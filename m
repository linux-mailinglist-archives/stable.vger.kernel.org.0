Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE28F2B5F79
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgKQM45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgKQM44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:56:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314002151B;
        Tue, 17 Nov 2020 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617815;
        bh=Uq7Mm0fH0GeoEf0FK7NZg4YvfEhyM/7m8LEGhI5rbic=;
        h=From:To:Cc:Subject:Date:From;
        b=Ubcbgztce59LlW2+OTAwTLVCT6WwQN1zhxdUDaxBm1NWgwi/l1cAwu8LGt1oi5Ulq
         Xjrn7pL5tEpTBoRMUnPgPjHnOQR54XQ9Av7Rk/k2qaR99WmRPGNORJ9B0GyVhPCf18
         yjEG1eJwjDFrh7EHeSSBjg6etnO19YZhJGsD/QHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 01/21] Revert "Revert "gpio: omap: Fix lost edge wake-up interrupts""
Date:   Tue, 17 Nov 2020 07:56:32 -0500
Message-Id: <20201117125652.599614-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7ffa08169849be898eed6f3694aab8c425497749 ]

This reverts commit 579ced8fdb00b8e94304a83e3cc419f6f8eab08e.

Turns out I was overly optimistic about cpu_pm blocking idle being a
solution for handling edge interrupts. While it helps in preventing
entering idle states that potentially lose context, we can still get
an edge interrupt triggering while entering idle. So we need to also
add back the workaround for seeing if there are any pending edge
interrupts when waking up.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Tero Kristo <t-kristo@ti.com>
Link: https://lore.kernel.org/r/20201028060556.56038-1-tony@atomide.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ea640fb636cf..3b87989e27640 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1114,13 +1114,23 @@ static void omap_gpio_idle(struct gpio_bank *bank, bool may_lose_context)
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
2.27.0

