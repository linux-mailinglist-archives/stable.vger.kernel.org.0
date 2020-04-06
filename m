Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7038519FA4D
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgDFQjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 12:39:44 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:56365 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729519AbgDFQjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 12:39:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20818680-1500050 
        for multiple; Mon, 06 Apr 2020 17:39:31 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Apply more mb() around clflush relocation paths
Date:   Mon,  6 Apr 2020 17:39:31 +0100
Message-Id: <20200406163931.6979-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Having spent some time with DBG_FORCE_RELOC == FORCE_CPU_RELOC, it
appears that our memory barriers around the clflush are lackluster for
our more seldom used paths. Seldom used does not mean never, so apply
the memory barriers or else we may randomly see incorrect relocation
addresses inside batches.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 230ba1aee355..d9ab517bbce9 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1037,6 +1037,8 @@ static void *reloc_kmap(struct drm_i915_gem_object *obj,
 	void *vaddr;
 
 	if (cache->vaddr) {
+		if (cache->vaddr & CLFLUSH_AFTER)
+			mb();
 		kunmap_atomic(unmask_page(cache->vaddr));
 	} else {
 		unsigned int flushes;
@@ -1051,14 +1053,15 @@ static void *reloc_kmap(struct drm_i915_gem_object *obj,
 
 		cache->vaddr = flushes | KMAP;
 		cache->node.mm = (void *)obj;
-		if (flushes)
-			mb();
 	}
 
 	vaddr = kmap_atomic(i915_gem_object_get_dirty_page(obj, page));
 	cache->vaddr = unmask_flags(cache->vaddr) | (unsigned long)vaddr;
 	cache->page = page;
 
+	if (cache->vaddr & CLFLUSH_BEFORE)
+		mb();
+
 	return vaddr;
 }
 
@@ -1163,8 +1166,10 @@ static void clflush_write32(u32 *addr, u32 value, unsigned int flushes)
 		 * mb barriers at the start and end of the relocation phase
 		 * to ensure ordering of clflush wrt to the system.
 		 */
-		if (flushes & CLFLUSH_AFTER)
+		if (flushes & CLFLUSH_AFTER) {
+			mb();
 			clflushopt(addr);
+		}
 	} else
 		*addr = value;
 }
-- 
2.20.1

