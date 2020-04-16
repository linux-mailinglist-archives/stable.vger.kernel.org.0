Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916291AC2CE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896771AbgDPNdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896749AbgDPNdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:33:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC980208E4;
        Thu, 16 Apr 2020 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044020;
        bh=Dxv9GWgwYfpM4ZleMavZeL7T7rb9/AIQg6B8qLU2Pao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyHwonsuvtQeH9yygag5DTjDMgzcsxONJQyTs/T8dGxxyBga7Z3ffKPRVKkkPVISx
         n3gjzL9FMTe3qNiH0POJFxJBot7pGOdwLccswVSHhteWJsQ9OugGw91/lJoRMPsEPo
         6B6TgLOgXEZflYWzjNSZ+yzv++8ukUqIBKQ4xXfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 048/257] spi: spi-fsl-dspi: Avoid NULL pointer in dspi_slave_abort for non-DMA mode
Date:   Thu, 16 Apr 2020 15:21:39 +0200
Message-Id: <20200416131331.939656998@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 3d6224e63be39ff26cf416492cb3923cd3d07dd0 ]

The driver does not create the dspi->dma structure unless operating in
DSPI_DMA_MODE, so it makes sense to check for that.

Fixes: f4b323905d8b ("spi: Introduce dspi_slave_abort() function for NXP's dspi SPI driver")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20200318001603.9650-8-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 8428b69c858bc..a534b8af27b8d 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1021,8 +1021,10 @@ static int dspi_slave_abort(struct spi_master *master)
 	 * Terminate all pending DMA transactions for the SPI working
 	 * in SLAVE mode.
 	 */
-	dmaengine_terminate_sync(dspi->dma->chan_rx);
-	dmaengine_terminate_sync(dspi->dma->chan_tx);
+	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
+		dmaengine_terminate_sync(dspi->dma->chan_rx);
+		dmaengine_terminate_sync(dspi->dma->chan_tx);
+	}
 
 	/* Clear the internal DSPI RX and TX FIFO buffers */
 	regmap_update_bits(dspi->regmap, SPI_MCR,
-- 
2.20.1



