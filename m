Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911216B454B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjCJOcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjCJOcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279782213D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE17AB822BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A48C433EF;
        Fri, 10 Mar 2023 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458687;
        bh=6uTEU6AcK5f4ZR49QOj9/ip4Zs8kOjaV3S0IGXbDSx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSogMVbu5RgHY8J0XBrRqA6KdaE3MtTYq3PaiDbuNDTTpcC1vrGpOccvxdGdhtrHG
         OzLZF6OiYwpQR6sE0gfGg6fwAY2ztZwZt0C0ogXFPG4wJ3zSFD6+eKUI5ibR2fvhTF
         TpkssKVrl4lZqe/CEFFBWlY3D9FZmrhA8n9RNgzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/357] drm/bridge: Rename bridge helpers targeting a bridge chain
Date:   Fri, 10 Mar 2023 14:36:40 +0100
Message-Id: <20230310133739.554926625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit ea099adfdf4bf35903dc1c0f59a0d60175759c70 ]

Change the prefix of bridge helpers targeting a bridge chain from
drm_bridge_ to drm_bridge_chain_ to better reflect the fact that
the operation will happen on all elements of chain, starting at the
bridge passed in argument.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191203141515.3597631-2-boris.brezillon@collabora.com
Stable-dep-of: 13fcfcb2a9a4 ("drm/msm/mdp5: Add check for kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c     |  19 ++--
 drivers/gpu/drm/drm_bridge.c            | 125 ++++++++++++------------
 drivers/gpu/drm/drm_probe_helper.c      |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c |   8 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c     |   4 +-
 drivers/gpu/drm/vc4/vc4_dsi.c           |   8 +-
 include/drm/drm_bridge.h                |  64 ++++++------
 7 files changed, 120 insertions(+), 110 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 5e906ea6df67d..e95c45cf5ffe8 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -445,8 +445,9 @@ mode_fixup(struct drm_atomic_state *state)
 		encoder = new_conn_state->best_encoder;
 		funcs = encoder->helper_private;
 
-		ret = drm_bridge_mode_fixup(encoder->bridge, &new_crtc_state->mode,
-				&new_crtc_state->adjusted_mode);
+		ret = drm_bridge_chain_mode_fixup(encoder->bridge,
+					&new_crtc_state->mode,
+					&new_crtc_state->adjusted_mode);
 		if (!ret) {
 			DRM_DEBUG_ATOMIC("Bridge fixup failed\n");
 			return -EINVAL;
@@ -511,7 +512,7 @@ static enum drm_mode_status mode_valid_path(struct drm_connector *connector,
 		return ret;
 	}
 
-	ret = drm_bridge_mode_valid(encoder->bridge, mode);
+	ret = drm_bridge_chain_mode_valid(encoder->bridge, mode);
 	if (ret != MODE_OK) {
 		DRM_DEBUG_ATOMIC("[BRIDGE] mode_valid() failed\n");
 		return ret;
@@ -1030,7 +1031,7 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
 		 * Each encoder has at most one connector (since we always steal
 		 * it away), so we won't call disable hooks twice.
 		 */
-		drm_atomic_bridge_disable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_disable(encoder->bridge, old_state);
 
 		/* Right function depends upon target state. */
 		if (funcs) {
@@ -1044,7 +1045,8 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
 				funcs->dpms(encoder, DRM_MODE_DPMS_OFF);
 		}
 
-		drm_atomic_bridge_post_disable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_post_disable(encoder->bridge,
+						     old_state);
 	}
 
 	for_each_oldnew_crtc_in_state(old_state, crtc, old_crtc_state, new_crtc_state, i) {
@@ -1225,7 +1227,8 @@ crtc_set_mode(struct drm_device *dev, struct drm_atomic_state *old_state)
 			funcs->mode_set(encoder, mode, adjusted_mode);
 		}
 
-		drm_bridge_mode_set(encoder->bridge, mode, adjusted_mode);
+		drm_bridge_chain_mode_set(encoder->bridge, mode,
+					  adjusted_mode);
 	}
 }
 
@@ -1342,7 +1345,7 @@ void drm_atomic_helper_commit_modeset_enables(struct drm_device *dev,
 		 * Each encoder has at most one connector (since we always steal
 		 * it away), so we won't call enable hooks twice.
 		 */
-		drm_atomic_bridge_pre_enable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_pre_enable(encoder->bridge, old_state);
 
 		if (funcs) {
 			if (funcs->atomic_enable)
@@ -1353,7 +1356,7 @@ void drm_atomic_helper_commit_modeset_enables(struct drm_device *dev,
 				funcs->commit(encoder);
 		}
 
-		drm_atomic_bridge_enable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_enable(encoder->bridge, old_state);
 	}
 
 	drm_atomic_helper_commit_writebacks(dev, old_state);
diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index cba537c99e437..54c874493c57e 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -172,8 +172,8 @@ void drm_bridge_detach(struct drm_bridge *bridge)
  */
 
 /**
- * drm_bridge_mode_fixup - fixup proposed mode for all bridges in the
- *			   encoder chain
+ * drm_bridge_chain_mode_fixup - fixup proposed mode for all bridges in the
+ *				 encoder chain
  * @bridge: bridge control structure
  * @mode: desired mode to be set for the bridge
  * @adjusted_mode: updated mode that works for this bridge
@@ -186,9 +186,9 @@ void drm_bridge_detach(struct drm_bridge *bridge)
  * RETURNS:
  * true on success, false on failure
  */
-bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
-			const struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
+bool drm_bridge_chain_mode_fixup(struct drm_bridge *bridge,
+				 const struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
 {
 	bool ret = true;
 
@@ -198,15 +198,16 @@ bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
 	if (bridge->funcs->mode_fixup)
 		ret = bridge->funcs->mode_fixup(bridge, mode, adjusted_mode);
 
-	ret = ret && drm_bridge_mode_fixup(bridge->next, mode, adjusted_mode);
+	ret = ret && drm_bridge_chain_mode_fixup(bridge->next, mode,
+						 adjusted_mode);
 
 	return ret;
 }
-EXPORT_SYMBOL(drm_bridge_mode_fixup);
+EXPORT_SYMBOL(drm_bridge_chain_mode_fixup);
 
 /**
- * drm_bridge_mode_valid - validate the mode against all bridges in the
- * 			   encoder chain.
+ * drm_bridge_chain_mode_valid - validate the mode against all bridges in the
+ *				 encoder chain.
  * @bridge: bridge control structure
  * @mode: desired mode to be validated
  *
@@ -219,8 +220,9 @@ EXPORT_SYMBOL(drm_bridge_mode_fixup);
  * RETURNS:
  * MODE_OK on success, drm_mode_status Enum error code on failure
  */
-enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
-					   const struct drm_display_mode *mode)
+enum drm_mode_status
+drm_bridge_chain_mode_valid(struct drm_bridge *bridge,
+			    const struct drm_display_mode *mode)
 {
 	enum drm_mode_status ret = MODE_OK;
 
@@ -233,12 +235,12 @@ enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
 	if (ret != MODE_OK)
 		return ret;
 
-	return drm_bridge_mode_valid(bridge->next, mode);
+	return drm_bridge_chain_mode_valid(bridge->next, mode);
 }
-EXPORT_SYMBOL(drm_bridge_mode_valid);
+EXPORT_SYMBOL(drm_bridge_chain_mode_valid);
 
 /**
- * drm_bridge_disable - disables all bridges in the encoder chain
+ * drm_bridge_chain_disable - disables all bridges in the encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.disable op for all the bridges in the encoder
@@ -247,20 +249,21 @@ EXPORT_SYMBOL(drm_bridge_mode_valid);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_disable(struct drm_bridge *bridge)
+void drm_bridge_chain_disable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
 
-	drm_bridge_disable(bridge->next);
+	drm_bridge_chain_disable(bridge->next);
 
 	if (bridge->funcs->disable)
 		bridge->funcs->disable(bridge);
 }
-EXPORT_SYMBOL(drm_bridge_disable);
+EXPORT_SYMBOL(drm_bridge_chain_disable);
 
 /**
- * drm_bridge_post_disable - cleans up after disabling all bridges in the encoder chain
+ * drm_bridge_chain_post_disable - cleans up after disabling all bridges in the
+ *				   encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.post_disable op for all the bridges in the
@@ -269,7 +272,7 @@ EXPORT_SYMBOL(drm_bridge_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_post_disable(struct drm_bridge *bridge)
+void drm_bridge_chain_post_disable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
@@ -277,25 +280,25 @@ void drm_bridge_post_disable(struct drm_bridge *bridge)
 	if (bridge->funcs->post_disable)
 		bridge->funcs->post_disable(bridge);
 
-	drm_bridge_post_disable(bridge->next);
+	drm_bridge_chain_post_disable(bridge->next);
 }
-EXPORT_SYMBOL(drm_bridge_post_disable);
+EXPORT_SYMBOL(drm_bridge_chain_post_disable);
 
 /**
- * drm_bridge_mode_set - set proposed mode for all bridges in the
- *			 encoder chain
+ * drm_bridge_chain_mode_set - set proposed mode for all bridges in the
+ *			       encoder chain
  * @bridge: bridge control structure
- * @mode: desired mode to be set for the bridge
- * @adjusted_mode: updated mode that works for this bridge
+ * @mode: desired mode to be set for the encoder chain
+ * @adjusted_mode: updated mode that works for this encoder chain
  *
  * Calls &drm_bridge_funcs.mode_set op for all the bridges in the
  * encoder chain, starting from the first bridge to the last.
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_mode_set(struct drm_bridge *bridge,
-			 const struct drm_display_mode *mode,
-			 const struct drm_display_mode *adjusted_mode)
+void drm_bridge_chain_mode_set(struct drm_bridge *bridge,
+			       const struct drm_display_mode *mode,
+			       const struct drm_display_mode *adjusted_mode)
 {
 	if (!bridge)
 		return;
@@ -303,13 +306,13 @@ void drm_bridge_mode_set(struct drm_bridge *bridge,
 	if (bridge->funcs->mode_set)
 		bridge->funcs->mode_set(bridge, mode, adjusted_mode);
 
-	drm_bridge_mode_set(bridge->next, mode, adjusted_mode);
+	drm_bridge_chain_mode_set(bridge->next, mode, adjusted_mode);
 }
-EXPORT_SYMBOL(drm_bridge_mode_set);
+EXPORT_SYMBOL(drm_bridge_chain_mode_set);
 
 /**
- * drm_bridge_pre_enable - prepares for enabling all
- *			   bridges in the encoder chain
+ * drm_bridge_chain_pre_enable - prepares for enabling all bridges in the
+ *				 encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.pre_enable op for all the bridges in the encoder
@@ -318,20 +321,20 @@ EXPORT_SYMBOL(drm_bridge_mode_set);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_pre_enable(struct drm_bridge *bridge)
+void drm_bridge_chain_pre_enable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
 
-	drm_bridge_pre_enable(bridge->next);
+	drm_bridge_chain_pre_enable(bridge->next);
 
 	if (bridge->funcs->pre_enable)
 		bridge->funcs->pre_enable(bridge);
 }
-EXPORT_SYMBOL(drm_bridge_pre_enable);
+EXPORT_SYMBOL(drm_bridge_chain_pre_enable);
 
 /**
- * drm_bridge_enable - enables all bridges in the encoder chain
+ * drm_bridge_chain_enable - enables all bridges in the encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.enable op for all the bridges in the encoder
@@ -340,7 +343,7 @@ EXPORT_SYMBOL(drm_bridge_pre_enable);
  *
  * Note that the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_enable(struct drm_bridge *bridge)
+void drm_bridge_chain_enable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
@@ -348,12 +351,12 @@ void drm_bridge_enable(struct drm_bridge *bridge)
 	if (bridge->funcs->enable)
 		bridge->funcs->enable(bridge);
 
-	drm_bridge_enable(bridge->next);
+	drm_bridge_chain_enable(bridge->next);
 }
-EXPORT_SYMBOL(drm_bridge_enable);
+EXPORT_SYMBOL(drm_bridge_chain_enable);
 
 /**
- * drm_atomic_bridge_disable - disables all bridges in the encoder chain
+ * drm_atomic_bridge_chain_disable - disables all bridges in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -364,24 +367,24 @@ EXPORT_SYMBOL(drm_bridge_enable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_disable(struct drm_bridge *bridge,
+				     struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
 
-	drm_atomic_bridge_disable(bridge->next, state);
+	drm_atomic_bridge_chain_disable(bridge->next, state);
 
 	if (bridge->funcs->atomic_disable)
 		bridge->funcs->atomic_disable(bridge, state);
 	else if (bridge->funcs->disable)
 		bridge->funcs->disable(bridge);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_disable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_disable);
 
 /**
- * drm_atomic_bridge_post_disable - cleans up after disabling all bridges in the
- *				    encoder chain
+ * drm_atomic_bridge_chain_post_disable - cleans up after disabling all bridges
+ *					  in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -392,8 +395,8 @@ EXPORT_SYMBOL(drm_atomic_bridge_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
-				    struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_post_disable(struct drm_bridge *bridge,
+					  struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
@@ -403,13 +406,13 @@ void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
 	else if (bridge->funcs->post_disable)
 		bridge->funcs->post_disable(bridge);
 
-	drm_atomic_bridge_post_disable(bridge->next, state);
+	drm_atomic_bridge_chain_post_disable(bridge->next, state);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_post_disable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_post_disable);
 
 /**
- * drm_atomic_bridge_pre_enable - prepares for enabling all bridges in the
- *				  encoder chain
+ * drm_atomic_bridge_chain_pre_enable - prepares for enabling all bridges in
+ *					the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -420,23 +423,23 @@ EXPORT_SYMBOL(drm_atomic_bridge_post_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_pre_enable(struct drm_bridge *bridge,
-				  struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_pre_enable(struct drm_bridge *bridge,
+					struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
 
-	drm_atomic_bridge_pre_enable(bridge->next, state);
+	drm_atomic_bridge_chain_pre_enable(bridge->next, state);
 
 	if (bridge->funcs->atomic_pre_enable)
 		bridge->funcs->atomic_pre_enable(bridge, state);
 	else if (bridge->funcs->pre_enable)
 		bridge->funcs->pre_enable(bridge);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_pre_enable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_pre_enable);
 
 /**
- * drm_atomic_bridge_enable - enables all bridges in the encoder chain
+ * drm_atomic_bridge_chain_enable - enables all bridges in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -447,8 +450,8 @@ EXPORT_SYMBOL(drm_atomic_bridge_pre_enable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_enable(struct drm_bridge *bridge,
+				    struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
@@ -458,9 +461,9 @@ void drm_atomic_bridge_enable(struct drm_bridge *bridge,
 	else if (bridge->funcs->enable)
 		bridge->funcs->enable(bridge);
 
-	drm_atomic_bridge_enable(bridge->next, state);
+	drm_atomic_bridge_chain_enable(bridge->next, state);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_enable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_enable);
 
 #ifdef CONFIG_OF
 /**
diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index ef2c468205a20..d45f43feaf862 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -112,7 +112,7 @@ drm_mode_validate_pipeline(struct drm_display_mode *mode,
 			continue;
 		}
 
-		ret = drm_bridge_mode_valid(encoder->bridge, mode);
+		ret = drm_bridge_chain_mode_valid(encoder->bridge, mode);
 		if (ret != MODE_OK) {
 			/* There is also no point in continuing for crtc check
 			 * here. */
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index b83acd696774b..babf3db82ce33 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1389,7 +1389,7 @@ static void exynos_dsi_enable(struct drm_encoder *encoder)
 		if (ret < 0)
 			goto err_put_sync;
 	} else {
-		drm_bridge_pre_enable(dsi->out_bridge);
+		drm_bridge_chain_pre_enable(dsi->out_bridge);
 	}
 
 	exynos_dsi_set_display_mode(dsi);
@@ -1400,7 +1400,7 @@ static void exynos_dsi_enable(struct drm_encoder *encoder)
 		if (ret < 0)
 			goto err_display_disable;
 	} else {
-		drm_bridge_enable(dsi->out_bridge);
+		drm_bridge_chain_enable(dsi->out_bridge);
 	}
 
 	dsi->state |= DSIM_STATE_VIDOUT_AVAILABLE;
@@ -1425,10 +1425,10 @@ static void exynos_dsi_disable(struct drm_encoder *encoder)
 	dsi->state &= ~DSIM_STATE_VIDOUT_AVAILABLE;
 
 	drm_panel_disable(dsi->panel);
-	drm_bridge_disable(dsi->out_bridge);
+	drm_bridge_chain_disable(dsi->out_bridge);
 	exynos_dsi_set_display_enable(dsi, false);
 	drm_panel_unprepare(dsi->panel);
-	drm_bridge_post_disable(dsi->out_bridge);
+	drm_bridge_chain_post_disable(dsi->out_bridge);
 	dsi->state &= ~DSIM_STATE_ENABLED;
 	pm_runtime_put_sync(dsi->dev);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 6b22fd63c3f55..37960172a3a15 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1246,8 +1246,8 @@ static int mtk_hdmi_conn_mode_valid(struct drm_connector *conn,
 		struct drm_display_mode adjusted_mode;
 
 		drm_mode_copy(&adjusted_mode, mode);
-		if (!drm_bridge_mode_fixup(hdmi->bridge.next, mode,
-					   &adjusted_mode))
+		if (!drm_bridge_chain_mode_fixup(hdmi->bridge.next, mode,
+						 &adjusted_mode))
 			return MODE_BAD;
 	}
 
diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index e249ab378700e..67bfbffdb65c4 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -752,9 +752,9 @@ static void vc4_dsi_encoder_disable(struct drm_encoder *encoder)
 	struct vc4_dsi *dsi = vc4_encoder->dsi;
 	struct device *dev = &dsi->pdev->dev;
 
-	drm_bridge_disable(dsi->bridge);
+	drm_bridge_chain_disable(dsi->bridge);
 	vc4_dsi_ulps(dsi, true);
-	drm_bridge_post_disable(dsi->bridge);
+	drm_bridge_chain_post_disable(dsi->bridge);
 
 	clk_disable_unprepare(dsi->pll_phy_clock);
 	clk_disable_unprepare(dsi->escape_clock);
@@ -1052,7 +1052,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 
 	vc4_dsi_ulps(dsi, false);
 
-	drm_bridge_pre_enable(dsi->bridge);
+	drm_bridge_chain_pre_enable(dsi->bridge);
 
 	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO) {
 		DSI_PORT_WRITE(DISP0_CTRL,
@@ -1069,7 +1069,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 			       DSI_DISP0_ENABLE);
 	}
 
-	drm_bridge_enable(dsi->bridge);
+	drm_bridge_chain_enable(dsi->bridge);
 
 	if (debug_dump_regs) {
 		struct drm_printer p = drm_info_printer(&dsi->pdev->dev);
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 7616f6562fe48..442a0654e1bfa 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -254,9 +254,10 @@ struct drm_bridge_funcs {
 	 * there is one) when this callback is called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_pre_enable. It
-	 * would be prudent to also provide an implementation of @pre_enable if
-	 * you are expecting driver calls into &drm_bridge_pre_enable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_pre_enable. It would be prudent to also provide an
+	 * implementation of @pre_enable if you are expecting driver calls into
+	 * &drm_bridge_chain_pre_enable.
 	 *
 	 * The @atomic_pre_enable callback is optional.
 	 */
@@ -279,9 +280,9 @@ struct drm_bridge_funcs {
 	 * chain if there is one.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_enable. It
-	 * would be prudent to also provide an implementation of @enable if
-	 * you are expecting driver calls into &drm_bridge_enable.
+	 * atomic commit. It will not be invoked from &drm_bridge_chain_enable.
+	 * It would be prudent to also provide an implementation of @enable if
+	 * you are expecting driver calls into &drm_bridge_chain_enable.
 	 *
 	 * The enable callback is optional.
 	 */
@@ -301,9 +302,10 @@ struct drm_bridge_funcs {
 	 * signals) feeding it is still running when this callback is called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_disable. It
-	 * would be prudent to also provide an implementation of @disable if
-	 * you are expecting driver calls into &drm_bridge_disable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_disable. It would be prudent to also provide an
+	 * implementation of @disable if you are expecting driver calls into
+	 * &drm_bridge_chain_disable.
 	 *
 	 * The disable callback is optional.
 	 */
@@ -325,10 +327,11 @@ struct drm_bridge_funcs {
 	 * called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_post_disable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_post_disable.
 	 * It would be prudent to also provide an implementation of
 	 * @post_disable if you are expecting driver calls into
-	 * &drm_bridge_post_disable.
+	 * &drm_bridge_chain_post_disable.
 	 *
 	 * The post_disable callback is optional.
 	 */
@@ -406,27 +409,28 @@ struct drm_bridge *of_drm_find_bridge(struct device_node *np);
 int drm_bridge_attach(struct drm_encoder *encoder, struct drm_bridge *bridge,
 		      struct drm_bridge *previous);
 
-bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
-			   const struct drm_display_mode *mode,
-			   struct drm_display_mode *adjusted_mode);
-enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
-					   const struct drm_display_mode *mode);
-void drm_bridge_disable(struct drm_bridge *bridge);
-void drm_bridge_post_disable(struct drm_bridge *bridge);
-void drm_bridge_mode_set(struct drm_bridge *bridge,
-			 const struct drm_display_mode *mode,
-			 const struct drm_display_mode *adjusted_mode);
-void drm_bridge_pre_enable(struct drm_bridge *bridge);
-void drm_bridge_enable(struct drm_bridge *bridge);
+bool drm_bridge_chain_mode_fixup(struct drm_bridge *bridge,
+				 const struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode);
+enum drm_mode_status
+drm_bridge_chain_mode_valid(struct drm_bridge *bridge,
+			    const struct drm_display_mode *mode);
+void drm_bridge_chain_disable(struct drm_bridge *bridge);
+void drm_bridge_chain_post_disable(struct drm_bridge *bridge);
+void drm_bridge_chain_mode_set(struct drm_bridge *bridge,
+			       const struct drm_display_mode *mode,
+			       const struct drm_display_mode *adjusted_mode);
+void drm_bridge_chain_pre_enable(struct drm_bridge *bridge);
+void drm_bridge_chain_enable(struct drm_bridge *bridge);
 
-void drm_atomic_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_atomic_state *state);
-void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
+void drm_atomic_bridge_chain_disable(struct drm_bridge *bridge,
+				     struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_post_disable(struct drm_bridge *bridge,
+					  struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_pre_enable(struct drm_bridge *bridge,
+					struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_enable(struct drm_bridge *bridge,
 				    struct drm_atomic_state *state);
-void drm_atomic_bridge_pre_enable(struct drm_bridge *bridge,
-				  struct drm_atomic_state *state);
-void drm_atomic_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_atomic_state *state);
 
 #ifdef CONFIG_DRM_PANEL_BRIDGE
 struct drm_bridge *drm_panel_bridge_add(struct drm_panel *panel,
-- 
2.39.2



