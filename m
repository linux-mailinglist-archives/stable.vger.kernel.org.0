Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58B3A9A80
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhFPMdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 08:33:35 -0400
Received: from muru.com ([72.249.23.125]:46576 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhFPMdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 08:33:31 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 2CEC380EB;
        Wed, 16 Jun 2021 12:31:34 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: [Backport for 5.4.y PATCHv2 3/4] clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
Date:   Wed, 16 Jun 2021 15:31:11 +0300
Message-Id: <20210616123112.65068-3-tony@atomide.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616123112.65068-1-tony@atomide.com>
References: <20210616123112.65068-1-tony@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce upstream.

There is a timer wrap issue on dra7 for the ARM architected timer.
In a typical clock configuration the timer fails to wrap after 388 days.

To work around the issue, we need to use timer-ti-dm timers instead.

Let's prepare for adding support for percpu timers by adding a common
dmtimer_clkevt_init_common() and call it from __omap_sync32k_timer_init().
This patch makes no intentional functional changes.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
[tony@atomide.com: backported to 5.4.y]
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/timer.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -367,18 +367,21 @@ void tick_broadcast(const struct cpumask *mask)
 }
 #endif
 
-static void __init omap2_gp_clockevent_init(int gptimer_id,
-						const char *fck_source,
-						const char *property)
+static void __init dmtimer_clkevt_init_common(struct dmtimer_clockevent *clkevt,
+					      int gptimer_id,
+					      const char *fck_source,
+					      unsigned int features,
+					      const struct cpumask *cpumask,
+					      const char *property,
+					      int rating, const char *name)
 {
-	struct dmtimer_clockevent *clkevt = &clockevent;
 	struct omap_dm_timer *timer = &clkevt->timer;
 	int res;
 
 	timer->id = gptimer_id;
 	timer->errata = omap_dm_timer_get_errata();
-	clkevt->dev.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
-	clkevt->dev.rating = 300;
+	clkevt->dev.features = features;
+	clkevt->dev.rating = rating;
 	clkevt->dev.set_next_event = omap2_gp_timer_set_next_event;
 	clkevt->dev.set_state_shutdown = omap2_gp_timer_shutdown;
 	clkevt->dev.set_state_periodic = omap2_gp_timer_set_periodic;
@@ -396,19 +399,15 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 				     &clkevt->dev.name, OMAP_TIMER_POSTED);
 	BUG_ON(res);
 
-	clkevt->dev.cpumask = cpu_possible_mask;
+	clkevt->dev.cpumask = cpumask;
 	clkevt->dev.irq = omap_dm_timer_get_irq(timer);
 
-	if (request_irq(timer->irq, omap2_gp_timer_interrupt,
-			IRQF_TIMER | IRQF_IRQPOLL, "gp_timer", clkevt))
-		pr_err("Failed to request irq %d (gp_timer)\n", timer->irq);
+	if (request_irq(clkevt->dev.irq, omap2_gp_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, name, clkevt))
+		pr_err("Failed to request irq %d (gp_timer)\n", clkevt->dev.irq);
 
 	__omap_dm_timer_int_enable(timer, OMAP_TIMER_INT_OVERFLOW);
 
-	clockevents_config_and_register(&clkevt->dev, timer->rate,
-					3, /* Timer internal resynch latency */
-					0xffffffff);
-
 	if (soc_is_am33xx() || soc_is_am43xx()) {
 		clkevt->dev.suspend = omap_clkevt_idle;
 		clkevt->dev.resume = omap_clkevt_unidle;
@@ -558,7 +557,12 @@ static void __init __omap_sync32k_timer_init(int clkev_nr, const char *clkev_src
 {
 	omap_clk_init();
 	omap_dmtimer_init();
-	omap2_gp_clockevent_init(clkev_nr, clkev_src, clkev_prop);
+	dmtimer_clkevt_init_common(&clockevent, clkev_nr, clkev_src,
+				   CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+				   cpu_possible_mask, clkev_prop, 300, "clockevent");
+	clockevents_config_and_register(&clockevent.dev, clockevent.timer.rate,
+					3, /* Timer internal resynch latency */
+					0xffffffff);
 
 	/* Enable the use of clocksource="gp_timer" kernel parameter */
 	if (use_gptimer_clksrc || gptimer)
-- 
2.31.1
