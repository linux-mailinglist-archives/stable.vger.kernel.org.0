Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E744328C54
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhCAStl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240188AbhCASmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:42:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91EEC651EB;
        Mon,  1 Mar 2021 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619175;
        bh=UoxtFuE9UUq9KB7qxaXV/6C1ls3EnmrdBcFKySKle28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8zPSn6xMTYAG58OP9rgN12HTEkm7QmLGgAC84FQ5aQMtB2ypRmknTd27+APyD9/v
         X4/oEUjGufypvh1F+qdmw2zncW8pC1jfeO/T12PTAG+uxSm7oAOkhO0kmHHtRcrpxR
         gKH6daBdHFj2V+9Rvk725qfguumGqVWgEd9/L9Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Orson Zhai <orson.zhai@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/663] mmc: sdhci-sprd: Fix some resource leaks in the remove function
Date:   Mon,  1 Mar 2021 17:09:38 +0100
Message-Id: <20210301161158.176598423@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c9c256a8b0dc09c305c409d6264cc016af2ba38d ]

'sdhci_remove_host()' and 'sdhci_pltfm_free()' should be used in place of
'mmc_remove_host()' and 'mmc_free_host()'.

This avoids some resource leaks, is more in line with the error handling
path of the probe function, and is more consistent with other drivers.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Orson Zhai <orson.zhai@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201217204236.163446-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-sprd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 58109c5b53e2e..19cbb6171b358 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -708,14 +708,14 @@ static int sdhci_sprd_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
-	struct mmc_host *mmc = host->mmc;
 
-	mmc_remove_host(mmc);
+	sdhci_remove_host(host, 0);
+
 	clk_disable_unprepare(sprd_host->clk_sdio);
 	clk_disable_unprepare(sprd_host->clk_enable);
 	clk_disable_unprepare(sprd_host->clk_2x_enable);
 
-	mmc_free_host(mmc);
+	sdhci_pltfm_free(pdev);
 
 	return 0;
 }
-- 
2.27.0



