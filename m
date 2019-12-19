Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A5126B78
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfLSS4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730856AbfLSS4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B907E24683;
        Thu, 19 Dec 2019 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781803;
        bh=bqb3iaVoJpmGesz4/Y6RO3W0H0hExgE1h5Kixb2dGiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Igx5iIyMCetFtcucAhib5OG6UGgjGlhA5PYllMJOmeKY3KXzPGl0vWc6o7JiqZ9yj
         QN62J9KLqtM5s4PfPVqiK79mlhoNfk5xtbWtEcje4pNlAGhJl1AP9V4yUbykxbfyxq
         pZ4FWD8NPkRTgzso0+NlPmQFXT23+gkR/CIFqnTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 80/80] drm/amdgpu: add invalidate semaphore limit for SRIOV and picasso in gmc9
Date:   Thu, 19 Dec 2019 19:35:12 +0100
Message-Id: <20191219183149.891190701@linuxfoundation.org>
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

commit 90f6452ca58d436de4f69b423ecd75a109aa9766 upstream.

It may fail to load guest driver in round 2 or cause Xstart problem
when using invalidate semaphore for SRIOV or picasso. So it needs avoid
using invalidate semaphore for SRIOV and picasso.

Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   44 ++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -448,6 +448,24 @@ static uint32_t gmc_v9_0_get_invalidate_
 	return req;
 }
 
+/**
+ * gmc_v9_0_use_invalidate_semaphore - judge whether to use semaphore
+ *
+ * @adev: amdgpu_device pointer
+ * @vmhub: vmhub type
+ *
+ */
+static bool gmc_v9_0_use_invalidate_semaphore(struct amdgpu_device *adev,
+				       uint32_t vmhub)
+{
+	return ((vmhub == AMDGPU_MMHUB_0 ||
+		 vmhub == AMDGPU_MMHUB_1) &&
+		(!amdgpu_sriov_vf(adev)) &&
+		(!(adev->asic_type == CHIP_RAVEN &&
+		   adev->rev_id < 0x8 &&
+		   adev->pdev->device == 0x15d8)));
+}
+
 /*
  * GART
  * VMID 0 is the physical GPU addresses as used by the kernel.
@@ -467,6 +485,7 @@ static uint32_t gmc_v9_0_get_invalidate_
 static void gmc_v9_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 					uint32_t vmhub, uint32_t flush_type)
 {
+	bool use_semaphore = gmc_v9_0_use_invalidate_semaphore(adev, vmhub);
 	const unsigned eng = 17;
 	u32 j, tmp;
 	struct amdgpu_vmhub *hub;
@@ -500,11 +519,7 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 	 */
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if ((vmhub == AMDGPU_MMHUB_0 ||
-	     vmhub == AMDGPU_MMHUB_1) &&
-	    (!(adev->asic_type == CHIP_RAVEN &&
-	       adev->rev_id < 0x8 &&
-	       adev->pdev->device == 0x15d8))) {
+	if (use_semaphore) {
 		for (j = 0; j < adev->usec_timeout; j++) {
 			/* a read return value of 1 means semaphore acuqire */
 			tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng);
@@ -534,11 +549,7 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 	}
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if ((vmhub == AMDGPU_MMHUB_0 ||
-	     vmhub == AMDGPU_MMHUB_1) &&
-	    (!(adev->asic_type == CHIP_RAVEN &&
-	       adev->rev_id < 0x8 &&
-	       adev->pdev->device == 0x15d8)))
+	if (use_semaphore)
 		/*
 		 * add semaphore release after invalidation,
 		 * write with 0 means semaphore release
@@ -556,6 +567,7 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 static uint64_t gmc_v9_0_emit_flush_gpu_tlb(struct amdgpu_ring *ring,
 					    unsigned vmid, uint64_t pd_addr)
 {
+	bool use_semaphore = gmc_v9_0_use_invalidate_semaphore(ring->adev, ring->funcs->vmhub);
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vmhub *hub = &adev->vmhub[ring->funcs->vmhub];
 	uint32_t req = gmc_v9_0_get_invalidate_req(vmid, 0);
@@ -569,11 +581,7 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 	 */
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if ((ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
-	     ring->funcs->vmhub == AMDGPU_MMHUB_1) &&
-	    (!(adev->asic_type == CHIP_RAVEN &&
-	       adev->rev_id < 0x8 &&
-	       adev->pdev->device == 0x15d8)))
+	if (use_semaphore)
 		/* a read return value of 1 means semaphore acuqire */
 		amdgpu_ring_emit_reg_wait(ring,
 					  hub->vm_inv_eng0_sem + eng, 0x1, 0x1);
@@ -589,11 +597,7 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 					    req, 1 << vmid);
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if ((ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
-	     ring->funcs->vmhub == AMDGPU_MMHUB_1) &&
-	    (!(adev->asic_type == CHIP_RAVEN &&
-	       adev->rev_id < 0x8 &&
-	       adev->pdev->device == 0x15d8)))
+	if (use_semaphore)
 		/*
 		 * add semaphore release after invalidation,
 		 * write with 0 means semaphore release


