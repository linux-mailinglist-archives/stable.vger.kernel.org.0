Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E90582F94
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiG0R2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbiG0R1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:27:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6D7E83A;
        Wed, 27 Jul 2022 09:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B2D3B821BE;
        Wed, 27 Jul 2022 16:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4AEC4347C;
        Wed, 27 Jul 2022 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940427;
        bh=0RyaagzoJehFp4OnNWJ66rEEeBYyrXWn1vmn7EOA0OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tarvzgdnSPN+IuyxGGw1diutkYg8QYBqeWCkCKisVwB1d2aQ+SJsQvJ09zGmv4l4W
         3YetAl2jCtEE+xwU5Lz+dxqwWaC5hTN8FkOAIY99pr+UVahJ3afkYq4VG0MnTqs28r
         3End9/+zn55CH/RTRyCKokr5KWRBvEGIknJibEnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.18 002/158] pinctrl: stm32: fix optional IRQ support to gpios
Date:   Wed, 27 Jul 2022 18:11:06 +0200
Message-Id: <20220727161021.529993485@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -1299,15 +1299,17 @@ static int stm32_gpiolib_register_bank(s
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
@@ -1466,6 +1468,8 @@ int stm32_pctl_probe(struct platform_dev
 	pctl->domain = stm32_pctrl_get_irq_domain(np);
 	if (IS_ERR(pctl->domain))
 		return PTR_ERR(pctl->domain);
+	if (!pctl->domain)
+		dev_warn(dev, "pinctrl without interrupt support\n");
 
 	/* hwspinlock is optional */
 	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);


