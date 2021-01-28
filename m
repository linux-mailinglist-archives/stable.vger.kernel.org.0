Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464AE307C9F
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhA1Rea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhA1RPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87BFA64E1E;
        Thu, 28 Jan 2021 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853970;
        bh=wzrs3LSX0yCovBDn06pscNKF6ENgDizxuYvW28xZ/W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7b8tQ40LVhK5zL4U4V4OsyMg7MQTPp6YtSjIy1FgC3Bakz9GNtmT+mkWUc5U9RCq
         0vamqaudgLLhXCR4W4qBE4AEYy9BKSkfEHrV98p5+HUzHAEt+Xb24inRVzFfYWe8hY
         z52ui+dGQaOg4er/UqEzp8qsdHtvl1bigQ2KUJdkTdMxg2TrMUprr5bJeFSsg4sE6v
         SZ8iAYc6+FQKZx+0m/ahE+LcMr3Au8rWBYE3+tcpjHNNx/Wh3KT+kL6p7Rk534Re0E
         beSyGvmjCZ8612O0TdsXtgmOYr0qF6/Fb/5shQSgMzA5vdBLZNKU+uKD/Ou9fbv2+9
         A3gbylVSKV9ug==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 09/16] rcu/nocb: Merge nocb_timer to the rdp leader
Date:   Thu, 28 Jan 2021 18:12:15 +0100
Message-Id: <20210128171222.131380-10-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
 kernel/rcu/tree_plugin.h | 119 ++++++++++++++++++++++-----------------
 2 files changed, 68 insertions(+), 52 deletions(-)

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
index 8c5fea58ee80..5e83ea380bec 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1687,41 +1687,48 @@ bool rcu_is_nocb_cpu(int cpu)
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
 
-	rdp->nocb_defer_wakeup = RCU_NOCB_WAKE_NOT;
-	del_timer(&rdp->nocb_timer);
-	rcu_nocb_unlock_irqrestore(rdp, flags);
-	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
+	rdp_gp->nocb_defer_wakeup = RCU_NOCB_WAKE_NOT;
+	del_timer(&rdp_gp->nocb_timer);
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
@@ -1729,12 +1736,18 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
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
 
@@ -1961,13 +1974,14 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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
@@ -1982,10 +1996,14 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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
@@ -2111,11 +2129,7 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
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
@@ -2161,11 +2175,16 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
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
+		WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&my_rdp->nocb_timer);
+		if (!rcu_nocb_poll) {
+			// At least one child with non-empty ->nocb_bypass, so set
+			// timer in order to avoid stranding its callbacks.
+			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
+		}
 		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
 	}
 	if (rcu_nocb_poll) {
@@ -2339,16 +2358,17 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
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
+		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);;
 		return false;
 	}
-	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
+	ndw = READ_ONCE(rdp_gp->nocb_defer_wakeup);
+	ret = __wake_nocb_gp(rdp_gp, rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 
 	return ret;
@@ -2369,7 +2389,10 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
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
@@ -2430,18 +2453,12 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
 							SEGCBLIST_KTHREAD_GP));
-	rcu_nocb_lock_irqsave(rdp, flags);
-	/* Make sure nocb timer won't stay around */
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_OFF);
-	rcu_nocb_unlock_irqrestore(rdp, flags);
-	del_timer_sync(&rdp->nocb_timer);
-
 	/* Sanity check */
 	WARN_ON_ONCE(rcu_cblist_n_cbs(&rdp->nocb_bypass));
 
 	/*
-	 * Lock one last time so we see latest updates from kthreads and timer
-	 * so that we can later run callbacks locally without the lock.
+	 * Lock one last time so we see latest updates from kthreads
+	 * and we can later run callbacks locally without the lock.
 	 */
 	rcu_nocb_lock_irqsave(rdp, flags);
 	/*
-- 
2.25.1

