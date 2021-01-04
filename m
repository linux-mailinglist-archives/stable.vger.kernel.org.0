Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC16F2E985B
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbhADPVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:21:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbhADPVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:21:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E366A221E5;
        Mon,  4 Jan 2021 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609773668;
        bh=HFmeWgP/ZwiP+hsm1k1sd6flGOowieQ4iCyWAlhoJv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+k9HGCekSuBIIVVZ/ISjvZonqSkNugJc5J5p4J/mSDFKTkdxuIdUMGN1QalOHEdk
         f7aRNnS1mdr8BczwxjxfrDMXpcUc8fYcPcQ9mj6jEcsdokhd8vOuR2qRHeI8vgS+YE
         DBDubISmg6gxHR6JrKrwimOmjBkWpGF5/KbhrVMlutD0AU0vW6wmBmZB1feFH/zvr7
         j81hw8oarxzf6ewpFfIXn/ncGwaaUFtaQQmcqJNuR2+OGvyvoTkjRuOOxYAHnor5Tw
         iLQZS4ZULUhxhgUXgA8F4X2S3mSlUuMAmlVyPdvrRLow64PpXZ9/0n23trV8z4xeGj
         bB+6i6q/TFWew==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/4] sched/idle: Fix missing need_resched() check after rcu_idle_enter()
Date:   Mon,  4 Jan 2021 16:20:55 +0100
Message-Id: <20210104152058.36642-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104152058.36642-1-frederic@kernel.org>
References: <20210104152058.36642-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Usually a wake up happening while running the idle task is spotted in
one of the need_resched() checks carefully placed within the idle loop
that can break to the scheduler.

Unfortunately in default_idle_call(), the call to rcu_idle_enter() is
already beyond the last need_resched() check and we may halt the CPU
with a resched request unhandled, leaving the task hanging.

Fix this with performing a last minute need_resched() check after
calling rcu_idle_enter().

Reported-and-tested-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/sched/idle.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 305727ea0677..1af60dc50beb 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -109,15 +109,21 @@ void __cpuidle default_idle_call(void)
 		rcu_idle_enter();
 		lockdep_hardirqs_on(_THIS_IP_);
 
-		arch_cpu_idle();
+		/*
+		 * Last need_resched() check must come after rcu_idle_enter()
+		 * which may wake up RCU internal tasks.
+		 */
+		if (!need_resched()) {
+			arch_cpu_idle();
+			raw_local_irq_disable();
+		}
 
 		/*
-		 * OK, so IRQs are enabled here, but RCU needs them disabled to
-		 * turn itself back on.. funny thing is that disabling IRQs
-		 * will cause tracing, which needs RCU. Jump through hoops to
-		 * make it 'work'.
+		 * OK, so IRQs are enabled after arch_cpu_idle(), but RCU needs
+		 * them disabled to turn itself back on.. funny thing is that
+		 * disabling IRQs will cause tracing, which needs RCU. Jump through
+		 * hoops to make it 'work'.
 		 */
-		raw_local_irq_disable();
 		lockdep_hardirqs_off(_THIS_IP_);
 		rcu_idle_exit();
 		lockdep_hardirqs_on(_THIS_IP_);
-- 
2.25.1

