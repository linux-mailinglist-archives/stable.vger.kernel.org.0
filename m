Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB5404F16
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbhIIMQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350875AbhIIMOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2BA61A40;
        Thu,  9 Sep 2021 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188150;
        bh=Ex0gHPSByP8khE8zUY284+5N1Sxj04zJgqDxhSWF0f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXwW/mAJFlNGeRJ+yjKnE7uqlgjSzFkWRHuaQnd3P0nVauF4Xbc0v+7VnvpabAgAD
         oE2ccVZI410R+sRmQkpuKWzDiz5GgxdY1tC1xXdNLyanHlQHpmv9PpjA5CHjzBII11
         eW51Hb/DWa95BCa/qm+6UyuRi4ZOcdCeEBkCDEumu5ek+lBK88h5gvH9Pa6aDlneb2
         ltivt59P4eM+F5vikTUPT+vk0Ut2spmnecLM7eyYLlWvx4A45fpyGC/4aPbfcJidNL
         mUiJG+Dt7cEzS8/NQomMSIC9vkouc4e1RyaKtw/vqKeuGbACj4rLrCJbK7unXOFkf1
         HDhVIfBsERmyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roy Chan <roy.chan@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 119/219] drm/amd/display: fix incorrect CM/TF programming sequence in dwb
Date:   Thu,  9 Sep 2021 07:44:55 -0400
Message-Id: <20210909114635.143983-119-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roy Chan <roy.chan@amd.com>

[ Upstream commit 781e1e23131cce56fb557e6ec2260480a6bd08cc ]

[How]
the programming sequeune was for old asic.
the correct programming sequeunce should be similar to the one
used in mpc. the fix is copied from the mpc programming sequeunce.

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Roy Chan <roy.chan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn30/dcn30_dwb_cm.c   | 90 +++++++++++++------
 1 file changed, 64 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
index 3fe9e41e4dbd..6a3d3a0ec0a3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -49,6 +49,11 @@
 static void dwb3_get_reg_field_ogam(struct dcn30_dwbc *dwbc30,
 	struct dcn3_xfer_func_reg *reg)
 {
+	reg->shifts.field_region_start_base = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_BASE_B;
+	reg->masks.field_region_start_base = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_BASE_B;
+	reg->shifts.field_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_OFFSET_B;
+	reg->masks.field_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_OFFSET_B;
+
 	reg->shifts.exp_region0_lut_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION0_LUT_OFFSET;
 	reg->masks.exp_region0_lut_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION0_LUT_OFFSET;
 	reg->shifts.exp_region0_num_segments = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION0_NUM_SEGMENTS;
@@ -66,8 +71,6 @@ static void dwb3_get_reg_field_ogam(struct dcn30_dwbc *dwbc30,
 	reg->masks.field_region_end_base = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_END_BASE_B;
 	reg->shifts.field_region_linear_slope = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_SLOPE_B;
 	reg->masks.field_region_linear_slope = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_SLOPE_B;
-	reg->masks.field_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_OFFSET_B;
-	reg->shifts.field_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_OFFSET_B;
 	reg->shifts.exp_region_start = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_B;
 	reg->masks.exp_region_start = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_B;
 	reg->shifts.exp_resion_start_segment = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_SEGMENT_B;
@@ -147,18 +150,19 @@ static enum dc_lut_mode dwb3_get_ogam_current(
 	uint32_t state_mode;
 	uint32_t ram_select;
 
-	REG_GET(DWB_OGAM_CONTROL,
-		DWB_OGAM_MODE, &state_mode);
-	REG_GET(DWB_OGAM_CONTROL,
-		DWB_OGAM_SELECT, &ram_select);
+	REG_GET_2(DWB_OGAM_CONTROL,
+		DWB_OGAM_MODE_CURRENT, &state_mode,
+		DWB_OGAM_SELECT_CURRENT, &ram_select);
 
 	if (state_mode == 0) {
 		mode = LUT_BYPASS;
 	} else if (state_mode == 2) {
 		if (ram_select == 0)
 			mode = LUT_RAM_A;
-		else
+		else if (ram_select == 1)
 			mode = LUT_RAM_B;
+		else
+			mode = LUT_BYPASS;
 	} else {
 		// Reserved value
 		mode = LUT_BYPASS;
@@ -172,10 +176,10 @@ static void dwb3_configure_ogam_lut(
 	struct dcn30_dwbc *dwbc30,
 	bool is_ram_a)
 {
-	REG_UPDATE(DWB_OGAM_LUT_CONTROL,
-		DWB_OGAM_LUT_READ_COLOR_SEL, 7);
-	REG_UPDATE(DWB_OGAM_CONTROL,
-		DWB_OGAM_SELECT, is_ram_a == true ? 0 : 1);
+	REG_UPDATE_2(DWB_OGAM_LUT_CONTROL,
+		DWB_OGAM_LUT_WRITE_COLOR_MASK, 7,
+		DWB_OGAM_LUT_HOST_SEL, (is_ram_a == true) ? 0 : 1);
+
 	REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
 }
 
@@ -185,17 +189,45 @@ static void dwb3_program_ogam_pwl(struct dcn30_dwbc *dwbc30,
 {
 	uint32_t i;
 
-    // triple base implementation
-	for (i = 0; i < num/2; i++) {
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].blue_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].blue_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].blue_reg);
+	uint32_t last_base_value_red = rgb[num-1].red_reg + rgb[num-1].delta_red_reg;
+	uint32_t last_base_value_green = rgb[num-1].green_reg + rgb[num-1].delta_green_reg;
+	uint32_t last_base_value_blue = rgb[num-1].blue_reg + rgb[num-1].delta_blue_reg;
+
+	if (is_rgb_equal(rgb,  num)) {
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].red_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_red);
+
+	} else {
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 4);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].red_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_red);
+
+		REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 2);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].green_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_green);
+
+		REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 1);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].blue_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_blue);
 	}
 }
 
@@ -211,6 +243,8 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
+	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
+
 	current_mode = dwb3_get_ogam_current(dwbc30);
 	if (current_mode == LUT_BYPASS || current_mode == LUT_RAM_A)
 		next_mode = LUT_RAM_B;
@@ -227,8 +261,7 @@ static bool dwb3_program_ogam_lut(
 	dwb3_program_ogam_pwl(
 		dwbc30, params->rgb_resulted, params->hw_points_num);
 
-	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
-	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_SELECT, next_mode == LUT_RAM_A ? 0 : 1);
+	REG_UPDATE(DWB_OGAM_CONTROL, DWB_OGAM_SELECT, next_mode == LUT_RAM_A ? 0 : 1);
 
 	return true;
 }
@@ -271,14 +304,19 @@ static void dwb3_program_gamut_remap(
 
 	struct color_matrices_reg gam_regs;
 
-	REG_UPDATE(DWB_GAMUT_REMAP_COEF_FORMAT, DWB_GAMUT_REMAP_COEF_FORMAT, coef_format);
-
 	if (regval == NULL || select == CM_GAMUT_REMAP_MODE_BYPASS) {
 		REG_SET(DWB_GAMUT_REMAP_MODE, 0,
 				DWB_GAMUT_REMAP_MODE, 0);
 		return;
 	}
 
+	REG_UPDATE(DWB_GAMUT_REMAP_COEF_FORMAT, DWB_GAMUT_REMAP_COEF_FORMAT, coef_format);
+
+	gam_regs.shifts.csc_c11 = dwbc30->dwbc_shift->DWB_GAMUT_REMAPA_C11;
+	gam_regs.masks.csc_c11  = dwbc30->dwbc_mask->DWB_GAMUT_REMAPA_C11;
+	gam_regs.shifts.csc_c12 = dwbc30->dwbc_shift->DWB_GAMUT_REMAPA_C12;
+	gam_regs.masks.csc_c12 = dwbc30->dwbc_mask->DWB_GAMUT_REMAPA_C12;
+
 	switch (select) {
 	case CM_GAMUT_REMAP_MODE_RAMA_COEFF:
 		gam_regs.csc_c11_c12 = REG(DWB_GAMUT_REMAPA_C11_C12);
-- 
2.30.2

