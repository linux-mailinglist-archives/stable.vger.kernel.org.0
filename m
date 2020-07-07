Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD62171A9
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgGGPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbgGGPXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E4692065D;
        Tue,  7 Jul 2020 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135409;
        bh=rzP5T9N3x3wQHrYUFrFJ1S2cJcZshoRH0ZUnfglc/HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VztxqMVw6JSrL+onrnDGW7Y1GoYFmFjg4oxROdADHlRGZVpP9La/HvQFiuaDlMT9Z
         ilBZgWIfwtSmovKAljwc/r/8gS1yG/K6fs22dcjuyvlsLlReymrKcLs2osG0tJ13iS
         uD1V0klzwOYhBlwHA3TqjGUnKNXmH0H8RV7/GNXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 009/112] drm/amd/display: Fix incorrectly pruned modes with deep color
Date:   Tue,  7 Jul 2020 17:16:14 +0200
Message-Id: <20200707145801.418588891@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[ Upstream commit cbd14ae7ea934fd9d9f95103a0601a7fea243573 ]

[Why]
When "max bpc" is set to enable deep color, some modes are removed from
the list if they fail validation on max bpc. These modes should be kept
if they validates fine with lower bpc.

[How]
- Retry with lower bpc in mode validation.
- Same in atomic commit to apply working bpc, not necessarily max bpc.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 102 +++++++++++-------
 1 file changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f9f02e08054bc..b7e161f2a47d4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3797,8 +3797,7 @@ static void update_stream_scaling_settings(const struct drm_display_mode *mode,
 
 static enum dc_color_depth
 convert_color_depth_from_display_info(const struct drm_connector *connector,
-				      const struct drm_connector_state *state,
-				      bool is_y420)
+				      bool is_y420, int requested_bpc)
 {
 	uint8_t bpc;
 
@@ -3818,10 +3817,7 @@ convert_color_depth_from_display_info(const struct drm_connector *connector,
 		bpc = bpc ? bpc : 8;
 	}
 
-	if (!state)
-		state = connector->state;
-
-	if (state) {
+	if (requested_bpc > 0) {
 		/*
 		 * Cap display bpc based on the user requested value.
 		 *
@@ -3830,7 +3826,7 @@ convert_color_depth_from_display_info(const struct drm_connector *connector,
 		 * or if this was called outside of atomic check, so it
 		 * can't be used directly.
 		 */
-		bpc = min(bpc, state->max_requested_bpc);
+		bpc = min_t(u8, bpc, requested_bpc);
 
 		/* Round down to the nearest even number. */
 		bpc = bpc - (bpc & 1);
@@ -3952,7 +3948,8 @@ static void fill_stream_properties_from_drm_display_mode(
 	const struct drm_display_mode *mode_in,
 	const struct drm_connector *connector,
 	const struct drm_connector_state *connector_state,
-	const struct dc_stream_state *old_stream)
+	const struct dc_stream_state *old_stream,
+	int requested_bpc)
 {
 	struct dc_crtc_timing *timing_out = &stream->timing;
 	const struct drm_display_info *info = &connector->display_info;
@@ -3982,8 +3979,9 @@ static void fill_stream_properties_from_drm_display_mode(
 
 	timing_out->timing_3d_format = TIMING_3D_FORMAT_NONE;
 	timing_out->display_color_depth = convert_color_depth_from_display_info(
-		connector, connector_state,
-		(timing_out->pixel_encoding == PIXEL_ENCODING_YCBCR420));
+		connector,
+		(timing_out->pixel_encoding == PIXEL_ENCODING_YCBCR420),
+		requested_bpc);
 	timing_out->scan_type = SCANNING_TYPE_NODATA;
 	timing_out->hdmi_vic = 0;
 
@@ -4189,7 +4187,8 @@ static struct dc_stream_state *
 create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 		       const struct drm_display_mode *drm_mode,
 		       const struct dm_connector_state *dm_state,
-		       const struct dc_stream_state *old_stream)
+		       const struct dc_stream_state *old_stream,
+		       int requested_bpc)
 {
 	struct drm_display_mode *preferred_mode = NULL;
 	struct drm_connector *drm_connector;
@@ -4274,10 +4273,10 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	*/
 	if (!scale || mode_refresh != preferred_refresh)
 		fill_stream_properties_from_drm_display_mode(stream,
-			&mode, &aconnector->base, con_state, NULL);
+			&mode, &aconnector->base, con_state, NULL, requested_bpc);
 	else
 		fill_stream_properties_from_drm_display_mode(stream,
-			&mode, &aconnector->base, con_state, old_stream);
+			&mode, &aconnector->base, con_state, old_stream, requested_bpc);
 
 	stream->timing.flags.DSC = 0;
 
@@ -4800,16 +4799,54 @@ static void handle_edid_mgmt(struct amdgpu_dm_connector *aconnector)
 	create_eml_sink(aconnector);
 }
 
+static struct dc_stream_state *
+create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
+				const struct drm_display_mode *drm_mode,
+				const struct dm_connector_state *dm_state,
+				const struct dc_stream_state *old_stream)
+{
+	struct drm_connector *connector = &aconnector->base;
+	struct amdgpu_device *adev = connector->dev->dev_private;
+	struct dc_stream_state *stream;
+	int requested_bpc = connector->state ? connector->state->max_requested_bpc : 8;
+	enum dc_status dc_result = DC_OK;
+
+	do {
+		stream = create_stream_for_sink(aconnector, drm_mode,
+						dm_state, old_stream,
+						requested_bpc);
+		if (stream == NULL) {
+			DRM_ERROR("Failed to create stream for sink!\n");
+			break;
+		}
+
+		dc_result = dc_validate_stream(adev->dm.dc, stream);
+
+		if (dc_result != DC_OK) {
+			DRM_DEBUG_KMS("Mode %dx%d (clk %d) failed DC validation with error %d\n",
+				      drm_mode->hdisplay,
+				      drm_mode->vdisplay,
+				      drm_mode->clock,
+				      dc_result);
+
+			dc_stream_release(stream);
+			stream = NULL;
+			requested_bpc -= 2; /* lower bpc to retry validation */
+		}
+
+	} while (stream == NULL && requested_bpc >= 6);
+
+	return stream;
+}
+
 enum drm_mode_status amdgpu_dm_connector_mode_valid(struct drm_connector *connector,
 				   struct drm_display_mode *mode)
 {
 	int result = MODE_ERROR;
 	struct dc_sink *dc_sink;
-	struct amdgpu_device *adev = connector->dev->dev_private;
 	/* TODO: Unhardcode stream count */
 	struct dc_stream_state *stream;
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
-	enum dc_status dc_result = DC_OK;
 
 	if ((mode->flags & DRM_MODE_FLAG_INTERLACE) ||
 			(mode->flags & DRM_MODE_FLAG_DBLSCAN))
@@ -4830,24 +4867,11 @@ enum drm_mode_status amdgpu_dm_connector_mode_valid(struct drm_connector *connec
 		goto fail;
 	}
 
-	stream = create_stream_for_sink(aconnector, mode, NULL, NULL);
-	if (stream == NULL) {
-		DRM_ERROR("Failed to create stream for sink!\n");
-		goto fail;
-	}
-
-	dc_result = dc_validate_stream(adev->dm.dc, stream);
-
-	if (dc_result == DC_OK)
+	stream = create_validate_stream_for_sink(aconnector, mode, NULL, NULL);
+	if (stream) {
+		dc_stream_release(stream);
 		result = MODE_OK;
-	else
-		DRM_DEBUG_KMS("Mode %dx%d (clk %d) failed DC validation with error %d\n",
-			      mode->hdisplay,
-			      mode->vdisplay,
-			      mode->clock,
-			      dc_result);
-
-	dc_stream_release(stream);
+	}
 
 fail:
 	/* TODO: error handling*/
@@ -5170,10 +5194,12 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 		return 0;
 
 	if (!state->duplicated) {
+		int max_bpc = conn_state->max_requested_bpc;
 		is_y420 = drm_mode_is_420_also(&connector->display_info, adjusted_mode) &&
 				aconnector->force_yuv420_output;
-		color_depth = convert_color_depth_from_display_info(connector, conn_state,
-								    is_y420);
+		color_depth = convert_color_depth_from_display_info(connector,
+								    is_y420,
+								    max_bpc);
 		bpp = convert_dc_color_depth_into_bpc(color_depth) * 3;
 		clock = adjusted_mode->clock;
 		dm_new_connector_state->pbn = drm_dp_calc_pbn_mode(clock, bpp, false);
@@ -7589,10 +7615,10 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state))
 			goto skip_modeset;
 
-		new_stream = create_stream_for_sink(aconnector,
-						     &new_crtc_state->mode,
-						    dm_new_conn_state,
-						    dm_old_crtc_state->stream);
+		new_stream = create_validate_stream_for_sink(aconnector,
+							     &new_crtc_state->mode,
+							     dm_new_conn_state,
+							     dm_old_crtc_state->stream);
 
 		/*
 		 * we can have no stream on ACTION_SET if a display
-- 
2.25.1



