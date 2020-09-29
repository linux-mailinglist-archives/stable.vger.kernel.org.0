Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40D727B97D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgI2BbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbgI2BbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C26A21D46;
        Tue, 29 Sep 2020 01:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343063;
        bh=i8E2TtvfhI6oB8OTuqVbslQiifotlH/tgoJgMGhWqH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvcMbKp0NZUlgrL6ojRW4t6t32IY4Cpyacgr035c7zu6SljPz5glaxFWHTFACjdDz
         oC/WNbh6gwSZFIvvi9hwKK4Bp4Wz7LGedpJmM+ssmRuuM2Fn5nsULBqhGltfGYd0no
         o50q5l6AhW7ipQTlapstw9RutQ+5N64lTkeARMBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 28/29] spi: fsl-dspi: fix use-after-free in remove path
Date:   Mon, 28 Sep 2020 21:30:25 -0400
Message-Id: <20200929013027.2406344-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 530b5affc675ade5db4a03f04ed7cd66806c8a1a ]

spi_unregister_controller() not only unregisters the controller, but
also frees the controller. This will free the driver data with it, so
we must not access it later dspi_remove().

Solve this by allocating the driver data separately from the SPI
controller.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20200923131026.20707-1-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 91c6affe139c9..aae9f9a7aea6c 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1273,11 +1273,14 @@ static int dspi_probe(struct platform_device *pdev)
 	void __iomem *base;
 	bool big_endian;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(struct fsl_dspi));
+	dspi = devm_kzalloc(&pdev->dev, sizeof(*dspi), GFP_KERNEL);
+	if (!dspi)
+		return -ENOMEM;
+
+	ctlr = spi_alloc_master(&pdev->dev, 0);
 	if (!ctlr)
 		return -ENOMEM;
 
-	dspi = spi_controller_get_devdata(ctlr);
 	dspi->pdev = pdev;
 	dspi->ctlr = ctlr;
 
@@ -1414,7 +1417,7 @@ static int dspi_probe(struct platform_device *pdev)
 	if (dspi->devtype_data->trans_mode != DSPI_DMA_MODE)
 		ctlr->ptp_sts_supported = true;
 
-	platform_set_drvdata(pdev, ctlr);
+	platform_set_drvdata(pdev, dspi);
 
 	ret = spi_register_controller(ctlr);
 	if (ret != 0) {
@@ -1437,8 +1440,7 @@ static int dspi_probe(struct platform_device *pdev)
 
 static int dspi_remove(struct platform_device *pdev)
 {
-	struct spi_controller *ctlr = platform_get_drvdata(pdev);
-	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
+	struct fsl_dspi *dspi = platform_get_drvdata(pdev);
 
 	/* Disconnect from the SPI framework */
 	spi_unregister_controller(dspi->ctlr);
-- 
2.25.1

