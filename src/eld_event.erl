%%%-------------------------------------------------------------------
%%% @doc Event data type
%%%
%%% @end
%%%-------------------------------------------------------------------

-module(eld_event).

%% API
-export([new/4]).

%% Types
-type event() :: #{
    type      => event_type(),
    timestamp => non_neg_integer(),
    user      => eld_user:user(),
    data      => map()
}.

-type event_type() :: identify | index | feature_request | custom.
%% Event type

-export_type([event/0]).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Creates a new event of a given type
%%
%% Valid event type, user and timestamp are required. Additional data must be
%% empty for `identify' and `index' events. `feature_request' events must
%% contain valid feature fields in `Data'. `custom' events may contain any
%% `Data' fields.
%% @end
-spec new(
    Type :: event_type(),
    User :: eld_user:user(),
    Timestamp :: non_neg_integer(),
    Data :: map()
) -> event().
new(identify, User, Timestamp, #{}) ->
    #{
        type      => identify,
        timestamp => Timestamp,
        user      => User
    };
new(index, User, Timestamp, #{}) ->
    #{
        type      => index,
        timestamp => Timestamp,
        user      => User
    };
new(feature_request, User, Timestamp, #{
    key                    := Key,                  % eld_flag:key()
    variation              := Variation,            % undefined | eld_flag:variation()
    value                  := Value,                % undefined | eld_flag:variation_value()
    default                := Default,              % undefined | eld_flag:variation_value()
    version                := Version,              % undefined | eld_flag:version()
    prereq_of              := PrereqOf,             % undefined | eld_flag:key()
    track_events           := TrackEvents,          % undefined | boolean()
    debug_events_util_date := DebugEventsUntilDate, % undefined | boolean()
    eval_reason            := EvalReason,           % undefined | eld_eval:reason()
    debug                  := Debug                 % undefined | boolean()
}) ->
    #{
        type      => feature_request,
        timestamp => Timestamp,
        user      => User,
        data      => #{
            key                    => Key,
            variation              => Variation,
            value                  => Value,
            default                => Default,
            version                => Version,
            prereq_of              => PrereqOf,
            track_events           => TrackEvents,
            debug_events_util_date => DebugEventsUntilDate,
            eval_reason            => EvalReason,
            debug                  => Debug
        }
    };
new(custom, User, Timestamp, Data) when is_map(Data) ->
    #{
        type      => custom,
        timestamp => Timestamp,
        user      => User,
        data      => Data
    }.