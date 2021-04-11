Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D9835B505
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 15:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhDKNot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 09:44:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33442 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbhDKNoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 09:44:04 -0400
Date:   Sun, 11 Apr 2021 13:43:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618148607;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=AbjMR5nQt2xl9HTdQrva+oXNpxjvXqwzBpkvmqrS/Ic=;
        b=CJh5Z1iT6+BRnz8cFvGIB8MSv7HZ22nZYFSOFaizDapUJv91hcQcHsYb1a45O2yameuI8N
        qWKekB2r3PjegU+s1/54XFUjOF5C1T61dg7ztIuEpS2Xem4ooIFu7YJx0DbMdpaP8Nr1zv
        2/Ikz8vVbsFvKOtE2llqdPHrHB7ykoP51IDIgozkMWQ41eFnRsXjRRNGsghkRnus81ObLF
        fmyGGnXMyblBn7mPztJL5q+Y2lTDKBADfAr1PPeJVqzHlCSBTTxGkHy2p4wFSgSoYV2CIa
        twrIdrvWI7YfA64O6xVSNMNsJOEo69y3U0iHz3BDpwCMpY2frwC04SUv5RSqgw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618148607;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=AbjMR5nQt2xl9HTdQrva+oXNpxjvXqwzBpkvmqrS/Ic=;
        b=tMhOI69MsumO27QwMgyz6GT/dDBflKN3c7ZLOw1OdJnOpV/xLFDNyQjdHnSV76t6uYSBdL
        lLtgOiqbtXk3zSBA==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] rcu/nocb: Fix missed nocb_timer requeue
Cc:     <stable@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161814860637.29796.8196578350712510174.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     b2fcf2102049f6e56981e0ab3d9b633b8e2741da
Gitweb:        https://git.kernel.org/tip/b2fcf2102049f6e56981e0ab3d9b633b8e2741da
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Tue, 23 Feb 2021 01:09:59 +01:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Mon, 15 Mar 2021 13:54:54 -07:00

rcu/nocb: Fix missed nocb_timer requeue

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
 
