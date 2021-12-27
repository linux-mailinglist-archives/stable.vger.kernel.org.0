Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABCA4800A2
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhL0Prr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbhL0Ppq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDC5261119;
        Mon, 27 Dec 2021 15:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C703EC36AEA;
        Mon, 27 Dec 2021 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619945;
        bh=NQcLE8T/l9+SlGkynqIV6O6uYFUAVEJ8aSVSTD+hjLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h76VnnkJnupSDDSODsEzWoOqAvY6sppBjiaDFu8qalIjjthC3wFg8T7c+fekbMMLj
         +uAoWY4wf3f1Pd1CpY27k1LP5461d+Iutk7H+hntLmRNBAzMhuyPfHbbw9mxxWGc3T
         glSMaMGHXBTaJrV/O2sgJGNWn5+8czdFBEN44Xsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 092/128] gpio: dln2: Fix interrupts when replugging the device
Date:   Mon, 27 Dec 2021 16:31:07 +0100
Message-Id: <20211227151334.587595100@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

commit 9a5875f14b0e3a13ae314883f1bb72b7f31fac07 upstream.

When replugging the device the following message shows up:

gpio gpiochip2: (dln2): detected irqchip that is shared with multiple gpiochips: please fix the driver.

This also has the effect that interrupts won't work.
The same problem would also show up if multiple devices where plugged in.

Fix this by allocating the irq_chip data structure per instance like other
drivers do.

I don't know when this problem appeared, but it is present in 5.10.

Cc: <stable@vger.kernel.org> # 5.10+
Cc: Daniel Baluta <daniel.baluta@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-dln2.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/gpio/gpio-dln2.c
+++ b/drivers/gpio/gpio-dln2.c
@@ -46,6 +46,7 @@
 struct dln2_gpio {
 	struct platform_device *pdev;
 	struct gpio_chip gpio;
+	struct irq_chip irqchip;
 
 	/*
 	 * Cache pin direction to save us one transfer, since the hardware has
@@ -383,15 +384,6 @@ static void dln2_irq_bus_unlock(struct i
 	mutex_unlock(&dln2->irq_lock);
 }
 
-static struct irq_chip dln2_gpio_irqchip = {
-	.name = "dln2-irq",
-	.irq_mask = dln2_irq_mask,
-	.irq_unmask = dln2_irq_unmask,
-	.irq_set_type = dln2_irq_set_type,
-	.irq_bus_lock = dln2_irq_bus_lock,
-	.irq_bus_sync_unlock = dln2_irq_bus_unlock,
-};
-
 static void dln2_gpio_event(struct platform_device *pdev, u16 echo,
 			    const void *data, int len)
 {
@@ -473,8 +465,15 @@ static int dln2_gpio_probe(struct platfo
 	dln2->gpio.direction_output = dln2_gpio_direction_output;
 	dln2->gpio.set_config = dln2_gpio_set_config;
 
+	dln2->irqchip.name = "dln2-irq",
+	dln2->irqchip.irq_mask = dln2_irq_mask,
+	dln2->irqchip.irq_unmask = dln2_irq_unmask,
+	dln2->irqchip.irq_set_type = dln2_irq_set_type,
+	dln2->irqchip.irq_bus_lock = dln2_irq_bus_lock,
+	dln2->irqchip.irq_bus_sync_unlock = dln2_irq_bus_unlock,
+
 	girq = &dln2->gpio.irq;
-	girq->chip = &dln2_gpio_irqchip;
+	girq->chip = &dln2->irqchip;
 	/* The event comes from the outside so no parent handler */
 	girq->parent_handler = NULL;
 	girq->num_parents = 0;


