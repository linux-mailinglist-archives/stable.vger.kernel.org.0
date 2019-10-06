Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9441CD771
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfJFR3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbfJFR3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E6F217F9;
        Sun,  6 Oct 2019 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382951;
        bh=kAO61HjFeH1doRYmWN6z62Ejk2alckKKZ1JNaT4YbW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai5A4p/GTX0h6nS2W/jv+h/FCgXFVHox7msLRFg/16ApTnMTlD76Vr/f8UBpbgQGM
         NUlhlOFMaDuRZsoo17w5/FFPD6M41BV8+EJRu5Rm9jafcfYFCWijj4EnOT1nIABQea
         w+s6kfTz/aowtHGeEJ4UDI003EhcSELXn4USsseI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/106] pinctrl: amd: disable spurious-firing GPIO IRQs
Date:   Sun,  6 Oct 2019 19:20:36 +0200
Message-Id: <20191006171139.515584588@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

[ Upstream commit d21b8adbd475dba19ac2086d3306327b4a297418 ]

When cold-booting Asus X434DA, GPIO 7 is found to be already configured
as an interrupt, and the GPIO level is found to be in a state that
causes the interrupt to fire.

As soon as pinctrl-amd probes, this interrupt fires and invokes
amd_gpio_irq_handler(). The IRQ is acked, but no GPIO-IRQ handler was
invoked, so the GPIO level being unchanged just causes another interrupt
to fire again immediately after.

This results in an interrupt storm causing this platform to hang
during boot, right after pinctrl-amd is probed.

Detect this situation and disable the GPIO interrupt when this happens.
This enables the affected platform to boot as normal. GPIO 7 actually is
the I2C touchpad interrupt line, and later on, i2c-multitouch loads and
re-enables this interrupt when it is ready to handle it.

Instead of this approach, I considered disabling all GPIO interrupts at
probe time, however that seems a little risky, and I also confirmed that
Windows does not seem to have this behaviour: the same 41 GPIO IRQs are
enabled under both Linux and Windows, which is a far larger collection
than the GPIOs referenced by the DSDT on this platform.

Signed-off-by: Daniel Drake <drake@endlessm.com>
Link: https://lore.kernel.org/r/20190814090540.7152-1-drake@endlessm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 1425c2874d402..cd7a5d95b499a 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -569,15 +569,25 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
 			    !(regval & BIT(INTERRUPT_MASK_OFF)))
 				continue;
 			irq = irq_find_mapping(gc->irq.domain, irqnr + i);
-			generic_handle_irq(irq);
+			if (irq != 0)
+				generic_handle_irq(irq);
 
 			/* Clear interrupt.
 			 * We must read the pin register again, in case the
 			 * value was changed while executing
 			 * generic_handle_irq() above.
+			 * If we didn't find a mapping for the interrupt,
+			 * disable it in order to avoid a system hang caused
+			 * by an interrupt storm.
 			 */
 			raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 			regval = readl(regs + i);
+			if (irq == 0) {
+				regval &= ~BIT(INTERRUPT_ENABLE_OFF);
+				dev_dbg(&gpio_dev->pdev->dev,
+					"Disabling spurious GPIO IRQ %d\n",
+					irqnr + i);
+			}
 			writel(regval, regs + i);
 			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 			ret = IRQ_HANDLED;
-- 
2.20.1



