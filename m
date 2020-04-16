Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C96A1AC672
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394381AbgDPOjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409560AbgDPOB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC7F20732;
        Thu, 16 Apr 2020 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045719;
        bh=NMUFoBmpwGS7c58K7u9EuChI6F1ONVgzsCUkmu/9A2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9RXipklNvrBvL4ywCHEuK4HvXDAmfz1E0Wm8P+4+kQ27SeNI+oxgQuhE65OSIVrA
         jrI6Lit4EQMigxOOtCRgGwrn10IfatqTgFOdW/piOhWJ89EHudLvFudhVK9kK1IcUa
         PtU8uueUzsQPurZbKcl6xpLgVkRDGCOxkr2i0UOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Sodhi, Vunny" <vunny.sodhi@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Michal Wajdeczko <michal.wajdeczko@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 249/254] drm/i915/ggtt: do not set bits 1-11 in gen12 ptes
Date:   Thu, 16 Apr 2020 15:25:38 +0200
Message-Id: <20200416131356.766805369@linuxfoundation.org>
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 69edc390a54268d41e45089cb972bf71510f5f07 ]

On TGL, bits 2-4 in the GGTT PTE are not ignored anymore and are
instead used for some extra VT-d capabilities. We don't (yet?) have
support for those capabilities, but, given that we shared the pte_encode
function betweed GGTT and PPGTT, we still set those bits to the PPGTT
PPAT values. The DMA engine gets very confused when those bits are
set while the iommu is enabled, leading to errors. E.g. when loading
the GuC we get:

[    9.796218] DMAR: DRHD: handling fault status reg 2
[    9.796235] DMAR: [DMA Write] Request device [00:02.0] PASID ffffffff fault addr 0 [fault reason 02] Present bit in context entry is clear
[    9.899215] [drm:intel_guc_fw_upload [i915]] *ERROR* GuC firmware signature verification failed

To fix this, just have dedicated gen8_pte_encode function per type of
gtt. Also, explicitly set vm->pte_encode for gen8_ppgtt, even if we
don't use it, to make sure we don't accidentally assign it to the GGTT
one, like we do for gen6_ppgtt, in case we need it in the future.

Reported-by: "Sodhi, Vunny" <vunny.sodhi@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200226185657.26445-1-daniele.ceraolospurio@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 26 ++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_ggtt.c | 13 ++++++++++---
 drivers/gpu/drm/i915/gt/intel_gtt.c  | 24 ------------------------
 drivers/gpu/drm/i915/gt/intel_gtt.h  |  4 ----
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 4d1de2d97d5cf..9aabc5815d388 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -25,6 +25,30 @@ static u64 gen8_pde_encode(const dma_addr_t addr,
 	return pde;
 }
 
+static u64 gen8_pte_encode(dma_addr_t addr,
+			   enum i915_cache_level level,
+			   u32 flags)
+{
+	gen8_pte_t pte = addr | _PAGE_PRESENT | _PAGE_RW;
+
+	if (unlikely(flags & PTE_READ_ONLY))
+		pte &= ~_PAGE_RW;
+
+	switch (level) {
+	case I915_CACHE_NONE:
+		pte |= PPAT_UNCACHED;
+		break;
+	case I915_CACHE_WT:
+		pte |= PPAT_DISPLAY_ELLC;
+		break;
+	default:
+		pte |= PPAT_CACHED;
+		break;
+	}
+
+	return pte;
+}
+
 static void gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
 {
 	struct drm_i915_private *i915 = ppgtt->vm.i915;
@@ -706,6 +730,8 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt)
 	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
 	ppgtt->vm.clear_range = gen8_ppgtt_clear;
 
+	ppgtt->vm.pte_encode = gen8_pte_encode;
+
 	if (intel_vgpu_active(gt->i915))
 		gen8_ppgtt_notify_vgt(ppgtt, true);
 
diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index 531d501be01fa..5fd8b3e0cd19c 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -167,6 +167,13 @@ static void gmch_ggtt_invalidate(struct i915_ggtt *ggtt)
 	intel_gtt_chipset_flush();
 }
 
+static u64 gen8_ggtt_pte_encode(dma_addr_t addr,
+				enum i915_cache_level level,
+				u32 flags)
+{
+	return addr | _PAGE_PRESENT;
+}
+
 static void gen8_set_pte(void __iomem *addr, gen8_pte_t pte)
 {
 	writeq(pte, addr);
@@ -182,7 +189,7 @@ static void gen8_ggtt_insert_page(struct i915_address_space *vm,
 	gen8_pte_t __iomem *pte =
 		(gen8_pte_t __iomem *)ggtt->gsm + offset / I915_GTT_PAGE_SIZE;
 
-	gen8_set_pte(pte, gen8_pte_encode(addr, level, 0));
+	gen8_set_pte(pte, gen8_ggtt_pte_encode(addr, level, 0));
 
 	ggtt->invalidate(ggtt);
 }
@@ -195,7 +202,7 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
 	struct sgt_iter sgt_iter;
 	gen8_pte_t __iomem *gtt_entries;
-	const gen8_pte_t pte_encode = gen8_pte_encode(0, level, 0);
+	const gen8_pte_t pte_encode = gen8_ggtt_pte_encode(0, level, 0);
 	dma_addr_t addr;
 
 	/*
@@ -890,7 +897,7 @@ static int gen8_gmch_probe(struct i915_ggtt *ggtt)
 	ggtt->vm.vma_ops.set_pages   = ggtt_set_pages;
 	ggtt->vm.vma_ops.clear_pages = clear_pages;
 
-	ggtt->vm.pte_encode = gen8_pte_encode;
+	ggtt->vm.pte_encode = gen8_ggtt_pte_encode;
 
 	setup_private_pat(ggtt->vm.gt->uncore);
 
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
index 16acdc5d67340..f6fcf05d54f36 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -454,30 +454,6 @@ void gtt_write_workarounds(struct intel_gt *gt)
 	}
 }
 
-u64 gen8_pte_encode(dma_addr_t addr,
-		    enum i915_cache_level level,
-		    u32 flags)
-{
-	gen8_pte_t pte = addr | _PAGE_PRESENT | _PAGE_RW;
-
-	if (unlikely(flags & PTE_READ_ONLY))
-		pte &= ~_PAGE_RW;
-
-	switch (level) {
-	case I915_CACHE_NONE:
-		pte |= PPAT_UNCACHED;
-		break;
-	case I915_CACHE_WT:
-		pte |= PPAT_DISPLAY_ELLC;
-		break;
-	default:
-		pte |= PPAT_CACHED;
-		break;
-	}
-
-	return pte;
-}
-
 static void tgl_setup_private_ppat(struct intel_uncore *uncore)
 {
 	/* TGL doesn't support LLC or AGE settings */
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.h b/drivers/gpu/drm/i915/gt/intel_gtt.h
index 7da7681c20b1b..7db9f3ac9aedb 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.h
@@ -515,10 +515,6 @@ struct i915_ppgtt *i915_ppgtt_create(struct intel_gt *gt);
 void i915_gem_suspend_gtt_mappings(struct drm_i915_private *i915);
 void i915_gem_restore_gtt_mappings(struct drm_i915_private *i915);
 
-u64 gen8_pte_encode(dma_addr_t addr,
-		    enum i915_cache_level level,
-		    u32 flags);
-
 int setup_page_dma(struct i915_address_space *vm, struct i915_page_dma *p);
 void cleanup_page_dma(struct i915_address_space *vm, struct i915_page_dma *p);
 
-- 
2.20.1



