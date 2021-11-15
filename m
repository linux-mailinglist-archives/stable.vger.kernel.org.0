Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F800451E26
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344565AbhKPAfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344618AbhKOTZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD052636A3;
        Mon, 15 Nov 2021 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002872;
        bh=MYJgA8nOfU5wFciEO+VjQWZOimo1eIo9xgFRUgbRBFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASnQXR7kjEnTXvybLGPEE+FiDuLFK+5ndVgBxQE1jnN+sIvcpyYkA9ir+4ct/WxKI
         o+m8+dWwLwpMUXtz7IsT3XOFLIOXHosBfP/gKTdceZ1/BKygSgANDiKYWT+1kxlKn/
         CUxI47v/w7UMlUv7rP2WO8Uq7gdx8uwQ3+0qCPVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 727/917] dmaengine: at_xdmac: call at_xdmac_axi_config() on resume path
Date:   Mon, 15 Nov 2021 18:03:42 +0100
Message-Id: <20211115165453.565542433@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index ab78e0f6afd70..c66ad5706cb5a 100644
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



