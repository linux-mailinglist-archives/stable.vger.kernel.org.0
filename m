Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637826B4549
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjCJOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjCJOcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779244201
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 131AB618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCA2C433EF;
        Fri, 10 Mar 2023 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458690;
        bh=pR+smp40dyVDldrURMsKUgpvkYDEyxHkfohfoDTzlJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fdg+aUHzPCTPFlUNjQffZthSAx00HsjegfAl/Wdfgpaqr4R+OMEjHOcvr1/zyab0J
         tjVhJxp4/M1Ph0hpxwt+lcY0QHMDSuHzVTx2G+LTHk2xUv++4YXxfvJFetaLkk7wjv
         q4XcIKCISOdyou+0KNqw1zkN51+jmGT0aCFmHz/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/357] drm/bridge: Introduce drm_bridge_get_next_bridge()
Date:   Fri, 10 Mar 2023 14:36:41 +0100
Message-Id: <20230310133739.594029608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit fadf872d9d9274a3be34d8438e0f6bb465c8f98b ]

And use it in drivers accessing the bridge->next field directly.
This is part of our attempt to make the bridge chain a double-linked list
based on the generic list helpers.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191203141515.3597631-3-boris.brezillon@collabora.com
Stable-dep-of: 13fcfcb2a9a4 ("drm/msm/mdp5: Add check for kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_encoder.c          |  2 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c    |  6 ++++--
 drivers/gpu/drm/omapdrm/omap_drv.c     |  4 ++--
 drivers/gpu/drm/omapdrm/omap_encoder.c |  3 ++-
 include/drm/drm_bridge.h               | 13 +++++++++++++
 5 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_encoder.c b/drivers/gpu/drm/drm_encoder.c
index 7fb47b7b8b44a..80ce9e1040de1 100644
--- a/drivers/gpu/drm/drm_encoder.c
+++ b/drivers/gpu/drm/drm_encoder.c
@@ -170,7 +170,7 @@ void drm_encoder_cleanup(struct drm_encoder *encoder)
 		struct drm_bridge *next;
 
 		while (bridge) {
-			next = bridge->next;
+			next = drm_bridge_get_next_bridge(bridge);
 			drm_bridge_detach(bridge);
 			bridge = next;
 		}
diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 37960172a3a15..74a54a9e35339 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1237,16 +1237,18 @@ static int mtk_hdmi_conn_mode_valid(struct drm_connector *conn,
 				    struct drm_display_mode *mode)
 {
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
+	struct drm_bridge *next_bridge;
 
 	dev_dbg(hdmi->dev, "xres=%d, yres=%d, refresh=%d, intl=%d clock=%d\n",
 		mode->hdisplay, mode->vdisplay, mode->vrefresh,
 		!!(mode->flags & DRM_MODE_FLAG_INTERLACE), mode->clock * 1000);
 
-	if (hdmi->bridge.next) {
+	next_bridge = drm_bridge_get_next_bridge(&hdmi->bridge);
+	if (next_bridge) {
 		struct drm_display_mode adjusted_mode;
 
 		drm_mode_copy(&adjusted_mode, mode);
-		if (!drm_bridge_chain_mode_fixup(hdmi->bridge.next, mode,
+		if (!drm_bridge_chain_mode_fixup(next_bridge, mode,
 						 &adjusted_mode))
 			return MODE_BAD;
 	}
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index 2983c003698ec..a4645b78f7374 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -216,8 +216,8 @@ static int omap_display_id(struct omap_dss_device *output)
 	} else if (output->bridge) {
 		struct drm_bridge *bridge = output->bridge;
 
-		while (bridge->next)
-			bridge = bridge->next;
+		while (drm_bridge_get_next_bridge(bridge))
+			bridge = drm_bridge_get_next_bridge(bridge);
 
 		node = bridge->of_node;
 	} else if (output->panel) {
diff --git a/drivers/gpu/drm/omapdrm/omap_encoder.c b/drivers/gpu/drm/omapdrm/omap_encoder.c
index 6fe14111cd956..b626b543a9923 100644
--- a/drivers/gpu/drm/omapdrm/omap_encoder.c
+++ b/drivers/gpu/drm/omapdrm/omap_encoder.c
@@ -125,7 +125,8 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
 	for (dssdev = output; dssdev; dssdev = dssdev->next)
 		omap_encoder_update_videomode_flags(&vm, dssdev->bus_flags);
 
-	for (bridge = output->bridge; bridge; bridge = bridge->next) {
+	for (bridge = output->bridge; bridge;
+	     bridge = drm_bridge_get_next_bridge(bridge)) {
 		if (!bridge->timings)
 			continue;
 
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 442a0654e1bfa..9f7192366cfbe 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -409,6 +409,19 @@ struct drm_bridge *of_drm_find_bridge(struct device_node *np);
 int drm_bridge_attach(struct drm_encoder *encoder, struct drm_bridge *bridge,
 		      struct drm_bridge *previous);
 
+/**
+ * drm_bridge_get_next_bridge() - Get the next bridge in the chain
+ * @bridge: bridge object
+ *
+ * RETURNS:
+ * the next bridge in the chain after @bridge, or NULL if @bridge is the last.
+ */
+static inline struct drm_bridge *
+drm_bridge_get_next_bridge(struct drm_bridge *bridge)
+{
+	return bridge->next;
+}
+
 bool drm_bridge_chain_mode_fixup(struct drm_bridge *bridge,
 				 const struct drm_display_mode *mode,
 				 struct drm_display_mode *adjusted_mode);
-- 
2.39.2



