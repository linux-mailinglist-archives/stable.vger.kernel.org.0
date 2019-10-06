Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15729CD6B2
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfJFRlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbfJFRlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 569D92053B;
        Sun,  6 Oct 2019 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383668;
        bh=2Qwsm8loPfoLwUa6cnWbCON9/e9C/jsrHa0Bssbv39I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWuM87Tr9tnL7wVvpvYbPovV9Y+cRbHkipc3jpV6l5nJeaUor5PLEmhwhm0NNMaxb
         PQF3MV/+A0+5m77hb89SpiIO7rTwD3ISvs9GpF5K3vIbfH1PR+ip+ENV3TELIdCYFU
         o+MS8zmWu4E8HsxUAc8vIfBb5FNTUSWNMwa4jDII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 052/166] pinctrl: amd: disable spurious-firing GPIO IRQs
Date:   Sun,  6 Oct 2019 19:20:18 +0200
Message-Id: <20191006171217.440320663@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
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
index 9b9c61e3f0652..977792654e017 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -565,15 +565,25 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
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



