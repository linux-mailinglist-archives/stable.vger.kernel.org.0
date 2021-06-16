Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552FA3A9A7A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhFPMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 08:33:28 -0400
Received: from muru.com ([72.249.23.125]:46560 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231618AbhFPMd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 08:33:27 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 4F4DC80EB;
        Wed, 16 Jun 2021 12:31:28 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: [Backport for 5.4.y PATCHv2 1/4] ARM: OMAP: replace setup_irq() by request_irq()
Date:   Wed, 16 Jun 2021 15:31:09 +0300
Message-Id: <20210616123112.65068-1-tony@atomide.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: afzal mohammed <afzal.mohd.ma@gmail.com>

commit b75ca5217743e4d7076cf65e044e88389e44318d upstream.

request_irq() is preferred over setup_irq(). Invocations of setup_irq()
occur after memory allocators are ready.

Per tglx[1], setup_irq() existed in olden days when allocators were not
ready by the time early interrupts were initialized.

Hence replace setup_irq() by request_irq().

[1] https://lkml.kernel.org/r/alpine.DEB.2.20.1710191609480.1971@nanos

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Signed-off-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/pm.c       | 13 ++++++-------
 arch/arm/mach-omap1/time.c     | 10 +++-------
 arch/arm/mach-omap1/timer32k.c | 10 +++-------
 arch/arm/mach-omap2/timer.c    | 11 +++--------
 4 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -596,11 +596,6 @@ static irqreturn_t omap_wakeup_interrupt(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction omap_wakeup_irq = {
-	.name		= "peripheral wakeup",
-	.handler	= omap_wakeup_interrupt
-};
-
 
 
 static const struct platform_suspend_ops omap_pm_ops = {
@@ -613,6 +608,7 @@ static const struct platform_suspend_ops omap_pm_ops = {
 static int __init omap_pm_init(void)
 {
 	int error = 0;
+	int irq;
 
 	if (!cpu_class_is_omap1())
 		return -ENODEV;
@@ -656,9 +652,12 @@ static int __init omap_pm_init(void)
 	arm_pm_idle = omap1_pm_idle;
 
 	if (cpu_is_omap7xx())
-		setup_irq(INT_7XX_WAKE_UP_REQ, &omap_wakeup_irq);
+		irq = INT_7XX_WAKE_UP_REQ;
 	else if (cpu_is_omap16xx())
-		setup_irq(INT_1610_WAKE_UP_REQ, &omap_wakeup_irq);
+		irq = INT_1610_WAKE_UP_REQ;
+	if (request_irq(irq, omap_wakeup_interrupt, 0, "peripheral wakeup",
+			NULL))
+		pr_err("Failed to request irq %d (peripheral wakeup)\n", irq);
 
 	/* Program new power ramp-up time
 	 * (0 for most boards since we don't lower voltage when in deep sleep)
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -155,15 +155,11 @@ static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction omap_mpu_timer1_irq = {
-	.name		= "mpu_timer1",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= omap_mpu_timer1_interrupt,
-};
-
 static __init void omap_init_mpu_timer(unsigned long rate)
 {
-	setup_irq(INT_TIMER1, &omap_mpu_timer1_irq);
+	if (request_irq(INT_TIMER1, omap_mpu_timer1_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "mpu_timer1", NULL))
+		pr_err("Failed to request irq %d (mpu_timer1)\n", INT_TIMER1);
 	omap_mpu_timer_start(0, (rate / HZ) - 1, 1);
 
 	clockevent_mpu_timer1.cpumask = cpumask_of(0);
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -148,15 +148,11 @@ static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction omap_32k_timer_irq = {
-	.name		= "32KHz timer",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= omap_32k_timer_interrupt,
-};
-
 static __init void omap_init_32k_timer(void)
 {
-	setup_irq(INT_OS_TIMER, &omap_32k_timer_irq);
+	if (request_irq(INT_OS_TIMER, omap_32k_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "32KHz timer", NULL))
+		pr_err("Failed to request irq %d(32KHz timer)\n", INT_OS_TIMER);
 
 	clockevent_32k_timer.cpumask = cpumask_of(0);
 	clockevents_config_and_register(&clockevent_32k_timer,
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -91,12 +91,6 @@ static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction omap2_gp_timer_irq = {
-	.name		= "gp_timer",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= omap2_gp_timer_interrupt,
-};
-
 static int omap2_gp_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
@@ -382,8 +376,9 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 				     &clockevent_gpt.name, OMAP_TIMER_POSTED);
 	BUG_ON(res);
 
-	omap2_gp_timer_irq.dev_id = &clkev;
-	setup_irq(clkev.irq, &omap2_gp_timer_irq);
+	if (request_irq(clkev.irq, omap2_gp_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "gp_timer", &clkev))
+		pr_err("Failed to request irq %d (gp_timer)\n", clkev.irq);
 
 	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
 
-- 
2.31.1
