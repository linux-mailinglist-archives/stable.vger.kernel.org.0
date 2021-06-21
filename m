Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FCF3AEDF8
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFUQYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhFUQW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C947613B0;
        Mon, 21 Jun 2021 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292421;
        bh=Igcd6qF2Vx5ZRAwC1p8bwMQB5ccpBfN9r6Sk0XEbGTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOrTOQ/ywBfgZTcsY39ooRN+YVqihhRVAW8azyYJlhaw7Knor1ANI0DrdJVEPcQDg
         vUxTFFmP5gLWqf4oM+I+ILFbXbbTn/46D3XCEJ35eHRLXBsaqDoANpgY9UeRAGSXh1
         jv/CWuigoZ5Sm+bg5ie1mPrATqzqk7/OhqWkNfpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 85/90] ARM: OMAP: replace setup_irq() by request_irq()
Date:   Mon, 21 Jun 2021 18:16:00 +0200
Message-Id: <20210621154907.033088532@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap1/pm.c       |   13 ++++++-------
 arch/arm/mach-omap1/time.c     |   10 +++-------
 arch/arm/mach-omap1/timer32k.c |   10 +++-------
 arch/arm/mach-omap2/timer.c    |   11 +++--------
 4 files changed, 15 insertions(+), 29 deletions(-)

--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -596,11 +596,6 @@ static irqreturn_t omap_wakeup_interrupt
 	return IRQ_HANDLED;
 }
 
-static struct irqaction omap_wakeup_irq = {
-	.name		= "peripheral wakeup",
-	.handler	= omap_wakeup_interrupt
-};
-
 
 
 static const struct platform_suspend_ops omap_pm_ops = {
@@ -613,6 +608,7 @@ static const struct platform_suspend_ops
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
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -155,15 +155,11 @@ static irqreturn_t omap_mpu_timer1_inter
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
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -148,15 +148,11 @@ static irqreturn_t omap_32k_timer_interr
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
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -91,12 +91,6 @@ static irqreturn_t omap2_gp_timer_interr
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
@@ -382,8 +376,9 @@ static void __init omap2_gp_clockevent_i
 				     &clockevent_gpt.name, OMAP_TIMER_POSTED);
 	BUG_ON(res);
 
-	omap2_gp_timer_irq.dev_id = &clkev;
-	setup_irq(clkev.irq, &omap2_gp_timer_irq);
+	if (request_irq(clkev.irq, omap2_gp_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "gp_timer", &clkev))
+		pr_err("Failed to request irq %d (gp_timer)\n", clkev.irq);
 
 	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
 


