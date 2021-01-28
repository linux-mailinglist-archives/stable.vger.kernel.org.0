Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D62308095
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 22:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhA1VcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 16:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhA1VcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 16:32:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88EDC64DE8;
        Thu, 28 Jan 2021 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611869493;
        bh=fDjhDAWt5ij6gL+wIv5TeN7rHAh3DIQyGwY7v2u98DA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=gXaE35JO1iOFi9m5omIomUpaieFWQQrA+16NjSz6P1H9UVnUZcywA0rtH50qhQscn
         K/yo6RKfizmZOch9Va3yx8ZeebqVK0iBNXkH2vV7rSuhRw8+HzCdyRWiSLKfCR01sP
         UUsQvVcBoxIs72oGkfRriiQJKS4Vy+vTVWOV5CEI+ixGIPxZX8fMzNsXGcq5Wx/Vgp
         erk7SjqbSv9TDzdCbzRnW8UFox4x8ut0ktou2JVzNTypfLo0EalTKI+lQO2ZwxUmh9
         ILzxtRfj69My5jvFRxdGb5wx1yb2fKr1t1JJmZxUftvUM+48Va0CvSQO2aC6G4I5jj
         ZO/q/zgcYL6Lg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 2B1B535237A0; Thu, 28 Jan 2021 13:31:33 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:31:33 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 05/16] rcu/nocb: Disable bypass when CPU isn't completely
 offloaded
Message-ID: <20210128213133.GT2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-6-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128171222.131380-6-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 06:12:11PM +0100, Frederic Weisbecker wrote:
> Instead of flushing bypass at the very last moment in the deoffloading
> process, just disable bypass enqueue at soon as we start the deoffloading
> process and flush the pending bypass early. It's less fragile and we
> leave some time to the kthreads and softirqs to process quietly.
> 
> Symmetrically, only enable bypass once we safely complete the offloading
> process.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Looks plausible, thank you!  Some questions and comments below.

> ---
>  include/linux/rcu_segcblist.h |  7 ++++---
>  kernel/rcu/tree_plugin.h      | 31 +++++++++++++++++++++++--------
>  2 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/rcu_segcblist.h b/include/linux/rcu_segcblist.h
> index 8afe886e85f1..5a2d6dadd720 100644
> --- a/include/linux/rcu_segcblist.h
> +++ b/include/linux/rcu_segcblist.h
> @@ -109,7 +109,7 @@ struct rcu_cblist {
>   *  |                           SEGCBLIST_KTHREAD_GP                           |
>   *  |                                                                          |
>   *  |   Kthreads handle callbacks holding nocb_lock, local rcu_core() stops    |
> - *  |   handling callbacks.                                                    |
> + *  |   handling callbacks. Allow bypass enqueue.                              |

"Allow bypass enqueue" as in bypass was disabled and entering this
state causes it to be enabled, correct?  If so, "Enable bypass
queueing" would be less ambiguous and would match the change below.

>   *  ----------------------------------------------------------------------------
>   */
>  
> @@ -125,7 +125,7 @@ struct rcu_cblist {
>   *  |                           SEGCBLIST_KTHREAD_GP                           |
>   *  |                                                                          |
>   *  |   CB/GP kthreads handle callbacks holding nocb_lock, local rcu_core()    |
> - *  |   ignores callbacks.                                                     |
> + *  |   ignores callbacks. Bypass enqueue is enabled.                          |
>   *  ----------------------------------------------------------------------------
>   *                                      |
>   *                                      v
> @@ -134,7 +134,8 @@ struct rcu_cblist {
>   *  |                           SEGCBLIST_KTHREAD_GP                           |
>   *  |                                                                          |
>   *  |   CB/GP kthreads and local rcu_core() handle callbacks concurrently      |
> - *  |   holding nocb_lock. Wake up CB and GP kthreads if necessary.            |
> + *  |   holding nocb_lock. Wake up CB and GP kthreads if necessary. Disable    |
> + *  |   bypass enqueue.                                                        |
>   *  ----------------------------------------------------------------------------
>   *                                      |
>   *                                      v
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 732942a15f2b..7781830a3cf1 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1825,11 +1825,22 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
>  	unsigned long j = jiffies;
>  	long ncbs = rcu_cblist_n_cbs(&rdp->nocb_bypass);
>  
> +	lockdep_assert_irqs_disabled();
> +
> +	// Pure softirq/rcuc based processing: no bypassing, no
> +	// locking.
>  	if (!rcu_rdp_is_offloaded(rdp)) {
> +		*was_alldone = !rcu_segcblist_pend_cbs(&rdp->cblist);
> +		return false;
> +	}
> +
> +	// In the process of (de-)offloading: no bypassing, but
> +	// locking.
> +	if (!rcu_segcblist_completely_offloaded(&rdp->cblist)) {
> +		rcu_nocb_lock(rdp);
>  		*was_alldone = !rcu_segcblist_pend_cbs(&rdp->cblist);
>  		return false; /* Not offloaded, no bypassing. */
>  	}
> -	lockdep_assert_irqs_disabled();
>  
>  	// Don't use ->nocb_bypass during early boot.
>  	if (rcu_scheduler_active != RCU_SCHEDULER_RUNNING) {
> @@ -2412,6 +2423,7 @@ static long rcu_nocb_rdp_deoffload(void *arg)
>  
>  	rcu_nocb_lock_irqsave(rdp, flags);
>  
> +	WARN_ON_ONCE(!rcu_nocb_flush_bypass(rdp, NULL, jiffies));

This flush suffices because we are running on the target CPU
holding ->nocb_lock (thus having interrupts disabled), and
because rdp_offload_toggle() invokes rcu_segcblist_offload(),
which clears SEGCBLIST_OFFLOADED.  Thus future calls to
rcu_segcblist_completely_offloaded() will return false,
which means that future calls to rcu_nocb_try_bypass() will
refuse to put anything into the bypass.

I believe that this deserves a comment, particularly if I am
confused about what is really happening here.  ;-)

On another topic, since I saw it along the way...

The header comment for rcu_segcblist_offload() says that the
structure must be empty, but that isn't really the case, is it?

>  	ret = rdp_offload_toggle(rdp, false, flags);
>  	swait_event_exclusive(rdp->nocb_state_wq,
>  			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
> @@ -2422,19 +2434,22 @@ static long rcu_nocb_rdp_deoffload(void *arg)
>  	rcu_nocb_unlock_irqrestore(rdp, flags);
>  	del_timer_sync(&rdp->nocb_timer);
>  
> +	/* Sanity check */
> +	WARN_ON_ONCE(rcu_cblist_n_cbs(&rdp->nocb_bypass));
> +
>  	/*
> -	 * Flush bypass. While IRQs are disabled and once we set
> -	 * SEGCBLIST_SOFTIRQ_ONLY, no callback is supposed to be
> -	 * enqueued on bypass.
> +	 * Lock one last time so we see latest updates from kthreads and timer

You lost me here.  What updates are we seeing from kthreads and timers?

> +	 * so that we can later run callbacks locally without the lock.
>  	 */
>  	rcu_nocb_lock_irqsave(rdp, flags);
> -	rcu_nocb_flush_bypass(rdp, NULL, jiffies);
> +	/*
> +	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY after the nocb
> +	 * LOCK/UNLOCK but let's be paranoid.
> +	 */
>  	rcu_segcblist_set_flags(cblist, SEGCBLIST_SOFTIRQ_ONLY);

As long as we are being paranoid, should we also check that the
bypass remains empty?

>  	/*
>  	 * With SEGCBLIST_SOFTIRQ_ONLY, we can't use
> -	 * rcu_nocb_unlock_irqrestore() anymore. Theoretically we
> -	 * could set SEGCBLIST_SOFTIRQ_ONLY with cb unlocked and IRQs
> -	 * disabled now, but let's be paranoid.
> +	 * rcu_nocb_unlock_irqrestore() anymore.
>  	 */
>  	raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
>  
> -- 
> 2.25.1
> 
