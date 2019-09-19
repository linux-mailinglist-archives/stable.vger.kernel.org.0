Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD1B871C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406458AbfISWds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405841AbfISWLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9AB521920;
        Thu, 19 Sep 2019 22:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931066;
        bh=g76naGs97Ybb8HLkSTNdZwBrQayN+tkzV82EWo/D3AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmDQCDesxvoUXdJKYOdE4xUHWQIdzxvFCVtJDbBgfVpXi00MzmPlrYeNReQDWY7mx
         lZ27nXk+YihsamzZ4toQ6K9yvdkoz5D/JvBMaiQil9yG9LlbsLdyNtlX2GuTB6GHti
         16Js3+zja3+OChHeM7LSUnzpMpTMfzhbM/H33FZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 116/124] dmaengine: rcar-dmac: Fix DMACHCLR handling if iommu is mapped
Date:   Fri, 20 Sep 2019 00:03:24 +0200
Message-Id: <20190919214823.402195765@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit cf24aac38698bfa1d021afd3883df3c4c65143a4 ]

The commit 20c169aceb45 ("dmaengine: rcar-dmac: clear pertinence
number of channels") forgets to clear the last channel by
DMACHCLR in rcar_dmac_init() (and doesn't need to clear the first
channel) if iommu is mapped to the device. So, this patch fixes it
by using "channels_mask" bitfield.

Note that the hardware and driver don't support more than 32 bits
in DMACHCLR register anyway, so this patch should reject more than
32 channels in rcar_dmac_parse_of().

Fixes: 20c169aceb459575 ("dmaengine: rcar-dmac: clear pertinence number of channels")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1567424643-26629-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rcar-dmac.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 54de669c38b84..f1d89bdebddab 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -192,6 +192,7 @@ struct rcar_dmac_chan {
  * @iomem: remapped I/O memory base
  * @n_channels: number of available channels
  * @channels: array of DMAC channels
+ * @channels_mask: bitfield of which DMA channels are managed by this driver
  * @modules: bitmask of client modules in use
  */
 struct rcar_dmac {
@@ -202,6 +203,7 @@ struct rcar_dmac {
 
 	unsigned int n_channels;
 	struct rcar_dmac_chan *channels;
+	unsigned int channels_mask;
 
 	DECLARE_BITMAP(modules, 256);
 };
@@ -438,7 +440,7 @@ static int rcar_dmac_init(struct rcar_dmac *dmac)
 	u16 dmaor;
 
 	/* Clear all channels and enable the DMAC globally. */
-	rcar_dmac_write(dmac, RCAR_DMACHCLR, GENMASK(dmac->n_channels - 1, 0));
+	rcar_dmac_write(dmac, RCAR_DMACHCLR, dmac->channels_mask);
 	rcar_dmac_write(dmac, RCAR_DMAOR,
 			RCAR_DMAOR_PRI_FIXED | RCAR_DMAOR_DME);
 
@@ -814,6 +816,9 @@ static void rcar_dmac_stop_all_chan(struct rcar_dmac *dmac)
 	for (i = 0; i < dmac->n_channels; ++i) {
 		struct rcar_dmac_chan *chan = &dmac->channels[i];
 
+		if (!(dmac->channels_mask & BIT(i)))
+			continue;
+
 		/* Stop and reinitialize the channel. */
 		spin_lock_irq(&chan->lock);
 		rcar_dmac_chan_halt(chan);
@@ -1776,6 +1781,8 @@ static int rcar_dmac_chan_probe(struct rcar_dmac *dmac,
 	return 0;
 }
 
+#define RCAR_DMAC_MAX_CHANNELS	32
+
 static int rcar_dmac_parse_of(struct device *dev, struct rcar_dmac *dmac)
 {
 	struct device_node *np = dev->of_node;
@@ -1787,12 +1794,16 @@ static int rcar_dmac_parse_of(struct device *dev, struct rcar_dmac *dmac)
 		return ret;
 	}
 
-	if (dmac->n_channels <= 0 || dmac->n_channels >= 100) {
+	/* The hardware and driver don't support more than 32 bits in CHCLR */
+	if (dmac->n_channels <= 0 ||
+	    dmac->n_channels >= RCAR_DMAC_MAX_CHANNELS) {
 		dev_err(dev, "invalid number of channels %u\n",
 			dmac->n_channels);
 		return -EINVAL;
 	}
 
+	dmac->channels_mask = GENMASK(dmac->n_channels - 1, 0);
+
 	return 0;
 }
 
@@ -1802,7 +1813,6 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 		DMA_SLAVE_BUSWIDTH_2_BYTES | DMA_SLAVE_BUSWIDTH_4_BYTES |
 		DMA_SLAVE_BUSWIDTH_8_BYTES | DMA_SLAVE_BUSWIDTH_16_BYTES |
 		DMA_SLAVE_BUSWIDTH_32_BYTES | DMA_SLAVE_BUSWIDTH_64_BYTES;
-	unsigned int channels_offset = 0;
 	struct dma_device *engine;
 	struct rcar_dmac *dmac;
 	struct resource *mem;
@@ -1831,10 +1841,8 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 	 * level we can't disable it selectively, so ignore channel 0 for now if
 	 * the device is part of an IOMMU group.
 	 */
-	if (device_iommu_mapped(&pdev->dev)) {
-		dmac->n_channels--;
-		channels_offset = 1;
-	}
+	if (device_iommu_mapped(&pdev->dev))
+		dmac->channels_mask &= ~BIT(0);
 
 	dmac->channels = devm_kcalloc(&pdev->dev, dmac->n_channels,
 				      sizeof(*dmac->channels), GFP_KERNEL);
@@ -1892,8 +1900,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->channels);
 
 	for (i = 0; i < dmac->n_channels; ++i) {
-		ret = rcar_dmac_chan_probe(dmac, &dmac->channels[i],
-					   i + channels_offset);
+		if (!(dmac->channels_mask & BIT(i)))
+			continue;
+
+		ret = rcar_dmac_chan_probe(dmac, &dmac->channels[i], i);
 		if (ret < 0)
 			goto error;
 	}
-- 
2.20.1



