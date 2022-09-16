Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6BE5BAB36
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiIPK1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiIPKZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:25:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EAFB2864;
        Fri, 16 Sep 2022 03:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB89F629BF;
        Fri, 16 Sep 2022 10:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3807C433C1;
        Fri, 16 Sep 2022 10:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323283;
        bh=HYhtkwwo7AXpZl8NqXh8rk9kEhQGoU232AMTAXyIbDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWOPONhfed2LjSfgcSm32ICn2vi7/HpQtbZFMpxkLlzOLrsLJTqxltQVFU5k+/TZe
         w6Df2k6pRJaDVvo5Pm4ETbUUWng78mvTlWN9mx5g8uS9rD/8TDopg3qI5PbvGfIsM/
         Mfy+DRElM+b5h0Ekm4URmPakZVg5rmPRW83vnkJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 35/38] gpio: 104-dio-48e: Make irq_chip immutable
Date:   Fri, 16 Sep 2022 12:09:09 +0200
Message-Id: <20220916100449.936955484@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



