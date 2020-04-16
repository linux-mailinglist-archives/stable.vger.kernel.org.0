Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E01AC49A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409594AbgDPOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409575AbgDPOCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F822078B;
        Thu, 16 Apr 2020 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045721;
        bh=rqFVzbwEDDBh3sVKfG18cizcwwfzoSsUz6l/2RBkno4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygLGJ0iMhKEhnB5cWMQRIK9GY6lmjlB+YV2qu5okZi+8r0koYdserMDC3HyoxHu0q
         HZxj6rgdfpm/wLqqfFeUOrWfTcYAO/MTHLUDplkJMU69Q5nCrPjjYpyTYQaXdqXJad
         Xvc0uo/FERuSCQWYG0IeoRO20CTxbXdR6zSqiWi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 250/254] drm/i915/gt: Fill all the unused space in the GGTT
Date:   Thu, 16 Apr 2020 15:25:39 +0200
Message-Id: <20200416131356.872202159@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 0b72a251bf92ca2378530fa1f9b35a71830ab51c ]

When we allocate space in the GGTT we may have to allocate a larger
region than will be populated by the object to accommodate fencing. Make
sure that this space beyond the end of the buffer points safely into
scratch space, in case the HW tries to access it anyway (e.g. fenced
access to the last tile row).

v2: Preemptively / conservatively guard gen6 ggtt as well.

Reported-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200331152348.26946-1-chris@chris-wilson.co.uk
(cherry picked from commit 4d6c18590870fbac1e65dde5e01e621c8e0ca096)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt.c | 37 ++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index 5fd8b3e0cd19c..d0d35c55170f8 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -199,10 +199,11 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
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
@@ -210,10 +211,17 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
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
@@ -249,13 +257,22 @@ static void gen6_ggtt_insert_entries(struct i915_address_space *vm,
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



