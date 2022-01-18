Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FC9491AB9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbiARDCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347836AbiARC5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8381C06135F;
        Mon, 17 Jan 2022 18:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73A44B81132;
        Tue, 18 Jan 2022 02:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4285AC36AF3;
        Tue, 18 Jan 2022 02:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473942;
        bh=0o1dRmrL+Pinxi7ZJCmm3u6/6Gkhhzo8HdcqSLllwjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAydej9Kdpa7oFp6P4p5I9kXTO69d+U2TiXMJT1QDQ3YkGxfyS7/3b73vrERD+HUp
         kNiQhledljC8IFFyDllUVsXwyUNc7jMduNHqSvvxwQOA5fvUwcnCDkGtoSUFYqJji7
         WkQ2ltEqpqNvD02Rz+WwnCH+qBOPyJOhZ7gvRW8bQmnBP8IN1ssnS+zFMffw6wEvJH
         rgxoaopa1SMzg7nR0YuZ8+4EdiXs1EuFOWuEBGIreqduWAOeB60gz/eoNynLO+FNTZ
         oxCHKC0uw/5hK9Rja2HAtUxAcsDzMxcpnBCl072J4Uz0AgGxVTsI/UfgsKUSD/Dixv
         foToQ9+7O3oOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iwona Winiarska <iwona.winiarska@intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        joel@jms.id.au, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 32/73] gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock
Date:   Mon, 17 Jan 2022 21:43:51 -0500
Message-Id: <20220118024432.1952028-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iwona Winiarska <iwona.winiarska@intel.com>

[ Upstream commit 61a7904b6ace99b1bde0d0e867fa3097f5c8cee2 ]

The gpio-aspeed driver implements an irq_chip which need to be invoked
from hardirq context. Since spin_lock() can sleep with PREEMPT_RT, it is
no longer legal to invoke it while interrupts are disabled.
This also causes lockdep to complain about:
[    0.649797] [ BUG: Invalid wait context ]
because aspeed_gpio.lock (spin_lock_t) is taken under irq_desc.lock
(raw_spinlock_t).
Let's use of raw_spinlock_t instead of spinlock_t.

Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 52 +++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 2820c59b5f071..22e0d6fcab1c4 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -53,7 +53,7 @@ struct aspeed_gpio_config {
 struct aspeed_gpio {
 	struct gpio_chip chip;
 	struct irq_chip irqc;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	void __iomem *base;
 	int irq;
 	const struct aspeed_gpio_config *config;
@@ -413,14 +413,14 @@ static void aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
 	unsigned long flags;
 	bool copro;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	copro = aspeed_gpio_copro_request(gpio, offset);
 
 	__aspeed_gpio_set(gc, offset, val);
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static int aspeed_gpio_dir_in(struct gpio_chip *gc, unsigned int offset)
@@ -435,7 +435,7 @@ static int aspeed_gpio_dir_in(struct gpio_chip *gc, unsigned int offset)
 	if (!have_input(gpio, offset))
 		return -ENOTSUPP;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	reg = ioread32(addr);
 	reg &= ~GPIO_BIT(offset);
@@ -445,7 +445,7 @@ static int aspeed_gpio_dir_in(struct gpio_chip *gc, unsigned int offset)
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return 0;
 }
@@ -463,7 +463,7 @@ static int aspeed_gpio_dir_out(struct gpio_chip *gc,
 	if (!have_output(gpio, offset))
 		return -ENOTSUPP;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	reg = ioread32(addr);
 	reg |= GPIO_BIT(offset);
@@ -474,7 +474,7 @@ static int aspeed_gpio_dir_out(struct gpio_chip *gc,
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return 0;
 }
@@ -492,11 +492,11 @@ static int aspeed_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 	if (!have_output(gpio, offset))
 		return 1;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	val = ioread32(bank_reg(gpio, bank, reg_dir)) & GPIO_BIT(offset);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return !val;
 
@@ -540,14 +540,14 @@ static void aspeed_gpio_irq_ack(struct irq_data *d)
 
 	status_addr = bank_reg(gpio, bank, reg_irq_status);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	copro = aspeed_gpio_copro_request(gpio, offset);
 
 	iowrite32(bit, status_addr);
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static void aspeed_gpio_irq_set_mask(struct irq_data *d, bool set)
@@ -566,7 +566,7 @@ static void aspeed_gpio_irq_set_mask(struct irq_data *d, bool set)
 
 	addr = bank_reg(gpio, bank, reg_irq_enable);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	copro = aspeed_gpio_copro_request(gpio, offset);
 
 	reg = ioread32(addr);
@@ -578,7 +578,7 @@ static void aspeed_gpio_irq_set_mask(struct irq_data *d, bool set)
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static void aspeed_gpio_irq_mask(struct irq_data *d)
@@ -630,7 +630,7 @@ static int aspeed_gpio_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	copro = aspeed_gpio_copro_request(gpio, offset);
 
 	addr = bank_reg(gpio, bank, reg_irq_type0);
@@ -650,7 +650,7 @@ static int aspeed_gpio_set_type(struct irq_data *d, unsigned int type)
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	irq_set_handler_locked(d, handler);
 
@@ -720,7 +720,7 @@ static int aspeed_gpio_reset_tolerance(struct gpio_chip *chip,
 
 	treg = bank_reg(gpio, to_bank(offset), reg_tolerance);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	copro = aspeed_gpio_copro_request(gpio, offset);
 
 	val = readl(treg);
@@ -734,7 +734,7 @@ static int aspeed_gpio_reset_tolerance(struct gpio_chip *chip,
 
 	if (copro)
 		aspeed_gpio_copro_release(gpio, offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return 0;
 }
@@ -860,7 +860,7 @@ static int enable_debounce(struct gpio_chip *chip, unsigned int offset,
 		return rc;
 	}
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	if (timer_allocation_registered(gpio, offset)) {
 		rc = unregister_allocated_timer(gpio, offset);
@@ -920,7 +920,7 @@ static int enable_debounce(struct gpio_chip *chip, unsigned int offset,
 	configure_timer(gpio, offset, i);
 
 out:
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return rc;
 }
@@ -931,13 +931,13 @@ static int disable_debounce(struct gpio_chip *chip, unsigned int offset)
 	unsigned long flags;
 	int rc;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	rc = unregister_allocated_timer(gpio, offset);
 	if (!rc)
 		configure_timer(gpio, offset, 0);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return rc;
 }
@@ -1019,7 +1019,7 @@ int aspeed_gpio_copro_grab_gpio(struct gpio_desc *desc,
 		return -EINVAL;
 	bindex = offset >> 3;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	/* Sanity check, this shouldn't happen */
 	if (gpio->cf_copro_bankmap[bindex] == 0xff) {
@@ -1040,7 +1040,7 @@ int aspeed_gpio_copro_grab_gpio(struct gpio_desc *desc,
 	if (bit)
 		*bit = GPIO_OFFSET(offset);
  bail:
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(aspeed_gpio_copro_grab_gpio);
@@ -1064,7 +1064,7 @@ int aspeed_gpio_copro_release_gpio(struct gpio_desc *desc)
 		return -EINVAL;
 	bindex = offset >> 3;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	/* Sanity check, this shouldn't happen */
 	if (gpio->cf_copro_bankmap[bindex] == 0) {
@@ -1078,7 +1078,7 @@ int aspeed_gpio_copro_release_gpio(struct gpio_desc *desc)
 		aspeed_gpio_change_cmd_source(gpio, bank, bindex,
 					      GPIO_CMDSRC_ARM);
  bail:
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(aspeed_gpio_copro_release_gpio);
@@ -1151,7 +1151,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(gpio->base))
 		return PTR_ERR(gpio->base);
 
-	spin_lock_init(&gpio->lock);
+	raw_spin_lock_init(&gpio->lock);
 
 	gpio_id = of_match_node(aspeed_gpio_of_table, pdev->dev.of_node);
 	if (!gpio_id)
-- 
2.34.1

