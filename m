Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A34591A51
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiHMMty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbiHMMty (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:49:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4C613F4B
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A98E60D24
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F0EC433D6;
        Sat, 13 Aug 2022 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660394992;
        bh=e8Tf+aLqfQLoN8CikQKFlQ+6Zaa+KuPAsbm5DzcRJmw=;
        h=Subject:To:Cc:From:Date:From;
        b=0YsC7z7GyCL1+BgnT9val+vophDDRqLNhvlhJNG0VP2XngN0BGPfCVTSPT+qbW+QB
         O3bVFNB8kIfC8FBlQtMHJRhx1iWF9JQGpYSygN3IxC2Li95Y0x5xoS1vmcOEKBEYPS
         IlRSdcRUZ5D9G0QoYil2bydCqOfki2rlXqR2uEoQ=
Subject: FAILED: patch "[PATCH] drm/vc4: drv: Adopt the dma configuration from the HVS or V3D" failed to apply to 4.19-stable tree
To:     dave.stevenson@raspberrypi.com, maxime@cerno.tech,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:49:39 +0200
Message-ID: <166039497916240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da8e393e23efb60eba8959856c7df88f9859f6eb Mon Sep 17 00:00:00 2001
From: Dave Stevenson <dave.stevenson@raspberrypi.com>
Date: Mon, 13 Jun 2022 16:47:28 +0200
Subject: [PATCH] drm/vc4: drv: Adopt the dma configuration from the HVS or V3D
 component

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

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 162bc18e7497..14a7d529144d 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -209,6 +209,15 @@ static void vc4_match_add_drivers(struct device *dev,
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
@@ -227,6 +236,16 @@ static int vc4_drm_bind(struct device *dev)
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

