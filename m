Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA60B6BB325
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbjCOMl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbjCOMlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086C2A0291
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A64B81E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67934C433D2;
        Wed, 15 Mar 2023 12:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883999;
        bh=K8qJ9fvaFe7b5hBkvgHxH9okfHgOCkUj75cWA6XVCIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWsZDU7eAj5HFaey5BKD/GL3oGesUf4+4Sg8dbibLiyH2aPPS388sLilApfI5F4B5
         rF1zPWX+5/oFD053EVR9Bb3kpa6Tsawxj75v9LZQhVL8AaWZDdVkDHUfKJD7tU9o2o
         IfEks5C9tckKCFmrIT8iCy6SfY3qQtmOxA8uVbCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Animesh Manna <animesh.manna@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 038/141] drm/i915: Do panel VBT init early if the VBT declares an explicit panel type
Date:   Wed, 15 Mar 2023 13:12:21 +0100
Message-Id: <20230315115741.123168303@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 3f9ffce5765d68775163b8b134c4d7f156b48eec ]

Lots of ADL machines out there with bogus VBTs that declare
two eDP child devices. In order for those to work we need to
figure out which power sequencer to use before we try the EDID
read. So let's do the panel VBT init early if we can, falling
back to the post-EDID init otherwise.

The post-EDID init panel_type=0xff approach of assuming the
power sequencer should already be enabled doesn't really work
with multiple eDP panels, and currently we just end up using
the same power sequencer for both eDP ports, which at least
confuses the wakeref tracking, and potentially also causes us
to toggle the VDD for the panel when we should not.

Cc: Animesh Manna <animesh.manna@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221125173156.31689-3-ville.syrjala@linux.intel.com
Stable-dep-of: 14e591a1930c ("drm/i915: Populate encoder->devdata for DSI on icl+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c        |  2 +-
 drivers/gpu/drm/i915/display/intel_bios.c     | 56 ++++++++++++++-----
 drivers/gpu/drm/i915/display/intel_bios.h     | 11 ++--
 .../drm/i915/display/intel_display_types.h    |  2 +-
 drivers/gpu/drm/i915/display/intel_dp.c       |  7 ++-
 drivers/gpu/drm/i915/display/intel_lvds.c     |  4 +-
 drivers/gpu/drm/i915/display/intel_panel.c    |  1 +
 drivers/gpu/drm/i915/display/intel_sdvo.c     |  2 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c        |  2 +-
 9 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index d16b30a2dded3..ae14c794c4bc0 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2043,7 +2043,7 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
 	/* attach connector to encoder */
 	intel_connector_attach_encoder(intel_connector, encoder);
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL, NULL);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL, NULL);
 
 	mutex_lock(&dev_priv->drm.mode_config.mutex);
 	intel_panel_add_vbt_lfp_fixed_mode(intel_connector);
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index a491e6c38875d..e7ab9094ac51a 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -620,14 +620,14 @@ static void dump_pnp_id(struct drm_i915_private *i915,
 
 static int opregion_get_panel_type(struct drm_i915_private *i915,
 				   const struct intel_bios_encoder_data *devdata,
-				   const struct edid *edid)
+				   const struct edid *edid, bool use_fallback)
 {
 	return intel_opregion_get_panel_type(i915);
 }
 
 static int vbt_get_panel_type(struct drm_i915_private *i915,
 			      const struct intel_bios_encoder_data *devdata,
-			      const struct edid *edid)
+			      const struct edid *edid, bool use_fallback)
 {
 	const struct bdb_lvds_options *lvds_options;
 
@@ -652,7 +652,7 @@ static int vbt_get_panel_type(struct drm_i915_private *i915,
 
 static int pnpid_get_panel_type(struct drm_i915_private *i915,
 				const struct intel_bios_encoder_data *devdata,
-				const struct edid *edid)
+				const struct edid *edid, bool use_fallback)
 {
 	const struct bdb_lvds_lfp_data *data;
 	const struct bdb_lvds_lfp_data_ptrs *ptrs;
@@ -701,9 +701,9 @@ static int pnpid_get_panel_type(struct drm_i915_private *i915,
 
 static int fallback_get_panel_type(struct drm_i915_private *i915,
 				   const struct intel_bios_encoder_data *devdata,
-				   const struct edid *edid)
+				   const struct edid *edid, bool use_fallback)
 {
-	return 0;
+	return use_fallback ? 0 : -1;
 }
 
 enum panel_type {
@@ -715,13 +715,13 @@ enum panel_type {
 
 static int get_panel_type(struct drm_i915_private *i915,
 			  const struct intel_bios_encoder_data *devdata,
-			  const struct edid *edid)
+			  const struct edid *edid, bool use_fallback)
 {
 	struct {
 		const char *name;
 		int (*get_panel_type)(struct drm_i915_private *i915,
 				      const struct intel_bios_encoder_data *devdata,
-				      const struct edid *edid);
+				      const struct edid *edid, bool use_fallback);
 		int panel_type;
 	} panel_types[] = {
 		[PANEL_TYPE_OPREGION] = {
@@ -744,7 +744,8 @@ static int get_panel_type(struct drm_i915_private *i915,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(panel_types); i++) {
-		panel_types[i].panel_type = panel_types[i].get_panel_type(i915, devdata, edid);
+		panel_types[i].panel_type = panel_types[i].get_panel_type(i915, devdata,
+									  edid, use_fallback);
 
 		drm_WARN_ON(&i915->drm, panel_types[i].panel_type > 0xf &&
 			    panel_types[i].panel_type != 0xff);
@@ -3199,14 +3200,26 @@ void intel_bios_init(struct drm_i915_private *i915)
 	kfree(oprom_vbt);
 }
 
-void intel_bios_init_panel(struct drm_i915_private *i915,
-			   struct intel_panel *panel,
-			   const struct intel_bios_encoder_data *devdata,
-			   const struct edid *edid)
+static void intel_bios_init_panel(struct drm_i915_private *i915,
+				  struct intel_panel *panel,
+				  const struct intel_bios_encoder_data *devdata,
+				  const struct edid *edid,
+				  bool use_fallback)
 {
-	init_vbt_panel_defaults(panel);
+	/* already have it? */
+	if (panel->vbt.panel_type >= 0) {
+		drm_WARN_ON(&i915->drm, !use_fallback);
+		return;
+	}
 
-	panel->vbt.panel_type = get_panel_type(i915, devdata, edid);
+	panel->vbt.panel_type = get_panel_type(i915, devdata,
+					       edid, use_fallback);
+	if (panel->vbt.panel_type < 0) {
+		drm_WARN_ON(&i915->drm, use_fallback);
+		return;
+	}
+
+	init_vbt_panel_defaults(panel);
 
 	parse_panel_options(i915, panel);
 	parse_generic_dtd(i915, panel);
@@ -3221,6 +3234,21 @@ void intel_bios_init_panel(struct drm_i915_private *i915,
 	parse_mipi_sequence(i915, panel);
 }
 
+void intel_bios_init_panel_early(struct drm_i915_private *i915,
+				 struct intel_panel *panel,
+				 const struct intel_bios_encoder_data *devdata)
+{
+	intel_bios_init_panel(i915, panel, devdata, NULL, false);
+}
+
+void intel_bios_init_panel_late(struct drm_i915_private *i915,
+				struct intel_panel *panel,
+				const struct intel_bios_encoder_data *devdata,
+				const struct edid *edid)
+{
+	intel_bios_init_panel(i915, panel, devdata, edid, true);
+}
+
 /**
  * intel_bios_driver_remove - Free any resources allocated by intel_bios_init()
  * @i915: i915 device instance
diff --git a/drivers/gpu/drm/i915/display/intel_bios.h b/drivers/gpu/drm/i915/display/intel_bios.h
index e375405a78284..ff1fdd2e0c1c5 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.h
+++ b/drivers/gpu/drm/i915/display/intel_bios.h
@@ -232,10 +232,13 @@ struct mipi_pps_data {
 } __packed;
 
 void intel_bios_init(struct drm_i915_private *dev_priv);
-void intel_bios_init_panel(struct drm_i915_private *dev_priv,
-			   struct intel_panel *panel,
-			   const struct intel_bios_encoder_data *devdata,
-			   const struct edid *edid);
+void intel_bios_init_panel_early(struct drm_i915_private *dev_priv,
+				 struct intel_panel *panel,
+				 const struct intel_bios_encoder_data *devdata);
+void intel_bios_init_panel_late(struct drm_i915_private *dev_priv,
+				struct intel_panel *panel,
+				const struct intel_bios_encoder_data *devdata,
+				const struct edid *edid);
 void intel_bios_fini_panel(struct intel_panel *panel);
 void intel_bios_driver_remove(struct drm_i915_private *dev_priv);
 bool intel_bios_is_valid_vbt(const void *buf, size_t size);
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index f07395065a69f..1b6989001ee2b 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -291,7 +291,7 @@ struct intel_vbt_panel_data {
 	struct drm_display_mode *sdvo_lvds_vbt_mode; /* if any */
 
 	/* Feature bits */
-	unsigned int panel_type:4;
+	int panel_type;
 	unsigned int lvds_dither:1;
 	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 75070eb07d4bf..1edb21f698087 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5202,6 +5202,9 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	intel_bios_init_panel_early(dev_priv, &intel_connector->panel,
+				    encoder->devdata);
+
 	intel_pps_init(intel_dp);
 
 	/* Cache DPCD and EDID for edp. */
@@ -5237,8 +5240,8 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 	}
 	intel_connector->edid = edid;
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel,
-			      encoder->devdata, IS_ERR(edid) ? NULL : edid);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel,
+				   encoder->devdata, IS_ERR(edid) ? NULL : edid);
 
 	intel_panel_add_edid_fixed_modes(intel_connector, true);
 
diff --git a/drivers/gpu/drm/i915/display/intel_lvds.c b/drivers/gpu/drm/i915/display/intel_lvds.c
index 7bf1bdfd03ec0..aecec992cd0d2 100644
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -964,8 +964,8 @@ void intel_lvds_init(struct drm_i915_private *dev_priv)
 	}
 	intel_connector->edid = edid;
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL,
-			      IS_ERR(edid) ? NULL : edid);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL,
+				   IS_ERR(edid) ? NULL : edid);
 
 	/* Try EDID first */
 	intel_panel_add_edid_fixed_modes(intel_connector, true);
diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index b49228eb79e75..609fcdbd7d58d 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -665,6 +665,7 @@ void intel_panel_init_alloc(struct intel_connector *connector)
 {
 	struct intel_panel *panel = &connector->panel;
 
+	connector->panel.vbt.panel_type = -1;
 	INIT_LIST_HEAD(&panel->fixed_modes);
 }
 
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 329b9d9af6679..21805c15d5eb8 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2886,7 +2886,7 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, u16 type)
 	if (!intel_sdvo_create_enhance_property(intel_sdvo, intel_sdvo_connector))
 		goto err;
 
-	intel_bios_init_panel(i915, &intel_connector->panel, NULL, NULL);
+	intel_bios_init_panel_late(i915, &intel_connector->panel, NULL, NULL);
 
 	/*
 	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index 84481030883ac..662bdb656aa30 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1916,7 +1916,7 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
 
 	intel_dsi->panel_power_off_time = ktime_get_boottime();
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL, NULL);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL, NULL);
 
 	if (intel_connector->panel.vbt.dsi.config->dual_link)
 		intel_dsi->ports = BIT(PORT_A) | BIT(PORT_C);
-- 
2.39.2



