Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EC7BCF69
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410116AbfIXQ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405050AbfIXQty (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869A7217D9;
        Tue, 24 Sep 2019 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343793;
        bh=kAO61HjFeH1doRYmWN6z62Ejk2alckKKZ1JNaT4YbW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiMyStoIMj9JnzqXoFKbcqbL+7fhtDxB+7EKrbf985qw/GrvHutrGwaugMW3FGeYh
         ecdbn3ZTytwx14fFfNj5eFTNYs0KLNFvtD674vTOloitHwmQQMRAZt6cqh9zKu+FZ6
         73BbyrcHSsWDZqYQ3x6RyXZ3mRIHi/MomR4QldcM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Drake <drake@endlessm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 32/50] pinctrl: amd: disable spurious-firing GPIO IRQs
Date:   Tue, 24 Sep 2019 12:48:29 -0400
Message-Id: <20190924164847.27780-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

