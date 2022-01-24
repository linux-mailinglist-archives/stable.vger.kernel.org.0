Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8125E497DFC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbiAXLae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiAXLac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454E6C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 03:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C0FB80AE3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C249C340E1;
        Mon, 24 Jan 2022 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643023829;
        bh=/F4BdxSnPyX35AbCp8lqfyFnokAISZn6R17S6mKKqmU=;
        h=Subject:To:Cc:From:Date:From;
        b=tLKeeTOJsP3O3wW+7Hz22GzSSKUF6te3yXj5b3YeAWNmVz7Ny29EUmiYVmOU+reig
         BNglut12meGZ8o10dLDwAvxH5lXbLy1bg4+jv/YZguv3O3KOgseYuPrV3Tu+Ai0o3i
         hB6otsd0EdMcaQBaNwCYa77oH2F9+3uKYdAWauss=
Subject: FAILED: patch "[PATCH] drm/vc4: hdmi: Prevent access to crtc->state outside of KMS" failed to apply to 5.15-stable tree
To:     maxime@cerno.tech, daniel.vetter@ffwll.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:30:27 +0100
Message-ID: <164302382722957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 633be8c3c0c5e0cf176ce904083a4728ae8e4025 Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Mon, 25 Oct 2021 16:11:10 +0200
Subject: [PATCH] drm/vc4: hdmi: Prevent access to crtc->state outside of KMS

Accessing the crtc->state pointer from outside the modesetting context
is not allowed. We thus need to copy whatever we need from the KMS state
to our structure in order to access it.

However, in the vc4 HDMI driver we do use that pointer in the ALSA code
path, and potentially in the hotplug interrupt handler path.

These paths both need access to the CRTC adjusted mode in order for the
proper dividers to be set for ALSA, and the scrambler state to be
reinstated properly for hotplug.

Let's copy this mode into our private encoder structure and reference it
from there when needed. Since that part is shared between KMS and other
paths, we need to protect it using our mutex.

Link: https://lore.kernel.org/all/YWgteNaNeaS9uWDe@phenom.ffwll.local/
Link: https://lore.kernel.org/r/20211025141113.702757-7-maxime@cerno.tech
Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index cea3665abcd6..71e3d1044d84 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -484,8 +484,7 @@ static void vc4_hdmi_set_avi_infoframe(struct drm_encoder *encoder)
 	struct vc4_hdmi_encoder *vc4_encoder = to_vc4_hdmi_encoder(encoder);
 	struct drm_connector *connector = &vc4_hdmi->connector;
 	struct drm_connector_state *cstate = connector->state;
-	struct drm_crtc *crtc = encoder->crtc;
-	const struct drm_display_mode *mode = &crtc->state->adjusted_mode;
+	const struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	union hdmi_infoframe frame;
 	int ret;
 
@@ -597,8 +596,8 @@ static bool vc4_hdmi_supports_scrambling(struct drm_encoder *encoder,
 
 static void vc4_hdmi_enable_scrambling(struct drm_encoder *encoder)
 {
-	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	unsigned long flags;
 
 	lockdep_assert_held(&vc4_hdmi->mutex);
@@ -624,18 +623,21 @@ static void vc4_hdmi_enable_scrambling(struct drm_encoder *encoder)
 static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 {
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	struct drm_crtc *crtc = encoder->crtc;
 	unsigned long flags;
 
+	lockdep_assert_held(&vc4_hdmi->mutex);
+
 	/*
 	 * At boot, encoder->crtc will be NULL. Since we don't know the
 	 * state of the scrambler and in order to avoid any
 	 * inconsistency, let's disable it all the time.
 	 */
-	if (crtc && !vc4_hdmi_supports_scrambling(encoder, &crtc->mode))
+	if (crtc && !vc4_hdmi_supports_scrambling(encoder, mode))
 		return;
 
-	if (crtc && !vc4_hdmi_mode_needs_scrambling(&crtc->mode))
+	if (crtc && !vc4_hdmi_mode_needs_scrambling(mode))
 		return;
 
 	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
@@ -1008,8 +1010,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		vc4_hdmi_encoder_get_connector_state(encoder, state);
 	struct vc4_hdmi_connector_state *vc4_conn_state =
 		conn_state_to_vc4_hdmi_conn_state(conn_state);
-	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	unsigned long pixel_rate = vc4_conn_state->pixel_rate;
 	unsigned long bvb_rate, hsm_rate;
 	unsigned long flags;
@@ -1111,9 +1113,9 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 static void vc4_hdmi_encoder_pre_crtc_enable(struct drm_encoder *encoder,
 					     struct drm_atomic_state *state)
 {
-	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
-	struct vc4_hdmi_encoder *vc4_encoder = to_vc4_hdmi_encoder(encoder);
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
+	struct vc4_hdmi_encoder *vc4_encoder = to_vc4_hdmi_encoder(encoder);
 	unsigned long flags;
 
 	mutex_lock(&vc4_hdmi->mutex);
@@ -1141,8 +1143,8 @@ static void vc4_hdmi_encoder_pre_crtc_enable(struct drm_encoder *encoder,
 static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 					      struct drm_atomic_state *state)
 {
-	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	struct vc4_hdmi_encoder *vc4_encoder = to_vc4_hdmi_encoder(encoder);
 	bool hsync_pos = mode->flags & DRM_MODE_FLAG_PHSYNC;
 	bool vsync_pos = mode->flags & DRM_MODE_FLAG_PVSYNC;
@@ -1218,6 +1220,19 @@ static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
 {
 }
 
+static void vc4_hdmi_encoder_atomic_mode_set(struct drm_encoder *encoder,
+					     struct drm_crtc_state *crtc_state,
+					     struct drm_connector_state *conn_state)
+{
+	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+
+	mutex_lock(&vc4_hdmi->mutex);
+	memcpy(&vc4_hdmi->saved_adjusted_mode,
+	       &crtc_state->adjusted_mode,
+	       sizeof(vc4_hdmi->saved_adjusted_mode));
+	mutex_unlock(&vc4_hdmi->mutex);
+}
+
 #define WIFI_2_4GHz_CH1_MIN_FREQ	2400000000ULL
 #define WIFI_2_4GHz_CH1_MAX_FREQ	2422000000ULL
 
@@ -1294,6 +1309,7 @@ vc4_hdmi_encoder_mode_valid(struct drm_encoder *encoder,
 
 static const struct drm_encoder_helper_funcs vc4_hdmi_encoder_helper_funcs = {
 	.atomic_check = vc4_hdmi_encoder_atomic_check,
+	.atomic_mode_set = vc4_hdmi_encoder_atomic_mode_set,
 	.mode_valid = vc4_hdmi_encoder_mode_valid,
 	.disable = vc4_hdmi_encoder_disable,
 	.enable = vc4_hdmi_encoder_enable,
@@ -1347,9 +1363,7 @@ static void vc4_hdmi_audio_set_mai_clock(struct vc4_hdmi *vc4_hdmi,
 
 static void vc4_hdmi_set_n_cts(struct vc4_hdmi *vc4_hdmi, unsigned int samplerate)
 {
-	struct drm_encoder *encoder = &vc4_hdmi->encoder.base.base;
-	struct drm_crtc *crtc = encoder->crtc;
-	const struct drm_display_mode *mode = &crtc->state->adjusted_mode;
+	const struct drm_display_mode *mode = &vc4_hdmi->saved_adjusted_mode;
 	u32 n, cts;
 	u64 tmp;
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.h b/drivers/gpu/drm/vc4/vc4_hdmi.h
index cf9bb21a8ef7..a43cc5614d19 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.h
@@ -197,6 +197,12 @@ struct vc4_hdmi {
 	 * be resilient to that.
 	 */
 	struct mutex mutex;
+
+	/**
+	 * @saved_adjusted_mode: Copy of @drm_crtc_state.adjusted_mode
+	 * for use by ALSA hooks and interrupt handlers. Protected by @mutex.
+	 */
+	struct drm_display_mode saved_adjusted_mode;
 };
 
 static inline struct vc4_hdmi *

