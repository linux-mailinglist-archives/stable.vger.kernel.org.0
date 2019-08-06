Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D983C91
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfHFVeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfHFVeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06EA216F4;
        Tue,  6 Aug 2019 21:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127258;
        bh=SW2v2vdzS/8zPs2QA6T6uw7sxmgEWHGl2EshkHf2GcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZfkgAgNEh+TYfloj0ieIirFT+CmVa2Xh13EQRBkpA1abfTGOiWsKk7/fixWJvZt6
         r6108+q/IGhtOPNNceI/6ngKWgV7YQibXnqJyjoX0taRsCm01OonIRvTMzK/QposIo
         nMIP/xV/vcLM1rT+N/rvKpJyujVZCDpWbF7WYs4U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 30/59] drm/amd/powerplay: fix null pointer dereference around dpm state relates
Date:   Tue,  6 Aug 2019 17:32:50 -0400
Message-Id: <20190806213319.19203-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 479156f2e5540077377a823eaf5a4263bd329063 ]

DPM state relates are not supported on the new SW SMU ASICs. But still
it's not OK to trigger null pointer dereference on accessing them.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c     | 18 +++++++++++++-----
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c |  3 ++-
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index abeaab4bf1bc2..d55519bc34e52 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -144,12 +144,16 @@ static ssize_t amdgpu_get_dpm_state(struct device *dev,
 	struct amdgpu_device *adev = ddev->dev_private;
 	enum amd_pm_state_type pm;
 
-	if (is_support_sw_smu(adev) && adev->smu.ppt_funcs->get_current_power_state)
-		pm = amdgpu_smu_get_current_power_state(adev);
-	else if (adev->powerplay.pp_funcs->get_current_power_state)
+	if (is_support_sw_smu(adev)) {
+		if (adev->smu.ppt_funcs->get_current_power_state)
+			pm = amdgpu_smu_get_current_power_state(adev);
+		else
+			pm = adev->pm.dpm.user_state;
+	} else if (adev->powerplay.pp_funcs->get_current_power_state) {
 		pm = amdgpu_dpm_get_current_power_state(adev);
-	else
+	} else {
 		pm = adev->pm.dpm.user_state;
+	}
 
 	return snprintf(buf, PAGE_SIZE, "%s\n",
 			(pm == POWER_STATE_TYPE_BATTERY) ? "battery" :
@@ -176,7 +180,11 @@ static ssize_t amdgpu_set_dpm_state(struct device *dev,
 		goto fail;
 	}
 
-	if (adev->powerplay.pp_funcs->dispatch_tasks) {
+	if (is_support_sw_smu(adev)) {
+		mutex_lock(&adev->pm.mutex);
+		adev->pm.dpm.user_state = state;
+		mutex_unlock(&adev->pm.mutex);
+	} else if (adev->powerplay.pp_funcs->dispatch_tasks) {
 		amdgpu_dpm_dispatch_task(adev, AMD_PP_TASK_ENABLE_USER_STATE, &state);
 	} else {
 		mutex_lock(&adev->pm.mutex);
diff --git a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
index eec329ab60370..61a6d183c153f 100644
--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -63,7 +63,8 @@ int smu_get_power_num_states(struct smu_context *smu,
 
 	/* not support power state */
 	memset(state_info, 0, sizeof(struct pp_states_info));
-	state_info->nums = 0;
+	state_info->nums = 1;
+	state_info->states[0] = POWER_STATE_TYPE_DEFAULT;
 
 	return 0;
 }
-- 
2.20.1

