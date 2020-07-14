Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7327621FBDF
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgGNTFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgGNSzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7807B22BEF;
        Tue, 14 Jul 2020 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752911;
        bh=WnWXystKD1gPfAT1UfcvNWEFGL4xdS81LhQZ9qwrS4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jplqxF7/0sHcaobw28HmgCeN71O2qSC31B/HCHxWF7kS2Xf+xJpGCnXg3ZLeMMQ+T
         C853mqWFKJIkRXzIBMTc0T/DFGOHwUsuhumKbr4/gw9JcBd5OO06HSSKcspKl/WVxu
         26schXjtwAdCWnGDUfcyEIj7u3Je+AFB74DYNvBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Roland Stigge <stigge@antcom.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 047/166] gpio: pca953x: Synchronize interrupt handler properly
Date:   Tue, 14 Jul 2020 20:43:32 +0200
Message-Id: <20200714184118.135701674@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 064c73afe7385de99e5b2785b88c83dc5d84403b ]

Since the commit aa58a21ae378 ("gpio: pca953x: disable regmap locking")
the locking of regmap is disabled and that immediately introduces
a synchronization issue. It's easy to see when we try to monitor
more than one interrupt from the same chip.

It seems that the problem exists from the day one and even commit
6e20fb18054c ("drivers/gpio/pca953x.c: add a mutex to fix race condition")
missed this.

Below are the traces and shell reproducers before and after proposed change.
Note duplicates in the IRQ events. /proc/interrupts also shows a deviation,
i.e. sum of children interrupts higher than parent's one.

When locking is disabled for regmap and no protection in IRQ handler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ...
 gpioset-194          regmap_hw_write_start: i2c-INT3491:02 reg=2 count=1
 irq/31-i2c-INT3-139  regmap_hw_read_start: i2c-INT3491:02 reg=4c count=2
 gpioset-194          regmap_hw_write_done: i2c-INT3491:02 reg=2 count=1
 gpioset-194          regmap_reg_read_cache: i2c-INT3491:02 reg=6 val=f5
 gpioset-194          regmap_reg_write: i2c-INT3491:02 reg=6 val=f5
 gpioset-194          regmap_hw_write_start: i2c-INT3491:02 reg=6 count=1
 irq/31-i2c-INT3-139  regmap_hw_read_done: i2c-INT3491:02 reg=4c count=2
 ...

 % gpiomon gpiochip3 0 &
 % gpioset gpiochip3 1=0
 % gpioset gpiochip3 1=1
 event:  RISING EDGE offset: 0 timestamp: [     302.782583765]
 % gpiomon gpiochip3 2 &
 % gpioset gpiochip3 1=0
 event:  RISING EDGE offset: 2 timestamp: [     312.033148829]
 event: FALLING EDGE offset: 0 timestamp: [     312.022757525]
 % gpioset gpiochip3 1=1
 event:  RISING EDGE offset: 2 timestamp: [     316.201148473]
 event:  RISING EDGE offset: 0 timestamp: [     316.191759599]

When locking is disabled for regmap and protection in IRQ handler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ...
 gpioset-202          regmap_hw_write_start: i2c-INT3491:02 reg=2 count=1
 gpioset-202          regmap_hw_write_done: i2c-INT3491:02 reg=2 count=1
 gpioset-202          regmap_reg_read_cache: i2c-INT3491:02 reg=6 val=fd
 gpioset-202          regmap_reg_write: i2c-INT3491:02 reg=6 val=fd
 gpioset-202          regmap_hw_write_start: i2c-INT3491:02 reg=6 count=1
 gpioset-202          regmap_hw_write_done: i2c-INT3491:02 reg=6 count=1
 irq/31-i2c-INT3-139  regmap_hw_read_start: i2c-INT3491:02 reg=4c count=2
 irq/31-i2c-INT3-139  regmap_hw_read_done: i2c-INT3491:02 reg=4c count=2
 ...

 % gpiomon gpiochip3 0 &
 % gpioset gpiochip3 1=0
 event: FALLING EDGE offset: 0 timestamp: [     531.330078107]
 % gpioset gpiochip3 1=1
 event:  RISING EDGE offset: 0 timestamp: [     532.912239128]
 % gpiomon gpiochip3 2 &
 % gpioset gpiochip3 1=0
 event: FALLING EDGE offset: 0 timestamp: [     539.633669484]
 % gpioset gpiochip3 1=1
 event:  RISING EDGE offset: 0 timestamp: [     542.256978461]

Fixes: 6e20fb18054c ("drivers/gpio/pca953x.c: add a mutex to fix race condition")
Depends-on: 35d13d94893f ("gpio: pca953x: convert to use bitmap API")
Depends-on: 49427232764d ("gpio: pca953x: Perform basic regmap conversion")
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 01011a780688a..d8ba6c5195be7 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -724,14 +724,16 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 	struct gpio_chip *gc = &chip->gpio_chip;
 	DECLARE_BITMAP(pending, MAX_LINE);
 	int level;
+	bool ret;
 
-	if (!pca953x_irq_pending(chip, pending))
-		return IRQ_NONE;
+	mutex_lock(&chip->i2c_lock);
+	ret = pca953x_irq_pending(chip, pending);
+	mutex_unlock(&chip->i2c_lock);
 
 	for_each_set_bit(level, pending, gc->ngpio)
 		handle_nested_irq(irq_find_mapping(gc->irq.domain, level));
 
-	return IRQ_HANDLED;
+	return IRQ_RETVAL(ret);
 }
 
 static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
-- 
2.25.1



