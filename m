Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFC96D48A5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbjDCOaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbjDCOah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A0935009
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33EF3B81BB7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2865C433D2;
        Mon,  3 Apr 2023 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532232;
        bh=03YZrf2VCFWNpy8ZcTFRFIV7F7IL0ymhrLpTIc2whbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PL3e2URKrkDsWReyV+9hSp6LCvS0MrxilNAjqfZBS1s1Y0/AQ2GR6xwu+qH55BW4m
         qfHIJW1mbfn+GsNtPsCib9zVBPZepRxVzbnYrIaPGPztr9bEJ8RBHe1GyZ/taimN+1
         eChkrijiUNJlHKvC3ojmbPwiYC25/Y7Z1q2/3ocY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 153/173] pinctrl: amd: Disable and mask interrupts on resume
Date:   Mon,  3 Apr 2023 16:09:28 +0200
Message-Id: <20230403140419.399462426@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kornel Dulęba <korneld@chromium.org>

commit b26cd9325be4c1fcd331b77f10acb627c560d4d7 upstream.

This fixes a similar problem to the one observed in:
commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe").

On some systems, during suspend/resume cycle firmware leaves
an interrupt enabled on a pin that is not used by the kernel.
This confuses the AMD pinctrl driver and causes spurious interrupts.

The driver already has logic to detect if a pin is used by the kernel.
Leverage it to re-initialize interrupt fields of a pin only if it's not
used by us.

Cc: stable@vger.kernel.org
Fixes: dbad75dd1f25 ("pinctrl: add AMD GPIO driver support.")
Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Link: https://lore.kernel.org/r/20230320093259.845178-1-korneld@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -764,32 +764,34 @@ static const struct pinconf_ops amd_pinc
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
 {
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	const struct pin_desc *pd;
 	unsigned long flags;
 	u32 pin_reg, mask;
-	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	for (i = 0; i < desc->npins; i++) {
-		int pin = desc->pins[i].number;
-		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
-
-		if (!pd)
-			continue;
+	pd = pin_desc_get(gpio_dev->pctrl, pin);
+	if (!pd)
+		return;
 
-		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	pin_reg = readl(gpio_dev->base + pin * 4);
+	pin_reg &= ~mask;
+	writel(pin_reg, gpio_dev->base + pin * 4);
+	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+}
 
-		pin_reg = readl(gpio_dev->base + i * 4);
-		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + i * 4);
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+{
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	int i;
 
-		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-	}
+	for (i = 0; i < desc->npins; i++)
+		amd_gpio_irq_init_pin(gpio_dev, i);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -842,8 +844,10 @@ static int amd_gpio_resume(struct device
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin))
+		if (!amd_gpio_should_save(gpio_dev, pin)) {
+			amd_gpio_irq_init_pin(gpio_dev, pin);
 			continue;
+		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;


