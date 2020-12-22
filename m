Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83FD2E03E6
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 02:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLVBiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 20:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgLVBiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 20:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C91522CB1;
        Tue, 22 Dec 2020 01:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601063;
        bh=6nMfwrsZb2Jqi0tEbsTkov9Zp4J5F8egvQ1o589NL/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3PETQq8GgEpjNXL3hgjKCORR1bqWVLC01PyGhIQE6oouWvDtydhIC7y5bIi4H5qB
         EwdPjvUMqn7B48JQvOHaLdK4TQkgAYbMXdrr5u93dljjLn+sKHoN6SxJtLKxC6/PtY
         s0H/qLHxJxIGiFqpdoW4o2rnCUF1yjRiZoS/wK9qDkCqDH58DGD64P8GzusAHYghy9
         P6lfZE2J63uRnJIJEwz39AG9SwClsqtpDjcmC64SWEfIdjxLGGWvJZ38Ty4uU6RYgj
         yDJqEp4Zi88XO1aiZ9hTRKO6v+iYagc4tAoLzsFDhTBITVBexUhGtRlP52Xgqpi1Rv
         SHQKENQkt/VWA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Date:   Tue, 22 Dec 2020 02:37:09 +0100
Message-Id: <20201222013712.15056-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222013712.15056-1-frederic@kernel.org>
References: <20201222013712.15056-1-frederic@kernel.org>
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

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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

