Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43E6E61BE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDRM1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDRM1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFAD9778
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDCA6313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4D6C433EF;
        Tue, 18 Apr 2023 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820817;
        bh=wJiEHiehS4BtOKRQtsr3qRjeaoYLDnAocmkB/KsgKwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1TVbyiNxyw65TaN1JjlGcT02mVJQVXryKtXRJdJp3ntP3r8rpKU+xcNkYlrx37/a
         2hnkw6UmGe+sy0/jjDUjA0aKXhHdJ78xaVI65JBIK8Xoq9MulR9WWAyk8yWcE84Mz9
         NYJLVxU2vPer6d9NJFq3YdXxkf6W9U2GgHnW+okA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sachi King <nakato@nakato.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/57] pinctrl: amd: disable and mask interrupts on probe
Date:   Tue, 18 Apr 2023 14:21:03 +0200
Message-Id: <20230418120258.840208700@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
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

From: Sachi King <nakato@nakato.io>

[ Upstream commit 4e5a04be88fe335ad5331f4f8c17f4ebd357e065 ]

Some systems such as the Microsoft Surface Laptop 4 leave interrupts
enabled and configured for use in sleep states on boot, which cause
unexpected behaviour such as spurious wakes and failed resumes in
s2idle states.

As interrupts should not be enabled until they are claimed and
explicitly enabled, disabling any interrupts mistakenly left enabled by
firmware should be safe.

Signed-off-by: Sachi King <nakato@nakato.io>
Link: https://lore.kernel.org/r/20211009033240.21543-1-nakato@nakato.io
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 4d283ebaaf230..a44902b140879 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -774,6 +774,34 @@ static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+{
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
+	u32 pin_reg, mask;
+	int i;
+
+	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
+		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
+		BIT(WAKE_CNTRL_OFF_S4);
+
+	for (i = 0; i < desc->npins; i++) {
+		int pin = desc->pins[i].number;
+		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
+
+		if (!pd)
+			continue;
+
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+
+		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg &= ~mask;
+		writel(pin_reg, gpio_dev->base + i * 4);
+
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+	}
+}
+
 #ifdef CONFIG_PM_SLEEP
 static bool amd_gpio_should_save(struct amd_gpio *gpio_dev, unsigned int pin)
 {
@@ -922,6 +950,9 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		return PTR_ERR(gpio_dev->pctrl);
 	}
 
+	/* Disable and mask interrupts */
+	amd_gpio_irq_init(gpio_dev);
+
 	girq = &gpio_dev->gc.irq;
 	girq->chip = &amd_gpio_irqchip;
 	/* This will let us handle the parent IRQ in the driver */
-- 
2.39.2



