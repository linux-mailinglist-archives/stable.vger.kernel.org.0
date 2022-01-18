Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53049161E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245277AbiARCcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43954 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiARC0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0A716115F;
        Tue, 18 Jan 2022 02:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC54C36AE3;
        Tue, 18 Jan 2022 02:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472806;
        bh=ufLzCl2omFWLzhWbChO1EMdtfVpNuNeChc52YK05Kdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFdso7uSf4o76dFV9m8TeaG/JQpWT9yygc6tWHehPyWfG5+Yyg6w+MTE0cYa30B1V
         Oh9Qh6+IFOC+Hbqg8xJFo0rTC790zOyp7uCdjflUfHSsCJs//wAfn75lO1pFBkXbr8
         87T3VFwzZ7MiK97nBOVLpCBOTPiNSCYVruSltbp2Hm7+efGkZUkQOOO0Z86tDcjrDo
         a8U44yx6qVygnOPlXmhZEWxdX0Wn7J3i6lA8Ipqps7Gk1AEKhjtJvjJYzqXKLslM3W
         iyvF8NeTmguk3fMfFJJwlLEwkrHZSVIIZQBggRyEK7ihnfnJ4fQvgu/2lZROMy2wo0
         e4FIcnfJRa7gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        abaci-bugfix@linux.alibaba.com, mchehab+huawei@kernel.org,
        robh@kernel.org, caihuoqing@baidu.com, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 139/217] mmc: omap_hsmmc: Revert special init for wl1251
Date:   Mon, 17 Jan 2022 21:18:22 -0500
Message-Id: <20220118021940.1942199-139-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit dfb654f1885f05baf506cdfdbc3f7efa1d847d54 ]

Due to recent changes to the mmc core, card quirks can be applied based
upon a compatible string in child OF node. The quirk needed for wl1251
(SDIO card) is managed in the core, therefore there is no longer any reason
to deal with this in omap_hsmmc too, so let's remove it.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/77d313b97d1e18b0eb7ed2d88d718d960f329bb0.1636564631.git.hns@goldelico.com
[Ulf: Re-wrote the commit message to make it more clear]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap_hsmmc.c | 36 -----------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9dafcbf969d96..fca30add563e9 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1499,41 +1499,6 @@ static void omap_hsmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	omap_hsmmc_set_bus_mode(host);
 }
 
-static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
-{
-	struct omap_hsmmc_host *host = mmc_priv(mmc);
-
-	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
-		struct device_node *np = mmc_dev(mmc)->of_node;
-
-		/*
-		 * REVISIT: should be moved to sdio core and made more
-		 * general e.g. by expanding the DT bindings of child nodes
-		 * to provide a mechanism to provide this information:
-		 * Documentation/devicetree/bindings/mmc/mmc-card.yaml
-		 */
-
-		np = of_get_compatible_child(np, "ti,wl1251");
-		if (np) {
-			/*
-			 * We have TI wl1251 attached to MMC3. Pass this
-			 * information to the SDIO core because it can't be
-			 * probed by normal methods.
-			 */
-
-			dev_info(host->dev, "found wl1251\n");
-			card->quirks |= MMC_QUIRK_NONSTD_SDIO;
-			card->cccr.wide_bus = 1;
-			card->cis.vendor = 0x104c;
-			card->cis.device = 0x9066;
-			card->cis.blksize = 512;
-			card->cis.max_dtr = 24000000;
-			card->ocr = 0x80;
-			of_node_put(np);
-		}
-	}
-}
-
 static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
@@ -1660,7 +1625,6 @@ static struct mmc_host_ops omap_hsmmc_ops = {
 	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = mmc_gpio_get_cd,
 	.get_ro = mmc_gpio_get_ro,
-	.init_card = omap_hsmmc_init_card,
 	.enable_sdio_irq = omap_hsmmc_enable_sdio_irq,
 };
 
-- 
2.34.1

