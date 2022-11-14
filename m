Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2C627FEB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbiKNNCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiKNNCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A3B26481
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C13061175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A170C433D6;
        Mon, 14 Nov 2022 13:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430951;
        bh=dGDX621B2880umc7pnYAa+Yf3p5eXt6thKsYhB1Slb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6TWWpmPzjhLTFXmMaYsvFVZ0/zvxnB7nX1d76ENwxevq/UwhSrvb3Vcg0TiQsrLx
         0DXtnhm+GxocxqduLgbj7Wth0LaHl/PkNCOxcgVRZ++XJx9Ik+sJa78Gh/fKR6+M/d
         2vHDOXYhPDyZUIX5j7u+S5Vio6mDcPjZAx0c71vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 006/190] drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()
Date:   Mon, 14 Nov 2022 13:43:50 +0100
Message-Id: <20221114124459.075271742@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit d372ec94a018c3a19dad71e2ee3478126394d9fc ]

Since commit a5810f551d0a ("drm/i915: Allow more varied alternate
fixed modes for panels") intel_panel_add_edid_alt_fixed_modes()
no longer considers vrr vs. drrs separately. So no reason to
pass them as separate parameters either.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220927180615.25476-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit eb89e83c152b122a94e79527d63cb7c79823c37e)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Stable-dep-of: 12caf46cf4fc ("drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c    | 2 +-
 drivers/gpu/drm/i915/display/intel_lvds.c  | 3 +--
 drivers/gpu/drm/i915/display/intel_panel.c | 4 ++--
 drivers/gpu/drm/i915/display/intel_panel.h | 2 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c  | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index d4492b6d23d2..21ba510716b6 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5233,7 +5233,7 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 			      encoder->devdata, IS_ERR(edid) ? NULL : edid);
 
 	intel_panel_add_edid_fixed_modes(intel_connector,
-					 intel_connector->panel.vbt.drrs_type != DRRS_TYPE_NONE,
+					 intel_connector->panel.vbt.drrs_type != DRRS_TYPE_NONE ||
 					 intel_vrr_is_capable(intel_connector));
 
 	/* MSO requires information from the EDID */
diff --git a/drivers/gpu/drm/i915/display/intel_lvds.c b/drivers/gpu/drm/i915/display/intel_lvds.c
index 730480ac3300..c0bec3e0f0ae 100644
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -972,8 +972,7 @@ void intel_lvds_init(struct drm_i915_private *dev_priv)
 
 	/* Try EDID first */
 	intel_panel_add_edid_fixed_modes(intel_connector,
-					 intel_connector->panel.vbt.drrs_type != DRRS_TYPE_NONE,
-					 false);
+					 intel_connector->panel.vbt.drrs_type != DRRS_TYPE_NONE);
 
 	/* Failed to get EDID, what about VBT? */
 	if (!intel_panel_preferred_fixed_mode(intel_connector))
diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index cb44984bb9a2..1e008922b95d 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -238,10 +238,10 @@ static void intel_panel_destroy_probed_modes(struct intel_connector *connector)
 }
 
 void intel_panel_add_edid_fixed_modes(struct intel_connector *connector,
-				      bool has_drrs, bool has_vrr)
+				      bool use_alt_fixed_modes)
 {
 	intel_panel_add_edid_preferred_mode(connector);
-	if (intel_panel_preferred_fixed_mode(connector) && (has_drrs || has_vrr))
+	if (intel_panel_preferred_fixed_mode(connector) && use_alt_fixed_modes)
 		intel_panel_add_edid_alt_fixed_modes(connector);
 	intel_panel_destroy_probed_modes(connector);
 }
diff --git a/drivers/gpu/drm/i915/display/intel_panel.h b/drivers/gpu/drm/i915/display/intel_panel.h
index b087c0c3cc6d..4a94bd0eae3b 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.h
+++ b/drivers/gpu/drm/i915/display/intel_panel.h
@@ -41,7 +41,7 @@ int intel_panel_fitting(struct intel_crtc_state *crtc_state,
 int intel_panel_compute_config(struct intel_connector *connector,
 			       struct drm_display_mode *adjusted_mode);
 void intel_panel_add_edid_fixed_modes(struct intel_connector *connector,
-				      bool has_drrs, bool has_vrr);
+				      bool use_alt_fixed_modes);
 void intel_panel_add_vbt_lfp_fixed_mode(struct intel_connector *connector);
 void intel_panel_add_vbt_sdvo_fixed_mode(struct intel_connector *connector);
 void intel_panel_add_encoder_fixed_mode(struct intel_connector *connector,
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index b5f65b093c10..282820fe55b5 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2901,7 +2901,7 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 
 	if (!intel_panel_preferred_fixed_mode(intel_connector)) {
 		intel_ddc_get_modes(connector, &intel_sdvo->ddc);
-		intel_panel_add_edid_fixed_modes(intel_connector, false, false);
+		intel_panel_add_edid_fixed_modes(intel_connector, false);
 	}
 
 	intel_panel_init(intel_connector);
-- 
2.35.1



