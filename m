Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C183222F4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBWALE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhBWALD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B90864DD3;
        Tue, 23 Feb 2021 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039022;
        bh=3H9Jv3hYX5Ve9kt7kgpvw3Du+Ru83HC8oyO6f0Dd6KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+7YgRseigzAmBUWQ33fTsw5i9ufX/lIhWcyvka3WgsvyiEyOJzOBVaMtA9l5k7oz
         nyD8wAMssqeJhJy9GjLsLNaQ6LHX2Afgc+44167mrjxGy2V7FS4/jAhQVOiTMx90n3
         cAsx5tsZZyFpRHVyi4j9RfGtVKUeXKj6edxCu+kI0mSmgVLRhmsGgxhDnrXPFGyjwh
         FMc9wcQIzbBAdfvOlRaPp7D4mrCLBpe4k/1aRRxCO0CbVqPG7gaI3LuYSe+V8XoP4L
         qswNfiKXakvqhNb1n+8nt3cT+EwAd1icyINp4/rpd90WwDX77QLBLxDyg9IGOnBPLs
         D2Im332xvvjxA==
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
Subject: [PATCH 02/13] rcu/nocb: Disable bypass when CPU isn't completely offloaded
Date:   Tue, 23 Feb 2021 01:10:00 +0100
Message-Id: <20210223001011.127063-3-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of flushing bypass at the very last moment in the deoffloading
process, just disable bypass enqueue at soon as we start the deoffloading
process and flush the pending bypass early. It's less fragile and we
leave some time to the kthreads and softirqs to process quietly.

Symmetrically, only enable bypass once we safely complete the offloading
process.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/rcu_segcblist.h |  7 ++++---
 kernel/rcu/tree_plugin.h      | 38 ++++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/rcu_segcblist.h b/include/linux/rcu_segcblist.h
index 8afe886e85f1..3db96c4f45fd 100644
--- a/include/linux/rcu_segcblist.h
+++ b/include/linux/rcu_segcblist.h
@@ -109,7 +109,7 @@ struct rcu_cblist {
  *  |                           SEGCBLIST_KTHREAD_GP                           |
  *  |                                                                          |
  *  |   Kthreads handle callbacks holding nocb_lock, local rcu_core() stops    |
- *  |   handling callbacks.                                                    |
+ *  |   handling callbacks. Enable bypass queueing.                            |
  *  ----------------------------------------------------------------------------
  */
 
@@ -125,7 +125,7 @@ struct rcu_cblist {
  *  |                           SEGCBLIST_KTHREAD_GP                           |
  *  |                                                                          |
  *  |   CB/GP kthreads handle callbacks holding nocb_lock, local rcu_core()    |
- *  |   ignores callbacks.                                                     |
+ *  |   ignores callbacks. Bypass enqueue is enabled.                          |
  *  ----------------------------------------------------------------------------
  *                                      |
  *                                      v
@@ -134,7 +134,8 @@ struct rcu_cblist {
  *  |                           SEGCBLIST_KTHREAD_GP                           |
  *  |                                                                          |
  *  |   CB/GP kthreads and local rcu_core() handle callbacks concurrently      |
- *  |   holding nocb_lock. Wake up CB and GP kthreads if necessary.            |
+ *  |   holding nocb_lock. Wake up CB and GP kthreads if necessary. Disable    |
+ *  |   bypass enqueue.                                                        |
  *  ----------------------------------------------------------------------------
  *                                      |
  *                                      v
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index dd0dc66c282d..924fa3d1df0d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1842,11 +1842,22 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 	unsigned long j = jiffies;
 	long ncbs = rcu_cblist_n_cbs(&rdp->nocb_bypass);
 
+	lockdep_assert_irqs_disabled();
+
+	// Pure softirq/rcuc based processing: no bypassing, no
+	// locking.
 	if (!rcu_rdp_is_offloaded(rdp)) {
+		*was_alldone = !rcu_segcblist_pend_cbs(&rdp->cblist);
+		return false;
+	}
+
+	// In the process of (de-)offloading: no bypassing, but
+	// locking.
+	if (!rcu_segcblist_completely_offloaded(&rdp->cblist)) {
+		rcu_nocb_lock(rdp);
 		*was_alldone = !rcu_segcblist_pend_cbs(&rdp->cblist);
 		return false; /* Not offloaded, no bypassing. */
 	}
-	lockdep_assert_irqs_disabled();
 
 	// Don't use ->nocb_bypass during early boot.
 	if (rcu_scheduler_active != RCU_SCHEDULER_RUNNING) {
@@ -2429,7 +2440,16 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 	pr_info("De-offloading %d\n", rdp->cpu);
 
 	rcu_nocb_lock_irqsave(rdp, flags);
-
+	/*
+	 * Flush once and for all now. This suffices because we are
+	 * running on the target CPU holding ->nocb_lock (thus having
+	 * interrupts disabled), and because rdp_offload_toggle()
+	 * invokes rcu_segcblist_offload(), which clears SEGCBLIST_OFFLOADED.
+	 * Thus future calls to rcu_segcblist_completely_offloaded() will
+	 * return false, which means that future calls to rcu_nocb_try_bypass()
+	 * will refuse to put anything into the bypass.
+	 */
+	WARN_ON_ONCE(!rcu_nocb_flush_bypass(rdp, NULL, jiffies));
 	ret = rdp_offload_toggle(rdp, false, flags);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
@@ -2441,21 +2461,21 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 	del_timer_sync(&rdp->nocb_timer);
 
 	/*
-	 * Flush bypass. While IRQs are disabled and once we set
-	 * SEGCBLIST_SOFTIRQ_ONLY, no callback is supposed to be
-	 * enqueued on bypass.
+	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY with CB unlocked
+	 * and IRQs disabled but let's be paranoid.
 	 */
 	rcu_nocb_lock_irqsave(rdp, flags);
-	rcu_nocb_flush_bypass(rdp, NULL, jiffies);
 	rcu_segcblist_set_flags(cblist, SEGCBLIST_SOFTIRQ_ONLY);
 	/*
 	 * With SEGCBLIST_SOFTIRQ_ONLY, we can't use
-	 * rcu_nocb_unlock_irqrestore() anymore. Theoretically we
-	 * could set SEGCBLIST_SOFTIRQ_ONLY with cb unlocked and IRQs
-	 * disabled now, but let's be paranoid.
+	 * rcu_nocb_unlock_irqrestore() anymore.
 	 */
 	raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
 
+	/* Sanity check */
+	WARN_ON_ONCE(rcu_cblist_n_cbs(&rdp->nocb_bypass));
+
+
 	return ret;
 }
 
-- 
2.25.1

