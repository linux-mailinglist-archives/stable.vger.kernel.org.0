Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38E062B5F5
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiKPJGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiKPJGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:06:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425C1DF1F;
        Wed, 16 Nov 2022 01:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9558BB81C25;
        Wed, 16 Nov 2022 09:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3B4C433C1;
        Wed, 16 Nov 2022 09:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668589568;
        bh=YYfMwPl4NQnca3KPt8ttjq0WsYA7mSjLpK7GyN9VTVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQlkvQlOS/ouzI1ejnoF9aO2lQd8dJ55nEANvFTRANbfu4cvVmqmcHeaAD3zh8uS5
         7pCGVVQmkPRAplWa32Csaw8j1bK8NWu6mH36kObBkXGFlg+0Z8pSMlbLGvPzrpzYMl
         /usLYbiGdtX8iODIdJ/5brfgzf6JRmZmYGK0Njv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.155
Date:   Wed, 16 Nov 2022 10:05:57 +0100
Message-Id: <166858955610723@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166858955628230@kroah.com>
References: <166858955628230@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 0aa5b1cfd700..60acc39e0e93 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -215,6 +215,7 @@ KVM_S390_VM_TOD_EXT).
 :Parameters: address of a buffer in user space to store the data (u8) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.2. ATTRIBUTE: KVM_S390_VM_TOD_LOW
 -----------------------------------
@@ -224,6 +225,7 @@ the POP (u64).
 
 :Parameters: address of a buffer in user space to store the data (u64) to
 :Returns:    -EFAULT if the given address is not accessible from kernel space
+	     -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.3. ATTRIBUTE: KVM_S390_VM_TOD_EXT
 -----------------------------------
@@ -237,6 +239,7 @@ it, it is stored as 0 and not allowed to be set to a value != 0.
 	     (kvm_s390_vm_tod_clock) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 4. GROUP: KVM_S390_VM_CRYPTO
 ============================
diff --git a/Makefile b/Makefile
index 43fecb404581..8ccf902b3609 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 154
+SUBLEVEL = 155
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index fa02efb28e88..c5685179db5a 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -12,6 +12,14 @@
 
 #include <asm/efi.h>
 
+static bool region_is_misaligned(const efi_memory_desc_t *md)
+{
+	if (PAGE_SIZE == EFI_PAGE_SIZE)
+		return false;
+	return !PAGE_ALIGNED(md->phys_addr) ||
+	       !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT);
+}
+
 /*
  * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
  * executable, everything else can be mapped with the XN bits
@@ -25,14 +33,22 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	if (type == EFI_MEMORY_MAPPED_IO)
 		return PROT_DEVICE_nGnRE;
 
-	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
-		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+	if (region_is_misaligned(md)) {
+		static bool __initdata code_is_misaligned;
+
 		/*
-		 * If the region is not aligned to the page size of the OS, we
-		 * can not use strict permissions, since that would also affect
-		 * the mapping attributes of the adjacent regions.
+		 * Regions that are not aligned to the OS page size cannot be
+		 * mapped with strict permissions, as those might interfere
+		 * with the permissions that are needed by the adjacent
+		 * region's mapping. However, if we haven't encountered any
+		 * misaligned runtime code regions so far, we can safely use
+		 * non-executable permissions for non-code regions.
 		 */
-		return pgprot_val(PAGE_KERNEL_EXEC);
+		code_is_misaligned |= (type == EFI_RUNTIME_SERVICES_CODE);
+
+		return code_is_misaligned ? pgprot_val(PAGE_KERNEL_EXEC)
+					  : pgprot_val(PAGE_KERNEL);
+	}
 
 	/* R-- */
 	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
@@ -62,19 +78,16 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
 				   md->type == EFI_RUNTIME_SERVICES_DATA);
 
-	if (!PAGE_ALIGNED(md->phys_addr) ||
-	    !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT)) {
-		/*
-		 * If the end address of this region is not aligned to page
-		 * size, the mapping is rounded up, and may end up sharing a
-		 * page frame with the next UEFI memory region. If we create
-		 * a block entry now, we may need to split it again when mapping
-		 * the next region, and support for that is going to be removed
-		 * from the MMU routines. So avoid block mappings altogether in
-		 * that case.
-		 */
+	/*
+	 * If this region is not aligned to the page size used by the OS, the
+	 * mapping will be rounded outwards, and may end up sharing a page
+	 * frame with an adjacent runtime memory region. Given that the page
+	 * table descriptor covering the shared page will be rewritten when the
+	 * adjacent region gets mapped, we must avoid block mappings here so we
+	 * don't have to worry about splitting them when that happens.
+	 */
+	if (region_is_misaligned(md))
 		page_mappings_only = true;
-	}
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
@@ -101,6 +114,9 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
 	BUG_ON(md->type != EFI_RUNTIME_SERVICES_CODE &&
 	       md->type != EFI_RUNTIME_SERVICES_DATA);
 
+	if (region_is_misaligned(md))
+		return 0;
+
 	/*
 	 * Calling apply_to_page_range() is only safe on regions that are
 	 * guaranteed to be mapped down to pages. Since we are only called
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 662c8db9f45b..9f5b1247b4ba 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
 			 * The branch offset must fit in the instruction's 26
 			 * bit field.
 			 */
-			WARN_ON((offset >= BIT(25)) ||
+			WARN_ON((offset >= (long)BIT(25)) ||
 				(offset < -(long)BIT(25)));
 
 			insn.j_format.opcode = bc6_op;
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 73e8b5e5bb65..b16304fdf448 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -470,6 +470,7 @@ extern void *dtb_early_va;
 extern uintptr_t dtb_early_pa;
 void setup_bootmem(void);
 void paging_init(void);
+void misc_mem_init(void);
 
 #define FIRST_USER_ADDRESS  0
 
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index dd5f985b1f40..9a8b2e60adcf 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -111,6 +111,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* Kernel thread */
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index cc85858f7fe8..8e78a8ab6a34 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -96,6 +96,8 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
+	early_init_fdt_scan_reserved_mem();
+	misc_mem_init();
 
 #ifdef CONFIG_SWIOTLB
 	swiotlb_init(1);
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 24d936c147cd..926ab3960f9e 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -30,7 +30,7 @@ obj-y += vdso.o vdso-syms.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
 
 # Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e8921e78a292..6c2f38aac544 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -13,6 +13,7 @@
 #include <linux/of_fdt.h>
 #include <linux/libfdt.h>
 #include <linux/set_memory.h>
+#include <linux/dma-map-ops.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -41,13 +42,14 @@ struct pt_alloc_ops {
 #endif
 };
 
+static phys_addr_t dma32_phys_limit __ro_after_init;
+
 static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
 
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(min(4UL * SZ_1G,
-			(unsigned long) PFN_PHYS(max_low_pfn)));
+	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
@@ -193,6 +195,7 @@ void __init setup_bootmem(void)
 
 	max_pfn = PFN_DOWN(dram_end);
 	max_low_pfn = max_pfn;
+	dma32_phys_limit = min(4UL * SZ_1G, (unsigned long)PFN_PHYS(max_low_pfn));
 	set_max_mapnr(max_low_pfn);
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -205,7 +208,7 @@ void __init setup_bootmem(void)
 	 */
 	memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 
-	early_init_fdt_scan_reserved_mem();
+	dma_contiguous_reserve(dma32_phys_limit);
 	memblock_allow_resize();
 	memblock_dump_all();
 }
@@ -665,8 +668,12 @@ static void __init resource_init(void)
 void __init paging_init(void)
 {
 	setup_vm_final();
-	sparse_init();
 	setup_zero_page();
+}
+
+void __init misc_mem_init(void)
+{
+	sparse_init();
 	zone_sizes_init();
 	resource_init();
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d8e9239c24ff..59db85fb63e1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1092,6 +1092,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
 	return 0;
 }
 
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+
 static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_tod_clock gtod;
@@ -1101,7 +1103,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
 		return -EINVAL;
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 
 	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
 		gtod.epoch_idx, gtod.tod);
@@ -1132,7 +1134,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
 			   sizeof(gtod.tod)))
 		return -EFAULT;
 
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
 	return 0;
 }
@@ -1144,6 +1146,16 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (attr->flags)
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+	/*
+	 * For protected guests, the TOD is managed by the ultravisor, so trying
+	 * to change it will never bring the expected results.
+	 */
+	if (kvm_s390_pv_is_protected(kvm)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	switch (attr->attr) {
 	case KVM_S390_VM_TOD_EXT:
 		ret = kvm_s390_set_tod_ext(kvm, attr);
@@ -1158,6 +1170,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -ENXIO;
 		break;
 	}
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -3862,14 +3877,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod)
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_s390_tod_clock_ext htod;
 	int i;
 
-	mutex_lock(&kvm->lock);
 	preempt_disable();
 
 	get_tod_clock_ext((char *)&htod);
@@ -3890,7 +3903,15 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 
 	kvm_s390_vcpu_unblock_all(kvm);
 	preempt_enable();
+}
+
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	if (!mutex_trylock(&kvm->lock))
+		return 0;
+	__kvm_s390_set_tod_clock(kvm, gtod);
 	mutex_unlock(&kvm->lock);
+	return 1;
 }
 
 /**
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index a3e9b71d426f..b6ff64796af9 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -326,8 +326,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod);
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 3b1a498e58d2..e34d518dd3d3 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -102,7 +102,20 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 
 	VCPU_EVENT(vcpu, 3, "SCK: setting guest TOD to 0x%llx", gtod.tod);
-	kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
+	/*
+	 * To set the TOD clock the kvm lock must be taken, but the vcpu lock
+	 * is already held in handle_set_clock. The usual lock order is the
+	 * opposite.  As SCK is deprecated and should not be used in several
+	 * cases, for example when the multiple epoch facility or TOD clock
+	 * steering facility is installed (see Principles of Operation),  a
+	 * slow path can be used.  If the lock can not be taken via try_lock,
+	 * the instruction will be retried via -EAGAIN at a later point in
+	 * time.
+	 */
+	if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod)) {
+		kvm_s390_retry_instr(vcpu);
+		return -EAGAIN;
+	}
 
 	kvm_s390_set_psw_cc(vcpu, 0);
 	return 0;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 144dc164b759..5a8ee3b83af2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -489,6 +489,11 @@
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	 1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -565,9 +570,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8b9e3277a6ce..ec3fa4dc9031 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -822,8 +822,6 @@ static void init_amd_gh(struct cpuinfo_x86 *c)
 		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 }
 
-#define MSR_AMD64_DE_CFG	0xC0011029
-
 static void init_amd_ln(struct cpuinfo_x86 *c)
 {
 	/*
@@ -1018,8 +1016,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * msr_set_bit() uses the safe accessors, too, even if the MSR
 		 * is not present.
 		 */
-		msr_set_bit(MSR_F10H_DECFG,
-			    MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT);
+		msr_set_bit(MSR_AMD64_DE_CFG,
+			    MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT);
 
 		/* A serializing LFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 774ca6bfda9f..205fa420ee7c 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -342,8 +342,8 @@ static void init_hygon(struct cpuinfo_x86 *c)
 		 * msr_set_bit() uses the safe accessors, too, even if the MSR
 		 * is not present.
 		 */
-		msr_set_bit(MSR_F10H_DECFG,
-			    MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT);
+		msr_set_bit(MSR_AMD64_DE_CFG,
+			    MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT);
 
 		/* A serializing LFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a0512a91760d..2b7528821577 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2475,9 +2475,9 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 	msr->data = 0;
 
 	switch (msr->index) {
-	case MSR_F10H_DECFG:
-		if (boot_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
+	case MSR_AMD64_DE_CFG:
+		if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		return 0;
@@ -2584,7 +2584,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = 0x1E;
 		}
 		break;
-	case MSR_F10H_DECFG:
+	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
 	default:
@@ -2764,7 +2764,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_VM_IGNNE:
 		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
-	case MSR_F10H_DECFG: {
+	case MSR_AMD64_DE_CFG: {
 		struct kvm_msr_entry msr_entry;
 
 		msr_entry.index = msr->index;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ac80b3ff0f5..23d7c563e012 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1362,7 +1362,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
 
-	MSR_F10H_DECFG,
+	MSR_AMD64_DE_CFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index d023c85e3c53..61581c45788e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -522,6 +522,7 @@ static void pm_save_spec_msr(void)
 		MSR_TSX_FORCE_ABORT,
 		MSR_IA32_MCU_OPT_CTRL,
 		MSR_AMD64_LS_CFG,
+		MSR_AMD64_DE_CFG,
 	};
 
 	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a0e788b64821..459ece666c62 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3303,6 +3303,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 	case REZERO_UNIT:
 	case SEEK_6:
 	case SEEK_10:
@@ -3969,6 +3970,7 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 		return ata_scsi_write_same_xlat;
 
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
 		break;
@@ -4215,6 +4217,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 	 * turning this into a no-op.
 	 */
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		fallthrough;
 
 	/* no-op's, complete with success */
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7eaee5b705b1..6a4f9697b574 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -237,6 +237,8 @@ static void atc_dostart(struct at_dma_chan *atchan, struct at_desc *first)
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);
@@ -297,7 +299,8 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -367,7 +370,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -393,7 +396,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */
@@ -443,18 +446,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* If the transfer was a memset, free our temporary buffer */
-	if (desc->memset_buffer) {
-		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
-			      desc->memset_paddr);
-		desc->memset_buffer = false;
-	}
-
-	/* move children to free_list */
-	list_splice_init(&desc->tx_list, &atchan->free_list);
-	/* move myself to free_list */
-	list_move(&desc->desc_node, &atchan->free_list);
-
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -464,42 +455,20 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 		dmaengine_desc_get_callback_invoke(txd, NULL);
 
 	dma_run_dependencies(txd);
-}
-
-/**
- * atc_complete_all - finish work for all transactions
- * @atchan: channel to complete transactions for
- *
- * Eventually submit queued descriptors if any
- *
- * Assume channel is idle while calling this function
- * Called with atchan->lock held and bh disabled
- */
-static void atc_complete_all(struct at_dma_chan *atchan)
-{
-	struct at_desc *desc, *_desc;
-	LIST_HEAD(list);
-	unsigned long flags;
-
-	dev_vdbg(chan2dev(&atchan->chan_common), "complete all\n");
 
 	spin_lock_irqsave(&atchan->lock, flags);
-
-	/*
-	 * Submit queued descriptors ASAP, i.e. before we go through
-	 * the completed ones.
-	 */
-	if (!list_empty(&atchan->queue))
-		atc_dostart(atchan, atc_first_queued(atchan));
-	/* empty active_list now it is completed */
-	list_splice_init(&atchan->active_list, &list);
-	/* empty queue list by moving descriptors (if any) to active_list */
-	list_splice_init(&atchan->queue, &atchan->active_list);
-
+	/* move children to free_list */
+	list_splice_init(&desc->tx_list, &atchan->free_list);
+	/* add myself to free_list */
+	list_add(&desc->desc_node, &atchan->free_list);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
+	/* If the transfer was a memset, free our temporary buffer */
+	if (desc->memset_buffer) {
+		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
+			      desc->memset_paddr);
+		desc->memset_buffer = false;
+	}
 }
 
 /**
@@ -508,26 +477,28 @@ static void atc_complete_all(struct at_dma_chan *atchan)
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
-	int ret;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
 
 	spin_lock_irqsave(&atchan->lock, flags);
-	ret = atc_chan_is_enabled(atchan);
-	spin_unlock_irqrestore(&atchan->lock, flags);
-	if (ret)
-		return;
-
-	if (list_empty(&atchan->active_list) ||
-	    list_is_singular(&atchan->active_list))
-		return atc_complete_all(atchan);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_chain_complete(atchan, atc_first_active(atchan));
+	desc = atc_first_active(atchan);
+	/* Remove the transfer node from the active list. */
+	list_del_init(&desc->desc_node);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+	atc_chain_complete(atchan, desc);
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-	atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
@@ -539,6 +510,7 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
+	struct at_desc *desc;
 	struct at_desc *child;
 	unsigned long flags;
 
@@ -551,13 +523,12 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	bad_desc = atc_first_active(atchan);
 	list_del_init(&bad_desc->desc_node);
 
-	/* As we are stopped, take advantage to push queued descriptors
-	 * in active_list */
-	list_splice_init(&atchan->queue, atchan->active_list.prev);
-
 	/* Try to restart the controller */
-	if (!list_empty(&atchan->active_list))
-		atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 
 	/*
 	 * KERN_CRITICAL may seem harsh, but since this only happens
@@ -672,19 +643,11 @@ static dma_cookie_t atc_tx_submit(struct dma_async_tx_descriptor *tx)
 	spin_lock_irqsave(&atchan->lock, flags);
 	cookie = dma_cookie_assign(tx);
 
-	if (list_empty(&atchan->active_list)) {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
-				desc->txd.cookie);
-		atc_dostart(atchan, desc);
-		list_add_tail(&desc->desc_node, &atchan->active_list);
-	} else {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
-				desc->txd.cookie);
-		list_add_tail(&desc->desc_node, &atchan->queue);
-	}
-
+	list_add_tail(&desc->desc_node, &atchan->queue);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
+	dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
+		 desc->txd.cookie);
 	return cookie;
 }
 
@@ -1418,11 +1381,8 @@ static int atc_terminate_all(struct dma_chan *chan)
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1441,19 +1401,15 @@ static int atc_terminate_all(struct dma_chan *chan)
 		cpu_relax();
 
 	/* active_list entries will end up before queued entries */
-	list_splice_init(&atchan->queue, &list);
-	list_splice_init(&atchan->active_list, &list);
-
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
+	list_splice_tail_init(&atchan->queue, &atchan->free_list);
+	list_splice_tail_init(&atchan->active_list, &atchan->free_list);
 
 	clear_bit(ATC_IS_PAUSED, &atchan->status);
 	/* if channel dedicated to cyclic operations, free it */
 	clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	return 0;
 }
 
@@ -1508,20 +1464,26 @@ atc_tx_status(struct dma_chan *chan,
 }
 
 /**
- * atc_issue_pending - try to finish work
+ * atc_issue_pending - takes the first transaction descriptor in the pending
+ * queue and starts the transfer.
  * @chan: target DMA channel
  */
 static void atc_issue_pending(struct dma_chan *chan)
 {
-	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_chan *atchan = to_at_dma_chan(chan);
+	struct at_desc *desc;
+	unsigned long flags;
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	/* Not needed for cyclic transfers */
-	if (atc_chan_is_cyclic(atchan))
-		return;
+	spin_lock_irqsave(&atchan->lock, flags);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->queue))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_advance_work(atchan);
+	desc = atc_first_queued(atchan);
+	list_move_tail(&desc->desc_node, &atchan->active_list);
+	atc_dostart(atchan, desc);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**
@@ -1939,7 +1901,11 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
 	  plat_dat->nr_channels);
 
-	dma_async_device_register(&atdma->dma_common);
+	err = dma_async_device_register(&atdma->dma_common);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register: %d.\n", err);
+		goto err_dma_async_device_register;
+	}
 
 	/*
 	 * Do not return an error if the dmac node is not present in order to
@@ -1959,6 +1925,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
+err_dma_async_device_register:
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->dma_desc_pool);
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 80fc2fe8c77e..8dc82c7b1dcf 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -164,13 +164,13 @@
 /* LLI == Linked List Item; aka DMA buffer descriptor */
 struct at_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	saddr;
-	dma_addr_t	daddr;
+	u32 saddr;
+	u32 daddr;
 	/* value that may get written back: */
-	u32		ctrla;
+	u32 ctrla;
 	/* more values that are not changed by hardware */
-	u32		ctrlb;
-	dma_addr_t	dscr;	/* chain to next lli */
+	u32 ctrlb;
+	u32 dscr;	/* chain to next lli */
 };
 
 /**
diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 9b0d463f89bb..4800c596433a 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -899,6 +899,7 @@ static int mv_xor_v2_remove(struct platform_device *pdev)
 	tasklet_kill(&xor_dev->irq_tasklet);
 
 	clk_disable_unprepare(xor_dev->clk);
+	clk_disable_unprepare(xor_dev->reg_clk);
 
 	return 0;
 }
diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index b4ef4f19f7de..68d9d60c051d 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -1249,14 +1249,14 @@ static int pxad_init_phys(struct platform_device *op,
 		return -ENOMEM;
 
 	for (i = 0; i < nb_phy_chans; i++)
-		if (platform_get_irq(op, i) > 0)
+		if (platform_get_irq_optional(op, i) > 0)
 			nr_irq++;
 
 	for (i = 0; i < nb_phy_chans; i++) {
 		phy = &pdev->phys[i];
 		phy->base = pdev->base;
 		phy->idx = i;
-		irq = platform_get_irq(op, i);
+		irq = platform_get_irq_optional(op, i);
 		if ((nr_irq > 1) && (irq > 0))
 			ret = devm_request_irq(&op->dev, irq,
 					       pxad_chan_handler,
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 8dd295dbe241..dd35d3d7ad03 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -36,13 +36,13 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attachme
 		goto err_unpin_pages;
 	}
 
-	ret = sg_alloc_table(st, obj->mm.pages->nents, GFP_KERNEL);
+	ret = sg_alloc_table(st, obj->mm.pages->orig_nents, GFP_KERNEL);
 	if (ret)
 		goto err_free;
 
 	src = obj->mm.pages->sgl;
 	dst = st->sgl;
-	for (i = 0; i < obj->mm.pages->nents; i++) {
+	for (i = 0; i < obj->mm.pages->orig_nents; i++) {
 		sg_set_page(dst, sg_page(src), src->length, 0);
 		dst = sg_next(dst);
 		src = sg_next(src);
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 52426bc8edb8..888aec1bbeee 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -404,7 +404,12 @@ static int __init vc4_drm_register(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&vc4_platform_driver);
+	ret = platform_driver_register(&vc4_platform_driver);
+	if (ret)
+		platform_unregister_drivers(component_drivers,
+					    ARRAY_SIZE(component_drivers));
+
+	return ret;
 }
 
 static void __exit vc4_drm_unregister(void)
diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 978ee2aab2d4..b7704dd6809d 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -498,7 +498,7 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = hid_add_device(hid_dev);
 	if (ret)
-		goto probe_err1;
+		goto probe_err2;
 
 
 	ret = hid_parse(hid_dev);
diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
index 364710966665..e49914664863 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -105,7 +105,7 @@ static const struct regmap_config tcsr_mutex_config = {
 	.reg_bits		= 32,
 	.reg_stride		= 4,
 	.val_bits		= 32,
-	.max_register		= 0x40000,
+	.max_register		= 0x20000,
 	.fast_io		= true,
 };
 
diff --git a/drivers/mmc/host/sdhci-cqhci.h b/drivers/mmc/host/sdhci-cqhci.h
new file mode 100644
index 000000000000..cf8e7ba71bbd
--- /dev/null
+++ b/drivers/mmc/host/sdhci-cqhci.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2022 The Chromium OS Authors
+ *
+ * Support that applies to the combination of SDHCI and CQHCI, while not
+ * expressing a dependency between the two modules.
+ */
+
+#ifndef __MMC_HOST_SDHCI_CQHCI_H__
+#define __MMC_HOST_SDHCI_CQHCI_H__
+
+#include "cqhci.h"
+#include "sdhci.h"
+
+static inline void sdhci_and_cqhci_reset(struct sdhci_host *host, u8 mask)
+{
+	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
+	    host->mmc->cqe_private)
+		cqhci_deactivate(host->mmc);
+
+	sdhci_reset(host, mask);
+}
+
+#endif /* __MMC_HOST_SDHCI_CQHCI_H__ */
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index be4e5cdda1fa..449562122adc 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -26,6 +26,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/mmc-esdhc-imx.h>
 #include <linux/pm_runtime.h>
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
 #include "cqhci.h"
@@ -294,22 +295,6 @@ struct pltfm_imx_data {
 	struct pm_qos_request pm_qos_req;
 };
 
-static const struct platform_device_id imx_esdhc_devtype[] = {
-	{
-		.name = "sdhci-esdhc-imx25",
-		.driver_data = (kernel_ulong_t) &esdhc_imx25_data,
-	}, {
-		.name = "sdhci-esdhc-imx35",
-		.driver_data = (kernel_ulong_t) &esdhc_imx35_data,
-	}, {
-		.name = "sdhci-esdhc-imx51",
-		.driver_data = (kernel_ulong_t) &esdhc_imx51_data,
-	}, {
-		/* sentinel */
-	}
-};
-MODULE_DEVICE_TABLE(platform, imx_esdhc_devtype);
-
 static const struct of_device_id imx_esdhc_dt_ids[] = {
 	{ .compatible = "fsl,imx25-esdhc", .data = &esdhc_imx25_data, },
 	{ .compatible = "fsl,imx35-esdhc", .data = &esdhc_imx35_data, },
@@ -1243,7 +1228,7 @@ static void esdhc_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 
 static void esdhc_reset(struct sdhci_host *host, u8 mask)
 {
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
@@ -1545,72 +1530,6 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
 }
 #endif
 
-static int sdhci_esdhc_imx_probe_nondt(struct platform_device *pdev,
-			 struct sdhci_host *host,
-			 struct pltfm_imx_data *imx_data)
-{
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
-	int err;
-
-	if (!host->mmc->parent->platform_data) {
-		dev_err(mmc_dev(host->mmc), "no board data!\n");
-		return -EINVAL;
-	}
-
-	imx_data->boarddata = *((struct esdhc_platform_data *)
-				host->mmc->parent->platform_data);
-	/* write_protect */
-	if (boarddata->wp_type == ESDHC_WP_GPIO) {
-		host->mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
-
-		err = mmc_gpiod_request_ro(host->mmc, "wp", 0, 0);
-		if (err) {
-			dev_err(mmc_dev(host->mmc),
-				"failed to request write-protect gpio!\n");
-			return err;
-		}
-	}
-
-	/* card_detect */
-	switch (boarddata->cd_type) {
-	case ESDHC_CD_GPIO:
-		err = mmc_gpiod_request_cd(host->mmc, "cd", 0, false, 0);
-		if (err) {
-			dev_err(mmc_dev(host->mmc),
-				"failed to request card-detect gpio!\n");
-			return err;
-		}
-		fallthrough;
-
-	case ESDHC_CD_CONTROLLER:
-		/* we have a working card_detect back */
-		host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
-		break;
-
-	case ESDHC_CD_PERMANENT:
-		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
-		break;
-
-	case ESDHC_CD_NONE:
-		break;
-	}
-
-	switch (boarddata->max_bus_width) {
-	case 8:
-		host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA;
-		break;
-	case 4:
-		host->mmc->caps |= MMC_CAP_4_BIT_DATA;
-		break;
-	case 1:
-	default:
-		host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
-		break;
-	}
-
-	return 0;
-}
-
 static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
@@ -1630,8 +1549,7 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 
 	imx_data = sdhci_pltfm_priv(pltfm_host);
 
-	imx_data->socdata = of_id ? of_id->data : (struct esdhc_soc_data *)
-						  pdev->id_entry->driver_data;
+	imx_data->socdata = of_id->data;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_PMQOS)
 		cpu_latency_qos_add_request(&imx_data->pm_qos_req, 0);
@@ -1943,7 +1861,6 @@ static struct platform_driver sdhci_esdhc_imx_driver = {
 		.of_match_table = imx_esdhc_dt_ids,
 		.pm	= &sdhci_esdhc_pmops,
 	},
-	.id_table	= imx_esdhc_devtype,
 	.probe		= sdhci_esdhc_imx_probe,
 	.remove		= sdhci_esdhc_imx_remove,
 };
diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index fc38db64a6b4..9da49dc15248 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -25,6 +25,7 @@
 #include <linux/firmware/xlnx-zynqmp.h>
 
 #include "cqhci.h"
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 
 #define SDHCI_ARASAN_VENDOR_REGISTER	0x78
@@ -359,7 +360,7 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
 		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 67211fc42d24..d8fd2b5efd38 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -24,6 +24,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/ktime.h>
 
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "cqhci.h"
 
@@ -361,7 +362,7 @@ static void tegra_sdhci_reset(struct sdhci_host *host, u8 mask)
 	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
 	u32 misc_ctrl, clk_ctrl, pad_ctrl;
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (!(mask & SDHCI_RESET_ALL))
 		return;
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 7cab9d831afb..24cd6d3dc647 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -15,6 +15,7 @@
 #include <linux/sys_soc.h>
 
 #include "cqhci.h"
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 
 /* CTL_CFG Registers */
@@ -378,7 +379,7 @@ static void sdhci_am654_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (sdhci_am654->quirks & SDHCI_AM654_QUIRK_FORCE_CDTEST) {
 		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
@@ -464,7 +465,7 @@ static struct sdhci_ops sdhci_am654_ops = {
 	.set_clock = sdhci_am654_set_clock,
 	.write_b = sdhci_am654_write_b,
 	.irq = sdhci_am654_cqhci_irq,
-	.reset = sdhci_reset,
+	.reset = sdhci_and_cqhci_reset,
 };
 
 static const struct sdhci_pltfm_data sdhci_am654_pdata = {
@@ -494,7 +495,7 @@ static struct sdhci_ops sdhci_j721e_8bit_ops = {
 	.set_clock = sdhci_am654_set_clock,
 	.write_b = sdhci_am654_write_b,
 	.irq = sdhci_am654_cqhci_irq,
-	.reset = sdhci_reset,
+	.reset = sdhci_and_cqhci_reset,
 };
 
 static const struct sdhci_pltfm_data sdhci_j721e_8bit_pdata = {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 78c7cbc372b0..71151f675a49 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1004,8 +1004,10 @@ static int xgene_enet_open(struct net_device *ndev)
 
 	xgene_enet_napi_enable(pdata);
 	ret = xgene_enet_register_irq(ndev);
-	if (ret)
+	if (ret) {
+		xgene_enet_napi_disable(pdata);
 		return ret;
+	}
 
 	if (ndev->phydev) {
 		phy_start(ndev->phydev);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 7c6e0811f2e6..ee823a18294c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -585,6 +585,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
 
+	memzero_explicit(&key_rec, sizeof(key_rec));
 	return ret;
 }
 
@@ -932,6 +933,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_ingress_sakey_record(hw, &sa_key_record, sa_idx);
 
+	memzero_explicit(&sa_key_record, sizeof(sa_key_record));
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 36c7cf05630a..431924959520 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -757,6 +757,7 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 			 u16 table_index)
 {
 	u16 packed_record[18];
+	int ret;
 
 	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
 		return -EINVAL;
@@ -789,9 +790,12 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 
 	packed_record[16] = rec->key_len & 0x3;
 
-	return set_raw_ingress_record(hw, packed_record, 18, 2,
-				      ROWOFFSET_INGRESSSAKEYRECORD +
-					      table_index);
+	ret = set_raw_ingress_record(hw, packed_record, 18, 2,
+				     ROWOFFSET_INGRESSSAKEYRECORD +
+				     table_index);
+
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
@@ -1739,14 +1743,14 @@ static int set_egress_sakey_record(struct aq_hw_s *hw,
 	ret = set_raw_egress_record(hw, packed_record, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
 	if (unlikely(ret))
-		return ret;
+		goto clear_key;
 	ret = set_raw_egress_record(hw, packed_record + 8, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
 					    32);
-	if (unlikely(ret))
-		return ret;
 
-	return 0;
+clear_key:
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 7b79528d6eed..2b6d929d462f 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,7 +69,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if ARCH_BCM2835
+	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b818d5f342d5..8311473d537b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12008,8 +12008,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(fltr, head, hash) {
 		if (bnxt_fltr_match(fltr, new_fltr)) {
+			rc = fltr->sw_id;
 			rcu_read_unlock();
-			rc = 0;
 			goto err_free;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index f8f775619520..81b63d1c2391 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -125,7 +125,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	}
 
 reset_coalesce:
-	if (netif_running(dev)) {
+	if (test_bit(BNXT_STATE_OPEN, &bp->state)) {
 		if (update_stats) {
 			rc = bnxt_close_nic(bp, true, false);
 			if (!rc)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad7261e243..8a167eea288c 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1302,6 +1302,7 @@ static int cxgb_up(struct adapter *adap)
 		if (ret < 0) {
 			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
+			quiesce_rx(adap);
 			free_irq_resources(adap);
 			err = ret;
 			goto out;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 2820a0bb971b..5e1e46425014 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -858,7 +858,7 @@ static int cxgb4vf_open(struct net_device *dev)
 	 */
 	err = t4vf_update_port_info(pi);
 	if (err < 0)
-		return err;
+		goto err_unwind;
 
 	/*
 	 * Note that this interface is up and start everything up ...
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 6eeccc11b76e..3312dc4083a0 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -884,12 +884,21 @@ static int mac_probe(struct platform_device *_of_dev)
 	return err;
 }
 
+static int mac_remove(struct platform_device *pdev)
+{
+	struct mac_device *mac_dev = platform_get_drvdata(pdev);
+
+	platform_device_unregister(mac_dev->priv->eth_dev);
+	return 0;
+}
+
 static struct platform_driver mac_driver = {
 	.driver = {
 		.name		= KBUILD_MODNAME,
 		.of_match_table	= mac_match,
 	},
 	.probe		= mac_probe,
+	.remove		= mac_remove,
 };
 
 builtin_platform_driver(mac_driver);
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111ce534..735b76effc49 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2471,6 +2471,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 	for (i = 0; i < mp->rxq_count; i++)
 		rxq_deinit(mp->rxq + i);
 out:
+	napi_disable(&mp->napi);
 	free_irq(dev->irq, dev);
 
 	return err;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 2a13c318048c..59a3ea02b8ad 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -771,6 +771,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
 int prestera_rxtx_switch_init(struct prestera_switch *sw)
 {
 	struct prestera_rxtx *rxtx;
+	int err;
 
 	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
 	if (!rxtx)
@@ -778,7 +779,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
 
 	sw->rxtx = rxtx;
 
-	return prestera_sdma_switch_init(sw);
+	err = prestera_sdma_switch_init(sw);
+	if (err)
+		kfree(rxtx);
+
+	return err;
 }
 
 void prestera_rxtx_switch_fini(struct prestera_switch *sw)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 6612b2c0be48..cf07318048df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1687,12 +1687,17 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int i;
 
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		while (down_trylock(&cmd->sem))
+	for (i = 0; i < cmd->max_reg_cmds; i++) {
+		while (down_trylock(&cmd->sem)) {
 			mlx5_cmd_trigger_completions(dev);
+			cond_resched();
+		}
+	}
 
-	while (down_trylock(&cmd->pages_sem))
+	while (down_trylock(&cmd->pages_sem)) {
 		mlx5_cmd_trigger_completions(dev);
+		cond_resched();
+	}
 
 	/* Unlock cmdif */
 	up(&cmd->pages_sem);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 1cbb330b9f42..6c865cb7f445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -30,9 +30,9 @@ mlx5_eswitch_termtbl_hash(struct mlx5_flow_act *flow_act,
 		     sizeof(dest->vport.num), hash);
 	hash = jhash((const void *)&dest->vport.vhca_id,
 		     sizeof(dest->vport.num), hash);
-	if (dest->vport.pkt_reformat)
-		hash = jhash(dest->vport.pkt_reformat,
-			     sizeof(*dest->vport.pkt_reformat),
+	if (flow_act->pkt_reformat)
+		hash = jhash(flow_act->pkt_reformat,
+			     sizeof(*flow_act->pkt_reformat),
 			     hash);
 	return hash;
 }
@@ -53,9 +53,11 @@ mlx5_eswitch_termtbl_cmp(struct mlx5_flow_act *flow_act1,
 	if (ret)
 		return ret;
 
-	return dest1->vport.pkt_reformat && dest2->vport.pkt_reformat ?
-	       memcmp(dest1->vport.pkt_reformat, dest2->vport.pkt_reformat,
-		      sizeof(*dest1->vport.pkt_reformat)) : 0;
+	if (flow_act1->pkt_reformat && flow_act2->pkt_reformat)
+		return memcmp(flow_act1->pkt_reformat, flow_act2->pkt_reformat,
+			      sizeof(*flow_act1->pkt_reformat));
+
+	return !(flow_act1->pkt_reformat == flow_act2->pkt_reformat);
 }
 
 static int
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 3cae8449fadb..8a30be698f99 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7114,9 +7114,8 @@ static int s2io_card_up(struct s2io_nic *sp)
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
-			s2io_reset(sp);
-			free_rx_buffers(sp);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_fill_buff;
 		}
 		DBG_PRINT(INFO_DBG, "Buf in ring:%d is %d:\n", i,
 			  ring->rx_bufs_left);
@@ -7154,18 +7153,16 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Enable Rx Traffic and interrupts on the NIC */
 	if (start_nic(sp)) {
 		DBG_PRINT(ERR_DBG, "%s: Starting NIC failed\n", dev->name);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	/* Add interrupt service routine */
 	if (s2io_add_isr(sp) != 0) {
 		if (sp->config.intr_type == MSI_X)
 			s2io_rem_isr(sp);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	timer_setup(&sp->alarm_timer, s2io_alarm_handle, 0);
@@ -7185,6 +7182,20 @@ static int s2io_card_up(struct s2io_nic *sp)
 	}
 
 	return 0;
+
+err_out:
+	if (config->napi) {
+		if (config->intr_type == MSI_X) {
+			for (i = 0; i < sp->config.rx_ring_num; i++)
+				napi_disable(&sp->mac_control.rings[i].napi);
+		} else {
+			napi_disable(&sp->napi);
+		}
+	}
+err_fill_buff:
+	s2io_reset(sp);
+	free_rx_buffers(sp);
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df9904f..9c48fd85c418 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -899,6 +899,7 @@ static int nixge_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(priv->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&priv->napi);
 	phy_stop(phy);
 	phy_disconnect(phy);
 	tasklet_kill(&priv->dma_err_tasklet);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 752658ec7bee..50ef68497bce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -261,11 +261,9 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 	if (ret)
 		return ret;
 
-	devm_add_action_or_reset(dwmac->dev,
-				 (void(*)(void *))clk_disable_unprepare,
-				 dwmac->rgmii_tx_clk);
-
-	return 0;
+	return devm_add_action_or_reset(dwmac->dev,
+					(void(*)(void *))clk_disable_unprepare,
+					clk);
 }
 
 static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b0f00b4edd94..5af0f9f8c097 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -864,6 +864,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index c62f474b6d08..fcebd2418dbd 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1302,12 +1302,15 @@ static int tsi108_open(struct net_device *dev)
 
 	data->rxring = dma_alloc_coherent(&data->pdev->dev, rxring_size,
 					  &data->rxdma, GFP_KERNEL);
-	if (!data->rxring)
+	if (!data->rxring) {
+		free_irq(data->irq_num, dev);
 		return -ENOMEM;
+	}
 
 	data->txring = dma_alloc_coherent(&data->pdev->dev, txring_size,
 					  &data->txdma, GFP_KERNEL);
 	if (!data->txring) {
+		free_irq(data->irq_num, dev);
 		dma_free_coherent(&data->pdev->dev, rxring_size, data->rxring,
 				    data->rxdma);
 		return -ENOMEM;
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 1ad6085994b1..5c17c92add8a 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -533,7 +533,7 @@ static int bpq_device_event(struct notifier_block *this,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !bpq_get_ax25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 70c5905a916b..f84e3cc0d3ec 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1390,7 +1390,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+					 bool active)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1414,7 +1415,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
-	rx_sc->active = true;
+	rx_sc->active = active;
 	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
@@ -1823,6 +1824,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -1867,7 +1869,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
-	bool was_active;
+	bool active = true;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1889,16 +1891,15 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
-	rx_sc = create_rx_sc(dev, sci);
+	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
+		active = nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
+
+	rx_sc = create_rx_sc(dev, sci, active);
 	if (IS_ERR(rx_sc)) {
 		rtnl_unlock();
 		return PTR_ERR(rx_sc);
 	}
 
-	was_active = rx_sc->active;
-	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
-		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
-
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
@@ -1922,7 +1923,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	rx_sc->active = was_active;
+	del_rx_sc(secy, sci);
+	free_rx_sc(rx_sc);
 	rtnl_unlock();
 	return ret;
 }
@@ -2065,6 +2067,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -2561,7 +2564,7 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	int i;
 
-	if (secy->n_rx_sc > 0)
+	if (secy->rx_sc)
 		return true;
 
 	for (i = 0; i < MACSEC_NUM_AN; i++)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c8d803d3616c..6b269a72388b 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1509,8 +1509,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	/* the macvlan port may be freed by macvlan_uninit when fail to register.
 	 * so we destroy the macvlan port only when it's valid.
 	 */
-	if (create && macvlan_port_get_rtnl(lowerdev))
+	if (create && macvlan_port_get_rtnl(lowerdev)) {
+		macvlan_flush_sources(port, vlan);
 		macvlan_port_destroy(port->dev);
+	}
 	return err;
 }
 EXPORT_SYMBOL_GPL(macvlan_common_newlink);
diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..c00eef457b85 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -632,6 +632,7 @@ static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
 
 	list_del(&flow->list);
 	clear_bit(flow->index, bitmap);
+	memzero_explicit(flow->key, sizeof(flow->key));
 	kfree(flow);
 }
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0c09f8e9d383..cb42fdbfeb32 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1986,17 +1986,25 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
+			WARN_ON_ONCE(1);
+			err = -ENOMEM;
 			this_cpu_inc(tun->pcpu_stats->rx_dropped);
+napi_busy:
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
-			WARN_ON(1);
-			return -ENOMEM;
+			return err;
 		}
 
-		local_bh_disable();
-		napi_gro_frags(&tfile->napi);
-		local_bh_enable();
+		if (likely(napi_schedule_prep(&tfile->napi))) {
+			local_bh_disable();
+			napi_gro_frags(&tfile->napi);
+			napi_complete(&tfile->napi);
+			local_bh_enable();
+		} else {
+			err = -EBUSY;
+			goto napi_busy;
+		}
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index f6562a343cb4..b965eb6a4bb1 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -403,7 +403,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 2b3639cba51a..03fc567e9f18 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -393,6 +393,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(child, "reg", &index);
 		if (ret || index > usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
+			if (!ret)
+				ret = -EINVAL;
 			goto put_child;
 		}
 
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 012639f6d335..519b2ab84a63 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -900,8 +900,16 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 	wwan_rfkill = NULL;
 	rfkill2_count = 0;
 
-	if (hp_wmi_rfkill_setup(device))
-		hp_wmi_rfkill2_setup(device);
+	/*
+	 * In pre-2009 BIOS, command 1Bh return 0x4 to indicate that
+	 * BIOS no longer controls the power for the wireless
+	 * devices. All features supported by this command will no
+	 * longer be supported.
+	 */
+	if (!hp_wmi_bios_2009_later()) {
+		if (hp_wmi_rfkill_setup(device))
+			hp_wmi_rfkill2_setup(device);
+	}
 
 	thermal_policy_setup(device);
 
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 999c14e5d0bd..0599566c66b0 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -192,7 +192,7 @@ void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index bc267832310c..d5294e663df5 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -77,8 +77,10 @@ static void fuse_add_dirent_to_cache(struct file *file,
 		goto unlock;
 
 	addr = kmap_atomic(page);
-	if (!offset)
+	if (!offset) {
 		clear_page(addr);
+		SetPageUptodate(page);
+	}
 	memcpy(addr + offset, dirent, reclen);
 	kunmap_atomic(addr);
 	fi->rdc.size = (index << PAGE_SHIFT) + offset + reclen;
@@ -516,6 +518,12 @@ static int fuse_readdir_cached(struct file *file, struct dir_context *ctx)
 
 	page = find_get_page_flags(file->f_mapping, index,
 				   FGP_ACCESSED | FGP_LOCK);
+	/* Page gone missing, then re-added to cache, but not initialized? */
+	if (page && !PageUptodate(page)) {
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
+	}
 	spin_lock(&fi->rdc.lock);
 	if (!page) {
 		/*
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05f360b66b07..d1cb1addea96 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9038,7 +9038,7 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 
 		if (unlikely(ctx->sqo_dead)) {
 			ret = -EOWNERDEAD;
-			goto out;
+			break;
 		}
 
 		if (!io_sqring_full(ctx))
@@ -9048,7 +9048,6 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
-out:
 	return ret;
 }
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 545f764d70b1..5ee4973525f0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -322,7 +322,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2248,7 +2248,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_transaction_info *ti;
 	int err;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2287,7 +2287,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2783,11 +2783,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem was remounted
-		 * read/write after nilfs_error degenerated it into a
-		 * read-only mount.
+		 * This happens if the filesystem is made read-only by
+		 * __nilfs_error or nilfs_remount and then remounted
+		 * read/write.  In these cases, reuse the existing
+		 * writer.
 		 */
-		nilfs_detach_log_writer(sb);
+		return 0;
 	}
 
 	nilfs->ns_writer = nilfs_segctor_new(sb, root);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index b9d30e8c43b0..7a41c9727c9e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1133,8 +1133,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out;
 	if (*flags & SB_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= SB_RDONLY;
 
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index c20ebecd7bc2..ce103dd39b89 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -690,9 +690,7 @@ int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 9f3aced46c68..aff5ca32e4f6 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -241,7 +241,7 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 						      poffset - lfi);
 			else {
 				if (!copy_name) {
-					copy_name = kmalloc(UDF_NAME_LEN,
+					copy_name = kmalloc(UDF_NAME_LEN_CS0,
 							    GFP_NOFS);
 					if (!copy_name) {
 						fi = ERR_PTR(-ENOMEM);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a774361f28d4..d233f9e4b9c6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -328,6 +328,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -972,7 +973,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 391bc1480dfb..4d37c69e76b1 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -45,7 +45,7 @@ struct bpf_reg_state {
 	enum bpf_reg_type type;
 	union {
 		/* valid when type == PTR_TO_PACKET */
-		u16 range;
+		int range;
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
@@ -290,6 +290,27 @@ struct bpf_verifier_state {
 	     iter < frame->allocated_stack / BPF_REG_SIZE;		\
 	     iter++, reg = bpf_get_spilled_reg(iter, frame))
 
+/* Invoke __expr over regsiters in __vst, setting __state and __reg */
+#define bpf_for_each_reg_in_vstate(__vst, __state, __reg, __expr)   \
+	({                                                               \
+		struct bpf_verifier_state *___vstate = __vst;            \
+		int ___i, ___j;                                          \
+		for (___i = 0; ___i <= ___vstate->curframe; ___i++) {    \
+			struct bpf_reg_state *___regs;                   \
+			__state = ___vstate->frame[___i];                \
+			___regs = __state->regs;                         \
+			for (___j = 0; ___j < MAX_BPF_REG; ___j++) {     \
+				__reg = &___regs[___j];                  \
+				(void)(__expr);                          \
+			}                                                \
+			bpf_for_each_spilled_reg(___j, __state, __reg) { \
+				if (!__reg)                              \
+					continue;                        \
+				(void)(__expr);                          \
+			}                                                \
+		}                                                        \
+	})
+
 /* linked list of verifier states used to prune search */
 struct bpf_verifier_state_list {
 	struct bpf_verifier_state state;
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 2ddb4226cd23..43a44538ec8d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -427,7 +427,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e4dcc23b52c0..50364031eb4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2978,7 +2978,9 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 			regno);
 		return -EACCES;
 	}
-	err = __check_mem_access(env, regno, off, size, reg->range,
+
+	err = reg->range < 0 ? -EINVAL :
+	      __check_mem_access(env, regno, off, size, reg->range,
 				 zero_size_allowed);
 	if (err) {
 		verbose(env, "R%d offset is outside of the packet\n", regno);
@@ -4991,50 +4993,41 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  */
-static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
-				     struct bpf_func_state *state)
+static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 {
-	struct bpf_reg_state *regs = state->regs, *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (reg_is_pkt_pointer_any(&regs[i]))
-			mark_reg_unknown(env, regs, i);
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
 
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
+	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
 		if (reg_is_pkt_pointer_any(reg))
 			__mark_reg_unknown(env, reg);
-	}
+	}));
 }
 
-static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
-{
-	struct bpf_verifier_state *vstate = env->cur_state;
-	int i;
-
-	for (i = 0; i <= vstate->curframe; i++)
-		__clear_all_pkt_pointers(env, vstate->frame[i]);
-}
+enum {
+	AT_PKT_END = -1,
+	BEYOND_PKT_END = -2,
+};
 
-static void release_reg_references(struct bpf_verifier_env *env,
-				   struct bpf_func_state *state,
-				   int ref_obj_id)
+static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range_open)
 {
-	struct bpf_reg_state *regs = state->regs, *reg;
-	int i;
+	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+	struct bpf_reg_state *reg = &state->regs[regn];
 
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
-			mark_reg_unknown(env, regs, i);
+	if (reg->type != PTR_TO_PACKET)
+		/* PTR_TO_PACKET_META is not supported yet */
+		return;
 
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		if (reg->ref_obj_id == ref_obj_id)
-			__mark_reg_unknown(env, reg);
-	}
+	/* The 'reg' is pkt > pkt_end or pkt >= pkt_end.
+	 * How far beyond pkt_end it goes is unknown.
+	 * if (!range_open) it's the case of pkt >= pkt_end
+	 * if (range_open) it's the case of pkt > pkt_end
+	 * hence this pointer is at least 1 byte bigger than pkt_end
+	 */
+	if (range_open)
+		reg->range = BEYOND_PKT_END;
+	else
+		reg->range = AT_PKT_END;
 }
 
 /* The pointer with the specified id has released its reference to kernel
@@ -5043,16 +5036,22 @@ static void release_reg_references(struct bpf_verifier_env *env,
 static int release_reference(struct bpf_verifier_env *env,
 			     int ref_obj_id)
 {
-	struct bpf_verifier_state *vstate = env->cur_state;
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
 	int err;
-	int i;
 
 	err = release_reference_state(cur_func(env), ref_obj_id);
 	if (err)
 		return err;
 
-	for (i = 0; i <= vstate->curframe; i++)
-		release_reg_references(env, vstate->frame[i], ref_obj_id);
+	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
+		if (reg->ref_obj_id == ref_obj_id) {
+			if (!env->allow_ptr_leaks)
+				__mark_reg_not_init(env, reg);
+			else
+				__mark_reg_unknown(env, reg);
+		}
+	}));
 
 	return 0;
 }
@@ -7191,35 +7190,14 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
-static void __find_good_pkt_pointers(struct bpf_func_state *state,
-				     struct bpf_reg_state *dst_reg,
-				     enum bpf_reg_type type, u16 new_range)
-{
-	struct bpf_reg_state *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		reg = &state->regs[i];
-		if (reg->type == type && reg->id == dst_reg->id)
-			/* keep the maximum range already checked */
-			reg->range = max(reg->range, new_range);
-	}
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		if (reg->type == type && reg->id == dst_reg->id)
-			reg->range = max(reg->range, new_range);
-	}
-}
-
 static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 				   struct bpf_reg_state *dst_reg,
 				   enum bpf_reg_type type,
 				   bool range_right_open)
 {
-	u16 new_range;
-	int i;
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
+	int new_range;
 
 	if (dst_reg->off < 0 ||
 	    (dst_reg->off == 0 && range_right_open))
@@ -7284,9 +7262,11 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 	 * the range won't allow anything.
 	 * dst_reg->off is known < MAX_PACKET_OFF, therefore it fits in a u16.
 	 */
-	for (i = 0; i <= vstate->curframe; i++)
-		__find_good_pkt_pointers(vstate->frame[i], dst_reg, type,
-					 new_range);
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		if (reg->type == type && reg->id == dst_reg->id)
+			/* keep the maximum range already checked */
+			reg->range = max(reg->range, new_range);
+	}));
 }
 
 static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
@@ -7470,6 +7450,67 @@ static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 	return is_branch64_taken(reg, val, opcode);
 }
 
+static int flip_opcode(u32 opcode)
+{
+	/* How can we transform "a <op> b" into "b <op> a"? */
+	static const u8 opcode_flip[16] = {
+		/* these stay the same */
+		[BPF_JEQ  >> 4] = BPF_JEQ,
+		[BPF_JNE  >> 4] = BPF_JNE,
+		[BPF_JSET >> 4] = BPF_JSET,
+		/* these swap "lesser" and "greater" (L and G in the opcodes) */
+		[BPF_JGE  >> 4] = BPF_JLE,
+		[BPF_JGT  >> 4] = BPF_JLT,
+		[BPF_JLE  >> 4] = BPF_JGE,
+		[BPF_JLT  >> 4] = BPF_JGT,
+		[BPF_JSGE >> 4] = BPF_JSLE,
+		[BPF_JSGT >> 4] = BPF_JSLT,
+		[BPF_JSLE >> 4] = BPF_JSGE,
+		[BPF_JSLT >> 4] = BPF_JSGT
+	};
+	return opcode_flip[opcode >> 4];
+}
+
+static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
+				   struct bpf_reg_state *src_reg,
+				   u8 opcode)
+{
+	struct bpf_reg_state *pkt;
+
+	if (src_reg->type == PTR_TO_PACKET_END) {
+		pkt = dst_reg;
+	} else if (dst_reg->type == PTR_TO_PACKET_END) {
+		pkt = src_reg;
+		opcode = flip_opcode(opcode);
+	} else {
+		return -1;
+	}
+
+	if (pkt->range >= 0)
+		return -1;
+
+	switch (opcode) {
+	case BPF_JLE:
+		/* pkt <= pkt_end */
+		fallthrough;
+	case BPF_JGT:
+		/* pkt > pkt_end */
+		if (pkt->range == BEYOND_PKT_END)
+			/* pkt has at last one extra byte beyond pkt_end */
+			return opcode == BPF_JGT;
+		break;
+	case BPF_JLT:
+		/* pkt < pkt_end */
+		fallthrough;
+	case BPF_JGE:
+		/* pkt >= pkt_end */
+		if (pkt->range == BEYOND_PKT_END || pkt->range == AT_PKT_END)
+			return opcode == BPF_JGE;
+		break;
+	}
+	return -1;
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
@@ -7640,23 +7681,7 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 				u64 val, u32 val32,
 				u8 opcode, bool is_jmp32)
 {
-	/* How can we transform "a <op> b" into "b <op> a"? */
-	static const u8 opcode_flip[16] = {
-		/* these stay the same */
-		[BPF_JEQ  >> 4] = BPF_JEQ,
-		[BPF_JNE  >> 4] = BPF_JNE,
-		[BPF_JSET >> 4] = BPF_JSET,
-		/* these swap "lesser" and "greater" (L and G in the opcodes) */
-		[BPF_JGE  >> 4] = BPF_JLE,
-		[BPF_JGT  >> 4] = BPF_JLT,
-		[BPF_JLE  >> 4] = BPF_JGE,
-		[BPF_JLT  >> 4] = BPF_JGT,
-		[BPF_JSGE >> 4] = BPF_JSLE,
-		[BPF_JSGT >> 4] = BPF_JSLT,
-		[BPF_JSLE >> 4] = BPF_JSGE,
-		[BPF_JSLT >> 4] = BPF_JSGT
-	};
-	opcode = opcode_flip[opcode >> 4];
+	opcode = flip_opcode(opcode);
 	/* This uses zero as "not present in table"; luckily the zero opcode,
 	 * BPF_JA, can't get here.
 	 */
@@ -7754,7 +7779,7 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			reg->ref_obj_id = 0;
 		} else if (!reg_may_point_to_spin_lock(reg)) {
 			/* For not-NULL ptr, reg->ref_obj_id will be reset
-			 * in release_reg_references().
+			 * in release_reference().
 			 *
 			 * reg->id is still used by spin_lock ptr. Other
 			 * than spin_lock ptr type, reg->id can be reset.
@@ -7764,22 +7789,6 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 	}
 }
 
-static void __mark_ptr_or_null_regs(struct bpf_func_state *state, u32 id,
-				    bool is_null)
-{
-	struct bpf_reg_state *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		mark_ptr_or_null_reg(state, &state->regs[i], id, is_null);
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		mark_ptr_or_null_reg(state, reg, id, is_null);
-	}
-}
-
 /* The logic is similar to find_good_pkt_pointers(), both could eventually
  * be folded together at some point.
  */
@@ -7787,10 +7796,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 				  bool is_null)
 {
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
-	struct bpf_reg_state *regs = state->regs;
+	struct bpf_reg_state *regs = state->regs, *reg;
 	u32 ref_obj_id = regs[regno].ref_obj_id;
 	u32 id = regs[regno].id;
-	int i;
 
 	if (ref_obj_id && ref_obj_id == id && is_null)
 		/* regs[regno] is in the " == NULL" branch.
@@ -7799,8 +7807,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 		 */
 		WARN_ON_ONCE(release_reference_state(state, id));
 
-	for (i = 0; i <= vstate->curframe; i++)
-		__mark_ptr_or_null_regs(vstate->frame[i], id, is_null);
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		mark_ptr_or_null_reg(state, reg, id, is_null);
+	}));
 }
 
 static bool try_match_pkt_pointers(const struct bpf_insn *insn,
@@ -7825,6 +7834,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' > pkt_end, pkt_meta' > pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(other_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7832,6 +7842,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end > pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(this_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7844,6 +7855,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' < pkt_end, pkt_meta' < pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(this_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7851,6 +7863,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end < pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(other_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7863,6 +7876,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' >= pkt_end, pkt_meta' >= pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(other_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7870,6 +7884,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end >= pkt_data', pkt_data >= pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(this_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7882,6 +7897,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' <= pkt_end, pkt_meta' <= pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(this_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7889,6 +7905,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end <= pkt_data', pkt_data <= pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(other_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7905,23 +7922,11 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 {
 	struct bpf_func_state *state;
 	struct bpf_reg_state *reg;
-	int i, j;
-
-	for (i = 0; i <= vstate->curframe; i++) {
-		state = vstate->frame[i];
-		for (j = 0; j < MAX_BPF_REG; j++) {
-			reg = &state->regs[j];
-			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-				*reg = *known_reg;
-		}
 
-		bpf_for_each_spilled_reg(j, state, reg) {
-			if (!reg)
-				continue;
-			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-				*reg = *known_reg;
-		}
-	}
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
+			*reg = *known_reg;
+	}));
 }
 
 static int check_cond_jmp_op(struct bpf_verifier_env *env,
@@ -7988,6 +7993,10 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				       src_reg->var_off.value,
 				       opcode,
 				       is_jmp32);
+	} else if (reg_is_pkt_pointer_any(dst_reg) &&
+		   reg_is_pkt_pointer_any(src_reg) &&
+		   !is_jmp32) {
+		pred = is_pkt_ptr_branch_taken(dst_reg, src_reg, opcode);
 	}
 
 	if (pred >= 0) {
@@ -7996,7 +8005,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		 */
 		if (!__is_pointer_value(false, dst_reg))
 			err = mark_chain_precision(env, insn->dst_reg);
-		if (BPF_SRC(insn->code) == BPF_X && !err)
+		if (BPF_SRC(insn->code) == BPF_X && !err &&
+		    !__is_pointer_value(false, src_reg))
 			err = mark_chain_precision(env, insn->src_reg);
 		if (err)
 			return err;
diff --git a/mm/memremap.c b/mm/memremap.c
index 2455bac89506..299aad0d26e5 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -348,6 +348,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1c95ede2c9a6..cf554e855521 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -451,7 +451,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index ca75d1b8f415..9da8fbc81c04 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -332,6 +332,9 @@ int j1939_send_one(struct j1939_priv *priv, struct sk_buff *skb)
 	/* re-claim the CAN_HDR from the SKB */
 	cf = skb_push(skb, J1939_CAN_HDR);
 
+	/* initialize header structure */
+	memset(cf, 0, J1939_CAN_HDR);
+
 	/* make it a full can frame again */
 	skb_put(skb, J1939_CAN_FTR + (8 - dlc));
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7bdcdad58dc8..06169889b0ca 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3809,23 +3809,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int i = 0;
 	int pos;
 
-	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
-	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
-		/* gso_size is untrusted, and we have a frag_list with a linear
-		 * non head_frag head.
-		 *
-		 * (we assume checking the first list_skb member suffices;
-		 * i.e if either of the list_skb members have non head_frag
-		 * head, then the first one has too).
-		 *
-		 * If head_skb's headlen does not fit requested gso_size, it
-		 * means that the frag_list members do NOT terminate on exact
-		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
-		 * sharing. Therefore we must fallback to copying the frag_list
-		 * skbs; we do so by disabling SG.
-		 */
-		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+	if ((skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY) &&
+	    mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb)) {
+		struct sk_buff *check_skb;
+
+		for (check_skb = list_skb; check_skb; check_skb = check_skb->next) {
+			if (skb_headlen(check_skb) && !check_skb->head_frag) {
+				/* gso_size is untrusted, and we have a frag_list with
+				 * a linear non head_frag item.
+				 *
+				 * If head_skb's headlen does not fit requested gso_size,
+				 * it means that the frag_list members do NOT terminate
+				 * on exact gso_size boundaries. Hence we cannot perform
+				 * skb_frag_t page sharing. Therefore we must fallback to
+				 * copying the frag_list skbs; we do so by disabling SG.
+				 */
+				features &= ~NETIF_F_SG;
+				break;
+			}
+		}
 	}
 
 	__skb_push(head_skb, doffset);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a7127364253c..cc588bc2b11d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3291,7 +3291,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_REPAIR_OPTIONS:
 		if (!tp->repair)
 			err = -EINVAL;
-		else if (sk->sk_state == TCP_ESTABLISHED)
+		else if (sk->sk_state == TCP_ESTABLISHED && !tp->bytes_sent)
 			err = tcp_repair_options_est(sk, optval, optlen);
 		else
 			err = -EPERM;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index eaf2308c355a..809ee0f32d59 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -315,7 +315,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 {
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
-	u32 tosend, delta = 0;
+	u32 tosend, origsize, sent, delta = 0;
 	u32 eval = __SK_NONE;
 	int ret;
 
@@ -370,10 +370,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, msg->sg.size);
+		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
 
+		origsize = msg->sg.size;
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		sent = origsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
 			sock_put(sk_redir);
@@ -412,7 +414,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		    msg->sg.data[msg->sg.start].page_link &&
 		    msg->sg.data[msg->sg.start].length) {
 			if (eval == __SK_REDIRECT)
-				sk_mem_charge(sk, msg->sg.size);
+				sk_mem_charge(sk, tosend - sent);
 			goto more_data;
 		}
 	}
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 8a22486cf270..17ac45aa7194 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
 {
 	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
 	ifal->ifal_family = AF_INET6;
+	ifal->__ifal_reserved = 0;
 	ifal->ifal_prefixlen = prefixlen;
 	ifal->ifal_flags = 0;
 	ifal->ifal_index = ifindex;
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 49e893313652..2d62932b5987 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -877,7 +877,7 @@ static int tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
 	};
 
 	ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-	if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+	if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct tipc_name_table_query))
 		return -EINVAL;
 
 	depth = ntohl(ntq->depth);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fd848609e656..a1e64d967bd3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1064,6 +1064,8 @@ MODULE_FIRMWARE("regulatory.db");
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1073,9 +1075,13 @@ static int query_regdb_file(const char *alpha2)
 	if (!alpha2)
 		return -ENOMEM;
 
-	return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
-				       &reg_pdev->dev, GFP_KERNEL,
-				       (void *)alpha2, regdb_fw_cb);
+	err = request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
+				      &reg_pdev->dev, GFP_KERNEL,
+				      (void *)alpha2, regdb_fw_cb);
+	if (err)
+		kfree(alpha2);
+
+	return err;
 }
 
 int reg_reload_regdb(void)
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 22d169923261..15119c49c093 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1669,7 +1669,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 		if (old == rcu_access_pointer(known->pub.ies))
 			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		cfg80211_update_hidden_bsses(known, new->pub.beacon_ies, old);
+		cfg80211_update_hidden_bsses(known,
+					     rcu_access_pointer(new->pub.beacon_ies),
+					     old);
 
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
index 3bc48c726c41..79ecbbfe37cd 100644
--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -23,6 +23,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index fbd34b8e8f57..7434e9ea926e 100644
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -29,6 +29,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 /*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
diff --git a/sound/hda/hdac_sysfs.c b/sound/hda/hdac_sysfs.c
index e56e83325903..bcf302f5115a 100644
--- a/sound/hda/hdac_sysfs.c
+++ b/sound/hda/hdac_sysfs.c
@@ -346,8 +346,10 @@ static int add_widget_node(struct kobject *parent, hda_nid_t nid,
 		return -ENOMEM;
 	kobject_init(kobj, &widget_ktype);
 	err = kobject_add(kobj, parent, "%02x", nid);
-	if (err < 0)
+	if (err < 0) {
+		kobject_put(kobj);
 		return err;
+	}
 	err = sysfs_create_group(kobj, group);
 	if (err < 0) {
 		kobject_put(kobj);
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 26dfa8558792..494bfd2135a9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2749,6 +2749,9 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE(0x1002, 0xab28),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_DEVICE(0x1002, 0xab30),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index f774b2ac9720..82f14c3f642b 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1272,6 +1272,7 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 60e3bc124836..e3f6b930ad4a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9161,6 +9161,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index a51591f68ae6..6a78813b63f5 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2028,6 +2028,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/* M-Audio Micro */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x201a),
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2030),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 04a691bc560c..752422147fb3 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1744,6 +1744,7 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
+	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 144dc164b759..8fb925676813 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -489,6 +489,11 @@
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -565,9 +570,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 6ebf2b215ef4..eefa2b34e641 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -271,6 +271,9 @@ int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
 	int err;
 	int fd;
 
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
 	fd = get_fd(&argc, &argv);
 	if (fd < 0)
 		return fd;
diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 96fe9c1af336..4688e39de52a 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -203,7 +203,7 @@ static void new_line_csv(struct perf_stat_config *config, void *ctx)
 
 	fputc('\n', os->fh);
 	if (os->prefix)
-		fprintf(os->fh, "%s%s", os->prefix, config->csv_sep);
+		fprintf(os->fh, "%s", os->prefix);
 	aggr_printout(config, os->evsel, os->id, os->nr);
 	for (i = 0; i < os->nfields; i++)
 		fputs(config->csv_sep, os->fh);
