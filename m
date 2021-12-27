Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2623547FFDA
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhL0PlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbhL0PkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB73CC0698D7;
        Mon, 27 Dec 2021 07:38:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AA91CE10E6;
        Mon, 27 Dec 2021 15:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3EBC36AE7;
        Mon, 27 Dec 2021 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619514;
        bh=LXeNJR/gvMrcWYBQng99m4jdj9N3l92Xj5JnzgzdHGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nn6QBBY8xbpdhdoGON/JxbGgA27+8qDr62TXT066vj6SsjScv7sANxX1Pd8p8iQwC
         JQF34QauJEwJHfF8NPICVvgINbtE30+5Z1bar3QcqnsDKRFIsRF10ygdIUbjcZ0qPl
         y8Jo0ORffRXmTFgNpjAbXeoJWxrQXluir0nqL/8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.10 51/76] gpio: dln2: Fix interrupts when replugging the device
Date:   Mon, 27 Dec 2021 16:31:06 +0100
Message-Id: <20211227151326.464030393@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
@@ -477,8 +469,15 @@ static int dln2_gpio_probe(struct platfo
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


