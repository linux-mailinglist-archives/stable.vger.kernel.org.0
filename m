Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996EB40431E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349126AbhIIBrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349279AbhIIBrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF166117A;
        Thu,  9 Sep 2021 01:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631151990;
        bh=G8dpfV2PElFHwAWhg2+m5dwGxUJR7xrvlAx2BMa7kq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD7n9cqTgxASXcb4/vH/+95+HJoRHA9vxHLNkraX3NXC2Po8dxVAjH490YwiyjNDx
         fo8tF21OJc82DpbqIeCVS0A3+YwSRxmjSCQs8H7w+hAiAYn870vqrbwITYOh9TDXLJ
         6T3PoUj27cX8a5p/OhC6KpE4XhzJCG2L2rJQtMbGwPZq0WRvafr4XsMsDHcHJTdBKd
         MjbLDxR1wGI9MbMxr6EUX/W4d09FGfhjf7kkyULJfBxT4ptb0Y1LVCAfgBPmeQ6t1k
         3jMp4h3QOQCZmiRGsLsgFpQe2d0RlKuHQ2mC0zF2CyQozYD9pVw6jcFxyMEkEEMveW
         QfsrCCZ+AkNPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 005/252] drm/ttm: Fix multihop assert on eviction.
Date:   Wed,  8 Sep 2021 21:42:15 -0400
Message-Id: <20210909014623.128976-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909014623.128976-1-sashal@kernel.org>
References: <20210909014623.128976-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 403797925768d9fa870f5b1ebcd20016b397083b ]

Problem:
Under memory pressure when GTT domain is almost full multihop assert
will come up when trying to evict LRU BO from VRAM to SYSTEM.

Fix:
Don't assert on multihop error in evict code but rather do a retry
as we do in ttm_bo_move_buffer

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210622162339.761651-6-andrey.grodzovsky@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 63 +++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 8d7fd65ccced..32202385073a 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -488,6 +488,31 @@ void ttm_bo_unlock_delayed_workqueue(struct ttm_device *bdev, int resched)
 }
 EXPORT_SYMBOL(ttm_bo_unlock_delayed_workqueue);
 
+static int ttm_bo_bounce_temp_buffer(struct ttm_buffer_object *bo,
+				     struct ttm_resource **mem,
+				     struct ttm_operation_ctx *ctx,
+				     struct ttm_place *hop)
+{
+	struct ttm_placement hop_placement;
+	struct ttm_resource *hop_mem;
+	int ret;
+
+	hop_placement.num_placement = hop_placement.num_busy_placement = 1;
+	hop_placement.placement = hop_placement.busy_placement = hop;
+
+	/* find space in the bounce domain */
+	ret = ttm_bo_mem_space(bo, &hop_placement, &hop_mem, ctx);
+	if (ret)
+		return ret;
+	/* move to the bounce domain */
+	ret = ttm_bo_handle_move_mem(bo, hop_mem, false, ctx, NULL);
+	if (ret) {
+		ttm_resource_free(bo, &hop_mem);
+		return ret;
+	}
+	return 0;
+}
+
 static int ttm_bo_evict(struct ttm_buffer_object *bo,
 			struct ttm_operation_ctx *ctx)
 {
@@ -527,12 +552,17 @@ static int ttm_bo_evict(struct ttm_buffer_object *bo,
 		goto out;
 	}
 
+bounce:
 	ret = ttm_bo_handle_move_mem(bo, evict_mem, true, ctx, &hop);
-	if (unlikely(ret)) {
-		WARN(ret == -EMULTIHOP, "Unexpected multihop in eviction - likely driver bug\n");
-		if (ret != -ERESTARTSYS)
+	if (ret == -EMULTIHOP) {
+		ret = ttm_bo_bounce_temp_buffer(bo, &evict_mem, ctx, &hop);
+		if (ret) {
 			pr_err("Buffer eviction failed\n");
-		ttm_resource_free(bo, &evict_mem);
+			ttm_resource_free(bo, &evict_mem);
+			goto out;
+		}
+		/* try and move to final place now. */
+		goto bounce;
 	}
 out:
 	return ret;
@@ -847,31 +877,6 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
 }
 EXPORT_SYMBOL(ttm_bo_mem_space);
 
-static int ttm_bo_bounce_temp_buffer(struct ttm_buffer_object *bo,
-				     struct ttm_resource **mem,
-				     struct ttm_operation_ctx *ctx,
-				     struct ttm_place *hop)
-{
-	struct ttm_placement hop_placement;
-	struct ttm_resource *hop_mem;
-	int ret;
-
-	hop_placement.num_placement = hop_placement.num_busy_placement = 1;
-	hop_placement.placement = hop_placement.busy_placement = hop;
-
-	/* find space in the bounce domain */
-	ret = ttm_bo_mem_space(bo, &hop_placement, &hop_mem, ctx);
-	if (ret)
-		return ret;
-	/* move to the bounce domain */
-	ret = ttm_bo_handle_move_mem(bo, hop_mem, false, ctx, NULL);
-	if (ret) {
-		ttm_resource_free(bo, &hop_mem);
-		return ret;
-	}
-	return 0;
-}
-
 static int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
 			      struct ttm_placement *placement,
 			      struct ttm_operation_ctx *ctx)
-- 
2.30.2

