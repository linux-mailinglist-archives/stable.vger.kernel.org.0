Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B956D3F28
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDCIid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjDCIic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:38:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56766195
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96E1EB815B1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A5EC4339C;
        Mon,  3 Apr 2023 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680511107;
        bh=cWxTsIsl0k2aJG7C3QEYSWlO8FLmmvLvp8/jydrmJFc=;
        h=Subject:To:Cc:From:Date:From;
        b=Sq782ZgLakAAypnQt+Vw0hODM9/kH2K7jL6UcP5ny67BbER7Sej9/81NQypHvCiaK
         nKqbiP3YSd+eUNYrEWj6teevJf//JF+QAfo67f8yL/kHkR7Rq8pNiaQ18OTSEHW3Ap
         hta2h8sjgBdtp7DQSFxrhtvi434CQaXP/RrSR2cI=
Subject: FAILED: patch "[PATCH] pinctrl: amd: Disable and mask interrupts on resume" failed to apply to 4.14-stable tree
To:     korneld@chromium.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:38:15 +0200
Message-ID: <2023040315-prodigal-chief-ace2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x b26cd9325be4c1fcd331b77f10acb627c560d4d7
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040315-prodigal-chief-ace2@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe")
e81376ebbafc ("pinctrl: amd: Use irqchip template")
279ffafaf39d ("pinctrl: Added IRQF_SHARED flag for amd-pinctrl driver")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b26cd9325be4c1fcd331b77f10acb627c560d4d7 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>
Date: Mon, 20 Mar 2023 09:32:59 +0000
Subject: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 9236a132c7ba..609821b756c2 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_ops = {
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
@@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin))
+		if (!amd_gpio_should_save(gpio_dev, pin)) {
+			amd_gpio_irq_init_pin(gpio_dev, pin);
 			continue;
+		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;

