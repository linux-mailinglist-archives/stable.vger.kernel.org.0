Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735826D585
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390241AbfGRT4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:56:54 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:52805 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727812AbfGRT4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:56:54 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17408887-1500050 
        for multiple; Thu, 18 Jul 2019 20:56:52 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Flush extra hard after writing relocations through the GTT
Date:   Thu, 18 Jul 2019 20:56:50 +0100
Message-Id: <20190718195650.20635-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
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
index 8a2047c4e7c3..01901dad33f7 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1019,11 +1019,12 @@ static void reloc_cache_reset(struct reloc_cache *cache)
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
@@ -1078,6 +1079,7 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 	void *vaddr;
 
 	if (cache->vaddr) {
+		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 		io_mapping_unmap_atomic((void __force __iomem *) unmask_page(cache->vaddr));
 	} else {
 		struct i915_vma *vma;
@@ -1119,7 +1121,6 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 
 	offset = cache->node.start;
 	if (cache->node.allocated) {
-		wmb();
 		ggtt->vm.insert_page(&ggtt->vm,
 				     i915_gem_object_get_dma_address(obj, page),
 				     offset, I915_CACHE_NONE, 0);
-- 
2.22.0

