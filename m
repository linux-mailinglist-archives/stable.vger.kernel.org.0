Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A783C126B71
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfLSS4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbfLSS4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC3224686;
        Thu, 19 Dec 2019 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781791;
        bh=koKJOmEYS1nYWq4ANIfkqGMN3gOkYyH6HUI+i/HxEvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N84MPu4Hx2NSwfSAJLDBv9QXDLNM+x4rq97yl0YQ/lbF+0CkgIN709gXAIyvnpDrz
         kjwLqXDip8OdH6Ve91cB2d4uGSdTND9VwSiUGwMfefSCZnjIpEQBJj6vFEMaCIlSxx
         BEuD/yK8j/Dl1not6Yk8PQxYS3mikspuudbQ6/og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 75/80] drm/amdgpu: invalidate mmhub semaphore workaround in gmc9/gmc10
Date:   Thu, 19 Dec 2019 19:35:07 +0100
Message-Id: <20191219183145.075534320@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changzhu <Changfeng.Zhu@amd.com>

commit f920d1bb9c4e77efb08c41d70b6d442f46fd8902 upstream.

It may lose gpuvm invalidate acknowldege state across power-gating off
cycle. To avoid this issue in gmc9/gmc10 invalidation, add semaphore acquire
before invalidation and semaphore release after invalidation.

After adding semaphore acquire before invalidation, the semaphore
register become read-only if another process try to acquire semaphore.
Then it will not be able to release this semaphore. Then it may cause
deadlock problem. If this deadlock problem happens, it needs a semaphore
firmware fix.

Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |   57 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  |   57 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/soc15.h     |    4 +-
 3 files changed, 116 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -235,6 +235,29 @@ static void gmc_v10_0_flush_vm_hub(struc
 	const unsigned eng = 17;
 	unsigned int i;
 
+	spin_lock(&adev->gmc.invalidate_lock);
+	/*
+	 * It may lose gpuvm invalidate acknowldege state across power-gating
+	 * off cycle, add semaphore acquire before invalidation and semaphore
+	 * release after invalidation to avoid entering power gated state
+	 * to WA the Issue
+	 */
+
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (vmhub == AMDGPU_MMHUB_0 ||
+	    vmhub == AMDGPU_MMHUB_1) {
+		for (i = 0; i < adev->usec_timeout; i++) {
+			/* a read return value of 1 means semaphore acuqire */
+			tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng);
+			if (tmp & 0x1)
+				break;
+			udelay(1);
+		}
+
+		if (i >= adev->usec_timeout)
+			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
+	}
+
 	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, tmp);
 
 	/*
@@ -254,6 +277,17 @@ static void gmc_v10_0_flush_vm_hub(struc
 		udelay(1);
 	}
 
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (vmhub == AMDGPU_MMHUB_0 ||
+	    vmhub == AMDGPU_MMHUB_1)
+		/*
+		 * add semaphore release after invalidation,
+		 * write with 0 means semaphore release
+		 */
+		WREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng, 0);
+
+	spin_unlock(&adev->gmc.invalidate_lock);
+
 	if (i < adev->usec_timeout)
 		return;
 
@@ -338,6 +372,20 @@ static uint64_t gmc_v10_0_emit_flush_gpu
 	uint32_t req = gmc_v10_0_get_invalidate_req(vmid, 0);
 	unsigned eng = ring->vm_inv_eng;
 
+	/*
+	 * It may lose gpuvm invalidate acknowldege state across power-gating
+	 * off cycle, add semaphore acquire before invalidation and semaphore
+	 * release after invalidation to avoid entering power gated state
+	 * to WA the Issue
+	 */
+
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+		/* a read return value of 1 means semaphore acuqire */
+		amdgpu_ring_emit_reg_wait(ring,
+					  hub->vm_inv_eng0_sem + eng, 0x1, 0x1);
+
 	amdgpu_ring_emit_wreg(ring, hub->ctx0_ptb_addr_lo32 + (2 * vmid),
 			      lower_32_bits(pd_addr));
 
@@ -348,6 +396,15 @@ static uint64_t gmc_v10_0_emit_flush_gpu
 					    hub->vm_inv_eng0_ack + eng,
 					    req, 1 << vmid);
 
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+		/*
+		 * add semaphore release after invalidation,
+		 * write with 0 means semaphore release
+		 */
+		amdgpu_ring_emit_wreg(ring, hub->vm_inv_eng0_sem + eng, 0);
+
 	return pd_addr;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -491,6 +491,29 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 	}
 
 	spin_lock(&adev->gmc.invalidate_lock);
+
+	/*
+	 * It may lose gpuvm invalidate acknowldege state across power-gating
+	 * off cycle, add semaphore acquire before invalidation and semaphore
+	 * release after invalidation to avoid entering power gated state
+	 * to WA the Issue
+	 */
+
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (vmhub == AMDGPU_MMHUB_0 ||
+	    vmhub == AMDGPU_MMHUB_1) {
+		for (j = 0; j < adev->usec_timeout; j++) {
+			/* a read return value of 1 means semaphore acuqire */
+			tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng);
+			if (tmp & 0x1)
+				break;
+			udelay(1);
+		}
+
+		if (j >= adev->usec_timeout)
+			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
+	}
+
 	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, tmp);
 
 	/*
@@ -506,7 +529,18 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 			break;
 		udelay(1);
 	}
+
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (vmhub == AMDGPU_MMHUB_0 ||
+	    vmhub == AMDGPU_MMHUB_1)
+		/*
+		 * add semaphore release after invalidation,
+		 * write with 0 means semaphore release
+		 */
+		WREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng, 0);
+
 	spin_unlock(&adev->gmc.invalidate_lock);
+
 	if (j < adev->usec_timeout)
 		return;
 
@@ -521,6 +555,20 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 	uint32_t req = gmc_v9_0_get_invalidate_req(vmid, 0);
 	unsigned eng = ring->vm_inv_eng;
 
+	/*
+	 * It may lose gpuvm invalidate acknowldege state across power-gating
+	 * off cycle, add semaphore acquire before invalidation and semaphore
+	 * release after invalidation to avoid entering power gated state
+	 * to WA the Issue
+	 */
+
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+		/* a read return value of 1 means semaphore acuqire */
+		amdgpu_ring_emit_reg_wait(ring,
+					  hub->vm_inv_eng0_sem + eng, 0x1, 0x1);
+
 	amdgpu_ring_emit_wreg(ring, hub->ctx0_ptb_addr_lo32 + (2 * vmid),
 			      lower_32_bits(pd_addr));
 
@@ -531,6 +579,15 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 					    hub->vm_inv_eng0_ack + eng,
 					    req, 1 << vmid);
 
+	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
+	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+		/*
+		 * add semaphore release after invalidation,
+		 * write with 0 means semaphore release
+		 */
+		amdgpu_ring_emit_wreg(ring, hub->vm_inv_eng0_sem + eng, 0);
+
 	return pd_addr;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/soc15.h
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.h
@@ -28,8 +28,8 @@
 #include "nbio_v7_0.h"
 #include "nbio_v7_4.h"
 
-#define SOC15_FLUSH_GPU_TLB_NUM_WREG		4
-#define SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT	1
+#define SOC15_FLUSH_GPU_TLB_NUM_WREG		6
+#define SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT	3
 
 extern const struct amd_ip_funcs soc15_common_ip_funcs;
 


