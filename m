Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865E65F263E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJBWvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiJBWur (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A094183BD;
        Sun,  2 Oct 2022 15:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DADE360F10;
        Sun,  2 Oct 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8439DC43150;
        Sun,  2 Oct 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751012;
        bh=Ij9qIbVDOEwLjRKRVfWKa91KXVvfWGsn+1ZqzNaeZok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Br8dGoPBKpvPUwfipDblk5Pc/cYmX7ZaEDLG89VrSiz/pTBLwH8TbhtjOHNo3c3C0
         YKfbgbIYyfVGn2aetsjQ7OOvpwWEJBgdRu+US0m+2pUaDHQ01m1rcsfiJ5N0QEttGB
         s/rYBwS9l//KqXieCC6BxUc2evxEw26Qd1ypVaAA1+Rkm5q1C9PGmxtw9iFxkZ1Y3L
         zySubN4VLVGpX6z3jp0rU+6OJ2prchnvibZCIZzF1x5qAOV5LXkSmJRl6l7Ac4cvLZ
         4m6eYdLaqmGhtZ6fTdalyTiviw5SsaJ7/VStn8ryPw/f4z457JduHIw0Ku2W0qqr23
         YH4L6JC+4CsRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 18/29] gpio: ftgpio010: Make irqchip immutable
Date:   Sun,  2 Oct 2022 18:49:11 -0400
Message-Id: <20221002224922.238837-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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

[ Upstream commit ab637d48363d7b8ee67ae089808a8bc6051d53c4 ]

This turns the FTGPIO010 irqchip immutable.

Tested on the D-Link DIR-685.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ftgpio010.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-ftgpio010.c b/drivers/gpio/gpio-ftgpio010.c
index f422c3e129a0..f77a965f5780 100644
--- a/drivers/gpio/gpio-ftgpio010.c
+++ b/drivers/gpio/gpio-ftgpio010.c
@@ -41,14 +41,12 @@
  * struct ftgpio_gpio - Gemini GPIO state container
  * @dev: containing device for this instance
  * @gc: gpiochip for this instance
- * @irq: irqchip for this instance
  * @base: remapped I/O-memory base
  * @clk: silicon clock
  */
 struct ftgpio_gpio {
 	struct device *dev;
 	struct gpio_chip gc;
-	struct irq_chip irq;
 	void __iomem *base;
 	struct clk *clk;
 };
@@ -70,6 +68,7 @@ static void ftgpio_gpio_mask_irq(struct irq_data *d)
 	val = readl(g->base + GPIO_INT_EN);
 	val &= ~BIT(irqd_to_hwirq(d));
 	writel(val, g->base + GPIO_INT_EN);
+	gpiochip_disable_irq(gc, irqd_to_hwirq(d));
 }
 
 static void ftgpio_gpio_unmask_irq(struct irq_data *d)
@@ -78,6 +77,7 @@ static void ftgpio_gpio_unmask_irq(struct irq_data *d)
 	struct ftgpio_gpio *g = gpiochip_get_data(gc);
 	u32 val;
 
+	gpiochip_enable_irq(gc, irqd_to_hwirq(d));
 	val = readl(g->base + GPIO_INT_EN);
 	val |= BIT(irqd_to_hwirq(d));
 	writel(val, g->base + GPIO_INT_EN);
@@ -221,6 +221,16 @@ static int ftgpio_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 	return 0;
 }
 
+static const struct irq_chip ftgpio_irq_chip = {
+	.name = "FTGPIO010",
+	.irq_ack = ftgpio_gpio_ack_irq,
+	.irq_mask = ftgpio_gpio_mask_irq,
+	.irq_unmask = ftgpio_gpio_unmask_irq,
+	.irq_set_type = ftgpio_gpio_set_irq_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	 GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
 static int ftgpio_gpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -277,14 +287,8 @@ static int ftgpio_gpio_probe(struct platform_device *pdev)
 	if (!IS_ERR(g->clk))
 		g->gc.set_config = ftgpio_gpio_set_config;
 
-	g->irq.name = "FTGPIO010";
-	g->irq.irq_ack = ftgpio_gpio_ack_irq;
-	g->irq.irq_mask = ftgpio_gpio_mask_irq;
-	g->irq.irq_unmask = ftgpio_gpio_unmask_irq;
-	g->irq.irq_set_type = ftgpio_gpio_set_irq_type;
-
 	girq = &g->gc.irq;
-	girq->chip = &g->irq;
+	gpio_irq_chip_set_chip(girq, &ftgpio_irq_chip);
 	girq->parent_handler = ftgpio_gpio_irq_handler;
 	girq->num_parents = 1;
 	girq->parents = devm_kcalloc(dev, 1, sizeof(*girq->parents),
-- 
2.35.1

