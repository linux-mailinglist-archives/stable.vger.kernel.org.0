Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630A1431760
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhJRLeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:34:24 -0400
Received: from asav21.altibox.net ([109.247.116.8]:41654 "EHLO
        asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhJRLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:34:23 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2021 07:34:20 EDT
Received: from localhost.localdomain (211.81-166-168.customer.lyse.net [81.166.168.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: noralf.tronnes@ebnett.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id 92D4380047;
        Mon, 18 Oct 2021 13:23:14 +0200 (CEST)
From:   =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
To:     linux-gpio@vger.kernel.org
Cc:     linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@gmail.com>
Subject: [PATCH] gpio: dln2: Fix interrupts when replugging the device
Date:   Mon, 18 Oct 2021 13:22:01 +0200
Message-Id: <20211018112201.25424-1-noralf@tronnes.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=Yr0hubQX c=1 sm=1 tr=0
        a=OYZzhG0JTxDrWp/F2OJbnw==:117 a=OYZzhG0JTxDrWp/F2OJbnw==:17
        a=IkcTkHD0fZMA:10 a=M51BFTxLslgA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=SJz97ENfAAAA:8 a=uisS6GW8JqvGFITEYyMA:9 a=QEXdDO2ut3YA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=vFet0B0WnEQeilDPIY6i:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpio/gpio-dln2.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-dln2.c b/drivers/gpio/gpio-dln2.c
index 4c5f6d0c8d74..22f11dd5210d 100644
--- a/drivers/gpio/gpio-dln2.c
+++ b/drivers/gpio/gpio-dln2.c
@@ -46,6 +46,7 @@
 struct dln2_gpio {
 	struct platform_device *pdev;
 	struct gpio_chip gpio;
+	struct irq_chip irqchip;
 
 	/*
 	 * Cache pin direction to save us one transfer, since the hardware has
@@ -383,15 +384,6 @@ static void dln2_irq_bus_unlock(struct irq_data *irqd)
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
@@ -477,8 +469,15 @@ static int dln2_gpio_probe(struct platform_device *pdev)
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
-- 
2.33.0

