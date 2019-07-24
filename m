Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4404573836
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfGXT1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbfGXT07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:26:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A22F20659;
        Wed, 24 Jul 2019 19:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996418;
        bh=d48ehVTORlKXviT2Y2XYVr7rT+Ebkzd6pWcD+Wo1+qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6oeCSpd8dOVwYUhT0+qKrpx5Mf7iDKGQkANgbsvSq5CVS12f8yfL/EARTfz4ylU+
         oWuTTYMpDqRC7bzonuUeptpBHS//bRozDXy6mHK8/LgqiHhadH4ixoPL5p8tXOIVi1
         3H7AHR6soOE3c2K8UITjBatWPWYvGplRkOK2l8OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 090/413] gpio: omap: Fix lost edge wake-up interrupts
Date:   Wed, 24 Jul 2019 21:16:21 +0200
Message-Id: <20190724191741.492376199@linuxfoundation.org>
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

[ Upstream commit a522f1d0c381c42f3ace13b8bbeeccabdd6d2e5c ]

If an edge interrupt triggers while entering idle just before we save
GPIO datain register to saved_datain, the triggered GPIO will not be
noticed on wake-up. This is because the saved_datain and GPIO datain
are the same on wake-up in omap_gpio_unidle(). Let's fix this by
ignoring any pending edge interrupts for saved_datain.

This issue affects only idle states where the GPIO module internal
wake-up path is operational. For deeper idle states where the GPIO
module gets powered off, Linux generic wakeirqs must be used for
the padconf wake-up events with pinctrl-single driver. For examples,
please see "interrupts-extended" dts usage in many drivers.

This issue can be somewhat easily reproduced by pinging an idle system
with smsc911x Ethernet interface configured IRQ_TYPE_EDGE_FALLING. At
some point the smsc911x interrupts will just stop triggering. Also if
WLCORE WLAN is used with EDGE interrupt like it's documentation specifies,
we can see lost interrupts without this patch.

Note that in the long run we may be able to cancel entering idle by
returning an error in gpio_omap_cpu_notifier() on pending interrupts.
But let's fix the bug first.

Also note that because of the recent clean-up efforts this patch does
not apply directly to older kernels. This does fix a long term issue
though, and can be backported as needed.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 746aa9caf934..8591c410ecaa 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1275,13 +1275,23 @@ static void omap_gpio_idle(struct gpio_bank *bank, bool may_lose_context)
 {
 	struct device *dev = bank->chip.parent;
 	void __iomem *base = bank->base;
-	u32 nowake;
+	u32 mask, nowake;
 
 	bank->saved_datain = readl_relaxed(base + bank->regs->datain);
 
 	if (!bank->enabled_non_wakeup_gpios)
 		goto update_gpio_context_count;
 
+	/* Check for pending EDGE_FALLING, ignore EDGE_BOTH */
+	mask = bank->enabled_non_wakeup_gpios & bank->context.fallingdetect;
+	mask &= ~bank->context.risingdetect;
+	bank->saved_datain |= mask;
+
+	/* Check for pending EDGE_RISING, ignore EDGE_BOTH */
+	mask = bank->enabled_non_wakeup_gpios & bank->context.risingdetect;
+	mask &= ~bank->context.fallingdetect;
+	bank->saved_datain &= ~mask;
+
 	if (!may_lose_context)
 		goto update_gpio_context_count;
 
-- 
2.20.1



