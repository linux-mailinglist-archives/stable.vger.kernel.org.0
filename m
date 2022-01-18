Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204E54915C4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245381AbiARC3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiARC1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:27:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA7C0612DE;
        Mon, 17 Jan 2022 18:25:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE6260A6B;
        Tue, 18 Jan 2022 02:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03FDC36AEF;
        Tue, 18 Jan 2022 02:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472727;
        bh=zrGN/H7rq5Xkf0os/FChXmYJJlBZX3zxIDFjOnOwKh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OulLmAYY5D50LCIrvJKMfMkcUEUE+45WLiPsSsC+0TOGX570eLDA9n8d7CxLIes7w
         TlSZyFdFqABmhC73i+4AYUuZnFC6RXkVaRLrD0rhJjRijW8fUpmM2GOfGOcFRLSf0G
         cdH/cbCjYIqRTZV8Br1qXxoUBal0QHsy1uRixYgxSs95ULS/fbmeY0a8oVACpoA+64
         bRLdS58ehTKStsbOpNdvfD7JaLiNCRJStdQylWzTTZszQW9cIoP1DrnOvqM5qTsSKK
         pqDGvn4NllapEVR2sAf49NDdICDj7EmwmOF16QuoaA21XpqmXtlSOL4UDhvlmUxg67
         h6XVS3DcGCfdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iwona Winiarska <iwona.winiarska@intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        joel@jms.id.au, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.16 116/217] gpio: aspeed-sgpio: Convert aspeed_sgpio.lock to raw_spinlock
Date:   Mon, 17 Jan 2022 21:17:59 -0500
Message-Id: <20220118021940.1942199-116-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iwona Winiarska <iwona.winiarska@intel.com>

[ Upstream commit ab39d6988dd53f354130438d8afa5596a2440fed ]

The gpio-aspeed-sgpio driver implements an irq_chip which need to be
invoked from hardirq context. Since spin_lock() can sleep with
PREEMPT_RT, it is no longer legal to invoke it while interrupts are
disabled.
This also causes lockdep to complain about:
[   25.919465] [ BUG: Invalid wait context ]
because aspeed_sgpio.lock (spin_lock_t) is taken under irq_desc.lock
(raw_spinlock_t).
Let's use of raw_spinlock_t instead of spinlock_t.

Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed-sgpio.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpio-aspeed-sgpio.c b/drivers/gpio/gpio-aspeed-sgpio.c
index b3a9b8488f11d..454cefbeecf0e 100644
--- a/drivers/gpio/gpio-aspeed-sgpio.c
+++ b/drivers/gpio/gpio-aspeed-sgpio.c
@@ -31,7 +31,7 @@ struct aspeed_sgpio {
 	struct gpio_chip chip;
 	struct irq_chip intc;
 	struct clk *pclk;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	void __iomem *base;
 	int irq;
 };
@@ -173,12 +173,12 @@ static int aspeed_sgpio_get(struct gpio_chip *gc, unsigned int offset)
 	enum aspeed_sgpio_reg reg;
 	int rc = 0;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	reg = aspeed_sgpio_is_input(offset) ? reg_val : reg_rdata;
 	rc = !!(ioread32(bank_reg(gpio, bank, reg)) & GPIO_BIT(offset));
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return rc;
 }
@@ -215,11 +215,11 @@ static void aspeed_sgpio_set(struct gpio_chip *gc, unsigned int offset, int val)
 	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	sgpio_set_value(gc, offset, val);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static int aspeed_sgpio_dir_in(struct gpio_chip *gc, unsigned int offset)
@@ -236,9 +236,9 @@ static int aspeed_sgpio_dir_out(struct gpio_chip *gc, unsigned int offset, int v
 	/* No special action is required for setting the direction; we'll
 	 * error-out in sgpio_set_value if this isn't an output GPIO */
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 	rc = sgpio_set_value(gc, offset, val);
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return rc;
 }
@@ -277,11 +277,11 @@ static void aspeed_sgpio_irq_ack(struct irq_data *d)
 
 	status_addr = bank_reg(gpio, bank, reg_irq_status);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	iowrite32(bit, status_addr);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static void aspeed_sgpio_irq_set_mask(struct irq_data *d, bool set)
@@ -296,7 +296,7 @@ static void aspeed_sgpio_irq_set_mask(struct irq_data *d, bool set)
 	irqd_to_aspeed_sgpio_data(d, &gpio, &bank, &bit, &offset);
 	addr = bank_reg(gpio, bank, reg_irq_enable);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	reg = ioread32(addr);
 	if (set)
@@ -306,7 +306,7 @@ static void aspeed_sgpio_irq_set_mask(struct irq_data *d, bool set)
 
 	iowrite32(reg, addr);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 
 static void aspeed_sgpio_irq_mask(struct irq_data *d)
@@ -355,7 +355,7 @@ static int aspeed_sgpio_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	addr = bank_reg(gpio, bank, reg_irq_type0);
 	reg = ioread32(addr);
@@ -372,7 +372,7 @@ static int aspeed_sgpio_set_type(struct irq_data *d, unsigned int type)
 	reg = (reg & ~bit) | type2;
 	iowrite32(reg, addr);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	irq_set_handler_locked(d, handler);
 
@@ -467,7 +467,7 @@ static int aspeed_sgpio_reset_tolerance(struct gpio_chip *chip,
 
 	reg = bank_reg(gpio, to_bank(offset), reg_tolerance);
 
-	spin_lock_irqsave(&gpio->lock, flags);
+	raw_spin_lock_irqsave(&gpio->lock, flags);
 
 	val = readl(reg);
 
@@ -478,7 +478,7 @@ static int aspeed_sgpio_reset_tolerance(struct gpio_chip *chip,
 
 	writel(val, reg);
 
-	spin_unlock_irqrestore(&gpio->lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
 	return 0;
 }
@@ -575,7 +575,7 @@ static int __init aspeed_sgpio_probe(struct platform_device *pdev)
 	iowrite32(FIELD_PREP(ASPEED_SGPIO_CLK_DIV_MASK, sgpio_clk_div) | gpio_cnt_regval |
 		  ASPEED_SGPIO_ENABLE, gpio->base + ASPEED_SGPIO_CTRL);
 
-	spin_lock_init(&gpio->lock);
+	raw_spin_lock_init(&gpio->lock);
 
 	gpio->chip.parent = &pdev->dev;
 	gpio->chip.ngpio = nr_gpios * 2;
-- 
2.34.1

