Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300933C24C6
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhGINZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhGINYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E790E613C9;
        Fri,  9 Jul 2021 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836924;
        bh=U/1QNR6vmGTeaC2wpQg0uqVJCHO2xQuRU/IOz5Md1cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIDCyjdKcGGLfpUasJL3iiJDdeCsN6je3LKuIr7FXe1u/ShtK3gvBe4Gk8d52xP6H
         gmVqKK1pDRN+0z85nA9rTZ4iEobd6NPIMZ88Zw4fmbJT5rv7AZ4M4aHM1Ehl8T1nri
         2nJqS8Oi+jE4O2EgJgviMJaFuo3PKq3BFQ4VZ6L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 32/34] clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support
Date:   Fri,  9 Jul 2021 15:20:48 +0200
Message-Id: <20210709131702.155092611@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 upstream.

We can move the TI dmtimer clockevent and clocksource to live under
drivers/clocksource if we rely only on the clock framework, and handle
the module configuration directly in the clocksource driver based on the
device tree data.

This removes the early dependency with system timers to the interconnect
related code, and we can probe pretty much everything else later on at
the module_init level.

Let's first add a new driver for timer-ti-dm-systimer based on existing
arch/arm/mach-omap2/timer.c. Then let's start moving SoCs to probe with
device tree data while still keeping the old timer.c. And eventually we
can just drop the old timer.c.

Let's take the opportunity to switch to use readl/writel as pointed out
by Daniel Lezcano <daniel.lezcano@linaro.org>. This allows further
clean-up of the timer-ti-dm code the a lot of the shared helpers can
just become static to the non-syster related code.

Note the boards can optionally configure different timer source clocks
if needed with assigned-clocks and assigned-clock-parents.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
[tony@atomide.com: backported to 4.19.y]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/timer.c |  109 ++++++++++++++++++++++++++------------------
 1 file changed, 65 insertions(+), 44 deletions(-)

--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -64,15 +64,28 @@
 
 /* Clockevent code */
 
-static struct omap_dm_timer clkev;
-static struct clock_event_device clockevent_gpt;
-
 /* Clockevent hwmod for am335x and am437x suspend */
 static struct omap_hwmod *clockevent_gpt_hwmod;
 
 /* Clockesource hwmod for am437x suspend */
 static struct omap_hwmod *clocksource_gpt_hwmod;
 
+struct dmtimer_clockevent {
+	struct clock_event_device dev;
+	struct omap_dm_timer timer;
+};
+
+static struct dmtimer_clockevent clockevent;
+
+static struct omap_dm_timer *to_dmtimer(struct clock_event_device *clockevent)
+{
+	struct dmtimer_clockevent *clkevt =
+		container_of(clockevent, struct dmtimer_clockevent, dev);
+	struct omap_dm_timer *timer = &clkevt->timer;
+
+	return timer;
+}
+
 #ifdef CONFIG_SOC_HAS_REALTIME_COUNTER
 static unsigned long arch_timer_freq;
 
@@ -84,10 +97,11 @@ void set_cntfreq(void)
 
 static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = &clockevent_gpt;
-
-	__omap_dm_timer_write_status(&clkev, OMAP_TIMER_INT_OVERFLOW);
+	struct dmtimer_clockevent *clkevt = dev_id;
+	struct clock_event_device *evt = &clkevt->dev;
+	struct omap_dm_timer *timer = &clkevt->timer;
 
+	__omap_dm_timer_write_status(timer, OMAP_TIMER_INT_OVERFLOW);
 	evt->event_handler(evt);
 	return IRQ_HANDLED;
 }
@@ -95,7 +109,9 @@ static irqreturn_t omap2_gp_timer_interr
 static int omap2_gp_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
-	__omap_dm_timer_load_start(&clkev, OMAP_TIMER_CTRL_ST,
+	struct omap_dm_timer *timer = to_dmtimer(evt);
+
+	__omap_dm_timer_load_start(timer, OMAP_TIMER_CTRL_ST,
 				   0xffffffff - cycles, OMAP_TIMER_POSTED);
 
 	return 0;
@@ -103,22 +119,26 @@ static int omap2_gp_timer_set_next_event
 
 static int omap2_gp_timer_shutdown(struct clock_event_device *evt)
 {
-	__omap_dm_timer_stop(&clkev, OMAP_TIMER_POSTED, clkev.rate);
+	struct omap_dm_timer *timer = to_dmtimer(evt);
+
+	__omap_dm_timer_stop(timer, OMAP_TIMER_POSTED, timer->rate);
+
 	return 0;
 }
 
 static int omap2_gp_timer_set_periodic(struct clock_event_device *evt)
 {
+	struct omap_dm_timer *timer = to_dmtimer(evt);
 	u32 period;
 
-	__omap_dm_timer_stop(&clkev, OMAP_TIMER_POSTED, clkev.rate);
+	__omap_dm_timer_stop(timer, OMAP_TIMER_POSTED, timer->rate);
 
-	period = clkev.rate / HZ;
+	period = timer->rate / HZ;
 	period -= 1;
 	/* Looks like we need to first set the load value separately */
-	__omap_dm_timer_write(&clkev, OMAP_TIMER_LOAD_REG, 0xffffffff - period,
+	__omap_dm_timer_write(timer, OMAP_TIMER_LOAD_REG, 0xffffffff - period,
 			      OMAP_TIMER_POSTED);
-	__omap_dm_timer_load_start(&clkev,
+	__omap_dm_timer_load_start(timer,
 				   OMAP_TIMER_CTRL_AR | OMAP_TIMER_CTRL_ST,
 				   0xffffffff - period, OMAP_TIMER_POSTED);
 	return 0;
@@ -132,26 +152,17 @@ static void omap_clkevt_idle(struct cloc
 	omap_hwmod_idle(clockevent_gpt_hwmod);
 }
 
-static void omap_clkevt_unidle(struct clock_event_device *unused)
+static void omap_clkevt_unidle(struct clock_event_device *evt)
 {
+	struct omap_dm_timer *timer = to_dmtimer(evt);
+
 	if (!clockevent_gpt_hwmod)
 		return;
 
 	omap_hwmod_enable(clockevent_gpt_hwmod);
-	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
+	__omap_dm_timer_int_enable(timer, OMAP_TIMER_INT_OVERFLOW);
 }
 
-static struct clock_event_device clockevent_gpt = {
-	.features		= CLOCK_EVT_FEAT_PERIODIC |
-				  CLOCK_EVT_FEAT_ONESHOT,
-	.rating			= 300,
-	.set_next_event		= omap2_gp_timer_set_next_event,
-	.set_state_shutdown	= omap2_gp_timer_shutdown,
-	.set_state_periodic	= omap2_gp_timer_set_periodic,
-	.set_state_oneshot	= omap2_gp_timer_shutdown,
-	.tick_resume		= omap2_gp_timer_shutdown,
-};
-
 static const struct of_device_id omap_timer_match[] __initconst = {
 	{ .compatible = "ti,omap2420-timer", },
 	{ .compatible = "ti,omap3430-timer", },
@@ -361,44 +372,54 @@ static void __init omap2_gp_clockevent_i
 						const char *fck_source,
 						const char *property)
 {
+	struct dmtimer_clockevent *clkevt = &clockevent;
+	struct omap_dm_timer *timer = &clkevt->timer;
 	int res;
 
-	clkev.id = gptimer_id;
-	clkev.errata = omap_dm_timer_get_errata();
+	timer->id = gptimer_id;
+	timer->errata = omap_dm_timer_get_errata();
+	clkevt->dev.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	clkevt->dev.rating = 300;
+	clkevt->dev.set_next_event = omap2_gp_timer_set_next_event;
+	clkevt->dev.set_state_shutdown = omap2_gp_timer_shutdown;
+	clkevt->dev.set_state_periodic = omap2_gp_timer_set_periodic;
+	clkevt->dev.set_state_oneshot = omap2_gp_timer_shutdown;
+	clkevt->dev.tick_resume = omap2_gp_timer_shutdown;
 
 	/*
 	 * For clock-event timers we never read the timer counter and
 	 * so we are not impacted by errata i103 and i767. Therefore,
 	 * we can safely ignore this errata for clock-event timers.
 	 */
-	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
+	__omap_dm_timer_override_errata(timer, OMAP_TIMER_ERRATA_I103_I767);
 
-	res = omap_dm_timer_init_one(&clkev, fck_source, property,
-				     &clockevent_gpt.name, OMAP_TIMER_POSTED);
+	res = omap_dm_timer_init_one(timer, fck_source, property,
+				     &clkevt->dev.name, OMAP_TIMER_POSTED);
 	BUG_ON(res);
 
-	if (request_irq(clkev.irq, omap2_gp_timer_interrupt,
-			IRQF_TIMER | IRQF_IRQPOLL, "gp_timer", &clkev))
-		pr_err("Failed to request irq %d (gp_timer)\n", clkev.irq);
-
-	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
-
-	clockevent_gpt.cpumask = cpu_possible_mask;
-	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
-	clockevents_config_and_register(&clockevent_gpt, clkev.rate,
+	clkevt->dev.cpumask = cpu_possible_mask;
+	clkevt->dev.irq = omap_dm_timer_get_irq(timer);
+
+	if (request_irq(timer->irq, omap2_gp_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "gp_timer", clkevt))
+		pr_err("Failed to request irq %d (gp_timer)\n", timer->irq);
+
+	__omap_dm_timer_int_enable(timer, OMAP_TIMER_INT_OVERFLOW);
+
+	clockevents_config_and_register(&clkevt->dev, timer->rate,
 					3, /* Timer internal resynch latency */
 					0xffffffff);
 
 	if (soc_is_am33xx() || soc_is_am43xx()) {
-		clockevent_gpt.suspend = omap_clkevt_idle;
-		clockevent_gpt.resume = omap_clkevt_unidle;
+		clkevt->dev.suspend = omap_clkevt_idle;
+		clkevt->dev.resume = omap_clkevt_unidle;
 
 		clockevent_gpt_hwmod =
-			omap_hwmod_lookup(clockevent_gpt.name);
+			omap_hwmod_lookup(clkevt->dev.name);
 	}
 
-	pr_info("OMAP clockevent source: %s at %lu Hz\n", clockevent_gpt.name,
-		clkev.rate);
+	pr_info("OMAP clockevent source: %s at %lu Hz\n", clkevt->dev.name,
+		timer->rate);
 }
 
 /* Clocksource code */


