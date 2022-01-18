Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8099549158D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245246AbiARC2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43832 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245193AbiARC0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C3961127;
        Tue, 18 Jan 2022 02:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41291C36AF5;
        Tue, 18 Jan 2022 02:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472798;
        bh=VugHGI8+6S85HjqW94JyGeLrIidA8ZW1E+7xFGmNbvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBE3iL4fGTIfln9vpQsQX07Sgx3NTqqvv19ZkdH0U6z+su6rMLVij1XJS9rVYw8Xy
         VLTcyWHZH6TlKOV8FIBxz1coVbgNBk+9wxqzM7mTgXCHPgGksfFGR5gfHbhgUtOsdC
         MCL9Q+YmQqnxEUkSlU67d3ocpna13KHSu/BbBq8rvBk3DPTShCe/yPhRCNHU3R6FIC
         +feUJfqxP+6+fsP0NJt82kkbTzCQQZszMapA05ApJ/Pd1SXAsnMlgRdhBYGCcmVvBF
         SBixBu1x832q/Lp0hzEi0BN7TdwHKY/BkRDYLLAAFJ+iM9zIsrl+3KX8WlXd/UtWga
         ViDWxlF4vRXAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 137/217] mmc: tmio: reinit card irqs in reset routine
Date:   Mon, 17 Jan 2022 21:18:20 -0500
Message-Id: <20220118021940.1942199-137-sashal@kernel.org>
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

