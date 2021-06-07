Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A4739E2AC
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhFGQSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231262AbhFGQQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD69613C5;
        Mon,  7 Jun 2021 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082444;
        bh=mL38B8L7m3iyZWRiJ81ZaCsFglFCjp7zhCV2YQ7Q84w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GG/SfNgSyMHl4PdwM15yR1Z4Zq0GAECUUV3BjTrryTIdxcbCYAU1NP39V84Cnugul
         jRPOHBAKKxLETQDAUnw62XtpLLcq8hnjW1joVJTRN7jpM1u+fS0+0AjOyBhTYd4m2b
         vFH5EByoDYHGR+lvHbbOMArqmZB88LzX5CGZ/HkjUjAW2GBjo0WLHwsV2sTKL3bkgm
         R0ZD0Wwv3JoEazO9R6Qc602Jx03Z7FY6FlopxWRKEoHcKy4GzZid9wp2xP+D5Hs4r/
         0TDblZkp5yFb6NV5ELB16MZvUK2elYb/KI968ztDn3QHeUoiljt1Sn/RwEJE6br/5d
         /L2Jg9gRxlZdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Zhao <Victor.Zhao@amd.com>,
        Jingwen Chen <Jingwen.Chen2@amd.com>,
        Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 35/39] drm/amd/amdgpu:save psp ring wptr to avoid attack
Date:   Mon,  7 Jun 2021 12:13:14 -0400
Message-Id: <20210607161318.3583636-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit 2370eba9f552eaae3d8aa1f70b8e9eec5c560f9e ]

[Why]
When some tools performing psp mailbox attack, the readback value
of register can be a random value which may break psp.

[How]
Use a psp wptr cache machanism to aovid the change made by attack.

v2: unify change and add detailed reason

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Monk Liu <monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h | 1 +
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c  | 3 ++-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c   | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index 919d2fb7427b..60b7563f4c05 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -73,6 +73,7 @@ struct psp_ring
 	uint64_t			ring_mem_mc_addr;
 	void				*ring_mem_handle;
 	uint32_t			ring_size;
+	uint32_t			ring_wptr;
 };
 
 /* More registers may will be supported */
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 6c5d9612abcb..cb764b554552 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -732,7 +732,7 @@ static uint32_t psp_v11_0_ring_get_wptr(struct psp_context *psp)
 	struct amdgpu_device *adev = psp->adev;
 
 	if (amdgpu_sriov_vf(adev))
-		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_102);
+		data = psp->km_ring.ring_wptr;
 	else
 		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_67);
 
@@ -746,6 +746,7 @@ static void psp_v11_0_ring_set_wptr(struct psp_context *psp, uint32_t value)
 	if (amdgpu_sriov_vf(adev)) {
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_102, value);
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_101, GFX_CTRL_CMD_ID_CONSUME_CMD);
+		psp->km_ring.ring_wptr = value;
 	} else
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_67, value);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
index f2e725f72d2f..908664a5774b 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
@@ -379,7 +379,7 @@ static uint32_t psp_v3_1_ring_get_wptr(struct psp_context *psp)
 	struct amdgpu_device *adev = psp->adev;
 
 	if (amdgpu_sriov_vf(adev))
-		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_102);
+		data = psp->km_ring.ring_wptr;
 	else
 		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_67);
 	return data;
@@ -394,6 +394,7 @@ static void psp_v3_1_ring_set_wptr(struct psp_context *psp, uint32_t value)
 		/* send interrupt to PSP for SRIOV ring write pointer update */
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_101,
 			GFX_CTRL_CMD_ID_CONSUME_CMD);
+		psp->km_ring.ring_wptr = value;
 	} else
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_67, value);
 }
-- 
2.30.2

