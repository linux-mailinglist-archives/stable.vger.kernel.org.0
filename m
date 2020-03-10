Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83917FB75
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgCJNOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbgCJNOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:14:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85C220409;
        Tue, 10 Mar 2020 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846044;
        bh=3mJEIanfZb7Kw5O43tdvJdQdHeQ7nB3JD4XplgY27bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQSy/sUwfw1afE8QY/IXSug2DV9g4xRwXlKFldmVWoOvuCLHev7ds2/J3WAh0oWg3
         6M+2vjcnk5MWxJlT88VRNY1QWCepn0mpg/INHM2aUiXtcoCgyi4DuyfXNoNW4O0s5l
         TX3rsuYq3vFPTptvL7x7LYjI82GfD+5tCOvUT9eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/86] dmaengine: imx-sdma: remove dma_slave_config direction usage and leave sdma_event_enable()
Date:   Tue, 10 Mar 2020 13:45:28 +0100
Message-Id: <20200310124534.243875074@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 107d06441b709d31ce592535086992799ee51e17 ]

dma_slave_config direction was marked as deprecated quite some
time back, remove the usage from this driver so that the field
can be removed

ENBLn bit should be set before any dma request triggered, please
refer to the below information from i.mx6sololite RM. Otherwise,
spi/uart test will be fail because there is dma request from tx
fifo always before dmaengine_prep_slave_sg() in where ENBLn set
and violate the below rule.

https://www.nxp.com/docs/en/reference-manual/IMX6SLRM.pdf:

40.8.28 Channel Enable RAM (SDMAARM_CHNENBLn)
"It is thus essential for the Arm platform to program them before
any DMA request is triggered to the SDMA, otherwise an unpredictable
combination of channels may be started".

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
[vkoul: sqashed patch from Robin into direction change]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 56 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index ceb82e74f5b4e..eea89c3b54c1e 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -335,6 +335,7 @@ struct sdma_desc {
  * @sdma:		pointer to the SDMA engine for this channel
  * @channel:		the channel number, matches dmaengine chan_id + 1
  * @direction:		transfer type. Needed for setting SDMA script
+ * @slave_config	Slave configuration
  * @peripheral_type:	Peripheral type. Needed for setting SDMA script
  * @event_id0:		aka dma request line
  * @event_id1:		for channels that use 2 events
@@ -362,6 +363,7 @@ struct sdma_channel {
 	struct sdma_engine		*sdma;
 	unsigned int			channel;
 	enum dma_transfer_direction		direction;
+	struct dma_slave_config		slave_config;
 	enum sdma_peripheral_type	peripheral_type;
 	unsigned int			event_id0;
 	unsigned int			event_id1;
@@ -440,6 +442,10 @@ struct sdma_engine {
 	struct sdma_buffer_descriptor	*bd0;
 };
 
+static int sdma_config_write(struct dma_chan *chan,
+		       struct dma_slave_config *dmaengine_cfg,
+		       enum dma_transfer_direction direction);
+
 static struct sdma_driver_data sdma_imx31 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX31,
 	.num_events = 32,
@@ -1122,18 +1128,6 @@ static int sdma_config_channel(struct dma_chan *chan)
 	sdmac->shp_addr = 0;
 	sdmac->per_addr = 0;
 
-	if (sdmac->event_id0) {
-		if (sdmac->event_id0 >= sdmac->sdma->drvdata->num_events)
-			return -EINVAL;
-		sdma_event_enable(sdmac, sdmac->event_id0);
-	}
-
-	if (sdmac->event_id1) {
-		if (sdmac->event_id1 >= sdmac->sdma->drvdata->num_events)
-			return -EINVAL;
-		sdma_event_enable(sdmac, sdmac->event_id1);
-	}
-
 	switch (sdmac->peripheral_type) {
 	case IMX_DMATYPE_DSP:
 		sdma_config_ownership(sdmac, false, true, true);
@@ -1431,6 +1425,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 	struct scatterlist *sg;
 	struct sdma_desc *desc;
 
+	sdma_config_write(chan, &sdmac->slave_config, direction);
+
 	desc = sdma_transfer_init(sdmac, direction, sg_len);
 	if (!desc)
 		goto err_out;
@@ -1515,6 +1511,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 
 	dev_dbg(sdma->dev, "%s channel: %d\n", __func__, channel);
 
+	sdma_config_write(chan, &sdmac->slave_config, direction);
+
 	desc = sdma_transfer_init(sdmac, direction, num_periods);
 	if (!desc)
 		goto err_out;
@@ -1570,17 +1568,18 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 	return NULL;
 }
 
-static int sdma_config(struct dma_chan *chan,
-		       struct dma_slave_config *dmaengine_cfg)
+static int sdma_config_write(struct dma_chan *chan,
+		       struct dma_slave_config *dmaengine_cfg,
+		       enum dma_transfer_direction direction)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 
-	if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
+	if (direction == DMA_DEV_TO_MEM) {
 		sdmac->per_address = dmaengine_cfg->src_addr;
 		sdmac->watermark_level = dmaengine_cfg->src_maxburst *
 			dmaengine_cfg->src_addr_width;
 		sdmac->word_size = dmaengine_cfg->src_addr_width;
-	} else if (dmaengine_cfg->direction == DMA_DEV_TO_DEV) {
+	} else if (direction == DMA_DEV_TO_DEV) {
 		sdmac->per_address2 = dmaengine_cfg->src_addr;
 		sdmac->per_address = dmaengine_cfg->dst_addr;
 		sdmac->watermark_level = dmaengine_cfg->src_maxburst &
@@ -1594,10 +1593,33 @@ static int sdma_config(struct dma_chan *chan,
 			dmaengine_cfg->dst_addr_width;
 		sdmac->word_size = dmaengine_cfg->dst_addr_width;
 	}
-	sdmac->direction = dmaengine_cfg->direction;
+	sdmac->direction = direction;
 	return sdma_config_channel(chan);
 }
 
+static int sdma_config(struct dma_chan *chan,
+		       struct dma_slave_config *dmaengine_cfg)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+
+	memcpy(&sdmac->slave_config, dmaengine_cfg, sizeof(*dmaengine_cfg));
+
+	/* Set ENBLn earlier to make sure dma request triggered after that */
+	if (sdmac->event_id0) {
+		if (sdmac->event_id0 >= sdmac->sdma->drvdata->num_events)
+			return -EINVAL;
+		sdma_event_enable(sdmac, sdmac->event_id0);
+	}
+
+	if (sdmac->event_id1) {
+		if (sdmac->event_id1 >= sdmac->sdma->drvdata->num_events)
+			return -EINVAL;
+		sdma_event_enable(sdmac, sdmac->event_id1);
+	}
+
+	return 0;
+}
+
 static enum dma_status sdma_tx_status(struct dma_chan *chan,
 				      dma_cookie_t cookie,
 				      struct dma_tx_state *txstate)
-- 
2.20.1



