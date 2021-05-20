Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D038A5DD
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhETKUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235255AbhETKTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42D1619A9;
        Thu, 20 May 2021 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504016;
        bh=/mj8Lz2qhNc0xP33Z4WoVs2t11srSRuqSlt2+4w9z2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOaWpa63xpSRyLyYlADic2lMEK6CI2vSAHcKZgWGXlRoGCSsqsm0mz0MagdiL9Hgc
         op0IGxWRHWU9V2c2hKoKUBxaIdQ75V8aLqAvthZVIMqSaEDHtRwI+Vr6LGkzLUubf1
         0RsUXBC/UjB6MDjD+s7be2Rlt3teLXtsNPEaGT40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 022/323] spi: spi-ti-qspi: Free DMA resources
Date:   Thu, 20 May 2021 11:18:34 +0200
Message-Id: <20210520092120.875655092@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 1d309cd688a76fb733f0089d36dc630327b32d59 upstream.

Release the RX channel and free the dma coherent memory when
devm_spi_register_master() fails.

Fixes: 5720ec0a6d26 ("spi: spi-ti-qspi: Add DMA support for QSPI mmap read")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20210218130950.90155-1-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -643,6 +643,17 @@ static int ti_qspi_runtime_resume(struct
 	return 0;
 }
 
+static void ti_qspi_dma_cleanup(struct ti_qspi *qspi)
+{
+	if (qspi->rx_bb_addr)
+		dma_free_coherent(qspi->dev, QSPI_DMA_BUFFER_SIZE,
+				  qspi->rx_bb_addr,
+				  qspi->rx_bb_dma_addr);
+
+	if (qspi->rx_chan)
+		dma_release_channel(qspi->rx_chan);
+}
+
 static const struct of_device_id ti_qspi_match[] = {
 	{.compatible = "ti,dra7xxx-qspi" },
 	{.compatible = "ti,am4372-qspi" },
@@ -794,6 +805,8 @@ no_dma:
 	if (!ret)
 		return 0;
 
+	ti_qspi_dma_cleanup(qspi);
+
 	pm_runtime_disable(&pdev->dev);
 free_master:
 	spi_master_put(master);
@@ -812,12 +825,7 @@ static int ti_qspi_remove(struct platfor
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	if (qspi->rx_bb_addr)
-		dma_free_coherent(qspi->dev, QSPI_DMA_BUFFER_SIZE,
-				  qspi->rx_bb_addr,
-				  qspi->rx_bb_dma_addr);
-	if (qspi->rx_chan)
-		dma_release_channel(qspi->rx_chan);
+	ti_qspi_dma_cleanup(qspi);
 
 	return 0;
 }


