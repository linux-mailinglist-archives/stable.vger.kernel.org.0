Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1036E9FB
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhD2MGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 08:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhD2MGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 08:06:50 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F8CC06138B;
        Thu, 29 Apr 2021 05:06:03 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 9CE22C800F9;
        Thu, 29 Apr 2021 14:06:00 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id zStg9Uz8oNy5; Thu, 29 Apr 2021 14:06:00 +0200 (CEST)
Received: from wsembach-tuxedo.fritz.box (p200300e37F398600fDb5850719dbc945.dip0.t-ipconnect.de [IPv6:2003:e3:7f39:8600:fdb5:8507:19db:c945])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 3B7FAC800F8;
        Thu, 29 Apr 2021 14:06:00 +0200 (CEST)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     wse@tuxedocomputers.com, airlied@linux.ie, daniel@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/display Try YCbCr420 color when RGB fails
Date:   Thu, 29 Apr 2021 14:05:53 +0200
Message-Id: <20210429120553.7823-1-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When encoder validation of a display mode fails, retry with less bandwidth
heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
to support 4k60Hz output, which previously failed silently.

AMDGPU had nearly the exact same issue. This problem description is
therefore copied from my commit message of the AMDGPU patch.

On some setups, while the monitor and the gpu support display modes with
pixel clocks of up to 600MHz, the link encoder might not. This prevents
YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
possible. However, which color mode is used is decided before the link
encoder capabilities are checked. This patch fixes the problem by retrying
to find a display mode with YCbCr420 enforced and using it, if it is
valid.

I'm not entierly sure if the second
"if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))" check in
intel_hdmi_compute_config(...) after forcing ycbcr420 is necessary. I
included it to better be safe then sorry.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
---
Rebased from 5.12 to drm-tip and resend to resolve merge conflict.

From 876c1c8d970ff2a411ee8d08651bd4edbe9ecb3d Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Thu, 29 Apr 2021 13:59:30 +0200
Subject: [PATCH] Retry using YCbCr420 encoding if clock setup for RGB fails

---
 drivers/gpu/drm/i915/display/intel_hdmi.c | 80 +++++++++++++++++------
 1 file changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 46de56af33db..c9b5a7d7f9c6 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1861,6 +1861,30 @@ static int intel_hdmi_port_clock(int clock, int bpc)
 	return clock * bpc / 8;
 }
 
+static enum drm_mode_status
+intel_hdmi_check_bpc(struct intel_hdmi *hdmi, int clock, bool has_hdmi_sink, struct drm_i915_private *dev_priv)
+{
+	enum drm_mode_status status;
+
+	/* check if we can do 8bpc */
+	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
+				       true, has_hdmi_sink);
+
+	if (has_hdmi_sink) {
+		/* if we can't do 8bpc we may still be able to do 12bpc */
+		if (status != MODE_OK && !HAS_GMCH(dev_priv))
+			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
+						       true, has_hdmi_sink);
+
+		/* if we can't do 8,12bpc we may still be able to do 10bpc */
+		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
+			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
+						       true, has_hdmi_sink);
+	}
+
+	return status;
+}
+
 static enum drm_mode_status
 intel_hdmi_mode_valid(struct drm_connector *connector,
 		      struct drm_display_mode *mode)
@@ -1891,23 +1915,18 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
 	if (drm_mode_is_420_only(&connector->display_info, mode))
 		clock /= 2;
 
-	/* check if we can do 8bpc */
-	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
-				       true, has_hdmi_sink);
+	status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
 
-	if (has_hdmi_sink) {
-		/* if we can't do 8bpc we may still be able to do 12bpc */
-		if (status != MODE_OK && !HAS_GMCH(dev_priv))
-			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
-						       true, has_hdmi_sink);
+	if (status != MODE_OK) {
+		if (drm_mode_is_420_also(&connector->display_info, mode)) {
+			/* if we can't do full color resolution we may still be able to do reduced color resolution */
+			clock /= 2;
 
-		/* if we can't do 8,12bpc we may still be able to do 10bpc */
-		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
-			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
-						       true, has_hdmi_sink);
+			status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
+		}
+		if (status != MODE_OK)
+			return status;
 	}
-	if (status != MODE_OK)
-		return status;
 
 	return intel_mode_valid_max_plane_size(dev_priv, mode, false);
 }
@@ -1990,14 +2009,17 @@ static bool hdmi_deep_color_possible(const struct intel_crtc_state *crtc_state,
 
 static int
 intel_hdmi_ycbcr420_config(struct intel_crtc_state *crtc_state,
-			   const struct drm_connector_state *conn_state)
+			   const struct drm_connector_state *conn_state,
+			   const bool force_ycbcr420)
 {
 	struct drm_connector *connector = conn_state->connector;
 	struct drm_i915_private *i915 = to_i915(connector->dev);
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
 
-	if (!drm_mode_is_420_only(&connector->display_info, adjusted_mode))
+	if (!(drm_mode_is_420_only(&connector->display_info, adjusted_mode) ||
+			(force_ycbcr420 &&
+			drm_mode_is_420_also(&connector->display_info, adjusted_mode))))
 		return 0;
 
 	if (!connector->ycbcr_420_allowed) {
@@ -2126,7 +2148,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 	struct drm_display_mode *adjusted_mode = &pipe_config->hw.adjusted_mode;
 	struct drm_connector *connector = conn_state->connector;
 	struct drm_scdc *scdc = &connector->display_info.hdmi.scdc;
-	int ret;
+	int ret, ret_saved;
 
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return -EINVAL;
@@ -2141,7 +2163,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
 		pipe_config->pixel_multiplier = 2;
 
-	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state);
+	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, false);
 	if (ret)
 		return ret;
 
@@ -2155,8 +2177,26 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 		intel_hdmi_has_audio(encoder, pipe_config, conn_state);
 
 	ret = intel_hdmi_compute_clock(encoder, pipe_config);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret_saved = ret;
+
+		ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, true);
+		if (ret)
+			return ret;
+
+		if (pipe_config->output_format != INTEL_OUTPUT_FORMAT_YCBCR420)
+			return ret_saved;
+
+		pipe_config->limited_color_range =
+			intel_hdmi_limited_color_range(pipe_config, conn_state);
+
+		if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))
+			pipe_config->has_pch_encoder = true;
+
+		ret = intel_hdmi_compute_clock(encoder, pipe_config);
+		if (ret)
+			return ret;
+	}
 
 	if (conn_state->picture_aspect_ratio)
 		adjusted_mode->picture_aspect_ratio =
-- 
2.25.1

