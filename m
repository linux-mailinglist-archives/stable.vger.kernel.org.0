Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52717249A8F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHSKkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:40:03 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:52991 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727914AbgHSKj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:39:59 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22172040-1500050 
        for multiple; Wed, 19 Aug 2020 11:39:51 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/gem: Fallback to using a plain kmap if reloc address space is limited
Date:   Wed, 19 Aug 2020 11:39:52 +0100
Message-Id: <20200819103952.19083-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200819103952.19083-1-chris@chris-wilson.co.uk>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the processor may not support vmap with WC, or the system may be
limited in virtual address space and so may fail to create such a vmap,
fallback to using a plain kmap of the system pages and flush the buffer
on completion.

Reported-by: Pavel Machek <pavel@ucw.cz>
Fixes: 964a9b0f611e ("drm/i915/gem: Use chained reloc batches")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <stable@vger.kernel.org> # v5.8+
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index a09f04eee417..44df98d85b38 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -950,6 +950,21 @@ static void reloc_cache_init(struct reloc_cache *cache,
 
 #define RELOC_TAIL 4
 
+static u32 *__reloc_gpu_map(struct reloc_cache *cache,
+			    struct intel_gt_buffer_pool_node *pool)
+{
+	u32 *map;
+
+	map = i915_gem_object_pin_map(pool->obj,
+				      cache->has_llc ?
+				      I915_MAP_FORCE_WB :
+				      I915_MAP_FORCE_WC);
+	if (IS_ERR(map)) /* try a plain kmap (and flush) if no WC maps */
+		map = i915_gem_object_pin_map(pool->obj, I915_MAP_FORCE_WB);
+
+	return map;
+}
+
 static int reloc_gpu_chain(struct reloc_cache *cache)
 {
 	struct intel_gt_buffer_pool_node *pool;
@@ -996,10 +1011,7 @@ static int reloc_gpu_chain(struct reloc_cache *cache)
 	*cmd++ = lower_32_bits(batch->node.start);
 	*cmd++ = upper_32_bits(batch->node.start); /* Always 0 for gen<8 */
 
-	cmd = i915_gem_object_pin_map(batch->obj,
-				      cache->has_llc ?
-				      I915_MAP_FORCE_WB :
-				      I915_MAP_FORCE_WC);
+	cmd = __reloc_gpu_map(cache, pool);
 	if (IS_ERR(cmd)) {
 		/* We will replace the BBS with BBE upon flushing the rq */
 		err = PTR_ERR(cmd);
@@ -1096,10 +1108,7 @@ static int __reloc_gpu_alloc(struct i915_execbuffer *eb,
 	if (IS_ERR(pool))
 		return PTR_ERR(pool);
 
-	cmd = i915_gem_object_pin_map(pool->obj,
-				      cache->has_llc ?
-				      I915_MAP_FORCE_WB :
-				      I915_MAP_FORCE_WC);
+	cmd = __reloc_gpu_map(cache, pool);
 	if (IS_ERR(cmd)) {
 		err = PTR_ERR(cmd);
 		goto out_pool;
-- 
2.20.1

