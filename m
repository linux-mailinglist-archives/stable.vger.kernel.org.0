Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4507C5C0384
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiIUQG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiIUQFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BAB3F31C;
        Wed, 21 Sep 2022 08:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 772BE63176;
        Wed, 21 Sep 2022 15:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6FC433D6;
        Wed, 21 Sep 2022 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775615;
        bh=QU8P21MuAyq1H6RBQVtU3ITuaSUzlij2SD4xr4QQmzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RS9XxNVaehHfTtZ6qG9gfFvp8TVd4009nXknORT6xp1Ntuy4zvai4b3gEYqZW7xPn
         ZlaH8Bn/poJmME3FMZoSfffClN2HRQgf34KjskbljNBgMqtjppqpW0Pry1LM9eOgw5
         GL+GgyYh3+iaDYbjM0RK7jfpJXyljEuIn9vmlOrHmLY2223xGx/ojINd/jV8+INCxd
         kfLYAuNjM6GD/YWl9JUhBSYI2qOonS9oPExTV+eR8bywlEUWe1L6xBVgdbT6N3yGrD
         EZ+qKse7UzOP2veaY77KLx9YCawTBRDENXjPwCOhW6ZDltd4XH4rXT7YH0p5fzTIO5
         7z+dCbWj2KfCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linusw@kernel.org,
        kaloz@openwrt.org, khalasa@piap.pl,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 05/16] gpio: ixp4xx: Make irqchip immutable
Date:   Wed, 21 Sep 2022 11:53:21 -0400
Message-Id: <20220921155332.234913-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155332.234913-1-sashal@kernel.org>
References: <20220921155332.234913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]

This turns the IXP4xx GPIO irqchip into an immutable
irqchip, a bit different from the standard template due
to being hierarchical.

Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
for a rootfs on compact flash with IRQs from this GPIO
block to the CF ATA controller.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ixp4xx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-ixp4xx.c b/drivers/gpio/gpio-ixp4xx.c
index 312309be0287..56656fb519f8 100644
--- a/drivers/gpio/gpio-ixp4xx.c
+++ b/drivers/gpio/gpio-ixp4xx.c
@@ -63,6 +63,14 @@ static void ixp4xx_gpio_irq_ack(struct irq_data *d)
 	__raw_writel(BIT(d->hwirq), g->base + IXP4XX_REG_GPIS);
 }
 
+static void ixp4xx_gpio_mask_irq(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+
+	irq_chip_mask_parent(d);
+	gpiochip_disable_irq(gc, d->hwirq);
+}
+
 static void ixp4xx_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -72,6 +80,7 @@ static void ixp4xx_gpio_irq_unmask(struct irq_data *d)
 	if (!(g->irq_edge & BIT(d->hwirq)))
 		ixp4xx_gpio_irq_ack(d);
 
+	gpiochip_enable_irq(gc, d->hwirq);
 	irq_chip_unmask_parent(d);
 }
 
@@ -149,12 +158,14 @@ static int ixp4xx_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	return irq_chip_set_type_parent(d, IRQ_TYPE_LEVEL_HIGH);
 }
 
-static struct irq_chip ixp4xx_gpio_irqchip = {
+static const struct irq_chip ixp4xx_gpio_irqchip = {
 	.name = "IXP4GPIO",
 	.irq_ack = ixp4xx_gpio_irq_ack,
-	.irq_mask = irq_chip_mask_parent,
+	.irq_mask = ixp4xx_gpio_mask_irq,
 	.irq_unmask = ixp4xx_gpio_irq_unmask,
 	.irq_set_type = ixp4xx_gpio_irq_set_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static int ixp4xx_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
@@ -263,7 +274,7 @@ static int ixp4xx_gpio_probe(struct platform_device *pdev)
 	g->gc.owner = THIS_MODULE;
 
 	girq = &g->gc.irq;
-	girq->chip = &ixp4xx_gpio_irqchip;
+	gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
 	girq->fwnode = g->fwnode;
 	girq->parent_domain = parent;
 	girq->child_to_parent_hwirq = ixp4xx_gpio_child_to_parent_hwirq;
-- 
2.35.1

