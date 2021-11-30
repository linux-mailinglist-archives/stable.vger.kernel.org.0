Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21F463783
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbhK3OyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57808 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbhK3OxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C99DCE1A53;
        Tue, 30 Nov 2021 14:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DA3C53FD3;
        Tue, 30 Nov 2021 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283793;
        bh=1Uf7O1EHnPUE0qHbeZTtKmD6EduuPvqppns4m9u1GjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3vB78GJmKQ238uyBpcIM6GjiEHBn685fhfdHgIj55S4D/M4L/FgjVniC5bly0aVi
         MCAyDA0wFX1OMvNHrYMh8Bwz0V8AZPjZxcrxjod7V1HQVbrEuFP1iF7iUXxRZrtimC
         HJIjr7IBtaIjE6a9C13zLQtZ98BNv7qEatbCuLXFb8UNDcN0Xw4FfUNO+Y0L8GKM9X
         P7zSx1SBjWC+nMAUMrWVdmwvGLBP9JuXYeDjt6pmZCbJwoIHfzPKKejHtKn8835SYB
         WmqTRYJkg9LTbuVoeW85iKBG+D82ZyuhDP7gd264FZykPYVJ9m3rDau0B2p9dhufYD
         dubfXepdQfjig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 58/68] drm/amdkfd: handle VMA remove race
Date:   Tue, 30 Nov 2021 09:46:54 -0500
Message-Id: <20211130144707.944580-58-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 0cc53cb450669cf1def4ff89e8cbcd8ec3c62380 ]

VMA may be removed before unmap notifier callback, and deferred list
work remove range, return success for this special case as we are
handling stale retry fault.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 179080329af89..4e933fb0fc698 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2448,20 +2448,13 @@ svm_range_count_fault(struct amdgpu_device *adev, struct kfd_process *p,
 }
 
 static bool
-svm_fault_allowed(struct mm_struct *mm, uint64_t addr, bool write_fault)
+svm_fault_allowed(struct vm_area_struct *vma, bool write_fault)
 {
 	unsigned long requested = VM_READ;
-	struct vm_area_struct *vma;
 
 	if (write_fault)
 		requested |= VM_WRITE;
 
-	vma = find_vma(mm, addr << PAGE_SHIFT);
-	if (!vma || (addr << PAGE_SHIFT) < vma->vm_start) {
-		pr_debug("address 0x%llx VMA is removed\n", addr);
-		return true;
-	}
-
 	pr_debug("requested 0x%lx, vma permission flags 0x%lx\n", requested,
 		vma->vm_flags);
 	return (vma->vm_flags & requested) == requested;
@@ -2479,6 +2472,7 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 	int32_t best_loc;
 	int32_t gpuidx = MAX_GPU_INSTANCE;
 	bool write_locked = false;
+	struct vm_area_struct *vma;
 	int r = 0;
 
 	if (!KFD_IS_SVM_API_SUPPORTED(adev->kfd.dev)) {
@@ -2552,7 +2546,17 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 		goto out_unlock_range;
 	}
 
-	if (!svm_fault_allowed(mm, addr, write_fault)) {
+	/* __do_munmap removed VMA, return success as we are handling stale
+	 * retry fault.
+	 */
+	vma = find_vma(mm, addr << PAGE_SHIFT);
+	if (!vma || (addr << PAGE_SHIFT) < vma->vm_start) {
+		pr_debug("address 0x%llx VMA is removed\n", addr);
+		r = 0;
+		goto out_unlock_range;
+	}
+
+	if (!svm_fault_allowed(vma, write_fault)) {
 		pr_debug("fault addr 0x%llx no %s permission\n", addr,
 			write_fault ? "write" : "read");
 		r = -EPERM;
-- 
2.33.0

