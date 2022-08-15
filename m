Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A36B594981
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354038AbiHOXnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354272AbiHOXlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFACCAE77;
        Mon, 15 Aug 2022 13:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C81860B9B;
        Mon, 15 Aug 2022 20:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8985AC433C1;
        Mon, 15 Aug 2022 20:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594290;
        bh=glN6sxhxG13vQizBKcYdIeAELf9tcp4qdEOf3tEnxBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlqfFczx5bN+1Kqpl1ZsN+xKM7HL8LN2MW/aJsovfmMoWsenlGRI9xBdvuLlk823m
         blU4UyeuPihnC7JnN/Fpbu6WuG68Im63Koe+zXO0p+Sv8gt9ZJIeZwL83WeA35Pk+8
         mrUZS+9FkZyAeGYuUwKyV1TodaCpAmtQV1JnYJSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0409/1157] drm/vc4: dsi: Release workaround buffer and DMA
Date:   Mon, 15 Aug 2022 19:56:05 +0200
Message-Id: <20220815180456.017347408@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 89c4bbe2a01ea401c2b0fabc104720809084b77f ]

On Pi0-3 the driver allocates a buffer and requests a DMA channel
because the ARM can't write to DSI1's registers directly.

However, we never release that buffer or channel. Let's add a
device-managed action to release each.

Fixes: 4078f5757144 ("drm/vc4: Add DSI driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-12-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 98308a17e4ed..e82ee94cafc7 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1487,13 +1487,29 @@ vc4_dsi_init_phy_clocks(struct vc4_dsi *dsi)
 				      dsi->clk_onecell);
 }
 
+static void vc4_dsi_dma_mem_release(void *ptr)
+{
+	struct vc4_dsi *dsi = ptr;
+	struct device *dev = &dsi->pdev->dev;
+
+	dma_free_coherent(dev, 4, dsi->reg_dma_mem, dsi->reg_dma_paddr);
+	dsi->reg_dma_mem = NULL;
+}
+
+static void vc4_dsi_dma_chan_release(void *ptr)
+{
+	struct vc4_dsi *dsi = ptr;
+
+	dma_release_channel(dsi->reg_dma_chan);
+	dsi->reg_dma_chan = NULL;
+}
+
 static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 	struct vc4_dsi_encoder *vc4_dsi_encoder;
-	dma_cap_mask_t dma_mask;
 	int ret;
 
 	dsi->variant = of_device_get_match_data(dev);
@@ -1527,6 +1543,8 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	 * so set up a channel for talking to it.
 	 */
 	if (dsi->variant->broken_axi_workaround) {
+		dma_cap_mask_t dma_mask;
+
 		dsi->reg_dma_mem = dma_alloc_coherent(dev, 4,
 						      &dsi->reg_dma_paddr,
 						      GFP_KERNEL);
@@ -1535,8 +1553,13 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 			return -ENOMEM;
 		}
 
+		ret = devm_add_action_or_reset(dev, vc4_dsi_dma_mem_release, dsi);
+		if (ret)
+			return ret;
+
 		dma_cap_zero(dma_mask);
 		dma_cap_set(DMA_MEMCPY, dma_mask);
+
 		dsi->reg_dma_chan = dma_request_chan_by_mask(&dma_mask);
 		if (IS_ERR(dsi->reg_dma_chan)) {
 			ret = PTR_ERR(dsi->reg_dma_chan);
@@ -1546,6 +1569,10 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 			return ret;
 		}
 
+		ret = devm_add_action_or_reset(dev, vc4_dsi_dma_chan_release, dsi);
+		if (ret)
+			return ret;
+
 		/* Get the physical address of the device's registers.  The
 		 * struct resource for the regs gives us the bus address
 		 * instead.
-- 
2.35.1



