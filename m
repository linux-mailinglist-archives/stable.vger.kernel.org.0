Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCB1996B5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgCaMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 08:42:11 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:64603 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730436AbgCaMmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 08:42:11 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20751955-1500050 
        for multiple; Tue, 31 Mar 2020 13:42:03 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Fill all the unused space in the GGTT
Date:   Tue, 31 Mar 2020 13:42:02 +0100
Message-Id: <20200331124202.4497-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
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

Reported-by: Imre Deak <imre.deak@intel.com>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_ggtt.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index d8944dabed55..ad56059651b8 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -191,10 +191,11 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 				     enum i915_cache_level level,
 				     u32 flags)
 {
+	const gen8_pte_t pte_encode = gen8_ggtt_pte_encode(0, level, 0);
 	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
 	struct sgt_iter sgt_iter;
-	gen8_pte_t __iomem *gtt_entries;
-	const gen8_pte_t pte_encode = gen8_ggtt_pte_encode(0, level, 0);
+	gen8_pte_t __iomem *gte;
+	gen8_pte_t __iomem *end;
 	dma_addr_t addr;
 
 	/*
@@ -202,10 +203,16 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 	 * not to allow the user to override access to a read only page.
 	 */
 
-	gtt_entries = (gen8_pte_t __iomem *)ggtt->gsm;
-	gtt_entries += vma->node.start / I915_GTT_PAGE_SIZE;
+	gte = (gen8_pte_t __iomem *)ggtt->gsm;
+	gte += vma->node.start / I915_GTT_PAGE_SIZE;
+	end = gte + vma->node.size / I915_GTT_PAGE_SIZE;
 	for_each_sgt_daddr(addr, sgt_iter, vma->pages)
-		gen8_set_pte(gtt_entries++, pte_encode | addr);
+		gen8_set_pte(gte++, pte_encode | addr);
+	GEM_BUG_ON(gte > end);
+
+	/* Fill the allocated but "unused" space beyond the end of the buffer */
+	while (gte < end)
+		gen8_set_pte(gte++, vm->scratch[0].encode);
 
 	/*
 	 * We want to flush the TLBs only after we're certain all the PTE
-- 
2.20.1

