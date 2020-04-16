Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC1A1AC831
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394919AbgDPPEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441716AbgDPNxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487FB20786;
        Thu, 16 Apr 2020 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045185;
        bh=+tVkHlpjfi2FdI+R1g0HWl2/qGo+Rc7EYvcZTCZ7d7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eai/2iwuLyKlf7SQzjB+fkUfRmzssVyw0sTGge6SFJ7WYdoyVuc0AIPmDNm4sh8r9
         TqM/ansYSe4xGB0OmZa8zucXxaY5gvyjXkItMyICAAdeW+kdEsAHvOR2GlpKKQH+uS
         l3VdBAv2JtXPxsw/3YPnneg+RVR99RvkO69hDOdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 031/254] spi: spi-fsl-dspi: Avoid NULL pointer in dspi_slave_abort for non-DMA mode
Date:   Thu, 16 Apr 2020 15:22:00 +0200
Message-Id: <20200416131329.754688943@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
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
index 6ec2dcb8c57a6..2ce65edf16b66 100644
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



