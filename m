Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCFD106EC4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfKVLAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730215AbfKVLAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D4E2073B;
        Fri, 22 Nov 2019 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420413;
        bh=EaemQSMRjOoOZA9hgJ+Xxl+flpaibVvlHklLcHHBV1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypX87GbCVuBinC+CRqa/galefcrqSgoPoEEJqMBra5KrBlQ+pcGMkPTUsI9zQiiAz
         6MhALTYW1fWgv4ovurRrl+Ula9H+oaNaVQdcqLyUIkKd3vmSVZjP8SNp7CT1H2Hujm
         cjWPTjHYjUOl+wIcmDseG1OTDrtFSOhuFAnOqP2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/220] ata: ep93xx: Use proper enums for directions
Date:   Fri, 22 Nov 2019 11:27:43 +0100
Message-Id: <20191122100919.794046625@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 6adde4a36f1b6a562a1057fbb1065007851050e7 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/ata/pata_ep93xx.c:662:36: warning: implicit conversion from
enumeration type 'enum dma_data_direction' to different enumeration type
'enum dma_transfer_direction' [-Wenum-conversion]
        drv_data->dma_rx_data.direction = DMA_FROM_DEVICE;
                                        ~ ^~~~~~~~~~~~~~~
drivers/ata/pata_ep93xx.c:670:36: warning: implicit conversion from
enumeration type 'enum dma_data_direction' to different enumeration type
'enum dma_transfer_direction' [-Wenum-conversion]
        drv_data->dma_tx_data.direction = DMA_TO_DEVICE;
                                        ~ ^~~~~~~~~~~~~
drivers/ata/pata_ep93xx.c:681:19: warning: implicit conversion from
enumeration type 'enum dma_data_direction' to different enumeration type
'enum dma_transfer_direction' [-Wenum-conversion]
        conf.direction = DMA_FROM_DEVICE;
                       ~ ^~~~~~~~~~~~~~~
drivers/ata/pata_ep93xx.c:692:19: warning: implicit conversion from
enumeration type 'enum dma_data_direction' to different enumeration type
'enum dma_transfer_direction' [-Wenum-conversion]
        conf.direction = DMA_TO_DEVICE;
                       ~ ^~~~~~~~~~~~~

Use the equivalent valued enums from the expected type so that Clang no
longer warns about a conversion.

DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
DMA_FROM_DEVICE = DMA_DEV_TO_MEM = 2

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ep93xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 0a550190955ad..cc6d06c1b2c70 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -659,7 +659,7 @@ static void ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	 * start of new transfer.
 	 */
 	drv_data->dma_rx_data.port = EP93XX_DMA_IDE;
-	drv_data->dma_rx_data.direction = DMA_FROM_DEVICE;
+	drv_data->dma_rx_data.direction = DMA_DEV_TO_MEM;
 	drv_data->dma_rx_data.name = "ep93xx-pata-rx";
 	drv_data->dma_rx_channel = dma_request_channel(mask,
 		ep93xx_pata_dma_filter, &drv_data->dma_rx_data);
@@ -667,7 +667,7 @@ static void ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 		return;
 
 	drv_data->dma_tx_data.port = EP93XX_DMA_IDE;
-	drv_data->dma_tx_data.direction = DMA_TO_DEVICE;
+	drv_data->dma_tx_data.direction = DMA_MEM_TO_DEV;
 	drv_data->dma_tx_data.name = "ep93xx-pata-tx";
 	drv_data->dma_tx_channel = dma_request_channel(mask,
 		ep93xx_pata_dma_filter, &drv_data->dma_tx_data);
@@ -678,7 +678,7 @@ static void ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 
 	/* Configure receive channel direction and source address */
 	memset(&conf, 0, sizeof(conf));
-	conf.direction = DMA_FROM_DEVICE;
+	conf.direction = DMA_DEV_TO_MEM;
 	conf.src_addr = drv_data->udma_in_phys;
 	conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	if (dmaengine_slave_config(drv_data->dma_rx_channel, &conf)) {
@@ -689,7 +689,7 @@ static void ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 
 	/* Configure transmit channel direction and destination address */
 	memset(&conf, 0, sizeof(conf));
-	conf.direction = DMA_TO_DEVICE;
+	conf.direction = DMA_MEM_TO_DEV;
 	conf.dst_addr = drv_data->udma_out_phys;
 	conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	if (dmaengine_slave_config(drv_data->dma_tx_channel, &conf)) {
-- 
2.20.1



