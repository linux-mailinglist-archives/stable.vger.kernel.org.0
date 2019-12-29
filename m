Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8312C622
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfL2Rno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730187AbfL2Rno (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C50AB206DB;
        Sun, 29 Dec 2019 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641423;
        bh=LWrPzQ32CmT9f26U2+6H21MNNI2hotPTgpv7WYQc9Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDcRVVi94P2zpqNTqtjsG/aFet9TiCsJpn2lPj53UE3yhnAbgvS2McOZv1IsUL7M9
         fgDPBzpIJTp073VCVaZMZSpo6SVa3xa3y57Rq7xQOVi58XGR3UF+hW938ugIFHOy5Q
         dZy0iWD+ruybIqv+XYB6iluBTFZusR7yVEIxyXXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/434] drm/ttm: return -EBUSY on pipelining with no_gpu_wait (v2)
Date:   Sun, 29 Dec 2019 18:21:50 +0100
Message-Id: <20191229172705.648196234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 98819462f025..f07803699809 100644
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



