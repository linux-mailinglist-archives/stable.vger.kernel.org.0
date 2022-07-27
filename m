Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3AC582C91
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbiG0Qrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiG0Qq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC9E52DE8;
        Wed, 27 Jul 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B3161A38;
        Wed, 27 Jul 2022 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8866EC43140;
        Wed, 27 Jul 2022 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939514;
        bh=vwzwNt4ul+AgIGUNeXSUEgqaNzRM2r3gbj8uZzIo1Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRgolFAT1cfDb5sqMYssTCvoPlccsNAfhj/fxbK6UKtoOo1IzqvPcBF19d+1AYojf
         SsFjOCeu94vbppBavW1XrOoCem3PocxsMMAmq0uM5n6YnqNiWJt9zXn/ad8Y1Qcm97
         vW6e7wEZZZQ/W/npSBFXt+HobFuTT1gbc5pH91hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 001/105] pinctrl: stm32: fix optional IRQ support to gpios
Date:   Wed, 27 Jul 2022 18:09:47 +0200
Message-Id: <20220727161012.124212010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@foss.st.com>

commit a1d4ef1adf8bbd302067534ead671a94759687ed upstream.

To act as an interrupt controller, a gpio bank relies on the
"interrupt-parent" of the pin controller.
When this optional "interrupt-parent" misses, do not create any IRQ domain.

This fixes a "NULL pointer in stm32_gpio_domain_alloc()" kernel crash when
the interrupt-parent = <exti> property is not declared in the Device Tree.

Fixes: 0eb9f683336d ("pinctrl: Add IRQ support to STM32 gpios")
Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
Link: https://lore.kernel.org/r/20220627142350.742973-1-fabien.dessenne@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)


--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1303,15 +1303,17 @@ static int stm32_gpiolib_register_bank(s
 	bank->bank_ioport_nr = bank_ioport_nr;
 	spin_lock_init(&bank->lock);
 
-	/* create irq hierarchical domain */
-	bank->fwnode = of_node_to_fwnode(np);
+	if (pctl->domain) {
+		/* create irq hierarchical domain */
+		bank->fwnode = of_node_to_fwnode(np);
+
+		bank->domain = irq_domain_create_hierarchy(pctl->domain, 0, STM32_GPIO_IRQ_LINE,
+							   bank->fwnode, &stm32_gpio_domain_ops,
+							   bank);
 
-	bank->domain = irq_domain_create_hierarchy(pctl->domain, 0,
-					STM32_GPIO_IRQ_LINE, bank->fwnode,
-					&stm32_gpio_domain_ops, bank);
-
-	if (!bank->domain)
-		return -ENODEV;
+		if (!bank->domain)
+			return -ENODEV;
+	}
 
 	err = gpiochip_add_data(&bank->gpio_chip, bank);
 	if (err) {
@@ -1481,6 +1483,8 @@ int stm32_pctl_probe(struct platform_dev
 	pctl->domain = stm32_pctrl_get_irq_domain(np);
 	if (IS_ERR(pctl->domain))
 		return PTR_ERR(pctl->domain);
+	if (!pctl->domain)
+		dev_warn(dev, "pinctrl without interrupt support\n");
 
 	/* hwspinlock is optional */
 	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);


