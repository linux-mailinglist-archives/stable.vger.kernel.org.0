Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3F6D080
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGROyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 10:54:14 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50213 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726513AbfGROyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 10:54:14 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17402281-1500050 
        for multiple; Thu, 18 Jul 2019 15:54:10 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] drm/i915: Use maximum write flush for pwrite_gtt
Date:   Thu, 18 Jul 2019 15:54:05 +0100
Message-Id: <20190718145407.21352-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718145407.21352-1-chris@chris-wilson.co.uk>
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As recently disovered by forcing big-core (!llc) machines to use the GTT
paths, we need our full GTT write flush before manipulating the GTT PTE
or else the writes may be directed to the wrong page.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fed0bc421a55..c6ba350e6e4f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -610,7 +610,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 		unsigned int page_length = PAGE_SIZE - page_offset;
 		page_length = remain < page_length ? remain : page_length;
 		if (node.allocated) {
-			wmb(); /* flush the write before we modify the GGTT */
+			/* flush the write before we modify the GGTT */
+			intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 			ggtt->vm.insert_page(&ggtt->vm,
 					     i915_gem_object_get_dma_address(obj, offset >> PAGE_SHIFT),
 					     node.start, I915_CACHE_NONE, 0);
@@ -639,8 +640,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 	i915_gem_object_unlock_fence(obj, fence);
 out_unpin:
 	mutex_lock(&i915->drm.struct_mutex);
+	intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 	if (node.allocated) {
-		wmb();
 		ggtt->vm.clear_range(&ggtt->vm, node.start, node.size);
 		remove_mappable_node(&node);
 	} else {
-- 
2.22.0

