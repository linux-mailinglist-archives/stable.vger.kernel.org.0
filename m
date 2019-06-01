Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587D331D3A
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbfFAN1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfFAN1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF5D25515;
        Sat,  1 Jun 2019 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395650;
        bh=DXLDT3cjyd1hg4iNu9cprxPx3Jjx2o2sbUQoe1/bG9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jufq+0dGOgoA5Le+Cy0nW5kf3WSQJrn+B/uztad1Rg/1/7qFT8YAWZDle7huQ1YSw
         VZh5iOfSWAPUKwPz1l4CZyd8NEG2fE9Ob/FmVq5RWxqoA4xPdZ4uepeTmpUELLaOxj
         hOgKbyMkXC2vAAZtI5Ch8e2KJdHPFjeiGss7X70s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 51/56] gpio: gpio-omap: add check for off wake capable gpios
Date:   Sat,  1 Jun 2019 09:25:55 -0400
Message-Id: <20190601132600.27427-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit da38ef3ed10a09248e13ae16530c2c6d448dc47d ]

We are currently assuming all GPIOs are non-wakeup capable GPIOs as we
not configuring the bank->non_wakeup_gpios like we used to earlier with
platform_data.

Let's add omap_gpio_is_off_wakeup_capable() to make the handling clearer
while considering that later patches may want to configure SoC specific
bank->non_wakeup_gpios for the GPIOs in wakeup domain.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Tero Kristo <t-kristo@ti.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 9943273ec9818..c8c49b1d5f9f9 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -292,6 +292,22 @@ static void omap_clear_gpio_debounce(struct gpio_bank *bank, unsigned offset)
 	}
 }
 
+/*
+ * Off mode wake-up capable GPIOs in bank(s) that are in the wakeup domain.
+ * See TRM section for GPIO for "Wake-Up Generation" for the list of GPIOs
+ * in wakeup domain. If bank->non_wakeup_gpios is not configured, assume none
+ * are capable waking up the system from off mode.
+ */
+static bool omap_gpio_is_off_wakeup_capable(struct gpio_bank *bank, u32 gpio_mask)
+{
+	u32 no_wake = bank->non_wakeup_gpios;
+
+	if (no_wake)
+		return !!(~no_wake & gpio_mask);
+
+	return false;
+}
+
 static inline void omap_set_gpio_trigger(struct gpio_bank *bank, int gpio,
 						unsigned trigger)
 {
@@ -323,13 +339,7 @@ static inline void omap_set_gpio_trigger(struct gpio_bank *bank, int gpio,
 	}
 
 	/* This part needs to be executed always for OMAP{34xx, 44xx} */
-	if (!bank->regs->irqctrl) {
-		/* On omap24xx proceed only when valid GPIO bit is set */
-		if (bank->non_wakeup_gpios) {
-			if (!(bank->non_wakeup_gpios & gpio_bit))
-				goto exit;
-		}
-
+	if (!bank->regs->irqctrl && !omap_gpio_is_off_wakeup_capable(bank, gpio)) {
 		/*
 		 * Log the edge gpio and manually trigger the IRQ
 		 * after resume if the input level changes
@@ -342,7 +352,6 @@ static inline void omap_set_gpio_trigger(struct gpio_bank *bank, int gpio,
 			bank->enabled_non_wakeup_gpios &= ~gpio_bit;
 	}
 
-exit:
 	bank->level_mask =
 		readl_relaxed(bank->base + bank->regs->leveldetect0) |
 		readl_relaxed(bank->base + bank->regs->leveldetect1);
-- 
2.20.1

