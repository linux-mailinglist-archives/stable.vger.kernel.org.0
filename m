Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5849999E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392240AbiAXVgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42470 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452896AbiAXV1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F21D2B812A7;
        Mon, 24 Jan 2022 21:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F9AC340E4;
        Mon, 24 Jan 2022 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059636;
        bh=VugHGI8+6S85HjqW94JyGeLrIidA8ZW1E+7xFGmNbvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwknhRKko4gRgnqWGES8sS/o3XUOfF0FeWg/QLttp1YG+Dnl3kOUJyB0xmjkP5hnj
         EMAAvrceKAeQ62XG4sh3aJjhPAtKvaKkp0y/6zQ2fynfsl4fNTj5bF+ZR4MrxUx3yd
         V/shXpUso9Ocw/1MzOTd9iOZ3ksblXJnUQTMyf3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0655/1039] mmc: tmio: reinit card irqs in reset routine
Date:   Mon, 24 Jan 2022 19:40:44 +0100
Message-Id: <20220124184147.379482173@linuxfoundation.org>
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



