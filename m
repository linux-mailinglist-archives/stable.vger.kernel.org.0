Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047C27C47E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgI2LOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbgI2LOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB7B208FE;
        Tue, 29 Sep 2020 11:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378063;
        bh=+bQuNrwBC+2CCwgy9Vn+XlWdoQkontIttZ1dYvINHiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Pw6D8P9KWmETOS/XiuDIpLHEdydHwxb2HXZS7sVsNYIXorWiXvpNEd9xF0l7J/lV
         hoYY/E2BIuupaKYUiWUnmHs6uwUDGKOQB7hl8lBFxn+Ek40nZC+5/U2MDnYVU0GZJK
         /BIBQNT1fZg7KAW2emrdRUsDPkIsvouGIGgasGcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Fend <matthias.fend@wolfvision.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/166] dmaengine: zynqmp_dma: fix burst length configuration
Date:   Tue, 29 Sep 2020 12:59:20 +0200
Message-Id: <20200929105937.606381337@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Fend <matthias.fend@wolfvision.net>

[ Upstream commit cc88525ebffc757e00cc5a5d61da6271646c7f5f ]

Since the dma engine expects the burst length register content as
power of 2 value, the burst length needs to be converted first.
Additionally add a burst length range check to avoid corrupting unrelated
register bits.

Signed-off-by: Matthias Fend <matthias.fend@wolfvision.net>
Link: https://lore.kernel.org/r/20200115102249.24398-1-matthias.fend@wolfvision.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 6d86d05e53aa1..66d6640766ed8 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -125,10 +125,12 @@
 /* Max transfer size per descriptor */
 #define ZYNQMP_DMA_MAX_TRANS_LEN	0x40000000
 
+/* Max burst lengths */
+#define ZYNQMP_DMA_MAX_DST_BURST_LEN    32768U
+#define ZYNQMP_DMA_MAX_SRC_BURST_LEN    32768U
+
 /* Reset values for data attributes */
 #define ZYNQMP_DMA_AXCACHE_VAL		0xF
-#define ZYNQMP_DMA_ARLEN_RST_VAL	0xF
-#define ZYNQMP_DMA_AWLEN_RST_VAL	0xF
 
 #define ZYNQMP_DMA_SRC_ISSUE_RST_VAL	0x1F
 
@@ -527,17 +529,19 @@ static void zynqmp_dma_handle_ovfl_int(struct zynqmp_dma_chan *chan, u32 status)
 
 static void zynqmp_dma_config(struct zynqmp_dma_chan *chan)
 {
-	u32 val;
+	u32 val, burst_val;
 
 	val = readl(chan->regs + ZYNQMP_DMA_CTRL0);
 	val |= ZYNQMP_DMA_POINT_TYPE_SG;
 	writel(val, chan->regs + ZYNQMP_DMA_CTRL0);
 
 	val = readl(chan->regs + ZYNQMP_DMA_DATA_ATTR);
+	burst_val = __ilog2_u32(chan->src_burst_len);
 	val = (val & ~ZYNQMP_DMA_ARLEN) |
-		(chan->src_burst_len << ZYNQMP_DMA_ARLEN_OFST);
+		((burst_val << ZYNQMP_DMA_ARLEN_OFST) & ZYNQMP_DMA_ARLEN);
+	burst_val = __ilog2_u32(chan->dst_burst_len);
 	val = (val & ~ZYNQMP_DMA_AWLEN) |
-		(chan->dst_burst_len << ZYNQMP_DMA_AWLEN_OFST);
+		((burst_val << ZYNQMP_DMA_AWLEN_OFST) & ZYNQMP_DMA_AWLEN);
 	writel(val, chan->regs + ZYNQMP_DMA_DATA_ATTR);
 }
 
@@ -551,8 +555,10 @@ static int zynqmp_dma_device_config(struct dma_chan *dchan,
 {
 	struct zynqmp_dma_chan *chan = to_chan(dchan);
 
-	chan->src_burst_len = config->src_maxburst;
-	chan->dst_burst_len = config->dst_maxburst;
+	chan->src_burst_len = clamp(config->src_maxburst, 1U,
+		ZYNQMP_DMA_MAX_SRC_BURST_LEN);
+	chan->dst_burst_len = clamp(config->dst_maxburst, 1U,
+		ZYNQMP_DMA_MAX_DST_BURST_LEN);
 
 	return 0;
 }
@@ -873,8 +879,8 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 		return PTR_ERR(chan->regs);
 
 	chan->bus_width = ZYNQMP_DMA_BUS_WIDTH_64;
-	chan->dst_burst_len = ZYNQMP_DMA_AWLEN_RST_VAL;
-	chan->src_burst_len = ZYNQMP_DMA_ARLEN_RST_VAL;
+	chan->dst_burst_len = ZYNQMP_DMA_MAX_DST_BURST_LEN;
+	chan->src_burst_len = ZYNQMP_DMA_MAX_SRC_BURST_LEN;
 	err = of_property_read_u32(node, "xlnx,bus-width", &chan->bus_width);
 	if (err < 0) {
 		dev_err(&pdev->dev, "missing xlnx,bus-width property\n");
-- 
2.25.1



