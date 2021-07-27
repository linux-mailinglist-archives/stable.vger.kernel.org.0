Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3064A3D7AF2
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhG0Qag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhG0Qaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:30:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5BAC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 09:30:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so511710plr.11
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 09:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LK4AoJZhThiEVl1NJx7P11OihGVK8RUXmaWINg7FR4o=;
        b=ZLGEEASPvIVr2JNxwGbjYQqYpwDhUltraQutuL6wxH/z8gzZ2+0/Ds+ulilSm5cmWt
         dAExHE9vdSKOgeQSKgfePIzYAJ3wJqdXU805oYBJzHc8JI/Ca0pp3u61Za//COqG61S2
         Ke4T9zBhxMGWzcTdjjyKLVkjjfjp7SqSLM37/rBvIlHDhgn/SFyhKtlIPtPOYShzxsLR
         v2HmGSbvsxqujKd+2LsEu6L4c7IIS1d/kPocEZ4BQpV7Gjjhd9itqSztkCQyFtXWXu3v
         n876oojPdCwz22TgdwfQPAqiTVR0T6IcAGR1HST+BsMHMqnsqupsGdRdS6YwXGDVt4fd
         HFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LK4AoJZhThiEVl1NJx7P11OihGVK8RUXmaWINg7FR4o=;
        b=YnGNsHCNFrbSCiqHsY5QOgYrsadCKKlHLpzUHS7n5HJE83jvSneHmWm3FzhBZMA+2t
         6Vro+exUSEbt/zG+Cfz8zqWtUEoXHLIT1k+VwgDU6rNVVMbqL73XPW4bAQx/HqnuK29s
         8sE27bu+ms3/9SlXUFdeZWxw/w5z61gNnYbzbERhLYFvnEzgHc8tL15tWzAsOiN19ECG
         ZgVG/XfPLsLVq0CvEMMQo7AqTKNmw8MqQhGbId2DEXeQ8chvbFcY3jDAhCc/Utyi/XGD
         FCiQQiJqruXrmdStpdb6V5r6lgBmSIm5wmpR3hcGYYtBpxHrJlqdzQc7KhAv+ApTOgm3
         uDFQ==
X-Gm-Message-State: AOAM531iXfwPK35LY+73sgTozOpO/JKs1Bra1kF150Ey/pLQMk3eKC65
        Qu6Gpyf+uZtFtMP4RryYErrPXDXQbdk0URqo
X-Google-Smtp-Source: ABdhPJzu/PYkW5OywKUYLNkzc6BkAuTDcSwuClQ4GFiEMkOVlE20cllKaaTMZJ95xReLUszFVGuyww==
X-Received: by 2002:a62:cd47:0:b029:329:714e:cce2 with SMTP id o68-20020a62cd470000b0290329714ecce2mr24106856pfg.22.1627403429001;
        Tue, 27 Jul 2021 09:30:29 -0700 (PDT)
Received: from omlet.lan ([134.134.139.86])
        by smtp.gmail.com with ESMTPSA id x7sm4390286pfc.96.2021.07.27.09.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:30:28 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
Date:   Tue, 27 Jul 2021 11:30:23 -0500
Message-Id: <20210727163024.3536962-1-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 upstream.  This version
applies to the 5.10 tree.

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
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-2-jason@jlekstrand.net
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 164 +-----------------
 drivers/gpu/drm/i915/i915_cmd_parser.c        |  28 +--
 2 files changed, 25 insertions(+), 167 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index bd3046e5a9348..e5ac0936a5871 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -24,7 +24,6 @@
 #include "i915_gem_clflush.h"
 #include "i915_gem_context.h"
 #include "i915_gem_ioctls.h"
-#include "i915_sw_fence_work.h"
 #include "i915_trace.h"
 #include "i915_user_extensions.h"
 
@@ -1401,6 +1400,10 @@ static u32 *reloc_gpu(struct i915_execbuffer *eb,
 		int err;
 		struct intel_engine_cs *engine = eb->engine;
 
+		/* If we need to copy for the cmdparser, we will stall anyway */
+		if (eb_use_cmdparser(eb))
+			return ERR_PTR(-EWOULDBLOCK);
+
 		if (!reloc_can_use_engine(engine)) {
 			engine = engine->gt->engine_class[COPY_ENGINE_CLASS][0];
 			if (!engine)
@@ -2267,152 +2270,6 @@ shadow_batch_pin(struct i915_execbuffer *eb,
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
-};
-
-static int __eb_parse(struct dma_fence_work *work)
-{
-	struct eb_parse_work *pw = container_of(work, typeof(*pw), base);
-
-	return intel_engine_cmd_parser(pw->engine,
-				       pw->batch,
-				       pw->batch_offset,
-				       pw->batch_length,
-				       pw->shadow,
-				       pw->trampoline);
-}
-
-static void __eb_parse_release(struct dma_fence_work *work)
-{
-	struct eb_parse_work *pw = container_of(work, typeof(*pw), base);
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
@@ -2494,13 +2351,11 @@ static int eb_parse(struct i915_execbuffer *eb)
 		eb->batch_flags |= I915_DISPATCH_SECURE;
 	}
 
-	batch = eb_dispatch_secure(eb, shadow);
-	if (IS_ERR(batch)) {
-		err = PTR_ERR(batch);
-		goto err_trampoline;
-	}
-
-	err = eb_parse_pipeline(eb, shadow, trampoline);
+	err = intel_engine_cmd_parser(eb->engine,
+				      eb->batch->vma,
+				      eb->batch_start_offset,
+				      eb->batch_len,
+				      shadow, trampoline);
 	if (err)
 		goto err_unpin_batch;
 
@@ -2522,7 +2377,6 @@ static int eb_parse(struct i915_execbuffer *eb)
 err_unpin_batch:
 	if (batch)
 		i915_vma_unpin(batch);
-err_trampoline:
 	if (trampoline)
 		i915_vma_unpin(trampoline);
 err_shadow:
diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 9ce174950340b..635aae9145cb2 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1143,27 +1143,30 @@ find_reg(const struct intel_engine_cs *engine, u32 addr)
 /* Returns a vmap'd pointer to dst_obj, which the caller must unmap */
 static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		       struct drm_i915_gem_object *src_obj,
-		       unsigned long offset, unsigned long length)
+		       u32 offset, u32 length)
 {
-	bool needs_clflush;
+	unsigned int src_needs_clflush;
+	unsigned int dst_needs_clflush;
 	void *dst, *src;
 	int ret;
 
+	ret = i915_gem_object_prepare_write(dst_obj, &dst_needs_clflush);
+	if (ret)
+		return ERR_PTR(ret);
+
 	dst = i915_gem_object_pin_map(dst_obj, I915_MAP_FORCE_WB);
+	i915_gem_object_finish_access(dst_obj);
 	if (IS_ERR(dst))
 		return dst;
 
-	ret = i915_gem_object_pin_pages(src_obj);
+	ret = i915_gem_object_prepare_read(src_obj, &src_needs_clflush);
 	if (ret) {
 		i915_gem_object_unpin_map(dst_obj);
 		return ERR_PTR(ret);
 	}
 
-	needs_clflush =
-		!(src_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ);
-
 	src = ERR_PTR(-ENODEV);
-	if (needs_clflush && i915_has_memcpy_from_wc()) {
+	if (src_needs_clflush && i915_has_memcpy_from_wc()) {
 		src = i915_gem_object_pin_map(src_obj, I915_MAP_WC);
 		if (!IS_ERR(src)) {
 			i915_unaligned_memcpy_from_wc(dst,
@@ -1185,7 +1188,7 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		 * validate up to the end of the batch.
 		 */
 		remain = length;
-		if (!(dst_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ))
+		if (dst_needs_clflush & CLFLUSH_BEFORE)
 			remain = round_up(remain,
 					  boot_cpu_data.x86_clflush_size);
 
@@ -1195,7 +1198,7 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 			int len = min(remain, PAGE_SIZE - x);
 
 			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
-			if (needs_clflush)
+			if (src_needs_clflush)
 				drm_clflush_virt_range(src + x, len);
 			memcpy(ptr, src + x, len);
 			kunmap_atomic(src);
@@ -1206,11 +1209,10 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		}
 	}
 
-	i915_gem_object_unpin_pages(src_obj);
+	i915_gem_object_finish_access(src_obj);
 
 	memset32(dst + length, 0, (dst_obj->base.size - length) / sizeof(u32));
 
-	/* dst_obj is returned with vmap pinned */
 	return dst;
 }
 
@@ -1417,6 +1419,7 @@ static unsigned long *alloc_whitelist(u32 batch_length)
  * Return: non-zero if the parser finds violations or otherwise fails; -EACCES
  * if the batch appears legal but should use hardware parsing
  */
+
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
 			    unsigned long batch_offset,
@@ -1437,7 +1440,8 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 				     batch->size));
 	GEM_BUG_ON(!batch_length);
 
-	cmd = copy_batch(shadow->obj, batch->obj, batch_offset, batch_length);
+	cmd = copy_batch(shadow->obj, batch->obj,
+			 batch_offset, batch_length);
 	if (IS_ERR(cmd)) {
 		DRM_DEBUG("CMD: Failed to copy batch\n");
 		return PTR_ERR(cmd);
-- 
2.31.1

