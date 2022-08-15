Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F73B593DCD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345462AbiHOTyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbiHOTx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744B845076;
        Mon, 15 Aug 2022 11:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 144BCB810A3;
        Mon, 15 Aug 2022 18:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A079C433C1;
        Mon, 15 Aug 2022 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589490;
        bh=45uz+rwgHCBS0lVdD6UyCB1stwIcWm/PdZp4hRTGTfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSUty2vh5Mz57dXMcLPPrWswexZXt2DyswWsQF8ij+kITsfCnesPNjfrQl9rtQc9t
         sWq+ch/bsSxxKDgFaFIaITuONxcq+LdxdJ9WXKKe5oe+at1QfhXTbV3XpffYbQm5d/
         aPQuGTU7f6t5/usxzc11UjCIvn9rgx6F9Zi5eQzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 694/779] drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component
Date:   Mon, 15 Aug 2022 20:05:38 +0200
Message-Id: <20220815180407.009803481@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit da8e393e23efb60eba8959856c7df88f9859f6eb ]

vc4_drv isn't necessarily under the /soc node in DT as it is a
virtual device, but it is the one that does the allocations.
The DMA addresses are consumed by primarily the HVS or V3D, and
those require VideoCore cache alias address mapping, and so will be
under /soc.

During probe find the a suitable device node for HVS or V3D,
and adopt the DMA configuration of that node.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-2-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index f6c16c5aee68..6e52801e2d99 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -214,6 +214,15 @@ static void vc4_match_add_drivers(struct device *dev,
 	}
 }
 
+const struct of_device_id vc4_dma_range_matches[] = {
+	{ .compatible = "brcm,bcm2711-hvs" },
+	{ .compatible = "brcm,bcm2835-hvs" },
+	{ .compatible = "brcm,bcm2835-v3d" },
+	{ .compatible = "brcm,cygnus-v3d" },
+	{ .compatible = "brcm,vc4-v3d" },
+	{}
+};
+
 static int vc4_drm_bind(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -231,6 +240,16 @@ static int vc4_drm_bind(struct device *dev)
 		vc4_drm_driver.driver_features &= ~DRIVER_RENDER;
 	of_node_put(node);
 
+	node = of_find_matching_node_and_match(NULL, vc4_dma_range_matches,
+					       NULL);
+	if (node) {
+		ret = of_dma_configure(dev, node, true);
+		of_node_put(node);
+
+		if (ret)
+			return ret;
+	}
+
 	vc4 = devm_drm_dev_alloc(dev, &vc4_drm_driver, struct vc4_dev, base);
 	if (IS_ERR(vc4))
 		return PTR_ERR(vc4);
-- 
2.35.1



