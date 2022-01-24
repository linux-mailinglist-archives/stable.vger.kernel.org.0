Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542A449A92C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322266AbiAYDVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379455AbiAXULf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B2BC06F8EA;
        Mon, 24 Jan 2022 11:33:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9253261502;
        Mon, 24 Jan 2022 19:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55956C340E5;
        Mon, 24 Jan 2022 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052814;
        bh=0o1dRmrL+Pinxi7ZJCmm3u6/6Gkhhzo8HdcqSLllwjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXRdZkS7CYagkdrF0y2lKNSgTTDTJxIkeHFMRa2j3BGLCCznhiKgeomfj2hV/SPVU
         yYQ/pbXjeekJ6h180FSBEzIypLh0JsOJF+biokRmKxR1vNixQ9YFYHmlE4RFHAGMJU
         ivDjM959v10chQwaXz03FDUEkesGf3tnWRFsDefg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/320] gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock
Date:   Mon, 24 Jan 2022 19:42:47 +0100
Message-Id: <20220124183959.884504044@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



