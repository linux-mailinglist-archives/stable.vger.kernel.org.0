Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B912F12F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgABWPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbgABWPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC83B21582;
        Thu,  2 Jan 2020 22:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003306;
        bh=ZS+WlfIB8lLIxCH46STt3Cd5ZX9t2dJe7rAyLDNHfUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeRFAyyQGcLf7UOk6zpFBiYnRuTKkLOIjpcVkBZSDqyoaVZ8LGc7RBfdCWhsG2KBo
         MQKJJUXavTM+wbRBJl0ImE2vMDWH1HC8PySjsxaqEzsWNS1x5fJvTUGPsgFxTw8QkL
         gQ4RPxSEX//O5zTF8QW/o6wsFg33BgQZPzAKPUrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/191] drm/amdgpu: Call find_vma under mmap_sem
Date:   Thu,  2 Jan 2020 23:06:27 +0100
Message-Id: <20200102215841.191558239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dff41d0a85fe..c0e41f1f0c23 100644
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



