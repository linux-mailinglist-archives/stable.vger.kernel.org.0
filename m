Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8950C44270
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfFMQWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbfFMIiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:38:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9753C20851;
        Thu, 13 Jun 2019 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415100;
        bh=/dHQldAbdnJrEc/3h2mQBWWH8i0MIkcdA6tz/exW4CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G0Yzyu3vJKqSIMMDs3JXBuqnzrF2Occn2TEJmyu7HejTIvI11l5DQ4jigxk9s5FA
         SMjgsyaoQNLseClYS4qG+W63+lu9LE1Q5akwe02iDkCp1Yb9qU9qa5uwyOFGI17zrA
         X1bovhQUcFprs9v/ZkK/jST+hCwWMuYvMyuYYBZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 70/81] gpio: gpio-omap: add check for off wake capable gpios
Date:   Thu, 13 Jun 2019 10:33:53 +0200
Message-Id: <20190613075654.106758634@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 148e81eea35a..83c6843db50c 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -296,6 +296,22 @@ static void omap_clear_gpio_debounce(struct gpio_bank *bank, unsigned offset)
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
@@ -327,13 +343,7 @@ static inline void omap_set_gpio_trigger(struct gpio_bank *bank, int gpio,
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
@@ -346,7 +356,6 @@ static inline void omap_set_gpio_trigger(struct gpio_bank *bank, int gpio,
 			bank->enabled_non_wakeup_gpios &= ~gpio_bit;
 	}
 
-exit:
 	bank->level_mask =
 		readl_relaxed(bank->base + bank->regs->leveldetect0) |
 		readl_relaxed(bank->base + bank->regs->leveldetect1);
-- 
2.20.1



