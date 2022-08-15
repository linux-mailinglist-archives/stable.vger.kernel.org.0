Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD93594202
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbiHOVKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348086AbiHOVIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEAD3C8FF;
        Mon, 15 Aug 2022 12:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E92F060F6A;
        Mon, 15 Aug 2022 19:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFEDC433C1;
        Mon, 15 Aug 2022 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591099;
        bh=kecoAhspe8ZOIjQtbaMol+JU8+XTX0SpoPNFUJlo3Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TS/XgkOgx0UGs5BmjV6xIJDki6KSnOXsqTQSJ/YvQlHOTIqmPf9OGwWbTux28nYFo
         XyCGrEQRgKa4j07iO3fLlu70eeY2i81wRitcFoUDybgbpgeSXkRKp9FH/qoymcEa4A
         pmqJFscHVGmVFFaFqm2Wz1Ita/lHeM5QAyXFezu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Shashank Sharma <shashank.sharma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0472/1095] drm/amdgpu: cleanup ctx implementation
Date:   Mon, 15 Aug 2022 19:57:51 +0200
Message-Id: <20220815180449.100544012@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 69493c034d2455204dfcd370de8c4dc204374a94 ]

Let each context have a pointer to the ctx manager and properly
initialize the adev pointer inside the context manager.

Reduce the BUG_ON() in amdgpu_ctx_add_fence() into a WARN_ON() and
directly return the sequence number instead of writing into a parmeter.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c  |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 46 ++++++++++++-------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h | 11 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |  2 +-
 4 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 2019622191b5..ee0cbc6ccbfb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1260,7 +1260,7 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 
 	p->fence = dma_fence_get(&job->base.s_fence->finished);
 
-	amdgpu_ctx_add_fence(p->ctx, entity, p->fence, &seq);
+	seq = amdgpu_ctx_add_fence(p->ctx, entity, p->fence);
 	amdgpu_cs_post_dependencies(p);
 
 	if ((job->preamble_status & AMDGPU_PREAMBLE_IB_PRESENT) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index c317078d1afd..a61e4c83a545 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -135,9 +135,9 @@ static enum amdgpu_ring_priority_level amdgpu_ctx_sched_prio_to_ring_prio(int32_
 
 static unsigned int amdgpu_ctx_get_hw_prio(struct amdgpu_ctx *ctx, u32 hw_ip)
 {
-	struct amdgpu_device *adev = ctx->adev;
-	int32_t ctx_prio;
+	struct amdgpu_device *adev = ctx->mgr->adev;
 	unsigned int hw_prio;
+	int32_t ctx_prio;
 
 	ctx_prio = (ctx->override_priority == AMDGPU_CTX_PRIORITY_UNSET) ?
 			ctx->init_priority : ctx->override_priority;
@@ -166,7 +166,7 @@ static unsigned int amdgpu_ctx_get_hw_prio(struct amdgpu_ctx *ctx, u32 hw_ip)
 static int amdgpu_ctx_init_entity(struct amdgpu_ctx *ctx, u32 hw_ip,
 				  const u32 ring)
 {
-	struct amdgpu_device *adev = ctx->adev;
+	struct amdgpu_device *adev = ctx->mgr->adev;
 	struct amdgpu_ctx_entity *entity;
 	struct drm_gpu_scheduler **scheds = NULL, *sched = NULL;
 	unsigned num_scheds = 0;
@@ -220,10 +220,8 @@ static int amdgpu_ctx_init_entity(struct amdgpu_ctx *ctx, u32 hw_ip,
 	return r;
 }
 
-static int amdgpu_ctx_init(struct amdgpu_device *adev,
-			   int32_t priority,
-			   struct drm_file *filp,
-			   struct amdgpu_ctx *ctx)
+static int amdgpu_ctx_init(struct amdgpu_ctx_mgr *mgr, int32_t priority,
+			   struct drm_file *filp, struct amdgpu_ctx *ctx)
 {
 	int r;
 
@@ -233,15 +231,14 @@ static int amdgpu_ctx_init(struct amdgpu_device *adev,
 
 	memset(ctx, 0, sizeof(*ctx));
 
-	ctx->adev = adev;
-
 	kref_init(&ctx->refcount);
+	ctx->mgr = mgr;
 	spin_lock_init(&ctx->ring_lock);
 	mutex_init(&ctx->lock);
 
-	ctx->reset_counter = atomic_read(&adev->gpu_reset_counter);
+	ctx->reset_counter = atomic_read(&mgr->adev->gpu_reset_counter);
 	ctx->reset_counter_query = ctx->reset_counter;
-	ctx->vram_lost_counter = atomic_read(&adev->vram_lost_counter);
+	ctx->vram_lost_counter = atomic_read(&mgr->adev->vram_lost_counter);
 	ctx->init_priority = priority;
 	ctx->override_priority = AMDGPU_CTX_PRIORITY_UNSET;
 	ctx->stable_pstate = AMDGPU_CTX_STABLE_PSTATE_NONE;
@@ -266,7 +263,7 @@ static void amdgpu_ctx_fini_entity(struct amdgpu_ctx_entity *entity)
 static int amdgpu_ctx_get_stable_pstate(struct amdgpu_ctx *ctx,
 					u32 *stable_pstate)
 {
-	struct amdgpu_device *adev = ctx->adev;
+	struct amdgpu_device *adev = ctx->mgr->adev;
 	enum amd_dpm_forced_level current_level;
 
 	current_level = amdgpu_dpm_get_performance_level(adev);
@@ -294,7 +291,7 @@ static int amdgpu_ctx_get_stable_pstate(struct amdgpu_ctx *ctx,
 static int amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
 					u32 stable_pstate)
 {
-	struct amdgpu_device *adev = ctx->adev;
+	struct amdgpu_device *adev = ctx->mgr->adev;
 	enum amd_dpm_forced_level level;
 	u32 current_stable_pstate;
 	int r;
@@ -345,7 +342,8 @@ static int amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
 static void amdgpu_ctx_fini(struct kref *ref)
 {
 	struct amdgpu_ctx *ctx = container_of(ref, struct amdgpu_ctx, refcount);
-	struct amdgpu_device *adev = ctx->adev;
+	struct amdgpu_ctx_mgr *mgr = ctx->mgr;
+	struct amdgpu_device *adev = mgr->adev;
 	unsigned i, j, idx;
 
 	if (!adev)
@@ -421,7 +419,7 @@ static int amdgpu_ctx_alloc(struct amdgpu_device *adev,
 	}
 
 	*id = (uint32_t)r;
-	r = amdgpu_ctx_init(adev, priority, filp, ctx);
+	r = amdgpu_ctx_init(mgr, priority, filp, ctx);
 	if (r) {
 		idr_remove(&mgr->ctx_handles, *id);
 		*id = 0;
@@ -671,9 +669,9 @@ int amdgpu_ctx_put(struct amdgpu_ctx *ctx)
 	return 0;
 }
 
-void amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
-			  struct drm_sched_entity *entity,
-			  struct dma_fence *fence, uint64_t *handle)
+uint64_t amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
+			      struct drm_sched_entity *entity,
+			      struct dma_fence *fence)
 {
 	struct amdgpu_ctx_entity *centity = to_amdgpu_ctx_entity(entity);
 	uint64_t seq = centity->sequence;
@@ -682,8 +680,7 @@ void amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
 
 	idx = seq & (amdgpu_sched_jobs - 1);
 	other = centity->fences[idx];
-	if (other)
-		BUG_ON(!dma_fence_is_signaled(other));
+	WARN_ON(other && !dma_fence_is_signaled(other));
 
 	dma_fence_get(fence);
 
@@ -693,8 +690,7 @@ void amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
 	spin_unlock(&ctx->ring_lock);
 
 	dma_fence_put(other);
-	if (handle)
-		*handle = seq;
+	return seq;
 }
 
 struct dma_fence *amdgpu_ctx_get_fence(struct amdgpu_ctx *ctx,
@@ -731,7 +727,7 @@ static void amdgpu_ctx_set_entity_priority(struct amdgpu_ctx *ctx,
 					   int hw_ip,
 					   int32_t priority)
 {
-	struct amdgpu_device *adev = ctx->adev;
+	struct amdgpu_device *adev = ctx->mgr->adev;
 	unsigned int hw_prio;
 	struct drm_gpu_scheduler **scheds = NULL;
 	unsigned num_scheds;
@@ -796,8 +792,10 @@ int amdgpu_ctx_wait_prev_fence(struct amdgpu_ctx *ctx,
 	return r;
 }
 
-void amdgpu_ctx_mgr_init(struct amdgpu_ctx_mgr *mgr)
+void amdgpu_ctx_mgr_init(struct amdgpu_ctx_mgr *mgr,
+			 struct amdgpu_device *adev)
 {
+	mgr->adev = adev;
 	mutex_init(&mgr->lock);
 	idr_init(&mgr->ctx_handles);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
index 142f2f87d44c..681050bc828c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
@@ -40,7 +40,7 @@ struct amdgpu_ctx_entity {
 
 struct amdgpu_ctx {
 	struct kref			refcount;
-	struct amdgpu_device		*adev;
+	struct amdgpu_ctx_mgr		*mgr;
 	unsigned			reset_counter;
 	unsigned			reset_counter_query;
 	uint32_t			vram_lost_counter;
@@ -70,9 +70,9 @@ int amdgpu_ctx_put(struct amdgpu_ctx *ctx);
 
 int amdgpu_ctx_get_entity(struct amdgpu_ctx *ctx, u32 hw_ip, u32 instance,
 			  u32 ring, struct drm_sched_entity **entity);
-void amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
-			  struct drm_sched_entity *entity,
-			  struct dma_fence *fence, uint64_t *seq);
+uint64_t amdgpu_ctx_add_fence(struct amdgpu_ctx *ctx,
+			      struct drm_sched_entity *entity,
+			      struct dma_fence *fence);
 struct dma_fence *amdgpu_ctx_get_fence(struct amdgpu_ctx *ctx,
 				       struct drm_sched_entity *entity,
 				       uint64_t seq);
@@ -85,7 +85,8 @@ int amdgpu_ctx_ioctl(struct drm_device *dev, void *data,
 int amdgpu_ctx_wait_prev_fence(struct amdgpu_ctx *ctx,
 			       struct drm_sched_entity *entity);
 
-void amdgpu_ctx_mgr_init(struct amdgpu_ctx_mgr *mgr);
+void amdgpu_ctx_mgr_init(struct amdgpu_ctx_mgr *mgr,
+			 struct amdgpu_device *adev);
 void amdgpu_ctx_mgr_entity_fini(struct amdgpu_ctx_mgr *mgr);
 long amdgpu_ctx_mgr_entity_flush(struct amdgpu_ctx_mgr *mgr, long timeout);
 void amdgpu_ctx_mgr_fini(struct amdgpu_ctx_mgr *mgr);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 49c55d82cba8..20a432a774c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -1142,7 +1142,7 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 	mutex_init(&fpriv->bo_list_lock);
 	idr_init(&fpriv->bo_list_handles);
 
-	amdgpu_ctx_mgr_init(&fpriv->ctx_mgr);
+	amdgpu_ctx_mgr_init(&fpriv->ctx_mgr, adev);
 
 	file_priv->driver_priv = fpriv;
 	goto out_suspend;
-- 
2.35.1



