Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687E81C8EBA
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgEGO3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgEGO3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6867420936;
        Thu,  7 May 2020 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861742;
        bh=qQJ8XuGD1yqiYvBBlA+XTk9Ka7sBVbNnfFgy4ubIWrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJdrr8Zrai7DJiuWpxowo157HHyG+CGPCf9fhx+IDHebxJ68G0Xzr3mJD3t3Mmh9E
         0m+goOARxxZn3AIs1hFSDTipR83bQF22Wg/uOhm1s0XYCLpHsUnRlVQ5YEacn+TJuD
         7IvPZSplajp9BuJPHM8oVZPuYyFxdcaM6vy9W3DE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiecheng Zhou <Tiecheng.Zhou@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 25/35] drm/amd/powerplay: avoid using pm_en before it is initialized revised
Date:   Thu,  7 May 2020 10:28:19 -0400
Message-Id: <20200507142830.26239-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiecheng Zhou <Tiecheng.Zhou@amd.com>

[ Upstream commit 690ae30be163d5262feae01335b2a6f30569e5aa ]

hwmgr->pm_en is initialized at hwmgr_hw_init.

during amdgpu_device_init, there is amdgpu_asic_reset that calls to
soc15_asic_reset (for V320 usecase, Vega10 asic), in which:
1) soc15_asic_reset_method calls to pp_get_asic_baco_capability (pm_en)
2) soc15_asic_baco_reset calls to pp_set_asic_baco_state (pm_en)

pm_en is used in the above two cases while it has not yet been initialized

So avoid using pm_en in the above two functions for V320 passthrough.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Tiecheng Zhou <Tiecheng.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
index d306cc7119976..8bb5fbef7de0f 100644
--- a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
@@ -1425,7 +1425,8 @@ static int pp_get_asic_baco_capability(void *handle, bool *cap)
 	if (!hwmgr)
 		return -EINVAL;
 
-	if (!hwmgr->pm_en || !hwmgr->hwmgr_func->get_asic_baco_capability)
+	if (!(hwmgr->not_vf && amdgpu_dpm) ||
+		!hwmgr->hwmgr_func->get_asic_baco_capability)
 		return 0;
 
 	mutex_lock(&hwmgr->smu_lock);
@@ -1459,7 +1460,8 @@ static int pp_set_asic_baco_state(void *handle, int state)
 	if (!hwmgr)
 		return -EINVAL;
 
-	if (!hwmgr->pm_en || !hwmgr->hwmgr_func->set_asic_baco_state)
+	if (!(hwmgr->not_vf && amdgpu_dpm) ||
+		!hwmgr->hwmgr_func->set_asic_baco_state)
 		return 0;
 
 	mutex_lock(&hwmgr->smu_lock);
-- 
2.20.1

