Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DCE6D78D5
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbjDEJtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbjDEJsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB9A619E;
        Wed,  5 Apr 2023 02:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE0FF63C6C;
        Wed,  5 Apr 2023 09:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA76C433EF;
        Wed,  5 Apr 2023 09:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688046;
        bh=0QSYJjE2iARe1totPZ7qA+yonuNKNS2/Gpfc3wP3kbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQS5oJhNC/JWKN3fKT6h7JoABgF0Uq/1o/zod9xc0dLg3RSC17DmVT2xWh5sIoBBN
         /3zmHQtf4ezAAdNf9ysk1w93dkn1lIpQYGY7ZDlbokx5FhblxOK7BkV5xfUQp9Q9Ez
         WQTwlOAIziS3SUc8liWRDODiwnLxT+h5hfUwJ3/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.106
Date:   Wed,  5 Apr 2023 11:47:16 +0200
Message-Id: <2023040515-prewar-purgatory-4df4@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023040515-monorail-everglade-9a41@gregkh>
References: <2023040515-monorail-everglade-9a41@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 915e9a34994f..6459e91369fd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 105
+SUBLEVEL = 106
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 69bd1732a299..9b465cd55a8d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -468,14 +468,33 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 				   CONFIG_PGTABLE_LEVELS),
 		.mm_ops		= &kvm_user_mm_ops,
 	};
+	unsigned long flags;
 	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
 	u32 level = ~0;
 	int ret;
 
+	/*
+	 * Disable IRQs so that we hazard against a concurrent
+	 * teardown of the userspace page tables (which relies on
+	 * IPI-ing threads).
+	 */
+	local_irq_save(flags);
 	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
-	VM_BUG_ON(ret);
-	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
-	VM_BUG_ON(!(pte & PTE_VALID));
+	local_irq_restore(flags);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * Not seeing an error, but not updating level? Something went
+	 * deeply wrong...
+	 */
+	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
+		return -EFAULT;
+
+	/* Oops, the userspace PTs are gone... Replay the fault */
+	if (!kvm_pte_valid(pte))
+		return -EAGAIN;
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
@@ -826,7 +845,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  *
  * Returns the size of the mapping.
  */
-static unsigned long
+static long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
@@ -838,8 +857,15 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
-	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
+	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, hva);
+
+		if (sz < 0)
+			return sz;
+
+		if (sz < PMD_SIZE)
+			return PAGE_SIZE;
+
 		/*
 		 * The address we faulted on is backed by a transparent huge
 		 * page.  However, because we map the compound huge page and
@@ -957,7 +983,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
-	unsigned long vma_pagesize, fault_granule;
+	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
@@ -1104,6 +1130,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
+
+		if (vma_pagesize < 0) {
+			ret = vma_pagesize;
+			goto out_unlock;
+		}
 	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
index 915ce4b189c1..76c5d8e4d6e2 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -64,6 +64,8 @@ phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
+bool bmips_rac_flush_disable;
+
 void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
@@ -74,6 +76,9 @@ void arch_sync_dma_for_cpu_all(void)
 	    boot_cpu_type() != CPU_BMIPS4380)
 		return;
 
+	if (unlikely(bmips_rac_flush_disable))
+		return;
+
 	/* Flush stale data out of the readahead cache */
 	cfg = __raw_readl(cbr + BMIPS_RAC_CONFIG);
 	__raw_writel(cfg | 0x100, cbr + BMIPS_RAC_CONFIG);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 31bcfa4e08b9..45c7cf582348 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -34,6 +34,8 @@
 #define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
 #define BCM6328_TP1_DISABLED	BIT(9)
 
+extern bool bmips_rac_flush_disable;
+
 static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
 
 struct bmips_quirk {
@@ -103,6 +105,12 @@ static void bcm6358_quirks(void)
 	 * disable SMP for now
 	 */
 	bmips_smp_enabled = 0;
+
+	/*
+	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
+	 * because the bootloader is not initializing it properly.
+	 */
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
 }
 
 static void bcm6368_quirks(void)
diff --git a/arch/powerpc/kernel/ptrace/ptrace-view.c b/arch/powerpc/kernel/ptrace/ptrace-view.c
index b8be1d6668b5..54dfa6a2aec8 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -290,6 +290,9 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 static int ppr_get(struct task_struct *target, const struct user_regset *regset,
 		   struct membuf to)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return membuf_write(&to, &target->thread.regs->ppr, sizeof(u64));
 }
 
@@ -297,6 +300,9 @@ static int ppr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count, const void *kbuf,
 		   const void __user *ubuf)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &target->thread.regs->ppr, 0, sizeof(u64));
 }
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 0b012ce0921c..25be1424d393 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -227,7 +227,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(6b,2b) EX_TABLE(3b,5b) EX_TABLE(7b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), [spec] "K" (0x81UL)
 		: "cc", "memory", "0");
 	return size;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8c9e41ff2a24..40fc1879a697 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2316,6 +2316,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->irr_pending = (apic_search_irr(apic) != -1);
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
@@ -2368,7 +2369,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2638,7 +2638,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
 		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu,
@@ -2802,6 +2801,10 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
@@ -2836,6 +2839,10 @@ int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ce45554d637..c95c3675e8d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7597,17 +7597,11 @@ static int vmx_pre_block(struct kvm_vcpu *vcpu)
 	if (pi_pre_block(vcpu))
 		return 1;
 
-	if (kvm_lapic_hv_timer_in_use(vcpu))
-		kvm_lapic_switch_to_sw_timer(vcpu);
-
 	return 0;
 }
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops.set_hv_timer)
-		kvm_lapic_switch_to_hv_timer(vcpu);
-
 	pi_post_block(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0622256cd768..5cb4af42ba64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10043,12 +10043,28 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	bool hv_timer;
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+		/*
+		 * Switch to the software timer before halt-polling/blocking as
+		 * the guest's timer may be a break event for the vCPU, and the
+		 * hypervisor timer runs only when the CPU is in guest mode.
+		 * Switch before halt-polling so that KVM recognizes an expired
+		 * timer before blocking.
+		 */
+		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
+		if (hv_timer)
+			kvm_lapic_switch_to_sw_timer(vcpu);
+
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
+		if (hv_timer)
+			kvm_lapic_switch_to_hv_timer(vcpu);
+
 		if (kvm_x86_ops.post_block)
 			static_call(kvm_x86_post_block)(vcpu);
 
@@ -10287,6 +10303,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+		/*
+		 * It should be impossible for the hypervisor timer to be in
+		 * use before KVM has ever run the vCPU.
+		 */
+		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 4953260e281c..40b5779fce21 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 
-obj-$(CONFIG_XEN_PV_DOM0)	+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= vga.o
 
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 561aad13412f..998db0257e2a 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1353,7 +1353,8 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 		x86_platform.set_legacy_features =
 				xen_dom0_set_legacy_features;
-		xen_init_vga(info, xen_start_info->console.dom0.info_size);
+		xen_init_vga(info, xen_start_info->console.dom0.info_size,
+			     &boot_params.screen_info);
 		xen_start_info->console.domU.mfn = 0;
 		xen_start_info->console.domU.evtchn = 0;
 
diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index bcae606bbc5c..ada3868c02c2 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -43,6 +43,19 @@ void __init xen_pvh_init(struct boot_params *boot_params)
 	x86_init.oem.banner = xen_banner;
 
 	xen_efi_init(boot_params);
+
+	if (xen_initial_domain()) {
+		struct xen_platform_op op = {
+			.cmd = XENPF_get_dom0_console,
+		};
+		int ret = HYPERVISOR_platform_op(&op);
+
+		if (ret > 0)
+			xen_init_vga(&op.u.dom0_console,
+				     min(ret * sizeof(char),
+					 sizeof(op.u.dom0_console)),
+				     &boot_params->screen_info);
+	}
 }
 
 void __init mem_map_via_hcall(struct boot_params *boot_params_p)
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
index e336f223f7f4..93697109592c 100644
--- a/arch/x86/xen/vga.c
+++ b/arch/x86/xen/vga.c
@@ -9,10 +9,9 @@
 
 #include "xen-ops.h"
 
-void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
+void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size,
+			 struct screen_info *screen_info)
 {
-	struct screen_info *screen_info = &boot_params.screen_info;
-
 	/* This is drawn from a dump from vgacon:startup in
 	 * standard Linux. */
 	screen_info->orig_video_mode = 3;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 16aed4b12129..71f31032c635 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -110,11 +110,12 @@ static inline void xen_uninit_lock_cpu(int cpu)
 
 struct dom0_vga_console_info;
 
-#ifdef CONFIG_XEN_PV_DOM0
-void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+#ifdef CONFIG_XEN_DOM0
+void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size,
+			 struct screen_info *);
 #else
 static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
-				       size_t size)
+				       size_t size, struct screen_info *si)
 {
 }
 #endif
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 904086ad5682..5624a64ff7e9 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -510,7 +510,7 @@ static size_t kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -519,9 +519,17 @@ void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
 	printk("%sStack:\n", loglvl);
-	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
-		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
-		       sp, len, false);
+	while (off < len) {
+		u8 line[STACK_DUMP_LINE_SIZE];
+		size_t line_len = len - off > STACK_DUMP_LINE_SIZE ?
+			STACK_DUMP_LINE_SIZE : len - off;
+
+		__memcpy(line, (u8 *)sp + off, line_len);
+		print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
+			       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
+			       line, line_len, false);
+		off += STACK_DUMP_LINE_SIZE;
+	}
 	show_trace(task, sp, loglvl);
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 07cf7a35ae50..c96bdb3e7ac5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -736,6 +736,10 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 
 	if (!file)
 		return -EBADF;
+
+	/* suppress uevents while reconfiguring the device */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
+
 	is_loop = is_loop_device(file);
 	error = loop_global_lock_killable(lo, is_loop);
 	if (error)
@@ -790,13 +794,18 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	fput(old_file);
 	if (partscan)
 		loop_reread_partitions(lo);
-	return 0;
+
+	error = 0;
+done:
+	/* enable and uncork uevent now that we are done */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	return error;
 
 out_err:
 	loop_global_unlock(lo, is_loop);
 out_putf:
 	fput(file);
-	return error;
+	goto done;
 }
 
 /* loop sysfs attributes */
@@ -1256,6 +1265,9 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		goto out_unlock;
 	}
 
+	/* suppress uevents while reconfiguring the device */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
+
 	disk_force_media_change(lo->lo_disk, DISK_EVENT_MEDIA_CHANGE);
 	set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
@@ -1304,11 +1316,16 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	if (partscan)
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
 
+	/* enable and uncork uevent now that we are done */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
 		loop_reread_partitions(lo);
+
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(bdev, loop_configure);
+
 	return 0;
 
 out_unlock:
diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 28bb65a5613f..201767823edb 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -192,8 +192,8 @@ static int weim_parse_dt(struct platform_device *pdev, void __iomem *base)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct cs_timing_state ts = {};
 	u32 reg;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index bc02e3e0d17d..7a3fee71a867 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -184,6 +184,21 @@ static bool needs_dsc_aux_workaround(struct dc_link *link)
 	return false;
 }
 
+bool is_synaptics_cascaded_panamera(struct dc_link *link, struct drm_dp_mst_port *port)
+{
+	u8 branch_vendor_data[4] = { 0 }; // Vendor data 0x50C ~ 0x50F
+
+	if (drm_dp_dpcd_read(port->mgr->aux, DP_BRANCH_VENDOR_SPECIFIC_START, &branch_vendor_data, 4) == 4) {
+		if (link->dpcd_caps.branch_dev_id == DP_BRANCH_DEVICE_ID_90CC24 &&
+				IS_SYNAPTICS_CASCADED_PANAMERA(link->dpcd_caps.branch_dev_name, branch_vendor_data)) {
+			DRM_INFO("Synaptics Cascaded MST hub\n");
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnector)
 {
 	struct dc_sink *dc_sink = aconnector->dc_sink;
@@ -207,6 +222,10 @@ static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnecto
 	    needs_dsc_aux_workaround(aconnector->dc_link))
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
+	/* synaptics cascaded MST hub case */
+	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+		aconnector->dsc_aux = port->mgr->aux;
+
 	if (!aconnector->dsc_aux)
 		return false;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index 900d3f7a8498..f7523fd23f54 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -26,6 +26,18 @@
 #ifndef __DAL_AMDGPU_DM_MST_TYPES_H__
 #define __DAL_AMDGPU_DM_MST_TYPES_H__
 
+#define DP_BRANCH_VENDOR_SPECIFIC_START 0x50C
+
+/**
+ * Panamera MST Hub detection
+ * Offset DPCD 050Eh == 0x5A indicates cascaded MST hub case
+ * Check from beginning of branch device vendor specific field (050Ch)
+ */
+#define IS_SYNAPTICS_PANAMERA(branchDevName) (((int)branchDevName[4] & 0xF0) == 0x50 ? 1 : 0)
+#define BRANCH_HW_REVISION_PANAMERA_A2 0x10
+#define SYNAPTICS_CASCADED_HUB_ID  0x5A
+#define IS_SYNAPTICS_CASCADED_PANAMERA(devName, data) ((IS_SYNAPTICS_PANAMERA(devName) && ((int)data[2] == SYNAPTICS_CASCADED_HUB_ID)) ? 1 : 0)
+
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
index 6d8bed9c739d..aa7227bfb5c5 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -88,7 +88,15 @@ static void *etnaviv_gem_prime_vmap_impl(struct etnaviv_gem_object *etnaviv_obj)
 static int etnaviv_gem_prime_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
 		struct vm_area_struct *vma)
 {
-	return dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	int ret;
+
+	ret = dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	if (!ret) {
+		/* Drop the reference acquired by drm_gem_mmap_obj(). */
+		drm_gem_object_put(&etnaviv_obj->base);
+	}
+
+	return ret;
 }
 
 static const struct etnaviv_gem_ops etnaviv_gem_prime_ops = {
diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 0e885440be24..1b5b4d252d5b 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -386,9 +386,9 @@ static bool icl_tc_phy_is_owned(struct intel_digital_port *dig_port)
 				PORT_TX_DFLEXDPCSSS(dig_port->tc_phy_fia));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
-			    "Port %s: PHY in TCCOLD, assume safe mode\n",
+			    "Port %s: PHY in TCCOLD, assume not owned\n",
 			    dig_port->tc_port_name);
-		return true;
+		return false;
 	}
 
 	return val & DP_PHY_MODE_STATUS_NOT_SAFE(dig_port->tc_phy_fia_idx);
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4a6b33bbe7ea..dd08ce97e7c9 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 			x = y = z = 0;
 
 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (s8)x / 4);
+		input_report_rel(dev2, REL_Y, -((s8)y / 4));
 
 		psmouse_report_standard_buttons(dev2, packet[3]);
 
@@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
 
-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (s8)x);
+	input_report_rel(dev2, REL_Y, -((s8)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);
 
 	psmouse_report_standard_buttons(dev2, packet[1]);
@@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
diff --git a/drivers/input/mouse/focaltech.c b/drivers/input/mouse/focaltech.c
index 6fd5fff0cbff..c74b99077d16 100644
--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -202,8 +202,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;
 	if (finger1 < FOC_MAX_FINGERS) {
-		state->fingers[finger1].x += (char)packet[1];
-		state->fingers[finger1].y += (char)packet[2];
+		state->fingers[finger1].x += (s8)packet[1];
+		state->fingers[finger1].y += (s8)packet[2];
 	} else {
 		psmouse_err(psmouse, "First finger in rel packet invalid: %d\n",
 			    finger1);
@@ -218,8 +218,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (s8)packet[4];
+		state->fingers[finger2].y += (s8)packet[5];
 	}
 }
 
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 0b513fcd51d1..166d36b2626e 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -123,10 +123,18 @@ static const unsigned long goodix_irq_flags[] = {
 static const struct dmi_system_id nine_bytes_report[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
-		.ident = "Lenovo YogaBook",
-		/* YB1-X91L/F and YB1-X90L/F */
+		/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9")
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		}
+	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		}
 	},
 #endif
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index bff2420fc3e1..7c20083d4a79 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1080,7 +1080,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	err = -EINVAL;
-	if (cap_sagaw(iommu->cap) == 0) {
+	if (!cap_sagaw(iommu->cap) &&
+	    (!ecap_smts(iommu->ecap) || ecap_slts(iommu->ecap))) {
 		pr_info("%s: No supported address widths. Not attempting DMA translation.\n",
 			iommu->name);
 		drhd->ignored = 1;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9e54b865f30d..bd0c9dfac981 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3189,6 +3189,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index b97adeee4cc1..4fd20e70aabd 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -172,6 +172,7 @@ struct meson_nfc {
 
 	dma_addr_t daddr;
 	dma_addr_t iaddr;
+	u32 info_bytes;
 
 	unsigned long assigned_cs;
 };
@@ -499,6 +500,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 					 nfc->daddr, datalen, dir);
 			return ret;
 		}
+		nfc->info_bytes = infolen;
 		cmd = GENCMDIADDRL(NFC_CMD_AIL, nfc->iaddr);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
@@ -516,8 +518,10 @@ static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 
 	dma_unmap_single(nfc->dev, nfc->daddr, datalen, dir);
-	if (infolen)
+	if (infolen) {
 		dma_unmap_single(nfc->dev, nfc->iaddr, infolen, dir);
+		nfc->info_bytes = 0;
+	}
 }
 
 static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
@@ -706,6 +710,8 @@ static void meson_nfc_check_ecc_pages_valid(struct meson_nfc *nfc,
 		usleep_range(10, 15);
 		/* info is updated by nfc dma engine*/
 		smp_rmb();
+		dma_sync_single_for_cpu(nfc->dev, nfc->iaddr, nfc->info_bytes,
+					DMA_FROM_DEVICE);
 		ret = *info & ECC_COMPLETE;
 	} while (!ret);
 }
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 5883fa7edda2..54f3e033abbf 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -86,22 +86,16 @@ static const struct regmap_bus regmap_smi[] = {
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
-		.max_raw_read = 1,
-		.max_raw_write = 1,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 2,
-		.max_raw_write = 2,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 4,
-		.max_raw_write = 4,
 	}
 };
 
@@ -112,7 +106,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 8,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -122,7 +115,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 16,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -132,7 +124,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 32,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 99c4e45c62e3..8a030dc0b8a3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2912,9 +2912,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4e98e34fc46b..4ef90e0cb8f8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -223,12 +223,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
 	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
-	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57508_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e5874c829226..ae4695fc067d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1202,6 +1202,7 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_40GB	PORT_PHY_QCFG_RESP_LINK_SPEED_40GB
 #define BNXT_LINK_SPEED_50GB	PORT_PHY_QCFG_RESP_LINK_SPEED_50GB
 #define BNXT_LINK_SPEED_100GB	PORT_PHY_QCFG_RESP_LINK_SPEED_100GB
+#define BNXT_LINK_SPEED_200GB	PORT_PHY_QCFG_RESP_LINK_SPEED_200GB
 	u16			support_speeds;
 	u16			support_pam4_speeds;
 	u16			auto_link_speeds;	/* fw adv setting */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 586311a271f2..bc9812a0a91c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1670,6 +1670,8 @@ u32 bnxt_fw_to_ethtool_speed(u16 fw_link_speed)
 		return SPEED_50000;
 	case BNXT_LINK_SPEED_100GB:
 		return SPEED_100000;
+	case BNXT_LINK_SPEED_200GB:
+		return SPEED_200000;
 	default:
 		return SPEED_UNKNOWN;
 	}
@@ -3504,6 +3506,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		bnxt_ulp_stop(bp);
 		rc = bnxt_close_nic(bp, true, false);
 		if (rc) {
+			etest->flags |= ETH_TEST_FL_FAILED;
 			bnxt_ulp_start(bp, rc);
 			return;
 		}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.c b/drivers/net/ethernet/intel/i40e/i40e_diag.c
index ef4d3762bf37..ca229b0efeb6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.c
@@ -44,7 +44,7 @@ static i40e_status i40e_diag_reg_pattern_test(struct i40e_hw *hw,
 	return 0;
 }
 
-struct i40e_diag_reg_test_info i40e_reg_list[] = {
+const struct i40e_diag_reg_test_info i40e_reg_list[] = {
 	/* offset               mask         elements   stride */
 	{I40E_QTX_CTL(0),       0x0000FFBF, 1,
 		I40E_QTX_CTL(1) - I40E_QTX_CTL(0)},
@@ -78,27 +78,28 @@ i40e_status i40e_diag_reg_test(struct i40e_hw *hw)
 {
 	i40e_status ret_code = 0;
 	u32 reg, mask;
+	u32 elements;
 	u32 i, j;
 
 	for (i = 0; i40e_reg_list[i].offset != 0 &&
 					     !ret_code; i++) {
 
+		elements = i40e_reg_list[i].elements;
 		/* set actual reg range for dynamically allocated resources */
 		if (i40e_reg_list[i].offset == I40E_QTX_CTL(0) &&
 		    hw->func_caps.num_tx_qp != 0)
-			i40e_reg_list[i].elements = hw->func_caps.num_tx_qp;
+			elements = hw->func_caps.num_tx_qp;
 		if ((i40e_reg_list[i].offset == I40E_PFINT_ITRN(0, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(1, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(2, 0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_TQCTL(0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_RQCTL(0)) &&
 		    hw->func_caps.num_msix_vectors != 0)
-			i40e_reg_list[i].elements =
-				hw->func_caps.num_msix_vectors - 1;
+			elements = hw->func_caps.num_msix_vectors - 1;
 
 		/* test register access */
 		mask = i40e_reg_list[i].mask;
-		for (j = 0; j < i40e_reg_list[i].elements && !ret_code; j++) {
+		for (j = 0; j < elements && !ret_code; j++) {
 			reg = i40e_reg_list[i].offset +
 			      (j * i40e_reg_list[i].stride);
 			ret_code = i40e_diag_reg_pattern_test(hw, reg, mask);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.h b/drivers/net/ethernet/intel/i40e/i40e_diag.h
index c3340f320a18..1db7c6d57231 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.h
@@ -20,7 +20,7 @@ struct i40e_diag_reg_test_info {
 	u32 stride;	/* bytes between each element */
 };
 
-extern struct i40e_diag_reg_test_info i40e_reg_list[];
+extern const struct i40e_diag_reg_test_info i40e_reg_list[];
 
 i40e_status i40e_diag_reg_test(struct i40e_hw *hw);
 i40e_status i40e_diag_eeprom_test(struct i40e_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2d9b10277186..0b61fde44915 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2758,7 +2758,7 @@ static enum ice_status
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	enum ice_status status = 0;
 	struct ice_hw *hw = pi->hw;
@@ -2776,11 +2776,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index eee180d8c024..4b738f739109 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -731,6 +731,72 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_has_prof_conflict
+ * @vf: pointer to the VF structure
+ * @conf: FDIR configuration for each filter
+ *
+ * Check if @conf has conflicting profile with existing profiles
+ *
+ * Return: true on success, and false on error.
+ */
+static bool
+ice_vc_fdir_has_prof_conflict(struct ice_vf *vf,
+			      struct virtchnl_fdir_fltr_conf *conf)
+{
+	struct ice_fdir_fltr *desc;
+
+	list_for_each_entry(desc, &vf->fdir.fdir_rule_list, fltr_node) {
+		struct virtchnl_fdir_fltr_conf *existing_conf;
+		enum ice_fltr_ptype flow_type_a, flow_type_b;
+		struct ice_fdir_fltr *a, *b;
+
+		existing_conf = to_fltr_conf_from_desc(desc);
+		a = &existing_conf->input;
+		b = &conf->input;
+		flow_type_a = a->flow_type;
+		flow_type_b = b->flow_type;
+
+		/* No need to compare two rules with different tunnel types or
+		 * with the same protocol type.
+		 */
+		if (existing_conf->ttype != conf->ttype ||
+		    flow_type_a == flow_type_b)
+			continue;
+
+		switch (flow_type_a) {
+		case ICE_FLTR_PTYPE_NONF_IPV4_UDP:
+		case ICE_FLTR_PTYPE_NONF_IPV4_TCP:
+		case ICE_FLTR_PTYPE_NONF_IPV4_SCTP:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_OTHER)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_SCTP)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV6_UDP:
+		case ICE_FLTR_PTYPE_NONF_IPV6_TCP:
+		case ICE_FLTR_PTYPE_NONF_IPV6_SCTP:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_OTHER)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV6_OTHER:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_UDP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_TCP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_SCTP)
+				return true;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
 /**
  * ice_vc_fdir_write_flow_prof
  * @vf: pointer to the VF structure
@@ -871,6 +937,13 @@ ice_vc_fdir_config_input_set(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 	enum ice_fltr_ptype flow;
 	int ret;
 
+	ret = ice_vc_fdir_has_prof_conflict(vf, conf);
+	if (ret) {
+		dev_dbg(dev, "Found flow profile conflict for VF %d\n",
+			vf->vf_id);
+		return ret;
+	}
+
 	flow = input->flow_type;
 	ret = ice_vc_fdir_alloc_prof(vf, flow);
 	if (ret) {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6..40aeaa7bd739 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
@@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 93575800ca92..a8188b972ccb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (!priv->prs_double_vlans)
 		return -ENOMEM;
 
-	/* Double VLAN: 0x8100, 0x88A8 */
-	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD,
+	/* Double VLAN: 0x88A8, 0x8100 */
+	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q,
 					MVPP2_PRS_PORT_MASK);
 	if (err)
 		return err;
@@ -1607,59 +1607,45 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 {
 	struct mvpp2_prs_entry pe;
-	int tid;
-
-	/* IPv4 over PPPoE with options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
-
-	memset(&pe, 0, sizeof(pe));
-	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
-	pe.index = tid;
-
-	mvpp2_prs_match_etype(&pe, 0, PPP_IP);
-
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
-				 sizeof(struct iphdr) - 4,
-				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
-	/* Set L3 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
-				  MVPP2_ETH_TYPE_LEN,
-				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+	int tid, ihl;
 
-	/* IPv4 over PPPoE without options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
+	/* IPv4 over PPPoE with header length >= 5 */
+	for (ihl = MVPP2_PRS_IPV4_IHL_MIN; ihl <= MVPP2_PRS_IPV4_IHL_MAX; ihl++) {
+		tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
+						MVPP2_PE_LAST_FREE_TID);
+		if (tid < 0)
+			return tid;
 
-	pe.index = tid;
+		memset(&pe, 0, sizeof(pe));
+		mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
+		pe.index = tid;
 
-	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD |
-				     MVPP2_PRS_IPV4_IHL_MIN,
-				     MVPP2_PRS_IPV4_HEAD_MASK |
-				     MVPP2_PRS_IPV4_IHL_MASK);
+		mvpp2_prs_match_etype(&pe, 0, PPP_IP);
+		mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
+					     MVPP2_PRS_IPV4_HEAD | ihl,
+					     MVPP2_PRS_IPV4_HEAD_MASK |
+					     MVPP2_PRS_IPV4_IHL_MASK);
 
-	/* Clear ri before updating */
-	pe.sram[MVPP2_PRS_SRAM_RI_WORD] = 0x0;
-	pe.sram[MVPP2_PRS_SRAM_RI_CTRL_WORD] = 0x0;
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
+		mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
+		mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
+					 MVPP2_PRS_RI_L3_PROTO_MASK);
+		/* goto ipv4 dst-address (skip eth_type + IP-header-size - 4) */
+		mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+					 sizeof(struct iphdr) - 4,
+					 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+		/* Set L3 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
+					  MVPP2_ETH_TYPE_LEN,
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
+		/* Set L4 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
+					  MVPP2_ETH_TYPE_LEN + (ihl * 4),
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+		/* Update shadow table and hw entry */
+		mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
+		mvpp2_prs_hw_write(priv, &pe);
+	}
 
 	/* IPv6 over PPPoE */
 	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 7bb1f20002b5..7c5403c01071 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -462,6 +462,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
+		flow_block_cb_incref(block_cb);
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &block_cb_list);
 		return 0;
@@ -470,7 +471,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (!block_cb)
 			return -ENOENT;
 
-		if (flow_block_cb_decref(block_cb)) {
+		if (!flow_block_cb_decref(block_cb)) {
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 		}
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 50f0f621b1aa..a84fd859aec9 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -970,6 +970,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
+	/* disable 10m pll off */
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
+
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c316a9eb5be3..302b97c2e617 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,7 +1304,8 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	struct net_device *net_dev = efx->net_dev;
+	netdev_features_t tun_feats, tso_feats;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1349,20 +1350,30 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
-	/* add encapsulated checksum offload features */
+	/* encap features might change during reset if fw variant changed */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	/* add encapsulated TSO features */
-	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
-		netdev_features_t encap_tso_features;
+		net_dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	else
+		net_dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tun_feats = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+		    NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tso_feats = NETIF_F_TSO | NETIF_F_TSO6;
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
+		/* If this is first nic_init, or if it is a reset and a new fw
+		 * variant has added new features, enable them by default.
+		 * If the features are not new, maintain their current value.
+		 */
+		if (!(net_dev->hw_features & tun_feats))
+			net_dev->features |= tun_feats;
+		net_dev->hw_enc_features |= tun_feats | tso_feats;
+		net_dev->hw_features |= tun_feats;
+	} else {
+		net_dev->hw_enc_features &= ~(tun_feats | tso_feats);
+		net_dev->hw_features &= ~tun_feats;
+		net_dev->features &= ~tun_feats;
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
@@ -3993,7 +4004,10 @@ static unsigned int ef10_check_caps(const struct efx_nic *efx,
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
 	 NETIF_F_IPV6_CSUM |		\
 	 NETIF_F_RXHASH |		\
-	 NETIF_F_NTUPLE)
+	 NETIF_F_NTUPLE |		\
+	 NETIF_F_SG |			\
+	 NETIF_F_RXCSUM |		\
+	 NETIF_F_RXALL)
 
 const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.is_vf = true,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index b6243f03e953..16a896360f3f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1003,21 +1003,18 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
-		net_dev->features |= NETIF_F_TSO6;
-		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
-			net_dev->hw_enc_features |= NETIF_F_TSO6;
-	}
-	/* Check whether device supports TSO */
-	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+	net_dev->features |= efx->type->offload_features;
+
+	/* Add TSO features */
+	if (efx->type->tso_versions && efx->type->tso_versions(efx))
+		net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
 				   NETIF_F_RXCSUM);
 
+	/* Determine user configurable features */
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 63b99dd8ca51..b330dcbe949d 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,8 +1037,6 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -1066,6 +1064,7 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 			     struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct phy_device *phydev;
 	int err = -ENXIO;
 
 	pdata->mii_bus = mdiobus_alloc();
@@ -1108,6 +1107,10 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 		goto err_out_free_bus_2;
 	}
 
+	phydev = phy_find_first(pdata->mii_bus);
+	if (phydev)
+		phydev->mac_managed_pm = true;
+
 	return 0;
 
 err_out_free_bus_2:
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index b6d945ea903d..c113ec56f5b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -530,7 +530,6 @@ struct mac_device_info {
 	unsigned int xlgmac;
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
-	unsigned int promisc;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 60638bf18f1f..cd85a2d076c9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -478,12 +478,6 @@ static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
 	if (vid > 4095)
 		return -EINVAL;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Adding VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		/* For single VLAN filter, VID 0 means VLAN promiscuous */
@@ -533,12 +527,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 {
 	int i, ret = 0;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Deleting VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		if ((hw->vlan_filter[0] & GMAC_VLAN_TAG_VID) == vid) {
@@ -563,39 +551,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 	return ret;
 }
 
-static void dwmac4_vlan_promisc_enable(struct net_device *dev,
-				       struct mac_device_info *hw)
-{
-	void __iomem *ioaddr = hw->pcsr;
-	u32 value;
-	u32 hash;
-	u32 val;
-	int i;
-
-	/* Single Rx VLAN Filter */
-	if (hw->num_vlan == 1) {
-		dwmac4_write_single_vlan(dev, 0);
-		return;
-	}
-
-	/* Extended Rx VLAN Filter Enable */
-	for (i = 0; i < hw->num_vlan; i++) {
-		if (hw->vlan_filter[i] & GMAC_VLAN_TAG_DATA_VEN) {
-			val = hw->vlan_filter[i] & ~GMAC_VLAN_TAG_DATA_VEN;
-			dwmac4_write_vlan_filter(dev, hw, i, val);
-		}
-	}
-
-	hash = readl(ioaddr + GMAC_VLAN_HASH_TABLE);
-	if (hash & GMAC_VLAN_VLHT) {
-		value = readl(ioaddr + GMAC_VLAN_TAG);
-		if (value & GMAC_VLAN_VTHM) {
-			value &= ~GMAC_VLAN_VTHM;
-			writel(value, ioaddr + GMAC_VLAN_TAG);
-		}
-	}
-}
-
 static void dwmac4_restore_hw_vlan_rx_fltr(struct net_device *dev,
 					   struct mac_device_info *hw)
 {
@@ -715,22 +670,12 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* VLAN filtering */
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en)
+		value &= ~GMAC_PACKET_FILTER_VTFE;
+	else if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
-
-	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en) {
-		if (!hw->promisc) {
-			hw->promisc = 1;
-			dwmac4_vlan_promisc_enable(dev, hw);
-		}
-	} else {
-		if (hw->promisc) {
-			hw->promisc = 0;
-			dwmac4_restore_hw_vlan_rx_fltr(dev, hw);
-		}
-	}
 }
 
 static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e2322bc3a4e9..5834d3ed6dcf 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1945,10 +1945,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 1544564bc283..d709e6918195 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -155,7 +155,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
-	total_size = get_order(total_size) << PAGE_SHIFT;
+	total_size = PAGE_SIZE << get_order(total_size);
 
 	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
 	if (!virt)
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2a4892402ed8..16b36e956360 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 755220c6451f..cdf4e22fe85d 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -587,15 +587,13 @@ static int dp83869_of_init(struct phy_device *phydev)
 						       &dp83869_internal_delay[0],
 						       delay_size, true);
 	if (dp83869->rx_int_delay < 0)
-		dp83869->rx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
 						       &dp83869_internal_delay[0],
 						       delay_size, false);
 	if (dp83869->tx_int_delay < 0)
-		dp83869->tx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	return ret;
 }
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index adfd21aa5b6a..f315bddacba3 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data for xenvif */
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
 	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
 
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
 	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
 	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
 	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 26428db845be..303d8ebbaafc 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -334,6 +334,7 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 struct xenvif_tx_cb {
 	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
 	u8 copy_count;
+	u32 split_mask;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
@@ -361,6 +362,8 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	struct sk_buff *skb =
 		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
 			  GFP_ATOMIC | __GFP_NOWARN);
+
+	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
 	if (unlikely(skb == NULL))
 		return NULL;
 
@@ -396,11 +399,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 	nr_slots = shinfo->nr_frags + 1;
 
 	copy_count(skb) = 0;
+	XENVIF_TX_CB(skb)->split_mask = 0;
 
 	/* Create copy ops for exactly data_len bytes into the skb head. */
 	__skb_put(skb, data_len);
 	while (data_len > 0) {
 		int amount = data_len > txp->size ? txp->size : data_len;
+		bool split = false;
 
 		cop->source.u.ref = txp->gref;
 		cop->source.domid = queue->vif->domid;
@@ -413,6 +418,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
 				               - data_len);
 
+		/* Don't cross local page boundary! */
+		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
+			amount = XEN_PAGE_SIZE - cop->dest.offset;
+			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
+			split = true;
+		}
+
 		cop->len = amount;
 		cop->flags = GNTCOPY_source_gref;
 
@@ -420,7 +432,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		pending_idx = queue->pending_ring[index];
 		callback_param(queue, pending_idx).ctx = NULL;
 		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
-		copy_count(skb)++;
+		if (!split)
+			copy_count(skb)++;
 
 		cop++;
 		data_len -= amount;
@@ -441,7 +454,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 			nr_slots--;
 		} else {
 			/* The copy op partially covered the tx_request.
-			 * The remainder will be mapped.
+			 * The remainder will be mapped or copied in the next
+			 * iteration.
 			 */
 			txp->offset += amount;
 			txp->size -= amount;
@@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		pending_idx = copy_pending_idx(skb, i);
 
 		newerr = (*gopp_copy)->status;
+
+		/* Split copies need to be handled together. */
+		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
+			(*gopp_copy)++;
+			if (!newerr)
+				newerr = (*gopp_copy)->status;
+		}
 		if (likely(!newerr)) {
 			/* The first frag might still have this slot mapped */
 			if (i < copy_count(skb) - 1 || !sharedslot)
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 52d1fe5ec3e7..0a77b8426817 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -863,32 +863,34 @@ static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
 {
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	const struct pin_desc *pd;
 	unsigned long flags;
 	u32 pin_reg, mask;
-	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	for (i = 0; i < desc->npins; i++) {
-		int pin = desc->pins[i].number;
-		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
-
-		if (!pd)
-			continue;
+	pd = pin_desc_get(gpio_dev->pctrl, pin);
+	if (!pd)
+		return;
 
-		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	pin_reg = readl(gpio_dev->base + pin * 4);
+	pin_reg &= ~mask;
+	writel(pin_reg, gpio_dev->base + pin * 4);
+	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+}
 
-		pin_reg = readl(gpio_dev->base + i * 4);
-		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + i * 4);
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+{
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	int i;
 
-		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-	}
+	for (i = 0; i < desc->npins; i++)
+		amd_gpio_irq_init_pin(gpio_dev, i);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -941,8 +943,10 @@ static int amd_gpio_resume(struct device *dev)
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin))
+		if (!amd_gpio_should_save(gpio_dev, pin)) {
+			amd_gpio_irq_init_pin(gpio_dev, pin);
 			continue;
+		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index c86fcdfaf825..e31f5d9febe9 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1184,7 +1184,6 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 		dev_err(dev, "can't add the irq domain\n");
 		return -ENODEV;
 	}
-	atmel_pioctrl->irq_domain->name = "atmel gpio";
 
 	for (i = 0; i < atmel_pioctrl->npins; i++) {
 		int irq = irq_create_mapping(atmel_pioctrl->irq_domain, i);
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 0a36ec8775a3..b14f1b7a625e 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -739,7 +739,7 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
 	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
-			   BIT(p), f << (p - 1));
+			   BIT(p), (f >> 1) << p);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index ac19fcc9abbf..b8d67bc4acb0 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -958,7 +958,18 @@ static inline void pmc_core_reg_write(struct pmc_dev *pmcdev, int reg_offset,
 
 static inline u64 pmc_core_adjust_slp_s0_step(struct pmc_dev *pmcdev, u32 value)
 {
-	return (u64)value * pmcdev->map->slp_s0_res_counter_step;
+	/*
+	 * ADL PCH does not have the SLP_S0 counter and LPM Residency counters are
+	 * used as a workaround which uses 30.5 usec tick. All other client
+	 * programs have the legacy SLP_S0 residency counter that is using the 122
+	 * usec tick.
+	 */
+	const int lpm_adj_x2 = pmcdev->map->lpm_res_counter_step_x2;
+
+	if (pmcdev->map == &adl_reg_map)
+		return (u64)value * GET_X2_COUNTER((u64)lpm_adj_x2);
+	else
+		return (u64)value * pmcdev->map->slp_s0_res_counter_step;
 }
 
 static int set_etr3(struct pmc_dev *pmcdev)
diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index c4d9c45350f7..c9ed2644bb8a 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -525,12 +525,23 @@ static ssize_t possible_values_show(struct kobject *kobj, struct kobj_attribute
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
 
-	if (!tlmi_priv.can_get_bios_selections)
-		return -EOPNOTSUPP;
-
 	return sysfs_emit(buf, "%s\n", setting->possible_values);
 }
 
+static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
+
+	if (setting->possible_values) {
+		/* Figure out what setting type is as BIOS does not return this */
+		if (strchr(setting->possible_values, ';'))
+			return sysfs_emit(buf, "enumeration\n");
+	}
+	/* Anything else is going to be a string */
+	return sysfs_emit(buf, "string\n");
+}
+
 static ssize_t current_value_store(struct kobject *kobj,
 		struct kobj_attribute *attr,
 		const char *buf, size_t count)
@@ -601,14 +612,30 @@ static struct kobj_attribute attr_possible_values = __ATTR_RO(possible_values);
 
 static struct kobj_attribute attr_current_val = __ATTR_RW_MODE(current_value, 0600);
 
+static struct kobj_attribute attr_type = __ATTR_RO(type);
+
+static umode_t attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int n)
+{
+	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
+
+	/* We don't want to display possible_values attributes if not available */
+	if ((attr == &attr_possible_values.attr) && (!setting->possible_values))
+		return 0;
+
+	return attr->mode;
+}
+
 static struct attribute *tlmi_attrs[] = {
 	&attr_displ_name.attr,
 	&attr_current_val.attr,
 	&attr_possible_values.attr,
+	&attr_type.attr,
 	NULL
 };
 
 static const struct attribute_group tlmi_attr_group = {
+	.is_visible = attr_is_visible,
 	.attrs = tlmi_attrs,
 };
 
@@ -916,7 +943,34 @@ static int tlmi_analyze(void)
 			if (ret || !setting->possible_values)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
+		} else {
+			/*
+			 * Older Thinkstations don't support the bios_selections API.
+			 * Instead they store this as a [Optional:Option1,Option2] section of the
+			 * name string.
+			 * Try and pull that out if it's available.
+			 */
+			char *item, *optstart, *optend;
+
+			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(item, "[Optional:");
+				if (optstart) {
+					optstart += strlen("[Optional:");
+					optend = strstr(optstart, "]");
+					if (optend)
+						setting->possible_values =
+							kstrndup(optstart, optend - optstart,
+									GFP_KERNEL);
+				}
+			}
 		}
+		/*
+		 * firmware-attributes requires that possible_values are separated by ';' but
+		 * Lenovo FW uses ','. Replace appropriately.
+		 */
+		if (setting->possible_values)
+			strreplace(setting->possible_values, ',', ';');
+
 		kobject_init(&setting->kobj, &tlmi_attr_setting_ktype);
 		tlmi_priv.setting[i] = setting;
 		kfree(item);
diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..8fa9772acf79 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -601,7 +601,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 599ad201dca7..fb163458337f 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -215,7 +215,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
 			dev_err(dev, "Can't get enable-clock from devicetree\n");
-			return -ENOENT;
+			return PTR_ERR(drvdata->enable_clock);
 		}
 	} else if (drvtype && drvtype->has_performance_state) {
 		drvdata->desc.ops = &fixed_voltage_domain_ops;
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 4d2556bc7fe5..5196c9ac5a81 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -86,8 +86,9 @@ static struct ap_driver vfio_ap_drv = {
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
-	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
+	struct ap_matrix_dev *matrix_dev;
 
+	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
 	kfree(matrix_dev);
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 056837849ead..c254254aa72f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4737,7 +4737,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4807,7 +4807,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 90118204e21a..5aa4ae0b0607 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6456,11 +6456,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	else if (rc == -EAGAIN)
 		goto try_32bit_dma;
 	total_sz += sense_sz;
-	ioc_info(ioc,
-	    "sense pool(0x%p)- dma(0x%llx): depth(%d),"
-	    "element_size(%d), pool_size(%d kB)\n",
-	    ioc->sense, (unsigned long long)ioc->sense_dma, ioc->scsiio_depth,
-	    SCSI_SENSE_BUFFERSIZE, sz / 1024);
 	/* reply pool, 4 byte align */
 	sz = ioc->reply_free_queue_depth * ioc->reply_sz;
 	rc = _base_allocate_reply_pool(ioc, sz);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a0100d26de8e..eaf64f33fe07 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1639,6 +1639,44 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+/**
+ * __dwc3_stop_active_transfer - stop the current active transfer
+ * @dep: isoc endpoint
+ * @force: set forcerm bit in the command
+ * @interrupt: command complete interrupt after End Transfer command
+ *
+ * When setting force, the ForceRM bit will be set. In that case
+ * the controller won't update the TRB progress on command
+ * completion. It also won't clear the HWO bit in the TRB.
+ * The command will also not complete immediately in that case.
+ */
+static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
+{
+	struct dwc3 *dwc = dep->dwc;
+	struct dwc3_gadget_ep_cmd_params params;
+	u32 cmd;
+	int ret;
+
+	cmd = DWC3_DEPCMD_ENDTRANSFER;
+	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
+	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
+	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
+	memset(&params, 0, sizeof(params));
+	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	WARN_ON_ONCE(ret);
+	dep->resource_index = 0;
+
+	if (!interrupt) {
+		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
+			mdelay(1);
+		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
+	} else if (!ret) {
+		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	}
+
+	return ret;
+}
+
 /**
  * dwc3_gadget_start_isoc_quirk - workaround invalid frame number
  * @dep: isoc endpoint
@@ -1808,21 +1846,8 @@ static int __dwc3_gadget_start_isoc(struct dwc3_ep *dep)
 	 * status, issue END_TRANSFER command and retry on the next XferNotReady
 	 * event.
 	 */
-	if (ret == -EAGAIN) {
-		struct dwc3_gadget_ep_cmd_params params;
-		u32 cmd;
-
-		cmd = DWC3_DEPCMD_ENDTRANSFER |
-			DWC3_DEPCMD_CMDIOC |
-			DWC3_DEPCMD_PARAM(dep->resource_index);
-
-		dep->resource_index = 0;
-		memset(&params, 0, sizeof(params));
-
-		ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-		if (!ret)
-			dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
-	}
+	if (ret == -EAGAIN)
+		ret = __dwc3_stop_active_transfer(dep, false, true);
 
 	return ret;
 }
@@ -3605,10 +3630,6 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
-	struct dwc3_gadget_ep_cmd_params params;
-	u32 cmd;
-	int ret;
-
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
@@ -3637,22 +3658,14 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * enabled, the EndTransfer command will have completed upon
 	 * returning from this function.
 	 *
-	 * This mode is NOT available on the DWC_usb31 IP.
+	 * This mode is NOT available on the DWC_usb31 IP.  In this
+	 * case, if the IOC bit is not set, then delay by 1ms
+	 * after issuing the EndTransfer command.  This allows for the
+	 * controller to handle the command completely before DWC3
+	 * remove requests attempts to unmap USB request buffers.
 	 */
 
-	cmd = DWC3_DEPCMD_ENDTRANSFER;
-	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
-	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
-	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
-	memset(&params, 0, sizeof(params));
-	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-	WARN_ON_ONCE(ret);
-	dep->resource_index = 0;
-
-	if (!interrupt)
-		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else
-		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	__dwc3_stop_active_transfer(dep, force, interrupt);
 }
 
 static void dwc3_clear_stall_all_ep(struct dwc3 *dwc)
diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index c00e01a17368..a8a0a448cdb5 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1040,6 +1040,9 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	u32 pixclock;
 	int screen_size, plane;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	plane = fbdev->plane;
 
 	/* Make sure that the mode respect all LCD controller and
diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index 66c81262d18f..6c6b6efb49f6 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -234,6 +234,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index a9579964eaba..8a703adfa936 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1214,6 +1214,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index a372a183c1f0..f9c388a8c10e 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -763,6 +763,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index ae0cf5540636..b9b00a1ffe22 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -166,6 +166,9 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (par->tga_type == TGA_TYPE_8PLANE) {
 		if (var->bits_per_pixel != 8)
 			return -EINVAL;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ed9c715d2579..f4173294f60e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4267,7 +4267,9 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	}
 
 	/* update qgroup status and info */
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	err = btrfs_run_qgroups(trans);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (err < 0)
 		btrfs_handle_fs_error(fs_info, err,
 				      "failed to update qgroup status and info");
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fc40159197f7..26110d9587cd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2752,13 +2752,22 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 }
 
 /*
- * called from commit_transaction. Writes all changed qgroups to disk.
+ * Writes all changed qgroups to disk.
+ * Called by the transaction commit path and the qgroup assign ioctl.
  */
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
+	/*
+	 * In case we are called from the qgroup assign ioctl, assert that we
+	 * are holding the qgroup_ioctl_lock, otherwise we can race with a quota
+	 * disable operation (ioctl) and access a freed quota root.
+	 */
+	if (trans->transaction->state != TRANS_STATE_COMMIT_DOING)
+		lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
+
 	if (!fs_info->quota_root)
 		return ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 24f7ba1478ed..5e191860e8a8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1406,8 +1406,17 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	flags |= FMODE_EXCL;
 
+	/*
+	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
+	 * initiate the device scan which may race with the user's mount
+	 * or mkfs command, resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is
+	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * during the mount process. It is ok to get some inconsistent
+	 * values temporarily, as the device paths of the fsid are the only
+	 * required information for assembling the volume.
+	 */
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index fa37f2672cd4..f7c91a3eb9a4 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -118,7 +118,10 @@ extern const struct dentry_operations cifs_ci_dentry_ops;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
 #else
-#define cifs_dfs_d_automount NULL
+static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
+{
+	return ERR_PTR(-EREMOTE);
+}
 #endif
 
 /* Functions related to symlinks */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 243d17696f06..6ca08e473a7e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4751,8 +4751,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 6105649b4ebb..610abaadbb67 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -292,7 +292,7 @@ int ksmbd_conn_handler_loop(void *p)
 		kvfree(conn->request_buf);
 		conn->request_buf = NULL;
 
-		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf));
+		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf), -1);
 		if (size != sizeof(hdr_buf))
 			break;
 
@@ -335,7 +335,7 @@ int ksmbd_conn_handler_loop(void *p)
 		 * We already read 4 bytes to find out PDU size, now
 		 * read in PDU
 		 */
-		size = t->ops->read(t, conn->request_buf + 4, pdu_size);
+		size = t->ops->read(t, conn->request_buf + 4, pdu_size, 2);
 		if (size < 0) {
 			pr_err("sock_read failed: %d\n", size);
 			break;
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 8694aef482c1..4b15c5e673d9 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -122,7 +122,8 @@ struct ksmbd_conn_ops {
 struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
-	int (*read)(struct ksmbd_transport *t, char *buf, unsigned int size);
+	int (*read)(struct ksmbd_transport *t, char *buf,
+		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 9d67419929d6..9ca29cdb7898 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -663,7 +663,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 }
 
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
-			   unsigned int size)
+			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_data_transfer *data_transfer;
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index e0ca6cc04b91..d1d7954368a5 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -291,16 +291,18 @@ static int ksmbd_tcp_run_kthread(struct interface *iface)
 
 /**
  * ksmbd_tcp_readv() - read data from socket in given iovec
- * @t:		TCP transport instance
- * @iov_orig:	base IO vector
- * @nr_segs:	number of segments in base iov
- * @to_read:	number of bytes to read from socket
+ * @t:			TCP transport instance
+ * @iov_orig:		base IO vector
+ * @nr_segs:		number of segments in base iov
+ * @to_read:		number of bytes to read from socket
+ * @max_retries:	maximum retry count
  *
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
 static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
-			   unsigned int nr_segs, unsigned int to_read)
+			   unsigned int nr_segs, unsigned int to_read,
+			   int max_retries)
 {
 	int length = 0;
 	int total_read;
@@ -308,7 +310,6 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
-	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
-			   max_retry) {
+		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+			/*
+			 * If max_retries is negative, Allow unlimited
+			 * retries to keep connection with inactive sessions.
+			 */
+			if (max_retries == 0) {
+				total_read = length;
+				break;
+			} else if (max_retries > 0) {
+				max_retries--;
+			}
+
 			usleep_range(1000, 2000);
 			length = 0;
-			max_retry--;
 			continue;
 		} else if (length <= 0) {
-			total_read = -EAGAIN;
+			total_read = length;
 			break;
 		}
 	}
@@ -358,14 +368,15 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
-static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf, unsigned int to_read)
+static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
+			  unsigned int to_read, int max_retries)
 {
 	struct kvec iov;
 
 	iov.iov_base = buf;
 	iov.iov_len = to_read;
 
-	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read);
+	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
 static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 27cafeada865..0546fa1ac98f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1993,8 +1993,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -2003,7 +2002,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 60a4372aa4d7..dfe8acc32df6 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -391,25 +391,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 		goto out_drop_write;
 
 	err = enable_verity(filp, &arg);
-	if (err)
-		goto out_allow_write_access;
 
 	/*
-	 * Some pages of the file may have been evicted from pagecache after
-	 * being used in the Merkle tree construction, then read into pagecache
-	 * again by another process reading from the file concurrently.  Since
-	 * these pages didn't undergo verification against the file digest which
-	 * fs-verity now claims to be enforcing, we have to wipe the pagecache
-	 * to ensure that all future reads are verified.
+	 * We no longer drop the inode's pagecache after enabling verity.  This
+	 * used to be done to try to avoid a race condition where pages could be
+	 * evicted after being used in the Merkle tree construction, then
+	 * re-instantiated by a concurrent read.  Such pages are unverified, and
+	 * the backing storage could have filled them with different content, so
+	 * they shouldn't be used to fulfill reads once verity is enabled.
+	 *
+	 * But, dropping the pagecache has a big performance impact, and it
+	 * doesn't fully solve the race condition anyway.  So for those reasons,
+	 * and also because this race condition isn't very important relatively
+	 * speaking (especially for small-ish files, where the chance of a page
+	 * being used, evicted, *and* re-instantiated all while enabling verity
+	 * is quite small), we no longer drop the inode's pagecache.
 	 */
-	filemap_write_and_wait(inode->i_mapping);
-	invalidate_inode_pages2(inode->i_mapping);
 
 	/*
 	 * allow_write_access() is needed to pair with deny_write_access().
 	 * Regardless, the filesystem won't allow writing to verity files.
 	 */
-out_allow_write_access:
 	allow_write_access(filp);
 out_drop_write:
 	mnt_drop_write_file(filp);
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index d3e182c1a128..9619a68df163 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -736,6 +736,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct block_device *bdev = inode->i_sb->s_bdev;
 	unsigned int max = bdev_max_zone_append_sectors(bdev);
+	pgoff_t start, end;
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
@@ -744,6 +745,19 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
+	/*
+	 * If the inode block size (zone write granularity) is smaller than the
+	 * page size, we may be appending data belonging to the last page of the
+	 * inode straddling inode->i_size, with that page already cached due to
+	 * a buffered read or readahead. So make sure to invalidate that page.
+	 * This will always be a no-op for the case where the block size is
+	 * equal to the page size.
+	 */
+	start = iocb->ki_pos >> PAGE_SHIFT;
+	end = (iocb->ki_pos + iov_iter_count(from) - 1) >> PAGE_SHIFT;
+	if (invalidate_inode_pages2_range(inode->i_mapping, start, end))
+		return -EBUSY;
+
 	nr_pages = iov_iter_npages(from, BIO_MAX_VECS);
 	if (!nr_pages)
 		return 0;
@@ -782,7 +796,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector != wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, zi->i_zsector);
+				bio->bi_iter.bi_sector, zi->i_zsector);
 			ret = -EIO;
 		}
 	}
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 670e41783edd..fec252b1e5b8 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -768,7 +768,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
 	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
-		__field(char, rcutorturename[RCUTORTURENAME_LEN])
+		__array(char, rcutorturename, RCUTORTURENAME_LEN)
 		__field(struct rcu_head *, rhp)
 		__field(unsigned long, secs)
 		__field(unsigned long, c_old)
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 732efb08c3e1..744bc4135567 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -500,6 +500,8 @@ struct xenpf_symdata {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_symdata);
 
+#define XENPF_get_dom0_console 64
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -523,6 +525,7 @@ struct xen_platform_op {
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		struct xenpf_symdata           symdata;
+		struct dom0_vga_console_info   dom0_console;
 		uint8_t                        pad[128];
 	} u;
 };
diff --git a/kernel/compat.c b/kernel/compat.c
index 55551989d9da..fb50f29d9b36 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -152,7 +152,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index c2bb07f5bcc7..c4ddd189f3e0 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -13,5 +13,6 @@ CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) \
 obj-y := core.o debugfs.o report.o
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c72459d5f42..acf7c09c9152 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8185,14 +8185,14 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
 		unsigned int retlen = min(len, cpumask_size());
 
-		if (copy_to_user(user_mask_ptr, mask, retlen))
+		if (copy_to_user(user_mask_ptr, cpumask_bits(mask), retlen))
 			ret = -EFAULT;
 		else
 			ret = retlen;
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index c736487fc0e4..e0c420eb0b2b 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -146,7 +146,7 @@ static int __init test_gen_kprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kprobe_test))
 		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kprobe_test");
+	kprobe_event_delete("gen_kprobe_test");
 	goto out;
 }
 
@@ -211,7 +211,7 @@ static int __init test_gen_kretprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kretprobe_test))
 		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kretprobe_test");
+	kprobe_event_delete("gen_kretprobe_test");
 	goto out;
 }
 
diff --git a/net/can/bcm.c b/net/can/bcm.c
index aab3a18f4a90..5727a073189b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -936,6 +936,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 			cf = op->frames + op->cfsiz * i;
 			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
+			if (err < 0)
+				goto free_op;
 
 			if (op->flags & CAN_FD_FRAME) {
 				if (cf->len > 64)
@@ -945,12 +947,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 					err = -EINVAL;
 			}
 
-			if (err < 0) {
-				if (op->frames != &op->sframe)
-					kfree(op->frames);
-				kfree(op);
-				return err;
-			}
+			if (err < 0)
+				goto free_op;
 
 			if (msg_head->flags & TX_CP_CAN_ID) {
 				/* copy can_id into frame */
@@ -1021,6 +1019,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		bcm_tx_start_timer(op);
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
+
+free_op:
+	if (op->frames != &op->sframe)
+		kfree(op->frames);
+	kfree(op);
+	return err;
 }
 
 /*
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 4177e9617070..848b60c9ef79 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1124,8 +1124,6 @@ static void __j1939_session_cancel(struct j1939_session *session,
 
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
-	else
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static void j1939_session_cancel(struct j1939_session *session,
@@ -1140,6 +1138,9 @@ static void j1939_session_cancel(struct j1939_session *session,
 	}
 
 	j1939_session_list_unlock(session->priv);
+
+	if (!session->sk)
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
@@ -1253,6 +1254,9 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
 			__j1939_session_cancel(session, J1939_XTP_ABORT_TIMEOUT);
 		}
 		j1939_session_list_unlock(session->priv);
+
+		if (!session->sk)
+			j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 	}
 
 	j1939_session_put(session);
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 414bf4d3d3c9..8c9a20e99f0f 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -385,7 +385,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (port->hsr->prot_version != PRP_V1 && net_ratelimit())
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 897dfce7dd27..bf801adff63d 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2140,6 +2140,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt)
 	switch (skst) {
 	case TCP_FIN_WAIT1:
 	case TCP_FIN_WAIT2:
+	case TCP_LAST_ACK:
 		break;
 	case TCP_ESTABLISHED:
 	case TCP_CLOSE_WAIT:
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5fba82757ce5..eb0952dbf423 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -906,7 +906,9 @@ static int copy_to_user_aead(struct xfrm_algo_aead *aead, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, aead, sizeof(*aead));
+	strscpy_pad(ap->alg_name, aead->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = aead->alg_key_len;
+	ap->alg_icv_len = aead->alg_icv_len;
 
 	if (redact_secret && aead->alg_key_len)
 		memset(ap->alg_key, 0, (aead->alg_key_len + 7) / 8);
@@ -926,7 +928,8 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, ealg, sizeof(*ealg));
+	strscpy_pad(ap->alg_name, ealg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = ealg->alg_key_len;
 
 	if (redact_secret && ealg->alg_key_len)
 		memset(ap->alg_key, 0, (ealg->alg_key_len + 7) / 8);
@@ -937,6 +940,40 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 	return 0;
 }
 
+static int copy_to_user_calg(struct xfrm_algo *calg, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*calg));
+	struct xfrm_algo *ap;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	ap = nla_data(nla);
+	strscpy_pad(ap->alg_name, calg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = 0;
+
+	return 0;
+}
+
+static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ENCAP, sizeof(*ep));
+	struct xfrm_encap_tmpl *uep;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	uep = nla_data(nla);
+	memset(uep, 0, sizeof(*uep));
+
+	uep->encap_type = ep->encap_type;
+	uep->encap_sport = ep->encap_sport;
+	uep->encap_dport = ep->encap_dport;
+	uep->encap_oa = ep->encap_oa;
+
+	return 0;
+}
+
 static int xfrm_smark_put(struct sk_buff *skb, struct xfrm_mark *m)
 {
 	int ret = 0;
@@ -992,12 +1029,12 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
 			goto out;
 	}
 	if (x->calg) {
-		ret = nla_put(skb, XFRMA_ALG_COMP, sizeof(*(x->calg)), x->calg);
+		ret = copy_to_user_calg(x->calg, skb);
 		if (ret)
 			goto out;
 	}
 	if (x->encap) {
-		ret = nla_put(skb, XFRMA_ENCAP, sizeof(*x->encap), x->encap);
+		ret = copy_to_user_encap(x->encap, skb);
 		if (ret)
 			goto out;
 	}
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 491064f55515..8947c988b6d3 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2137,6 +2137,8 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 		ret = substream->ops->ack(substream);
 		if (ret < 0) {
 			runtime->control->appl_ptr = old_appl_ptr;
+			if (ret == -EPIPE)
+				__snd_pcm_xrun(substream);
 			return ret;
 		}
 	}
diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 3d6914c64c4a..4cdaeefeb688 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -430,7 +430,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index c0cb6e49a9b6..2646663e0342 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4231,8 +4231,10 @@ static int tuning_ctl_set(struct hda_codec *codec, hda_nid_t nid,
 
 	for (i = 0; i < TUNING_CTLS_COUNT; i++)
 		if (nid == ca0132_tuning_ctls[i].nid)
-			break;
+			goto found;
 
+	return -EINVAL;
+found:
 	snd_hda_power_up(codec);
 	dspio_set_param(codec, ca0132_tuning_ctls[i].mid, 0x20,
 			ca0132_tuning_ctls[i].req,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 9d6464ded63e..deff4a3d7a78 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -980,7 +980,10 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
+	/* NOTE: we'd need to extend the quirk for 17aa:3977 as the same
+	 * PCI SSID is used on multiple Lenovo models
+	 */
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
@@ -1003,6 +1006,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_ZBOOK_MUTE_LED, .name = "hp-zbook-mute-led" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 21ad6f9e59b0..c81c7671589d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2625,6 +2625,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65f5, "Clevo PD50PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x66a2, "Clevo PE60RNE", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
@@ -2645,6 +2646,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x96e1, "Clevo P960[ER][CDFN]-K", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x97e1, "Clevo P970[ER][CDFN]", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x97e2, "Clevo P970RC-M", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1558, 0xd502, "Clevo PD50SNE", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo laptop", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x161f, 0x2054, "Medion laptop", ALC883_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Y530", ALC882_FIXUP_LENOVO_Y530),
@@ -9201,6 +9203,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x5101, "Clevo S510WU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5157, "Clevo W517GU1", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51a1, "Clevo NS50MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f2, "Clevo NH79EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -9235,6 +9238,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x971d, "Clevo N970T[CDF]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa500, "Clevo NL5[03]RU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa600, "Clevo NL50NU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0xa671, "Clevo NP70SN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb018, "Clevo NP50D[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb022, "Clevo NH77D[DC][QW]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -9328,6 +9332,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 1e198e4d57b8..82d4e0fda91b 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -170,7 +170,7 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
+	err = snd_devm_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   sizeof(*chip), &card);
 	if (err < 0)
 		return err;
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index c80114c0ad7b..b492c32ce070 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2165,7 +2165,7 @@ static int snd_ymfpci_memalloc(struct snd_ymfpci *chip)
 	chip->work_base = ptr;
 	chip->work_base_addr = ptr_addr;
 	
-	snd_BUG_ON(ptr + chip->work_size !=
+	snd_BUG_ON(ptr + PAGE_ALIGN(chip->work_size) !=
 		   chip->work_ptr->area + chip->work_ptr->bytes);
 
 	snd_ymfpci_writel(chip, YDSXGR_PLAYCTRLBASE, chip->bank_base_playback_addr);
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 2b7ba78551fa..35d148e60c33 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -239,7 +239,7 @@ enum {
 
 struct tx_mute_work {
 	struct tx_macro *tx;
-	u32 decimator;
+	u8 decimator;
 	struct delayed_work dwork;
 };
 
@@ -632,7 +632,7 @@ static int tx_macro_mclk_enable(struct tx_macro *tx,
 	return 0;
 }
 
-static bool is_amic_enabled(struct snd_soc_component *component, int decimator)
+static bool is_amic_enabled(struct snd_soc_component *component, u8 decimator)
 {
 	u16 adc_mux_reg, adc_reg, adc_n;
 
@@ -843,7 +843,7 @@ static int tx_macro_enable_dec(struct snd_soc_dapm_widget *w,
 			       struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
-	unsigned int decimator;
+	u8 decimator;
 	u16 tx_vol_ctl_reg, dec_cfg_reg, hpf_gate_reg, tx_gain_ctl_reg;
 	u8 hpf_cut_off_freq;
 	int hpf_delay = TX_MACRO_DMIC_HPF_DELAY_MS;
@@ -1058,7 +1058,8 @@ static int tx_macro_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_soc_dai *dai)
 {
 	struct snd_soc_component *component = dai->component;
-	u32 decimator, sample_rate;
+	u32 sample_rate;
+	u8 decimator;
 	int tx_fs_rate;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
 
@@ -1122,7 +1123,7 @@ static int tx_macro_digital_mute(struct snd_soc_dai *dai, int mute, int stream)
 {
 	struct snd_soc_component *component = dai->component;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
-	u16 decimator;
+	u8 decimator;
 
 	decimator = tx->active_decimator[dai->id];
 
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 092350eb5f4e..6c7d842d0496 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -444,8 +444,8 @@ static void push_back_to_ready_list(struct snd_usb_endpoint *ep,
  * This function is used both for implicit feedback endpoints and in low-
  * latency playback mode.
  */
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock)
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock)
 {
 	bool implicit_fb = snd_usb_endpoint_implicit_feedback_sink(ep);
 
@@ -469,7 +469,7 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		spin_unlock_irqrestore(&ep->lock, flags);
 
 		if (ctx == NULL)
-			return;
+			break;
 
 		/* copy over the length information */
 		if (implicit_fb) {
@@ -484,11 +484,14 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			break;
 		if (err < 0) {
 			/* push back to ready list again for -EAGAIN */
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
 				push_back_to_ready_list(ep, ctx);
-			else
+				break;
+			}
+
+			if (!in_stream_lock)
 				notify_xrun(ep);
-			return;
+			return -EPIPE;
 		}
 
 		err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
@@ -496,13 +499,16 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			usb_audio_err(ep->chip,
 				      "Unable to submit urb #%d: %d at %s\n",
 				      ctx->index, err, __func__);
-			notify_xrun(ep);
-			return;
+			if (!in_stream_lock)
+				notify_xrun(ep);
+			return -EPIPE;
 		}
 
 		set_bit(ctx->index, &ep->active_mask);
 		atomic_inc(&ep->submitted_urbs);
 	}
+
+	return 0;
 }
 
 /*
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index 6a9af04cf175..daa7ba063d85 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -49,7 +49,7 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 				      struct snd_urb_ctx *ctx, int idx,
 				      unsigned int avail);
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock);
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock);
 
 #endif /* __USBAUDIO_ENDPOINT_H */
diff --git a/sound/usb/format.c b/sound/usb/format.c
index 405dc0bf6678..4b1c5ba121f3 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -39,8 +39,12 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
-		if (format >= 64)
-			return 0; /* invalid format */
+		if (format >= 64) {
+			usb_audio_info(chip,
+				       "%u:%d: invalid format type 0x%llx is detected, processed as PCM\n",
+				       fp->iface, fp->altsetting, format);
+			format = UAC_FORMAT_TYPE_I_PCM;
+		}
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1ULL << format;
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 87a30be64324..de0964dbf7a9 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1557,7 +1557,7 @@ static int snd_usb_pcm_playback_ack(struct snd_pcm_substream *substream)
 	 * outputs here
 	 */
 	if (!ep->active_mask)
-		snd_usb_queue_pending_output_urbs(ep, true);
+		return snd_usb_queue_pending_output_urbs(ep, true);
 	return 0;
 }
 
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index f620911ad3bb..8b1ba4b725e3 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -821,14 +821,9 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 				 const struct btf_type *t)
 {
 	const struct btf_member *m;
-	int align, i, bit_sz;
+	int max_align = 1, align, i, bit_sz;
 	__u16 vlen;
 
-	align = btf__align_of(btf, id);
-	/* size of a non-packed struct has to be a multiple of its alignment*/
-	if (align && t->size % align)
-		return true;
-
 	m = btf_members(t);
 	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
@@ -837,8 +832,11 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 		bit_sz = btf_member_bitfield_size(t, i);
 		if (align && bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
+		max_align = max(align, max_align);
 	}
-
+	/* size of a non-packed struct has to be a multiple of its alignment */
+	if (t->size % max_align != 0)
+		return true;
 	/*
 	 * if original struct was marked as packed, but its layout is
 	 * naturally aligned, we'll detect that it's not packed
@@ -846,44 +844,97 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	return false;
 }
 
-static int chip_away_bits(int total, int at_most)
-{
-	return total % at_most ? : at_most;
-}
-
 static void btf_dump_emit_bit_padding(const struct btf_dump *d,
-				      int cur_off, int m_off, int m_bit_sz,
-				      int align, int lvl)
+				      int cur_off, int next_off, int next_align,
+				      bool in_bitfield, int lvl)
 {
-	int off_diff = m_off - cur_off;
-	int ptr_bits = d->ptr_sz * 8;
+	const struct {
+		const char *name;
+		int bits;
+	} pads[] = {
+		{"long", d->ptr_sz * 8}, {"int", 32}, {"short", 16}, {"char", 8}
+	};
+	int new_off, pad_bits, bits, i;
+	const char *pad_type;
+
+	if (cur_off >= next_off)
+		return; /* no gap */
+
+	/* For filling out padding we want to take advantage of
+	 * natural alignment rules to minimize unnecessary explicit
+	 * padding. First, we find the largest type (among long, int,
+	 * short, or char) that can be used to force naturally aligned
+	 * boundary. Once determined, we'll use such type to fill in
+	 * the remaining padding gap. In some cases we can rely on
+	 * compiler filling some gaps, but sometimes we need to force
+	 * alignment to close natural alignment with markers like
+	 * `long: 0` (this is always the case for bitfields).  Note
+	 * that even if struct itself has, let's say 4-byte alignment
+	 * (i.e., it only uses up to int-aligned types), using `long:
+	 * X;` explicit padding doesn't actually change struct's
+	 * overall alignment requirements, but compiler does take into
+	 * account that type's (long, in this example) natural
+	 * alignment requirements when adding implicit padding. We use
+	 * this fact heavily and don't worry about ruining correct
+	 * struct alignment requirement.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pads); i++) {
+		pad_bits = pads[i].bits;
+		pad_type = pads[i].name;
 
-	if (off_diff <= 0)
-		/* no gap */
-		return;
-	if (m_bit_sz == 0 && off_diff < align * 8)
-		/* natural padding will take care of a gap */
-		return;
+		new_off = roundup(cur_off, pad_bits);
+		if (new_off <= next_off)
+			break;
+	}
 
-	while (off_diff > 0) {
-		const char *pad_type;
-		int pad_bits;
-
-		if (ptr_bits > 32 && off_diff > 32) {
-			pad_type = "long";
-			pad_bits = chip_away_bits(off_diff, ptr_bits);
-		} else if (off_diff > 16) {
-			pad_type = "int";
-			pad_bits = chip_away_bits(off_diff, 32);
-		} else if (off_diff > 8) {
-			pad_type = "short";
-			pad_bits = chip_away_bits(off_diff, 16);
-		} else {
-			pad_type = "char";
-			pad_bits = chip_away_bits(off_diff, 8);
+	if (new_off > cur_off && new_off <= next_off) {
+		/* We need explicit `<type>: 0` aligning mark if next
+		 * field is right on alignment offset and its
+		 * alignment requirement is less strict than <type>'s
+		 * alignment (so compiler won't naturally align to the
+		 * offset we expect), or if subsequent `<type>: X`,
+		 * will actually completely fit in the remaining hole,
+		 * making compiler basically ignore `<type>: X`
+		 * completely.
+		 */
+		if (in_bitfield ||
+		    (new_off == next_off && roundup(cur_off, next_align * 8) != new_off) ||
+		    (new_off != next_off && next_off - new_off <= new_off - cur_off))
+			/* but for bitfields we'll emit explicit bit count */
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type,
+					in_bitfield ? new_off - cur_off : 0);
+		cur_off = new_off;
+	}
+
+	/* Now we know we start at naturally aligned offset for a chosen
+	 * padding type (long, int, short, or char), and so the rest is just
+	 * a straightforward filling of remaining padding gap with full
+	 * `<type>: sizeof(<type>);` markers, except for the last one, which
+	 * might need smaller than sizeof(<type>) padding.
+	 */
+	while (cur_off != next_off) {
+		bits = min(next_off - cur_off, pad_bits);
+		if (bits == pad_bits) {
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
+			cur_off += bits;
+			continue;
+		}
+		/* For the remainder padding that doesn't cover entire
+		 * pad_type bit length, we pick the smallest necessary type.
+		 * This is pure aesthetics, we could have just used `long`,
+		 * but having smallest necessary one communicates better the
+		 * scale of the padding gap.
+		 */
+		for (i = ARRAY_SIZE(pads) - 1; i >= 0; i--) {
+			pad_type = pads[i].name;
+			pad_bits = pads[i].bits;
+			if (pad_bits < bits)
+				continue;
+
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, bits);
+			cur_off += bits;
+			break;
 		}
-		btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
-		off_diff -= pad_bits;
 	}
 }
 
@@ -903,9 +954,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 {
 	const struct btf_member *m = btf_members(t);
 	bool is_struct = btf_is_struct(t);
-	int align, i, packed, off = 0;
+	bool packed, prev_bitfield = false;
+	int align, i, off = 0;
 	__u16 vlen = btf_vlen(t);
 
+	align = btf__align_of(d->btf, id);
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
 
 	btf_dump_printf(d, "%s%s%s {",
@@ -915,33 +968,36 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 
 	for (i = 0; i < vlen; i++, m++) {
 		const char *fname;
-		int m_off, m_sz;
+		int m_off, m_sz, m_align;
+		bool in_bitfield;
 
 		fname = btf_name_of(d, m->name_off);
 		m_sz = btf_member_bitfield_size(t, i);
 		m_off = btf_member_bit_offset(t, i);
-		align = packed ? 1 : btf__align_of(d->btf, m->type);
+		m_align = packed ? 1 : btf__align_of(d->btf, m->type);
 
-		btf_dump_emit_bit_padding(d, off, m_off, m_sz, align, lvl + 1);
+		in_bitfield = prev_bitfield && m_sz != 0;
+
+		btf_dump_emit_bit_padding(d, off, m_off, m_align, in_bitfield, lvl + 1);
 		btf_dump_printf(d, "\n%s", pfx(lvl + 1));
 		btf_dump_emit_type_decl(d, m->type, fname, lvl + 1);
 
 		if (m_sz) {
 			btf_dump_printf(d, ": %d", m_sz);
 			off = m_off + m_sz;
+			prev_bitfield = true;
 		} else {
 			m_sz = max((__s64)0, btf__resolve_size(d->btf, m->type));
 			off = m_off + m_sz * 8;
+			prev_bitfield = false;
 		}
+
 		btf_dump_printf(d, ";");
 	}
 
 	/* pad at the end, if necessary */
-	if (is_struct) {
-		align = packed ? 1 : btf__align_of(d->btf, id);
-		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
-					  lvl + 1);
-	}
+	if (is_struct)
+		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
 	if (vlen)
 		btf_dump_printf(d, "\n");
diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 9b17097bc3d7..b3d4bf08e70b 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -296,6 +296,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 4f176bbf29f4..a3197efe52c6 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4241,7 +4241,7 @@ int print_hwp(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 
 	fprintf(outf, "cpu%d: MSR_HWP_STATUS: 0x%08llx "
 		"(%sGuaranteed_Perf_Change, %sExcursion_Min)\n",
-		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x2) ? "" : "No-");
+		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x4) ? "" : "No-");
 
 	return 0;
 }
@@ -5237,7 +5237,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
index 8f44767a75fa..22a7cd8fd9ac 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
@@ -53,7 +53,7 @@ struct bitfields_only_mixed_types {
  */
 /* ------ END-EXPECTED-OUTPUT ------ */
 struct bitfield_mixed_with_others {
-	long: 4; /* char is enough as a backing field */
+	char: 4; /* char is enough as a backing field */
 	int a: 4;
 	/* 8-bit implicit padding */
 	short b; /* combined with previous bitfield */
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index 1cef3bec1dc7..22dbd1213434 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -58,7 +58,81 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-/*------ END-EXPECTED-OUTPUT ------ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct nested_packed_but_aligned_struct {
+ *	int x1;
+ *	int x2;
+ *};
+ *
+ *struct outer_implicitly_packed_struct {
+ *	char y1;
+ *	struct nested_packed_but_aligned_struct y2;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct nested_packed_but_aligned_struct {
+	int x1;
+	int x2;
+} __attribute__((packed));
+
+struct outer_implicitly_packed_struct {
+	char y1;
+	struct nested_packed_but_aligned_struct y2;
+};
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct usb_ss_ep_comp_descriptor {
+ *	char: 8;
+ *	char bDescriptorType;
+ *	char bMaxBurst;
+ *	short wBytesPerInterval;
+ *};
+ *
+ *struct usb_host_endpoint {
+ *	long: 64;
+ *	char: 8;
+ *	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+ *	long: 0;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct usb_ss_ep_comp_descriptor {
+	char: 8;
+	char bDescriptorType;
+	char bMaxBurst;
+	int: 0;
+	short wBytesPerInterval;
+} __attribute__((packed));
+
+struct usb_host_endpoint {
+	long: 64;
+	char: 8;
+	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+	long: 0;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct nested_packed_struct {
+	int a;
+	char b;
+} __attribute__((packed));
+
+struct outer_nonpacked_struct {
+	short a;
+	struct nested_packed_struct b;
+};
+
+struct outer_packed_struct {
+	short a;
+	struct nested_packed_struct b;
+} __attribute__((packed));
+
+/* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
 	struct packed_trailing_space _1;
@@ -69,6 +143,10 @@ int f(struct {
 	union union_is_never_packed _6;
 	union union_does_not_need_packing _7;
 	union jump_code_union _8;
+	struct outer_implicitly_packed_struct _9;
+	struct usb_host_endpoint _10;
+	struct outer_nonpacked_struct _11;
+	struct outer_packed_struct _12;
 } *_)
 {
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 35c512818a56..0b3cdffbfcf7 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -19,7 +19,7 @@ struct padded_implicitly {
 /*
  *struct padded_explicitly {
  *	int a;
- *	int: 32;
+ *	long: 0;
  *	int b;
  *};
  *
@@ -28,41 +28,28 @@ struct padded_implicitly {
 
 struct padded_explicitly {
 	int a;
-	int: 1; /* algo will explicitly pad with full 32 bits here */
+	int: 1; /* algo will emit aligning `long: 0;` here */
 	int b;
 };
 
 /* ----- START-EXPECTED-OUTPUT ----- */
-/*
- *struct padded_a_lot {
- *	int a;
- *	long: 32;
- *	long: 64;
- *	long: 64;
- *	int b;
- *};
- *
- */
-/* ------ END-EXPECTED-OUTPUT ------ */
-
 struct padded_a_lot {
 	int a;
-	/* 32 bit of implicit padding here, which algo will make explicit */
 	long: 64;
 	long: 64;
 	int b;
 };
 
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 /* ----- START-EXPECTED-OUTPUT ----- */
 /*
  *struct padded_cache_line {
  *	int a;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
  *	int b;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
@@ -85,7 +72,7 @@ struct padded_cache_line {
  *struct zone {
  *	int a;
  *	short b;
- *	short: 16;
+ *	long: 0;
  *	struct zone_padding __pad__;
  *};
  *
@@ -102,12 +89,160 @@ struct zone {
 	struct zone_padding __pad__;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padding_wo_named_members {
+	long: 64;
+	long: 64;
+};
+
+struct padding_weird_1 {
+	int a;
+	long: 64;
+	short: 16;
+	short b;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padding_weird_2 {
+ *	long: 56;
+ *	char a;
+ *	long: 56;
+ *	char b;
+ *	char: 8;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct padding_weird_2 {
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char a;
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char b;
+	char: 8;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct exact_1byte {
+	char x;
+};
+
+struct padded_1byte {
+	char: 8;
+};
+
+struct exact_2bytes {
+	short x;
+};
+
+struct padded_2bytes {
+	short: 16;
+};
+
+struct exact_4bytes {
+	int x;
+};
+
+struct padded_4bytes {
+	int: 32;
+};
+
+struct exact_8bytes {
+	long x;
+};
+
+struct padded_8bytes {
+	long: 64;
+};
+
+struct ff_periodic_effect {
+	int: 32;
+	short magnitude;
+	long: 0;
+	short phase;
+	long: 0;
+	int: 32;
+	int custom_len;
+	short *custom_data;
+};
+
+struct ib_wc {
+	long: 64;
+	long: 64;
+	int: 32;
+	int byte_len;
+	void *qp;
+	union {} ex;
+	long: 64;
+	int slid;
+	int wc_flags;
+	long: 64;
+	char smac[6];
+	long: 0;
+	char network_hdr_type;
+};
+
+struct acpi_object_method {
+	long: 64;
+	char: 8;
+	char type;
+	short reference_count;
+	char flags;
+	short: 0;
+	char: 8;
+	char sync_level;
+	long: 64;
+	void *node;
+	void *aml_start;
+	union {} dispatch;
+	long: 64;
+	int aml_length;
+};
+
+struct nested_unpacked {
+	int x;
+};
+
+struct nested_packed {
+	struct nested_unpacked a;
+	char c;
+} __attribute__((packed));
+
+struct outer_mixed_but_unpacked {
+	struct nested_packed b1;
+	short a1;
+	struct nested_packed b2;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct padded_implicitly _1;
 	struct padded_explicitly _2;
 	struct padded_a_lot _3;
 	struct padded_cache_line _4;
 	struct zone _5;
+	struct padding_wo_named_members _6;
+	struct padding_weird_1 _7;
+	struct padding_weird_2 _8;
+	struct exact_1byte _100;
+	struct padded_1byte _101;
+	struct exact_2bytes _102;
+	struct padded_2bytes _103;
+	struct exact_4bytes _104;
+	struct padded_4bytes _105;
+	struct exact_8bytes _106;
+	struct padded_8bytes _107;
+	struct ff_periodic_effect _200;
+	struct ib_wc _201;
+	struct acpi_object_method _202;
+	struct outer_mixed_but_unpacked _203;
 } *_)
 {
 	return 0;
