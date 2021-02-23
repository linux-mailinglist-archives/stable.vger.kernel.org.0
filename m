Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36C1322305
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBWAMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhBWALv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55ECE64EC1;
        Tue, 23 Feb 2021 00:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039050;
        bh=lSs2SjBHiHAEFRCFThiXQ4SdNqq4gkZh2PN7m3em8kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AczR6r6/0z+zVVn3Ud0cJ0x4ynb+9azGPDzu9486S2mERkZxa52DZzN5zZUxfnzKh
         zw4SUAwG5ygW/G8oJivdLvLfCEECW1r+t2FeROR8fhqBUapQiLEItQQt5pB3Fg3axt
         S9aQK7TcKKoZ41fJwHWez+Y1NbEt4Ipk13S2YZE1hvarRMRkm1y0xkjTw9owuwVp5f
         id834fZoYOpYoW2LwtEfkfTx63aWEcWneDZDLGqUu90E4CQ8j1TWjQv/VJVPxzSdPA
         U51t/Zlv0XxYv7PDvxWWBRM+ZS1tIL7aBT/Jd1ksr1ATO1/PnRtrEtcvaLtSrJ2QCq
         LUBV9rt8/OKkQ==
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
Subject: [PATCH 13/13] rcu/nocb: Unify timers
Date:   Tue, 23 Feb 2021 01:10:11 +0100
Message-Id: <20210223001011.127063-14-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that nocb_timer and nocb_bypass_timer have become very similar,
merge them together. A new RCU_NOCB_WAKE_BYPASS wake level is introduced.
As a result, timers perform all kinds of deferred wake ups but other
deferred wakeup callsites only handle non-bypass wakeups in order not
to wake up rcuo too early.

The timer also performs the full barrier all the time to order
timer_pending() and callback enqueue although the path performing
RCU_NOCB_WAKE_FORCE that makes use of it is debatable. It should also
test against the rdp leader instead of the current rdp.

The permanent full barrier shouldn't bring visible overhead since the
timers almost never fire.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 include/trace/events/rcu.h |  1 +
 kernel/rcu/tree.h          |  6 +--
 kernel/rcu/tree_plugin.h   | 92 ++++++++++++++++----------------------
 3 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 5fc29400e1a2..c16cb7d78f51 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -278,6 +278,7 @@ TRACE_EVENT_RCU(rcu_exp_funnel_lock,
  * "WakeNot": Don't wake rcuo kthread.
  * "WakeNotPoll": Don't wake rcuo kthread because it is polling.
  * "WakeOvfIsDeferred": Wake rcuo kthread later, CB list is huge.
+ * "WakeBypassIsDeferred": Wake rcuo kthread later, bypass list is contended.
  * "WokeEmpty": rcuo CB kthread woke to find empty list.
  */
 TRACE_EVENT_RCU(rcu_nocb_wake,
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 2510e86265c1..9a16487edfca 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -218,7 +218,6 @@ struct rcu_data {
 
 	/* The following fields are used by GP kthread, hence own cacheline. */
 	raw_spinlock_t nocb_gp_lock ____cacheline_internodealigned_in_smp;
-	struct timer_list nocb_bypass_timer; /* Force nocb_bypass flush. */
 	u8 nocb_gp_sleep;		/* Is the nocb GP thread asleep? */
 	u8 nocb_gp_bypass;		/* Found a bypass on last scan? */
 	u8 nocb_gp_gp;			/* GP to wait for on last scan? */
@@ -258,8 +257,9 @@ struct rcu_data {
 
 /* Values for nocb_defer_wakeup field in struct rcu_data. */
 #define RCU_NOCB_WAKE_NOT	0
-#define RCU_NOCB_WAKE		1
-#define RCU_NOCB_WAKE_FORCE	2
+#define RCU_NOCB_WAKE_BYPASS	1
+#define RCU_NOCB_WAKE		2
+#define RCU_NOCB_WAKE_FORCE	3
 
 #define RCU_JIFFIES_TILL_FORCE_QS (1 + (HZ > 250) + (HZ > 500))
 					/* For jiffies_till_first_fqs and */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index e0420e3b30e6..6bf35a1fe68e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1711,8 +1711,6 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
 		del_timer(&rdp_gp->nocb_timer);
 	}
 
-	del_timer(&rdp_gp->nocb_bypass_timer);
-
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
 		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
 		needwake = true;
@@ -1750,10 +1748,19 @@ static void wake_nocb_gp_defer(struct rcu_data *rdp, int waketype,
 
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 
-	if (rdp_gp->nocb_defer_wakeup == RCU_NOCB_WAKE_NOT)
-		mod_timer(&rdp_gp->nocb_timer, jiffies + 1);
-	if (rdp_gp->nocb_defer_wakeup < waketype)
+	/*
+	 * Bypass wakeup overrides previous deferments. In case
+	 * of callback storm, no need to wake up too early.
+	 */
+	if (waketype == RCU_NOCB_WAKE_BYPASS) {
+		mod_timer(&rdp_gp->nocb_timer, jiffies + 2);
 		WRITE_ONCE(rdp_gp->nocb_defer_wakeup, waketype);
+	} else {
+		if (rdp_gp->nocb_defer_wakeup < RCU_NOCB_WAKE)
+			mod_timer(&rdp_gp->nocb_timer, jiffies + 1);
+		if (rdp_gp->nocb_defer_wakeup < waketype)
+			WRITE_ONCE(rdp_gp->nocb_defer_wakeup, waketype);
+	}
 
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 
@@ -2005,7 +2012,7 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		smp_mb(); /* Enqueue before timer_pending(). */
 		if ((rdp->nocb_cb_sleep ||
 		     !rcu_segcblist_ready_cbs(&rdp->cblist)) &&
-		    !timer_pending(&rdp->nocb_bypass_timer)) {
+		    !timer_pending(&rdp->nocb_timer)) {
 			rcu_nocb_unlock_irqrestore(rdp, flags);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_FORCE,
 					   TPS("WakeOvfIsDeferred"));
@@ -2020,19 +2027,6 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 	return;
 }
 
-/* Wake up the no-CBs GP kthread to flush ->nocb_bypass. */
-static void do_nocb_bypass_wakeup_timer(struct timer_list *t)
-{
-	unsigned long flags;
-	struct rcu_data *rdp = from_timer(rdp, t, nocb_bypass_timer);
-
-	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("Timer"));
-
-	raw_spin_lock_irqsave(&rdp->nocb_gp_lock, flags);
-	smp_mb__after_spinlock(); /* Timer expire before wakeup. */
-	__wake_nocb_gp(rdp, rdp, false, flags);
-}
-
 /*
  * Check if we ignore this rdp.
  *
@@ -2185,19 +2179,12 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	my_rdp->nocb_gp_bypass = bypass;
 	my_rdp->nocb_gp_gp = needwait_gp;
 	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
-	if (bypass) {
-		if (!rcu_nocb_poll) {
-			raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
-			// Avoid race with first bypass CB.
-			if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
-				WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-				del_timer(&my_rdp->nocb_timer);
-			}
-			// At least one child with non-empty ->nocb_bypass, so set
-			// timer in order to avoid stranding its callbacks.
-			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
-			raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
-		}
+
+	if (bypass && !rcu_nocb_poll) {
+		// At least one child with non-empty ->nocb_bypass, so set
+		// timer in order to avoid stranding its callbacks.
+		wake_nocb_gp_defer(my_rdp, RCU_NOCB_WAKE_BYPASS,
+				   TPS("WakeBypassIsDeferred"));
 	}
 	if (rcu_nocb_poll) {
 		/* Polling, so trace if first poll in the series. */
@@ -2221,8 +2208,6 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	}
 	if (!rcu_nocb_poll) {
 		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
-		if (bypass)
-			del_timer(&my_rdp->nocb_bypass_timer);
 		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
 			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 			del_timer(&my_rdp->nocb_timer);
@@ -2370,16 +2355,14 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp, int level)
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
-static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp,
-					   int level)
+static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp_gp,
+					   struct rcu_data *rdp, int level,
+					   unsigned long flags)
+	__releases(rdp_gp->nocb_gp_lock)
 {
-	unsigned long flags;
 	int ndw;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 	int ret;
 
-	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
-
 	if (!rcu_nocb_need_deferred_wakeup(rdp_gp, level)) {
 		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 		return false;
@@ -2395,9 +2378,15 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp,
 /* Do a deferred wakeup of rcu_nocb_kthread() from a timer handler. */
 static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
 {
+	unsigned long flags;
 	struct rcu_data *rdp = from_timer(rdp, t, nocb_timer);
 
-	do_nocb_deferred_wakeup_common(rdp, RCU_NOCB_WAKE);
+	WARN_ON_ONCE(rdp->nocb_gp_rdp != rdp);
+	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("Timer"));
+
+	raw_spin_lock_irqsave(&rdp->nocb_gp_lock, flags);
+	smp_mb__after_spinlock(); /* Timer expire before wakeup. */
+	do_nocb_deferred_wakeup_common(rdp, rdp, RCU_NOCB_WAKE_BYPASS, flags);
 }
 
 /*
@@ -2407,12 +2396,14 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
  */
 static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
-	if (!rdp->nocb_gp_rdp)
+	unsigned long flags;
+	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
+
+	if (!rdp_gp || !rcu_nocb_need_deferred_wakeup(rdp_gp, RCU_NOCB_WAKE))
 		return false;
 
-	if (rcu_nocb_need_deferred_wakeup(rdp->nocb_gp_rdp, RCU_NOCB_WAKE))
-		return do_nocb_deferred_wakeup_common(rdp, RCU_NOCB_WAKE);
-	return false;
+	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+	return do_nocb_deferred_wakeup_common(rdp_gp, rdp, RCU_NOCB_WAKE, flags);
 }
 
 void rcu_nocb_flush_deferred_wakeup(void)
@@ -2655,7 +2646,6 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 	raw_spin_lock_init(&rdp->nocb_bypass_lock);
 	raw_spin_lock_init(&rdp->nocb_gp_lock);
 	timer_setup(&rdp->nocb_timer, do_nocb_deferred_wakeup_timer, 0);
-	timer_setup(&rdp->nocb_bypass_timer, do_nocb_bypass_wakeup_timer, 0);
 	rcu_cblist_init(&rdp->nocb_bypass);
 }
 
@@ -2814,13 +2804,12 @@ static void show_rcu_nocb_gp_state(struct rcu_data *rdp)
 {
 	struct rcu_node *rnp = rdp->mynode;
 
-	pr_info("nocb GP %d %c%c%c%c%c%c %c[%c%c] %c%c:%ld rnp %d:%d %lu %c CPU %d%s\n",
+	pr_info("nocb GP %d %c%c%c%c%c %c[%c%c] %c%c:%ld rnp %d:%d %lu %c CPU %d%s\n",
 		rdp->cpu,
 		"kK"[!!rdp->nocb_gp_kthread],
 		"lL"[raw_spin_is_locked(&rdp->nocb_gp_lock)],
 		"dD"[!!rdp->nocb_defer_wakeup],
 		"tT"[timer_pending(&rdp->nocb_timer)],
-		"bB"[timer_pending(&rdp->nocb_bypass_timer)],
 		"sS"[!!rdp->nocb_gp_sleep],
 		".W"[swait_active(&rdp->nocb_gp_wq)],
 		".W"[swait_active(&rnp->nocb_gp_wq[0])],
@@ -2841,7 +2830,6 @@ static void show_rcu_nocb_state(struct rcu_data *rdp)
 	char bufr[20];
 	struct rcu_segcblist *rsclp = &rdp->cblist;
 	bool waslocked;
-	bool wastimer;
 	bool wassleep;
 
 	if (rdp->nocb_gp_rdp == rdp)
@@ -2878,15 +2866,13 @@ static void show_rcu_nocb_state(struct rcu_data *rdp)
 		return;
 
 	waslocked = raw_spin_is_locked(&rdp->nocb_gp_lock);
-	wastimer = timer_pending(&rdp->nocb_bypass_timer);
 	wassleep = swait_active(&rdp->nocb_gp_wq);
-	if (!rdp->nocb_gp_sleep && !waslocked && !wastimer && !wassleep)
+	if (!rdp->nocb_gp_sleep && !waslocked && !wassleep)
 		return;  /* Nothing untowards. */
 
-	pr_info("   nocb GP activity on CB-only CPU!!! %c%c%c%c %c\n",
+	pr_info("   nocb GP activity on CB-only CPU!!! %c%c%c %c\n",
 		"lL"[waslocked],
 		"dD"[!!rdp->nocb_defer_wakeup],
-		"tT"[wastimer],
 		"sS"[!!rdp->nocb_gp_sleep],
 		".W"[wassleep]);
 }
-- 
2.25.1

