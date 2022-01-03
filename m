Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0B4835D8
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiACRaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59640 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiACR33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A310C61169;
        Mon,  3 Jan 2022 17:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B43C36AF0;
        Mon,  3 Jan 2022 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230968;
        bh=Szb9TvzsCywHF4L0vx7zk+gn/LMnbJj7FKMxDHllITc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rld9iMYk09N8oOEtEoS44qYoZaKnFzimdKVrZDss6JCP/o5j7usL2h0cMtBKFh+d7
         RkYcJo0KfgPb7cdgYvnp7pwrRQ4g7FQRxFoKKpynv87RXhCArHfCZrUvXclnNe7ykz
         lAWgc35bujMT5b+FHt9MIn6OwBjybqgFpPwAPWlS0aNVxDAdtZOPPK6MPzkT/1UnIV
         iilubnUMKILP2dM6E4THeuMWE77ccnG0pKG0ImlUY1fH0Pv8qLWULLGVNgIKv6Xrxh
         tN0XK20TG4rFBjC7xaVKs8+jST2qgVvRfKe2zifQgRHDsr1OVwRKGTrcX3AMiV100A
         0KTZNpwXSGkOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prike Liang <Prike.Liang@amd.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, darren.powell@amd.com, ray.huang@amd.com,
        Xiaojian.Du@amd.com, Arunpravin.PaneerSelvam@amd.com,
        Lang.Yu@amd.com, kevin1.wang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 09/16] drm/amd/pm: skip setting gfx cgpg in the s0ix suspend-resume
Date:   Mon,  3 Jan 2022 12:28:42 -0500
Message-Id: <20220103172849.1612731-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 8c45096c60d6ce6341c374636100ed1b2c1c33a1 ]

In the s0ix entry need retain gfx in the gfxoff state,so here need't
set gfx cgpg in the S0ix suspend-resume process. Moreover move the S0ix
check into SMU12 can simplify the code condition check.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1712
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c      | 7 ++-----
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c | 3 ++-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 04863a7971155..30ee8819587e2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1536,9 +1536,7 @@ static int smu_suspend(void *handle)
 
 	smu->watermarks_bitmap &= ~(WATERMARKS_LOADED);
 
-	/* skip CGPG when in S0ix */
-	if (smu->is_apu && !adev->in_s0ix)
-		smu_set_gfx_cgpg(&adev->smu, false);
+	smu_set_gfx_cgpg(&adev->smu, false);
 
 	return 0;
 }
@@ -1569,8 +1567,7 @@ static int smu_resume(void *handle)
 		return ret;
 	}
 
-	if (smu->is_apu)
-		smu_set_gfx_cgpg(&adev->smu, true);
+	smu_set_gfx_cgpg(&adev->smu, true);
 
 	smu->disable_uclk_switch = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
index 43028f2cd28b5..9c91e79c955fb 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
@@ -120,7 +120,8 @@ int smu_v12_0_powergate_sdma(struct smu_context *smu, bool gate)
 
 int smu_v12_0_set_gfx_cgpg(struct smu_context *smu, bool enable)
 {
-	if (!(smu->adev->pg_flags & AMD_PG_SUPPORT_GFX_PG))
+	/* Until now the SMU12 only implemented for Renoir series so here neen't do APU check. */
+	if (!(smu->adev->pg_flags & AMD_PG_SUPPORT_GFX_PG) || smu->adev->in_s0ix)
 		return 0;
 
 	return smu_cmn_send_smc_msg_with_param(smu,
-- 
2.34.1

