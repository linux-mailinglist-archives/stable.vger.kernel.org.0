Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9F4514B2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhKOUMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344896AbhKOTZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CCDC633F2;
        Mon, 15 Nov 2021 19:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003188;
        bh=RvzjfwrRdm2zXYaO2ZjytE2bjPNeAuwoudSoPEVczZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMMJYBZgZbcomKDZmf5HgSndlNqc/lWaZzkYWwA7yKWfjZv0Z653FM7Aq6UCkDAxD
         Gp7CwKgM325czO51LpoUjRB6OXdSuwDUgV1GWd1JOPHT2l09QYClHgk/u7miv/35Qr
         g0hFIvLK51Cy0G1i+8C6aPzis7wD16gyit5n7SV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Darren Powell <darren.powell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 810/917] drm/amdgpu/powerplay: fix sysfs_emit/sysfs_emit_at handling
Date:   Mon, 15 Nov 2021 18:05:05 +0100
Message-Id: <20211115165456.470110175@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e9c76719c1e99caf95e70de74170291b9457bbc1 ]

sysfs_emit and sysfs_emit_at requrie a page boundary
aligned buf address. Make them happy!

v2: fix sysfs_emit -> sysfs_emit_at missed conversions

Cc: Lang Yu <lang.yu@amd.com>
Cc: Darren Powell <darren.powell@amd.com>
Fixes: 6db0c87a0a8e ("amdgpu/pm: Replace hwmgr smu usage of sprintf with sysfs_emit")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1774
Reviewed-by: Lang Yu <lang.yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |  8 ++++++--
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    | 10 +++++++---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  2 ++
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h    | 13 +++++++++++++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  | 12 +++++++++---
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |  4 ++++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  | 14 ++++++++++----
 7 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index 1de3ae77e03ed..258c573acc979 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1024,6 +1024,8 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 	uint32_t min_freq, max_freq = 0;
 	uint32_t ret = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
@@ -1065,7 +1067,7 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 			if (ret)
 				return ret;
 
-			size = sysfs_emit(buf, "%s:\n", "OD_SCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
 			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
 			(data->gfx_actual_soft_min_freq > 0) ? data->gfx_actual_soft_min_freq : min_freq);
 			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
@@ -1081,7 +1083,7 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 			if (ret)
 				return ret;
 
-			size = sysfs_emit(buf, "%s:\n", "OD_RANGE");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
 			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
 				min_freq, max_freq);
 		}
@@ -1456,6 +1458,8 @@ static int smu10_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	if (!buf)
 		return -EINVAL;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	size += sysfs_emit_at(buf, size, "%s %16s %s %s %s %s\n",title[0],
 			title[1], title[2], title[3], title[4], title[5]);
 
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index e7803ce8f67aa..aceebf5842253 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -4914,6 +4914,8 @@ static int smu7_print_clock_levels(struct pp_hwmgr *hwmgr,
 	int size = 0;
 	uint32_t i, now, clock, pcie_speed;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_API_GetSclkFrequency, &clock);
@@ -4963,7 +4965,7 @@ static int smu7_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 	case OD_SCLK:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_SCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
 			for (i = 0; i < odn_sclk_table->num_of_pl; i++)
 				size += sysfs_emit_at(buf, size, "%d: %10uMHz %10umV\n",
 					i, odn_sclk_table->entries[i].clock/100,
@@ -4972,7 +4974,7 @@ static int smu7_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 	case OD_MCLK:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_MCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
 			for (i = 0; i < odn_mclk_table->num_of_pl; i++)
 				size += sysfs_emit_at(buf, size, "%d: %10uMHz %10umV\n",
 					i, odn_mclk_table->entries[i].clock/100,
@@ -4981,7 +4983,7 @@ static int smu7_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 	case OD_RANGE:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_RANGE");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
 			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.sclk_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.engineClock/100);
@@ -5518,6 +5520,8 @@ static int smu7_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	if (!buf)
 		return -EINVAL;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	size += sysfs_emit_at(buf, size, "%s %16s %16s %16s %16s %16s %16s %16s\n",
 			title[0], title[1], title[2], title[3],
 			title[4], title[5], title[6], title[7]);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
index b94a77e4e7147..8e28a8eecefc6 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
@@ -1550,6 +1550,8 @@ static int smu8_print_clock_levels(struct pp_hwmgr *hwmgr,
 	uint32_t i, now;
 	int size = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		now = PHM_GET_FIELD(cgs_read_ind_register(hwmgr->device,
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h
index ad33983a8064e..2a75da1e9f035 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h
@@ -109,6 +109,19 @@ int phm_irq_process(struct amdgpu_device *adev,
 			   struct amdgpu_irq_src *source,
 			   struct amdgpu_iv_entry *entry);
 
+/*
+ * Helper function to make sysfs_emit_at() happy. Align buf to
+ * the current page boundary and record the offset.
+ */
+static inline void phm_get_sysfs_buf(char **buf, int *offset)
+{
+	if (!*buf || !offset)
+		return;
+
+	*offset = offset_in_page(*buf);
+	*buf -= *offset;
+}
+
 int smu9_register_irq_handlers(struct pp_hwmgr *hwmgr);
 
 void *smu_atom_get_data_table(void *dev, uint32_t table, uint16_t *size,
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index c152a61ddd2c9..c981fc2882f01 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -4548,6 +4548,8 @@ static int vega10_get_ppfeature_status(struct pp_hwmgr *hwmgr, char *buf)
 	int ret = 0;
 	int size = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	ret = vega10_get_enabled_smc_features(hwmgr, &features_enabled);
 	PP_ASSERT_WITH_CODE(!ret,
 			"[EnableAllSmuFeatures] Failed to get enabled smc features!",
@@ -4637,6 +4639,8 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 
 	int i, now, size = 0, count = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		if (data->registry_data.sclk_dpm_key_disabled)
@@ -4717,7 +4721,7 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 
 	case OD_SCLK:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_SCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
 			podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_sclk;
 			for (i = 0; i < podn_vdd_dep->count; i++)
 				size += sysfs_emit_at(buf, size, "%d: %10uMhz %10umV\n",
@@ -4727,7 +4731,7 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 	case OD_MCLK:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_MCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
 			podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_mclk;
 			for (i = 0; i < podn_vdd_dep->count; i++)
 				size += sysfs_emit_at(buf, size, "%d: %10uMhz %10umV\n",
@@ -4737,7 +4741,7 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 	case OD_RANGE:
 		if (hwmgr->od_enabled) {
-			size = sysfs_emit(buf, "%s:\n", "OD_RANGE");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
 			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.gfx_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.engineClock/100);
@@ -5112,6 +5116,8 @@ static int vega10_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	if (!buf)
 		return -EINVAL;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	size += sysfs_emit_at(buf, size, "%s %16s %s %s %s %s\n",title[0],
 			title[1], title[2], title[3], title[4], title[5]);
 
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
index 8558718e15a8f..f7e783e1c888f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -2141,6 +2141,8 @@ static int vega12_get_ppfeature_status(struct pp_hwmgr *hwmgr, char *buf)
 	int ret = 0;
 	int size = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	ret = vega12_get_enabled_smc_features(hwmgr, &features_enabled);
 	PP_ASSERT_WITH_CODE(!ret,
 		"[EnableAllSmuFeatures] Failed to get enabled smc features!",
@@ -2244,6 +2246,8 @@ static int vega12_print_clock_levels(struct pp_hwmgr *hwmgr,
 	int i, now, size = 0;
 	struct pp_clock_levels_with_latency clocks;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		PP_ASSERT_WITH_CODE(
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index 0cf39c1244b1c..03e63be4ee275 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -3238,6 +3238,8 @@ static int vega20_get_ppfeature_status(struct pp_hwmgr *hwmgr, char *buf)
 	int ret = 0;
 	int size = 0;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	ret = vega20_get_enabled_smc_features(hwmgr, &features_enabled);
 	PP_ASSERT_WITH_CODE(!ret,
 			"[EnableAllSmuFeatures] Failed to get enabled smc features!",
@@ -3364,6 +3366,8 @@ static int vega20_print_clock_levels(struct pp_hwmgr *hwmgr,
 	int ret = 0;
 	uint32_t gen_speed, lane_width, current_gen_speed, current_lane_width;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	switch (type) {
 	case PP_SCLK:
 		ret = vega20_get_current_clk_freq(hwmgr, PPCLK_GFXCLK, &now);
@@ -3479,7 +3483,7 @@ static int vega20_print_clock_levels(struct pp_hwmgr *hwmgr,
 	case OD_SCLK:
 		if (od8_settings[OD8_SETTING_GFXCLK_FMIN].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_FMAX].feature_id) {
-			size = sysfs_emit(buf, "%s:\n", "OD_SCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
 			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
 				od_table->GfxclkFmin);
 			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
@@ -3489,7 +3493,7 @@ static int vega20_print_clock_levels(struct pp_hwmgr *hwmgr,
 
 	case OD_MCLK:
 		if (od8_settings[OD8_SETTING_UCLK_FMAX].feature_id) {
-			size = sysfs_emit(buf, "%s:\n", "OD_MCLK");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
 			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
 				od_table->UclkFmax);
 		}
@@ -3503,7 +3507,7 @@ static int vega20_print_clock_levels(struct pp_hwmgr *hwmgr,
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE1].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE2].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE3].feature_id) {
-			size = sysfs_emit(buf, "%s:\n", "OD_VDDC_CURVE");
+			size += sysfs_emit_at(buf, size, "%s:\n", "OD_VDDC_CURVE");
 			size += sysfs_emit_at(buf, size, "0: %10uMhz %10dmV\n",
 				od_table->GfxclkFreq1,
 				od_table->GfxclkVolt1 / VOLTAGE_SCALE);
@@ -3518,7 +3522,7 @@ static int vega20_print_clock_levels(struct pp_hwmgr *hwmgr,
 		break;
 
 	case OD_RANGE:
-		size = sysfs_emit(buf, "%s:\n", "OD_RANGE");
+		size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
 
 		if (od8_settings[OD8_SETTING_GFXCLK_FMIN].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_FMAX].feature_id) {
@@ -4003,6 +4007,8 @@ static int vega20_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	if (!buf)
 		return -EINVAL;
 
+	phm_get_sysfs_buf(&buf, &size);
+
 	size += sysfs_emit_at(buf, size, "%16s %s %s %s %s %s %s %s %s %s %s\n",
 			title[0], title[1], title[2], title[3], title[4], title[5],
 			title[6], title[7], title[8], title[9], title[10]);
-- 
2.33.0



