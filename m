Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58F532C84D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383941AbhCDAfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448487AbhCDAZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 19:25:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349D464EBD;
        Thu,  4 Mar 2021 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614817395;
        bh=FAZG03zSoIbEYQ+G/Ef9ono8IzzxV7GIMyktvPk563g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyMwjSXtopsX1BrIHqc2M77tJJdjSL18gVYYSMlEBYaKOCKUpfXdmtKK3sXeSFD+2
         8B+wNmz4+EMEWoa4/UYSRXVc4ykFr0ZdnHsVIgHZuvchTxWOdreg3/57Brjo5J51qB
         pv+6KOWwHU+qC99Nh8YoRBzlsNu10E7Roup3Zp2Kujx2djDzo49bSlXFWAK5gYPUYA
         K0I3cU11lD65L7Ttv4HMDZzlvKZ5qMfj/jOC6SfoUDwLkKMvdDP1bJ1wNZKfRBpjEJ
         NIL9WXcURYnRbUgt2ZDrDBJIbzNf+avAoZfU9IVty0R5OSDiMgw+MKlrgzzgPIYaGk
         3SzxccJm5PtZQ==
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH tip/core/rcu 09/12] rcu/nocb: Fix missed nocb_timer requeue
Date:   Wed,  3 Mar 2021 16:23:08 -0800
Message-Id: <20210304002311.23655-9-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20210304002225.GA23492@paulmck-ThinkPad-P72>
References: <20210304002225.GA23492@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

This sequence of events can lead to a failure to requeue a CPU's
->nocb_timer:

1.	There are no callbacks queued for any CPU covered by CPU 0-2's
	->nocb_gp_kthread.  Note that ->nocb_gp_kthread is associated
	with CPU 0.

2.	CPU 1 enqueues its first callback with interrupts disabled, and
	thus must defer awakening its ->nocb_gp_kthread.  It therefore
	queues its rcu_data structure's ->nocb_timer.  At this point,
	CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.

3.	CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
	callback, but with interrupts enabled, allowing it to directly
	awaken the ->nocb_gp_kthread.

4.	The newly awakened ->nocb_gp_kthread associates both CPU 1's
	and CPU 2's callbacks with a future grace period and arranges
	for that grace period to be started.

5.	This ->nocb_gp_kthread goes to sleep waiting for the end of this
	future grace period.

6.	This grace period elapses before the CPU 1's timer fires.
	This is normally improbably given that the timer is set for only
	one jiffy, but timers can be delayed.  Besides, it is possible
	that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.

7.	The grace period ends, so rcu_gp_kthread awakens the
	->nocb_gp_kthread, which in turn awakens both CPU 1's and
	CPU 2's ->nocb_cb_kthread.  Then ->nocb_gb_kthread sleeps
	waiting for more newly queued callbacks.

8.	CPU 1's ->nocb_cb_kthread invokes its callback, then sleeps
	waiting for more invocable callbacks.

9.	Note that neither kthread updated any ->nocb_timer state,
	so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.

10.	CPU 1 enqueues its second callback, this time with interrupts
 	enabled so it can wake directly	->nocb_gp_kthread.
	It does so with calling wake_nocb_gp() which also cancels the
	pending timer that got queued in step 2. But that doesn't reset
	CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
	So CPU 1's ->nocb_defer_wakeup and its ->nocb_timer are now
	desynchronized.

11.	->nocb_gp_kthread associates the callback queued in 10 with a new
	grace period, arranges for that grace period to start and sleeps
	waiting for it to complete.

12.	The grace period ends, rcu_gp_kthread awakens ->nocb_gp_kthread,
	which in turn wakes up CPU 1's ->nocb_cb_kthread which then
	invokes the callback queued in 10.

13.	CPU 1 enqueues its third callback, this time with interrupts
	disabled so it must queue a timer for a deferred wakeup. However
	the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
	incorrectly indicates that a timer is already queued.  Instead,
	CPU 1's ->nocb_timer was cancelled in 10.  CPU 1 therefore fails
	to queue the ->nocb_timer.

14.	CPU 1 has its pending callback and it may go unnoticed until
	some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever
	calls an explicit deferred wakeup, for example, during idle entry.

This commit fixes this bug by resetting rdp->nocb_defer_wakeup everytime
we delete the ->nocb_timer.

It is quite possible that there is a similar scenario involving
->nocb_bypass_timer and ->nocb_defer_wakeup.  However, despite some
effort from several people, a failure scenario has not yet been located.
However, that by no means guarantees that no such scenario exists.
Finding a failure scenario is left as an exercise for the reader, and the
"Fixes:" tag below relates to ->nocb_bypass_timer instead of ->nocb_timer.

Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
Cc: <stable@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/rcu/tree_plugin.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a1a17ad..e392bd1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1708,7 +1708,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
-	del_timer(&rdp->nocb_timer);
+
+	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp->nocb_timer);
+	}
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
@@ -2335,7 +2339,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 
-- 
2.9.5

