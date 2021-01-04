Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9632E985D
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbhADPVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbhADPVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:21:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8F32245C;
        Mon,  4 Jan 2021 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609773672;
        bh=xEuYweJJUO5EPqtYq/PHed3k5kHWmhrNEp0ENvHFaaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm6NwlfYKPxoZ6b1bHQFHHIVnMGDlqw0v/PBsDKW1mQZZbW3dVFoxeAwKujZNvCom
         hobgrPlGLz92KxuBzFj2hFG0l4IW7Q6rRqrHtlLgNjgodjHc+bMyqlc+xWTRWn4H9F
         TgXBH0uaXLvimDXKF0fMldCdka/qRE4qIAROfEetXqyrZW8hs90e3v4E/iL1RvbtjI
         qvN2uYzfXQ0SabQ1kdhLPpVXwS2cA4cPd7v6N78Vy9CNoqVvr+84Fu16Z0K9khRIhJ
         Eb6nK32Oh38+priywP0n1fbP/WXCv5ebumeGa777zaXcnsSESOvvNawwgG5MfJXcJ5
         tftG/PjfM85Cw==
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
Subject: [PATCH 2/4] cpuidle: Fix missing need_resched() check after rcu_idle_enter()
Date:   Mon,  4 Jan 2021 16:20:56 +0100
Message-Id: <20210104152058.36642-3-frederic@kernel.org>
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

Unfortunately within cpuidle the call to rcu_idle_enter() is already
beyond the last generic need_resched() check. Some drivers may perform
their own checks like with mwait_idle_with_hints() but many others don't
and we may halt the CPU with a resched request unhandled, leaving the
task hanging.

Fix this with performing a last minute need_resched() check after
calling rcu_idle_enter().

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: 1098582a0f6c (sched,idle,rcu: Push rcu_idle deeper into the idle path)
Cc: stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
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

