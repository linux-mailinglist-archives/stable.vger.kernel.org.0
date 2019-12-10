Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F3D11931D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfLJVGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfLJVEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31E1724679;
        Tue, 10 Dec 2019 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011861;
        bh=G3pxgIYne46zikRD4f0dDWJlvjJHvRooIorjQRkUWwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CyRwNEC0MH3udFRIzaIsCPy/bmeyAgnQYwENOJ68DWc+b9pYcsHXPgdP2n4pKOiJ
         2iMRld30xxreONK4bbXhnDnzvCuq8BWxEqrCqdK/kY5sqZdMZKt/MsNmJs/9WKQYeF
         MmcQkTSd25X4xJddrzxX0Hvy2yikMiopuXlMsHjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 015/350] drm/ttm: return -EBUSY on pipelining with no_gpu_wait (v2)
Date:   Tue, 10 Dec 2019 15:58:27 -0500
Message-Id: <20191210210402.8367-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
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

[ Upstream commit 3084cf46cf8110826a42de8c8ef30e8fa48974c2 ]

Setting the no_gpu_wait flag means that the allocate BO must be available
immediately and we can't wait for any GPU operation to finish.

v2: squash in mem leak fix, rebase

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 44 +++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 98819462f025f..f078036998092 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -926,7 +926,8 @@ EXPORT_SYMBOL(ttm_bo_mem_put);
  */
 static int ttm_bo_add_move_fence(struct ttm_buffer_object *bo,
 				 struct ttm_mem_type_manager *man,
-				 struct ttm_mem_reg *mem)
+				 struct ttm_mem_reg *mem,
+				 bool no_wait_gpu)
 {
 	struct dma_fence *fence;
 	int ret;
@@ -935,19 +936,22 @@ static int ttm_bo_add_move_fence(struct ttm_buffer_object *bo,
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
 
-	if (fence) {
-		dma_resv_add_shared_fence(bo->base.resv, fence);
+	if (!fence)
+		return 0;
 
-		ret = dma_resv_reserve_shared(bo->base.resv, 1);
-		if (unlikely(ret)) {
-			dma_fence_put(fence);
-			return ret;
-		}
+	if (no_wait_gpu)
+		return -EBUSY;
+
+	dma_resv_add_shared_fence(bo->base.resv, fence);
 
-		dma_fence_put(bo->moving);
-		bo->moving = fence;
+	ret = dma_resv_reserve_shared(bo->base.resv, 1);
+	if (unlikely(ret)) {
+		dma_fence_put(fence);
+		return ret;
 	}
 
+	dma_fence_put(bo->moving);
+	bo->moving = fence;
 	return 0;
 }
 
@@ -978,7 +982,7 @@ static int ttm_bo_mem_force_space(struct ttm_buffer_object *bo,
 			return ret;
 	} while (1);
 
-	return ttm_bo_add_move_fence(bo, man, mem);
+	return ttm_bo_add_move_fence(bo, man, mem, ctx->no_wait_gpu);
 }
 
 static uint32_t ttm_bo_select_caching(struct ttm_mem_type_manager *man,
@@ -1120,14 +1124,18 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
 		if (unlikely(ret))
 			goto error;
 
-		if (mem->mm_node) {
-			ret = ttm_bo_add_move_fence(bo, man, mem);
-			if (unlikely(ret)) {
-				(*man->func->put_node)(man, mem);
-				goto error;
-			}
-			return 0;
+		if (!mem->mm_node)
+			continue;
+
+		ret = ttm_bo_add_move_fence(bo, man, mem, ctx->no_wait_gpu);
+		if (unlikely(ret)) {
+			(*man->func->put_node)(man, mem);
+			if (ret == -EBUSY)
+				continue;
+
+			goto error;
 		}
+		return 0;
 	}
 
 	for (i = 0; i < placement->num_busy_placement; ++i) {
-- 
2.20.1

