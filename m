Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EA12E03EC
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 02:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgLVBi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 20:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgLVBi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 20:38:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCF2322B3B;
        Tue, 22 Dec 2020 01:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601066;
        bh=igI/vQe3iEazWjzSihez2c88DYa3jmo8Cwp6nJTNEJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjcXpCaFnWatiCN7WHPSOJRN1Clx7ZlZ2RJdMJQw0p8HFynjEvyOlS7GuDYcT2usk
         we9C1QdvFVGo5ByiAGdTI++AU5L0q37Yt60EFuWgr30H109ySpm58qA6xwI9YseAs1
         zEsu1GlI4BMeIQQdA5LQDTPCoUP60cOE8yb4b8Ob7sSF1Xs4l/29hRJHCZZxhG03Ju
         DG2oAvPklyr2lMy95/ahSS4GibrKxCxcLSbly/4/0lk8zrRkHAtdgZsdCaAwFB6PmX
         2CD7dJGuSfes8V1xtvWeAH+ZAwibHsGfLZEVy9eGjEvFPo064Dt+z4bA8O3MiEFPeP
         7qccI0GSdAOvA==
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
Subject: [PATCH 2/4] cpuidle: Fix missing need_resched() check after rcu_idle_enter()
Date:   Tue, 22 Dec 2020 02:37:10 +0100
Message-Id: <20201222013712.15056-3-frederic@kernel.org>
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

Unfortunately within cpuidle the call to rcu_idle_enter() is already
beyond the last generic need_resched() check. Some drivers may perform
their own checks like with mwait_idle_with_hints() but many others don't
and we may halt the CPU with a resched request unhandled, leaving the
task hanging.

Fix this with performing a last minute need_resched() check after
calling rcu_idle_enter().

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: 1098582a0f6c (sched,idle,rcu: Push rcu_idle deeper into the idle path)
Cc: stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ef2ea1b12cd8..4cc1ba49ce05 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -134,8 +134,8 @@ int cpuidle_find_deepest_state(struct cpuidle_driver *drv,
 }
 
 #ifdef CONFIG_SUSPEND
-static void enter_s2idle_proper(struct cpuidle_driver *drv,
-				struct cpuidle_device *dev, int index)
+static int enter_s2idle_proper(struct cpuidle_driver *drv,
+			       struct cpuidle_device *dev, int index)
 {
 	ktime_t time_start, time_end;
 	struct cpuidle_state *target_state = &drv->states[index];
@@ -151,7 +151,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
 	stop_critical_timings();
 	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
 		rcu_idle_enter();
-	target_state->enter_s2idle(dev, drv, index);
+	/*
+	 * Last need_resched() check must come after rcu_idle_enter()
+	 * which may wake up RCU internal tasks.
+	 */
+	if (!need_resched())
+		target_state->enter_s2idle(dev, drv, index);
+	else
+		index = -EBUSY;
 	if (WARN_ON_ONCE(!irqs_disabled()))
 		local_irq_disable();
 	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
@@ -159,10 +166,13 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
 	tick_unfreeze();
 	start_critical_timings();
 
-	time_end = ns_to_ktime(local_clock());
+	if (index > 0) {
+		time_end = ns_to_ktime(local_clock());
+		dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
+		dev->states_usage[index].s2idle_usage++;
+	}
 
-	dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
-	dev->states_usage[index].s2idle_usage++;
+	return index;
 }
 
 /**
@@ -184,7 +194,7 @@ int cpuidle_enter_s2idle(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 */
 	index = find_deepest_state(drv, dev, U64_MAX, 0, true);
 	if (index > 0) {
-		enter_s2idle_proper(drv, dev, index);
+		index = enter_s2idle_proper(drv, dev, index);
 		local_irq_enable();
 	}
 	return index;
@@ -234,7 +244,14 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 	stop_critical_timings();
 	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
 		rcu_idle_enter();
-	entered_state = target_state->enter(dev, drv, index);
+	/*
+	 * Last need_resched() check must come after rcu_idle_enter()
+	 * which may wake up RCU internal tasks.
+	 */
+	if (!need_resched())
+		entered_state = target_state->enter(dev, drv, index);
+	else
+		entered_state = -EBUSY;
 	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
 		rcu_idle_exit();
 	start_critical_timings();
-- 
2.25.1

