Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4658E47B749
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhLUB6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhLUB6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:58:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B012C06175C;
        Mon, 20 Dec 2021 17:58:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308D3B81100;
        Tue, 21 Dec 2021 01:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CBAC36AE5;
        Tue, 21 Dec 2021 01:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051915;
        bh=Q+SZIjdUVNrKMWQVHn+2qgzolBOtmVNaIVwqy4ymAns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7FpfDwbyaUnusMdsiaG9mMyijofWBCY/YPNyRP2fPusq3gSiv7qffLoEf7MFW6Vs
         tS28f1GzwojF+O1tUtZcqG4XhNcDrshQN5q72C2ZVF8QupIkFVPuJK15rWuoNNGFm0
         zWyjlvTbvwm2XeOSQyyNxfXq3eB41q4Uc/DXxKxqtel0ctvr1aObB/EQx/LLJz1sBj
         k5TsOkP/koEMMF1Dz8CEfTORC/lwfGuKjvHLcT59PWR6x+HqamcnvhGomabwzeZTEo
         4WRVMcg8cG/nvbo6q0zQkWkxueabG3YApkTL0tFGSNThTSmSp69w9X27WcGCkBUX1F
         Hu/OkHugV7OAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, Guchun Chen <guchun.chen@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, Oak.Zeng@amd.com,
        rajneesh.bhardwaj@amd.com, Likun.Gao@amd.com, alex.sierra@amd.com,
        Harish.Kasiviswanathan@amd.com, Dennis.Li@amd.com,
        lijo.lazar@amd.com, darren.powell@amd.com,
        jinhuieric.huang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 19/29] drm/amdgpu: correct the wrong cached state for GMC on PICASSO
Date:   Mon, 20 Dec 2021 20:57:40 -0500
Message-Id: <20211221015751.116328-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 17c65d6fca844ee72a651944d8ce721e9040bf70 ]

Pair the operations did in GMC ->hw_init and ->hw_fini. That
can help to maintain correct cached state for GMC and avoid
unintention gate operation dropping due to wrong cached state.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1828

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c            | 8 ++++++++
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c          | 8 ++++----
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 7 ++++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 5551359d5dfdc..398596aac8ca5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1802,6 +1802,14 @@ static int gmc_v9_0_hw_fini(void *handle)
 		return 0;
 	}
 
+	/*
+	 * Pair the operations did in gmc_v9_0_hw_init and thus maintain
+	 * a correct cached state for GMC. Otherwise, the "gate" again
+	 * operation on S3 resuming will fail due to wrong cached state.
+	 */
+	if (adev->mmhub.funcs->update_power_gating)
+		adev->mmhub.funcs->update_power_gating(adev, false);
+
 	amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index a99953833820e..3ef5e368d125d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -302,10 +302,10 @@ static void mmhub_v1_0_update_power_gating(struct amdgpu_device *adev,
 	if (amdgpu_sriov_vf(adev))
 		return;
 
-	if (enable && adev->pg_flags & AMD_PG_SUPPORT_MMHUB) {
-		amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GMC, true);
-
-	}
+	if (adev->pg_flags & AMD_PG_SUPPORT_MMHUB)
+		amdgpu_dpm_set_powergating_by_smu(adev,
+						  AMD_IP_BLOCK_TYPE_GMC,
+						  enable);
 }
 
 static int mmhub_v1_0_gart_enable(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 321215003643b..69f67206b5b5a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -1332,7 +1332,12 @@ static int pp_set_powergating_by_smu(void *handle,
 		pp_dpm_powergate_vce(handle, gate);
 		break;
 	case AMD_IP_BLOCK_TYPE_GMC:
-		pp_dpm_powergate_mmhub(handle);
+		/*
+		 * For now, this is only used on PICASSO.
+		 * And only "gate" operation is supported.
+		 */
+		if (gate)
+			pp_dpm_powergate_mmhub(handle);
 		break;
 	case AMD_IP_BLOCK_TYPE_GFX:
 		ret = pp_dpm_powergate_gfx(handle, gate);
-- 
2.34.1

