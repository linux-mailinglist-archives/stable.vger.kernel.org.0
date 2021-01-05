Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA12EB61A
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 00:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhAEXZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 18:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbhAEXZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 18:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5DE22E00;
        Tue,  5 Jan 2021 23:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609889111;
        bh=5+RKh4S+UxqjnbESAF5kYqwsRzsNnd8xwrAFkQxEBEg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=U7QprrgWttH0ysnCpctFVLlNNUKiWGd3O30YGbzyJF+0UuWtOpvdbUtuxvllQ/Vnn
         2LPGvXmeSAD0DMWM9B2wSI1FNx875myW5aA1jaOStS0KCXUYT14fZCHZagHYWNxo1Y
         xekvDuXmAWIfsz7+eVakieeJbfwX+0hhXosGaO8uVCe3PZxTwOYO+vZ+GXVGj7fbZt
         KafjEpg+/BW7XjBClXn6vx0E/79tCNRtqmKU7+oEu3n0iBWaItOtaki5vmz9bPudx0
         C9Jvlvg78sFy3SpbU0EPUuSfJkjnNOGA3BYVhrno6GZyqqpX1Zj8NuMVMnVSnsie5O
         E1YjN4Mqk+2CQ==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id EF0B93522A62; Tue,  5 Jan 2021 15:25:10 -0800 (PST)
Date:   Tue, 5 Jan 2021 15:25:10 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] sched/idle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <20210105232510.GA16840@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210104152058.36642-1-frederic@kernel.org>
 <20210104152058.36642-2-frederic@kernel.org>
 <20210105095503.GF3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105095503.GF3040@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 10:55:03AM +0100, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 04:20:55PM +0100, Frederic Weisbecker wrote:
> > Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> > kthread (rcuog) to be serviced.
> > 
> > Usually a wake up happening while running the idle task is spotted in
> > one of the need_resched() checks carefully placed within the idle loop
> > that can break to the scheduler.
> 
> Urgh, this is horrific and fragile :/ You having had to audit and fix a
> number of rcu_idle_enter() callers should've made you realize that
> making rcu_idle_enter() return something would've been saner.
> 
> Also, I might hope that when RCU does do that wakeup, it will not have
> put RCU in idle mode? So it is a natural 'fail' state for
> rcu_idle_enter(), *sigh* it continues to put RCU to sleep, so that needs
> fixing too.

It depends on what is being awakened.  For example, the nocb rcuog
and rcuoc kthreads might be well on some other CPU, so RCU might need
the wakeup to happen, but might also need to go completely to sleep on
this CPU.

But yes, if the wakeup needs to be on the current CPU, then idle must
be exited and RCU needs to again be watching.  However, RCU has no idea
what CPU the to-be-awakened kthread will be running on.  And even if
it were to know at the time it does the wakeup, that kthread's location
might well have changed by the time the current CPU enters idle.

> I'm thinking that rcu_user_enter() will have the exact same problem? Did
> you audit that?
> 
> Something like the below, combined with a fixup for all callers (which
> the compiler will help us find thanks to __must_check).

Looks at least somewhat plausible at first glance.

Though given the above, it is possible (likely, even) that
rcu_user_enter() returns true, but that this CPU still needs to enter
idle.  So isn't a subsequent check of need_resched() or friends still
required?  Or is your point that this will happen automatically upon
exit from the idle loop?

							Thanx, Paul

> ---
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index de0826411311..612f66c16078 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -95,10 +95,10 @@ static inline void rcu_sysrq_end(void) { }
>  #endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
>  
>  #ifdef CONFIG_NO_HZ_FULL
> -void rcu_user_enter(void);
> +bool __must_check rcu_user_enter(void);
>  void rcu_user_exit(void);
>  #else
> -static inline void rcu_user_enter(void) { }
> +static inline bool __must_check rcu_user_enter(void) { return true; }
>  static inline void rcu_user_exit(void) { }
>  #endif /* CONFIG_NO_HZ_FULL */
>  
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index df578b73960f..9ba0c5d9e99e 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -43,7 +43,7 @@ bool rcu_gp_might_be_stalled(void);
>  unsigned long get_state_synchronize_rcu(void);
>  void cond_synchronize_rcu(unsigned long oldstate);
>  
> -void rcu_idle_enter(void);
> +bool __must_check rcu_idle_enter(void);
>  void rcu_idle_exit(void);
>  void rcu_irq_enter(void);
>  void rcu_irq_exit(void);
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 40e5e3dd253e..13e19e5db0b8 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -625,7 +625,7 @@ EXPORT_SYMBOL_GPL(rcutorture_get_gp_data);
>   * the possibility of usermode upcalls having messed up our count
>   * of interrupt nesting level during the prior busy period.
>   */
> -static noinstr void rcu_eqs_enter(bool user)
> +static noinstr bool rcu_eqs_enter(bool user)
>  {
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  
> @@ -636,7 +636,7 @@ static noinstr void rcu_eqs_enter(bool user)
>  	if (rdp->dynticks_nesting != 1) {
>  		// RCU will still be watching, so just do accounting and leave.
>  		rdp->dynticks_nesting--;
> -		return;
> +		return true;
>  	}
>  
>  	lockdep_assert_irqs_disabled();
> @@ -644,7 +644,14 @@ static noinstr void rcu_eqs_enter(bool user)
>  	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
>  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
>  	rdp = this_cpu_ptr(&rcu_data);
> -	do_nocb_deferred_wakeup(rdp);
> +	if (do_nocb_deferred_wakeup(rdp)) {
> +		/*
> +		 * We did the wakeup, don't enter EQS, we'll need to abort idle
> +		 * and schedule.
> +		 */
> +		return false;
> +	}
> +
>  	rcu_prepare_for_idle();
>  	rcu_preempt_deferred_qs(current);
>  
> @@ -657,6 +664,8 @@ static noinstr void rcu_eqs_enter(bool user)
>  	rcu_dynticks_eqs_enter();
>  	// ... but is no longer watching here.
>  	rcu_dynticks_task_enter();
> +
> +	return true;
>  }
>  
>  /**
> @@ -670,10 +679,10 @@ static noinstr void rcu_eqs_enter(bool user)
>   * If you add or remove a call to rcu_idle_enter(), be sure to test with
>   * CONFIG_RCU_EQS_DEBUG=y.
>   */
> -void rcu_idle_enter(void)
> +bool rcu_idle_enter(void)
>  {
>  	lockdep_assert_irqs_disabled();
> -	rcu_eqs_enter(false);
> +	return rcu_eqs_enter(false);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
>  
> @@ -689,10 +698,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
>   * If you add or remove a call to rcu_user_enter(), be sure to test with
>   * CONFIG_RCU_EQS_DEBUG=y.
>   */
> -noinstr void rcu_user_enter(void)
> +noinstr bool rcu_user_enter(void)
>  {
>  	lockdep_assert_irqs_disabled();
> -	rcu_eqs_enter(true);
> +	return rcu_eqs_enter(true);
>  }
>  #endif /* CONFIG_NO_HZ_FULL */
>  
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 7708ed161f4a..9226f4021a36 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -433,7 +433,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
>  static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_empty,
>  				 unsigned long flags);
>  static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
> -static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
> +static bool do_nocb_deferred_wakeup(struct rcu_data *rdp);
>  static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
>  static void rcu_spawn_cpu_nocb_kthread(int cpu);
>  static void __init rcu_spawn_nocb_kthreads(void);
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 7e291ce0a1d6..8ca41b3fe4f9 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1631,7 +1631,7 @@ bool rcu_is_nocb_cpu(int cpu)
>   * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
>   * and this function releases it.
>   */
> -static void wake_nocb_gp(struct rcu_data *rdp, bool force,
> +static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
>  			   unsigned long flags)
>  	__releases(rdp->nocb_lock)
>  {
> @@ -1654,8 +1654,11 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
>  		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DoWake"));
>  	}
>  	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
> -	if (needwake)
> +	if (needwake) {
>  		wake_up_process(rdp_gp->nocb_gp_kthread);
> +		return true;
> +	}
> +	return false;
>  }
>  
>  /*
> @@ -2155,17 +2158,19 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
>  static void do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
>  {
>  	unsigned long flags;
> +	bool ret;
>  	int ndw;
>  
>  	rcu_nocb_lock_irqsave(rdp, flags);
>  	if (!rcu_nocb_need_deferred_wakeup(rdp)) {
>  		rcu_nocb_unlock_irqrestore(rdp, flags);
> -		return;
> +		return false;
>  	}
>  	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
>  	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> -	wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
> +	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
>  	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
> +	return ret;
>  }
>  
>  /* Do a deferred wakeup of rcu_nocb_kthread() from a timer handler. */
> @@ -2181,10 +2186,12 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
>   * This means we do an inexact common-case check.  Note that if
>   * we miss, ->nocb_timer will eventually clean things up.
>   */
> -static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> +static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
>  {
>  	if (rcu_nocb_need_deferred_wakeup(rdp))
> -		do_nocb_deferred_wakeup_common(rdp);
> +		return do_nocb_deferred_wakeup_common(rdp);
> +
> +	return false;
>  }
>  
>  void __init rcu_init_nohz(void)
> @@ -2518,8 +2525,9 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
>  	return false;
>  }
>  
> -static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> +static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
>  {
> +	return false
>  }
>  
>  static void rcu_spawn_cpu_nocb_kthread(int cpu)
