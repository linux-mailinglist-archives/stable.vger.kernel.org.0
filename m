Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F08451242
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhKOTd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244625AbhKOTRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ABCD61B44;
        Mon, 15 Nov 2021 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000531;
        bh=0hsI4YDMGAhptLhRTnSi3BZAiLFMj3piUW3GFS5g3I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY/Ped+L0pojmGDLq61I7txDRxDCOUqd+EyXRR+JNlHhV7pX0m7hGVqGNwPBI2xaj
         pvqSBvBUsHeZUzn2Px0NGiCYPR6Kp9gAKOiDOu93INZaG2EdfetnTSyewyxLMRABJj
         20w9LQ2NRvEy8lr/P3TVERGIXS/nlW8GCBy49t6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 694/849] dmaengine: at_xdmac: call at_xdmac_axi_config() on resume path
Date:   Mon, 15 Nov 2021 18:02:57 +0100
Message-Id: <20211115165443.729946240@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit fa5270ec2f2688d98a82895be7039b81c87d856c ]

at_xdmac could be used on SoCs which supports backup mode (where most
of the SoC power, including power to DMA controller, is closed at suspend
time). Thus, on resume, the settings which were previously done need to be
restored. Do the same for axi configuration.

Fixes: f40566f220a1 ("dmaengine: at_xdmac: add AXI priority support and recommended settings")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211007111230.2331837-2-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 51 ++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 64a52bf4d7377..855a59f3248ee 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1926,6 +1926,30 @@ static void at_xdmac_free_chan_resources(struct dma_chan *chan)
 	return;
 }
 
+static void at_xdmac_axi_config(struct platform_device *pdev)
+{
+	struct at_xdmac	*atxdmac = (struct at_xdmac *)platform_get_drvdata(pdev);
+	bool dev_m2m = false;
+	u32 dma_requests;
+
+	if (!atxdmac->layout->axi_config)
+		return; /* Not supported */
+
+	if (!of_property_read_u32(pdev->dev.of_node, "dma-requests",
+				  &dma_requests)) {
+		dev_info(&pdev->dev, "controller in mem2mem mode.\n");
+		dev_m2m = true;
+	}
+
+	if (dev_m2m) {
+		at_xdmac_write(atxdmac, AT_XDMAC_GCFG, AT_XDMAC_GCFG_M2M);
+		at_xdmac_write(atxdmac, AT_XDMAC_GWAC, AT_XDMAC_GWAC_M2M);
+	} else {
+		at_xdmac_write(atxdmac, AT_XDMAC_GCFG, AT_XDMAC_GCFG_P2M);
+		at_xdmac_write(atxdmac, AT_XDMAC_GWAC, AT_XDMAC_GWAC_P2M);
+	}
+}
+
 #ifdef CONFIG_PM
 static int atmel_xdmac_prepare(struct device *dev)
 {
@@ -1975,6 +1999,7 @@ static int atmel_xdmac_resume(struct device *dev)
 	struct at_xdmac		*atxdmac = dev_get_drvdata(dev);
 	struct at_xdmac_chan	*atchan;
 	struct dma_chan		*chan, *_chan;
+	struct platform_device	*pdev = container_of(dev, struct platform_device, dev);
 	int			i;
 	int ret;
 
@@ -1982,6 +2007,8 @@ static int atmel_xdmac_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	at_xdmac_axi_config(pdev);
+
 	/* Clear pending interrupts. */
 	for (i = 0; i < atxdmac->dma.chancnt; i++) {
 		atchan = &atxdmac->chan[i];
@@ -2007,30 +2034,6 @@ static int atmel_xdmac_resume(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static void at_xdmac_axi_config(struct platform_device *pdev)
-{
-	struct at_xdmac	*atxdmac = (struct at_xdmac *)platform_get_drvdata(pdev);
-	bool dev_m2m = false;
-	u32 dma_requests;
-
-	if (!atxdmac->layout->axi_config)
-		return; /* Not supported */
-
-	if (!of_property_read_u32(pdev->dev.of_node, "dma-requests",
-				  &dma_requests)) {
-		dev_info(&pdev->dev, "controller in mem2mem mode.\n");
-		dev_m2m = true;
-	}
-
-	if (dev_m2m) {
-		at_xdmac_write(atxdmac, AT_XDMAC_GCFG, AT_XDMAC_GCFG_M2M);
-		at_xdmac_write(atxdmac, AT_XDMAC_GWAC, AT_XDMAC_GWAC_M2M);
-	} else {
-		at_xdmac_write(atxdmac, AT_XDMAC_GCFG, AT_XDMAC_GCFG_P2M);
-		at_xdmac_write(atxdmac, AT_XDMAC_GWAC, AT_XDMAC_GWAC_P2M);
-	}
-}
-
 static int at_xdmac_probe(struct platform_device *pdev)
 {
 	struct at_xdmac	*atxdmac;
-- 
2.33.0



