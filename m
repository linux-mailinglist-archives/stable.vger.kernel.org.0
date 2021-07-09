Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81A83C24C8
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhGINZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232793AbhGINYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD44611B0;
        Fri,  9 Jul 2021 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836928;
        bh=6oQVXFeIvmrA2ziujFxfgTSpUT1DmARUpi0laEJoKRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k8C2vWLwtwJu9X6F9INuW3Fy1HzLviGBigdvMCJbAw1GEA+MUH0YluRHcEtvflb1
         NXr0AEbkufczGXEgviM77BZNP/brQOpO+1kX8C0KNrmpO4+9kdG6NN33E/xcl7EKjs
         f0c3zjKBlsFVxdiPjayZXg5QvpnQvSrX56IqcDjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 34/34] clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940
Date:   Fri,  9 Jul 2021 15:20:50 +0200
Message-Id: <20210709131703.070627814@linuxfoundation.org>
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

commit 25de4ce5ed02994aea8bc111d133308f6fd62566 upstream.

There is a timer wrap issue on dra7 for the ARM architected timer.
In a typical clock configuration the timer fails to wrap after 388 days.

To work around the issue, we need to use timer-ti-dm percpu timers instead.

Let's configure dmtimer3 and 4 as percpu timers by default, and warn about
the issue if the dtb is not configured properly.

For more information, please see the errata for "AM572x Sitara Processors
Silicon Revisions 1.1, 2.0":

https://www.ti.com/lit/er/sprz429m/sprz429m.pdf

The concept is based on earlier reference patches done by Tero Kristo and
Keerthy.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
[tony@atomide.com: backported to 4.19.y]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/dra7.dtsi         |   11 +++++++
 arch/arm/mach-omap2/board-generic.c |    4 +-
 arch/arm/mach-omap2/timer.c         |   53 +++++++++++++++++++++++++++++++++++-
 drivers/clk/ti/clk-7xx.c            |    1 
 include/linux/cpuhotplug.h          |    1 
 5 files changed, 67 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -48,6 +48,7 @@
 
 	timer {
 		compatible = "arm,armv7-timer";
+		status = "disabled";	/* See ARM architected timer wrap erratum i940 */
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
@@ -910,6 +911,8 @@
 			reg = <0x48032000 0x80>;
 			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer2";
+			clock-names = "fck";
+			clocks = <&l4per_clkctrl DRA7_TIMER2_CLKCTRL 24>;
 		};
 
 		timer3: timer@48034000 {
@@ -917,6 +920,10 @@
 			reg = <0x48034000 0x80>;
 			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer3";
+			clock-names = "fck";
+			clocks = <&l4per_clkctrl DRA7_TIMER3_CLKCTRL 24>;
+			assigned-clocks = <&l4per_clkctrl DRA7_TIMER3_CLKCTRL 24>;
+			assigned-clock-parents = <&timer_sys_clk_div>;
 		};
 
 		timer4: timer@48036000 {
@@ -924,6 +931,10 @@
 			reg = <0x48036000 0x80>;
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer4";
+			clock-names = "fck";
+			clocks = <&l4per_clkctrl DRA7_TIMER4_CLKCTRL 24>;
+			assigned-clocks = <&l4per_clkctrl DRA7_TIMER4_CLKCTRL 24>;
+			assigned-clock-parents = <&timer_sys_clk_div>;
 		};
 
 		timer5: timer@48820000 {
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -330,7 +330,7 @@ DT_MACHINE_START(DRA74X_DT, "Generic DRA
 	.init_late	= dra7xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
-	.init_time	= omap5_realtime_timer_init,
+	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= dra74x_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
@@ -353,7 +353,7 @@ DT_MACHINE_START(DRA72X_DT, "Generic DRA
 	.init_late	= dra7xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
-	.init_time	= omap5_realtime_timer_init,
+	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= dra72x_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -42,6 +42,7 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/dmtimer-omap.h>
 #include <linux/sched_clock.h>
+#include <linux/cpu.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
@@ -421,6 +422,53 @@ static void __init dmtimer_clkevt_init_c
 		timer->rate);
 }
 
+static DEFINE_PER_CPU(struct dmtimer_clockevent, dmtimer_percpu_timer);
+
+static int omap_gptimer_starting_cpu(unsigned int cpu)
+{
+	struct dmtimer_clockevent *clkevt = per_cpu_ptr(&dmtimer_percpu_timer, cpu);
+	struct clock_event_device *dev = &clkevt->dev;
+	struct omap_dm_timer *timer = &clkevt->timer;
+
+	clockevents_config_and_register(dev, timer->rate, 3, ULONG_MAX);
+	irq_force_affinity(dev->irq, cpumask_of(cpu));
+
+	return 0;
+}
+
+static int __init dmtimer_percpu_quirk_init(void)
+{
+	struct dmtimer_clockevent *clkevt;
+	struct clock_event_device *dev;
+	struct device_node *arm_timer;
+	struct omap_dm_timer *timer;
+	int cpu = 0;
+
+	arm_timer = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
+	if (of_device_is_available(arm_timer)) {
+		pr_warn_once("ARM architected timer wrap issue i940 detected\n");
+		return 0;
+	}
+
+	for_each_possible_cpu(cpu) {
+		clkevt = per_cpu_ptr(&dmtimer_percpu_timer, cpu);
+		dev = &clkevt->dev;
+		timer = &clkevt->timer;
+
+		dmtimer_clkevt_init_common(clkevt, 0, "timer_sys_ck",
+					   CLOCK_EVT_FEAT_ONESHOT,
+					   cpumask_of(cpu),
+					   "assigned-clock-parents",
+					   500, "percpu timer");
+	}
+
+	cpuhp_setup_state(CPUHP_AP_OMAP_DM_TIMER_STARTING,
+			  "clockevents/omap/gptimer:starting",
+			  omap_gptimer_starting_cpu, NULL);
+
+	return 0;
+}
+
 /* Clocksource code */
 static struct omap_dm_timer clksrc;
 static bool use_gptimer_clksrc __initdata;
@@ -565,6 +613,9 @@ static void __init __omap_sync32k_timer_
 					3, /* Timer internal resynch latency */
 					0xffffffff);
 
+	if (soc_is_dra7xx())
+		dmtimer_percpu_quirk_init();
+
 	/* Enable the use of clocksource="gp_timer" kernel parameter */
 	if (use_gptimer_clksrc || gptimer)
 		omap2_gptimer_clocksource_init(clksrc_nr, clksrc_src,
@@ -592,7 +643,7 @@ void __init omap3_secure_sync32k_timer_i
 #endif /* CONFIG_ARCH_OMAP3 */
 
 #if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM33XX) || \
-	defined(CONFIG_SOC_AM43XX)
+	defined(CONFIG_SOC_AM43XX) || defined(CONFIG_SOC_DRA7XX)
 void __init omap3_gptimer_timer_init(void)
 {
 	__omap_sync32k_timer_init(2, "timer_sys_ck", NULL,
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -733,6 +733,7 @@ const struct omap_clkctrl_data dra7_clkc
 static struct ti_dt_clk dra7xx_clks[] = {
 	DT_CLK(NULL, "timer_32k_ck", "sys_32k_ck"),
 	DT_CLK(NULL, "sys_clkin_ck", "timer_sys_clk_div"),
+	DT_CLK(NULL, "timer_sys_ck", "timer_sys_clk_div"),
 	DT_CLK(NULL, "sys_clkin", "sys_clkin1"),
 	DT_CLK(NULL, "atl_dpll_clk_mux", "atl_cm:0000:24"),
 	DT_CLK(NULL, "atl_gfclk_mux", "atl_cm:0000:26"),
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -118,6 +118,7 @@ enum cpuhp_state {
 	CPUHP_AP_ARM_L2X0_STARTING,
 	CPUHP_AP_EXYNOS4_MCT_TIMER_STARTING,
 	CPUHP_AP_ARM_ARCH_TIMER_STARTING,
+	CPUHP_AP_OMAP_DM_TIMER_STARTING,
 	CPUHP_AP_ARM_GLOBAL_TIMER_STARTING,
 	CPUHP_AP_JCORE_TIMER_STARTING,
 	CPUHP_AP_ARM_TWD_STARTING,


