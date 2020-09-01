Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD91425970B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgIAQJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgIAPie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453C52158C;
        Tue,  1 Sep 2020 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974712;
        bh=LT6/A+nPBaAd4DwepDhQ8PDFT1ywFHpwou5Q3H0lWhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujlI+WsTnblxXDcPY3acPuStSN8sOFNftI8em77ug6GiAC+aJN7NZ6E0ShEG550Ph
         wXdUsaWWMIl+lWwq22kgKICSB/ECqloKBqUW/FO4YF+8gOfHy2kZM+bSLnYKZcBWzJ
         RHui7nEeYizppORExhd1rqb9GKhPHUztdmSFGO8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lewis Huang <Lewis.Huang@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 066/255] drm/amd/display: change global buffer to local buffer
Date:   Tue,  1 Sep 2020 17:08:42 +0200
Message-Id: <20200901151003.893400403@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lewis Huang <Lewis.Huang@amd.com>

[ Upstream commit 8ae5b155928c9183c2f37b5c4eec21037d958699 ]

[Why]
Multi-adapter calculate regamma table at the same time.
Two thread used the same global variable cause race
condition.

[How]
Change global buffer to local buffer

Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_color.c   |  10 +-
 .../drm/amd/display/modules/color/Makefile    |   4 +
 .../amd/display/modules/color/color_gamma.c   | 115 ++++++++++--------
 .../amd/display/modules/color/color_gamma.h   |  18 ++-
 .../amd/display/modules/color/color_table.c   |  48 ++++++++
 .../amd/display/modules/color/color_table.h   |  47 +++++++
 6 files changed, 183 insertions(+), 59 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/display/modules/color/color_table.c
 create mode 100644 drivers/gpu/drm/amd/display/modules/color/color_table.h

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index 4dfb6b55bb2ed..b321ff654df42 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -195,10 +195,13 @@ static int __set_legacy_tf(struct dc_transfer_func *func,
 			   bool has_rom)
 {
 	struct dc_gamma *gamma = NULL;
+	struct calculate_buffer cal_buffer = {0};
 	bool res;
 
 	ASSERT(lut && lut_size == MAX_COLOR_LEGACY_LUT_ENTRIES);
 
+	cal_buffer.buffer_index = -1;
+
 	gamma = dc_create_gamma();
 	if (!gamma)
 		return -ENOMEM;
@@ -208,7 +211,7 @@ static int __set_legacy_tf(struct dc_transfer_func *func,
 	__drm_lut_to_dc_gamma(lut, gamma, true);
 
 	res = mod_color_calculate_regamma_params(func, gamma, true, has_rom,
-						 NULL);
+						 NULL, &cal_buffer);
 
 	dc_gamma_release(&gamma);
 
@@ -221,10 +224,13 @@ static int __set_output_tf(struct dc_transfer_func *func,
 			   bool has_rom)
 {
 	struct dc_gamma *gamma = NULL;
+	struct calculate_buffer cal_buffer = {0};
 	bool res;
 
 	ASSERT(lut && lut_size == MAX_COLOR_LUT_ENTRIES);
 
+	cal_buffer.buffer_index = -1;
+
 	gamma = dc_create_gamma();
 	if (!gamma)
 		return -ENOMEM;
@@ -248,7 +254,7 @@ static int __set_output_tf(struct dc_transfer_func *func,
 		 */
 		gamma->type = GAMMA_CS_TFM_1D;
 		res = mod_color_calculate_regamma_params(func, gamma, false,
-							 has_rom, NULL);
+							 has_rom, NULL, &cal_buffer);
 	}
 
 	dc_gamma_release(&gamma);
diff --git a/drivers/gpu/drm/amd/display/modules/color/Makefile b/drivers/gpu/drm/amd/display/modules/color/Makefile
index 65c33a76951a4..3ee7f27ff93b9 100644
--- a/drivers/gpu/drm/amd/display/modules/color/Makefile
+++ b/drivers/gpu/drm/amd/display/modules/color/Makefile
@@ -25,6 +25,10 @@
 
 MOD_COLOR = color_gamma.o
 
+ifdef CONFIG_DRM_AMD_DC_DCN
+MOD_COLOR += color_table.o
+endif
+
 AMD_DAL_MOD_COLOR = $(addprefix $(AMDDALPATH)/modules/color/,$(MOD_COLOR))
 #$(info ************  DAL COLOR MODULE MAKEFILE ************)
 
diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index bcfe34ef8c28d..b8695660b480e 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -30,20 +30,10 @@
 #include "opp.h"
 #include "color_gamma.h"
 
-#define NUM_PTS_IN_REGION 16
-#define NUM_REGIONS 32
-#define MAX_HW_POINTS (NUM_PTS_IN_REGION*NUM_REGIONS)
-
 static struct hw_x_point coordinates_x[MAX_HW_POINTS + 2];
 
-static struct fixed31_32 pq_table[MAX_HW_POINTS + 2];
-static struct fixed31_32 de_pq_table[MAX_HW_POINTS + 2];
-
 // these are helpers for calculations to reduce stack usage
 // do not depend on these being preserved across calls
-static struct fixed31_32 scratch_1;
-static struct fixed31_32 scratch_2;
-static struct translate_from_linear_space_args scratch_gamma_args;
 
 /* Helper to optimize gamma calculation, only use in translate_from_linear, in
  * particular the dc_fixpt_pow function which is very expensive
@@ -56,9 +46,6 @@ static struct translate_from_linear_space_args scratch_gamma_args;
  * just multiply with 2^gamma which can be computed once, and save the result so we
  * recursively compute all the values.
  */
-static struct fixed31_32 pow_buffer[NUM_PTS_IN_REGION];
-static struct fixed31_32 gamma_of_2; // 2^gamma
-int pow_buffer_ptr = -1;
 										/*sRGB	 709 2.2 2.4 P3*/
 static const int32_t gamma_numerator01[] = { 31308,	180000,	0,	0,	0};
 static const int32_t gamma_numerator02[] = { 12920,	4500,	0,	0,	0};
@@ -66,9 +53,6 @@ static const int32_t gamma_numerator03[] = { 55,	99,		0,	0,	0};
 static const int32_t gamma_numerator04[] = { 55,	99,		0,	0,	0};
 static const int32_t gamma_numerator05[] = { 2400,	2200,	2200, 2400, 2600};
 
-static bool pq_initialized; /* = false; */
-static bool de_pq_initialized; /* = false; */
-
 /* one-time setup of X points */
 void setup_x_points_distribution(void)
 {
@@ -250,6 +234,8 @@ void precompute_pq(void)
 	struct fixed31_32 scaling_factor =
 			dc_fixpt_from_fraction(80, 10000);
 
+	struct fixed31_32 *pq_table = mod_color_get_table(type_pq_table);
+
 	/* pow function has problems with arguments too small */
 	for (i = 0; i < 32; i++)
 		pq_table[i] = dc_fixpt_zero;
@@ -269,7 +255,7 @@ void precompute_de_pq(void)
 	uint32_t begin_index, end_index;
 
 	struct fixed31_32 scaling_factor = dc_fixpt_from_int(125);
-
+	struct fixed31_32 *de_pq_table = mod_color_get_table(type_de_pq_table);
 	/* X points is 2^-25 to 2^7
 	 * De-gamma X is 2^-12 to 2^0 – we are skipping first -12-(-25) = 13 regions
 	 */
@@ -339,6 +325,9 @@ static struct fixed31_32 translate_from_linear_space(
 {
 	const struct fixed31_32 one = dc_fixpt_from_int(1);
 
+	struct fixed31_32 scratch_1, scratch_2;
+	struct calculate_buffer *cal_buffer = args->cal_buffer;
+
 	if (dc_fixpt_le(one, args->arg))
 		return one;
 
@@ -352,21 +341,21 @@ static struct fixed31_32 translate_from_linear_space(
 
 		return scratch_1;
 	} else if (dc_fixpt_le(args->a0, args->arg)) {
-		if (pow_buffer_ptr == 0) {
-			gamma_of_2 = dc_fixpt_pow(dc_fixpt_from_int(2),
+		if (cal_buffer->buffer_index == 0) {
+			cal_buffer->gamma_of_2 = dc_fixpt_pow(dc_fixpt_from_int(2),
 					dc_fixpt_recip(args->gamma));
 		}
 		scratch_1 = dc_fixpt_add(one, args->a3);
-		if (pow_buffer_ptr < 16)
+		if (cal_buffer->buffer_index < 16)
 			scratch_2 = dc_fixpt_pow(args->arg,
 					dc_fixpt_recip(args->gamma));
 		else
-			scratch_2 = dc_fixpt_mul(gamma_of_2,
-					pow_buffer[pow_buffer_ptr%16]);
+			scratch_2 = dc_fixpt_mul(cal_buffer->gamma_of_2,
+					cal_buffer->buffer[cal_buffer->buffer_index%16]);
 
-		if (pow_buffer_ptr != -1) {
-			pow_buffer[pow_buffer_ptr%16] = scratch_2;
-			pow_buffer_ptr++;
+		if (cal_buffer->buffer_index != -1) {
+			cal_buffer->buffer[cal_buffer->buffer_index%16] = scratch_2;
+			cal_buffer->buffer_index++;
 		}
 
 		scratch_1 = dc_fixpt_mul(scratch_1, scratch_2);
@@ -413,15 +402,17 @@ static struct fixed31_32 translate_from_linear_space_long(
 			args->a1);
 }
 
-static struct fixed31_32 calculate_gamma22(struct fixed31_32 arg, bool use_eetf)
+static struct fixed31_32 calculate_gamma22(struct fixed31_32 arg, bool use_eetf, struct calculate_buffer *cal_buffer)
 {
 	struct fixed31_32 gamma = dc_fixpt_from_fraction(22, 10);
+	struct translate_from_linear_space_args scratch_gamma_args;
 
 	scratch_gamma_args.arg = arg;
 	scratch_gamma_args.a0 = dc_fixpt_zero;
 	scratch_gamma_args.a1 = dc_fixpt_zero;
 	scratch_gamma_args.a2 = dc_fixpt_zero;
 	scratch_gamma_args.a3 = dc_fixpt_zero;
+	scratch_gamma_args.cal_buffer = cal_buffer;
 	scratch_gamma_args.gamma = gamma;
 
 	if (use_eetf)
@@ -467,14 +458,18 @@ static struct fixed31_32 translate_to_linear_space(
 static struct fixed31_32 translate_from_linear_space_ex(
 	struct fixed31_32 arg,
 	struct gamma_coefficients *coeff,
-	uint32_t color_index)
+	uint32_t color_index,
+	struct calculate_buffer *cal_buffer)
 {
+	struct translate_from_linear_space_args scratch_gamma_args;
+
 	scratch_gamma_args.arg = arg;
 	scratch_gamma_args.a0 = coeff->a0[color_index];
 	scratch_gamma_args.a1 = coeff->a1[color_index];
 	scratch_gamma_args.a2 = coeff->a2[color_index];
 	scratch_gamma_args.a3 = coeff->a3[color_index];
 	scratch_gamma_args.gamma = coeff->user_gamma[color_index];
+	scratch_gamma_args.cal_buffer = cal_buffer;
 
 	return translate_from_linear_space(&scratch_gamma_args);
 }
@@ -742,10 +737,11 @@ static void build_pq(struct pwl_float_data_ex *rgb_regamma,
 	struct fixed31_32 output;
 	struct fixed31_32 scaling_factor =
 			dc_fixpt_from_fraction(sdr_white_level, 10000);
+	struct fixed31_32 *pq_table = mod_color_get_table(type_pq_table);
 
-	if (!pq_initialized && sdr_white_level == 80) {
+	if (!mod_color_is_table_init(type_pq_table) && sdr_white_level == 80) {
 		precompute_pq();
-		pq_initialized = true;
+		mod_color_set_table_init_state(type_pq_table, true);
 	}
 
 	/* TODO: start index is from segment 2^-24, skipping first segment
@@ -787,12 +783,12 @@ static void build_de_pq(struct pwl_float_data_ex *de_pq,
 {
 	uint32_t i;
 	struct fixed31_32 output;
-
+	struct fixed31_32 *de_pq_table = mod_color_get_table(type_de_pq_table);
 	struct fixed31_32 scaling_factor = dc_fixpt_from_int(125);
 
-	if (!de_pq_initialized) {
+	if (!mod_color_is_table_init(type_de_pq_table)) {
 		precompute_de_pq();
-		de_pq_initialized = true;
+		mod_color_set_table_init_state(type_de_pq_table, true);
 	}
 
 
@@ -811,7 +807,9 @@ static void build_de_pq(struct pwl_float_data_ex *de_pq,
 
 static bool build_regamma(struct pwl_float_data_ex *rgb_regamma,
 		uint32_t hw_points_num,
-		const struct hw_x_point *coordinate_x, enum dc_transfer_func_predefined type)
+		const struct hw_x_point *coordinate_x,
+		enum dc_transfer_func_predefined type,
+		struct calculate_buffer *cal_buffer)
 {
 	uint32_t i;
 	bool ret = false;
@@ -827,20 +825,21 @@ static bool build_regamma(struct pwl_float_data_ex *rgb_regamma,
 	if (!build_coefficients(coeff, type))
 		goto release;
 
-	memset(pow_buffer, 0, NUM_PTS_IN_REGION * sizeof(struct fixed31_32));
-	pow_buffer_ptr = 0; // see variable definition for more info
+	memset(cal_buffer->buffer, 0, NUM_PTS_IN_REGION * sizeof(struct fixed31_32));
+	cal_buffer->buffer_index = 0; // see variable definition for more info
+
 	i = 0;
 	while (i <= hw_points_num) {
 		/*TODO use y vs r,g,b*/
 		rgb->r = translate_from_linear_space_ex(
-			coord_x->x, coeff, 0);
+			coord_x->x, coeff, 0, cal_buffer);
 		rgb->g = rgb->r;
 		rgb->b = rgb->r;
 		++coord_x;
 		++rgb;
 		++i;
 	}
-	pow_buffer_ptr = -1; // reset back to no optimize
+	cal_buffer->buffer_index = -1;
 	ret = true;
 release:
 	kvfree(coeff);
@@ -932,7 +931,8 @@ static void hermite_spline_eetf(struct fixed31_32 input_x,
 static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 		uint32_t hw_points_num,
 		const struct hw_x_point *coordinate_x,
-		const struct freesync_hdr_tf_params *fs_params)
+		const struct freesync_hdr_tf_params *fs_params,
+		struct calculate_buffer *cal_buffer)
 {
 	uint32_t i;
 	struct pwl_float_data_ex *rgb = rgb_regamma;
@@ -969,7 +969,7 @@ static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 		max_content = max_display;
 
 	if (!use_eetf)
-		pow_buffer_ptr = 0; // see var definition for more info
+		cal_buffer->buffer_index = 0; // see var definition for more info
 	rgb += 32; // first 32 points have problems with fixed point, too small
 	coord_x += 32;
 	for (i = 32; i <= hw_points_num; i++) {
@@ -988,7 +988,7 @@ static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 				if (dc_fixpt_lt(scaledX, dc_fixpt_zero))
 					output = dc_fixpt_zero;
 				else
-					output = calculate_gamma22(scaledX, use_eetf);
+					output = calculate_gamma22(scaledX, use_eetf, cal_buffer);
 
 				rgb->r = output;
 				rgb->g = output;
@@ -1008,7 +1008,7 @@ static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 		++coord_x;
 		++rgb;
 	}
-	pow_buffer_ptr = -1;
+	cal_buffer->buffer_index = -1;
 
 	return true;
 }
@@ -1606,7 +1606,7 @@ static void build_new_custom_resulted_curve(
 }
 
 static void apply_degamma_for_user_regamma(struct pwl_float_data_ex *rgb_regamma,
-		uint32_t hw_points_num)
+		uint32_t hw_points_num, struct calculate_buffer *cal_buffer)
 {
 	uint32_t i;
 
@@ -1619,7 +1619,7 @@ static void apply_degamma_for_user_regamma(struct pwl_float_data_ex *rgb_regamma
 	i = 0;
 	while (i != hw_points_num + 1) {
 		rgb->r = translate_from_linear_space_ex(
-				coord_x->x, &coeff, 0);
+				coord_x->x, &coeff, 0, cal_buffer);
 		rgb->g = rgb->r;
 		rgb->b = rgb->r;
 		++coord_x;
@@ -1674,7 +1674,8 @@ static bool map_regamma_hw_to_x_user(
 #define _EXTRA_POINTS 3
 
 bool calculate_user_regamma_coeff(struct dc_transfer_func *output_tf,
-		const struct regamma_lut *regamma)
+		const struct regamma_lut *regamma,
+		struct calculate_buffer *cal_buffer)
 {
 	struct gamma_coefficients coeff;
 	const struct hw_x_point *coord_x = coordinates_x;
@@ -1706,11 +1707,11 @@ bool calculate_user_regamma_coeff(struct dc_transfer_func *output_tf,
 	}
 	while (i != MAX_HW_POINTS + 1) {
 		output_tf->tf_pts.red[i] = translate_from_linear_space_ex(
-				coord_x->x, &coeff, 0);
+				coord_x->x, &coeff, 0, cal_buffer);
 		output_tf->tf_pts.green[i] = translate_from_linear_space_ex(
-				coord_x->x, &coeff, 1);
+				coord_x->x, &coeff, 1, cal_buffer);
 		output_tf->tf_pts.blue[i] = translate_from_linear_space_ex(
-				coord_x->x, &coeff, 2);
+				coord_x->x, &coeff, 2, cal_buffer);
 		++coord_x;
 		++i;
 	}
@@ -1723,7 +1724,8 @@ bool calculate_user_regamma_coeff(struct dc_transfer_func *output_tf,
 }
 
 bool calculate_user_regamma_ramp(struct dc_transfer_func *output_tf,
-		const struct regamma_lut *regamma)
+		const struct regamma_lut *regamma,
+		struct calculate_buffer *cal_buffer)
 {
 	struct dc_transfer_func_distributed_points *tf_pts = &output_tf->tf_pts;
 	struct dividers dividers;
@@ -1756,7 +1758,7 @@ bool calculate_user_regamma_ramp(struct dc_transfer_func *output_tf,
 	scale_user_regamma_ramp(rgb_user, &regamma->ramp, dividers);
 
 	if (regamma->flags.bits.applyDegamma == 1) {
-		apply_degamma_for_user_regamma(rgb_regamma, MAX_HW_POINTS);
+		apply_degamma_for_user_regamma(rgb_regamma, MAX_HW_POINTS, cal_buffer);
 		copy_rgb_regamma_to_coordinates_x(coordinates_x,
 				MAX_HW_POINTS, rgb_regamma);
 	}
@@ -1943,7 +1945,8 @@ static bool calculate_curve(enum dc_transfer_func_predefined trans,
 				struct dc_transfer_func_distributed_points *points,
 				struct pwl_float_data_ex *rgb_regamma,
 				const struct freesync_hdr_tf_params *fs_params,
-				uint32_t sdr_ref_white_level)
+				uint32_t sdr_ref_white_level,
+				struct calculate_buffer *cal_buffer)
 {
 	uint32_t i;
 	bool ret = false;
@@ -1979,7 +1982,8 @@ static bool calculate_curve(enum dc_transfer_func_predefined trans,
 		build_freesync_hdr(rgb_regamma,
 				MAX_HW_POINTS,
 				coordinates_x,
-				fs_params);
+				fs_params,
+				cal_buffer);
 
 		ret = true;
 	} else if (trans == TRANSFER_FUNCTION_HLG) {
@@ -2008,7 +2012,8 @@ static bool calculate_curve(enum dc_transfer_func_predefined trans,
 		build_regamma(rgb_regamma,
 				MAX_HW_POINTS,
 				coordinates_x,
-				trans);
+				trans,
+				cal_buffer);
 
 		ret = true;
 	}
@@ -2018,7 +2023,8 @@ static bool calculate_curve(enum dc_transfer_func_predefined trans,
 
 bool mod_color_calculate_regamma_params(struct dc_transfer_func *output_tf,
 		const struct dc_gamma *ramp, bool mapUserRamp, bool canRomBeUsed,
-		const struct freesync_hdr_tf_params *fs_params)
+		const struct freesync_hdr_tf_params *fs_params,
+		struct calculate_buffer *cal_buffer)
 {
 	struct dc_transfer_func_distributed_points *tf_pts = &output_tf->tf_pts;
 	struct dividers dividers;
@@ -2090,7 +2096,8 @@ bool mod_color_calculate_regamma_params(struct dc_transfer_func *output_tf,
 			tf_pts,
 			rgb_regamma,
 			fs_params,
-			output_tf->sdr_ref_white_level);
+			output_tf->sdr_ref_white_level,
+			cal_buffer);
 
 	if (ret) {
 		map_regamma_hw_to_x_user(ramp, coeff, rgb_user,
diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.h b/drivers/gpu/drm/amd/display/modules/color/color_gamma.h
index 7f56226ba77a9..37ffbef6602b0 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.h
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.h
@@ -26,6 +26,8 @@
 #ifndef COLOR_MOD_COLOR_GAMMA_H_
 #define COLOR_MOD_COLOR_GAMMA_H_
 
+#include "color_table.h"
+
 struct dc_transfer_func;
 struct dc_gamma;
 struct dc_transfer_func_distributed_points;
@@ -83,6 +85,12 @@ struct freesync_hdr_tf_params {
 	unsigned int skip_tm; // skip tm
 };
 
+struct calculate_buffer {
+	int buffer_index;
+	struct fixed31_32 buffer[NUM_PTS_IN_REGION];
+	struct fixed31_32 gamma_of_2;
+};
+
 struct translate_from_linear_space_args {
 	struct fixed31_32 arg;
 	struct fixed31_32 a0;
@@ -90,6 +98,7 @@ struct translate_from_linear_space_args {
 	struct fixed31_32 a2;
 	struct fixed31_32 a3;
 	struct fixed31_32 gamma;
+	struct calculate_buffer *cal_buffer;
 };
 
 void setup_x_points_distribution(void);
@@ -99,7 +108,8 @@ void precompute_de_pq(void);
 
 bool mod_color_calculate_regamma_params(struct dc_transfer_func *output_tf,
 		const struct dc_gamma *ramp, bool mapUserRamp, bool canRomBeUsed,
-		const struct freesync_hdr_tf_params *fs_params);
+		const struct freesync_hdr_tf_params *fs_params,
+		struct calculate_buffer *cal_buffer);
 
 bool mod_color_calculate_degamma_params(struct dc_color_caps *dc_caps,
 		struct dc_transfer_func *output_tf,
@@ -109,10 +119,12 @@ bool mod_color_calculate_degamma_curve(enum dc_transfer_func_predefined trans,
 				struct dc_transfer_func_distributed_points *points);
 
 bool calculate_user_regamma_coeff(struct dc_transfer_func *output_tf,
-		const struct regamma_lut *regamma);
+		const struct regamma_lut *regamma,
+		struct calculate_buffer *cal_buffer);
 
 bool calculate_user_regamma_ramp(struct dc_transfer_func *output_tf,
-		const struct regamma_lut *regamma);
+		const struct regamma_lut *regamma,
+		struct calculate_buffer *cal_buffer);
 
 
 #endif /* COLOR_MOD_COLOR_GAMMA_H_ */
diff --git a/drivers/gpu/drm/amd/display/modules/color/color_table.c b/drivers/gpu/drm/amd/display/modules/color/color_table.c
new file mode 100644
index 0000000000000..692e536e7d057
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/modules/color/color_table.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2019 Advanced Micro Devices, Inc. (unpublished)
+ *
+ * All rights reserved.  This notice is intended as a precaution against
+ * inadvertent publication and does not imply publication or any waiver
+ * of confidentiality.  The year included in the foregoing notice is the
+ * year of creation of the work.
+ */
+
+#include "color_table.h"
+
+static struct fixed31_32 pq_table[MAX_HW_POINTS + 2];
+static struct fixed31_32 de_pq_table[MAX_HW_POINTS + 2];
+static bool pq_initialized;
+static bool de_pg_initialized;
+
+bool mod_color_is_table_init(enum table_type type)
+{
+	bool ret = false;
+
+	if (type == type_pq_table)
+		ret = pq_initialized;
+	if (type == type_de_pq_table)
+		ret = de_pg_initialized;
+
+	return ret;
+}
+
+struct fixed31_32 *mod_color_get_table(enum table_type type)
+{
+	struct fixed31_32 *table = NULL;
+
+	if (type == type_pq_table)
+		table = pq_table;
+	if (type == type_de_pq_table)
+		table = de_pq_table;
+
+	return table;
+}
+
+void mod_color_set_table_init_state(enum table_type type, bool state)
+{
+	if (type == type_pq_table)
+		pq_initialized = state;
+	if (type == type_de_pq_table)
+		de_pg_initialized = state;
+}
+
diff --git a/drivers/gpu/drm/amd/display/modules/color/color_table.h b/drivers/gpu/drm/amd/display/modules/color/color_table.h
new file mode 100644
index 0000000000000..2621dd6194027
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/modules/color/color_table.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2016 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+
+#ifndef COLOR_MOD_COLOR_TABLE_H_
+#define COLOR_MOD_COLOR_TABLE_H_
+
+#include "dc_types.h"
+
+#define NUM_PTS_IN_REGION 16
+#define NUM_REGIONS 32
+#define MAX_HW_POINTS (NUM_PTS_IN_REGION*NUM_REGIONS)
+
+enum table_type {
+	type_pq_table,
+	type_de_pq_table
+};
+
+bool mod_color_is_table_init(enum table_type type);
+
+struct fixed31_32 *mod_color_get_table(enum table_type type);
+
+void mod_color_set_table_init_state(enum table_type type, bool state);
+
+#endif /* COLOR_MOD_COLOR_TABLE_H_ */
-- 
2.25.1



