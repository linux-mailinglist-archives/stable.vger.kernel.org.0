Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D61C38E9F0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhEXOv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233761AbhEXOtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F293561261;
        Mon, 24 May 2021 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867658;
        bh=PzC1/aHqCfv71WlG8DDX9grk2xusdWHpo+JrJJTeOp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJgh0CeeDBoCgym8Pu3y2ErIIw9syTChWyemsQDGHbO8knf/Zx/3PTjz2ZzP53XoK
         735yc9dhMYdmJRILds+o0ngaKVXIANmkH5osExHZDir8KbNdT6t5vogHPhGDioP4uy
         uge7R+n7CLszYtkeTCtTAHqNyrDhRIzq+nPARpklSdPzG/VcREgiTOdeOuzZKacKnA
         OnPLADgt8P/V7qdagaA9heAS1u1GRH49kROkTCrOzBHrsyFFEjOJwq7BCC5OCYLdrP
         18sf71YwsOPdb2cveCMkvz8crvsglqw2RQFiE94sskV5VPMNbldM6dLLZcUBjlE+eU
         f8y16lZ1Vc0iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 60/63] drm/amdgpu: stop touching sched.ready in the backend
Date:   Mon, 24 May 2021 10:46:17 -0400
Message-Id: <20210524144620.2497249-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit a2b4785f01280a4291edb9fda69032fc2e4bfd3f ]

This unfortunately comes up in regular intervals and breaks
GPU reset for the engine in question.

The sched.ready flag controls if an engine can't get working
during hw_init, but should never be set to false during hw_fini.

v2: squash in unused variable fix (Alex)

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 2 --
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 2 --
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c | 5 -----
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c  | 8 +-------
 4 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index c6724a0e0c43..dc947c8ffe21 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -198,8 +198,6 @@ static int jpeg_v2_5_hw_fini(void *handle)
 		if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 		      RREG32_SOC15(JPEG, i, mmUVD_JRBC_STATUS))
 			jpeg_v2_5_set_powergating_state(adev, AMD_PG_STATE_GATE);
-
-		ring->sched.ready = false;
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index e8fbb2a0de34..1d354245678d 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -166,8 +166,6 @@ static int jpeg_v3_0_hw_fini(void *handle)
 	      RREG32_SOC15(JPEG, 0, mmUVD_JRBC_STATUS))
 		jpeg_v3_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
 
-	ring->sched.ready = false;
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 690a5090475a..32c6aa03d267 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -470,11 +470,6 @@ static void sdma_v5_2_gfx_stop(struct amdgpu_device *adev)
 		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
 		WREG32(sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_IB_CNTL), ib_cntl);
 	}
-
-	sdma0->sched.ready = false;
-	sdma1->sched.ready = false;
-	sdma2->sched.ready = false;
-	sdma3->sched.ready = false;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 9b844e9fb16f..ebbc04ff5da0 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -368,7 +368,7 @@ static int vcn_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct amdgpu_ring *ring;
-	int i, j;
+	int i;
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
@@ -383,12 +383,6 @@ static int vcn_v3_0_hw_fini(void *handle)
 				vcn_v3_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
 			}
 		}
-		ring->sched.ready = false;
-
-		for (j = 0; j < adev->vcn.num_enc_rings; ++j) {
-			ring = &adev->vcn.inst[i].ring_enc[j];
-			ring->sched.ready = false;
-		}
 	}
 
 	return 0;
-- 
2.30.2

