(******************************************************************************)
(*  _  __ * The Kappa Language                                                *)
(* | |/ / * Copyright 2010-2017 CNRS - Harvard Medical School - INRIA - IRIF  *)
(* | ' /  *********************************************************************)
(* | . \  * This file is distributed under the terms of the                   *)
(* |_|\_\ * GNU Lesser General Public License Version 3                       *)
(******************************************************************************)

open Lwt.Infix

let continue_simulation () =
  Common.async
    (fun () ->
       State_error.wrap
         __LOC__
         (State_simulation.with_simulation
            ~label:__LOC__
            (fun _ _ t ->
               let simulation_id = State_simulation.t_simulation_id t in
               let simulation_parameter = State_parameter.create_parameter simulation_id  in
               State_simulation.continue_simulation simulation_parameter))
       >>= (fun _ -> Lwt.return_unit)
    )

let pause_simulation () =
  Common.async
    (fun () ->
       State_error.wrap
         __LOC__
         (State_simulation.with_simulation
            ~label:__LOC__
            (fun _ _ _ ->
               State_simulation.pause_simulation ()))
       >>= (fun _ -> Lwt.return_unit)
    )

let stop_simulation () =
  Common.async
    (fun () ->
       let () = Common.debug (Js.string "subpanel_editor_controller.stop") in
       State_error.wrap
         __LOC__
         (State_simulation.with_simulation
            ~label:__LOC__
            (fun _ _ _ ->
               State_simulation.stop_simulation ())) >>=
       (Api_common.result_bind_lwt
          ~ok:(fun _ ->
              let () = State_error.clear_errors () in
              Lwt.return (Api_common.result_ok ())))
       >>= (fun _ -> Lwt.return_unit)
    )

let start_simulation () =
  Common.async
    (fun () ->
       State_error.wrap
         __LOC__
         (State_simulation.with_simulation
            ~label:__LOC__
            (fun _ _ t ->
               let simulation_id = State_simulation.t_simulation_id t in
               let simulation_parameter = State_parameter.create_parameter simulation_id  in
               State_simulation.start_simulation simulation_parameter))
       >>= (fun _ -> Lwt.return_unit)
    )

let perturb_simulation () =
    Common.async
    (fun () ->
       State_error.wrap
         __LOC__
         (State_simulation.with_simulation
            ~label:__LOC__
            (fun _ _ _ ->
               let model_perturbation = React.S.value State_perturbation.model_perturbation in
               State_simulation.perturb_simulation model_perturbation))
       >>= (fun _ -> Lwt.return_unit)
    )