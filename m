Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4224DE1F
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHUQPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgHUQPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095032173E;
        Fri, 21 Aug 2020 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026499;
        bh=nwrWhC4bKbEo13ygdPQVtJJpbqLCY9k/8wpLAF6SzMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USFQBtgzX6hR4hg6VM8HhxpN3gyAg5PYNTrRV9vgnimv6NSuPHr1QGIwX4o5fGqW1
         KydbCCLQU7BE1Fa/FblTAEa1x9PVWlXrjm5kjuFKeIbj8lXS5BV0syTAjGPg1bWPuK
         CzUw1MOE9UkglkgPovbjys1oHTi9cDA+q+cZszNo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 29/62] drm/amdgpu/pm: fix ref count leak when pm_runtime_get_sync fails
Date:   Fri, 21 Aug 2020 12:13:50 -0400
Message-Id: <20200821161423.347071-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
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
index 02e6f8c4dde08..459b81fc5aef4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -167,8 +167,10 @@ static ssize_t amdgpu_get_power_dpm_state(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		if (adev->smu.ppt_funcs->get_current_power_state)
@@ -212,8 +214,10 @@ static ssize_t amdgpu_set_power_dpm_state(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		mutex_lock(&adev->pm.mutex);
@@ -307,8 +311,10 @@ static ssize_t amdgpu_get_power_dpm_force_performance_level(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		level = smu_get_performance_level(&adev->smu);
@@ -369,8 +375,10 @@ static ssize_t amdgpu_set_power_dpm_force_performance_level(struct device *dev,
 	}
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		current_level = smu_get_performance_level(&adev->smu);
@@ -449,8 +457,10 @@ static ssize_t amdgpu_get_pp_num_states(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_get_power_num_states(&adev->smu, &data);
@@ -491,8 +501,10 @@ static ssize_t amdgpu_get_pp_cur_state(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pm = smu_get_current_power_state(smu);
@@ -567,8 +579,10 @@ static ssize_t amdgpu_set_pp_force_state(struct device *dev,
 		state = data.states[idx];
 
 		ret = pm_runtime_get_sync(ddev->dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_autosuspend(ddev->dev);
 			return ret;
+		}
 
 		/* only set user selected power states */
 		if (state != POWER_STATE_TYPE_INTERNAL_BOOT &&
@@ -608,8 +622,10 @@ static ssize_t amdgpu_get_pp_table(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		size = smu_sys_get_pp_table(&adev->smu, (void **)&table);
@@ -650,8 +666,10 @@ static ssize_t amdgpu_set_pp_table(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_sys_set_pp_table(&adev->smu, (void *)buf, count);
@@ -790,8 +808,10 @@ static ssize_t amdgpu_set_pp_od_clk_voltage(struct device *dev,
 	}
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_od_edit_dpm_table(&adev->smu, type,
@@ -847,8 +867,10 @@ static ssize_t amdgpu_get_pp_od_clk_voltage(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		size = smu_print_clk_levels(&adev->smu, SMU_OD_SCLK, buf);
@@ -905,8 +927,10 @@ static ssize_t amdgpu_set_pp_features(struct device *dev,
 	pr_debug("featuremask = 0x%llx\n", featuremask);
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		ret = smu_sys_set_pp_feature_mask(&adev->smu, featuremask);
@@ -942,8 +966,10 @@ static ssize_t amdgpu_get_pp_features(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_sys_get_pp_feature_mask(&adev->smu, buf);
@@ -1001,8 +1027,10 @@ static ssize_t amdgpu_get_pp_dpm_sclk(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_SCLK, buf);
@@ -1071,8 +1099,10 @@ static ssize_t amdgpu_set_pp_dpm_sclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_SCLK, mask, true);
@@ -1101,8 +1131,10 @@ static ssize_t amdgpu_get_pp_dpm_mclk(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_MCLK, buf);
@@ -1135,8 +1167,10 @@ static ssize_t amdgpu_set_pp_dpm_mclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_MCLK, mask, true);
@@ -1165,8 +1199,10 @@ static ssize_t amdgpu_get_pp_dpm_socclk(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_SOCCLK, buf);
@@ -1199,8 +1235,10 @@ static ssize_t amdgpu_set_pp_dpm_socclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_SOCCLK, mask, true);
@@ -1231,8 +1269,10 @@ static ssize_t amdgpu_get_pp_dpm_fclk(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_FCLK, buf);
@@ -1265,8 +1305,10 @@ static ssize_t amdgpu_set_pp_dpm_fclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_FCLK, mask, true);
@@ -1297,8 +1339,10 @@ static ssize_t amdgpu_get_pp_dpm_dcefclk(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_DCEFCLK, buf);
@@ -1331,8 +1375,10 @@ static ssize_t amdgpu_set_pp_dpm_dcefclk(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_DCEFCLK, mask, true);
@@ -1363,8 +1409,10 @@ static ssize_t amdgpu_get_pp_dpm_pcie(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_print_clk_levels(&adev->smu, SMU_PCIE, buf);
@@ -1397,8 +1445,10 @@ static ssize_t amdgpu_set_pp_dpm_pcie(struct device *dev,
 		return ret;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_force_clk_levels(&adev->smu, SMU_PCIE, mask, true);
@@ -1429,8 +1479,10 @@ static ssize_t amdgpu_get_pp_sclk_od(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		value = smu_get_od_percentage(&(adev->smu), SMU_OD_SCLK);
@@ -1462,8 +1514,10 @@ static ssize_t amdgpu_set_pp_sclk_od(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		value = smu_set_od_percentage(&(adev->smu), SMU_OD_SCLK, (uint32_t)value);
@@ -1498,8 +1552,10 @@ static ssize_t amdgpu_get_pp_mclk_od(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		value = smu_get_od_percentage(&(adev->smu), SMU_OD_MCLK);
@@ -1531,8 +1587,10 @@ static ssize_t amdgpu_set_pp_mclk_od(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		value = smu_set_od_percentage(&(adev->smu), SMU_OD_MCLK, (uint32_t)value);
@@ -1587,8 +1645,10 @@ static ssize_t amdgpu_get_pp_power_profile_mode(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		size = smu_get_power_profile_mode(&adev->smu, buf);
@@ -1650,8 +1710,10 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 	parameter[parameter_size] = profile_mode;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev))
 		ret = smu_set_power_profile_mode(&adev->smu, parameter, parameter_size, true);
@@ -1687,8 +1749,10 @@ static ssize_t amdgpu_get_gpu_busy_percent(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return r;
+	}
 
 	/* read the IP busy sensor */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_LOAD,
@@ -1723,8 +1787,10 @@ static ssize_t amdgpu_get_mem_busy_percent(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return r;
+	}
 
 	/* read the IP busy sensor */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MEM_LOAD,
@@ -1770,8 +1836,10 @@ static ssize_t amdgpu_get_pcie_bw(struct device *dev,
 		return -ENODATA;
 
 	ret = pm_runtime_get_sync(ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(ddev->dev);
 		return ret;
+	}
 
 	amdgpu_asic_get_pcie_usage(adev, &count0, &count1);
 
@@ -2003,8 +2071,10 @@ static ssize_t amdgpu_hwmon_show_temp(struct device *dev,
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	switch (channel) {
 	case PP_TEMP_JUNCTION:
@@ -2134,8 +2204,10 @@ static ssize_t amdgpu_hwmon_get_pwm1_enable(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2172,8 +2244,10 @@ static ssize_t amdgpu_hwmon_set_pwm1_enable(struct device *dev,
 		return err;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_set_fan_control_mode(&adev->smu, value);
@@ -2220,8 +2294,10 @@ static ssize_t amdgpu_hwmon_set_pwm1(struct device *dev,
 		return -EPERM;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2272,8 +2348,10 @@ static ssize_t amdgpu_hwmon_get_pwm1(struct device *dev,
 		return -EPERM;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_percent(&adev->smu, &speed);
@@ -2305,8 +2383,10 @@ static ssize_t amdgpu_hwmon_get_fan1_input(struct device *dev,
 		return -EPERM;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_rpm(&adev->smu, &speed);
@@ -2337,8 +2417,10 @@ static ssize_t amdgpu_hwmon_get_fan1_min(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MIN_FAN_RPM,
 				   (void *)&min_rpm, &size);
@@ -2365,8 +2447,10 @@ static ssize_t amdgpu_hwmon_get_fan1_max(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_MAX_FAN_RPM,
 				   (void *)&max_rpm, &size);
@@ -2392,8 +2476,10 @@ static ssize_t amdgpu_hwmon_get_fan1_target(struct device *dev,
 		return -EPERM;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_get_fan_speed_rpm(&adev->smu, &rpm);
@@ -2424,8 +2510,10 @@ static ssize_t amdgpu_hwmon_set_fan1_target(struct device *dev,
 		return -EPERM;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2473,8 +2561,10 @@ static ssize_t amdgpu_hwmon_get_fan1_enable(struct device *dev,
 		return -EPERM;
 
 	ret = pm_runtime_get_sync(adev->ddev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return ret;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		pwm_mode = smu_get_fan_control_mode(&adev->smu);
@@ -2519,8 +2609,10 @@ static ssize_t amdgpu_hwmon_set_fan1_enable(struct device *dev,
 		return -EINVAL;
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_set_fan_control_mode(&adev->smu, pwm_mode);
@@ -2551,8 +2643,10 @@ static ssize_t amdgpu_hwmon_show_vddgfx(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_VDDGFX,
@@ -2590,8 +2684,10 @@ static ssize_t amdgpu_hwmon_show_vddnb(struct device *dev,
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_VDDNB,
@@ -2626,8 +2722,10 @@ static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the voltage */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_POWER,
@@ -2665,8 +2763,10 @@ static ssize_t amdgpu_hwmon_show_power_cap_max(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_get_power_limit(&adev->smu, &limit, true, true);
@@ -2697,8 +2797,10 @@ static ssize_t amdgpu_hwmon_show_power_cap(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	if (is_support_sw_smu(adev)) {
 		smu_get_power_limit(&adev->smu, &limit, false,  true);
@@ -2740,8 +2842,10 @@ static ssize_t amdgpu_hwmon_set_power_cap(struct device *dev,
 
 
 	err = pm_runtime_get_sync(adev->ddev->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return err;
+	}
 
 	if (is_support_sw_smu(adev))
 		err = smu_set_power_limit(&adev->smu, value);
@@ -2771,8 +2875,10 @@ static ssize_t amdgpu_hwmon_show_sclk(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the sclk */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GFX_SCLK,
@@ -2806,8 +2912,10 @@ static ssize_t amdgpu_hwmon_show_mclk(struct device *dev,
 		return -EPERM;
 
 	r = pm_runtime_get_sync(adev->ddev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(adev->ddev->dev);
 		return r;
+	}
 
 	/* get the sclk */
 	r = amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GFX_MCLK,
@@ -3669,8 +3777,10 @@ static int amdgpu_debugfs_pm_info(struct seq_file *m, void *data)
 		return -EPERM;
 
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

