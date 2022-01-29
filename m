Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E574A2DFD
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiA2LBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbiA2LAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D0C06174E;
        Sat, 29 Jan 2022 03:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C4060B25;
        Sat, 29 Jan 2022 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E228BC340ED;
        Sat, 29 Jan 2022 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643454010;
        bh=tPhnt0bYDmuss2dp1pJ2b8J38/UP+7whdYsTkIk7xYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxUr87wvdJuR2fJMrctug1IgKGRgVlnaQCmgbzyXLUU3I8hNu1nAaULHiFBSjXBqS
         etcLoLtqlV3ZLzC11ZNYGhMcQuzxkA1+nfY7qUhm+nK/y0zgy4I54QHt6nRj4lTva9
         cgK32kopnvKPdE+A3Mx4RSCfQBxlYSFkQQ5sq9OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.18
Date:   Sat, 29 Jan 2022 11:59:56 +0100
Message-Id: <164345399635246@kroah.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <1643453996204137@kroah.com>
References: <1643453996204137@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 088197ed3f66..385286f987d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 17
+SUBLEVEL = 18
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index b15eb4a3e6b2..840a35ed92ec 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,15 +22,6 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-static inline bool in_bpf_jit(struct pt_regs *regs)
-{
-	if (!IS_ENABLED(CONFIG_BPF_JIT))
-		return false;
-
-	return regs->pc >= BPF_JIT_REGION_START &&
-	       regs->pc < BPF_JIT_REGION_END;
-}
-
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index f1745a843414..05886322c300 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(_PAGE_END(VA_BITS_MIN))
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-(UL(1) << (VA_BITS - VMEMMAP_SHIFT)))
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b03e383d944a..fe0cd0568813 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -988,7 +988,7 @@ static struct break_hook bug_break_hook = {
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index aa0060178343..60a8b6a8a42b 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -9,14 +9,19 @@
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long addr;
 
-	fixup = search_exception_tables(instruction_pointer(regs));
-	if (!fixup)
-		return 0;
+	addr = instruction_pointer(regs);
 
-	if (in_bpf_jit(regs))
+	/* Search the BPF tables first, these are formatted differently */
+	fixup = search_bpf_extables(addr);
+	if (fixup)
 		return arm64_bpf_fixup_exception(fixup, regs);
 
+	fixup = search_exception_tables(addr);
+	if (!fixup)
+		return 0;
+
 	regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
 	return 1;
 }
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c403536c9bb..9bc4066c5bf3 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ static struct addr_marker address_markers[] = {
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 803e7773fa86..465c44d0c72f 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1138,15 +1138,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 u64 bpf_jit_alloc_exec_limit(void)
 {
-	return BPF_JIT_REGION_SIZE;
+	return VMALLOC_END - VMALLOC_START;
 }
 
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return vmalloc(size);
 }
 
 void bpf_jit_free_exec(void *addr)
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index b5d93247237b..c67e21244342 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -72,6 +72,9 @@
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0                                                                  0x049d
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0_BASE_IDX                                                         2
 
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2                                                          0x05ea
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2_BASE_IDX                                                 2
+
 
 static const char *gfxhub_client_ids[] = {
 	"CB",
@@ -1103,6 +1106,8 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 	u32 d1vga_control = RREG32_SOC15(DCE, 0, mmD1VGA_CONTROL);
 	unsigned size;
 
+	/* TODO move to DC so GMC doesn't need to hard-code DCN registers */
+
 	if (REG_GET_FIELD(d1vga_control, D1VGA_CONTROL, D1VGA_MODE_ENABLE)) {
 		size = AMDGPU_VBIOS_VGA_ALLOCATION;
 	} else {
@@ -1110,7 +1115,6 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 
 		switch (adev->asic_type) {
 		case CHIP_RAVEN:
-		case CHIP_RENOIR:
 			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION);
 			size = (REG_GET_FIELD(viewport,
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
@@ -1118,6 +1122,14 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
 				4);
 			break;
+		case CHIP_RENOIR:
+			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2);
+			size = (REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
+				REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
+				4);
+			break;
 		case CHIP_VEGA10:
 		case CHIP_VEGA12:
 		case CHIP_VEGA20:
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
index 8c2b77eb9459..162ae7186124 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -119,6 +119,12 @@ int dcn31_smu_send_msg_with_param(
 
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 
+	if (result == VBIOSSMC_Result_Failed) {
+		ASSERT(0);
+		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
+		return -1;
+	}
+
 	if (IS_SMU_TIMEOUT(result)) {
 		ASSERT(0);
 		dm_helpers_smu_timeout(CTX, msg_id, param, 10 * 200000);
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index 2471f36aaff3..3012cbe5b0b7 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -298,6 +298,7 @@ struct drm_i915_gem_object {
 			     I915_BO_ALLOC_USER)
 #define I915_BO_READONLY         BIT(4)
 #define I915_TILING_QUIRK_BIT    5 /* unknown swizzling; do not release! */
+#define I915_BO_WAS_BOUND_BIT    6
 
 	/**
 	 * @mem_flags - Mutable placement-related flags
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 8eb1c3a6fc9c..8d6c38a62201 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -10,6 +10,8 @@
 #include "i915_gem_lmem.h"
 #include "i915_gem_mman.h"
 
+#include "gt/intel_gt.h"
+
 void __i915_gem_object_set_pages(struct drm_i915_gem_object *obj,
 				 struct sg_table *pages,
 				 unsigned int sg_page_sizes)
@@ -218,6 +220,14 @@ __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 	__i915_gem_object_reset_page_iter(obj);
 	obj->mm.page_sizes.phys = obj->mm.page_sizes.sg = 0;
 
+	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+		intel_wakeref_t wakeref;
+
+		with_intel_runtime_pm_if_active(&i915->runtime_pm, wakeref)
+			intel_gt_invalidate_tlbs(&i915->gt);
+	}
+
 	return pages;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 62d40c986642..e1e1d17d49fd 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -29,6 +29,8 @@ void intel_gt_init_early(struct intel_gt *gt, struct drm_i915_private *i915)
 
 	spin_lock_init(&gt->irq_lock);
 
+	mutex_init(&gt->tlb_invalidate_lock);
+
 	INIT_LIST_HEAD(&gt->closed_vma);
 	spin_lock_init(&gt->closed_lock);
 
@@ -895,3 +897,103 @@ void intel_gt_info_print(const struct intel_gt_info *info,
 
 	intel_sseu_dump(&info->sseu, p);
 }
+
+struct reg_and_bit {
+	i915_reg_t reg;
+	u32 bit;
+};
+
+static struct reg_and_bit
+get_reg_and_bit(const struct intel_engine_cs *engine, const bool gen8,
+		const i915_reg_t *regs, const unsigned int num)
+{
+	const unsigned int class = engine->class;
+	struct reg_and_bit rb = { };
+
+	if (drm_WARN_ON_ONCE(&engine->i915->drm,
+			     class >= num || !regs[class].reg))
+		return rb;
+
+	rb.reg = regs[class];
+	if (gen8 && class == VIDEO_DECODE_CLASS)
+		rb.reg.reg += 4 * engine->instance; /* GEN8_M2TCR */
+	else
+		rb.bit = engine->instance;
+
+	rb.bit = BIT(rb.bit);
+
+	return rb;
+}
+
+void intel_gt_invalidate_tlbs(struct intel_gt *gt)
+{
+	static const i915_reg_t gen8_regs[] = {
+		[RENDER_CLASS]			= GEN8_RTCR,
+		[VIDEO_DECODE_CLASS]		= GEN8_M1TCR, /* , GEN8_M2TCR */
+		[VIDEO_ENHANCEMENT_CLASS]	= GEN8_VTCR,
+		[COPY_ENGINE_CLASS]		= GEN8_BTCR,
+	};
+	static const i915_reg_t gen12_regs[] = {
+		[RENDER_CLASS]			= GEN12_GFX_TLB_INV_CR,
+		[VIDEO_DECODE_CLASS]		= GEN12_VD_TLB_INV_CR,
+		[VIDEO_ENHANCEMENT_CLASS]	= GEN12_VE_TLB_INV_CR,
+		[COPY_ENGINE_CLASS]		= GEN12_BLT_TLB_INV_CR,
+	};
+	struct drm_i915_private *i915 = gt->i915;
+	struct intel_uncore *uncore = gt->uncore;
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
+	const i915_reg_t *regs;
+	unsigned int num = 0;
+
+	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
+		return;
+
+	if (GRAPHICS_VER(i915) == 12) {
+		regs = gen12_regs;
+		num = ARRAY_SIZE(gen12_regs);
+	} else if (GRAPHICS_VER(i915) >= 8 && GRAPHICS_VER(i915) <= 11) {
+		regs = gen8_regs;
+		num = ARRAY_SIZE(gen8_regs);
+	} else if (GRAPHICS_VER(i915) < 8) {
+		return;
+	}
+
+	if (drm_WARN_ONCE(&i915->drm, !num,
+			  "Platform does not implement TLB invalidation!"))
+		return;
+
+	GEM_TRACE("\n");
+
+	assert_rpm_wakelock_held(&i915->runtime_pm);
+
+	mutex_lock(&gt->tlb_invalidate_lock);
+	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
+
+	for_each_engine(engine, gt, id) {
+		/*
+		 * HW architecture suggest typical invalidation time at 40us,
+		 * with pessimistic cases up to 100us and a recommendation to
+		 * cap at 1ms. We go a bit higher just in case.
+		 */
+		const unsigned int timeout_us = 100;
+		const unsigned int timeout_ms = 4;
+		struct reg_and_bit rb;
+
+		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
+		if (!i915_mmio_reg_offset(rb.reg))
+			continue;
+
+		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+		if (__intel_wait_for_register_fw(uncore,
+						 rb.reg, rb.bit, 0,
+						 timeout_us, timeout_ms,
+						 NULL))
+			drm_err_ratelimited(&gt->i915->drm,
+					    "%s TLB invalidation did not complete in %ums!\n",
+					    engine->name, timeout_ms);
+	}
+
+	intel_uncore_forcewake_put_delayed(uncore, FORCEWAKE_ALL);
+	mutex_unlock(&gt->tlb_invalidate_lock);
+}
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.h b/drivers/gpu/drm/i915/gt/intel_gt.h
index 74e771871a9b..c0169d6017c2 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt.h
@@ -90,4 +90,6 @@ void intel_gt_info_print(const struct intel_gt_info *info,
 
 void intel_gt_watchdog_work(struct work_struct *work);
 
+void intel_gt_invalidate_tlbs(struct intel_gt *gt);
+
 #endif /* __INTEL_GT_H__ */
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_types.h b/drivers/gpu/drm/i915/gt/intel_gt_types.h
index a81e21bf1bd1..9fbcbcc6c35d 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_types.h
@@ -72,6 +72,8 @@ struct intel_gt {
 
 	struct intel_uc uc;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct intel_gt_timelines {
 		spinlock_t lock; /* protects active_list */
 		struct list_head active_list;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 9023d4ecf3b3..c65473fc9093 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2669,6 +2669,12 @@ static inline bool i915_mmio_reg_valid(i915_reg_t reg)
 #define   GAMT_CHKN_DISABLE_DYNAMIC_CREDIT_SHARING	(1 << 28)
 #define   GAMT_CHKN_DISABLE_I2M_CYCLE_ON_WR_PORT	(1 << 24)
 
+#define GEN8_RTCR	_MMIO(0x4260)
+#define GEN8_M1TCR	_MMIO(0x4264)
+#define GEN8_M2TCR	_MMIO(0x4268)
+#define GEN8_BTCR	_MMIO(0x426c)
+#define GEN8_VTCR	_MMIO(0x4270)
+
 #if 0
 #define PRB0_TAIL	_MMIO(0x2030)
 #define PRB0_HEAD	_MMIO(0x2034)
@@ -2763,6 +2769,11 @@ static inline bool i915_mmio_reg_valid(i915_reg_t reg)
 #define   FAULT_VA_HIGH_BITS		(0xf << 0)
 #define   FAULT_GTT_SEL			(1 << 4)
 
+#define GEN12_GFX_TLB_INV_CR	_MMIO(0xced8)
+#define GEN12_VD_TLB_INV_CR	_MMIO(0xcedc)
+#define GEN12_VE_TLB_INV_CR	_MMIO(0xcee0)
+#define GEN12_BLT_TLB_INV_CR	_MMIO(0xcee4)
+
 #define GEN12_AUX_ERR_DBG		_MMIO(0x43f4)
 
 #define FPGA_DBG		_MMIO(0x42300)
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 4b7fc4647e46..dfd20060812b 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -434,6 +434,9 @@ int i915_vma_bind(struct i915_vma *vma,
 		vma->ops->bind_vma(vma->vm, NULL, vma, cache_level, bind_flags);
 	}
 
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	atomic_or(bind_flags, &vma->flags);
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index 6b38bc2811c1..de8d0558389c 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -718,7 +718,8 @@ void intel_uncore_forcewake_get__locked(struct intel_uncore *uncore,
 }
 
 static void __intel_uncore_forcewake_put(struct intel_uncore *uncore,
-					 enum forcewake_domains fw_domains)
+					 enum forcewake_domains fw_domains,
+					 bool delayed)
 {
 	struct intel_uncore_forcewake_domain *domain;
 	unsigned int tmp;
@@ -733,7 +734,11 @@ static void __intel_uncore_forcewake_put(struct intel_uncore *uncore,
 			continue;
 		}
 
-		uncore->funcs.force_wake_put(uncore, domain->mask);
+		if (delayed &&
+		    !(domain->uncore->fw_domains_timer & domain->mask))
+			fw_domain_arm_timer(domain);
+		else
+			uncore->funcs.force_wake_put(uncore, domain->mask);
 	}
 }
 
@@ -754,7 +759,20 @@ void intel_uncore_forcewake_put(struct intel_uncore *uncore,
 		return;
 
 	spin_lock_irqsave(&uncore->lock, irqflags);
-	__intel_uncore_forcewake_put(uncore, fw_domains);
+	__intel_uncore_forcewake_put(uncore, fw_domains, false);
+	spin_unlock_irqrestore(&uncore->lock, irqflags);
+}
+
+void intel_uncore_forcewake_put_delayed(struct intel_uncore *uncore,
+					enum forcewake_domains fw_domains)
+{
+	unsigned long irqflags;
+
+	if (!uncore->funcs.force_wake_put)
+		return;
+
+	spin_lock_irqsave(&uncore->lock, irqflags);
+	__intel_uncore_forcewake_put(uncore, fw_domains, true);
 	spin_unlock_irqrestore(&uncore->lock, irqflags);
 }
 
@@ -796,7 +814,7 @@ void intel_uncore_forcewake_put__locked(struct intel_uncore *uncore,
 	if (!uncore->funcs.force_wake_put)
 		return;
 
-	__intel_uncore_forcewake_put(uncore, fw_domains);
+	__intel_uncore_forcewake_put(uncore, fw_domains, false);
 }
 
 void assert_forcewakes_inactive(struct intel_uncore *uncore)
diff --git a/drivers/gpu/drm/i915/intel_uncore.h b/drivers/gpu/drm/i915/intel_uncore.h
index 3c0b0a8b5250..4c63209dcf53 100644
--- a/drivers/gpu/drm/i915/intel_uncore.h
+++ b/drivers/gpu/drm/i915/intel_uncore.h
@@ -229,6 +229,8 @@ void intel_uncore_forcewake_get(struct intel_uncore *uncore,
 				enum forcewake_domains domains);
 void intel_uncore_forcewake_put(struct intel_uncore *uncore,
 				enum forcewake_domains domains);
+void intel_uncore_forcewake_put_delayed(struct intel_uncore *uncore,
+					enum forcewake_domains domains);
 void intel_uncore_forcewake_flush(struct intel_uncore *uncore,
 				  enum forcewake_domains fw_domains);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 2a7cec4cb8a8..f9f28516ffb4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1112,15 +1112,14 @@ extern int vmw_execbuf_fence_commands(struct drm_file *file_priv,
 				      struct vmw_private *dev_priv,
 				      struct vmw_fence_obj **p_fence,
 				      uint32_t *p_handle);
-extern void vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
+extern int vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 					struct vmw_fpriv *vmw_fp,
 					int ret,
 					struct drm_vmw_fence_rep __user
 					*user_fence_rep,
 					struct vmw_fence_obj *fence,
 					uint32_t fence_handle,
-					int32_t out_fence_fd,
-					struct sync_file *sync_file);
+					int32_t out_fence_fd);
 bool vmw_cmd_describe(const void *buf, u32 *size, char const **cmd);
 
 /**
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 5f2ffa9de5c8..9144e8f88c81 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3823,17 +3823,17 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
  * Also if copying fails, user-space will be unable to signal the fence object
  * so we wait for it immediately, and then unreference the user-space reference.
  */
-void
+int
 vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 			    struct vmw_fpriv *vmw_fp, int ret,
 			    struct drm_vmw_fence_rep __user *user_fence_rep,
 			    struct vmw_fence_obj *fence, uint32_t fence_handle,
-			    int32_t out_fence_fd, struct sync_file *sync_file)
+			    int32_t out_fence_fd)
 {
 	struct drm_vmw_fence_rep fence_rep;
 
 	if (user_fence_rep == NULL)
-		return;
+		return 0;
 
 	memset(&fence_rep, 0, sizeof(fence_rep));
 
@@ -3861,20 +3861,14 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 	 * handle.
 	 */
 	if (unlikely(ret != 0) && (fence_rep.error == 0)) {
-		if (sync_file)
-			fput(sync_file->file);
-
-		if (fence_rep.fd != -1) {
-			put_unused_fd(fence_rep.fd);
-			fence_rep.fd = -1;
-		}
-
 		ttm_ref_object_base_unref(vmw_fp->tfile, fence_handle,
 					  TTM_REF_USAGE);
 		VMW_DEBUG_USER("Fence copy error. Syncing.\n");
 		(void) vmw_fence_obj_wait(fence, false, false,
 					  VMW_FENCE_WAIT_TIMEOUT);
 	}
+
+	return ret ? -EFAULT : 0;
 }
 
 /**
@@ -4212,16 +4206,23 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 
 			(void) vmw_fence_obj_wait(fence, false, false,
 						  VMW_FENCE_WAIT_TIMEOUT);
+		}
+	}
+
+	ret = vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
+				    user_fence_rep, fence, handle, out_fence_fd);
+
+	if (sync_file) {
+		if (ret) {
+			/* usercopy of fence failed, put the file object */
+			fput(sync_file->file);
+			put_unused_fd(out_fence_fd);
 		} else {
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
 		}
 	}
 
-	vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
-				    user_fence_rep, fence, handle, out_fence_fd,
-				    sync_file);
-
 	/* Don't unreference when handing fence out */
 	if (unlikely(out_fence != NULL)) {
 		*out_fence = fence;
@@ -4239,7 +4240,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	 */
 	vmw_validation_unref_lists(&val_ctx);
 
-	return 0;
+	return ret;
 
 out_unlock_binding:
 	mutex_unlock(&dev_priv->binding_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 9fe12329a4d5..b4d9d7258a54 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1159,7 +1159,7 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 	}
 
 	vmw_execbuf_copy_fence_user(dev_priv, vmw_fp, 0, user_fence_rep, fence,
-				    handle, -1, NULL);
+				    handle, -1);
 	vmw_fence_obj_unreference(&fence);
 	return 0;
 out_no_create:
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 74fa41909213..14e8f665b13b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2516,7 +2516,7 @@ void vmw_kms_helper_validation_finish(struct vmw_private *dev_priv,
 	if (file_priv)
 		vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv),
 					    ret, user_fence_rep, fence,
-					    handle, -1, NULL);
+					    handle, -1);
 	if (out_fence)
 		*out_fence = fence;
 	else
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index e789430f407c..72bdbebf25ce 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1850,6 +1850,14 @@ struct bnx2x {
 
 	/* Vxlan/Geneve related information */
 	u16 udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
+
+#define FW_CAP_INVALIDATE_VF_FP_HSI	BIT(0)
+	u32 fw_cap;
+
+	u32 fw_major;
+	u32 fw_minor;
+	u32 fw_rev;
+	u32 fw_eng;
 };
 
 /* Tx queues may be less or equal to Rx queues */
@@ -2525,5 +2533,6 @@ void bnx2x_register_phc(struct bnx2x *bp);
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-
+int bnx2x_init_firmware(struct bnx2x *bp);
+void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index b5d954cb409a..41ebbb2c7d3a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2364,10 +2364,8 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
 		/* build my FW version dword */
-		u32 my_fw = (BCM_5710_FW_MAJOR_VERSION) +
-			(BCM_5710_FW_MINOR_VERSION << 8) +
-			(BCM_5710_FW_REVISION_VERSION << 16) +
-			(BCM_5710_FW_ENGINEERING_VERSION << 24);
+		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
+				(bp->fw_rev << 16) + (bp->fw_eng << 24);
 
 		/* read loaded FW from chip */
 		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
index 3f8435208bf4..a84d015da5df 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
@@ -241,6 +241,8 @@
 	IRO[221].m2))
 #define XSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[48].base + ((funcId) * IRO[48].m1))
+#define XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(fid)	\
+	(IRO[386].base + ((fid) * IRO[386].m1))
 #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
 
 /* eth hsi version */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
index 622fadc50316..611efee75834 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
@@ -3024,7 +3024,8 @@ struct afex_stats {
 
 #define BCM_5710_FW_MAJOR_VERSION			7
 #define BCM_5710_FW_MINOR_VERSION			13
-#define BCM_5710_FW_REVISION_VERSION		15
+#define BCM_5710_FW_REVISION_VERSION		21
+#define BCM_5710_FW_REVISION_VERSION_V15	15
 #define BCM_5710_FW_ENGINEERING_VERSION		0
 #define BCM_5710_FW_COMPILE_FLAGS			1
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index ae87296ae1ff..10a5b43976d2 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -74,9 +74,19 @@
 	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
 	__stringify(BCM_5710_FW_REVISION_VERSION) "."	\
 	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
+#define FW_FILE_VERSION_V15				\
+	__stringify(BCM_5710_FW_MAJOR_VERSION) "."      \
+	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
+	__stringify(BCM_5710_FW_REVISION_VERSION_V15) "."	\
+	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
 #define FW_FILE_NAME_E1		"bnx2x/bnx2x-e1-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E1H	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E2		"bnx2x/bnx2x-e2-" FW_FILE_VERSION ".fw"
+#define FW_FILE_NAME_E1_V15	"bnx2x/bnx2x-e1-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E1H_V15	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E2_V15	"bnx2x/bnx2x-e2-" FW_FILE_VERSION_V15 ".fw"
 
 /* Time in jiffies before concluding the transmitter is hung */
 #define TX_TIMEOUT		(5*HZ)
@@ -747,9 +757,7 @@ static int bnx2x_mc_assert(struct bnx2x *bp)
 		  CHIP_IS_E1(bp) ? "everest1" :
 		  CHIP_IS_E1H(bp) ? "everest1h" :
 		  CHIP_IS_E2(bp) ? "everest2" : "everest3",
-		  BCM_5710_FW_MAJOR_VERSION,
-		  BCM_5710_FW_MINOR_VERSION,
-		  BCM_5710_FW_REVISION_VERSION);
+		  bp->fw_major, bp->fw_minor, bp->fw_rev);
 
 	return rc;
 }
@@ -12302,6 +12310,15 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	bnx2x_read_fwinfo(bp);
 
+	if (IS_PF(bp)) {
+		rc = bnx2x_init_firmware(bp);
+
+		if (rc) {
+			bnx2x_free_mem_bp(bp);
+			return rc;
+		}
+	}
+
 	func = BP_FUNC(bp);
 
 	/* need to reset chip if undi was active */
@@ -12314,6 +12331,7 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
+			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13311,16 +13329,11 @@ static int bnx2x_check_firmware(struct bnx2x *bp)
 	/* Check FW version */
 	offset = be32_to_cpu(fw_hdr->fw_version.offset);
 	fw_ver = firmware->data + offset;
-	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
-	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
-	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
-	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
+	if (fw_ver[0] != bp->fw_major || fw_ver[1] != bp->fw_minor ||
+	    fw_ver[2] != bp->fw_rev || fw_ver[3] != bp->fw_eng) {
 		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be %d.%d.%d.%d\n",
-		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
-		       BCM_5710_FW_MAJOR_VERSION,
-		       BCM_5710_FW_MINOR_VERSION,
-		       BCM_5710_FW_REVISION_VERSION,
-		       BCM_5710_FW_ENGINEERING_VERSION);
+			  fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
+			  bp->fw_major, bp->fw_minor, bp->fw_rev, bp->fw_eng);
 		return -EINVAL;
 	}
 
@@ -13398,34 +13411,51 @@ do {									\
 	     (u8 *)bp->arr, len);					\
 } while (0)
 
-static int bnx2x_init_firmware(struct bnx2x *bp)
+int bnx2x_init_firmware(struct bnx2x *bp)
 {
-	const char *fw_file_name;
+	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
 	int rc;
 
 	if (bp->firmware)
 		return 0;
 
-	if (CHIP_IS_E1(bp))
+	if (CHIP_IS_E1(bp)) {
 		fw_file_name = FW_FILE_NAME_E1;
-	else if (CHIP_IS_E1H(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1_V15;
+	} else if (CHIP_IS_E1H(bp)) {
 		fw_file_name = FW_FILE_NAME_E1H;
-	else if (!CHIP_IS_E1x(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1H_V15;
+	} else if (!CHIP_IS_E1x(bp)) {
 		fw_file_name = FW_FILE_NAME_E2;
-	else {
+		fw_file_name_v15 = FW_FILE_NAME_E2_V15;
+	} else {
 		BNX2X_ERR("Unsupported chip revision\n");
 		return -EINVAL;
 	}
+
 	BNX2X_DEV_INFO("Loading %s\n", fw_file_name);
 
 	rc = request_firmware(&bp->firmware, fw_file_name, &bp->pdev->dev);
 	if (rc) {
-		BNX2X_ERR("Can't load firmware file %s\n",
-			  fw_file_name);
-		goto request_firmware_exit;
+		BNX2X_DEV_INFO("Trying to load older fw %s\n", fw_file_name_v15);
+
+		/* try to load prev version */
+		rc = request_firmware(&bp->firmware, fw_file_name_v15, &bp->pdev->dev);
+
+		if (rc)
+			goto request_firmware_exit;
+
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION_V15;
+	} else {
+		bp->fw_cap |= FW_CAP_INVALIDATE_VF_FP_HSI;
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION;
 	}
 
+	bp->fw_major = BCM_5710_FW_MAJOR_VERSION;
+	bp->fw_minor = BCM_5710_FW_MINOR_VERSION;
+	bp->fw_eng = BCM_5710_FW_ENGINEERING_VERSION;
+
 	rc = bnx2x_check_firmware(bp);
 	if (rc) {
 		BNX2X_ERR("Corrupt firmware file %s\n", fw_file_name);
@@ -13481,7 +13511,7 @@ static int bnx2x_init_firmware(struct bnx2x *bp)
 	return rc;
 }
 
-static void bnx2x_release_firmware(struct bnx2x *bp)
+void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -13998,6 +14028,7 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	return 0;
 
 init_one_freemem:
+	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 6fbf735fca31..561395731450 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
 void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)
 {
+	u16 abs_fid;
+
+	abs_fid = FW_VF_HANDLE(abs_vfid);
+
 	/* set the VF-PF association in the FW */
-	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid), BP_FUNC(bp));
-	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
+	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
+	storm_memset_func_en(bp, abs_fid, 1);
+
+	/* Invalidate fp_hsi version for vfs */
+	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
+		REG_WR8(bp, BAR_XSTRORM_INTMEM +
+			    XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
 
 	/* clear vf errors*/
 	bnx2x_vf_semi_clear_err(bp, abs_vfid);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index ecffeddf90c6..f713b91537f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1760,6 +1760,18 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     long res, unsigned int cflags)
 {
@@ -2200,6 +2212,10 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -9766,18 +9782,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_drop_tctx_refs(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-	unsigned int refs = tctx->cached_refs;
-
-	if (refs) {
-		tctx->cached_refs = 0;
-		percpu_counter_sub(&tctx->inflight, refs);
-		put_task_struct_many(task, refs);
-	}
-}
-
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -9834,10 +9838,14 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_idle set for normal exit.
+		 */
+		atomic_dec(&tctx->in_idle);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
diff --git a/fs/select.c b/fs/select.c
index 945896d0ac9e..5edffee1162c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -458,9 +458,11 @@ static int max_select_fd(unsigned long n, fd_set_bits *fds)
 	return max;
 }
 
-#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR)
-#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR)
-#define POLLEX_SET (EPOLLPRI)
+#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR |\
+			EPOLLNVAL)
+#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR |\
+			 EPOLLNVAL)
+#define POLLEX_SET (EPOLLPRI | EPOLLNVAL)
 
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit,
@@ -527,6 +529,7 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					break;
 				if (!(bit & all_bits))
 					continue;
+				mask = EPOLLNVAL;
 				f = fdget(i);
 				if (f.file) {
 					wait_key_set(wait, in, out, bit,
@@ -534,34 +537,34 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					mask = vfs_poll(f.file, wait);
 
 					fdput(f);
-					if ((mask & POLLIN_SET) && (in & bit)) {
-						res_in |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLOUT_SET) && (out & bit)) {
-						res_out |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLEX_SET) && (ex & bit)) {
-						res_ex |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					/* got something, stop busy polling */
-					if (retval) {
-						can_busy_loop = false;
-						busy_flag = 0;
-
-					/*
-					 * only remember a returned
-					 * POLL_BUSY_LOOP if we asked for it
-					 */
-					} else if (busy_flag & mask)
-						can_busy_loop = true;
-
 				}
+				if ((mask & POLLIN_SET) && (in & bit)) {
+					res_in |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLOUT_SET) && (out & bit)) {
+					res_out |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLEX_SET) && (ex & bit)) {
+					res_ex |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				/* got something, stop busy polling */
+				if (retval) {
+					can_busy_loop = false;
+					busy_flag = 0;
+
+				/*
+				 * only remember a returned
+				 * POLL_BUSY_LOOP if we asked for it
+				 */
+				} else if (busy_flag & mask)
+					can_busy_loop = true;
+
 			}
 			if (res_in)
 				*rinp = res_in;
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7ae10fab68b8..4ca6d5b199e8 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1594,10 +1594,11 @@ static void __maybe_unused rcu_advance_cbs_nowake(struct rcu_node *rnp,
 						  struct rcu_data *rdp)
 {
 	rcu_lockdep_assert_cblist_protected(rdp);
-	if (!rcu_seq_state(rcu_seq_current(&rnp->gp_seq)) ||
-	    !raw_spin_trylock_rcu_node(rnp))
+	if (!rcu_seq_state(rcu_seq_current(&rnp->gp_seq)) || !raw_spin_trylock_rcu_node(rnp))
 		return;
-	WARN_ON_ONCE(rcu_advance_cbs(rnp, rdp));
+	// The grace period cannot end while we hold the rcu_node lock.
+	if (rcu_seq_state(rcu_seq_current(&rnp->gp_seq)))
+		WARN_ON_ONCE(rcu_advance_cbs(rnp, rdp));
 	raw_spin_unlock_rcu_node(rnp);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 87e41c3cac10..96cd7eae800b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -103,11 +103,6 @@ static bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
 
-/* memcg and lruvec stats flushing */
-static void flush_memcg_stats_dwork(struct work_struct *w);
-static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_SPINLOCK(stats_flush_lock);
-
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
 
@@ -635,6 +630,64 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 	return mz;
 }
 
+/*
+ * memcg and lruvec stats flushing
+ *
+ * Many codepaths leading to stats update or read are performance sensitive and
+ * adding stats flushing in such codepaths is not desirable. So, to optimize the
+ * flushing the kernel does:
+ *
+ * 1) Periodically and asynchronously flush the stats every 2 seconds to not let
+ *    rstat update tree grow unbounded.
+ *
+ * 2) Flush the stats synchronously on reader side only when there are more than
+ *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
+ *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
+ *    only for 2 seconds due to (1).
+ */
+static void flush_memcg_stats_dwork(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
+static DEFINE_SPINLOCK(stats_flush_lock);
+static DEFINE_PER_CPU(unsigned int, stats_updates);
+static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
+{
+	unsigned int x;
+
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+
+	x = __this_cpu_add_return(stats_updates, abs(val));
+	if (x > MEMCG_CHARGE_BATCH) {
+		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		__this_cpu_write(stats_updates, 0);
+	}
+}
+
+static void __mem_cgroup_flush_stats(void)
+{
+	unsigned long flag;
+
+	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
+		return;
+
+	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	atomic_set(&stats_flush_threshold, 0);
+	spin_unlock_irqrestore(&stats_flush_lock, flag);
+}
+
+void mem_cgroup_flush_stats(void)
+{
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+		__mem_cgroup_flush_stats();
+}
+
+static void flush_memcg_stats_dwork(struct work_struct *w)
+{
+	__mem_cgroup_flush_stats();
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -647,7 +700,7 @@ void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg, val);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -675,10 +728,12 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	memcg = pn->memcg;
 
 	/* Update memcg */
-	__mod_memcg_state(memcg, idx, val);
+	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
 
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+
+	memcg_rstat_updated(memcg, val);
 }
 
 /**
@@ -780,7 +835,7 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg, count);
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -1414,7 +1469,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	 *
 	 * Current memory state:
 	 */
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3507,8 +3562,7 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		/* mem_cgroup_threshold() calls here from irqsafe context */
-		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+		mem_cgroup_flush_stats();
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3889,7 +3943,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -3961,7 +4015,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4464,7 +4518,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -5330,21 +5384,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg_wb_domain_size_changed(memcg);
 }
 
-void mem_cgroup_flush_stats(void)
-{
-	if (!spin_trylock(&stats_flush_lock))
-		return;
-
-	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
-	spin_unlock(&stats_flush_lock);
-}
-
-static void flush_memcg_stats_dwork(struct work_struct *w)
-{
-	mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
-}
-
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
@@ -6362,7 +6401,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
