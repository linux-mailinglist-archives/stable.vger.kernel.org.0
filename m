Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA14112C7AA
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbfL2RpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730844AbfL2RpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB64B206A4;
        Sun, 29 Dec 2019 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641516;
        bh=IJKVOE9RE3UOW/6j1AdWXpcYL0jXvE+Qz2W38zLtu9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T36e7WO3cvVb/DvKb2PtwDEn75iLbakAIzWJsd9Bmt26THJaMqynRe6H2gJq+DWUs
         zgCFqxNbLKNmeOFdn8h1nnjDi/AOb2exf0AQBvfnLVRaFaq1bR5KV2JIR0rZLM1BL0
         9ePHw2fOzzp7MlBT6Ip0f03/ZzQdvlOwdLT5/sCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/434] drm/amd/display: set minimum abm backlight level
Date:   Sun, 29 Dec 2019 18:22:30 +0100
Message-Id: <20191229172708.029124448@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit 2ad0cdf9e2e9e079af34af681863fa638f2ee212 ]

[Why]
A lot of the time, the backlight characteristic curve maps min backlight
to a non-zero value.
But there are cases where we want the curve to intersect at 0.
In this scenario even if OS never asks to set 0% backlight, the ABM
reduction can result in backlight being lowered close to 0.
This particularly can cause problems in some LED drivers, and in
general just looks like backlight is completely off.

[How]
Add default cap to disallow backlight from dropping below 1%
even after ABM reduction is applied.

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  5 ++
 .../amd/display/modules/power/power_helpers.c | 77 +++++++++++--------
 .../amd/display/modules/power/power_helpers.h |  1 +
 3 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4139f129eafb..4e9c15c409ba 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -940,6 +940,11 @@ static int dm_late_init(void *handle)
 	params.backlight_lut_array_size = 16;
 	params.backlight_lut_array = linear_lut;
 
+	/* Min backlight level after ABM reduction,  Don't allow below 1%
+	 * 0xFFFF x 0.01 = 0x28F
+	 */
+	params.min_abm_backlight = 0x28F;
+
 	/* todo will enable for navi10 */
 	if (adev->asic_type <= CHIP_RAVEN) {
 		ret = dmcu_load_iram(dmcu, params);
diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
index 05e2be856037..ba1aafe40512 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -115,7 +115,7 @@ static const struct abm_parameters * const abm_settings[] = {
 /* NOTE: iRAM is 256B in size */
 struct iram_table_v_2 {
 	/* flags                      */
-	uint16_t flags;							/* 0x00 U16  */
+	uint16_t min_abm_backlight;					/* 0x00 U16  */
 
 	/* parameters for ABM2.0 algorithm */
 	uint8_t min_reduction[NUM_AMBI_LEVEL][NUM_AGGR_LEVEL];		/* 0x02 U0.8 */
@@ -140,10 +140,10 @@ struct iram_table_v_2 {
 
 	/* For reading PSR State directly from IRAM */
 	uint8_t psr_state;						/* 0xf0       */
-	uint8_t dmcu_mcp_interface_version;							/* 0xf1       */
-	uint8_t dmcu_abm_feature_version;							/* 0xf2       */
-	uint8_t dmcu_psr_feature_version;							/* 0xf3       */
-	uint16_t dmcu_version;										/* 0xf4       */
+	uint8_t dmcu_mcp_interface_version;				/* 0xf1       */
+	uint8_t dmcu_abm_feature_version;				/* 0xf2       */
+	uint8_t dmcu_psr_feature_version;				/* 0xf3       */
+	uint16_t dmcu_version;						/* 0xf4       */
 	uint8_t dmcu_state;						/* 0xf6       */
 
 	uint16_t blRampReduction;					/* 0xf7       */
@@ -164,42 +164,43 @@ struct iram_table_v_2_2 {
 	uint8_t max_reduction[NUM_AMBI_LEVEL][NUM_AGGR_LEVEL];		/* 0x16 U0.8 */
 	uint8_t bright_pos_gain[NUM_AMBI_LEVEL][NUM_AGGR_LEVEL];	/* 0x2a U2.6 */
 	uint8_t dark_pos_gain[NUM_AMBI_LEVEL][NUM_AGGR_LEVEL];		/* 0x3e U2.6 */
-	uint8_t hybrid_factor[NUM_AGGR_LEVEL];						/* 0x52 U0.8 */
-	uint8_t contrast_factor[NUM_AGGR_LEVEL];					/* 0x56 U0.8 */
-	uint8_t deviation_gain[NUM_AGGR_LEVEL];						/* 0x5a U0.8 */
-	uint8_t iir_curve[NUM_AMBI_LEVEL];							/* 0x5e U0.8 */
-	uint8_t min_knee[NUM_AGGR_LEVEL];							/* 0x63 U0.8 */
-	uint8_t max_knee[NUM_AGGR_LEVEL];							/* 0x67 U0.8 */
-	uint8_t pad[21];											/* 0x6b U0.8 */
+	uint8_t hybrid_factor[NUM_AGGR_LEVEL];				/* 0x52 U0.8 */
+	uint8_t contrast_factor[NUM_AGGR_LEVEL];			/* 0x56 U0.8 */
+	uint8_t deviation_gain[NUM_AGGR_LEVEL];				/* 0x5a U0.8 */
+	uint8_t iir_curve[NUM_AMBI_LEVEL];				/* 0x5e U0.8 */
+	uint8_t min_knee[NUM_AGGR_LEVEL];				/* 0x63 U0.8 */
+	uint8_t max_knee[NUM_AGGR_LEVEL];				/* 0x67 U0.8 */
+	uint16_t min_abm_backlight;					/* 0x6b U16  */
+	uint8_t pad[19];						/* 0x6d U0.8 */
 
 	/* parameters for crgb conversion */
-	uint16_t crgb_thresh[NUM_POWER_FN_SEGS];					/* 0x80 U3.13 */
-	uint16_t crgb_offset[NUM_POWER_FN_SEGS];					/* 0x90 U1.15 */
-	uint16_t crgb_slope[NUM_POWER_FN_SEGS];						/* 0xa0 U4.12 */
+	uint16_t crgb_thresh[NUM_POWER_FN_SEGS];			/* 0x80 U3.13 */
+	uint16_t crgb_offset[NUM_POWER_FN_SEGS];			/* 0x90 U1.15 */
+	uint16_t crgb_slope[NUM_POWER_FN_SEGS];				/* 0xa0 U4.12 */
 
 	/* parameters for custom curve */
 	/* thresholds for brightness --> backlight */
-	uint16_t backlight_thresholds[NUM_BL_CURVE_SEGS];			/* 0xb0 U16.0 */
+	uint16_t backlight_thresholds[NUM_BL_CURVE_SEGS];		/* 0xb0 U16.0 */
 	/* offsets for brightness --> backlight */
-	uint16_t backlight_offsets[NUM_BL_CURVE_SEGS];				/* 0xd0 U16.0 */
+	uint16_t backlight_offsets[NUM_BL_CURVE_SEGS];			/* 0xd0 U16.0 */
 
 	/* For reading PSR State directly from IRAM */
-	uint8_t psr_state;											/* 0xf0       */
-	uint8_t dmcu_mcp_interface_version;							/* 0xf1       */
-	uint8_t dmcu_abm_feature_version;							/* 0xf2       */
-	uint8_t dmcu_psr_feature_version;							/* 0xf3       */
-	uint16_t dmcu_version;										/* 0xf4       */
-	uint8_t dmcu_state;											/* 0xf6       */
-
-	uint8_t dummy1;												/* 0xf7       */
-	uint8_t dummy2;												/* 0xf8       */
-	uint8_t dummy3;												/* 0xf9       */
-	uint8_t dummy4;												/* 0xfa       */
-	uint8_t dummy5;												/* 0xfb       */
-	uint8_t dummy6;												/* 0xfc       */
-	uint8_t dummy7;												/* 0xfd       */
-	uint8_t dummy8;												/* 0xfe       */
-	uint8_t dummy9;												/* 0xff       */
+	uint8_t psr_state;						/* 0xf0       */
+	uint8_t dmcu_mcp_interface_version;				/* 0xf1       */
+	uint8_t dmcu_abm_feature_version;				/* 0xf2       */
+	uint8_t dmcu_psr_feature_version;				/* 0xf3       */
+	uint16_t dmcu_version;						/* 0xf4       */
+	uint8_t dmcu_state;						/* 0xf6       */
+
+	uint8_t dummy1;							/* 0xf7       */
+	uint8_t dummy2;							/* 0xf8       */
+	uint8_t dummy3;							/* 0xf9       */
+	uint8_t dummy4;							/* 0xfa       */
+	uint8_t dummy5;							/* 0xfb       */
+	uint8_t dummy6;							/* 0xfc       */
+	uint8_t dummy7;							/* 0xfd       */
+	uint8_t dummy8;							/* 0xfe       */
+	uint8_t dummy9;							/* 0xff       */
 };
 #pragma pack(pop)
 
@@ -271,7 +272,8 @@ void fill_iram_v_2(struct iram_table_v_2 *ram_table, struct dmcu_iram_parameters
 {
 	unsigned int set = params.set;
 
-	ram_table->flags = 0x0;
+	ram_table->min_abm_backlight =
+			cpu_to_be16(params.min_abm_backlight);
 	ram_table->deviation_gain = 0xb3;
 
 	ram_table->blRampReduction =
@@ -445,6 +447,9 @@ void fill_iram_v_2_2(struct iram_table_v_2_2 *ram_table, struct dmcu_iram_parame
 
 	ram_table->flags = 0x0;
 
+	ram_table->min_abm_backlight =
+			cpu_to_be16(params.min_abm_backlight);
+
 	ram_table->deviation_gain[0] = 0xb3;
 	ram_table->deviation_gain[1] = 0xa8;
 	ram_table->deviation_gain[2] = 0x98;
@@ -588,6 +593,10 @@ void fill_iram_v_2_3(struct iram_table_v_2_2 *ram_table, struct dmcu_iram_parame
 	unsigned int set = params.set;
 
 	ram_table->flags = 0x0;
+
+	ram_table->min_abm_backlight =
+			cpu_to_be16(params.min_abm_backlight);
+
 	for (i = 0; i < NUM_AGGR_LEVEL; i++) {
 		ram_table->hybrid_factor[i] = abm_settings[set][i].brightness_gain;
 		ram_table->contrast_factor[i] = abm_settings[set][i].contrast_factor;
diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.h b/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
index da5df00fedce..e54157026330 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
@@ -38,6 +38,7 @@ struct dmcu_iram_parameters {
 	unsigned int backlight_lut_array_size;
 	unsigned int backlight_ramping_reduction;
 	unsigned int backlight_ramping_start;
+	unsigned int min_abm_backlight;
 	unsigned int set;
 };
 
-- 
2.20.1



