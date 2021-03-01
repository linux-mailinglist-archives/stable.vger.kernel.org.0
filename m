Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFF8328AC4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhCASWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239534AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1FF651A3;
        Mon,  1 Mar 2021 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618704;
        bh=/951M1uEq+FxX2OMX/prgfD6J6WheVGhjYktz+CcEzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT1w4ISEigR25jrUGCkudIWgu465qhEHgXG1DWtbz+FpgxHgEOUBBbD0p4vPmCJYy
         20dfHZkAsZuFID9fNqi+PkBUXmHRukhFX7vUmxfzDKZwDxL9v9gsgsLmkA8Jz/zwpk
         Fe4UWyJjqmlSCS+T1q77PPLaXRDcNCfzA47N0iZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/663] drm/amd/display: Fix HDMI deep color output for DCE 6-11.
Date:   Mon,  1 Mar 2021 17:07:14 +0100
Message-Id: <20210301161150.982679182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit efa18405baa55a864c61d2f3cc6fe4d363818eb3 ]

This fixes corrupted display output in HDMI deep color
10/12 bpc mode at least as observed on AMD Mullins, DCE-8.3.

It will hopefully also provide fixes for other DCE's up to
DCE-11, assuming those will need similar fixes, but i could
not test that for HDMI due to lack of suitable hw, so viewer
discretion is advised.

dce110_stream_encoder_hdmi_set_stream_attribute() is used for
HDMI setup on all DCE's and is missing color_depth assignment.

dce110_program_pix_clk() is used for pixel clock setup on HDMI
for DCE 6-11, and is missing color_depth assignment.

Additionally some of the underlying Atombios specific encoder
and pixelclock setup functions are missing code which is in
the classic amdgpu kms modesetting path and the in the radeon
kms driver for DCE6/DCE8.

encoder_control_digx_v3() - Was missing setup code wrt. amdgpu
and radeon kms classic drivers. Added here, but untested due to
lack of suitable test hw.

encoder_control_digx_v4() - Added missing setup code.
Successfully tested on AMD mullins / DCE-8.3 with HDMI deep color
output at 10 bpc and 12 bpc.

Note that encoder_control_digx_v5() has proper setup code in place
and is used, e.g., by DCE-11.2, but this code wasn't used for deep
color setup due to the missing cntl.color_depth setup in the calling
function for HDMI.

set_pixel_clock_v5() - Missing setup code wrt. classic amdgpu/radeon
kms. Added here, but untested due to lack of hw.

set_pixel_clock_v6() - Missing setup code added. Successfully tested
on AMD mullins DCE-8.3. This fixes corrupted display output at HDMI
deep color output with 10 bpc or 12 bpc.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/bios/command_table.c   | 61 +++++++++++++++++++
 .../drm/amd/display/dc/dce/dce_clock_source.c | 14 +++++
 .../amd/display/dc/dce/dce_stream_encoder.c   |  1 +
 3 files changed, 76 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/command_table.c b/drivers/gpu/drm/amd/display/dc/bios/command_table.c
index 070459e3e4070..afc10b954ffa7 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/command_table.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/command_table.c
@@ -245,6 +245,23 @@ static enum bp_result encoder_control_digx_v3(
 					cntl->enable_dp_audio);
 	params.ucLaneNum = (uint8_t)(cntl->lanes_number);
 
+	switch (cntl->color_depth) {
+	case COLOR_DEPTH_888:
+		params.ucBitPerColor = PANEL_8BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_101010:
+		params.ucBitPerColor = PANEL_10BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_121212:
+		params.ucBitPerColor = PANEL_12BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_161616:
+		params.ucBitPerColor = PANEL_16BIT_PER_COLOR;
+		break;
+	default:
+		break;
+	}
+
 	if (EXEC_BIOS_CMD_TABLE(DIGxEncoderControl, params))
 		result = BP_RESULT_OK;
 
@@ -274,6 +291,23 @@ static enum bp_result encoder_control_digx_v4(
 					cntl->enable_dp_audio));
 	params.ucLaneNum = (uint8_t)(cntl->lanes_number);
 
+	switch (cntl->color_depth) {
+	case COLOR_DEPTH_888:
+		params.ucBitPerColor = PANEL_8BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_101010:
+		params.ucBitPerColor = PANEL_10BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_121212:
+		params.ucBitPerColor = PANEL_12BIT_PER_COLOR;
+		break;
+	case COLOR_DEPTH_161616:
+		params.ucBitPerColor = PANEL_16BIT_PER_COLOR;
+		break;
+	default:
+		break;
+	}
+
 	if (EXEC_BIOS_CMD_TABLE(DIGxEncoderControl, params))
 		result = BP_RESULT_OK;
 
@@ -1057,6 +1091,19 @@ static enum bp_result set_pixel_clock_v5(
 		 * driver choose program it itself, i.e. here we program it
 		 * to 888 by default.
 		 */
+		if (bp_params->signal_type == SIGNAL_TYPE_HDMI_TYPE_A)
+			switch (bp_params->color_depth) {
+			case TRANSMITTER_COLOR_DEPTH_30:
+				/* yes this is correct, the atom define is wrong */
+				clk.sPCLKInput.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_32BPP;
+				break;
+			case TRANSMITTER_COLOR_DEPTH_36:
+				/* yes this is correct, the atom define is wrong */
+				clk.sPCLKInput.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_30BPP;
+				break;
+			default:
+				break;
+			}
 
 		if (EXEC_BIOS_CMD_TABLE(SetPixelClock, clk))
 			result = BP_RESULT_OK;
@@ -1135,6 +1182,20 @@ static enum bp_result set_pixel_clock_v6(
 		 * driver choose program it itself, i.e. here we pass required
 		 * target rate that includes deep color.
 		 */
+		if (bp_params->signal_type == SIGNAL_TYPE_HDMI_TYPE_A)
+			switch (bp_params->color_depth) {
+			case TRANSMITTER_COLOR_DEPTH_30:
+				clk.sPCLKInput.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_30BPP_V6;
+				break;
+			case TRANSMITTER_COLOR_DEPTH_36:
+				clk.sPCLKInput.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_36BPP_V6;
+				break;
+			case TRANSMITTER_COLOR_DEPTH_48:
+				clk.sPCLKInput.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_48BPP;
+				break;
+			default:
+				break;
+			}
 
 		if (EXEC_BIOS_CMD_TABLE(SetPixelClock, clk))
 			result = BP_RESULT_OK;
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 49ae5ff12da63..bae3a146b2cc2 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -871,6 +871,20 @@ static bool dce110_program_pix_clk(
 	bp_pc_params.flags.SET_EXTERNAL_REF_DIV_SRC =
 					pll_settings->use_external_clk;
 
+	switch (pix_clk_params->color_depth) {
+	case COLOR_DEPTH_101010:
+		bp_pc_params.color_depth = TRANSMITTER_COLOR_DEPTH_30;
+		break;
+	case COLOR_DEPTH_121212:
+		bp_pc_params.color_depth = TRANSMITTER_COLOR_DEPTH_36;
+		break;
+	case COLOR_DEPTH_161616:
+		bp_pc_params.color_depth = TRANSMITTER_COLOR_DEPTH_48;
+		break;
+	default:
+		break;
+	}
+
 	if (clk_src->bios->funcs->set_pixel_clock(
 			clk_src->bios, &bp_pc_params) != BP_RESULT_OK)
 		return false;
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
index 5054bb567b748..99ad475fc1ff5 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
@@ -564,6 +564,7 @@ static void dce110_stream_encoder_hdmi_set_stream_attribute(
 	cntl.enable_dp_audio = enable_audio;
 	cntl.pixel_clock = actual_pix_clk_khz;
 	cntl.lanes_number = LANE_COUNT_FOUR;
+	cntl.color_depth = crtc_timing->display_color_depth;
 
 	if (enc110->base.bp->funcs->encoder_control(
 			enc110->base.bp, &cntl) != BP_RESULT_OK)
-- 
2.27.0



