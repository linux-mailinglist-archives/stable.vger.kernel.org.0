Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3E259381F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiHOS5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244562AbiHOSyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571448CAF;
        Mon, 15 Aug 2022 11:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9AD161050;
        Mon, 15 Aug 2022 18:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF013C433C1;
        Mon, 15 Aug 2022 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588207;
        bh=PRf5I9/9OWbqMYqRtr1TFnB82kwN/Tq7+SulViMUAGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssfxkEElTcTFnPh+t0UgsFn8eKX9EibFZcjH50MZcB97TRUqxJ/QtkbmEvb1E+G6r
         ee4D6Tgk86RCA7JYbqrffFN+6tFBQMobVMc2BetQ58Qe0gnpnotYrbgVm0yGE7XWWo
         4VmZ9GQxFlF+Vd62b8amEYc2HTNkfCA89ASJJnm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/779] drm/vc4: dsi: Switch to devm_drm_of_get_bridge
Date:   Mon, 15 Aug 2022 19:59:01 +0200
Message-Id: <20220815180349.978287223@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit a43dd76bacd0d5441a4c84f60d64bdfaedc95bac ]

The new devm_drm_of_get_bridge removes most of the boilerplate we
have to deal with. Let's switch to it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210910130941.1740182-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index ca8506316660..64dfefeb03f5 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1493,7 +1493,6 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 	struct vc4_dsi_encoder *vc4_dsi_encoder;
-	struct drm_panel *panel;
 	const struct of_device_id *match;
 	dma_cap_mask_t dma_mask;
 	int ret;
@@ -1605,27 +1604,9 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 	}
 
-	ret = drm_of_find_panel_or_bridge(dev->of_node, 0, 0,
-					  &panel, &dsi->bridge);
-	if (ret) {
-		/* If the bridge or panel pointed by dev->of_node is not
-		 * enabled, just return 0 here so that we don't prevent the DRM
-		 * dev from being registered. Of course that means the DSI
-		 * encoder won't be exposed, but that's not a problem since
-		 * nothing is connected to it.
-		 */
-		if (ret == -ENODEV)
-			return 0;
-
-		return ret;
-	}
-
-	if (panel) {
-		dsi->bridge = devm_drm_panel_bridge_add_typed(dev, panel,
-							      DRM_MODE_CONNECTOR_DSI);
-		if (IS_ERR(dsi->bridge))
-			return PTR_ERR(dsi->bridge);
-	}
+	dsi->bridge = devm_drm_of_get_bridge(dev, dev->of_node, 0, 0);
+	if (IS_ERR(dsi->bridge))
+		return PTR_ERR(dsi->bridge);
 
 	/* The esc clock rate is supposed to always be 100Mhz. */
 	ret = clk_set_rate(dsi->escape_clock, 100 * 1000000);
@@ -1663,8 +1644,7 @@ static void vc4_dsi_unbind(struct device *dev, struct device *master,
 {
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 
-	if (dsi->bridge)
-		pm_runtime_disable(dev);
+	pm_runtime_disable(dev);
 
 	/*
 	 * Restore the bridge_chain so the bridge detach procedure can happen
-- 
2.35.1



