Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A84417F0
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhKAJlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhKAJjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1816961374;
        Mon,  1 Nov 2021 09:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758856;
        bh=pu4MhGtx1nrsoSCEqdzI6ySOBeTARR6xIr4jYu7COCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYGM49UgsDjofvEMLcIfSNNi0OU2hO1AExEGB1sFUmeTqAfbUmAJoyJHIiOJV21B7
         e4hpFoBXzXGiH2PhjD84HEiONeNHEf6Xks0Xsk0CHp82qIrr8LEKYeW4xaaMDltR+x
         SsVVI8hQs2/c19xTJ421RYA62WR2u+lIK3KDQmVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.14 011/125] pinctrl: amd: disable and mask interrupts on probe
Date:   Mon,  1 Nov 2021 10:16:24 +0100
Message-Id: <20211101082535.600569357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sachi King <nakato@nakato.io>

commit 4e5a04be88fe335ad5331f4f8c17f4ebd357e065 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -832,6 +832,34 @@ static const struct pinconf_ops amd_pinc
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
@@ -969,6 +997,9 @@ static int amd_gpio_probe(struct platfor
 		return PTR_ERR(gpio_dev->pctrl);
 	}
 
+	/* Disable and mask interrupts */
+	amd_gpio_irq_init(gpio_dev);
+
 	girq = &gpio_dev->gc.irq;
 	girq->chip = &amd_gpio_irqchip;
 	/* This will let us handle the parent IRQ in the driver */


