Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8253719A0D8
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 23:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgCaVbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 17:31:16 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:63852 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727852AbgCaVbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 17:31:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20757566-1500050 
        for multiple; Tue, 31 Mar 2020 22:31:10 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH 02/11] drm/i915/gt: Fill all the unused space in the GGTT
Date:   Tue, 31 Mar 2020 22:30:59 +0100
Message-Id: <20200331213108.11340-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200331213108.11340-1-chris@chris-wilson.co.uk>
References: <20200331213108.11340-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we allocate space in the GGTT we may have to allocate a larger
region than will be populated by the object to accommodate fencing. Make
sure that this space beyond the end of the buffer points safely into
scratch space, in case the HW tries to access it anyway (e.g. fenced
access to the last tile row).

v2: Preemptively / conservatively guard gen6 ggtt as well.

Reported-by: Imre Deak <imre.deak@intel.com>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_ggtt.c | 37 ++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index d8944dabed55..ae07bcd7c226 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -191,10 +191,11 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 				     enum i915_cache_level level,
 				     u32 flags)
 {
-	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
-	struct sgt_iter sgt_iter;
-	gen8_pte_t __iomem *gtt_entries;
 	const gen8_pte_t pte_encode = gen8_ggtt_pte_encode(0, level, 0);
+	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
+	gen8_pte_t __iomem *gte;
+	gen8_pte_t __iomem *end;
+	struct sgt_iter iter;
 	dma_addr_t addr;
 
 	/*
@@ -202,10 +203,17 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 	 * not to allow the user to override access to a read only page.
 	 */
 
-	gtt_entries = (gen8_pte_t __iomem *)ggtt->gsm;
-	gtt_entries += vma->node.start / I915_GTT_PAGE_SIZE;
-	for_each_sgt_daddr(addr, sgt_iter, vma->pages)
-		gen8_set_pte(gtt_entries++, pte_encode | addr);
+	gte = (gen8_pte_t __iomem *)ggtt->gsm;
+	gte += vma->node.start / I915_GTT_PAGE_SIZE;
+	end = gte + vma->node.size / I915_GTT_PAGE_SIZE;
+
+	for_each_sgt_daddr(addr, iter, vma->pages)
+		gen8_set_pte(gte++, pte_encode | addr);
+	GEM_BUG_ON(gte > end);
+
+	/* Fill the allocated but "unused" space beyond the end of the buffer */
+	while (gte < end)
+		gen8_set_pte(gte++, vm->scratch[0].encode);
 
 	/*
 	 * We want to flush the TLBs only after we're certain all the PTE
@@ -241,13 +249,22 @@ static void gen6_ggtt_insert_entries(struct i915_address_space *vm,
 				     u32 flags)
 {
 	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
-	gen6_pte_t __iomem *entries = (gen6_pte_t __iomem *)ggtt->gsm;
-	unsigned int i = vma->node.start / I915_GTT_PAGE_SIZE;
+	gen6_pte_t __iomem *gte;
+	gen6_pte_t __iomem *end;
 	struct sgt_iter iter;
 	dma_addr_t addr;
 
+	gte = (gen6_pte_t __iomem *)ggtt->gsm;
+	gte += vma->node.start / I915_GTT_PAGE_SIZE;
+	end = gte + vma->node.size / I915_GTT_PAGE_SIZE;
+
 	for_each_sgt_daddr(addr, iter, vma->pages)
-		iowrite32(vm->pte_encode(addr, level, flags), &entries[i++]);
+		iowrite32(vm->pte_encode(addr, level, flags), gte++);
+	GEM_BUG_ON(gte > end);
+
+	/* Fill the allocated but "unused" space beyond the end of the buffer */
+	while (gte < end)
+		iowrite32(vm->scratch[0].encode, gte++);
 
 	/*
 	 * We want to flush the TLBs only after we're certain all the PTE
-- 
2.20.1

