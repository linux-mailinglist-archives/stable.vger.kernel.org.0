Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B92167877
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgBUHqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgBUHqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:46:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDC824673;
        Fri, 21 Feb 2020 07:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271170;
        bh=m4jyVE18pfZq4qi+TJEPKig9Dd0guUKdRgNJXmVZibI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBJox8ve3LEncH7UMCcme+d2ZHnrGc05i0zdInZbH21APtJ3ucnXfnW3NbnZU+LkA
         sX9QYW75n6eEqPhe0hT3ARg+GL+J+jsnwfEQe/yradoZpKc7H8sGO4dPQbYkcT3Q/s
         QM9dSQsNxIJbMFWolbg+L19vbGtQU4f2+pgKvtB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 064/399] spi: fsl-lpspi: fix only one cs-gpio working
Date:   Fri, 21 Feb 2020 08:36:29 +0100
Message-Id: <20200221072408.604738913@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit bc3a8b295e5bca9d1ec2622a6ba38289f9fd3d8a ]

Why it does not work at the moment:
- num_chipselect sets the number of cs-gpios that are in the DT.
  This comes from drivers/spi/spi.c
- num_chipselect gets set with devm_spi_register_controller, that is
  called in drivers/spi/spi.c
- devm_spi_register_controller got called after num_chipselect has
  been used.

How this commit fixes the issue:
- devm_spi_register_controller gets called before num_chipselect is
  being used.

Fixes: c7a402599504 ("spi: lpspi: use the core way to implement cs-gpio function")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Link: https://lore.kernel.org/r/20191204141312.1411251-1-philippe.schenker@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 2cc0ddb4a9889..1375bdfc587bf 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -862,6 +862,22 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	fsl_lpspi->dev = &pdev->dev;
 	fsl_lpspi->is_slave = is_slave;
 
+	controller->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 32);
+	controller->transfer_one = fsl_lpspi_transfer_one;
+	controller->prepare_transfer_hardware = lpspi_prepare_xfer_hardware;
+	controller->unprepare_transfer_hardware = lpspi_unprepare_xfer_hardware;
+	controller->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	controller->flags = SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX;
+	controller->dev.of_node = pdev->dev.of_node;
+	controller->bus_num = pdev->id;
+	controller->slave_abort = fsl_lpspi_slave_abort;
+
+	ret = devm_spi_register_controller(&pdev->dev, controller);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "spi_register_controller error.\n");
+		goto out_controller_put;
+	}
+
 	if (!fsl_lpspi->is_slave) {
 		for (i = 0; i < controller->num_chipselect; i++) {
 			int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
@@ -885,16 +901,6 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		controller->prepare_message = fsl_lpspi_prepare_message;
 	}
 
-	controller->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 32);
-	controller->transfer_one = fsl_lpspi_transfer_one;
-	controller->prepare_transfer_hardware = lpspi_prepare_xfer_hardware;
-	controller->unprepare_transfer_hardware = lpspi_unprepare_xfer_hardware;
-	controller->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
-	controller->flags = SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX;
-	controller->dev.of_node = pdev->dev.of_node;
-	controller->bus_num = pdev->id;
-	controller->slave_abort = fsl_lpspi_slave_abort;
-
 	init_completion(&fsl_lpspi->xfer_done);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -952,12 +958,6 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		dev_err(&pdev->dev, "dma setup error %d, use pio\n", ret);
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "spi_register_controller error.\n");
-		goto out_controller_put;
-	}
-
 	return 0;
 
 out_controller_put:
-- 
2.20.1



