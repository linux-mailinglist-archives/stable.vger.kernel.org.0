Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B479068959F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjBCKTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjBCKS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:18:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0059DEEC;
        Fri,  3 Feb 2023 02:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93602B8287A;
        Fri,  3 Feb 2023 10:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A3C4339B;
        Fri,  3 Feb 2023 10:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419504;
        bh=bpFz5jIFWiqNjVmsGb3GITZto1VqCdnJyj0HhMlQOYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAn74kXn/mzf1YgtNbiUO7CAQtB2HzHUDkB8Ye98kcQDWN72wV0KHGF0TqpP4csim
         GHNLXO8J3+eOwOPMquq8LWSzG1LkpSGh09fdpbzu83bJ7utl4FRp11m2hl1iX8OctL
         5eW1AgwHYN9b03PZ8oHepQGMn5qRBkgk88nu6fNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 4.19 26/80] dmaengine: xilinx_dma: program hardware supported buffer length
Date:   Fri,  3 Feb 2023 11:12:20 +0100
Message-Id: <20230203101016.284409147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit ae809690b46a71dc56cda5b3b8884c8c41a0df15 ]

AXI-DMA IP supports configurable (c_sg_length_width) buffer length
register width, hence read buffer length (xlnx,sg-length-width) DT
property and ensure that driver doesn't program buffer length
exceeding the supported limit. For VDMA and CDMA there is no change.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com> [rebase, reword]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 596b53ccc36a ("dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index e4ea94b93400..6687cee26843 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -164,7 +164,9 @@
 #define XILINX_DMA_REG_BTT		0x28
 
 /* AXI DMA Specific Masks/Bit fields */
-#define XILINX_DMA_MAX_TRANS_LEN	GENMASK(22, 0)
+#define XILINX_DMA_MAX_TRANS_LEN_MIN	8
+#define XILINX_DMA_MAX_TRANS_LEN_MAX	23
+#define XILINX_DMA_V2_MAX_TRANS_LEN_MAX	26
 #define XILINX_DMA_CR_COALESCE_MAX	GENMASK(23, 16)
 #define XILINX_DMA_CR_CYCLIC_BD_EN_MASK	BIT(4)
 #define XILINX_DMA_CR_COALESCE_SHIFT	16
@@ -2634,7 +2636,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	struct xilinx_dma_device *xdev;
 	struct device_node *child, *np = pdev->dev.of_node;
 	struct resource *io;
-	u32 num_frames, addr_width;
+	u32 num_frames, addr_width, len_width;
 	int i, err;
 
 	/* Allocate and initialize the DMA engine structure */
@@ -2666,10 +2668,24 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	/* Retrieve the DMA engine properties from the device tree */
 	xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
-	xdev->max_buffer_len = XILINX_DMA_MAX_TRANS_LEN;
+	xdev->max_buffer_len = GENMASK(XILINX_DMA_MAX_TRANS_LEN_MAX - 1, 0);
 
-	if (xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA)
+	if (xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA) {
 		xdev->mcdma = of_property_read_bool(node, "xlnx,mcdma");
+		if (!of_property_read_u32(node, "xlnx,sg-length-width",
+					  &len_width)) {
+			if (len_width < XILINX_DMA_MAX_TRANS_LEN_MIN ||
+			    len_width > XILINX_DMA_V2_MAX_TRANS_LEN_MAX) {
+				dev_warn(xdev->dev,
+					 "invalid xlnx,sg-length-width property value. Using default width\n");
+			} else {
+				if (len_width > XILINX_DMA_MAX_TRANS_LEN_MAX)
+					dev_warn(xdev->dev, "Please ensure that IP supports buffer length > 23 bits\n");
+				xdev->max_buffer_len =
+					GENMASK(len_width - 1, 0);
+			}
+		}
+	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
 		err = of_property_read_u32(node, "xlnx,num-fstores",
-- 
2.39.0



