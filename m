Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7205A3222FD
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhBWALo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhBWALk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D141964E5B;
        Tue, 23 Feb 2021 00:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039030;
        bh=/Pkuy380SrlxdfvjuoRSOwLB7Cysz4VucEz/yxTu7YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmN6RazMvPAYHTLPP5dH6qIXEE/4aSuMW7eIx52T8LLPhQFFxAkqhPJToSTxgeuzI
         pHSBEaqTKm9GGZTA1nf3siqgABzvcnBkPsUbCvwWBwNatEY8AX6VJVCaVhHLODWYNB
         rNMo7yZlLgq4DjIdbv0szkJYfU/BTTu7q5t16Jq9yLRi0pHoCIdFAHkciT0rzO2ia8
         0FrIyVnGfV0mKA03FsUfIvwokCD6O8uj4/I9rzDfmAU0zseSqLUMTzgtkJp+yFGx4p
         hNO8WPRKYSB3PXRW9RECxAsgo0LCIThyNuAjPm7Kmyulhk3hRBLtyc729SduHPK948
         IXvr+W6PbrFKA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 05/13] rcu/nocb: Merge nocb_timer to the rdp leader
Date:   Tue, 23 Feb 2021 01:10:03 +0100
Message-Id: <20210223001011.127063-6-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently each offline rdp has its own nocb_timer armed when the
nocb_gp wakeup must be deferred. This layout has many drawbacks,
compared to a solution based on a single timer per rdp group:

* It's a lot of timers to maintain.

* The per rdp nocb lock must be held to arm and cancel the timer and it's
  already quite contended.

* Firing one timer doesn't cancel the other rdp's timers in the same
  group:
  - They may conflict and end up with spurious wake ups
  - Each of the rdp that armed a timer need to lock both nocb_lock
    and then nocb_gp_lock upon exit to idle/user/guest mode.

* We can't cancel all of them if we detect an unflushed bypass in
  nocb_gp_wait(). In fact currently we only ever cancel the nocb_timer
  of the leader group.

* The leader group's nocb_timer is cancelled without locking nocb_lock
  in nocb_gp_wait(). It appears to be safe currently but is very error
  prone and hairy for reviewers.

* Since the timer takes the nocb_lock, it requires extra care in the NOCB
  (de-)offloading process, needing it to be either enabled or disabled
  and flushed.

Use a per rdp leader timer instead. It is based on nocb_gp_lock that is
_way_ less contended and stays so after this change. As a matter of fact,
the nocb_timer almost never fires and the deferred wakeup is mostly
handled on idle/user/guest entry. Now the early check performed at this
point in do_nocb_deferred_wakeup() is done on rdp_gp->nocb_defer_wakeup,
which is racy of course. It doesn't matter though because we only need
the guarantee to see the timer armed if we were the last one to arm it.
Any other situation (another rdp has armed it and we either see it or not)
is fine.

This solves all the issues listed above.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree.h        |   1 -
 kernel/rcu/tree_plugin.h | 142 +++++++++++++++++++++------------------
 2 files changed, 78 insertions(+), 65 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 71821d59d95c..b280a843bd2c 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -257,7 +257,6 @@ struct rcu_data {
 };
 
 /* Values for nocb_defer_wakeup field in struct rcu_data. */
-#define RCU_NOCB_WAKE_OFF	-1
 #define RCU_NOCB_WAKE_NOT	0
 #define RCU_NOCB_WAKE		1
 #define RCU_NOCB_WAKE_FORCE	2
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 587df271d640..847636d3e93d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -33,10 +33,6 @@ static inline bool rcu_current_is_nocb_kthread(struct rcu_data *rdp)
 	return false;
 }
 
-static inline bool rcu_running_nocb_timer(struct rcu_data *rdp)
-{
-	return (timer_curr_running(&rdp->nocb_timer) && !in_irq());
-}
 #else
 static inline int rcu_lockdep_is_held_nocb(struct rcu_data *rdp)
 {
@@ -48,11 +44,6 @@ static inline bool rcu_current_is_nocb_kthread(struct rcu_data *rdp)
 	return false;
 }
 
-static inline bool rcu_running_nocb_timer(struct rcu_data *rdp)
-{
-	return false;
-}
-
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
@@ -72,8 +63,7 @@ static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
 		  rcu_lockdep_is_held_nocb(rdp) ||
 		  (rdp == this_cpu_ptr(&rcu_data) &&
 		   !(IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible())) ||
-		  rcu_current_is_nocb_kthread(rdp) ||
-		  rcu_running_nocb_timer(rdp)),
+		  rcu_current_is_nocb_kthread(rdp)),
 		"Unsafe read of RCU_NOCB offloaded state"
 	);
 
@@ -1702,43 +1692,50 @@ bool rcu_is_nocb_cpu(int cpu)
 	return false;
 }
 
-/*
- * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
- * and this function releases it.
- */
-static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
-			 unsigned long flags)
-	__releases(rdp->nocb_lock)
+static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
+			   struct rcu_data *rdp,
+			   bool force, unsigned long flags)
+	__releases(rdp_gp->nocb_gp_lock)
 {
 	bool needwake = false;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
-	lockdep_assert_held(&rdp->nocb_lock);
 	if (!READ_ONCE(rdp_gp->nocb_gp_kthread)) {
-		rcu_nocb_unlock_irqrestore(rdp, flags);
+		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
 		return false;
 	}
 
-	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
-		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-		del_timer(&rdp->nocb_timer);
+	if (rdp_gp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp_gp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp_gp->nocb_timer);
 	}
-	rcu_nocb_unlock_irqrestore(rdp, flags);
-	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
 		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
 		needwake = true;
+	}
+	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
+	if (needwake) {
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DoWake"));
-	}
-	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
-	if (needwake)
 		wake_up_process(rdp_gp->nocb_gp_kthread);
+	}
 
 	return needwake;
 }
 
+/*
+ * Kick the GP kthread for this NOCB group.
+ */
+static bool wake_nocb_gp(struct rcu_data *rdp, bool force)
+{
+	unsigned long flags;
+	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
+
+	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+	return __wake_nocb_gp(rdp_gp, rdp, force, flags);
+}
+
 /*
  * Arrange to wake the GP kthread for this NOCB group at some future
  * time when it is safe to do so.
@@ -1746,12 +1743,18 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 static void wake_nocb_gp_defer(struct rcu_data *rdp, int waketype,
 			       const char *reason)
 {
-	if (rdp->nocb_defer_wakeup == RCU_NOCB_WAKE_OFF)
-		return;
-	if (rdp->nocb_defer_wakeup == RCU_NOCB_WAKE_NOT)
-		mod_timer(&rdp->nocb_timer, jiffies + 1);
-	if (rdp->nocb_defer_wakeup < waketype)
-		WRITE_ONCE(rdp->nocb_defer_wakeup, waketype);
+	unsigned long flags;
+	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
+
+	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+
+	if (rdp_gp->nocb_defer_wakeup == RCU_NOCB_WAKE_NOT)
+		mod_timer(&rdp_gp->nocb_timer, jiffies + 1);
+	if (rdp_gp->nocb_defer_wakeup < waketype)
+		WRITE_ONCE(rdp_gp->nocb_defer_wakeup, waketype);
+
+	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
+
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, reason);
 }
 
@@ -1978,13 +1981,14 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		rdp->qlen_last_fqs_check = len;
 		if (!irqs_disabled_flags(flags)) {
 			/* ... if queue was empty ... */
-			wake_nocb_gp(rdp, false, flags);
+			rcu_nocb_unlock_irqrestore(rdp, flags);
+			wake_nocb_gp(rdp, false);
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
+			rcu_nocb_unlock_irqrestore(rdp, flags);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE,
 					   TPS("WakeEmptyIsDeferred"));
-			rcu_nocb_unlock_irqrestore(rdp, flags);
 		}
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		/* ... or if many callbacks queued. */
@@ -1999,10 +2003,14 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		smp_mb(); /* Enqueue before timer_pending(). */
 		if ((rdp->nocb_cb_sleep ||
 		     !rcu_segcblist_ready_cbs(&rdp->cblist)) &&
-		    !timer_pending(&rdp->nocb_bypass_timer))
+		    !timer_pending(&rdp->nocb_bypass_timer)) {
+			rcu_nocb_unlock_irqrestore(rdp, flags);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_FORCE,
 					   TPS("WakeOvfIsDeferred"));
-		rcu_nocb_unlock_irqrestore(rdp, flags);
+		} else {
+			rcu_nocb_unlock_irqrestore(rdp, flags);
+			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
+		}
 	} else {
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
@@ -2128,11 +2136,7 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 			bypass = true;
 		}
 		rnp = rdp->mynode;
-		if (bypass) {  // Avoid race with first bypass CB.
-			WRITE_ONCE(my_rdp->nocb_defer_wakeup,
-				   RCU_NOCB_WAKE_NOT);
-			del_timer(&my_rdp->nocb_timer);
-		}
+
 		// Advance callbacks if helpful and low contention.
 		needwake_gp = false;
 		if (!rcu_segcblist_restempty(&rdp->cblist,
@@ -2178,11 +2182,18 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	my_rdp->nocb_gp_bypass = bypass;
 	my_rdp->nocb_gp_gp = needwait_gp;
 	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
-	if (bypass && !rcu_nocb_poll) {
-		// At least one child with non-empty ->nocb_bypass, so set
-		// timer in order to avoid stranding its callbacks.
+	if (bypass) {
 		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
-		mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
+		// Avoid race with first bypass CB.
+		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
+			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+			del_timer(&my_rdp->nocb_timer);
+		}
+		if (!rcu_nocb_poll) {
+			// At least one child with non-empty ->nocb_bypass, so set
+			// timer in order to avoid stranding its callbacks.
+			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
+		}
 		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
 	}
 	if (rcu_nocb_poll) {
@@ -2356,15 +2367,18 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 {
 	unsigned long flags;
 	int ndw;
+	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 	int ret;
 
-	rcu_nocb_lock_irqsave(rdp, flags);
-	if (!rcu_nocb_need_deferred_wakeup(rdp)) {
-		rcu_nocb_unlock_irqrestore(rdp, flags);
+	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+
+	if (!rcu_nocb_need_deferred_wakeup(rdp_gp)) {
+		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 		return false;
 	}
-	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
+
+	ndw = rdp_gp->nocb_defer_wakeup;
+	ret = __wake_nocb_gp(rdp_gp, rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 
 	return ret;
@@ -2385,7 +2399,10 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
  */
 static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
-	if (rcu_nocb_need_deferred_wakeup(rdp))
+	if (!rdp->nocb_gp_rdp)
+		return false;
+
+	if (rcu_nocb_need_deferred_wakeup(rdp->nocb_gp_rdp))
 		return do_nocb_deferred_wakeup_common(rdp);
 	return false;
 }
@@ -2454,17 +2471,15 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
 							SEGCBLIST_KTHREAD_GP));
-	rcu_nocb_lock_irqsave(rdp, flags);
-	/* Make sure nocb timer won't stay around */
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_OFF);
-	rcu_nocb_unlock_irqrestore(rdp, flags);
-	del_timer_sync(&rdp->nocb_timer);
-
 	/*
-	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY with CB unlocked
-	 * and IRQs disabled but let's be paranoid.
+	 * Lock one last time to acquire latest callback updates from kthreads
+	 * so we can later handle callbacks locally without locking.
 	 */
 	rcu_nocb_lock_irqsave(rdp, flags);
+	/*
+	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY after the nocb
+	 * lock is released but how about being paranoid for once?
+	 */
 	rcu_segcblist_set_flags(cblist, SEGCBLIST_SOFTIRQ_ONLY);
 	/*
 	 * With SEGCBLIST_SOFTIRQ_ONLY, we can't use
@@ -2528,8 +2543,7 @@ static long rcu_nocb_rdp_offload(void *arg)
 	 * SEGCBLIST_SOFTIRQ_ONLY mode.
 	 */
 	raw_spin_lock_irqsave(&rdp->nocb_lock, flags);
-	/* Re-enable nocb timer */
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+
 	/*
 	 * We didn't take the nocb lock while working on the
 	 * rdp->cblist in SEGCBLIST_SOFTIRQ_ONLY mode.
-- 
2.25.1

