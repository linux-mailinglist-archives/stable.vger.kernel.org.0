Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B164669422
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392082AbfGOOrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392069AbfGOOrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:47:15 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4C920896;
        Mon, 15 Jul 2019 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202034;
        bh=pJWg48+kNqHl1VlRuE9K6jWYUqdNwt4hfqqK4cAvq7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E66tcj0sffMEk5UyfnnwkbmTIEewN+oeOOkd3RJSCYlM/l/m81/iTYE7gHYorTXEJ
         ES/Kp5zEXmQY7sJmv+z9rw3IYkM5EIJvB+YRhSP68YTfdsNnAeMUc4+BSQuLZ/89pH
         r0kSaIBuFd98QhbPR0T9rnq6vXHTRs6PBmJ8ymOM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/53] gpio: omap: ensure irq is enabled before wakeup
Date:   Mon, 15 Jul 2019 10:45:09 -0400
Message-Id: <20190715144535.11636-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

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
index f23136825a6e..6e65c02baad1 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -821,9 +821,9 @@ static void omap_gpio_irq_shutdown(struct irq_data *d)
 
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
@@ -865,8 +865,8 @@ static void omap_gpio_mask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	omap_set_gpio_irqenable(bank, offset, 0);
 	omap_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+	omap_set_gpio_irqenable(bank, offset, 0);
 	raw_spin_unlock_irqrestore(&bank->lock, flags);
 }
 
@@ -878,9 +878,6 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	if (trigger)
-		omap_set_gpio_triggering(bank, offset, trigger);
-
 	omap_set_gpio_irqenable(bank, offset, 1);
 
 	/*
@@ -888,9 +885,13 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
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

