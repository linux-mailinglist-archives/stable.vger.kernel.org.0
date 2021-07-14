Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDF3C8BBC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhGNThV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGNThV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 15:37:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA61AC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:34:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so1963235plf.12
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8nDZ0zbwQ8nPGLFDQiiGDDwLohN2PwklzBsxs5APKh4=;
        b=cbjCY6ylF/B2Wcw3aL/FqfonnF9X0tCLHE7Z6BbDHM0ax24B7S/nX9FS07BaXxXDVJ
         r8M46jQgSgjr+fMK8h1o4jX8FX/iejocBOOGBUt8rgfYJUxaupKEjveJMGp7Z7IRwUi9
         mBKtjQ5YLcmFGpenOrof0by5UIxagFEGipe6KSQzW1hOZblgFeaS7sqIJV3JgEt5t4P3
         uNgy40uW6QyH9r12973AJi9hGQxsB8u4GVlTtqRuwg6ieoUK9LDusTacNzsFq7eLRV7/
         h9vo2hcV2AouS3wXA3MuG53aDVECqx2+8SzAS9TTidY/EXYm3XOpYELdZDXYY2n2lG95
         KAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8nDZ0zbwQ8nPGLFDQiiGDDwLohN2PwklzBsxs5APKh4=;
        b=kHhcrP/tve8elZFKfuU5iIyhbN2sVFBetPSAwD8IZwEKcTixSkWU8HZUoIONTx1Kqg
         AI+fnxOjjWS0Fx4Ury8E9jzHDgstCtYGTrvhHWzhXg+32Zdtc9/e+V9wid/LPXX7nNxS
         8sMHOn69jm2EMRaOrt/TTUrbVy0QfRwKalhUHz2quFDqRcJijsZ4kSOYTiTK3550X7q+
         7BbJSHyUnPiSuu9d5di5jgfB89uybeKWqCFidAxCMT+xiqzbyPRc0XnnGlfJpIFYBVUy
         PD5jLj1HytJS1TecZqO+ucbZ2zzA08i91nI8q194wpZwqSsb0FDj7S+VqM8KKBtYd3l4
         boew==
X-Gm-Message-State: AOAM530v14B0SAhsTrFAgEmX2fBFYNtOLH09k00ybZ+GeY/Cmz5F3GtR
        yfLTs5MeQUn6QZkKxP4yRg/Rzg==
X-Google-Smtp-Source: ABdhPJwIxYg2338kbBaJSnsLQZHnLdZ/pVSVot/B1Vx28/KrBgIZo5gI8Sjbot3tHag5ylbd4JUV/A==
X-Received: by 2002:a17:902:fe87:b029:12a:ef40:57a2 with SMTP id x7-20020a170902fe87b029012aef4057a2mr8658592plm.81.1626291268054;
        Wed, 14 Jul 2021 12:34:28 -0700 (PDT)
Received: from omlet.com ([134.134.139.71])
        by smtp.gmail.com with ESMTPSA id i1sm3679740pfo.37.2021.07.14.12.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 12:34:27 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/5] drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
Date:   Wed, 14 Jul 2021 14:34:15 -0500
Message-Id: <20210714193419.1459723-2-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714193419.1459723-1-jason@jlekstrand.net>
References: <20210714193419.1459723-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser").  The
justification for this commit in the git history was a vague comment
about getting it out from under the struct_mutex.  While this may
improve perf for some workloads on Gen7 platforms where we rely on the
command parser for features such as indirect rendering, no numbers were
provided to prove such an improvement.  It claims to closed two
gitlab/bugzilla issues but with no explanation whatsoever as to why or
what bug it's fixing.

Meanwhile, by moving command parsing off to an async callback, it leaves
us with a problem of what to do on error.  When things were synchronous,
EXECBUFFER2 would fail with an error code if parsing failed.  When
moving it to async, we needed another way to handle that error and the
solution employed was to set an error on the dma_fence and then trust
that said error gets propagated to the client eventually.  Moving back
to synchronous will help us untangle the fence error propagation mess.

This also reverts most of 0edbb9ba1bfe ("drm/i915: Move cmd parser
pinning to execbuffer") which is a refactor of some of our allocation
paths for asynchronous parsing.  Now that everything is synchronous, we
don't need it.

v2 (Daniel Vetter):
 - Add stabel Cc and Fixes tag

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Cc: <stable@vger.kernel.org> # v5.6+
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 227 +-----------------
 .../i915/gem/selftests/i915_gem_execbuffer.c  |   4 +
 drivers/gpu/drm/i915/i915_cmd_parser.c        | 132 +++++-----
 drivers/gpu/drm/i915/i915_drv.h               |   7 +-
 4 files changed, 91 insertions(+), 279 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 5ea8b4e23e428..1ed7475de454d 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -25,10 +25,8 @@
 #include "i915_gem_clflush.h"
 #include "i915_gem_context.h"
 #include "i915_gem_ioctls.h"
-#include "i915_sw_fence_work.h"
 #include "i915_trace.h"
 #include "i915_user_extensions.h"
-#include "i915_memcpy.h"
 
 struct eb_vma {
 	struct i915_vma *vma;
@@ -1471,6 +1469,10 @@ static u32 *reloc_gpu(struct i915_execbuffer *eb,
 		int err;
 		struct intel_engine_cs *engine = eb->engine;
 
+		/* If we need to copy for the cmdparser, we will stall anyway */
+		if (eb_use_cmdparser(eb))
+			return ERR_PTR(-EWOULDBLOCK);
+
 		if (!reloc_can_use_engine(engine)) {
 			engine = engine->gt->engine_class[COPY_ENGINE_CLASS][0];
 			if (!engine)
@@ -2385,217 +2387,6 @@ shadow_batch_pin(struct i915_execbuffer *eb,
 	return vma;
 }
 
-struct eb_parse_work {
-	struct dma_fence_work base;
-	struct intel_engine_cs *engine;
-	struct i915_vma *batch;
-	struct i915_vma *shadow;
-	struct i915_vma *trampoline;
-	unsigned long batch_offset;
-	unsigned long batch_length;
-	unsigned long *jump_whitelist;
-	const void *batch_map;
-	void *shadow_map;
-};
-
-static int __eb_parse(struct dma_fence_work *work)
-{
-	struct eb_parse_work *pw = container_of(work, typeof(*pw), base);
-	int ret;
-	bool cookie;
-
-	cookie = dma_fence_begin_signalling();
-	ret = intel_engine_cmd_parser(pw->engine,
-				      pw->batch,
-				      pw->batch_offset,
-				      pw->batch_length,
-				      pw->shadow,
-				      pw->jump_whitelist,
-				      pw->shadow_map,
-				      pw->batch_map);
-	dma_fence_end_signalling(cookie);
-
-	return ret;
-}
-
-static void __eb_parse_release(struct dma_fence_work *work)
-{
-	struct eb_parse_work *pw = container_of(work, typeof(*pw), base);
-
-	if (!IS_ERR_OR_NULL(pw->jump_whitelist))
-		kfree(pw->jump_whitelist);
-
-	if (pw->batch_map)
-		i915_gem_object_unpin_map(pw->batch->obj);
-	else
-		i915_gem_object_unpin_pages(pw->batch->obj);
-
-	i915_gem_object_unpin_map(pw->shadow->obj);
-
-	if (pw->trampoline)
-		i915_active_release(&pw->trampoline->active);
-	i915_active_release(&pw->shadow->active);
-	i915_active_release(&pw->batch->active);
-}
-
-static const struct dma_fence_work_ops eb_parse_ops = {
-	.name = "eb_parse",
-	.work = __eb_parse,
-	.release = __eb_parse_release,
-};
-
-static inline int
-__parser_mark_active(struct i915_vma *vma,
-		     struct intel_timeline *tl,
-		     struct dma_fence *fence)
-{
-	struct intel_gt_buffer_pool_node *node = vma->private;
-
-	return i915_active_ref(&node->active, tl->fence_context, fence);
-}
-
-static int
-parser_mark_active(struct eb_parse_work *pw, struct intel_timeline *tl)
-{
-	int err;
-
-	mutex_lock(&tl->mutex);
-
-	err = __parser_mark_active(pw->shadow, tl, &pw->base.dma);
-	if (err)
-		goto unlock;
-
-	if (pw->trampoline) {
-		err = __parser_mark_active(pw->trampoline, tl, &pw->base.dma);
-		if (err)
-			goto unlock;
-	}
-
-unlock:
-	mutex_unlock(&tl->mutex);
-	return err;
-}
-
-static int eb_parse_pipeline(struct i915_execbuffer *eb,
-			     struct i915_vma *shadow,
-			     struct i915_vma *trampoline)
-{
-	struct eb_parse_work *pw;
-	struct drm_i915_gem_object *batch = eb->batch->vma->obj;
-	bool needs_clflush;
-	int err;
-
-	GEM_BUG_ON(overflows_type(eb->batch_start_offset, pw->batch_offset));
-	GEM_BUG_ON(overflows_type(eb->batch_len, pw->batch_length));
-
-	pw = kzalloc(sizeof(*pw), GFP_KERNEL);
-	if (!pw)
-		return -ENOMEM;
-
-	err = i915_active_acquire(&eb->batch->vma->active);
-	if (err)
-		goto err_free;
-
-	err = i915_active_acquire(&shadow->active);
-	if (err)
-		goto err_batch;
-
-	if (trampoline) {
-		err = i915_active_acquire(&trampoline->active);
-		if (err)
-			goto err_shadow;
-	}
-
-	pw->shadow_map = i915_gem_object_pin_map(shadow->obj, I915_MAP_WB);
-	if (IS_ERR(pw->shadow_map)) {
-		err = PTR_ERR(pw->shadow_map);
-		goto err_trampoline;
-	}
-
-	needs_clflush =
-		!(batch->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ);
-
-	pw->batch_map = ERR_PTR(-ENODEV);
-	if (needs_clflush && i915_has_memcpy_from_wc())
-		pw->batch_map = i915_gem_object_pin_map(batch, I915_MAP_WC);
-
-	if (IS_ERR(pw->batch_map)) {
-		err = i915_gem_object_pin_pages(batch);
-		if (err)
-			goto err_unmap_shadow;
-		pw->batch_map = NULL;
-	}
-
-	pw->jump_whitelist =
-		intel_engine_cmd_parser_alloc_jump_whitelist(eb->batch_len,
-							     trampoline);
-	if (IS_ERR(pw->jump_whitelist)) {
-		err = PTR_ERR(pw->jump_whitelist);
-		goto err_unmap_batch;
-	}
-
-	dma_fence_work_init(&pw->base, &eb_parse_ops);
-
-	pw->engine = eb->engine;
-	pw->batch = eb->batch->vma;
-	pw->batch_offset = eb->batch_start_offset;
-	pw->batch_length = eb->batch_len;
-	pw->shadow = shadow;
-	pw->trampoline = trampoline;
-
-	/* Mark active refs early for this worker, in case we get interrupted */
-	err = parser_mark_active(pw, eb->context->timeline);
-	if (err)
-		goto err_commit;
-
-	err = dma_resv_reserve_shared(pw->batch->resv, 1);
-	if (err)
-		goto err_commit;
-
-	err = dma_resv_reserve_shared(shadow->resv, 1);
-	if (err)
-		goto err_commit;
-
-	/* Wait for all writes (and relocs) into the batch to complete */
-	err = i915_sw_fence_await_reservation(&pw->base.chain,
-					      pw->batch->resv, NULL, false,
-					      0, I915_FENCE_GFP);
-	if (err < 0)
-		goto err_commit;
-
-	/* Keep the batch alive and unwritten as we parse */
-	dma_resv_add_shared_fence(pw->batch->resv, &pw->base.dma);
-
-	/* Force execution to wait for completion of the parser */
-	dma_resv_add_excl_fence(shadow->resv, &pw->base.dma);
-
-	dma_fence_work_commit_imm(&pw->base);
-	return 0;
-
-err_commit:
-	i915_sw_fence_set_error_once(&pw->base.chain, err);
-	dma_fence_work_commit_imm(&pw->base);
-	return err;
-
-err_unmap_batch:
-	if (pw->batch_map)
-		i915_gem_object_unpin_map(batch);
-	else
-		i915_gem_object_unpin_pages(batch);
-err_unmap_shadow:
-	i915_gem_object_unpin_map(shadow->obj);
-err_trampoline:
-	if (trampoline)
-		i915_active_release(&trampoline->active);
-err_shadow:
-	i915_active_release(&shadow->active);
-err_batch:
-	i915_active_release(&eb->batch->vma->active);
-err_free:
-	kfree(pw);
-	return err;
-}
-
 static struct i915_vma *eb_dispatch_secure(struct i915_execbuffer *eb, struct i915_vma *vma)
 {
 	/*
@@ -2685,7 +2476,15 @@ static int eb_parse(struct i915_execbuffer *eb)
 		goto err_trampoline;
 	}
 
-	err = eb_parse_pipeline(eb, shadow, trampoline);
+	err = dma_resv_reserve_shared(shadow->resv, 1);
+	if (err)
+		goto err_trampoline;
+
+	err = intel_engine_cmd_parser(eb->engine,
+				      eb->batch->vma,
+				      eb->batch_start_offset,
+				      eb->batch_len,
+				      shadow, trampoline);
 	if (err)
 		goto err_unpin_batch;
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
index 4df505e4c53ae..16162fc2782dc 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
@@ -125,6 +125,10 @@ static int igt_gpu_reloc(void *arg)
 	intel_gt_pm_get(&eb.i915->gt);
 
 	for_each_uabi_engine(eb.engine, eb.i915) {
+		if (intel_engine_requires_cmd_parser(eb.engine) ||
+		    intel_engine_using_cmd_parser(eb.engine))
+			continue;
+
 		reloc_cache_init(&eb.reloc_cache, eb.i915);
 		memset(map, POISON_INUSE, 4096);
 
diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 3992c25a191da..00ec618d01590 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1145,19 +1145,41 @@ find_reg(const struct intel_engine_cs *engine, u32 addr)
 static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		       struct drm_i915_gem_object *src_obj,
 		       unsigned long offset, unsigned long length,
-		       void *dst, const void *src)
+		       bool *needs_clflush_after)
 {
-	bool needs_clflush =
-		!(src_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ);
-
-	if (src) {
-		GEM_BUG_ON(!needs_clflush);
-		i915_unaligned_memcpy_from_wc(dst, src + offset, length);
-	} else {
-		struct scatterlist *sg;
+	unsigned int src_needs_clflush;
+	unsigned int dst_needs_clflush;
+	void *dst, *src;
+	int ret;
+
+	ret = i915_gem_object_prepare_write(dst_obj, &dst_needs_clflush);
+	if (ret)
+		return ERR_PTR(ret);
+
+	dst = i915_gem_object_pin_map(dst_obj, I915_MAP_WB);
+	i915_gem_object_finish_access(dst_obj);
+	if (IS_ERR(dst))
+		return dst;
+
+	ret = i915_gem_object_prepare_read(src_obj, &src_needs_clflush);
+	if (ret) {
+		i915_gem_object_unpin_map(dst_obj);
+		return ERR_PTR(ret);
+	}
+
+	src = ERR_PTR(-ENODEV);
+	if (src_needs_clflush && i915_has_memcpy_from_wc()) {
+		src = i915_gem_object_pin_map(src_obj, I915_MAP_WC);
+		if (!IS_ERR(src)) {
+			i915_unaligned_memcpy_from_wc(dst,
+						      src + offset,
+						      length);
+			i915_gem_object_unpin_map(src_obj);
+		}
+	}
+	if (IS_ERR(src)) {
+		unsigned long x, n, remain;
 		void *ptr;
-		unsigned int x, sg_ofs;
-		unsigned long remain;
 
 		/*
 		 * We can avoid clflushing partial cachelines before the write
@@ -1168,40 +1190,34 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		 * validate up to the end of the batch.
 		 */
 		remain = length;
-		if (!(dst_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ))
+		if (dst_needs_clflush & CLFLUSH_BEFORE)
 			remain = round_up(remain,
 					  boot_cpu_data.x86_clflush_size);
 
 		ptr = dst;
 		x = offset_in_page(offset);
-		sg = i915_gem_object_get_sg(src_obj, offset >> PAGE_SHIFT, &sg_ofs, false);
-
-		while (remain) {
-			unsigned long sg_max = sg->length >> PAGE_SHIFT;
-
-			for (; remain && sg_ofs < sg_max; sg_ofs++) {
-				unsigned long len = min(remain, PAGE_SIZE - x);
-				void *map;
-
-				map = kmap_atomic(nth_page(sg_page(sg), sg_ofs));
-				if (needs_clflush)
-					drm_clflush_virt_range(map + x, len);
-				memcpy(ptr, map + x, len);
-				kunmap_atomic(map);
-
-				ptr += len;
-				remain -= len;
-				x = 0;
-			}
-
-			sg_ofs = 0;
-			sg = sg_next(sg);
+		for (n = offset >> PAGE_SHIFT; remain; n++) {
+			int len = min(remain, PAGE_SIZE - x);
+
+			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
+			if (src_needs_clflush)
+				drm_clflush_virt_range(src + x, len);
+			memcpy(ptr, src + x, len);
+			kunmap_atomic(src);
+
+			ptr += len;
+			remain -= len;
+			x = 0;
 		}
 	}
 
+	i915_gem_object_finish_access(src_obj);
+
 	memset32(dst + length, 0, (dst_obj->base.size - length) / sizeof(u32));
 
 	/* dst_obj is returned with vmap pinned */
+	*needs_clflush_after = dst_needs_clflush & CLFLUSH_AFTER;
+
 	return dst;
 }
 
@@ -1360,6 +1376,9 @@ static int check_bbstart(u32 *cmd, u32 offset, u32 length,
 	if (target_cmd_index == offset)
 		return 0;
 
+	if (IS_ERR(jump_whitelist))
+		return PTR_ERR(jump_whitelist);
+
 	if (!test_bit(target_cmd_index, jump_whitelist)) {
 		DRM_DEBUG("CMD: BB_START to 0x%llx not a previously executed cmd\n",
 			  jump_target);
@@ -1369,28 +1388,10 @@ static int check_bbstart(u32 *cmd, u32 offset, u32 length,
 	return 0;
 }
 
-/**
- * intel_engine_cmd_parser_alloc_jump_whitelist() - preallocate jump whitelist for intel_engine_cmd_parser()
- * @batch_length: length of the commands in batch_obj
- * @trampoline: Whether jump trampolines are used.
- *
- * Preallocates a jump whitelist for parsing the cmd buffer in intel_engine_cmd_parser().
- * This has to be preallocated, because the command parser runs in signaling context,
- * and may not allocate any memory.
- *
- * Return: NULL or pointer to a jump whitelist, or ERR_PTR() on failure. Use
- * IS_ERR() to check for errors. Must bre freed() with kfree().
- *
- * NULL is a valid value, meaning no allocation was required.
- */
-unsigned long *intel_engine_cmd_parser_alloc_jump_whitelist(u32 batch_length,
-							    bool trampoline)
+static unsigned long *alloc_whitelist(u32 batch_length)
 {
 	unsigned long *jmp;
 
-	if (trampoline)
-		return NULL;
-
 	/*
 	 * We expect batch_length to be less than 256KiB for known users,
 	 * i.e. we need at most an 8KiB bitmap allocation which should be
@@ -1425,21 +1426,21 @@ unsigned long *intel_engine_cmd_parser_alloc_jump_whitelist(u32 batch_length,
  * Return: non-zero if the parser finds violations or otherwise fails; -EACCES
  * if the batch appears legal but should use hardware parsing
  */
+
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
 			    unsigned long batch_offset,
 			    unsigned long batch_length,
 			    struct i915_vma *shadow,
-			    unsigned long *jump_whitelist,
-			    void *shadow_map,
-			    const void *batch_map)
+			    bool trampoline)
 {
 	u32 *cmd, *batch_end, offset = 0;
 	struct drm_i915_cmd_descriptor default_desc = noop_desc;
 	const struct drm_i915_cmd_descriptor *desc = &default_desc;
+	bool needs_clflush_after = false;
+	unsigned long *jump_whitelist;
 	u64 batch_addr, shadow_addr;
 	int ret = 0;
-	bool trampoline = !jump_whitelist;
 
 	GEM_BUG_ON(!IS_ALIGNED(batch_offset, sizeof(*cmd)));
 	GEM_BUG_ON(!IS_ALIGNED(batch_length, sizeof(*cmd)));
@@ -1447,8 +1448,18 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 				     batch->size));
 	GEM_BUG_ON(!batch_length);
 
-	cmd = copy_batch(shadow->obj, batch->obj, batch_offset, batch_length,
-			 shadow_map, batch_map);
+	cmd = copy_batch(shadow->obj, batch->obj,
+			 batch_offset, batch_length,
+			 &needs_clflush_after);
+	if (IS_ERR(cmd)) {
+		DRM_DEBUG("CMD: Failed to copy batch\n");
+		return PTR_ERR(cmd);
+	}
+
+	jump_whitelist = NULL;
+	if (!trampoline)
+		/* Defer failure until attempted use */
+		jump_whitelist = alloc_whitelist(batch_length);
 
 	shadow_addr = gen8_canonical_addr(shadow->node.start);
 	batch_addr = gen8_canonical_addr(batch->node.start + batch_offset);
@@ -1549,6 +1560,9 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 
 	i915_gem_object_flush_map(shadow->obj);
 
+	if (!IS_ERR_OR_NULL(jump_whitelist))
+		kfree(jump_whitelist);
+	i915_gem_object_unpin_map(shadow->obj);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index c4747f4407ef1..d38167a77ec00 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1957,17 +1957,12 @@ const char *i915_cache_level_str(struct drm_i915_private *i915, int type);
 int i915_cmd_parser_get_version(struct drm_i915_private *dev_priv);
 int intel_engine_init_cmd_parser(struct intel_engine_cs *engine);
 void intel_engine_cleanup_cmd_parser(struct intel_engine_cs *engine);
-unsigned long *intel_engine_cmd_parser_alloc_jump_whitelist(u32 batch_length,
-							    bool trampoline);
-
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
 			    unsigned long batch_offset,
 			    unsigned long batch_length,
 			    struct i915_vma *shadow,
-			    unsigned long *jump_whitelist,
-			    void *shadow_map,
-			    const void *batch_map);
+			    bool trampoline);
 #define I915_CMD_PARSER_TRAMPOLINE_SIZE 8
 
 /* intel_device_info.c */
-- 
2.31.1

