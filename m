Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B51F29BA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgFIADl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731215AbgFHXVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91D7120872;
        Mon,  8 Jun 2020 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658508;
        bh=tL/acNf1vHtTAwCq0RaBlHXUprEJKc6+sPNDpB+oLs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QMjTcHNlMz/TSom2mL1W4o5WXs3gwyHs+AYBDQVMLINBbB5Px3Ip0tl52vank/XO
         G9R2uY6CazapOJz91wpmV82ZLDc2v/3o7RP53Dul3f8Pyjb3GiVuZApTURoT70jiwo
         yYb1hSdQ8wRpbGfCkjxZ7Lhdqo7j4VILldJIcpt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     chen gong <curry.gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 138/175] drm/amd/powerpay: Disable gfxoff when setting manual mode on picasso and raven
Date:   Mon,  8 Jun 2020 19:18:11 -0400
Message-Id: <20200608231848.3366970-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chen gong <curry.gong@amd.com>

[ Upstream commit cbd2d08c7463e78d625a69e9db27ad3004cbbd99 ]

[Problem description]
1. Boot up picasso platform, launches desktop, Don't do anything (APU enter into "gfxoff" state)
2. Remote login to platform using SSH, then type the command line:
	sudo su -c "echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level"
	sudo su -c "echo 2 > /sys/class/drm/card0/device/pp_dpm_sclk" (fix SCLK to 1400MHz)
3. Move the mouse around in Window
4. Phenomenon :  The screen frozen

Tester will switch sclk level during glmark2 run time.
APU will enter "gfxoff" state intermittently during glmark2 run time.
The system got hanged if fix GFXCLK to 1400MHz when APU is in "gfxoff"
state.

[Debug]
1. Fix SCLK to X MHz
	1400: screen frozen, screen black, then OS will reboot.
	1300: screen frozen.
	1200: screen frozen, screen black.
	1100: screen frozen, screen black, then OS will reboot.
	1000: screen frozen, screen black.
	900:  screen frozen, screen black, then OS will reboot.
	800:  Situation Nomal, issue disappear.
	700:  Situation Nomal, issue disappear.
2. SBIOS setting: AMD CBS --> SMU Debug Options -->SMU Debug --> "GFX DLDO Psm Margin Control":
	50 : Situation Nomal, issue disappear.
	45 : Situation Nomal, issue disappear.
	40 : Situation Nomal, issue disappear.
	35 : Situation Nomal, issue disappear.
	30 : screen black.
	25 : screen frozen, then blurred screen.
	20 : screen frozen.
	15 : screen black.
	10 : screen frozen.
	5  : screen frozen, then blurred screen.
3. Disable GFXOFF feature
	Situation Nomal, issue disappear.

[Why]
Through a period of time debugging with Sys Eng team and SMU team, Sys
Eng team said this is voltage/frequency marginal issue not a F/W or H/W
bug. This experiment proves that default targetPsm [for f=1400MHz] is
not sufficient when GFXOFF is enabled on Picasso.

SMU team think it is an odd test conditions to force sclk="1400MHz" when
GPU is in "gfxoff" state，then wake up the GFX. SCLK should be in the
"lowest frequency" when gfxoff.

[How]
Disable gfxoff when setting manual mode.
Enable gfxoff when setting other mode(exiting manual mode) again.

By the way, from the user point of view, now that user switch to manual
mode and force SCLK Frequency, he don't want SCLK be controlled by
workload.It becomes meaningless to "switch to manual mode" if APU enter "gfxoff"
due to lack of workload at this point.

Tips: Same issue observed on Raven.

Signed-off-by: chen gong <curry.gong@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index c8008b956363..d1d2372ab7ca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -370,6 +370,15 @@ static ssize_t amdgpu_set_dpm_forced_performance_level(struct device *dev,
 	if (current_level == level)
 		return count;
 
+	if (adev->asic_type == CHIP_RAVEN) {
+		if (adev->rev_id < 8) {
+			if (current_level != AMD_DPM_FORCED_LEVEL_MANUAL && level == AMD_DPM_FORCED_LEVEL_MANUAL)
+				amdgpu_gfx_off_ctrl(adev, false);
+			else if (current_level == AMD_DPM_FORCED_LEVEL_MANUAL && level != AMD_DPM_FORCED_LEVEL_MANUAL)
+				amdgpu_gfx_off_ctrl(adev, true);
+		}
+	}
+
 	/* profile_exit setting is valid only when current mode is in profile mode */
 	if (!(current_level & (AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD |
 	    AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK |
-- 
2.25.1

