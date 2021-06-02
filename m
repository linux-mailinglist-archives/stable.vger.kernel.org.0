Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83FD3986E1
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 12:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhFBKsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 06:48:53 -0400
Received: from muru.com ([72.249.23.125]:35432 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFBKsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 06:48:33 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 5A6F68150;
        Wed,  2 Jun 2021 10:46:56 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: [Backport for linux-5.4.y PATCH 4/4] ARM: OMAP2+: Handle dra7 timer wrap errata i940
Date:   Wed,  2 Jun 2021 13:46:25 +0300
Message-Id: <20210602104625.6079-4-tony@atomide.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602104625.6079-1-tony@atomide.com>
References: <20210602104625.6079-1-tony@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 25de4ce5ed02994aea8bc111d133308f6fd62566 backported to
stable linux-5.4.y mach-omap2/timer instead of drivers/clocksource as
earlier kernels still depend on legacy platform code for timers. Note
that earlier stable kernels need also additional patches and will be
posted separately.

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
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/boot/dts/dra7-l4.dtsi      |  4 +--
 arch/arm/boot/dts/dra7.dtsi         | 20 +++++++++++
 arch/arm/mach-omap2/board-generic.c |  4 +--
 arch/arm/mach-omap2/timer.c         | 53 ++++++++++++++++++++++++++++-
 drivers/clk/ti/clk-7xx.c            |  1 +
 include/linux/cpuhotplug.h          |  1 +
 6 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -1176,7 +1176,7 @@
 			};
 		};
 
-		target-module@34000 {			/* 0x48034000, ap 7 46.0 */
+		timer3_target: target-module@34000 {	/* 0x48034000, ap 7 46.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			ti,hwmods = "timer3";
 			reg = <0x34000 0x4>,
@@ -1204,7 +1204,7 @@
 			};
 		};
 
-		target-module@36000 {			/* 0x48036000, ap 9 4e.0 */
+		timer4_target: target-module@36000 {	/* 0x48036000, ap 9 4e.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			ti,hwmods = "timer4";
 			reg = <0x36000 0x4>,
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -46,6 +46,7 @@
 
 	timer {
 		compatible = "arm,armv7-timer";
+		status = "disabled";	/* See ARM architected timer wrap erratum i940 */
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
@@ -766,3 +767,22 @@
 
 #include "dra7-l4.dtsi"
 #include "dra7xx-clocks.dtsi"
+
+/* Local timers, see ARM architected timer wrap erratum i940 */
+&timer3_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		assigned-clocks = <&l4per_clkctrl DRA7_L4PER_TIMER3_CLKCTRL 24>;
+		assigned-clock-parents = <&timer_sys_clk_div>;
+	};
+};
+
+&timer4_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		assigned-clocks = <&l4per_clkctrl DRA7_L4PER_TIMER4_CLKCTRL 24>;
+		assigned-clock-parents = <&timer_sys_clk_div>;
+	};
+};
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -327,7 +327,7 @@ DT_MACHINE_START(DRA74X_DT, "Generic DRA74X (Flattened Device Tree)")
 	.init_late	= dra7xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
-	.init_time	= omap5_realtime_timer_init,
+	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= dra74x_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
@@ -350,7 +350,7 @@ DT_MACHINE_START(DRA72X_DT, "Generic DRA72X (Flattened Device Tree)")
 	.init_late	= dra7xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
-	.init_time	= omap5_realtime_timer_init,
+	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= dra72x_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -42,6 +42,7 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/dmtimer-omap.h>
 #include <linux/sched_clock.h>
+#include <linux/cpu.h>
 
 #include <asm/mach/time.h>
 
@@ -420,6 +421,53 @@ static void __init dmtimer_clkevt_init_common(struct dmtimer_clockevent *clkevt,
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
@@ -564,6 +612,9 @@ static void __init __omap_sync32k_timer_init(int clkev_nr, const char *clkev_src
 					3, /* Timer internal resynch latency */
 					0xffffffff);
 
+	if (soc_is_dra7xx())
+		dmtimer_percpu_quirk_init();
+
 	/* Enable the use of clocksource="gp_timer" kernel parameter */
 	if (use_gptimer_clksrc || gptimer)
 		omap2_gptimer_clocksource_init(clksrc_nr, clksrc_src,
@@ -591,7 +642,7 @@ void __init omap3_secure_sync32k_timer_init(void)
 #endif /* CONFIG_ARCH_OMAP3 */
 
 #if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM33XX) || \
-	defined(CONFIG_SOC_AM43XX)
+	defined(CONFIG_SOC_AM43XX) || defined(CONFIG_SOC_DRA7XX)
 void __init omap3_gptimer_timer_init(void)
 {
 	__omap_sync32k_timer_init(2, "timer_sys_ck", NULL,
diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -793,6 +793,7 @@ static struct ti_dt_clk dra7xx_clks[] = {
 	DT_CLK(NULL, "timer_32k_ck", "sys_32k_ck"),
 	DT_CLK(NULL, "sys_clkin_ck", "timer_sys_clk_div"),
 	DT_CLK(NULL, "sys_clkin", "sys_clkin1"),
+	DT_CLK(NULL, "timer_sys_ck", "timer_sys_clk_div"),
 	DT_CLK(NULL, "atl_dpll_clk_mux", "atl-clkctrl:0000:24"),
 	DT_CLK(NULL, "atl_gfclk_mux", "atl-clkctrl:0000:26"),
 	DT_CLK(NULL, "dcan1_sys_clk_mux", "wkupaon-clkctrl:0068:24"),
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -119,6 +119,7 @@ enum cpuhp_state {
 	CPUHP_AP_ARM_L2X0_STARTING,
 	CPUHP_AP_EXYNOS4_MCT_TIMER_STARTING,
 	CPUHP_AP_ARM_ARCH_TIMER_STARTING,
+	CPUHP_AP_OMAP_DM_TIMER_STARTING,
 	CPUHP_AP_ARM_GLOBAL_TIMER_STARTING,
 	CPUHP_AP_JCORE_TIMER_STARTING,
 	CPUHP_AP_ARM_TWD_STARTING,
-- 
2.31.1
