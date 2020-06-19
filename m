Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9A200E29
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391325AbgFSPFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391315AbgFSPFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D83052158C;
        Fri, 19 Jun 2020 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579132;
        bh=nDJ5aA8yDvrtA35YXgEoanLshtxLTVoWR9hrb1QTiLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8WYNlBjbgJ1PerB7gyG3LjZdKkejGuEROk7RjVK3GVLiLqmEl8R+4xroKWsSH606
         Gjeah5QZRDFTZOD5RLMTY3yZNJRL8FxYfGTdMw8ESnqUbZGcjGvxlx9seeeXeK9lFW
         l2nALr0nSw8JxjLNQZvGmL3tJX/161SLOT4gBbL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/261] drm/amdgpu: fix and cleanup amdgpu_gem_object_close v4
Date:   Fri, 19 Jun 2020 16:30:13 +0200
Message-Id: <20200619141650.001566495@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 82c416b13cb7d22b96ec0888b296a48dff8a09eb ]

The problem is that we can't add the clear fence to the BO
when there is an exclusive fence on it since we can't
guarantee the the clear fence will complete after the
exclusive one.

To fix this refactor the function and also add the exclusive
fence as shared to the resv object.

v2: fix warning
v3: add excl fence as shared instead
v4: squash in fix for fence handling in amdgpu_gem_object_close

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: xinhui pan <xinhui.pan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 43 ++++++++++++++-----------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 8ceb44925947..5fa5158d18ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -161,16 +161,17 @@ void amdgpu_gem_object_close(struct drm_gem_object *obj,
 
 	struct amdgpu_bo_list_entry vm_pd;
 	struct list_head list, duplicates;
+	struct dma_fence *fence = NULL;
 	struct ttm_validate_buffer tv;
 	struct ww_acquire_ctx ticket;
 	struct amdgpu_bo_va *bo_va;
-	int r;
+	long r;
 
 	INIT_LIST_HEAD(&list);
 	INIT_LIST_HEAD(&duplicates);
 
 	tv.bo = &bo->tbo;
-	tv.num_shared = 1;
+	tv.num_shared = 2;
 	list_add(&tv.head, &list);
 
 	amdgpu_vm_get_pd_bo(vm, &list, &vm_pd);
@@ -178,28 +179,34 @@ void amdgpu_gem_object_close(struct drm_gem_object *obj,
 	r = ttm_eu_reserve_buffers(&ticket, &list, false, &duplicates, false);
 	if (r) {
 		dev_err(adev->dev, "leaking bo va because "
-			"we fail to reserve bo (%d)\n", r);
+			"we fail to reserve bo (%ld)\n", r);
 		return;
 	}
 	bo_va = amdgpu_vm_bo_find(vm, bo);
-	if (bo_va && --bo_va->ref_count == 0) {
-		amdgpu_vm_bo_rmv(adev, bo_va);
-
-		if (amdgpu_vm_ready(vm)) {
-			struct dma_fence *fence = NULL;
+	if (!bo_va || --bo_va->ref_count)
+		goto out_unlock;
 
-			r = amdgpu_vm_clear_freed(adev, vm, &fence);
-			if (unlikely(r)) {
-				dev_err(adev->dev, "failed to clear page "
-					"tables on GEM object close (%d)\n", r);
-			}
+	amdgpu_vm_bo_rmv(adev, bo_va);
+	if (!amdgpu_vm_ready(vm))
+		goto out_unlock;
 
-			if (fence) {
-				amdgpu_bo_fence(bo, fence, true);
-				dma_fence_put(fence);
-			}
-		}
+	fence = dma_resv_get_excl(bo->tbo.base.resv);
+	if (fence) {
+		amdgpu_bo_fence(bo, fence, true);
+		fence = NULL;
 	}
+
+	r = amdgpu_vm_clear_freed(adev, vm, &fence);
+	if (r || !fence)
+		goto out_unlock;
+
+	amdgpu_bo_fence(bo, fence, true);
+	dma_fence_put(fence);
+
+out_unlock:
+	if (unlikely(r < 0))
+		dev_err(adev->dev, "failed to clear page "
+			"tables on GEM object close (%ld)\n", r);
 	ttm_eu_backoff_reservation(&ticket, &list);
 }
 
-- 
2.25.1



