Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271D61194C7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbfLJVMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbfLJVMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0733321D7D;
        Tue, 10 Dec 2019 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012367;
        bh=6ZrutHCfZULgWK9SE9TNvRak3OhPphztuTeNSWShhDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KbGam5OJsS+KXI8h/v6GW75D13gKPEShJFH8VQiSV6iSt7ieyqIHPZ4PN8paqTPV
         xRoiqys+Sxwof8UxAO5SQhuLXKSu/Xjhz79BPNm+Y7y/pVDUSqurtWIC0YsyPV780d
         GFLDEfjxV8MhG1TWeP7mWpag1yAv1iz2FIvgGXu4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 294/350] spi: tegra20-slink: add missed clk_unprepare
Date:   Tue, 10 Dec 2019 16:06:39 -0500
Message-Id: <20191210210735.9077-255-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 111fffc91435c..374a2a32edcd3 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1073,7 +1073,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	ret = clk_enable(tspi->clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Clock enable failed %d\n", ret);
-		goto exit_free_master;
+		goto exit_clk_unprepare;
 	}
 
 	spi_irq = platform_get_irq(pdev, 0);
@@ -1146,6 +1146,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	free_irq(spi_irq, tspi);
 exit_clk_disable:
 	clk_disable(tspi->clk);
+exit_clk_unprepare:
+	clk_unprepare(tspi->clk);
 exit_free_master:
 	spi_master_put(master);
 	return ret;
@@ -1159,6 +1161,7 @@ static int tegra_slink_remove(struct platform_device *pdev)
 	free_irq(tspi->irq, tspi);
 
 	clk_disable(tspi->clk);
+	clk_unprepare(tspi->clk);
 
 	if (tspi->tx_dma_chan)
 		tegra_slink_deinit_dma_param(tspi, false);
-- 
2.20.1

