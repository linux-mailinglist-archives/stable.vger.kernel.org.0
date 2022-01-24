Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576A849A40D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369264AbiAYABV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847528AbiAXXUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9047C06F8FB;
        Mon, 24 Jan 2022 13:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 769A06136E;
        Mon, 24 Jan 2022 21:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501CAC340E4;
        Mon, 24 Jan 2022 21:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059659;
        bh=wnlzurwnqQUQibaZHONoMred/MZWh5Vz2vdlyjP1zDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRTetLi0fCNRZnNZUVPjgi2fHD5hyl/0jJAwL+Q+nGwdpHAeKASv2006WaA5skQYU
         F8X9PWrCkxp6a6Q9DbqQVEPTpQWLXB3zeNf8HYQ6Jh7GgCNq00xOC38cIuunH2R5bd
         ij5vO5nEND7Ke2UdOEwefqEMXMOuF7RYwKN+IUcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0657/1039] mmc: omap_hsmmc: Revert special init for wl1251
Date:   Mon, 24 Jan 2022 19:40:46 +0100
Message-Id: <20220124184147.454092568@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

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



