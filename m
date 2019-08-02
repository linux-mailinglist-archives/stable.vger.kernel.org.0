Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FE47F423
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391192AbfHBJmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391012AbfHBJmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56212086A;
        Fri,  2 Aug 2019 09:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738928;
        bh=gwkjzpSz98peYPY3ZHojqgnIIfnUHN9Q6cUt2m55l9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz4DTBN73GqpaFI8+PvXTVLIZ91rCcscZGuVpC5SOFbmNV8XzeH1LvjNREP+lMltE
         ekpaFdu7BRxptp3nG7Vy5m7mp6eWNlNkr37+G/9offQ5J9gIvjVTa7lwffto5AKVK1
         /xE3fK65B/7QO8CPgmB7dhHSBVJeizQD7eqoRQKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/223] gpio: omap: ensure irq is enabled before wakeup
Date:   Fri,  2 Aug 2019 11:34:20 +0200
Message-Id: <20190802092241.263596464@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c859e0d479b3b4f6132fc12637c51e01492f31f6 ]

Documentation states:

  NOTE: There must be a correlation between the wake-up enable and
  interrupt-enable registers. If a GPIO pin has a wake-up configured
  on it, it must also have the corresponding interrupt enabled (on
  one of the two interrupt lines).

Ensure that this condition is always satisfied by enabling the detection
events after enabling the interrupt, and disabling the detection before
disabling the interrupt.  This ensures interrupt/wakeup events can not
happen until both the wakeup and interrupt enables correlate.

If we do any clearing, clear between the interrupt enable/disable and
trigger setting.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index bd12b433f964..fc841ce24db7 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -786,9 +786,9 @@ static void omap_gpio_irq_shutdown(struct irq_data *d)
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
 	bank->irq_usage &= ~(BIT(offset));
-	omap_set_gpio_irqenable(bank, offset, 0);
-	omap_clear_gpio_irqstatus(bank, offset);
 	omap_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+	omap_clear_gpio_irqstatus(bank, offset);
+	omap_set_gpio_irqenable(bank, offset, 0);
 	if (!LINE_USED(bank->mod_usage, offset))
 		omap_clear_gpio_debounce(bank, offset);
 	omap_disable_gpio_module(bank, offset);
@@ -830,8 +830,8 @@ static void omap_gpio_mask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	omap_set_gpio_irqenable(bank, offset, 0);
 	omap_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+	omap_set_gpio_irqenable(bank, offset, 0);
 	raw_spin_unlock_irqrestore(&bank->lock, flags);
 }
 
@@ -843,9 +843,6 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	if (trigger)
-		omap_set_gpio_triggering(bank, offset, trigger);
-
 	omap_set_gpio_irqenable(bank, offset, 1);
 
 	/*
@@ -853,9 +850,13 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
 	 * is cleared, thus after the handler has run. OMAP4 needs this done
 	 * after enabing the interrupt to clear the wakeup status.
 	 */
-	if (bank->level_mask & BIT(offset))
+	if (bank->regs->leveldetect0 && bank->regs->wkup_en &&
+	    trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
 		omap_clear_gpio_irqstatus(bank, offset);
 
+	if (trigger)
+		omap_set_gpio_triggering(bank, offset, trigger);
+
 	raw_spin_unlock_irqrestore(&bank->lock, flags);
 }
 
-- 
2.20.1



