Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90E3307CB8
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhA1Rhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhA1RPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2FAA64E1D;
        Thu, 28 Jan 2021 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853960;
        bh=JK9DOBj4/khMplr7onAOn5tohqayBCx7Y3olHU9EheE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUY1570ZA6AXEoC63upEXBQeCYCRaF9XrBBbJ4GQ/NOAyltXu9qXSI8tSa9s+bPHk
         JfSOxybNDeiOAXMEbwHNBSkikyC7w4ZHthPS02JUKJkPT+yHCSy+zq2nPxO1mQo1pU
         nd1TqeEOXTxstLPmHlmGmRpSVJeXIglVBrAx9pdn6OXTn7FSwSpESG0BEupmuH4Znr
         uLfH++W9JS9g29vyeQi6JCsLP+ojZ3tQI4jm9n0STVAD+cfq2nIK74P5x8Dt1vAtMI
         AFJ0sMdflskMzMFpP5cPCkXbAn54gueRoEiJeXvs3Jy6Zjg0rGvwRMjfkATc1yOyIQ
         9waornCOboV1A==
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
Subject: [PATCH 05/16] rcu/nocb: Disable bypass when CPU isn't completely offloaded
Date:   Thu, 28 Jan 2021 18:12:11 +0100
Message-Id: <20210128171222.131380-6-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
 kernel/rcu/tree_plugin.h      | 31 +++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcu_segcblist.h b/include/linux/rcu_segcblist.h
index 8afe886e85f1..5a2d6dadd720 100644
--- a/include/linux/rcu_segcblist.h
+++ b/include/linux/rcu_segcblist.h
@@ -109,7 +109,7 @@ struct rcu_cblist {
  *  |                           SEGCBLIST_KTHREAD_GP                           |
  *  |                                                                          |
  *  |   Kthreads handle callbacks holding nocb_lock, local rcu_core() stops    |
- *  |   handling callbacks.                                                    |
+ *  |   handling callbacks. Allow bypass enqueue.                              |
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
index 732942a15f2b..7781830a3cf1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1825,11 +1825,22 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
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
@@ -2412,6 +2423,7 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 
 	rcu_nocb_lock_irqsave(rdp, flags);
 
+	WARN_ON_ONCE(!rcu_nocb_flush_bypass(rdp, NULL, jiffies));
 	ret = rdp_offload_toggle(rdp, false, flags);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
@@ -2422,19 +2434,22 @@ static long rcu_nocb_rdp_deoffload(void *arg)
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	del_timer_sync(&rdp->nocb_timer);
 
+	/* Sanity check */
+	WARN_ON_ONCE(rcu_cblist_n_cbs(&rdp->nocb_bypass));
+
 	/*
-	 * Flush bypass. While IRQs are disabled and once we set
-	 * SEGCBLIST_SOFTIRQ_ONLY, no callback is supposed to be
-	 * enqueued on bypass.
+	 * Lock one last time so we see latest updates from kthreads and timer
+	 * so that we can later run callbacks locally without the lock.
 	 */
 	rcu_nocb_lock_irqsave(rdp, flags);
-	rcu_nocb_flush_bypass(rdp, NULL, jiffies);
+	/*
+	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY after the nocb
+	 * LOCK/UNLOCK but let's be paranoid.
+	 */
 	rcu_segcblist_set_flags(cblist, SEGCBLIST_SOFTIRQ_ONLY);
 	/*
 	 * With SEGCBLIST_SOFTIRQ_ONLY, we can't use
-	 * rcu_nocb_unlock_irqrestore() anymore. Theoretically we
-	 * could set SEGCBLIST_SOFTIRQ_ONLY with cb unlocked and IRQs
-	 * disabled now, but let's be paranoid.
+	 * rcu_nocb_unlock_irqrestore() anymore.
 	 */
 	raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
 
-- 
2.25.1

