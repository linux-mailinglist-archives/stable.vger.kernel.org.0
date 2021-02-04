Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94B30BFEB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhBBNpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhBBNnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 784F764F6B;
        Tue,  2 Feb 2021 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273211;
        bh=vDgI0KISKsQpwYAOn5Nnpa0DlPBe8ruIWp/pmp29/k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4G7o7kjhkiuSYIxrMWJq3SDaXV4pLMmRaxE6QN23TChJSnSsIa3hvgA4QiGBNpA6
         Xy/xaeb7qZWYy44rUE33k9CHooTSUg/W0KqCl+5UoDnMfRWHSBTkToSVAGzzcjzbxg
         4m5ULDX669jlHSlz3EE/g01OSvI4vgQS8MLl5kuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 022/142] Revert "drm/amdgpu/swsmu: drop set_fan_speed_percent (v2)"
Date:   Tue,  2 Feb 2021 14:36:25 +0100
Message-Id: <20210202132958.627180725@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit a119f87b86bcdf14a18ce39a899e97a1e9160f7f upstream.

On some boards the rpm interface apparently does not work at all
leading to the fan not spinning or spinning at strange speeds.
Revert this for now to fix 5.10, 5.11.  The follow on patch
fixes this properly for 5.12.

This reverts commit 8d6e65adc25e23fabbc5293b6cd320195c708dca.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1408
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/pm/inc/amdgpu_smu.h                 |    1 
 drivers/gpu/drm/amd/pm/inc/smu_v11_0.h                  |    3 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c               |    9 +---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c       |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c          |   31 +++++++++++++++-
 7 files changed, 39 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_smu.h
@@ -575,6 +575,7 @@ struct pptable_funcs {
 	int (*conv_power_profile_to_pplib_workload)(int power_profile);
 	uint32_t (*get_fan_control_mode)(struct smu_context *smu);
 	int (*set_fan_control_mode)(struct smu_context *smu, uint32_t mode);
+	int (*set_fan_speed_percent)(struct smu_context *smu, uint32_t speed);
 	int (*set_fan_speed_rpm)(struct smu_context *smu, uint32_t speed);
 	int (*set_xgmi_pstate)(struct smu_context *smu, uint32_t pstate);
 	int (*gfx_off_control)(struct smu_context *smu, bool enable);
--- a/drivers/gpu/drm/amd/pm/inc/smu_v11_0.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu_v11_0.h
@@ -200,6 +200,9 @@ int
 smu_v11_0_set_fan_control_mode(struct smu_context *smu,
 			       uint32_t mode);
 
+int
+smu_v11_0_set_fan_speed_percent(struct smu_context *smu, uint32_t speed);
+
 int smu_v11_0_set_fan_speed_rpm(struct smu_context *smu,
 				       uint32_t speed);
 
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2255,19 +2255,14 @@ int smu_get_fan_speed_percent(struct smu
 int smu_set_fan_speed_percent(struct smu_context *smu, uint32_t speed)
 {
 	int ret = 0;
-	uint32_t rpm;
 
 	if (!smu->pm_enabled || !smu->adev->pm.dpm_enabled)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&smu->mutex);
 
-	if (smu->ppt_funcs->set_fan_speed_rpm) {
-		if (speed > 100)
-			speed = 100;
-		rpm = speed * smu->fan_max_rpm / 100;
-		ret = smu->ppt_funcs->set_fan_speed_rpm(smu, rpm);
-	}
+	if (smu->ppt_funcs->set_fan_speed_percent)
+		ret = smu->ppt_funcs->set_fan_speed_percent(smu, speed);
 
 	mutex_unlock(&smu->mutex);
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2366,6 +2366,7 @@ static const struct pptable_funcs arctur
 	.display_clock_voltage_request = smu_v11_0_display_clock_voltage_request,
 	.get_fan_control_mode = smu_v11_0_get_fan_control_mode,
 	.set_fan_control_mode = smu_v11_0_set_fan_control_mode,
+	.set_fan_speed_percent = smu_v11_0_set_fan_speed_percent,
 	.set_fan_speed_rpm = smu_v11_0_set_fan_speed_rpm,
 	.set_xgmi_pstate = smu_v11_0_set_xgmi_pstate,
 	.gfx_off_control = smu_v11_0_gfx_off_control,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2710,6 +2710,7 @@ static const struct pptable_funcs navi10
 	.display_clock_voltage_request = smu_v11_0_display_clock_voltage_request,
 	.get_fan_control_mode = smu_v11_0_get_fan_control_mode,
 	.set_fan_control_mode = smu_v11_0_set_fan_control_mode,
+	.set_fan_speed_percent = smu_v11_0_set_fan_speed_percent,
 	.set_fan_speed_rpm = smu_v11_0_set_fan_speed_rpm,
 	.set_xgmi_pstate = smu_v11_0_set_xgmi_pstate,
 	.gfx_off_control = smu_v11_0_gfx_off_control,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2776,6 +2776,7 @@ static const struct pptable_funcs sienna
 	.display_clock_voltage_request = smu_v11_0_display_clock_voltage_request,
 	.get_fan_control_mode = smu_v11_0_get_fan_control_mode,
 	.set_fan_control_mode = smu_v11_0_set_fan_control_mode,
+	.set_fan_speed_percent = smu_v11_0_set_fan_speed_percent,
 	.set_fan_speed_rpm = smu_v11_0_set_fan_speed_rpm,
 	.set_xgmi_pstate = smu_v11_0_set_xgmi_pstate,
 	.gfx_off_control = smu_v11_0_gfx_off_control,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1123,6 +1123,35 @@ smu_v11_0_set_fan_static_mode(struct smu
 }
 
 int
+smu_v11_0_set_fan_speed_percent(struct smu_context *smu, uint32_t speed)
+{
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
+
+	if (speed > 100)
+		speed = 100;
+
+	if (smu_v11_0_auto_fan_control(smu, 0))
+		return -EINVAL;
+
+	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	if (!duty100)
+		return -EINVAL;
+
+	tmp64 = (uint64_t)speed * duty100;
+	do_div(tmp64, 100);
+	duty = (uint32_t)tmp64;
+
+	WREG32_SOC15(THM, 0, mmCG_FDO_CTRL0,
+		     REG_SET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL0),
+				   CG_FDO_CTRL0, FDO_STATIC_DUTY, duty));
+
+	return smu_v11_0_set_fan_static_mode(smu, FDO_PWM_MODE_STATIC);
+}
+
+int
 smu_v11_0_set_fan_control_mode(struct smu_context *smu,
 			       uint32_t mode)
 {
@@ -1130,7 +1159,7 @@ smu_v11_0_set_fan_control_mode(struct sm
 
 	switch (mode) {
 	case AMD_FAN_CTRL_NONE:
-		ret = smu_v11_0_set_fan_speed_rpm(smu, smu->fan_max_rpm);
+		ret = smu_v11_0_set_fan_speed_percent(smu, 100);
 		break;
 	case AMD_FAN_CTRL_MANUAL:
 		ret = smu_v11_0_auto_fan_control(smu, 0);


