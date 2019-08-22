Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04A699A96
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbfHVRIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390506AbfHVRIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:50 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33434233FE;
        Thu, 22 Aug 2019 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493729;
        bh=SW2v2vdzS/8zPs2QA6T6uw7sxmgEWHGl2EshkHf2GcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/2SOEnDAALnm8ISxRMeXaKGTApY+uS9CC77xQVaKXpno3VS2gy1lj46opYHfWdWs
         pbAcEHlmG4G0lfttSWpD2YG7k4Ytov7kqPoxIaGRvccvEGtPj9Tipfqg1lw36sGOSm
         7LLiYCFxEpUlMQQfVQrFKI47QXC3+1cGCc8f0dQU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 064/135] drm/amd/powerplay: fix null pointer dereference around dpm state relates
Date:   Thu, 22 Aug 2019 13:07:00 -0400
Message-Id: <20190822170811.13303-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
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

