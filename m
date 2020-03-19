Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA97F18B5E1
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgCSNWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgCSNWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B46F208D6;
        Thu, 19 Mar 2020 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624134;
        bh=fk9fQzxJWVAvDod5jdw7cSQ5EFdgFd7DJhHuctujlgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wG3fG4V7TMRNJy68NJdlSy4IrVqXCGMjCRnf8mBGb/1SNKKfGUCJvmBVf2Wu5Tjd6
         8sRlD56Bgzk5/gLnvK0U1xDrHziq8GZo8bkfobEREKMcerVmHChw/Zdly6z/N3gVUB
         JDq99XOgfJ7P6069EVWkhFMdn//OwM6mJkOLsn4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Yong Zhao <Yong.Zhao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/60] drm/amdgpu: Fix TLB invalidation request when using semaphore
Date:   Thu, 19 Mar 2020 14:03:41 +0100
Message-Id: <20200319123920.270688305@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 37c58ddf57364d1a636850bb8ba6acbe1e16195e ]

Use a more meaningful variable name for the invalidation request
that is distinct from the tmp variable that gets overwritten when
acquiring the invalidation semaphore.

Fixes: 4ed8a03740d0 ("drm/amdgpu: invalidate mmhub semaphore workaround in gmc9/gmc10")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Yong Zhao <Yong.Zhao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c | 5 +++--
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index a7ba4c6cf7a1c..f642e066e67a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -230,7 +230,8 @@ static void gmc_v10_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 				   unsigned int vmhub, uint32_t flush_type)
 {
 	struct amdgpu_vmhub *hub = &adev->vmhub[vmhub];
-	u32 tmp = gmc_v10_0_get_invalidate_req(vmid, flush_type);
+	u32 inv_req = gmc_v10_0_get_invalidate_req(vmid, flush_type);
+	u32 tmp;
 	/* Use register 17 for GART */
 	const unsigned eng = 17;
 	unsigned int i;
@@ -258,7 +259,7 @@ static void gmc_v10_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
 	}
 
-	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, tmp);
+	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, inv_req);
 
 	/*
 	 * Issue a dummy read to wait for the ACK register to be cleared
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index da53a55bf955b..688111ef814de 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -487,13 +487,13 @@ static void gmc_v9_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 {
 	bool use_semaphore = gmc_v9_0_use_invalidate_semaphore(adev, vmhub);
 	const unsigned eng = 17;
-	u32 j, tmp;
+	u32 j, inv_req, tmp;
 	struct amdgpu_vmhub *hub;
 
 	BUG_ON(vmhub >= adev->num_vmhubs);
 
 	hub = &adev->vmhub[vmhub];
-	tmp = gmc_v9_0_get_invalidate_req(vmid, flush_type);
+	inv_req = gmc_v9_0_get_invalidate_req(vmid, flush_type);
 
 	/* This is necessary for a HW workaround under SRIOV as well
 	 * as GFXOFF under bare metal
@@ -504,7 +504,7 @@ static void gmc_v9_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 		uint32_t req = hub->vm_inv_eng0_req + eng;
 		uint32_t ack = hub->vm_inv_eng0_ack + eng;
 
-		amdgpu_virt_kiq_reg_write_reg_wait(adev, req, ack, tmp,
+		amdgpu_virt_kiq_reg_write_reg_wait(adev, req, ack, inv_req,
 				1 << vmid);
 		return;
 	}
@@ -532,7 +532,7 @@ static void gmc_v9_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
 	}
 
-	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, tmp);
+	WREG32_NO_KIQ(hub->vm_inv_eng0_req + eng, inv_req);
 
 	/*
 	 * Issue a dummy read to wait for the ACK register to be cleared
-- 
2.20.1



