Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF01F2BA6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgFIARv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgFHXSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4375820823;
        Mon,  8 Jun 2020 23:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658330;
        bh=nDJ5aA8yDvrtA35YXgEoanLshtxLTVoWR9hrb1QTiLY=;
        h=From:To:Cc:Subject:Date:From;
        b=2T4PPlxkwCQQyhVVHugx/bCig6Pc4MNb6wn15szWKgNZYs+9B8auoRetiwDoNuMS1
         JudeGVmYVRlLd/EisB8beElfwHo0dO5p/EDioadLXfNiC0VSKxI+cLrp24UES2fFAi
         PXpyYpBznr1zlCD1MPPz1viYNIxzc/igjGuG1CSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.4 001/175] drm/amdgpu: fix and cleanup amdgpu_gem_object_close v4
Date:   Mon,  8 Jun 2020 19:15:54 -0400
Message-Id: <20200608231848.3366970-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

