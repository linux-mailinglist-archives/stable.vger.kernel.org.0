Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D61315E832
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404597AbgBNQ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:58:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbgBNQRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D98D24654;
        Fri, 14 Feb 2020 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697037;
        bh=jWqy65rsqNtV3mIs9sxF5cxBGVtDHBwnIDrhzjfLImM=;
        h=From:To:Cc:Subject:Date:From;
        b=NtBhOSfa7oQjeUhjK3mjYmp55M7UbqTHPd1mTKFGFaWjAnaBy9sS9e+IgolMoWtix
         aWiRwurXw+39U198uHYS6Tw53J7rYsCi2mmsSB7wu5HQIvphxruIR3wLQsZowYOglm
         oLA3s7kn+SAm54+GwjHnR6d/4PqqqBRYaMk/lA+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 001/186] drm/amdgpu: remove set but not used variable 'mc_shared_chmap' from 'gfx_v6_0.c' and 'gfx_v7_0.c'
Date:   Fri, 14 Feb 2020 11:14:10 -0500
Message-Id: <20200214161715.18113-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 747a397d394fac0001e4b3c03d7dce3a118af567 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c: In function
‘gfx_v6_0_constants_init’:
drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c:1579:6: warning: variable
‘mc_shared_chmap’ set but not used [-Wunused-but-set-variable]

drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c: In function
‘gfx_v7_0_gpu_early_init’:
drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c:4262:6: warning: variable
‘mc_shared_chmap’ set but not used [-Wunused-but-set-variable]

Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
Fixes: d93f3ca706b8 ("drm/amdgpu/gfx7: rework gpu_init()")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 3 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index dbbe986f90f29..4b724c1130290 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -1554,7 +1554,7 @@ static void gfx_v6_0_config_init(struct amdgpu_device *adev)
 static void gfx_v6_0_gpu_init(struct amdgpu_device *adev)
 {
 	u32 gb_addr_config = 0;
-	u32 mc_shared_chmap, mc_arb_ramcfg;
+	u32 mc_arb_ramcfg;
 	u32 sx_debug_1;
 	u32 hdp_host_path_cntl;
 	u32 tmp;
@@ -1656,7 +1656,6 @@ static void gfx_v6_0_gpu_init(struct amdgpu_device *adev)
 
 	WREG32(mmBIF_FB_EN, BIF_FB_EN__FB_READ_EN_MASK | BIF_FB_EN__FB_WRITE_EN_MASK);
 
-	mc_shared_chmap = RREG32(mmMC_SHARED_CHMAP);
 	adev->gfx.config.mc_arb_ramcfg = RREG32(mmMC_ARB_RAMCFG);
 	mc_arb_ramcfg = adev->gfx.config.mc_arb_ramcfg;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index 6f76b26464658..1703ace67b527 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -4345,7 +4345,7 @@ static int gfx_v7_0_late_init(void *handle)
 static void gfx_v7_0_gpu_early_init(struct amdgpu_device *adev)
 {
 	u32 gb_addr_config;
-	u32 mc_shared_chmap, mc_arb_ramcfg;
+	u32 mc_arb_ramcfg;
 	u32 dimm00_addr_map, dimm01_addr_map, dimm10_addr_map, dimm11_addr_map;
 	u32 tmp;
 
@@ -4422,7 +4422,6 @@ static void gfx_v7_0_gpu_early_init(struct amdgpu_device *adev)
 		break;
 	}
 
-	mc_shared_chmap = RREG32(mmMC_SHARED_CHMAP);
 	adev->gfx.config.mc_arb_ramcfg = RREG32(mmMC_ARB_RAMCFG);
 	mc_arb_ramcfg = adev->gfx.config.mc_arb_ramcfg;
 
-- 
2.20.1

