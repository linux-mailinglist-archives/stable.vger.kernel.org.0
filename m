Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37AC40954C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347858AbhIMOkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345049AbhIMOhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01D7A61BF8;
        Mon, 13 Sep 2021 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541260;
        bh=4To1bOUCDLgmDWAARWr6k4/bL8hIqGaRJ22HHKwMkho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRE1+WgtslQxNvCfZvN19sBtuOsVOsjmWKJvoxlG/plI5jtoyJ2g5GWOpjQkVN/nC
         vPmLJkk+m5DMVWl61zJDoQTHjDmEApVlnEpY2NjjKhn9wzetZrfiZO4zwkCEFhGxXD
         i+wBXxLbq/bWOCDiB2cIJBSMjohs3BDm7YoeuH6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 227/334] ASoC: fsl_rpmsg: Check -EPROBE_DEFER for getting clocks
Date:   Mon, 13 Sep 2021 15:14:41 +0200
Message-Id: <20210913131121.094265963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 2fbbcffea5b6adbfe90ffc842a6b3eb2d7e381ed ]

The devm_clk_get() may return -EPROBE_DEFER, then clocks
will be assigned to NULL wrongly. As the clocks are
optional so we can use devm_clk_get_optional() instead of
devm_clk_get().

Fixes: b73d9e6225e8 ("ASoC: fsl_rpmsg: Add CPU DAI driver for audio base on rpmsg")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1629266614-6942-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_rpmsg.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/fsl/fsl_rpmsg.c b/sound/soc/fsl/fsl_rpmsg.c
index ea5c973e2e84..d60f4dac6c1b 100644
--- a/sound/soc/fsl/fsl_rpmsg.c
+++ b/sound/soc/fsl/fsl_rpmsg.c
@@ -165,25 +165,25 @@ static int fsl_rpmsg_probe(struct platform_device *pdev)
 	}
 
 	/* Get the optional clocks */
-	rpmsg->ipg = devm_clk_get(&pdev->dev, "ipg");
+	rpmsg->ipg = devm_clk_get_optional(&pdev->dev, "ipg");
 	if (IS_ERR(rpmsg->ipg))
-		rpmsg->ipg = NULL;
+		return PTR_ERR(rpmsg->ipg);
 
-	rpmsg->mclk = devm_clk_get(&pdev->dev, "mclk");
+	rpmsg->mclk = devm_clk_get_optional(&pdev->dev, "mclk");
 	if (IS_ERR(rpmsg->mclk))
-		rpmsg->mclk = NULL;
+		return PTR_ERR(rpmsg->mclk);
 
-	rpmsg->dma = devm_clk_get(&pdev->dev, "dma");
+	rpmsg->dma = devm_clk_get_optional(&pdev->dev, "dma");
 	if (IS_ERR(rpmsg->dma))
-		rpmsg->dma = NULL;
+		return PTR_ERR(rpmsg->dma);
 
-	rpmsg->pll8k = devm_clk_get(&pdev->dev, "pll8k");
+	rpmsg->pll8k = devm_clk_get_optional(&pdev->dev, "pll8k");
 	if (IS_ERR(rpmsg->pll8k))
-		rpmsg->pll8k = NULL;
+		return PTR_ERR(rpmsg->pll8k);
 
-	rpmsg->pll11k = devm_clk_get(&pdev->dev, "pll11k");
+	rpmsg->pll11k = devm_clk_get_optional(&pdev->dev, "pll11k");
 	if (IS_ERR(rpmsg->pll11k))
-		rpmsg->pll11k = NULL;
+		return PTR_ERR(rpmsg->pll11k);
 
 	platform_set_drvdata(pdev, rpmsg);
 	pm_runtime_enable(&pdev->dev);
-- 
2.30.2



