Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB622EA810
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbhAEJ4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbhAEJz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 04:55:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F44C061574;
        Tue,  5 Jan 2021 01:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z8JIq8pYNr8a/sZWb+PSyi6nNI8yfstlWxNvM4VhLMc=; b=CZzNa5OpOjnwLU+NJzJrLypzhl
        7/F637nSvsE2bfX/o3NmtooZjEyZH/Qa2fC6AWWdzrC9AisgLk37zc1ZGgNbMPI0IRLZB04vhKUGC
        1XaqExaIWElflJaG0Xj/nNXH7hacgDuoezI+VZ1DiE60GROMCt1B45TFgmjt9Izfu99fF/47DO5Pm
        2V9eRq6g0pE0z6l10fsRS1StSkYebOo9QzwIq35JAqBt/4vjGUyUWJ/mV8FyLV3vkYGD8d/TrLoey
        D5wY7Opt6ush45E9DHPUYbkI97X38EpK5L3QxfzrLW8Xn7HbDgFGeCKO7HwxdinZ+E0xGGxjuRH04
        ahSjubMQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwj3S-0003jQ-GC; Tue, 05 Jan 2021 09:55:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D8147305815;
        Tue,  5 Jan 2021 10:55:03 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C548F20248724; Tue,  5 Jan 2021 10:55:03 +0100 (CET)
Date:   Tue, 5 Jan 2021 10:55:03 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] sched/idle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <20210105095503.GF3040@hirez.programming.kicks-ass.net>
References: <20210104152058.36642-1-frederic@kernel.org>
 <20210104152058.36642-2-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104152058.36642-2-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:20:55PM +0100, Frederic Weisbecker wrote:
> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> kthread (rcuog) to be serviced.
> 
> Usually a wake up happening while running the idle task is spotted in
> one of the need_resched() checks carefully placed within the idle loop
> that can break to the scheduler.

Urgh, this is horrific and fragile :/ You having had to audit and fix a
number of rcu_idle_enter() callers should've made you realize that
making rcu_idle_enter() return something would've been saner.

Also, I might hope that when RCU does do that wakeup, it will not have
put RCU in idle mode? So it is a natural 'fail' state for
rcu_idle_enter(), *sigh* it continues to put RCU to sleep, so that needs
fixing too.

I'm thinking that rcu_user_enter() will have the exact same problem? Did
you audit that?

Something like the below, combined with a fixup for all callers (which
the compiler will help us find thanks to __must_check).

---

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index de0826411311..612f66c16078 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -95,10 +95,10 @@ static inline void rcu_sysrq_end(void) { }
 #endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
-void rcu_user_enter(void);
+bool __must_check rcu_user_enter(void);
 void rcu_user_exit(void);
 #else
-static inline void rcu_user_enter(void) { }
+static inline bool __must_check rcu_user_enter(void) { return true; }
 static inline void rcu_user_exit(void) { }
 #endif /* CONFIG_NO_HZ_FULL */
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index df578b73960f..9ba0c5d9e99e 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -43,7 +43,7 @@ bool rcu_gp_might_be_stalled(void);
 unsigned long get_state_synchronize_rcu(void);
 void cond_synchronize_rcu(unsigned long oldstate);
 
-void rcu_idle_enter(void);
+bool __must_check rcu_idle_enter(void);
 void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 40e5e3dd253e..13e19e5db0b8 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -625,7 +625,7 @@ EXPORT_SYMBOL_GPL(rcutorture_get_gp_data);
  * the possibility of usermode upcalls having messed up our count
  * of interrupt nesting level during the prior busy period.
  */
-static noinstr void rcu_eqs_enter(bool user)
+static noinstr bool rcu_eqs_enter(bool user)
 {
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 
@@ -636,7 +636,7 @@ static noinstr void rcu_eqs_enter(bool user)
 	if (rdp->dynticks_nesting != 1) {
 		// RCU will still be watching, so just do accounting and leave.
 		rdp->dynticks_nesting--;
-		return;
+		return true;
 	}
 
 	lockdep_assert_irqs_disabled();
@@ -644,7 +644,14 @@ static noinstr void rcu_eqs_enter(bool user)
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
-	do_nocb_deferred_wakeup(rdp);
+	if (do_nocb_deferred_wakeup(rdp)) {
+		/*
+		 * We did the wakeup, don't enter EQS, we'll need to abort idle
+		 * and schedule.
+		 */
+		return false;
+	}
+
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -657,6 +664,8 @@ static noinstr void rcu_eqs_enter(bool user)
 	rcu_dynticks_eqs_enter();
 	// ... but is no longer watching here.
 	rcu_dynticks_task_enter();
+
+	return true;
 }
 
 /**
@@ -670,10 +679,10 @@ static noinstr void rcu_eqs_enter(bool user)
  * If you add or remove a call to rcu_idle_enter(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_idle_enter(void)
+bool rcu_idle_enter(void)
 {
 	lockdep_assert_irqs_disabled();
-	rcu_eqs_enter(false);
+	return rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
@@ -689,10 +698,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  * If you add or remove a call to rcu_user_enter(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-noinstr void rcu_user_enter(void)
+noinstr bool rcu_user_enter(void)
 {
 	lockdep_assert_irqs_disabled();
-	rcu_eqs_enter(true);
+	return rcu_eqs_enter(true);
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 7708ed161f4a..9226f4021a36 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -433,7 +433,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_empty,
 				 unsigned long flags);
 static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_cpu_nocb_kthread(int cpu);
 static void __init rcu_spawn_nocb_kthreads(void);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7e291ce0a1d6..8ca41b3fe4f9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1631,7 +1631,7 @@ bool rcu_is_nocb_cpu(int cpu)
  * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
  * and this function releases it.
  */
-static void wake_nocb_gp(struct rcu_data *rdp, bool force,
+static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 			   unsigned long flags)
 	__releases(rdp->nocb_lock)
 {
@@ -1654,8 +1654,11 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DoWake"));
 	}
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
-	if (needwake)
+	if (needwake) {
 		wake_up_process(rdp_gp->nocb_gp_kthread);
+		return true;
+	}
+	return false;
 }
 
 /*
@@ -2155,17 +2158,19 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 static void do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 {
 	unsigned long flags;
+	bool ret;
 	int ndw;
 
 	rcu_nocb_lock_irqsave(rdp, flags);
 	if (!rcu_nocb_need_deferred_wakeup(rdp)) {
 		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return;
+		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
 	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-	wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
+	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
+	return ret;
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread() from a timer handler. */
@@ -2181,10 +2186,12 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
  * This means we do an inexact common-case check.  Note that if
  * we miss, ->nocb_timer will eventually clean things up.
  */
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 	if (rcu_nocb_need_deferred_wakeup(rdp))
-		do_nocb_deferred_wakeup_common(rdp);
+		return do_nocb_deferred_wakeup_common(rdp);
+
+	return false;
 }
 
 void __init rcu_init_nohz(void)
@@ -2518,8 +2525,9 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 	return false;
 }
 
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	return false
 }
 
 static void rcu_spawn_cpu_nocb_kthread(int cpu)
