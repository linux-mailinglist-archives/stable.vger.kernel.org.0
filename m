Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACAF419FDC
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbhI0UOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 16:14:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236816AbhI0UOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 16:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632773560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RRg7qaSkYFTmSpOqY6x05C6jG3RXAAV6AEUBcClpAI0=;
        b=ZgxjdPfkmWD667BCwthOe2XDUmLA0rS3YJQ3GUwnMoKKbwGJdNrdag6qbVrgfouDxrlhLE
        rOITLHSCIGcIYM34X8QAicsvXUGWPr+Ywy2R4cIim6+6OD8x6Vb2qzqmmXLtvHBoawioBt
        Hgc5XncaorN0CYZYNQUGA9M8c00tS7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-SDnurkPuOAGDcg8n0-AO9Q-1; Mon, 27 Sep 2021 16:12:37 -0400
X-MC-Unique: SDnurkPuOAGDcg8n0-AO9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A7B802C88;
        Mon, 27 Sep 2021 20:12:35 +0000 (UTC)
Received: from Ruby.lyude.net (unknown [10.22.17.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A318410074EF;
        Mon, 27 Sep 2021 20:12:32 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] drm/i915: Add support for panels with VESA backlights with PWM enable/disable
Date:   Mon, 27 Sep 2021 16:12:04 -0400
Message-Id: <20210927201206.682788-2-lyude@redhat.com>
In-Reply-To: <20210927201206.682788-1-lyude@redhat.com>
References: <20210927201206.682788-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This simply adds proper support for panel backlights that can be controlled
via VESA's backlight control protocol, but which also require that we
enable and disable the backlight via PWM instead of via the DPCD interface.
We also enable this by default, in order to fix some people's backlights
that were broken by not having this enabled.

For reference, backlights that require this and use VESA's backlight
interface tend to be laptops with hybrid GPUs, but this very well may
change in the future.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/3680
Fixes: fe7d52bccab6 ("drm/i915/dp: Don't use DPCD backlights that need PWM enable/disable")
Cc: <stable@vger.kernel.org> # v5.12+
---
 .../drm/i915/display/intel_dp_aux_backlight.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index 569d17b4d00f..594fdc7453ca 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -293,6 +293,10 @@ intel_dp_aux_vesa_enable_backlight(const struct intel_crtc_state *crtc_state,
 	struct intel_panel *panel = &connector->panel;
 	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
 
+	if (!panel->backlight.edp.vesa.info.aux_enable)
+		panel->backlight.pwm_funcs->enable(crtc_state, conn_state,
+						   panel->backlight.pwm_level_max);
+
 	drm_edp_backlight_enable(&intel_dp->aux, &panel->backlight.edp.vesa.info, level);
 }
 
@@ -304,6 +308,10 @@ static void intel_dp_aux_vesa_disable_backlight(const struct drm_connector_state
 	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
 
 	drm_edp_backlight_disable(&intel_dp->aux, &panel->backlight.edp.vesa.info);
+
+	if (!panel->backlight.edp.vesa.info.aux_enable)
+		panel->backlight.pwm_funcs->disable(old_conn_state,
+						    intel_backlight_invert_pwm_level(connector, 0));
 }
 
 static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector, enum pipe pipe)
@@ -321,6 +329,15 @@ static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector,
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
@@ -340,12 +357,7 @@ intel_dp_aux_supports_vesa_backlight(struct intel_connector *connector)
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
-- 
2.31.1

