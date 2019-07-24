Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6154739DB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbfGXToZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390808AbfGXToY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:44:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420C3214AF;
        Wed, 24 Jul 2019 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997462;
        bh=W7GWnlYEu15MiLQsnqFtJlzTw1zEyXiEJ2XFlF6/RrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4qzVS1t9j2Xk4Q0AcXj8FsHNJKfhBx6eQTllWqBzFPjRKsZsM3dV1cUhmSXTlJyL
         zIWP1mV0ACpBj9ablaCUFf/AagHGSP2gdouTQrw85Nk9EyWIsgqqDIacXFK4z5cyHJ
         1PAA9rQjPphJ1ZZIMrqFMtUSkmOd2WUZ/vjSiyQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 005/371] dmaengine: imx-sdma: fix use-after-free on probe error path
Date:   Wed, 24 Jul 2019 21:15:57 +0200
Message-Id: <20190724191724.893916762@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2b8066c3deb9140fdf258417a51479b2aeaa7622 ]

If probe() fails anywhere beyond the point where
sdma_get_firmware() is called, then a kernel oops may occur.

Problematic sequence of events:
1. probe() calls sdma_get_firmware(), which schedules the
   firmware callback to run when firmware becomes available,
   using the sdma instance structure as the context
2. probe() encounters an error, which deallocates the
   sdma instance structure
3. firmware becomes available, firmware callback is
   called with deallocated sdma instance structure
4. use after free - kernel oops !

Solution: only attempt to load firmware when we're certain
that probe() will succeed. This guarantees that the firmware
callback's context will remain valid.

Note that the remove() path is unaffected by this issue: the
firmware loader will increment the driver module's use count,
ensuring that the module cannot be unloaded while the
firmware callback is pending or running.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
[vkoul: fixed braces for if condition]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 48 ++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 248c440c10f2..4ec84a633bd3 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2096,27 +2096,6 @@ static int sdma_probe(struct platform_device *pdev)
 	if (pdata && pdata->script_addrs)
 		sdma_add_scripts(sdma, pdata->script_addrs);
 
-	if (pdata) {
-		ret = sdma_get_firmware(sdma, pdata->fw_name);
-		if (ret)
-			dev_warn(&pdev->dev, "failed to get firmware from platform data\n");
-	} else {
-		/*
-		 * Because that device tree does not encode ROM script address,
-		 * the RAM script in firmware is mandatory for device tree
-		 * probe, otherwise it fails.
-		 */
-		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
-					      &fw_name);
-		if (ret)
-			dev_warn(&pdev->dev, "failed to get firmware name\n");
-		else {
-			ret = sdma_get_firmware(sdma, fw_name);
-			if (ret)
-				dev_warn(&pdev->dev, "failed to get firmware from device tree\n");
-		}
-	}
-
 	sdma->dma_device.dev = &pdev->dev;
 
 	sdma->dma_device.device_alloc_chan_resources = sdma_alloc_chan_resources;
@@ -2161,6 +2140,33 @@ static int sdma_probe(struct platform_device *pdev)
 		of_node_put(spba_bus);
 	}
 
+	/*
+	 * Kick off firmware loading as the very last step:
+	 * attempt to load firmware only if we're not on the error path, because
+	 * the firmware callback requires a fully functional and allocated sdma
+	 * instance.
+	 */
+	if (pdata) {
+		ret = sdma_get_firmware(sdma, pdata->fw_name);
+		if (ret)
+			dev_warn(&pdev->dev, "failed to get firmware from platform data\n");
+	} else {
+		/*
+		 * Because that device tree does not encode ROM script address,
+		 * the RAM script in firmware is mandatory for device tree
+		 * probe, otherwise it fails.
+		 */
+		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
+					      &fw_name);
+		if (ret) {
+			dev_warn(&pdev->dev, "failed to get firmware name\n");
+		} else {
+			ret = sdma_get_firmware(sdma, fw_name);
+			if (ret)
+				dev_warn(&pdev->dev, "failed to get firmware from device tree\n");
+		}
+	}
+
 	return 0;
 
 err_register:
-- 
2.20.1



