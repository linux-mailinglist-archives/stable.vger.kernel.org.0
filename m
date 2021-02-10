Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7241316862
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBJNyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhBJNyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:54:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8545AC061574;
        Wed, 10 Feb 2021 05:53:34 -0800 (PST)
Date:   Wed, 10 Feb 2021 13:53:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0CB8zPCHW0sNIe0P1frAuXXaFjM4jFls7TklCrWBFI=;
        b=jZMVbU9+mBsrGhqW6sbO4ZyKGo1oMq92N8FsnLq1uuLx5FpweB0LGBWfWRYT+5zc2w5nO/
        YsuQLPkEPCndAOebBm89LONJEf2srkUs6cX/XEhNDAsl2QzyaKZRBmTS65cSDR1GNbyEnf
        +4G9yB3i6nxPqNeTHAFCqOCgh00e+vp24pphM1Szr7tg8WooazgRSxMqLNPDuen0HUObW1
        pyT61S1Qfi471eTE5ZgkOMwUX7tSG4awCkLRks4lKzSKZ7GUJDeD2JQ2wlVnq4XCGR7Iv4
        SjTvrbGxv1ZxgUNvTQAYKlOsvOzaOyuRPzk1ZUpJy4E8+b6WVTq4Zc3W2T9q7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0CB8zPCHW0sNIe0P1frAuXXaFjM4jFls7TklCrWBFI=;
        b=uwtfyAv5YqdBO9YABZwxVw2KIrMmuofUGi7sDX+BKChwdbyo+G7O/aan3y/ov3sJStCIdY
        nvOocx8mKYQxbWDw==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] rcu/nocb: Trigger self-IPI on late deferred wake up
 before user resume
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-4-frederic@kernel.org>
References: <20210131230548.32970-4-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161296521234.23325.16460014025012705438.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     0940cbceefbaa40d85efeb968ce9f2707a145e58
Gitweb:        https://git.kernel.org/tip/0940cbceefbaa40d85efeb968ce9f2707a145e58
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:46 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 10 Feb 2021 14:44:50 +01:00

rcu/nocb: Trigger self-IPI on late deferred wake up before user resume

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
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-4-frederic@kernel.org
---
 kernel/rcu/tree.c        | 21 ++++++++++++++++++++-
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 25 ++++++++++++++++---------
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 82838e9..4b1e5bd 100644
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
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 7708ed1..9226f40 100644
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
index d5b38c2..384856e 100644
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
@@ -1643,7 +1643,7 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
 		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return;
+		return false;
 	}
 	del_timer(&rdp->nocb_timer);
 	rcu_nocb_unlock_irqrestore(rdp, flags);
@@ -1656,6 +1656,8 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 	if (needwake)
 		wake_up_process(rdp_gp->nocb_gp_kthread);
+
+	return needwake;
 }
 
 /*
@@ -2152,20 +2154,23 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
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
@@ -2181,10 +2186,11 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
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
@@ -2523,8 +2529,9 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 	return false;
 }
 
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	return false;
 }
 
 static void rcu_spawn_cpu_nocb_kthread(int cpu)
