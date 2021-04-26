Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1624A36AEA2
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhDZHpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234034AbhDZHon (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43CA4613DA;
        Mon, 26 Apr 2021 07:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422874;
        bh=hjSYZSPWPq1fnBFqrqtgESksCLg0BUKDwHBIfJIdR54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN+DNl0vSmz7aoRCjhb53oc3jX+LAZOb1fHPfEqpCoUWBqbeOyJYEM78Qk7DRVJWC
         3YH3FfJpJzAU/yH7pmyKQYzB58mAo1fCHB06yGD+KtGPxaupPFvF1pB/iYez9SrgBt
         UdiZ6UIwjBoWEXs1ROQVxNlyqx1cY/Qer5j2Dhp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 05/41] drm/amdgpu: reserve fence slot to update page table
Date:   Mon, 26 Apr 2021 09:29:52 +0200
Message-Id: <20210426072819.866751115@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

commit d42a5b639d15622ece5b9dd12dafd9776efa2593 upstream.

Forgot to reserve a fence slot to use sdma to update page table, cause
below kernel BUG backtrace to handle vm retry fault while application is
exiting.

[  133.048143] kernel BUG at /home/yangp/git/compute_staging/kernel/drivers/dma-buf/dma-resv.c:281!
[  133.048487] Workqueue: events amdgpu_irq_handle_ih1 [amdgpu]
[  133.048506] RIP: 0010:dma_resv_add_shared_fence+0x204/0x280
[  133.048672]  amdgpu_vm_sdma_commit+0x134/0x220 [amdgpu]
[  133.048788]  amdgpu_vm_bo_update_range+0x220/0x250 [amdgpu]
[  133.048905]  amdgpu_vm_handle_fault+0x202/0x370 [amdgpu]
[  133.049031]  gmc_v9_0_process_interrupt+0x1ab/0x310 [amdgpu]
[  133.049165]  ? kgd2kfd_interrupt+0x9a/0x180 [amdgpu]
[  133.049289]  ? amdgpu_irq_dispatch+0xb6/0x240 [amdgpu]
[  133.049408]  amdgpu_irq_dispatch+0xb6/0x240 [amdgpu]
[  133.049534]  amdgpu_ih_process+0x9b/0x1c0 [amdgpu]
[  133.049657]  amdgpu_irq_handle_ih1+0x21/0x60 [amdgpu]
[  133.049669]  process_one_work+0x29f/0x640
[  133.049678]  worker_thread+0x39/0x3f0
[  133.049685]  ? process_one_work+0x640/0x640

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -3298,7 +3298,7 @@ bool amdgpu_vm_handle_fault(struct amdgp
 	struct amdgpu_bo *root;
 	uint64_t value, flags;
 	struct amdgpu_vm *vm;
-	long r;
+	int r;
 
 	spin_lock(&adev->vm_manager.pasid_lock);
 	vm = idr_find(&adev->vm_manager.pasid_idr, pasid);
@@ -3347,6 +3347,12 @@ bool amdgpu_vm_handle_fault(struct amdgp
 		value = 0;
 	}
 
+	r = dma_resv_reserve_shared(root->tbo.base.resv, 1);
+	if (r) {
+		pr_debug("failed %d to reserve fence slot\n", r);
+		goto error_unlock;
+	}
+
 	r = amdgpu_vm_bo_update_mapping(adev, adev, vm, true, false, NULL, addr,
 					addr, flags, value, NULL, NULL,
 					NULL);
@@ -3358,7 +3364,7 @@ bool amdgpu_vm_handle_fault(struct amdgp
 error_unlock:
 	amdgpu_bo_unreserve(root);
 	if (r < 0)
-		DRM_ERROR("Can't handle page fault (%ld)\n", r);
+		DRM_ERROR("Can't handle page fault (%d)\n", r);
 
 error_unref:
 	amdgpu_bo_unref(&root);


