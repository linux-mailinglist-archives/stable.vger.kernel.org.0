Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F224D0D0
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 10:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHUIuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 04:50:25 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:55722 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727868AbgHUIuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 04:50:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22195100-1500050 
        for multiple; Fri, 21 Aug 2020 09:50:15 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     linux-mm@kvack.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] drm/i915/gem: Replace reloc chain with terminator on error unwind
Date:   Fri, 21 Aug 2020 09:50:11 +0100
Message-Id: <20200821085011.28878-4-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200821085011.28878-1-chris@chris-wilson.co.uk>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we hit an error during construction of the reloc chain, we need to
replace the chain into the next batch with the terminator so that upon
flushing the relocations so far, we do not execute a hanging batch.

Reported-by: Pavel Machek <pavel@ucw.cz>
Fixes: 964a9b0f611e ("drm/i915/gem: Use chained reloc batches")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <stable@vger.kernel.org> # v5.8+
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 31 ++++++++++---------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 24a1486d2dc5..a09f04eee417 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -972,21 +972,6 @@ static int reloc_gpu_chain(struct reloc_cache *cache)
 	if (err)
 		goto out_pool;
 
-	GEM_BUG_ON(cache->rq_size + RELOC_TAIL > PAGE_SIZE  / sizeof(u32));
-	cmd = cache->rq_cmd + cache->rq_size;
-	*cmd++ = MI_ARB_CHECK;
-	if (cache->gen >= 8)
-		*cmd++ = MI_BATCH_BUFFER_START_GEN8;
-	else if (cache->gen >= 6)
-		*cmd++ = MI_BATCH_BUFFER_START;
-	else
-		*cmd++ = MI_BATCH_BUFFER_START | MI_BATCH_GTT;
-	*cmd++ = lower_32_bits(batch->node.start);
-	*cmd++ = upper_32_bits(batch->node.start); /* Always 0 for gen<8 */
-	i915_gem_object_flush_map(cache->rq_vma->obj);
-	i915_gem_object_unpin_map(cache->rq_vma->obj);
-	cache->rq_vma = NULL;
-
 	err = intel_gt_buffer_pool_mark_active(pool, rq);
 	if (err == 0) {
 		i915_vma_lock(batch);
@@ -999,15 +984,31 @@ static int reloc_gpu_chain(struct reloc_cache *cache)
 	if (err)
 		goto out_pool;
 
+	GEM_BUG_ON(cache->rq_size + RELOC_TAIL > PAGE_SIZE  / sizeof(u32));
+	cmd = cache->rq_cmd + cache->rq_size;
+	*cmd++ = MI_ARB_CHECK;
+	if (cache->gen >= 8)
+		*cmd++ = MI_BATCH_BUFFER_START_GEN8;
+	else if (cache->gen >= 6)
+		*cmd++ = MI_BATCH_BUFFER_START;
+	else
+		*cmd++ = MI_BATCH_BUFFER_START | MI_BATCH_GTT;
+	*cmd++ = lower_32_bits(batch->node.start);
+	*cmd++ = upper_32_bits(batch->node.start); /* Always 0 for gen<8 */
+
 	cmd = i915_gem_object_pin_map(batch->obj,
 				      cache->has_llc ?
 				      I915_MAP_FORCE_WB :
 				      I915_MAP_FORCE_WC);
 	if (IS_ERR(cmd)) {
+		/* We will replace the BBS with BBE upon flushing the rq */
 		err = PTR_ERR(cmd);
 		goto out_pool;
 	}
 
+	i915_gem_object_flush_map(cache->rq_vma->obj);
+	i915_gem_object_unpin_map(cache->rq_vma->obj);
+
 	/* Return with batch mapping (cmd) still pinned */
 	cache->rq_cmd = cmd;
 	cache->rq_size = 0;
-- 
2.20.1

