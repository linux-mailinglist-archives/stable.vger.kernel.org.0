Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156D211B63C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfLKPNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbfLKPNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D1724658;
        Wed, 11 Dec 2019 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077230;
        bh=rpxLrDaSvagMx3JhYJPE14kyPqGFg5t4VEmZNEMZ6H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6E16z43o4YF6TyMgA0t6mUH4Fivqsw5yD2y/5E1cWKBOEQpbuMrxOiTY6koJ4KiC
         BAUoQlp443xpQqp5pmxCgGy8jy3yq4ZJgDVHTEOIOrLv1XDKF20+e6KSpgcsGwVO8e
         QzmXIfbJH4+Ax3VMtRAU0qVy8AWc6+R7Dkeg2OYM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 109/134] drm/amdgpu: Call find_vma under mmap_sem
Date:   Wed, 11 Dec 2019 10:11:25 -0500
Message-Id: <20191211151150.19073-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit a9ae8731e6e52829a935d81a65d7f925cb95dbac ]

find_vma() must be called under the mmap_sem, reorganize this code to
do the vma check after entering the lock.

Further, fix the unlocked use of struct task_struct's mm, instead use
the mm from hmm_mirror which has an active mm_grab. Also the mm_grab
must be converted to a mm_get before acquiring mmap_sem or calling
find_vma().

Fixes: 66c45500bfdc ("drm/amdgpu: use new HMM APIs and helpers")
Fixes: 0919195f2b0d ("drm/amdgpu: Enable amdgpu_ttm_tt_get_user_pages in worker threads")
Link: https://lore.kernel.org/r/20191112202231.3856-11-jgg@ziepe.ca
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Tested-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 37 ++++++++++++++-----------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index dff41d0a85fe9..c0e41f1f0c236 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -35,6 +35,7 @@
 #include <linux/hmm.h>
 #include <linux/pagemap.h>
 #include <linux/sched/task.h>
+#include <linux/sched/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
@@ -788,7 +789,7 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 	struct hmm_mirror *mirror = bo->mn ? &bo->mn->mirror : NULL;
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	struct mm_struct *mm = gtt->usertask->mm;
+	struct mm_struct *mm;
 	unsigned long start = gtt->userptr;
 	struct vm_area_struct *vma;
 	struct hmm_range *range;
@@ -796,25 +797,14 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 	uint64_t *pfns;
 	int r = 0;
 
-	if (!mm) /* Happens during process shutdown */
-		return -ESRCH;
-
 	if (unlikely(!mirror)) {
 		DRM_DEBUG_DRIVER("Failed to get hmm_mirror\n");
-		r = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
-	vma = find_vma(mm, start);
-	if (unlikely(!vma || start < vma->vm_start)) {
-		r = -EFAULT;
-		goto out;
-	}
-	if (unlikely((gtt->userflags & AMDGPU_GEM_USERPTR_ANONONLY) &&
-		vma->vm_file)) {
-		r = -EPERM;
-		goto out;
-	}
+	mm = mirror->hmm->mmu_notifier.mm;
+	if (!mmget_not_zero(mm)) /* Happens during process shutdown */
+		return -ESRCH;
 
 	range = kzalloc(sizeof(*range), GFP_KERNEL);
 	if (unlikely(!range)) {
@@ -847,6 +837,17 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 	hmm_range_wait_until_valid(range, HMM_RANGE_DEFAULT_TIMEOUT);
 
 	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, start);
+	if (unlikely(!vma || start < vma->vm_start)) {
+		r = -EFAULT;
+		goto out_unlock;
+	}
+	if (unlikely((gtt->userflags & AMDGPU_GEM_USERPTR_ANONONLY) &&
+		vma->vm_file)) {
+		r = -EPERM;
+		goto out_unlock;
+	}
+
 	r = hmm_range_fault(range, 0);
 	up_read(&mm->mmap_sem);
 
@@ -865,15 +866,19 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 	}
 
 	gtt->range = range;
+	mmput(mm);
 
 	return 0;
 
+out_unlock:
+	up_read(&mm->mmap_sem);
 out_free_pfns:
 	hmm_range_unregister(range);
 	kvfree(pfns);
 out_free_ranges:
 	kfree(range);
 out:
+	mmput(mm);
 	return r;
 }
 
-- 
2.20.1

