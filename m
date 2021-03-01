Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418932918D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhCAU1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45771 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242968AbhCAUVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA937653F8;
        Mon,  1 Mar 2021 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621882;
        bh=gtaiJeLyUAAsZSBWSW6l2CEJRuWmKyvn8ijz8XEZtuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1Lixrpxx25riQy8FHZ8ObOsAIIOKCdvTr2z3k2bEpUWCYf8QYuMtHemxb/nCHKlS
         v7NaZbIqANJhYh7ctcySftGlt9W+xWwxoxfUmI65VJ/sIOAvd+w5MPL+g1kaf464gX
         yyPU9jLGJtTfNx4AT7IJlW3WGEmQv48XLugKeewg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.11 678/775] rcu/nocb: Trigger self-IPI on late deferred wake up before user resume
Date:   Mon,  1 Mar 2021 17:14:06 +0100
Message-Id: <20210301161234.888672576@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit f8bb5cae9616224a39cbb399de382d36ac41df10 upstream.

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Unfortunately the call to rcu_user_enter() is already past the last
rescheduling opportunity before we resume to userspace or to guest mode.
We may escape there with the woken task ignored.

The ultimate resort to fix every callsites is to trigger a self-IPI
(nohz_full depends on arch to implement arch_irq_work_raise()) that will
trigger a reschedule on IRQ tail or guest exit.

Eventually every site that want a saner treatment will need to carefully
place a call to rcu_nocb_flush_deferred_wakeup() before the last explicit
need_resched() check upon resume.

Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-4-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c        |   21 ++++++++++++++++++++-
 kernel/rcu/tree.h        |    2 +-
 kernel/rcu/tree_plugin.h |   25 ++++++++++++++++---------
 3 files changed, 37 insertions(+), 11 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -677,6 +677,18 @@ void rcu_idle_enter(void)
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 #ifdef CONFIG_NO_HZ_FULL
+
+/*
+ * An empty function that will trigger a reschedule on
+ * IRQ tail once IRQs get re-enabled on userspace resume.
+ */
+static void late_wakeup_func(struct irq_work *work)
+{
+}
+
+static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
+	IRQ_WORK_INIT(late_wakeup_func);
+
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -694,12 +706,19 @@ noinstr void rcu_user_enter(void)
 
 	lockdep_assert_irqs_disabled();
 
+	/*
+	 * We may be past the last rescheduling opportunity in the entry code.
+	 * Trigger a self IPI that will fire and reschedule once we resume to
+	 * user/guest mode.
+	 */
 	instrumentation_begin();
-	do_nocb_deferred_wakeup(rdp);
+	if (do_nocb_deferred_wakeup(rdp) && need_resched())
+		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
 	instrumentation_end();
 
 	rcu_eqs_enter(true);
 }
+
 #endif /* CONFIG_NO_HZ_FULL */
 
 /**
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -433,7 +433,7 @@ static bool rcu_nocb_try_bypass(struct r
 static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_empty,
 				 unsigned long flags);
 static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_cpu_nocb_kthread(int cpu);
 static void __init rcu_spawn_nocb_kthreads(void);
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1631,8 +1631,8 @@ bool rcu_is_nocb_cpu(int cpu)
  * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
  * and this function releases it.
  */
-static void wake_nocb_gp(struct rcu_data *rdp, bool force,
-			   unsigned long flags)
+static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
+			 unsigned long flags)
 	__releases(rdp->nocb_lock)
 {
 	bool needwake = false;
@@ -1643,7 +1643,7 @@ static void wake_nocb_gp(struct rcu_data
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
 		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return;
+		return false;
 	}
 	del_timer(&rdp->nocb_timer);
 	rcu_nocb_unlock_irqrestore(rdp, flags);
@@ -1656,6 +1656,8 @@ static void wake_nocb_gp(struct rcu_data
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 	if (needwake)
 		wake_up_process(rdp_gp->nocb_gp_kthread);
+
+	return needwake;
 }
 
 /*
@@ -2152,20 +2154,23 @@ static int rcu_nocb_need_deferred_wakeup
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
-static void do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 {
 	unsigned long flags;
 	int ndw;
+	int ret;
 
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
+
+	return ret;
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread() from a timer handler. */
@@ -2181,10 +2186,11 @@ static void do_nocb_deferred_wakeup_time
  * This means we do an inexact common-case check.  Note that if
  * we miss, ->nocb_timer will eventually clean things up.
  */
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 	if (rcu_nocb_need_deferred_wakeup(rdp))
-		do_nocb_deferred_wakeup_common(rdp);
+		return do_nocb_deferred_wakeup_common(rdp);
+	return false;
 }
 
 void rcu_nocb_flush_deferred_wakeup(void)
@@ -2523,8 +2529,9 @@ static int rcu_nocb_need_deferred_wakeup
 	return false;
 }
 
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	return false;
 }
 
 static void rcu_spawn_cpu_nocb_kthread(int cpu)


