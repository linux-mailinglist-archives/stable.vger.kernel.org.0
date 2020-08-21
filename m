Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073F624D9F1
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgHUQQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgHUQQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7E222B40;
        Fri, 21 Aug 2020 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026581;
        bh=mpbgj65TDYM4OE27MKRy/4cufNHeJ2Fm4h2DwDiS3ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azdc5tGr+vnQJMNUN+E3mEv6aFzGdyZL8gNmoQ4aBUd9NKa3gVw//IHyWmBWO6wTY
         2nmo23CoHbycL9BzQ93RP9CryxFakD5x54LHauDqq+4+AhIPovmpo3ZM6x3GugGntY
         x1wpdI1UxavMDPLRM84DtquzDqfBVlFTREiUBdmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 29/61] drm/amdgpu/pm: fix ref count leak when pm_runtime_get_sync fails
Date:   Fri, 21 Aug 2020 12:15:13 -0400
Message-Id: <20200821161545.347622-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 66429300e1bd9cdfbe96cfc475e4964db2a36921 ]

The call to pm_runtime_get_sync increments the counter even in case of
failure, leading to incorrect ref count.
In case of failure, decrement the ref count before returning.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c | 220 ++++++++++++++++++-------
 1 file changed, 165 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index 96b8feb77b15d..e08b0033ca465 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -167,8 +167,10 @@ static ssize_t amdgpu_get_dpm_state(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		if (adev->smu.ppt_funcs->get_current_power_state)
@@ -212,8 +214,10 @@ static ssize_t amdgpu_set_dpm_state(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		mutex_lock(&adev->pm.mutex);
@@ -307,8 +311,10 @@ static ssize_t amdgpu_get_dpm_forced_performance_level(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		level = smu_get_performance_level(&adev->smu);
@@ -369,8 +375,10 @@ static ssize_t amdgpu_set_dpm_forced_performance_level(struct device *dev,
 	}
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		current_level = smu_get_performance_level(&adev->smu);
@@ -446,8 +454,10 @@ static ssize_t amdgpu_get_pp_num_states(struct device *dev,
 	int i, buf_len, ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_get_power_num_states(&adev->smu, &data);
@@ -488,8 +498,10 @@ static ssize_t amdgpu_get_pp_cur_state(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pm = smu_get_current_power_state(smu);
@@ -564,8 +576,10 @@ static ssize_t amdgpu_set_pp_force_state(struct device *dev,
 		state = data.states[idx];
 
 		ret = pm_runtime_get_sync(ddev->dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_autosuspend(ddev->dev);
 			return ret;
+		}
 
 		/* only set user selected power states */
 		if (state != POWER_STATE_TYPE_INTERNAL_BOOT &&
@@ -605,8 +619,10 @@ static ssize_t amdgpu_get_pp_table(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		size = smu_sys_get_pp_table(&adev->smu, (void **)&table);
@@ -647,8 +663,10 @@ static ssize_t amdgpu_set_pp_table(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_sys_set_pp_table(&adev->smu, (void *)buf, count);
@@ -787,8 +805,10 @@ static ssize_t amdgpu_set_pp_od_clk_voltage(struct device *dev,
 	}
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_od_edit_dpm_table(&adev->smu, type,
@@ -844,8 +864,10 @@ static ssize_t amdgpu_get_pp_od_clk_voltage(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		size = smu_print_clk_levels(&adev->smu, SMU_OD_SCLK, buf);
@@ -902,8 +924,10 @@ static ssize_t amdgpu_set_pp_feature_status(struct device *dev,
 	pr_debug("featuremask = 0x%llx\n", featuremask);
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_sys_set_pp_feature_mask(&adev->smu, featuremask);
@@ -939,8 +963,10 @@ static ssize_t amdgpu_get_pp_feature_status(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_sys_get_pp_feature_mask(&adev->smu, buf);
@@ -998,8 +1024,10 @@ static ssize_t amdgpu_get_pp_dpm_sclk(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_SCLK, buf);
@@ -1068,8 +1096,10 @@ static ssize_t amdgpu_set_pp_dpm_sclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_SCLK, mask, true);
@@ -1098,8 +1128,10 @@ static ssize_t amdgpu_get_pp_dpm_mclk(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_MCLK, buf);
@@ -1132,8 +1164,10 @@ static ssize_t amdgpu_set_pp_dpm_mclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_MCLK, mask, true);
@@ -1162,8 +1196,10 @@ static ssize_t amdgpu_get_pp_dpm_socclk(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_SOCCLK, buf);
@@ -1196,8 +1232,10 @@ static ssize_t amdgpu_set_pp_dpm_socclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_SOCCLK, mask, true);
@@ -1228,8 +1266,10 @@ static ssize_t amdgpu_get_pp_dpm_fclk(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_FCLK, buf);
@@ -1262,8 +1302,10 @@ static ssize_t amdgpu_set_pp_dpm_fclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_FCLK, mask, true);
@@ -1294,8 +1336,10 @@ static ssize_t amdgpu_get_pp_dpm_dcefclk(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_DCEFCLK, buf);
@@ -1328,8 +1372,10 @@ static ssize_t amdgpu_set_pp_dpm_dcefclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_DCEFCLK, mask, true);
@@ -1360,8 +1406,10 @@ static ssize_t amdgpu_get_pp_dpm_pcie(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_PCIE, buf);
@@ -1394,8 +1442,10 @@ static ssize_t amdgpu_set_pp_dpm_pcie(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_PCIE, mask, true);
@@ -1426,8 +1476,10 @@ static ssize_t amdgpu_get_pp_sclk_od(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		value = smu_get_od_percentage(&(adev->smu), SMU_OD_SCLK);
@@ -1459,8 +1511,10 @@ static ssize_t amdgpu_set_pp_sclk_od(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		value = smu_set_od_percentage(&(adev->smu), SMU_OD_SCLK, (uint32_t)value);
@@ -1495,8 +1549,10 @@ static ssize_t amdgpu_get_pp_mclk_od(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		value = smu_get_od_percentage(&(adev->smu), SMU_OD_MCLK);
@@ -1528,8 +1584,10 @@ static ssize_t amdgpu_set_pp_mclk_od(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		value = smu_set_od_percentage(&(adev->smu), SMU_OD_MCLK, (uint32_t)value);
@@ -1584,8 +1642,10 @@ static ssize_t amdgpu_get_pp_power_profile_mode(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_get_power_profile_mode(&adev->smu, buf);
@@ -1647,8 +1707,10 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 	parameter[parameter_size] = profile_mode;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_set_power_profile_mode(&adev->smu, parameter, parameter_size, true);
@@ -1684,8 +1746,10 @@ static ssize_t amdgpu_get_busy_percent(struct device *dev,
 		return 0;
 
 	r = pm_runtime_get_sync(ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return r;
+	}
 
 	/* read the IP busy sensor */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_LOAD,
@@ -1720,8 +1784,10 @@ static ssize_t amdgpu_get_memory_busy_percent(struct device *dev,
 		return 0;
 
 	r = pm_runtime_get_sync(ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return r;
+	}
 
 	/* read the IP busy sensor */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MEM_LOAD,
@@ -1761,8 +1827,10 @@ static ssize_t amdgpu_get_pcie_bw(struct device *dev,
 		return 0;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	amdgpu_asic_get_pcie_usage(adev, &count0, &count1);
 
@@ -1863,8 +1931,10 @@ static ssize_t amdgpu_hwmon_show_temp(struct device *dev,
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	switch (channel) {
 	case PP_TEMP_JUNCTION:
@@ -1991,8 +2061,10 @@ static ssize_t amdgpu_hwmon_get_pwm1_enable(struct device *dev,
 	int ret;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2026,8 +2098,10 @@ static ssize_t amdgpu_hwmon_set_pwm1_enable(struct device *dev,
 		return err;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_set_fan_control_mode(&adev->smu, value);
@@ -2071,8 +2145,10 @@ static ssize_t amdgpu_hwmon_set_pwm1(struct device *dev,
 	u32 pwm_mode;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2120,8 +2196,10 @@ static ssize_t amdgpu_hwmon_get_pwm1(struct device *dev,
 	u32 speed = 0;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_percent(&adev->smu, &speed);
@@ -2150,8 +2228,10 @@ static ssize_t amdgpu_hwmon_get_fan1_input(struct device *dev,
 	u32 speed = 0;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_rpm(&adev->smu, &speed);
@@ -2179,8 +2259,10 @@ static ssize_t amdgpu_hwmon_get_fan1_min(struct device *dev,
 	int r;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MIN_FAN_RPM,
 				   (void *)&min_rpm, &size);
@@ -2204,8 +2286,10 @@ static ssize_t amdgpu_hwmon_get_fan1_max(struct device *dev,
 	int r;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MAX_FAN_RPM,
 				   (void *)&max_rpm, &size);
@@ -2228,8 +2312,10 @@ static ssize_t amdgpu_hwmon_get_fan1_target(struct device *dev,
 	u32 rpm = 0;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_rpm(&adev->smu, &rpm);
@@ -2257,8 +2343,10 @@ static ssize_t amdgpu_hwmon_set_fan1_target(struct device *dev,
 	u32 pwm_mode;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2303,8 +2391,10 @@ static ssize_t amdgpu_hwmon_get_fan1_enable(struct device *dev,
 	int ret;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2346,8 +2436,10 @@ static ssize_t amdgpu_hwmon_set_fan1_enable(struct device *dev,
 		return -EINVAL;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_set_fan_control_mode(&adev->smu, pwm_mode);
@@ -2375,8 +2467,10 @@ static ssize_t amdgpu_hwmon_show_vddgfx(struct device *dev,
 	int r, size = sizeof(vddgfx);
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_VDDGFX,
@@ -2411,8 +2505,10 @@ static ssize_t amdgpu_hwmon_show_vddnb(struct device *dev,
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_VDDNB,
@@ -2444,8 +2540,10 @@ static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
 	unsigned uw;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_POWER,
@@ -2480,8 +2578,10 @@ static ssize_t amdgpu_hwmon_show_power_cap_max(struct device *dev,
 	int r;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_get_power_limit(&adev->smu, &limit, true, true);
@@ -2509,8 +2609,10 @@ static ssize_t amdgpu_hwmon_show_power_cap(struct device *dev,
 	int r;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_get_power_limit(&adev->smu, &limit, false,  true);
@@ -2549,8 +2651,10 @@ static ssize_t amdgpu_hwmon_set_power_cap(struct device *dev,
 
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_set_power_limit(&adev->smu, value);
@@ -2577,8 +2681,10 @@ static ssize_t amdgpu_hwmon_show_sclk(struct device *dev,
 	int r, size = sizeof(sclk);
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the sclk */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GFX_SCLK,
@@ -2609,8 +2715,10 @@ static ssize_t amdgpu_hwmon_show_mclk(struct device *dev,
 	int r, size = sizeof(mclk);
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the sclk */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GFX_MCLK,
@@ -3639,8 +3747,10 @@ static int amdgpu_debugfs_pm_info(struct seq_file *m, void *data)
 	int r;
 
 	r = pm_runtime_get_sync(dev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	amdgpu_device_ip_get_clockgating_state(adev, &flags);
 	seq_printf(m, "Clock Gating Flags Mask: 0x%x\n", flags);
-- 
2.25.1

