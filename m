Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37D22EFCFE
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbhAICGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbhAICG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:06:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 185C023AC1;
        Sat,  9 Jan 2021 02:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157948;
        bh=DmtAyxnXnAsrifI9+yfmddVBH+zgcl5C6QweDwHY7cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWmX/ewLt97KeYAkf1nu+jZeVUHO/YqX78CIF8XLQakwwC1JwJ1k3U8HkTPGoXjqP
         EWLVeYpMQW/aFDH6uz3Q8oRKR+sKYHCYrVY3q7jC5NsSMS/t/B8dSLQmLWhq6ec0od
         EbERWFzb0PCS6IFxzJrcQecV8l1hcM/WXytIXrveUpctxEgo5YGLaO+sPEUg/ix8l0
         +gfCkEvjew3swNFk6laFX3NdgbsBeQ7wa110m3yVTO2Va+a2GoPPwguJQgl7QnBnIA
         GRW5tsW8IpOphG3CBjiwtHfH/Fov2FK3AiNZGRfxzzRVFLaQZQWhxUR6VjndP9ZIGo
         El4sG3WD10R1Q==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 3/8] rcu/nocb: Perform deferred wake up before last idle's need_resched() check
Date:   Sat,  9 Jan 2021 03:05:31 +0100
Message-Id: <20210109020536.127953-4-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Usually a local wake up happening while running the idle task is handled
in one of the need_resched() checks carefully placed within the idle
loop that can break to the scheduler.

Unfortunately the call to rcu_idle_enter() is already beyond the last
generic need_resched() check and we may halt the CPU with a resched
request unhandled, leaving the task hanging.

Fix this with splitting the rcuog wakeup handling from rcu_idle_enter()
and place it before the last generic need_resched() check in the idle
loop. It is then assumed that no call to call_rcu() will be performed
after that in the idle loop until the CPU is put in low power mode.
Further debug code will help spotting the offenders.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Cc: stable@vger.kernel.org
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/rcupdate.h | 2 ++
 kernel/rcu/tree.c        | 3 ---
 kernel/rcu/tree_plugin.h | 5 +++++
 kernel/sched/idle.c      | 3 +++
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index de0826411311..4068234fb303 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -104,8 +104,10 @@ static inline void rcu_user_exit(void) { }
 
 #ifdef CONFIG_RCU_NOCB_CPU
 void rcu_init_nohz(void);
+void rcu_nocb_flush_deferred_wakeup(void);
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_init_nohz(void) { }
+static inline void rcu_nocb_flush_deferred_wakeup(void) { }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 /**
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b9fff18d14d9..b6e1377774e3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -670,10 +670,7 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
-	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7e291ce0a1d6..d5b38c28abd1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2187,6 +2187,11 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 		do_nocb_deferred_wakeup_common(rdp);
 }
 
+void rcu_nocb_flush_deferred_wakeup(void)
+{
+	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
+}
+
 void __init rcu_init_nohz(void)
 {
 	int cpu;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 305727ea0677..b601a3aa2152 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -55,6 +55,7 @@ __setup("hlt", cpu_idle_nopoll_setup);
 static noinline int __cpuidle cpu_idle_poll(void)
 {
 	trace_cpu_idle(0, smp_processor_id());
+	rcu_nocb_flush_deferred_wakeup();
 	stop_critical_timings();
 	rcu_idle_enter();
 	local_irq_enable();
@@ -173,6 +174,8 @@ static void cpuidle_idle_call(void)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 
+	rcu_nocb_flush_deferred_wakeup();
+
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
 	 * case, exit the function after re-enabling the local irq.
-- 
2.25.1

