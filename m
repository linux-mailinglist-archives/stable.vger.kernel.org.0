Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B360D228
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 18:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiJYQ7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 12:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiJYQ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 12:59:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0D917415
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 09:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666717182; x=1698253182;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qX7Kc/WSRswECF9x6zNcp49V86F7NNcuzfDKFsaS378=;
  b=KVuCfC75zHwY7diHD9rODDcWbI+hTstI7LVAu0OXt/riY+OmGCiRe3Pv
   s8VMhkFIq5rRmfCeeJi2xcVVwUDOQKurPevAmPF4Kt73FcEVMdzlmJRJl
   ngNtwJ86obG9vl0qHVOknwO48U91W+274tL7/rr7NPqvQ8Fgj7+rTiAvE
   nXtAnrETyhCTvRtlse+RsE6D582n9FEKuwe+gaLqzaUekr1wrVU7QhnCT
   NrUcvnWEtyUFx6l1N088xeNqgavUQlbKdFLlsaZU8SAEAe4HqWRqfe76P
   5qKpXbIN/8Jgin2Jg5NwYYGl0nJYjf3q3/m7y+hpVVGsgbtNx0OtZj4zg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="291036523"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="291036523"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 09:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="609640147"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="609640147"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga006.jf.intel.com with SMTP; 25 Oct 2022 09:59:39 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 25 Oct 2022 19:59:38 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/sdvo: Fallback to current output timings for LVDS fixed mode
Date:   Tue, 25 Oct 2022 19:59:38 +0300
Message-Id: <20221025165938.17264-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

If we can't dig out a fixed mode for LVDS from the VBT or EDID
let's fall back to using the current output timings. This should
work as long as the BIOS has (somehow) enabled the output.

In this case we are dealing with the some kind of BLB based POS
machine (Toshiba SurePOS 500) where neither the OpRegion mailbox
nor the vbios ROM contain a valid VBT. And no EDID anywhere we
could find either.

Cc: <stable@vger.kernel.org> # v5.19+
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_panel.c |  6 ++--
 drivers/gpu/drm/i915/display/intel_panel.h |  3 ++
 drivers/gpu/drm/i915/display/intel_sdvo.c  | 40 ++++++++++++++++++++++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 69ce77711b7c..69082fbc7647 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -275,9 +275,9 @@ void intel_panel_add_edid_fixed_modes(struct intel_connector *connector,
 	intel_panel_destroy_probed_modes(connector);
 }
 
-static void intel_panel_add_fixed_mode(struct intel_connector *connector,
-				       struct drm_display_mode *fixed_mode,
-				       const char *type)
+void intel_panel_add_fixed_mode(struct intel_connector *connector,
+				struct drm_display_mode *fixed_mode,
+				const char *type)
 {
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	struct drm_display_info *info = &connector->base.display_info;
diff --git a/drivers/gpu/drm/i915/display/intel_panel.h b/drivers/gpu/drm/i915/display/intel_panel.h
index 5c5b5b7f95b6..964efed8ef3c 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.h
+++ b/drivers/gpu/drm/i915/display/intel_panel.h
@@ -43,6 +43,9 @@ int intel_panel_fitting(struct intel_crtc_state *crtc_state,
 			const struct drm_connector_state *conn_state);
 int intel_panel_compute_config(struct intel_connector *connector,
 			       struct drm_display_mode *adjusted_mode);
+void intel_panel_add_fixed_mode(struct intel_connector *connector,
+				struct drm_display_mode *fixed_mode,
+				const char *type);
 void intel_panel_add_edid_fixed_modes(struct intel_connector *connector,
 				      bool use_alt_fixed_modes);
 void intel_panel_add_vbt_lfp_fixed_mode(struct intel_connector *connector);
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index cf8e80936d8e..9ed54118b669 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -781,6 +781,13 @@ static bool intel_sdvo_get_input_timing(struct intel_sdvo *intel_sdvo,
 				     SDVO_CMD_GET_INPUT_TIMINGS_PART1, dtd);
 }
 
+static bool intel_sdvo_get_output_timing(struct intel_sdvo *intel_sdvo,
+					 struct intel_sdvo_dtd *dtd)
+{
+	return intel_sdvo_get_timing(intel_sdvo,
+				     SDVO_CMD_GET_OUTPUT_TIMINGS_PART1, dtd);
+}
+
 static bool
 intel_sdvo_create_preferred_input_timing(struct intel_sdvo *intel_sdvo,
 					 struct intel_sdvo_connector *intel_sdvo_connector,
@@ -2864,6 +2871,36 @@ intel_sdvo_analog_init(struct intel_sdvo *intel_sdvo, int device)
 	return true;
 }
 
+static void
+intel_sdvo_add_current_fixed_mode(struct intel_sdvo *intel_sdvo,
+				  struct intel_sdvo_connector *connector)
+{
+	struct drm_i915_private *i915 = to_i915(intel_sdvo->base.base.dev);
+	struct drm_display_mode *mode;
+	struct intel_sdvo_dtd dtd = {};
+
+	if (!intel_sdvo_set_target_output(intel_sdvo,
+					  connector->output_flag)) {
+		drm_dbg_kms(&i915->drm, "failed to set SDVO target output\n");
+		return;
+	}
+
+	if (!intel_sdvo_get_output_timing(intel_sdvo, &dtd)) {
+		drm_dbg_kms(&i915->drm, "failed to get SDVO output timings\n");
+		return;
+	}
+
+	mode = drm_mode_create(&i915->drm);
+	if (!mode)
+		return;
+
+	intel_sdvo_get_mode_from_dtd(mode, &dtd);
+
+	drm_mode_set_name(mode);
+
+	intel_panel_add_fixed_mode(&connector->base, mode, "current (SDVO)");
+}
+
 static bool
 intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 {
@@ -2913,6 +2950,9 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 		intel_panel_add_edid_fixed_modes(intel_connector, false);
 	}
 
+	if (!intel_panel_preferred_fixed_mode(intel_connector))
+		intel_sdvo_add_current_fixed_mode(intel_sdvo, intel_sdvo_connector);
+
 	intel_panel_init(intel_connector);
 
 	if (!intel_panel_preferred_fixed_mode(intel_connector))
-- 
2.37.4

