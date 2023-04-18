Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2F6E6216
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjDRMaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjDRMaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78242C148
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595E76313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B77C433EF;
        Tue, 18 Apr 2023 12:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820974;
        bh=2F4CZAnNnQKfp2Y4krkHQZqyH0jNoJO4PjinYFAMRLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZcO2+EOYmuGpOMLcISXYiwa9RpUeNASWJMnaugOFRMsJA3pVeX/0ahXIZDwmdnTp
         Sc3rBkEbXnvg4DJH8Dcvscr/9qqULO+FcUJP9godPl5X3Pzxoe/GTvAyjsHm/sRwL0
         K/9qImpTTxpA4xnfzqCdFemZRlaS5+/5IzKS7dk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 44/92] Revert "pinctrl: amd: Disable and mask interrupts on resume"
Date:   Tue, 18 Apr 2023 14:21:19 +0200
Message-Id: <20230418120306.374496677@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kornel Dulęba <korneld@chromium.org>

commit 534e465845ebfb4a97eb5459d3931a0b35e3b9a5 upstream.

This reverts commit b26cd9325be4c1fcd331b77f10acb627c560d4d7.

This patch introduces a regression on Lenovo Z13, which can't wake
from the lid with it applied; and some unspecified AMD based Dell
platforms are unable to wake from hitting the power button

Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230411134932.292287-1-korneld@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -770,34 +770,32 @@ static const struct pinconf_ops amd_pinc
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 {
-	const struct pin_desc *pd;
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
 	unsigned long flags;
 	u32 pin_reg, mask;
+	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	pd = pin_desc_get(gpio_dev->pctrl, pin);
-	if (!pd)
-		return;
+	for (i = 0; i < desc->npins; i++) {
+		int pin = desc->pins[i].number;
+		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
 
-	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + pin * 4);
-	pin_reg &= ~mask;
-	writel(pin_reg, gpio_dev->base + pin * 4);
-	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-}
+		if (!pd)
+			continue;
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
-{
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
-	int i;
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
-	for (i = 0; i < desc->npins; i++)
-		amd_gpio_irq_init_pin(gpio_dev, i);
+		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg &= ~mask;
+		writel(pin_reg, gpio_dev->base + i * 4);
+
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -850,10 +848,8 @@ static int amd_gpio_resume(struct device
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin)) {
-			amd_gpio_irq_init_pin(gpio_dev, pin);
+		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
-		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;


