Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440194051C7
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353403AbhIIMif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352575AbhIIMdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DA961360;
        Thu,  9 Sep 2021 11:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188405;
        bh=1U7V6Bj9L8VOn+hJXISyjw7MmPlFXuWObey8GMQ2gtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZljmpWJC2srX3gRIQUQkyysfGTknMZcvymEoYBDqqz9awBLfnT5VSF3X6330uJEj
         W4OTFkTf2Fmyio+E032XWdMgyfHSqWOger3/ue549Nt/Zp3Q0r5OZiQ6dQhfiecIij
         WOzk4MDfTrgX3hq4KgokNuVjGyyH9BQzhjctXKEBwzx88A5n1UH05X6GWBu5munxM0
         DHcpEul2ZWBuTjTbZXLY7Br3HTnLY5LtukfJYH34gSEaiFc9/JL3ERchQos4UTfKKm
         Z5NBoYm9o4vWHcIvlEtnhGTIL2XQTszBawWYzHbFhC33lnVnE9wtQbqGB1APwCDEdd
         uMyae/6VHmw7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roy Chan <roy.chan@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 098/176] drm/amd/display: fix incorrect CM/TF programming sequence in dwb
Date:   Thu,  9 Sep 2021 07:50:00 -0400
Message-Id: <20210909115118.146181-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 8593145379d9..6d621f07be48 100644
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

