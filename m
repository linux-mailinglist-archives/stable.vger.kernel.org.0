Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0B373833
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfGXT0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbfGXT0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:26:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55E520659;
        Wed, 24 Jul 2019 19:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996412;
        bh=00Oip0XXbWSFeDOhJsm+ouVfEBA36IUzYI9gXjf5nGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0buvTSZ76wG1vYC3EntNZoFQ3M1vpCeTROzcrKhCmF8rGgsXXtw8VG4tNB089bx4
         kLh6dZcXp8Jn6BUG6G+HCx8cvTT+XNi4f17ela9WGXW5JGgQay5YLhfU4zoj8/waaf
         /Nld6yQlEdCEmsepWsSq1/2IiTI4Gkkb5Y7SGYc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 088/413] gpio: omap: ensure irq is enabled before wakeup
Date:   Wed, 24 Jul 2019 21:16:19 +0200
Message-Id: <20190724191741.377378001@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
index 7632c98aa3a4..746aa9caf934 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -829,9 +829,9 @@ static void omap_gpio_irq_shutdown(struct irq_data *d)
 
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
@@ -867,8 +867,8 @@ static void omap_gpio_mask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	omap_set_gpio_irqenable(bank, offset, 0);
 	omap_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+	omap_set_gpio_irqenable(bank, offset, 0);
 	raw_spin_unlock_irqrestore(&bank->lock, flags);
 }
 
@@ -880,9 +880,6 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
-	if (trigger)
-		omap_set_gpio_triggering(bank, offset, trigger);
-
 	omap_set_gpio_irqenable(bank, offset, 1);
 
 	/*
@@ -890,9 +887,13 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
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



