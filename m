Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2912C75B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfL2R1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbfL2R1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87C620722;
        Sun, 29 Dec 2019 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640465;
        bh=aViCECLoQEmKe9GP89XKGxpWmbxdZa6gBMW4ylTAiDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVX3GL3RU9h/nfjoXBIfo+prUiiN1UW1bnR97TdWzJptPWCu/XsjPst9zkIv4AALf
         x7WcMWEwHQzE/DM8GX8p0WnMT+FE8njHOurY4adh7P1GEPPseAOrOcsW7Oo94cjEHS
         tcOreaIsH6VTC306+F7JREl5G1N0x2VlyyVwJAQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/161] spi: tegra20-slink: add missed clk_unprepare
Date:   Sun, 29 Dec 2019 18:19:28 +0100
Message-Id: <20191229162435.179080819@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
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
index 9831c1106945..62b074b167a9 100644
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



