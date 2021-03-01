Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF07C32901B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242641AbhCAUC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240616AbhCATwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E7364F47;
        Mon,  1 Mar 2021 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621158;
        bh=mDkW+A7na7sxGBnFyX9RLqrq1Zd3Jfo798K584dNJHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJXyNZcIhccw0k0dTahYh4R+vG3RCIT/2j4+P3QBnt1bfPQDYFq9tWhVoWKnmvG/v
         aE6gnijUWpPkCGN1D8QnCyycg69S5dGKWdRBNgU0e4kENztOCBgR46R3DNf3H+dtEi
         5rDmBqf2Fya/SSRdLPyIP+lkzXtKhmcOW+TFVgmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Orson Zhai <orson.zhai@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 397/775] mmc: sdhci-sprd: Fix some resource leaks in the remove function
Date:   Mon,  1 Mar 2021 17:09:25 +0100
Message-Id: <20210301161221.209406018@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index f85171edabeb9..5dc36efff47ff 100644
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



