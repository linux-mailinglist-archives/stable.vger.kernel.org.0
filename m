Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4206F582B33
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiG0Q3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbiG0Q3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4E250199;
        Wed, 27 Jul 2022 09:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 832CFB821B9;
        Wed, 27 Jul 2022 16:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA74AC433D6;
        Wed, 27 Jul 2022 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939080;
        bh=WuFV2JU2/PxxhG50bEuKHrsPc1tFmBWsHYTqbG8O1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFPFuxwSV6r6pgkYtXzedkwZooBJ5HEPSsRmQ9cGqRS+ApYPFK1MoHSeuJo4pfGrX
         FGf/U5AKNyDYBJV05F9wyhkcQT3Zi9Qo5rPMn/rqt9Zmn1nWvOIVbxeN3+aqJaIcG3
         5hfQegr3sAHvbAQtgWgWcQHLAV9pKDeCeB1cjvxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jyri Sarha <jsarha@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/37] drm/tilcdc: Remove obsolete crtc_mode_valid() hack
Date:   Wed, 27 Jul 2022 18:10:44 +0200
Message-Id: <20220727161001.579872211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jyri Sarha <jsarha@ti.com>

[ Upstream commit 57d8396504b3a93f284e51b866740a3e7419a3d9 ]

Earlier there were no mode_valid() helper for crtc and tilcdc had a
hack to over come this limitation. But now the mode_valid() helper is
there (has been since v4.13), so it is about time to get rid of that
hack.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/ <5c4dcb5b1e7975bd2b7ca86f7addf219cd0f9a06.1564750248.git.jsarha@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c     | 28 +++-----
 drivers/gpu/drm/tilcdc/tilcdc_drv.c      |  1 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.h      |  2 -
 drivers/gpu/drm/tilcdc/tilcdc_external.c | 88 +++---------------------
 drivers/gpu/drm/tilcdc/tilcdc_external.h |  1 -
 drivers/gpu/drm/tilcdc/tilcdc_panel.c    |  9 ---
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c   |  9 ---
 7 files changed, 19 insertions(+), 119 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index 06d6e785c920..7b11908d992a 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -707,9 +707,6 @@ static bool tilcdc_crtc_mode_fixup(struct drm_crtc *crtc,
 static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
 				    struct drm_crtc_state *state)
 {
-	struct drm_display_mode *mode = &state->mode;
-	int ret;
-
 	/* If we are not active we don't care */
 	if (!state->active)
 		return 0;
@@ -721,12 +718,6 @@ static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
-	ret = tilcdc_crtc_mode_valid(crtc, mode);
-	if (ret) {
-		dev_dbg(crtc->dev->dev, "Mode \"%s\" not valid", mode->name);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -750,13 +741,6 @@ static const struct drm_crtc_funcs tilcdc_crtc_funcs = {
 	.disable_vblank	= tilcdc_crtc_disable_vblank,
 };
 
-static const struct drm_crtc_helper_funcs tilcdc_crtc_helper_funcs = {
-		.mode_fixup     = tilcdc_crtc_mode_fixup,
-		.atomic_check	= tilcdc_crtc_atomic_check,
-		.atomic_enable	= tilcdc_crtc_atomic_enable,
-		.atomic_disable	= tilcdc_crtc_atomic_disable,
-};
-
 int tilcdc_crtc_max_width(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
@@ -771,7 +755,9 @@ int tilcdc_crtc_max_width(struct drm_crtc *crtc)
 	return max_width;
 }
 
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
+static enum drm_mode_status
+tilcdc_crtc_mode_valid(struct drm_crtc *crtc,
+		       const struct drm_display_mode *mode)
 {
 	struct tilcdc_drm_private *priv = crtc->dev->dev_private;
 	unsigned int bandwidth;
@@ -859,6 +845,14 @@ int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
 	return MODE_OK;
 }
 
+static const struct drm_crtc_helper_funcs tilcdc_crtc_helper_funcs = {
+	.mode_valid	= tilcdc_crtc_mode_valid,
+	.mode_fixup	= tilcdc_crtc_mode_fixup,
+	.atomic_check	= tilcdc_crtc_atomic_check,
+	.atomic_enable	= tilcdc_crtc_atomic_enable,
+	.atomic_disable	= tilcdc_crtc_atomic_disable,
+};
+
 void tilcdc_crtc_set_panel_info(struct drm_crtc *crtc,
 		const struct tilcdc_panel_info *info)
 {
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 56039897607c..d42e1f9f2949 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -208,7 +208,6 @@ static void tilcdc_fini(struct drm_device *dev)
 
 	drm_irq_uninstall(dev);
 	drm_mode_config_cleanup(dev);
-	tilcdc_remove_external_device(dev);
 
 	if (priv->clk)
 		clk_put(priv->clk);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
index 8caa11bc7aec..c0ab69c79a93 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
@@ -91,7 +91,6 @@ struct tilcdc_drm_private {
 
 	struct drm_encoder *external_encoder;
 	struct drm_connector *external_connector;
-	const struct drm_connector_helper_funcs *connector_funcs;
 
 	bool is_registered;
 	bool is_componentized;
@@ -173,7 +172,6 @@ void tilcdc_crtc_set_panel_info(struct drm_crtc *crtc,
 		const struct tilcdc_panel_info *info);
 void tilcdc_crtc_set_simulate_vesa_sync(struct drm_crtc *crtc,
 					bool simulate_vesa_sync);
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode);
 int tilcdc_crtc_max_width(struct drm_crtc *crtc);
 void tilcdc_crtc_shutdown(struct drm_crtc *crtc);
 int tilcdc_crtc_update_fb(struct drm_crtc *crtc,
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c b/drivers/gpu/drm/tilcdc/tilcdc_external.c
index 711c7b3289d3..9c8520569d31 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
@@ -40,64 +40,6 @@ static const struct tilcdc_panel_info panel_info_default = {
 		.raster_order           = 0,
 };
 
-static int tilcdc_external_mode_valid(struct drm_connector *connector,
-				      struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	int ret;
-
-	ret = tilcdc_crtc_mode_valid(priv->crtc, mode);
-	if (ret != MODE_OK)
-		return ret;
-
-	BUG_ON(priv->external_connector != connector);
-	BUG_ON(!priv->connector_funcs);
-
-	/* If the connector has its own mode_valid call it. */
-	if (!IS_ERR(priv->connector_funcs) &&
-	    priv->connector_funcs->mode_valid)
-		return priv->connector_funcs->mode_valid(connector, mode);
-
-	return MODE_OK;
-}
-
-static int tilcdc_add_external_connector(struct drm_device *dev,
-					 struct drm_connector *connector)
-{
-	struct tilcdc_drm_private *priv = dev->dev_private;
-	struct drm_connector_helper_funcs *connector_funcs;
-
-	/* There should never be more than one connector */
-	if (WARN_ON(priv->external_connector))
-		return -EINVAL;
-
-	priv->external_connector = connector;
-	connector_funcs = devm_kzalloc(dev->dev, sizeof(*connector_funcs),
-				       GFP_KERNEL);
-	if (!connector_funcs)
-		return -ENOMEM;
-
-	/* connector->helper_private contains always struct
-	 * connector_helper_funcs pointer. For tilcdc crtc to have a
-	 * say if a specific mode is Ok, we need to install our own
-	 * helper functions. In our helper functions we copy
-	 * everything else but use our own mode_valid() (above).
-	 */
-	if (connector->helper_private) {
-		priv->connector_funcs =	connector->helper_private;
-		*connector_funcs = *priv->connector_funcs;
-	} else {
-		priv->connector_funcs = ERR_PTR(-ENOENT);
-	}
-	connector_funcs->mode_valid = tilcdc_external_mode_valid;
-	drm_connector_helper_add(connector, connector_funcs);
-
-	dev_dbg(dev->dev, "External connector '%s' connected\n",
-		connector->name);
-
-	return 0;
-}
-
 static
 struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
 						    struct drm_encoder *encoder)
@@ -119,7 +61,6 @@ struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
 int tilcdc_add_component_encoder(struct drm_device *ddev)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 
 	list_for_each_entry(encoder, &ddev->mode_config.encoder_list, head)
@@ -131,28 +72,17 @@ int tilcdc_add_component_encoder(struct drm_device *ddev)
 		return -ENODEV;
 	}
 
-	connector = tilcdc_encoder_find_connector(ddev, encoder);
+	priv->external_connector =
+		tilcdc_encoder_find_connector(ddev, encoder);
 
-	if (!connector)
+	if (!priv->external_connector)
 		return -ENODEV;
 
 	/* Only tda998x is supported at the moment. */
 	tilcdc_crtc_set_simulate_vesa_sync(priv->crtc, true);
 	tilcdc_crtc_set_panel_info(priv->crtc, &panel_info_tda998x);
 
-	return tilcdc_add_external_connector(ddev, connector);
-}
-
-void tilcdc_remove_external_device(struct drm_device *dev)
-{
-	struct tilcdc_drm_private *priv = dev->dev_private;
-
-	/* Restore the original helper functions, if any. */
-	if (IS_ERR(priv->connector_funcs))
-		drm_connector_helper_add(priv->external_connector, NULL);
-	else if (priv->connector_funcs)
-		drm_connector_helper_add(priv->external_connector,
-					 priv->connector_funcs);
+	return 0;
 }
 
 static const struct drm_encoder_funcs tilcdc_external_encoder_funcs = {
@@ -163,7 +93,6 @@ static
 int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_connector *connector;
 	int ret;
 
 	priv->external_encoder->possible_crtcs = BIT(0);
@@ -176,13 +105,12 @@ int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 
 	tilcdc_crtc_set_panel_info(priv->crtc, &panel_info_default);
 
-	connector = tilcdc_encoder_find_connector(ddev, priv->external_encoder);
-	if (!connector)
+	priv->external_connector =
+		tilcdc_encoder_find_connector(ddev, priv->external_encoder);
+	if (!priv->external_connector)
 		return -ENODEV;
 
-	ret = tilcdc_add_external_connector(ddev, connector);
-
-	return ret;
+	return 0;
 }
 
 int tilcdc_attach_external_device(struct drm_device *ddev)
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.h b/drivers/gpu/drm/tilcdc/tilcdc_external.h
index 763d18f006c7..a28b9df68c8f 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.h
@@ -19,7 +19,6 @@
 #define __TILCDC_EXTERNAL_H__
 
 int tilcdc_add_component_encoder(struct drm_device *dev);
-void tilcdc_remove_external_device(struct drm_device *dev);
 int tilcdc_get_external_components(struct device *dev,
 				   struct component_match **match);
 int tilcdc_attach_external_device(struct drm_device *ddev);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 0484b2cf0e2b..f67a6194fd65 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -176,14 +176,6 @@ static int panel_connector_get_modes(struct drm_connector *connector)
 	return i;
 }
 
-static int panel_connector_mode_valid(struct drm_connector *connector,
-		  struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	/* our only constraints are what the crtc can generate: */
-	return tilcdc_crtc_mode_valid(priv->crtc, mode);
-}
-
 static struct drm_encoder *panel_connector_best_encoder(
 		struct drm_connector *connector)
 {
@@ -201,7 +193,6 @@ static const struct drm_connector_funcs panel_connector_funcs = {
 
 static const struct drm_connector_helper_funcs panel_connector_helper_funcs = {
 	.get_modes          = panel_connector_get_modes,
-	.mode_valid         = panel_connector_mode_valid,
 	.best_encoder       = panel_connector_best_encoder,
 };
 
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 1e2dfb1b1d6b..68c7bbba24e9 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -185,14 +185,6 @@ static int tfp410_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int tfp410_connector_mode_valid(struct drm_connector *connector,
-		  struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	/* our only constraints are what the crtc can generate: */
-	return tilcdc_crtc_mode_valid(priv->crtc, mode);
-}
-
 static struct drm_encoder *tfp410_connector_best_encoder(
 		struct drm_connector *connector)
 {
@@ -211,7 +203,6 @@ static const struct drm_connector_funcs tfp410_connector_funcs = {
 
 static const struct drm_connector_helper_funcs tfp410_connector_helper_funcs = {
 	.get_modes          = tfp410_connector_get_modes,
-	.mode_valid         = tfp410_connector_mode_valid,
 	.best_encoder       = tfp410_connector_best_encoder,
 };
 
-- 
2.35.1



