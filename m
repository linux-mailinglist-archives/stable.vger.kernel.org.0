Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E613E1C37
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 21:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242454AbhHETMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 15:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242471AbhHETMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 15:12:33 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5402F61108;
        Thu,  5 Aug 2021 19:12:18 +0000 (UTC)
Date:   Thu, 5 Aug 2021 15:12:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix: tracepoint: rcu get state and cond sync for
 static call updates (v2)
Message-ID: <20210805151211.7b8458ae@oasis.local.home>
In-Reply-To: <20210805132717.23813-4-mathieu.desnoyers@efficios.com>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
        <20210805132717.23813-4-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  5 Aug 2021 09:27:17 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> State transitions from 1->0->1 and N->2->1 callbacks require RCU
> synchronization. Rather than performing the RCU synchronization every
> time the state change occurs, which is quite slow when many tracepoints
> are registered in batch, instead keep a snapshot of the RCU state on the
> most recent transitions which belong to a chain, and conditionally wait
> for a grace period on the last transition of the chain if one g.p. has
> not elapsed since the last snapshot.
> 
> This applies to both RCU and SRCU.
> 
> Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/
> Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")
> Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
> Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when adding a tracepoint")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Stefan Metzmacher <metze@samba.org>
> Cc: <stable@vger.kernel.org> # 5.10+
> ---
> Changes since v1:
> - Use tp_rcu_get_state/tp_rcu_cond_sync on 2->1 transition when
>   tp_funcs[0].data != old[0].data rather than
>   tracepoint_synchronize_unregister.
> ---
>  kernel/tracepoint.c | 81 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 69 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 8d772bd6894d..d8f69580001c 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -28,6 +28,44 @@ extern tracepoint_ptr_t __stop___tracepoints_ptrs[];
>  DEFINE_SRCU(tracepoint_srcu);
>  EXPORT_SYMBOL_GPL(tracepoint_srcu);
>  
> +enum tp_transition_sync {
> +	TP_TRANSITION_SYNC_1_0_1,
> +	TP_TRANSITION_SYNC_N_2_1,
> +
> +	_NR_TP_TRANSITION_SYNC,
> +};
> +
> +struct tp_transition_snapshot {
> +	unsigned long rcu;
> +	unsigned long srcu;
> +	bool ongoing;
> +};
> +
> +/* Protected by tracepoints_mutex */
> +static struct tp_transition_snapshot tp_transition_snapshot[_NR_TP_TRANSITION_SYNC];
> +
> +static void tp_rcu_get_state(enum tp_transition_sync sync)
> +{
> +	struct tp_transition_snapshot *snapshot = &tp_transition_snapshot[sync];
> +
> +	/* Keep the latest get_state snapshot. */
> +	snapshot->rcu = get_state_synchronize_rcu();
> +	snapshot->srcu = start_poll_synchronize_srcu(&tracepoint_srcu);
> +	snapshot->ongoing = true;
> +}
> +
> +static void tp_rcu_cond_sync(enum tp_transition_sync sync)
> +{
> +	struct tp_transition_snapshot *snapshot = &tp_transition_snapshot[sync];
> +
> +	if (!snapshot->ongoing)
> +		return;
> +	cond_synchronize_rcu(snapshot->rcu);
> +	if (!poll_state_synchronize_srcu(&tracepoint_srcu, snapshot->srcu))
> +		synchronize_srcu(&tracepoint_srcu);
> +	snapshot->ongoing = false;
> +}
> +
>  /* Set to 1 to enable tracepoint debug output */
>  static const int tracepoint_debug;
>  
> @@ -311,6 +349,11 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  	 */
>  	switch (nr_func_state(tp_funcs)) {
>  	case TP_FUNC_1:		/* 0->1 */
> +		/*
> +		 * Make sure new static func never uses old data after a
> +		 * 1->0->1 transition sequence.
> +		 */
> +		tp_rcu_cond_sync(TP_TRANSITION_SYNC_1_0_1);
>  		/* Set static call to first function */
>  		tracepoint_update_call(tp, tp_funcs);
>  		/* Both iterator and static call handle NULL tp->funcs */
> @@ -326,9 +369,21 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  		 * static call update/call.
>  		 */
>  		rcu_assign_pointer(tp->funcs, tp_funcs);
> +		/*
> +		 * Make sure static func never uses incorrect data after a
> +		 * 1->...->2->1 transition sequence.
> +		 */
> +		if (tp_funcs[0].data != old[0].data)
> +			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
>  		break;
>  	case TP_FUNC_N:		/* N->N+1 (N>1) */
>  		rcu_assign_pointer(tp->funcs, tp_funcs);
> +		/*
> +		 * Make sure static func never uses incorrect data after a
> +		 * N->...->2->1 (N>1) transition sequence.
> +		 */
> +		if (tp_funcs[0].data != old[0].data)
> +			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
>  		break;

Looks to me that the above can be replaced with:

	case TP_FUNC_2:		/* 1->2 */
		/* Set iterator static call */
		tracepoint_update_call(tp, tp_funcs);
		/*
		 * Iterator callback installed before updating tp->funcs.
		 * Requires ordering between RCU assign/dereference and
		 * static call update/call.
		 */
		fallthrough;
	case TP_FUNC_N:		/* N->N+1 (N>1) */
		rcu_assign_pointer(tp->funcs, tp_funcs);
		/*
		 * Make sure static func never uses incorrect data after a
		 * N->...->2->1 (N>1) transition sequence.
		 */
		if (tp_funcs[0].data != old[0].data)
			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
		break;

>  	default:
>  		WARN_ON_ONCE(1);
> @@ -372,24 +427,20 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  		/* Both iterator and static call handle NULL tp->funcs */
>  		rcu_assign_pointer(tp->funcs, NULL);
>  		/*
> -		 * Make sure new func never uses old data after a 1->0->1
> -		 * transition sequence.
> -		 * Considering that transition 0->1 is the common case
> -		 * and don't have rcu-sync, issue rcu-sync after
> -		 * transition 1->0 to break that sequence by waiting for
> -		 * readers to be quiescent.
> +		 * Make sure new static func never uses old data after a
> +		 * 1->0->1 transition sequence.
>  		 */
> -		tracepoint_synchronize_unregister();
> +		tp_rcu_get_state(TP_TRANSITION_SYNC_1_0_1);
>  		break;
>  	case TP_FUNC_1:		/* 2->1 */
>  		rcu_assign_pointer(tp->funcs, tp_funcs);
>  		/*
> -		 * On 2->1 transition, RCU sync is needed before setting
> -		 * static call to first callback, because the observer
> -		 * may have loaded any prior tp->funcs after the last one
> -		 * associated with an rcu-sync.
> +		 * Make sure static func never uses incorrect data after a
> +		 * N->...->2->1 (N>2) transition sequence.
>  		 */
> -		tracepoint_synchronize_unregister();

We should add a comment here with:

		/*
		 * If the first element's data has changed, then force the
		 * synchronization, to prevent current readers that have loaded
		 * the old data from calling the new function.
		 */

Can you send a v3 of just this patch? I'll pull in the other patches.

-- Steve

> +		if (tp_funcs[0].data != old[0].data)
> +			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
> +		tp_rcu_cond_sync(TP_TRANSITION_SYNC_N_2_1);
>  		/* Set static call to first function */
>  		tracepoint_update_call(tp, tp_funcs);
>  		break;
> @@ -397,6 +448,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  		fallthrough;
>  	case TP_FUNC_N:
>  		rcu_assign_pointer(tp->funcs, tp_funcs);
> +		/*
> +		 * Make sure static func never uses incorrect data after a
> +		 * N->...->2->1 (N>2) transition sequence.
> +		 */
> +		if (tp_funcs[0].data != old[0].data)
> +			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);

