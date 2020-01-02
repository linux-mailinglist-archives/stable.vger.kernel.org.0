Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92A12EED4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgABWle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbgABWhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:37:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B2820866;
        Thu,  2 Jan 2020 22:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004624;
        bh=MwWttBtNzN/i0lLMDO007EKBFmGopDV8Av0V68y56dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCeSzjsAmHElYEidVKVV/6Gtc9yrkhP3Yi6VGMG/3s71kCdhGdABWGatl3ZhVFxFm
         k8EBNB25JlOxgbTMrrI3kbY4TiCczFxYmnr0F07obIeL8gxD2Xcfv0wSNk4NERo3WA
         5W4NXyyd9DmDA0m/MqCU6zH8PkcER0Ftr6W+7tAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/137] spi: tegra20-slink: add missed clk_unprepare
Date:   Thu,  2 Jan 2020 23:07:11 +0100
Message-Id: <20200102220554.317562031@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 04358e40ba96d687c0811c21d9dede73f5244a98 ]

The driver misses calling clk_unprepare in probe failure and remove.
Add the calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191115083122.12278-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index af2880d0c112..cf2a329fd895 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1078,7 +1078,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	ret = clk_enable(tspi->clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Clock enable failed %d\n", ret);
-		goto exit_free_master;
+		goto exit_clk_unprepare;
 	}
 
 	spi_irq = platform_get_irq(pdev, 0);
@@ -1151,6 +1151,8 @@ exit_free_irq:
 	free_irq(spi_irq, tspi);
 exit_clk_disable:
 	clk_disable(tspi->clk);
+exit_clk_unprepare:
+	clk_unprepare(tspi->clk);
 exit_free_master:
 	spi_master_put(master);
 	return ret;
@@ -1164,6 +1166,7 @@ static int tegra_slink_remove(struct platform_device *pdev)
 	free_irq(tspi->irq, tspi);
 
 	clk_disable(tspi->clk);
+	clk_unprepare(tspi->clk);
 
 	if (tspi->tx_dma_chan)
 		tegra_slink_deinit_dma_param(tspi, false);
-- 
2.20.1



