Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB036DE78
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 19:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242253AbhD1RkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 13:40:12 -0400
Received: from srv6.fidu.org ([159.69.62.71]:55662 "EHLO srv6.fidu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242630AbhD1Rja (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 13:39:30 -0400
X-Greylist: delayed 93891 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2021 13:39:29 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id BE1A1C800F8;
        Wed, 28 Apr 2021 19:38:38 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id Kd_ISh5iUVqZ; Wed, 28 Apr 2021 19:38:38 +0200 (CEST)
Received: from wsembach-tuxedo.fritz.box (p200300e37f398600C736Fc0acfe84D15.dip0.t-ipconnect.de [IPv6:2003:e3:7f39:8600:c736:fc0a:cfe8:4d15])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 65199C800F9;
        Wed, 28 Apr 2021 19:38:38 +0200 (CEST)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     wse@tuxedocomputers.com, airlied@linux.ie, daniel@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/display Try YCbCr420 color when RGB fails
Date:   Wed, 28 Apr 2021 19:38:07 +0200
Message-Id: <20210428173807.92518-1-wse@tuxedocomputers.com>
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

From c7499210af78e15a2aea2178000958f26e0d43a0 Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Tue, 30 Mar 2021 15:07:34 +0200
Subject: [PATCH] Retry using YCbCr420 encoding if clock setup for RGB fails

---
 drivers/gpu/drm/i915/display/intel_hdmi.c | 78 +++++++++++++++++------
 1 file changed, 59 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 95919d325b0b..273685c0e395 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -2233,6 +2233,29 @@ hdmi_port_clock_valid(struct intel_hdmi *hdmi,
 	return MODE_OK;
 }
 
+static enum drm_mode_status
+intel_hdmi_check_bpc(struct intel_hdmi *hdmi, int clock, bool has_hdmi_sink, struct drm_i915_private *dev_priv)
+{
+	enum drm_mode_status status;
+
+	/* check if we can do 8bpc */
+	status = hdmi_port_clock_valid(hdmi, clock, true, has_hdmi_sink);
+
+	if (has_hdmi_sink) {
+		/* if we can't do 8bpc we may still be able to do 12bpc */
+		if (status != MODE_OK && !HAS_GMCH(dev_priv))
+			status = hdmi_port_clock_valid(hdmi, clock * 3 / 2,
+						       true, has_hdmi_sink);
+
+		/* if we can't do 8,12bpc we may still be able to do 10bpc */
+		if (status != MODE_OK && INTEL_GEN(dev_priv) >= 11)
+			status = hdmi_port_clock_valid(hdmi, clock * 5 / 4,
+						       true, has_hdmi_sink);
+	}
+
+	return status;
+}
+
 static enum drm_mode_status
 intel_hdmi_mode_valid(struct drm_connector *connector,
 		      struct drm_display_mode *mode)
@@ -2263,22 +2286,18 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
 	if (drm_mode_is_420_only(&connector->display_info, mode))
 		clock /= 2;
 
-	/* check if we can do 8bpc */
-	status = hdmi_port_clock_valid(hdmi, clock, true, has_hdmi_sink);
+	status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
 
-	if (has_hdmi_sink) {
-		/* if we can't do 8bpc we may still be able to do 12bpc */
-		if (status != MODE_OK && !HAS_GMCH(dev_priv))
-			status = hdmi_port_clock_valid(hdmi, clock * 3 / 2,
-						       true, has_hdmi_sink);
+	if (status != MODE_OK) {
+		if (drm_mode_is_420_also(&connector->display_info, mode)) {
+			/* if we can't do full color resolution we may still be able to do reduced color resolution */
+			clock /= 2;
 
-		/* if we can't do 8,12bpc we may still be able to do 10bpc */
-		if (status != MODE_OK && INTEL_GEN(dev_priv) >= 11)
-			status = hdmi_port_clock_valid(hdmi, clock * 5 / 4,
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
@@ -2361,14 +2380,17 @@ static bool hdmi_deep_color_possible(const struct intel_crtc_state *crtc_state,
 
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
@@ -2507,7 +2529,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 	struct drm_display_mode *adjusted_mode = &pipe_config->hw.adjusted_mode;
 	struct drm_connector *connector = conn_state->connector;
 	struct drm_scdc *scdc = &connector->display_info.hdmi.scdc;
-	int ret;
+	int ret, ret_saved;
 
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return -EINVAL;
@@ -2522,7 +2544,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
 		pipe_config->pixel_multiplier = 2;
 
-	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state);
+	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, false);
 	if (ret)
 		return ret;
 
@@ -2536,8 +2558,26 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
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

