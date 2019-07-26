Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6417611E
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 10:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfGZIqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 04:46:19 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:63254 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725878AbfGZIqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 04:46:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17621083-1500050 
        for multiple; Fri, 26 Jul 2019 09:46:16 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH 10/27] drm/i915: Flush extra hard after writing relocations through the GTT
Date:   Fri, 26 Jul 2019 09:45:56 +0100
Message-Id: <20190726084613.22129-10-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726084613.22129-1-chris@chris-wilson.co.uk>
References: <20190726084613.22129-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently discovered in commit bdae33b8b82b ("drm/i915: Use maximum write
flush for pwrite_gtt") was that we needed to our full write barrier
before changing the GGTT PTE to ensure that our indirect writes through
the GTT landed before the PTE changed (and the writes end up in a
different page). That also applies to our GGTT relocation path.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index cbd7c6e3a1f8..4db4463089ce 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1014,11 +1014,12 @@ static void reloc_cache_reset(struct reloc_cache *cache)
 		kunmap_atomic(vaddr);
 		i915_gem_object_finish_access((struct drm_i915_gem_object *)cache->node.mm);
 	} else {
-		wmb();
+		struct i915_ggtt *ggtt = cache_to_ggtt(cache);
+
+		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 		io_mapping_unmap_atomic((void __iomem *)vaddr);
-		if (cache->node.allocated) {
-			struct i915_ggtt *ggtt = cache_to_ggtt(cache);
 
+		if (cache->node.allocated) {
 			ggtt->vm.clear_range(&ggtt->vm,
 					     cache->node.start,
 					     cache->node.size);
@@ -1073,6 +1074,7 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 	void *vaddr;
 
 	if (cache->vaddr) {
+		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 		io_mapping_unmap_atomic((void __force __iomem *) unmask_page(cache->vaddr));
 	} else {
 		struct i915_vma *vma;
@@ -1114,7 +1116,6 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 
 	offset = cache->node.start;
 	if (cache->node.allocated) {
-		wmb();
 		ggtt->vm.insert_page(&ggtt->vm,
 				     i915_gem_object_get_dma_address(obj, page),
 				     offset, I915_CACHE_NONE, 0);
-- 
2.22.0

