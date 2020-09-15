Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB326A73A
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIOOiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgIOOhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0ACD2242C;
        Tue, 15 Sep 2020 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180035;
        bh=tHrh5VR63ed/BO5xJkXkOiyyZEqaggP7oWHcWOYt3L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDzPfxqvwwC1ZicwQhyi15fal4YaO+n3NjK9X67KW6CIw1XDNDLgiF9mzV1eTt+eK
         Nma3sF9XpB7ptgKqTbClwPCnp5qIOVZ4P4Mn6LRXJYHImqCYHBl0da/1F+gNaE4ZFz
         Fvuw8e+7ULKF9wNi/2OxyUKem6/1RO0iWvzbq6M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/177] media: gpio-ir-tx: spinlock is not needed to disable interrupts
Date:   Tue, 15 Sep 2020 16:12:33 +0200
Message-Id: <20200915140657.572571613@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 1451b93223bbe3b4e9c91fca6b451d00667c5bf0 ]

During bit-banging the IR on a gpio pin, we cannot be scheduled or have
anything interrupt us, else the generated signal will be incorrect.
Therefore, we need to disable interrupts on the local cpu. This also
disables preemption.

local_irq_disable() does exactly what we need and does not require a
spinlock.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/gpio-ir-tx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
index f33b443bfa47b..c6cd2e6d8e654 100644
--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -19,8 +19,6 @@ struct gpio_ir {
 	struct gpio_desc *gpio;
 	unsigned int carrier;
 	unsigned int duty_cycle;
-	/* we need a spinlock to hold the cpu while transmitting */
-	spinlock_t lock;
 };
 
 static const struct of_device_id gpio_ir_tx_of_match[] = {
@@ -53,12 +51,11 @@ static int gpio_ir_tx_set_carrier(struct rc_dev *dev, u32 carrier)
 static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
 				   uint count)
 {
-	unsigned long flags;
 	ktime_t edge;
 	s32 delta;
 	int i;
 
-	spin_lock_irqsave(&gpio_ir->lock, flags);
+	local_irq_disable();
 
 	edge = ktime_get();
 
@@ -72,14 +69,11 @@ static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
 	}
 
 	gpiod_set_value(gpio_ir->gpio, 0);
-
-	spin_unlock_irqrestore(&gpio_ir->lock, flags);
 }
 
 static void gpio_ir_tx_modulated(struct gpio_ir *gpio_ir, uint *txbuf,
 				 uint count)
 {
-	unsigned long flags;
 	ktime_t edge;
 	/*
 	 * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
@@ -95,7 +89,7 @@ static void gpio_ir_tx_modulated(struct gpio_ir *gpio_ir, uint *txbuf,
 	space = DIV_ROUND_CLOSEST((100 - gpio_ir->duty_cycle) *
 				  (NSEC_PER_SEC / 100), gpio_ir->carrier);
 
-	spin_lock_irqsave(&gpio_ir->lock, flags);
+	local_irq_disable();
 
 	edge = ktime_get();
 
@@ -128,19 +122,20 @@ static void gpio_ir_tx_modulated(struct gpio_ir *gpio_ir, uint *txbuf,
 			edge = last;
 		}
 	}
-
-	spin_unlock_irqrestore(&gpio_ir->lock, flags);
 }
 
 static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 		      unsigned int count)
 {
 	struct gpio_ir *gpio_ir = dev->priv;
+	unsigned long flags;
 
+	local_irq_save(flags);
 	if (gpio_ir->carrier)
 		gpio_ir_tx_modulated(gpio_ir, txbuf, count);
 	else
 		gpio_ir_tx_unmodulated(gpio_ir, txbuf, count);
+	local_irq_restore(flags);
 
 	return count;
 }
@@ -176,7 +171,6 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
 
 	gpio_ir->carrier = 38000;
 	gpio_ir->duty_cycle = 50;
-	spin_lock_init(&gpio_ir->lock);
 
 	rc = devm_rc_register_device(&pdev->dev, rcdev);
 	if (rc < 0)
-- 
2.25.1



