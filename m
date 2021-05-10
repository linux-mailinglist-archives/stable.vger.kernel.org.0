Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB237856F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhEJLAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234196AbhEJK4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F1AC61466;
        Mon, 10 May 2021 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643474;
        bh=M/+vdv7m2BJtYprDvTm8xYCLvC7XflMUiq1xKdH3+S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIrpSMw1KW5cCQ/fSQB895uTa7c3WFfgrm82SGzXchfq/w3otycPyumI8xLoCcxpG
         NZ3Y2Pnc51xH4Kh+nzDaCHzaJsn38Dnp56cfUrZmAyI6Vs62sEFSjv/4mAjGAVf4WN
         qcUjVFjK8t0vHBGRYPGYBCfylY752gQaR9nuxY7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 030/342] spi: spi-ti-qspi: Free DMA resources
Date:   Mon, 10 May 2021 12:17:00 +0200
Message-Id: <20210510102011.098138218@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -733,6 +733,17 @@ static int ti_qspi_runtime_resume(struct
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
@@ -886,6 +897,8 @@ no_dma:
 	if (!ret)
 		return 0;
 
+	ti_qspi_dma_cleanup(qspi);
+
 	pm_runtime_disable(&pdev->dev);
 free_master:
 	spi_master_put(master);
@@ -904,12 +917,7 @@ static int ti_qspi_remove(struct platfor
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


