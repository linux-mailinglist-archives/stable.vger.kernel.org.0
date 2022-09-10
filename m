Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8A5B498D
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiIJVVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiIJVUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF54E4BD00;
        Sat, 10 Sep 2022 14:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF781B8094C;
        Sat, 10 Sep 2022 21:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFE1C43141;
        Sat, 10 Sep 2022 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844670;
        bh=HYhtkwwo7AXpZl8NqXh8rk9kEhQGoU232AMTAXyIbDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6l4ffyocpB5Xx43l1WFnFiDk0zknxPg7ET/O+fK9CfMx/Ts+1ttHGfYdaWivJt6P
         ARrb461ccshOF/QKUQaB+hZTzchHxxTQDoQyvtBzz8tSnjhxYnizQL5CZf1PHd8wWr
         vVeNpAh1qYzNGGF8q4Do0yA4LNFdaFXtwfah34MVmKCEKR+W/V3igPB13TELjvgWhO
         5Txc2OI0yT5vz9LF09s18U9jc4X1/obspKDNb+3nKJwVjodlUAmBXgBVSN6rOqr27f
         a0Q94H6J2qC0W2uJwm023Pu53oJD19Iu63h6CrJpX9d5L+SZ8UlVdMLRyA2fZdH+JI
         hsAzhsROcsxzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Breathitt Gray <william.gray@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 37/38] gpio: 104-dio-48e: Make irq_chip immutable
Date:   Sat, 10 Sep 2022 17:16:22 -0400
Message-Id: <20220910211623.69825-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 35f0aa7727b092520bf91374768a4fdafd4a4fe3 ]

Kernel warns about mutable irq_chips:

    "not an immutable chip, please consider fixing!"

Make the struct irq_chip const, flag it as IRQCHIP_IMMUTABLE, add the
new helper functions, and call the appropriate gpiolib functions.

Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-104-dio-48e.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-104-dio-48e.c b/drivers/gpio/gpio-104-dio-48e.c
index f118ad9bcd33d..0e95351d47d49 100644
--- a/drivers/gpio/gpio-104-dio-48e.c
+++ b/drivers/gpio/gpio-104-dio-48e.c
@@ -271,6 +271,7 @@ static void dio48e_irq_mask(struct irq_data *data)
 		dio48egpio->irq_mask &= ~BIT(0);
 	else
 		dio48egpio->irq_mask &= ~BIT(1);
+	gpiochip_disable_irq(chip, offset);
 
 	if (!dio48egpio->irq_mask)
 		/* disable interrupts */
@@ -298,6 +299,7 @@ static void dio48e_irq_unmask(struct irq_data *data)
 		iowrite8(0x00, dio48egpio->base + 0xB);
 	}
 
+	gpiochip_enable_irq(chip, offset);
 	if (offset == 19)
 		dio48egpio->irq_mask |= BIT(0);
 	else
@@ -320,12 +322,14 @@ static int dio48e_irq_set_type(struct irq_data *data, unsigned int flow_type)
 	return 0;
 }
 
-static struct irq_chip dio48e_irqchip = {
+static const struct irq_chip dio48e_irqchip = {
 	.name = "104-dio-48e",
 	.irq_ack = dio48e_irq_ack,
 	.irq_mask = dio48e_irq_mask,
 	.irq_unmask = dio48e_irq_unmask,
-	.irq_set_type = dio48e_irq_set_type
+	.irq_set_type = dio48e_irq_set_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static irqreturn_t dio48e_irq_handler(int irq, void *dev_id)
@@ -414,7 +418,7 @@ static int dio48e_probe(struct device *dev, unsigned int id)
 	dio48egpio->chip.set_multiple = dio48e_gpio_set_multiple;
 
 	girq = &dio48egpio->chip.irq;
-	girq->chip = &dio48e_irqchip;
+	gpio_irq_chip_set_chip(girq, &dio48e_irqchip);
 	/* This will let us handle the parent IRQ in the driver */
 	girq->parent_handler = NULL;
 	girq->num_parents = 0;
-- 
2.35.1

