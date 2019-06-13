Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0151343F87
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbfFMP6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731499AbfFMIuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22E720851;
        Thu, 13 Jun 2019 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415820;
        bh=boL3nWCzla5lT6QeNwDsvpbHGX1QWNYlDdNfDmkwvKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJt7VH00bWYepXfPYL1Nv8XQOVYb3fQiC8Vs7anAQRVpix7Pzue85Ec0g1lcvpPuf
         WIm9zUOmTo7wmBJIhjMLPlsM/sI29i9bXT/SDMFljRPdpBqp2TJfxRaF8rfGvnFAo7
         2uEXbaMRmyLtjqKn3AAcSakBz7IW/daUf4bKW+xA=
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
Subject: [PATCH 5.1 135/155] gpio: gpio-omap: limit errata 1.101 handling to wkup domain gpios only
Date:   Thu, 13 Jun 2019 10:34:07 +0200
Message-Id: <20190613075700.284753913@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 21e2118f470302f16bee7ebd1444505eadbc2c20 ]

We need to only apply errata 1.101 handling to clear non-wakeup edge gpios
for idle to the gpio bank(s) in the wkup domain to prevent spurious wake-up
events.

And we must restore what we did after idle manually as the gpio bank in
wkup domain is not restored otherwise.

Let's keep bank->saved_datain register reading separate, that's not related
to the 1.101 errata and is used separately on restore.

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
 drivers/gpio/gpio-omap.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index e8bfee919a7e..fafd79438bbf 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1453,7 +1453,10 @@ static void omap_gpio_restore_context(struct gpio_bank *bank);
 static void omap_gpio_idle(struct gpio_bank *bank, bool may_lose_context)
 {
 	struct device *dev = bank->chip.parent;
-	u32 l1 = 0, l2 = 0;
+	void __iomem *base = bank->base;
+	u32 nowake;
+
+	bank->saved_datain = readl_relaxed(base + bank->regs->datain);
 
 	if (bank->funcs.idle_enable_level_quirk)
 		bank->funcs.idle_enable_level_quirk(bank);
@@ -1465,20 +1468,15 @@ static void omap_gpio_idle(struct gpio_bank *bank, bool may_lose_context)
 		goto update_gpio_context_count;
 
 	/*
-	 * If going to OFF, remove triggering for all
+	 * If going to OFF, remove triggering for all wkup domain
 	 * non-wakeup GPIOs.  Otherwise spurious IRQs will be
 	 * generated.  See OMAP2420 Errata item 1.101.
 	 */
-	bank->saved_datain = readl_relaxed(bank->base +
-						bank->regs->datain);
-	l1 = bank->context.fallingdetect;
-	l2 = bank->context.risingdetect;
-
-	l1 &= ~bank->enabled_non_wakeup_gpios;
-	l2 &= ~bank->enabled_non_wakeup_gpios;
-
-	writel_relaxed(l1, bank->base + bank->regs->fallingdetect);
-	writel_relaxed(l2, bank->base + bank->regs->risingdetect);
+	if (!bank->loses_context && bank->enabled_non_wakeup_gpios) {
+		nowake = bank->enabled_non_wakeup_gpios;
+		omap_gpio_rmw(base, bank->regs->fallingdetect, nowake, ~nowake);
+		omap_gpio_rmw(base, bank->regs->risingdetect, nowake, ~nowake);
+	}
 
 	bank->workaround_enabled = true;
 
@@ -1527,6 +1525,12 @@ static void omap_gpio_unidle(struct gpio_bank *bank)
 				return;
 			}
 		}
+	} else {
+		/* Restore changes done for OMAP2420 errata 1.101 */
+		writel_relaxed(bank->context.fallingdetect,
+			       bank->base + bank->regs->fallingdetect);
+		writel_relaxed(bank->context.risingdetect,
+			       bank->base + bank->regs->risingdetect);
 	}
 
 	if (!bank->workaround_enabled)
-- 
2.20.1



