Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB0497335
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiAWQuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiAWQuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:50:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692ACC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 08:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 063D460F95
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6374C340E2;
        Sun, 23 Jan 2022 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956645;
        bh=Yap0nCBS+EAFiOtOLWBKkOamTWa0ncZYIQyfMrfE1uE=;
        h=Subject:To:Cc:From:Date:From;
        b=bSdGpYYvZSvkElVbZE6U6vkqFFs4neoWtvtULf/dPhY7+cjHm7y6bFkGPuYA0ZTDL
         X+lE5wGReqJ1Mv7tjKHTUkdFPH8n0AmDKaDcrA6PREd4keKkIvZsVpg20AUAkGOUxO
         VLqk6jfEXxqTCbzBllBipTwpcgLgQEZ7qZCIVMvM=
Subject: FAILED: patch "[PATCH] drm/i915: Add support for panels with VESA backlights with" failed to apply to 5.16-stable tree
To:     lyude@redhat.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:50:42 +0100
Message-ID: <164295664220261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04f0d6cc62cc1eaf9242c081520c024a17ba86a3 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Fri, 5 Nov 2021 14:33:38 -0400
Subject: [PATCH] drm/i915: Add support for panels with VESA backlights with
 PWM enable/disable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This simply adds proper support for panel backlights that can be controlled
via VESA's backlight control protocol, but which also require that we
enable and disable the backlight via PWM instead of via the DPCD interface.
We also enable this by default, in order to fix some people's backlights
that were broken by not having this enabled.

For reference, backlights that require this and use VESA's backlight
interface tend to be laptops with hybrid GPUs, but this very well may
change in the future.

v4:
* Make sure that we call intel_backlight_level_to_pwm() in
  intel_dp_aux_vesa_enable_backlight() - vsyrjala

Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/3680
Fixes: fe7d52bccab6 ("drm/i915/dp: Don't use DPCD backlights that need PWM enable/disable")
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Link: https://patchwork.freedesktop.org/patch/msgid/20211105183342.130810-2-lyude@redhat.com

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index 569d17b4d00f..f05b71c01b8e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -293,6 +293,13 @@ intel_dp_aux_vesa_enable_backlight(const struct intel_crtc_state *crtc_state,
 	struct intel_panel *panel = &connector->panel;
 	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
 
+	if (!panel->backlight.edp.vesa.info.aux_enable) {
+		u32 pwm_level = intel_backlight_invert_pwm_level(connector,
+								 panel->backlight.pwm_level_max);
+
+		panel->backlight.pwm_funcs->enable(crtc_state, conn_state, pwm_level);
+	}
+
 	drm_edp_backlight_enable(&intel_dp->aux, &panel->backlight.edp.vesa.info, level);
 }
 
@@ -304,6 +311,10 @@ static void intel_dp_aux_vesa_disable_backlight(const struct drm_connector_state
 	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
 
 	drm_edp_backlight_disable(&intel_dp->aux, &panel->backlight.edp.vesa.info);
+
+	if (!panel->backlight.edp.vesa.info.aux_enable)
+		panel->backlight.pwm_funcs->disable(old_conn_state,
+						    intel_backlight_invert_pwm_level(connector, 0));
 }
 
 static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector, enum pipe pipe)
@@ -321,6 +332,15 @@ static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector,
 	if (ret < 0)
 		return ret;
 
+	if (!panel->backlight.edp.vesa.info.aux_enable) {
+		ret = panel->backlight.pwm_funcs->setup(connector, pipe);
+		if (ret < 0) {
+			drm_err(&i915->drm,
+				"Failed to setup PWM backlight controls for eDP backlight: %d\n",
+				ret);
+			return ret;
+		}
+	}
 	panel->backlight.max = panel->backlight.edp.vesa.info.max;
 	panel->backlight.min = 0;
 	if (current_mode == DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD) {
@@ -340,12 +360,7 @@ intel_dp_aux_supports_vesa_backlight(struct intel_connector *connector)
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 
-	/* TODO: We currently only support AUX only backlight configurations, not backlights which
-	 * require a mix of PWM and AUX controls to work. In the mean time, these machines typically
-	 * work just fine using normal PWM controls anyway.
-	 */
-	if ((intel_dp->edp_dpcd[1] & DP_EDP_BACKLIGHT_AUX_ENABLE_CAP) &&
-	    drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
+	if (drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
 		drm_dbg_kms(&i915->drm, "AUX Backlight Control Supported!\n");
 		return true;
 	}

