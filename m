Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838553AA005
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhFPPoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235476AbhFPPmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 343E0613BD;
        Wed, 16 Jun 2021 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857874;
        bh=KEn+BrAL7HcuxfY0qjHMLmBIi25/yKl2/NG/iX7SUbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiF7FPVQ0MA5h/eAcS3msx/5e2TWEdWCGjSii8R6+0UkF75ihDJhQLk3OdcpdyXl7
         4wR111xn0rm2/vqQuuQpYkgcaBsBvEJOliRkRfOwSCjJ4qBmGh4eZO8S59U6NzGuwg
         IPxSnZiH0B5ns0MllVqpcneF6QYz9fRUkIkzrNIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Zhao <Victor.Zhao@amd.com>,
        Jingwen Chen <Jingwen.Chen2@amd.com>,
        Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 44/48] drm/amd/amdgpu:save psp ring wptr to avoid attack
Date:   Wed, 16 Jun 2021 17:33:54 +0200
Message-Id: <20210616152838.032034749@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cb50ba445f8c..0fd62a8e68c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -76,6 +76,7 @@ struct psp_ring
 	uint64_t			ring_mem_mc_addr;
 	void				*ring_mem_handle;
 	uint32_t			ring_size;
+	uint32_t			ring_wptr;
 };
 
 /* More registers may will be supported */
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index c325d6f53a71..d39735a89a25 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -720,7 +720,7 @@ static uint32_t psp_v11_0_ring_get_wptr(struct psp_context *psp)
 	struct amdgpu_device *adev = psp->adev;
 
 	if (amdgpu_sriov_vf(adev))
-		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_102);
+		data = psp->km_ring.ring_wptr;
 	else
 		data = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_67);
 
@@ -734,6 +734,7 @@ static void psp_v11_0_ring_set_wptr(struct psp_context *psp, uint32_t value)
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



