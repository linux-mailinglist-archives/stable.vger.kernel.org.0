Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106F3201215
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393443AbgFSPZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393018AbgFSPZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D2920734;
        Fri, 19 Jun 2020 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580335;
        bh=X9M32Bh0nXxv5LYujkA9sCqehA1ijPRpYu/JYe4UznQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLM1GexaBp9Qu158dBsb83dSJVkPdxucju/IZOE8dJq/Oz84HchC1QUJiVTtDUDtW
         KuUF9XBPSy3NTMLk819LyAvjlQPP/FHGLoi53HUOZkuF1BaGixgV3fHL6XX+01pkA2
         OYRgJnxrjYh+xDr2vaimCUvLOhU34L9rJq5TLwk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chen gong <curry.gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 209/376] drm/amd/powerpay: Disable gfxoff when setting manual mode on picasso and raven
Date:   Fri, 19 Jun 2020 16:32:07 +0200
Message-Id: <20200619141720.229972974@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 49e2e43f2e4a..532f4d908b8d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -383,6 +383,15 @@ static ssize_t amdgpu_set_dpm_forced_performance_level(struct device *dev,
 		return count;
 	}
 
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



