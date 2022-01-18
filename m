Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE44A491864
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbiARCqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245636AbiARCnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26934C08E874;
        Mon, 17 Jan 2022 18:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C04D8B8122C;
        Tue, 18 Jan 2022 02:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70FAC36AEB;
        Tue, 18 Jan 2022 02:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473436;
        bh=VugHGI8+6S85HjqW94JyGeLrIidA8ZW1E+7xFGmNbvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnPh2V2PPsPm0obMlOeabLkYVZ7khhYeXbKNQdyKawHuS8JD8IRndjm4Eto49rMEX
         5wpKKnLZlZsv5JpbvCGoDFiegcOuFwI4tIdBRmUwYoZuW6Y+zalbx6tw58GBSU0AhG
         vD+TeB6flqboTVqOFiFpTUSUzelyN7J6UI2K9KqFUKIpP71vcQAbkgMAblq2+AgGqJ
         7iLlaCD8ENnN6nQjyBdhXkrId1I5BWpOy1Yc8MptY0/dsRm6+0ihPSjFn9vsudmxn5
         +6hRG1fzhImnpezVAhKbaBeLe8XWnvcTT0EbzUWmAXbV67Hq5U4BXbLiUqZgrGb5I8
         L+oZehXp1aj/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 117/188] mmc: tmio: reinit card irqs in reset routine
Date:   Mon, 17 Jan 2022 21:30:41 -0500
Message-Id: <20220118023152.1948105-117-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit e315b1f3a170f368da5618f8a598e68880302ed1 ]

Refactor the code so that card detect irqs are always reenabled after a
reset. This avoids doing it manually all over the code or forgetting to
do this in the future.

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
[wsa: added a comment when 'native_hotplug' has to be set]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20211103122646.64422-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index e2affa52ef469..a5850d83908be 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -960,14 +960,8 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	case MMC_POWER_OFF:
 		tmio_mmc_power_off(host);
 		/* For R-Car Gen2+, we need to reset SDHI specific SCC */
-		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2) {
-			host->reset(host);
-
-			if (host->native_hotplug)
-				tmio_mmc_enable_mmc_irqs(host,
-						TMIO_STAT_CARD_REMOVE |
-						TMIO_STAT_CARD_INSERT);
-		}
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+			tmio_mmc_reset(host);
 
 		host->set_clock(host, 0);
 		break;
@@ -1175,6 +1169,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host *_host)
 	if (mmc_can_gpio_cd(mmc))
 		_host->ops.get_cd = mmc_gpio_get_cd;
 
+	/* must be set before tmio_mmc_reset() */
 	_host->native_hotplug = !(mmc_can_gpio_cd(mmc) ||
 				  mmc->caps & MMC_CAP_NEEDS_POLL ||
 				  !mmc_card_is_removable(mmc));
@@ -1295,10 +1290,6 @@ int tmio_mmc_host_runtime_resume(struct device *dev)
 	if (host->clk_cache)
 		host->set_clock(host, host->clk_cache);
 
-	if (host->native_hotplug)
-		tmio_mmc_enable_mmc_irqs(host,
-				TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT);
-
 	tmio_mmc_enable_dma(host, true);
 
 	return 0;
-- 
2.34.1

