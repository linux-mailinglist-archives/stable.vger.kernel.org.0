Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F003826CA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhEQIYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:24:22 -0400
Received: from muru.com ([72.249.23.125]:56528 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhEQIYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 04:24:22 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id EB3F180BA;
        Mon, 17 May 2021 08:23:09 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [Backport for linux-5.10.y PATCH 2/2] clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940
Date:   Mon, 17 May 2021 11:22:44 +0300
Message-Id: <20210517082244.17447-2-tony@atomide.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517082244.17447-1-tony@atomide.com>
References: <20210517082244.17447-1-tony@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 25de4ce5ed02994aea8bc111d133308f6fd62566 for stable
linux-5.10.y. Depends on backported upstream commit
3efe7a878a11c13b5297057bfc1e5639ce1241ce.

There is a timer wrap issue on dra7 for the ARM architected timer.
In a typical clock configuration the timer fails to wrap after 388 days.

To work around the issue, we need to use timer-ti-dm percpu timers instead.

Let's configure dmtimer3 and 4 as percpu timers by default, and warn about
the issue if the dtb is not configured properly.

Let's do this as a single patch so it can be backported to v5.8 and later
kernels easily. Note that this patch depends on earlier timer-ti-dm
systimer posted mode fixes, and a preparatory clockevent patch
"clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue".

For more information, please see the errata for "AM572x Sitara Processors
Silicon Revisions 1.1, 2.0":

https://www.ti.com/lit/er/sprz429m/sprz429m.pdf

The concept is based on earlier reference patches done by Tero Kristo and
Keerthy.

Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210323074326.28302-3-tony@atomide.com
---
 arch/arm/boot/dts/dra7-l4.dtsi             |  4 +-
 arch/arm/boot/dts/dra7.dtsi                | 20 ++++++
 drivers/clocksource/timer-ti-dm-systimer.c | 76 ++++++++++++++++++++++
 include/linux/cpuhotplug.h                 |  1 +
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -1168,7 +1168,7 @@ timer2: timer@0 {
 			};
 		};
 
-		target-module@34000 {			/* 0x48034000, ap 7 46.0 */
+		timer3_target: target-module@34000 {	/* 0x48034000, ap 7 46.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			reg = <0x34000 0x4>,
 			      <0x34010 0x4>;
@@ -1195,7 +1195,7 @@ timer3: timer@0 {
 			};
 		};
 
-		target-module@36000 {			/* 0x48036000, ap 9 4e.0 */
+		timer4_target: target-module@36000 {	/* 0x48036000, ap 9 4e.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			reg = <0x36000 0x4>,
 			      <0x36010 0x4>;
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -46,6 +46,7 @@ aliases {
 
 	timer {
 		compatible = "arm,armv7-timer";
+		status = "disabled";	/* See ARM architected timer wrap erratum i940 */
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
@@ -1090,3 +1091,22 @@ timer@0 {
 		assigned-clock-parents = <&sys_32k_ck>;
 	};
 };
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
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -2,6 +2,7 @@
 #include <linux/clk.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/cpuhotplug.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -630,6 +631,78 @@ static int __init dmtimer_clockevent_init(struct device_node *np)
 	return error;
 }
 
+/* Dmtimer as percpu timer. See dra7 ARM architected timer wrap erratum i940 */
+static DEFINE_PER_CPU(struct dmtimer_clockevent, dmtimer_percpu_timer);
+
+static int __init dmtimer_percpu_timer_init(struct device_node *np, int cpu)
+{
+	struct dmtimer_clockevent *clkevt;
+	int error;
+
+	if (!cpu_possible(cpu))
+		return -EINVAL;
+
+	if (!of_property_read_bool(np->parent, "ti,no-reset-on-init") ||
+	    !of_property_read_bool(np->parent, "ti,no-idle"))
+		pr_warn("Incomplete dtb for percpu dmtimer %pOF\n", np->parent);
+
+	clkevt = per_cpu_ptr(&dmtimer_percpu_timer, cpu);
+
+	error = dmtimer_clkevt_init_common(clkevt, np, CLOCK_EVT_FEAT_ONESHOT,
+					   cpumask_of(cpu), "percpu-dmtimer",
+					   500);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+/* See TRM for timer internal resynch latency */
+static int omap_dmtimer_starting_cpu(unsigned int cpu)
+{
+	struct dmtimer_clockevent *clkevt = per_cpu_ptr(&dmtimer_percpu_timer, cpu);
+	struct clock_event_device *dev = &clkevt->dev;
+	struct dmtimer_systimer *t = &clkevt->t;
+
+	clockevents_config_and_register(dev, t->rate, 3, ULONG_MAX);
+	irq_force_affinity(dev->irq, cpumask_of(cpu));
+
+	return 0;
+}
+
+static int __init dmtimer_percpu_timer_startup(void)
+{
+	struct dmtimer_clockevent *clkevt = per_cpu_ptr(&dmtimer_percpu_timer, 0);
+	struct dmtimer_systimer *t = &clkevt->t;
+
+	if (t->sysc) {
+		cpuhp_setup_state(CPUHP_AP_TI_GP_TIMER_STARTING,
+				  "clockevents/omap/gptimer:starting",
+				  omap_dmtimer_starting_cpu, NULL);
+	}
+
+	return 0;
+}
+subsys_initcall(dmtimer_percpu_timer_startup);
+
+static int __init dmtimer_percpu_quirk_init(struct device_node *np, u32 pa)
+{
+	struct device_node *arm_timer;
+
+	arm_timer = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
+	if (of_device_is_available(arm_timer)) {
+		pr_warn_once("ARM architected timer wrap issue i940 detected\n");
+		return 0;
+	}
+
+	if (pa == 0x48034000)		/* dra7 dmtimer3 */
+		return dmtimer_percpu_timer_init(np, 0);
+	else if (pa == 0x48036000)	/* dra7 dmtimer4 */
+		return dmtimer_percpu_timer_init(np, 1);
+
+	return 0;
+}
+
 /* Clocksource */
 static struct dmtimer_clocksource *
 to_dmtimer_clocksource(struct clocksource *cs)
@@ -763,6 +836,9 @@ static int __init dmtimer_systimer_init(struct device_node *np)
 	if (clockevent == pa)
 		return dmtimer_clockevent_init(np);
 
+	if (of_machine_is_compatible("ti,dra7"))
+		return dmtimer_percpu_quirk_init(np, pa);
+
 	return 0;
 }
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -135,6 +135,7 @@ enum cpuhp_state {
 	CPUHP_AP_RISCV_TIMER_STARTING,
 	CPUHP_AP_CLINT_TIMER_STARTING,
 	CPUHP_AP_CSKY_TIMER_STARTING,
+	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
-- 
2.31.1
