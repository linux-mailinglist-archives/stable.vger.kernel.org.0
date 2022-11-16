Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB262B5F9
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiKPJGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiKPJGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39E2BCB;
        Wed, 16 Nov 2022 01:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C96E3B81C25;
        Wed, 16 Nov 2022 09:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71B3C433C1;
        Wed, 16 Nov 2022 09:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668589576;
        bh=WP4/2KsIMVFQLYxaYe4u7KDXgP1xV9DAvcCu7V8paY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrH2uk/qG6ZMWY2G0V+u+uIYGSGCvWsIRqitU9sVSROGaOwveCCQlsgYX4oQcsrGl
         gtsV3S2BsLybrR5eHYLKjMEPO/MdSaRDi9pU6ehbuoZHDcDvQnWGGMg1wEp9efG1wt
         qvwEZa5Z85Q9UigXeixkSWJ8QVvKsc+Ad7zmiMUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.79
Date:   Wed, 16 Nov 2022 10:06:06 +0100
Message-Id: <1668589565203138@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166858956522698@kroah.com>
References: <166858956522698@kroah.com>
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
index 397dcb7af1c8..e59491ff5e96 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 78
+SUBLEVEL = 79
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e1be6c429810..a908a37f0367 100644
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
@@ -63,19 +79,16 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
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
@@ -102,6 +115,9 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
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
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 03ac3aa611f5..bda3bc294718 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -124,6 +124,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* Kernel thread */
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 7bdbf3f608a4..ef81e9003ab8 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -291,6 +291,7 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
+	early_init_fdt_scan_reserved_mem();
 	misc_mem_init();
 
 	init_resources();
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index f2e065671e4d..84ac0fe612e7 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -30,7 +30,7 @@ obj-y += vdso.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
 
 # Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index a37a08ceeded..830f53b141a0 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -242,7 +242,6 @@ static void __init setup_bootmem(void)
 			memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 	}
 
-	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(dma32_phys_limit);
 	if (IS_ENABLED(CONFIG_64BIT))
 		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b456aa196c04..c61533e1448a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1117,6 +1117,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
 	return 0;
 }
 
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+
 static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_tod_clock gtod;
@@ -1126,7 +1128,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
 		return -EINVAL;
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 
 	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
 		gtod.epoch_idx, gtod.tod);
@@ -1157,7 +1159,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
 			   sizeof(gtod.tod)))
 		return -EFAULT;
 
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
 	return 0;
 }
@@ -1169,6 +1171,16 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -1183,6 +1195,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -ENXIO;
 		break;
 	}
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -3941,13 +3956,6 @@ static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_t
 	preempt_enable();
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
-{
-	mutex_lock(&kvm->lock);
-	__kvm_s390_set_tod_clock(kvm, gtod);
-	mutex_unlock(&kvm->lock);
-}
-
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	if (!mutex_trylock(&kvm->lock))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f8803bf0ff17..a2fde6d69057 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -326,7 +326,6 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 8f38265bc81d..f069ab09c5fc 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -495,6 +495,11 @@
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
@@ -572,9 +577,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8b1bf1c14fc3..c30e32097fb1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -794,8 +794,6 @@ static void init_amd_gh(struct cpuinfo_x86 *c)
 		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 }
 
-#define MSR_AMD64_DE_CFG	0xC0011029
-
 static void init_amd_ln(struct cpuinfo_x86 *c)
 {
 	/*
@@ -990,8 +988,8 @@ static void init_amd(struct cpuinfo_x86 *c)
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
index 21fd425088fe..c393b8773ace 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -326,8 +326,8 @@ static void init_hygon(struct cpuinfo_x86 *c)
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
index 49bb3db2761a..3116d24945c8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2666,9 +2666,9 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
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
@@ -2777,7 +2777,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = 0x1E;
 		}
 		break;
-	case MSR_F10H_DECFG:
+	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
 	default:
@@ -2977,7 +2977,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_VM_IGNNE:
 		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
-	case MSR_F10H_DECFG: {
+	case MSR_AMD64_DE_CFG: {
 		struct kvm_msr_entry msr_entry;
 
 		msr_entry.index = msr->index;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ec2a37ba07e6..7f41e1f9f0b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1464,7 +1464,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
 
-	MSR_F10H_DECFG,
+	MSR_AMD64_DE_CFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 732cb075d707..3c1eadc5a77a 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -519,6 +519,7 @@ static void pm_save_spec_msr(void)
 		MSR_TSX_FORCE_ABORT,
 		MSR_IA32_MCU_OPT_CTRL,
 		MSR_AMD64_LS_CFG,
+		MSR_AMD64_DE_CFG,
 	};
 
 	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 10303611d17b..ef41cb385a0d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3259,6 +3259,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 	case REZERO_UNIT:
 	case SEEK_6:
 	case SEEK_10:
@@ -3925,6 +3926,7 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 		return ata_scsi_write_same_xlat;
 
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
 		break;
@@ -4170,6 +4172,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 	 * turning this into a no-op.
 	 */
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		fallthrough;
 
 	/* no-op's, complete with success */
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 30ae36124b1d..4583a8b5e5bd 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -256,6 +256,8 @@ static void atc_dostart(struct at_dma_chan *atchan, struct at_desc *first)
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);
@@ -316,7 +318,8 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -386,7 +389,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -412,7 +415,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */
@@ -462,18 +465,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
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
@@ -483,42 +474,20 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
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
@@ -527,26 +496,28 @@ static void atc_complete_all(struct at_dma_chan *atchan)
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
 
@@ -558,6 +529,7 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
+	struct at_desc *desc;
 	struct at_desc *child;
 	unsigned long flags;
 
@@ -570,13 +542,12 @@ static void atc_handle_error(struct at_dma_chan *atchan)
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
@@ -691,19 +662,11 @@ static dma_cookie_t atc_tx_submit(struct dma_async_tx_descriptor *tx)
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
 
@@ -1437,11 +1400,8 @@ static int atc_terminate_all(struct dma_chan *chan)
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1460,19 +1420,15 @@ static int atc_terminate_all(struct dma_chan *chan)
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
 
@@ -1527,20 +1483,26 @@ atc_tx_status(struct dma_chan *chan,
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
@@ -1958,7 +1920,11 @@ static int __init at_dma_probe(struct platform_device *pdev)
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
@@ -1978,6 +1944,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
+err_dma_async_device_register:
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->dma_desc_pool);
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 4d1ebc040031..d4d382d74607 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -186,13 +186,13 @@
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
index aa6e552249ab..e613ace79ea8 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -1248,14 +1248,14 @@ static int pxad_init_phys(struct platform_device *op,
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
diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index 4fdd9f06b723..4f1aeb81e9c7 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -299,6 +299,7 @@ struct k3_udma_glue_tx_channel *k3_udma_glue_request_tx_chn(struct device *dev,
 	ret = device_register(&tx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&tx_chn->common.chan_dev);
 		tx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -917,6 +918,7 @@ k3_udma_glue_request_rx_chn_priv(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -1048,6 +1050,7 @@ k3_udma_glue_request_remote_rx_chn(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 4a16e3c257b9..131d98c600ee 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -780,7 +780,7 @@ svm_migrate_to_vram(struct svm_range *prange, uint32_t best_loc,
 static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 {
 	unsigned long addr = vmf->address;
-	struct vm_area_struct *vma;
+	struct svm_range_bo *svm_bo;
 	enum svm_work_list_ops op;
 	struct svm_range *parent;
 	struct svm_range *prange;
@@ -788,24 +788,42 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	struct mm_struct *mm;
 	int r = 0;
 
-	vma = vmf->vma;
-	mm = vma->vm_mm;
+	svm_bo = vmf->page->zone_device_data;
+	if (!svm_bo) {
+		pr_debug("failed get device page at addr 0x%lx\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
+	if (!mmget_not_zero(svm_bo->eviction_fence->mm)) {
+		pr_debug("addr 0x%lx of process mm is detroyed\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
 
-	p = kfd_lookup_process_by_mm(vma->vm_mm);
+	mm = svm_bo->eviction_fence->mm;
+	if (mm != vmf->vma->vm_mm)
+		pr_debug("addr 0x%lx is COW mapping in child process\n", addr);
+
+	p = kfd_lookup_process_by_mm(mm);
 	if (!p) {
 		pr_debug("failed find process at fault address 0x%lx\n", addr);
-		return VM_FAULT_SIGBUS;
+		r = VM_FAULT_SIGBUS;
+		goto out_mmput;
 	}
-	addr >>= PAGE_SHIFT;
+	if (READ_ONCE(p->svms.faulting_task) == current) {
+		pr_debug("skipping ram migration\n");
+		r = 0;
+		goto out_unref_process;
+	}
+
 	pr_debug("CPU page fault svms 0x%p address 0x%lx\n", &p->svms, addr);
+	addr >>= PAGE_SHIFT;
 
 	mutex_lock(&p->svms.lock);
 
 	prange = svm_range_from_addr(&p->svms, addr, &parent);
 	if (!prange) {
-		pr_debug("cannot find svm range at 0x%lx\n", addr);
+		pr_debug("failed get range svms 0x%p addr 0x%lx\n", &p->svms, addr);
 		r = -EFAULT;
-		goto out;
+		goto out_unlock_svms;
 	}
 
 	mutex_lock(&parent->migrate_mutex);
@@ -827,10 +845,10 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 		goto out_unlock_prange;
 	}
 
-	r = svm_migrate_vram_to_ram(prange, mm);
+	r = svm_migrate_vram_to_ram(prange, vmf->vma->vm_mm);
 	if (r)
-		pr_debug("failed %d migrate 0x%p [0x%lx 0x%lx] to ram\n", r,
-			 prange, prange->start, prange->last);
+		pr_debug("failed %d migrate svms 0x%p range 0x%p [0x%lx 0x%lx]\n",
+			 r, prange->svms, prange, prange->start, prange->last);
 
 	/* xnack on, update mapping on GPUs with ACCESS_IN_PLACE */
 	if (p->xnack_enabled && parent == prange)
@@ -844,12 +862,13 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	if (prange != parent)
 		mutex_unlock(&prange->migrate_mutex);
 	mutex_unlock(&parent->migrate_mutex);
-out:
+out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
-	kfd_unref_process(p);
-
+out_unref_process:
 	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
-
+	kfd_unref_process(p);
+out_mmput:
+	mmput(mm);
 	return r ? VM_FAULT_SIGBUS : 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 6d8f9bb2d905..47ec820cae72 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -755,6 +755,7 @@ struct svm_range_list {
 	atomic_t			evicted_ranges;
 	struct delayed_work		restore_work;
 	DECLARE_BITMAP(bitmap_supported, MAX_GPU_INSTANCE);
+	struct task_struct 		*faulting_task;
 };
 
 /* Process data */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 74e6f613be02..22a70aaccf13 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1489,9 +1489,11 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 
 		next = min(vma->vm_end, end);
 		npages = (next - addr) >> PAGE_SHIFT;
+		WRITE_ONCE(p->svms.faulting_task, current);
 		r = amdgpu_hmm_range_get_pages(&prange->notifier, mm, NULL,
 					       addr, npages, &hmm_range,
 					       readonly, true, owner);
+		WRITE_ONCE(p->svms.faulting_task, NULL);
 		if (r) {
 			pr_debug("failed %d to get svm range pages\n", r);
 			goto unreserve_out;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index c71d50e82168..ca6fa133993c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -366,7 +366,9 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		if (((adev->pdev->device == 0x73A1) &&
 		    (adev->pdev->revision == 0x00)) ||
 		    ((adev->pdev->device == 0x73BF) &&
-		    (adev->pdev->revision == 0xCF)))
+		    (adev->pdev->revision == 0xCF)) ||
+		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
 	}
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index afa34111de02..af74c9c37c9c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -34,13 +34,13 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attachme
 		goto err;
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
index d216a1fd057c..099df15e1a61 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -383,7 +383,12 @@ static int __init vc4_drm_register(void)
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
index bbcbdc4327dc..71cec9bfe919 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -25,6 +25,7 @@
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
 #include "cqhci.h"
@@ -1273,7 +1274,7 @@ static void esdhc_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 
 static void esdhc_reset(struct sdhci_host *host, u8 mask)
 {
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
@@ -1654,14 +1655,14 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->mmc->caps2 |= MMC_CAP2_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 737e2bfdedc2..bede148db732 100644
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
index 829a8bf7c77d..fff9fb8d6bac 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -24,6 +24,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/ktime.h>
 
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "cqhci.h"
 
@@ -363,7 +364,7 @@ static void tegra_sdhci_reset(struct sdhci_host *host, u8 mask)
 	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
 	u32 misc_ctrl, clk_ctrl, pad_ctrl;
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (!(mask & SDHCI_RESET_ALL))
 		return;
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index a3e62e212631..9661e010df89 100644
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
index 56e0fb07aec7..1cd3c289f49b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -77,7 +77,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if ARCH_BCM2835
+	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a6ca7ba5276c..db1864a3f64a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12605,8 +12605,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
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
index 0f276ce2d1eb..586311a271f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -132,7 +132,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	}
 
 reset_coalesce:
-	if (netif_running(dev)) {
+	if (test_bit(BNXT_STATE_OPEN, &bp->state)) {
 		if (update_stats) {
 			rc = bnxt_close_nic(bp, true, false);
 			if (!rc)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 38e47703f9ab..07568aa15873 100644
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
index 49b76fd47daa..464c2b365721 100644
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
index 39ae965cd4f6..b0c756b65cc2 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -882,12 +882,21 @@ static int mac_probe(struct platform_device *_of_dev)
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
index 90fd5588e20d..fc67e9d31f6d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2477,6 +2477,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 	for (i = 0; i < mp->rxq_count; i++)
 		rxq_deinit(mp->rxq + i);
 out:
+	napi_disable(&mp->napi);
 	free_irq(dev->irq, dev);
 
 	return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 7cf24dd5c878..e14624caddc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1013,6 +1013,9 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
 			return err;
 	}
 
+	pfvf->cq_op_addr = (__force u64 *)otx2_get_regaddr(pfvf,
+							   NIX_LF_CQ_OP_STATUS);
+
 	/* Initialize work queue for receive buffer refill */
 	pfvf->refill_wrk = devm_kcalloc(pfvf->dev, pfvf->qset.cq_cnt,
 					sizeof(struct refill_work), GFP_KERNEL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4ecd0ef05f3b..095e5de78c0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -337,6 +337,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 	u64			flags;
+	u64			*cq_op_addr;
 
 	struct otx2_qset	qset;
 	struct otx2_hw		hw;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index b1894d4045b8..ab291c2c3014 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -13,6 +13,7 @@
 #include <linux/if_vlan.h>
 #include <linux/iommu.h>
 #include <net/ip.h>
+#include <linux/bitfield.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -1153,6 +1154,59 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 }
 EXPORT_SYMBOL(otx2_set_real_num_queues);
 
+static char *nix_sqoperr_e_str[NIX_SQOPERR_MAX] = {
+	"NIX_SQOPERR_OOR",
+	"NIX_SQOPERR_CTX_FAULT",
+	"NIX_SQOPERR_CTX_POISON",
+	"NIX_SQOPERR_DISABLED",
+	"NIX_SQOPERR_SIZE_ERR",
+	"NIX_SQOPERR_OFLOW",
+	"NIX_SQOPERR_SQB_NULL",
+	"NIX_SQOPERR_SQB_FAULT",
+	"NIX_SQOPERR_SQE_SZ_ZERO",
+};
+
+static char *nix_mnqerr_e_str[NIX_MNQERR_MAX] = {
+	"NIX_MNQERR_SQ_CTX_FAULT",
+	"NIX_MNQERR_SQ_CTX_POISON",
+	"NIX_MNQERR_SQB_FAULT",
+	"NIX_MNQERR_SQB_POISON",
+	"NIX_MNQERR_TOTAL_ERR",
+	"NIX_MNQERR_LSO_ERR",
+	"NIX_MNQERR_CQ_QUERY_ERR",
+	"NIX_MNQERR_MAX_SQE_SIZE_ERR",
+	"NIX_MNQERR_MAXLEN_ERR",
+	"NIX_MNQERR_SQE_SIZEM1_ZERO",
+};
+
+static char *nix_snd_status_e_str[NIX_SND_STATUS_MAX] =  {
+	"NIX_SND_STATUS_GOOD",
+	"NIX_SND_STATUS_SQ_CTX_FAULT",
+	"NIX_SND_STATUS_SQ_CTX_POISON",
+	"NIX_SND_STATUS_SQB_FAULT",
+	"NIX_SND_STATUS_SQB_POISON",
+	"NIX_SND_STATUS_HDR_ERR",
+	"NIX_SND_STATUS_EXT_ERR",
+	"NIX_SND_STATUS_JUMP_FAULT",
+	"NIX_SND_STATUS_JUMP_POISON",
+	"NIX_SND_STATUS_CRC_ERR",
+	"NIX_SND_STATUS_IMM_ERR",
+	"NIX_SND_STATUS_SG_ERR",
+	"NIX_SND_STATUS_MEM_ERR",
+	"NIX_SND_STATUS_INVALID_SUBDC",
+	"NIX_SND_STATUS_SUBDC_ORDER_ERR",
+	"NIX_SND_STATUS_DATA_FAULT",
+	"NIX_SND_STATUS_DATA_POISON",
+	"NIX_SND_STATUS_NPC_DROP_ACTION",
+	"NIX_SND_STATUS_LOCK_VIOL",
+	"NIX_SND_STATUS_NPC_UCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_ABORT",
+	"NIX_SND_STATUS_NPC_VTAG_PTR_ERR",
+	"NIX_SND_STATUS_NPC_VTAG_SIZE_ERR",
+	"NIX_SND_STATUS_SEND_STATS_ERR",
+};
+
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 {
 	struct otx2_nic *pf = data;
@@ -1186,46 +1240,67 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 
 	/* SQ */
 	for (qidx = 0; qidx < pf->hw.tx_queues; qidx++) {
+		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
+		u8 sq_op_err_code, mnq_err_code, snd_err_code;
+
+		/* Below debug registers captures first errors corresponding to
+		 * those registers. We don't have to check against SQ qid as
+		 * these are fatal errors.
+		 */
+
 		ptr = otx2_get_regaddr(pf, NIX_LF_SQ_OP_INT);
 		val = otx2_atomic64_add((qidx << 44), ptr);
 		otx2_write64(pf, NIX_LF_SQ_OP_INT, (qidx << 44) |
 			     (val & NIX_SQINT_BITS));
 
-		if (!(val & (NIX_SQINT_BITS | BIT_ULL(42))))
-			continue;
-
 		if (val & BIT_ULL(42)) {
 			netdev_err(pf->netdev, "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
 				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
-		} else {
-			if (val & BIT_ULL(NIX_SQINT_LMT_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: LMT store error NIX_LF_SQ_OP_ERR_DBG:0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SQ_OP_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_MNQ_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Meta-descriptor enqueue error NIX_LF_MNQ_ERR_DGB:0x%llx\n",
-					   qidx,
-					   otx2_read64(pf, NIX_LF_MNQ_ERR_DBG));
-				otx2_write64(pf, NIX_LF_MNQ_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SEND_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Send error, NIX_LF_SEND_ERR_DBG 0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SEND_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SEND_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
-				netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
-					   qidx);
+			goto done;
 		}
 
+		sq_op_err_dbg = otx2_read64(pf, NIX_LF_SQ_OP_ERR_DBG);
+		if (!(sq_op_err_dbg & BIT(44)))
+			goto chk_mnq_err_dbg;
+
+		sq_op_err_code = FIELD_GET(GENMASK(7, 0), sq_op_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_SQ_OP_ERR_DBG(%llx)  err=%s\n",
+			   qidx, sq_op_err_dbg, nix_sqoperr_e_str[sq_op_err_code]);
+
+		otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG, BIT_ULL(44));
+
+		if (sq_op_err_code == NIX_SQOPERR_SQB_NULL)
+			goto chk_mnq_err_dbg;
+
+		/* Err is not NIX_SQOPERR_SQB_NULL, call aq function to read SQ structure.
+		 * TODO: But we are in irq context. How to call mbox functions which does sleep
+		 */
+
+chk_mnq_err_dbg:
+		mnq_err_dbg = otx2_read64(pf, NIX_LF_MNQ_ERR_DBG);
+		if (!(mnq_err_dbg & BIT(44)))
+			goto chk_snd_err_dbg;
+
+		mnq_err_code = FIELD_GET(GENMASK(7, 0), mnq_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_MNQ_ERR_DBG(%llx)  err=%s\n",
+			   qidx, mnq_err_dbg,  nix_mnqerr_e_str[mnq_err_code]);
+		otx2_write64(pf, NIX_LF_MNQ_ERR_DBG, BIT_ULL(44));
+
+chk_snd_err_dbg:
+		snd_err_dbg = otx2_read64(pf, NIX_LF_SEND_ERR_DBG);
+		if (snd_err_dbg & BIT(44)) {
+			snd_err_code = FIELD_GET(GENMASK(7, 0), snd_err_dbg);
+			netdev_err(pf->netdev, "SQ%lld: NIX_LF_SND_ERR_DBG:0x%llx err=%s\n",
+				   qidx, snd_err_dbg, nix_snd_status_e_str[snd_err_code]);
+			otx2_write64(pf, NIX_LF_SEND_ERR_DBG, BIT_ULL(44));
+		}
+
+done:
+		/* Print values and reset */
+		if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
+			netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
+				   qidx);
+
 		schedule_work(&pf->reset_task);
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 4bbd12ff26e6..e5f30fd778fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -274,4 +274,61 @@ enum nix_sqint_e {
 			BIT_ULL(NIX_SQINT_SEND_ERR) | \
 			BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
 
+enum nix_sqoperr_e {
+	NIX_SQOPERR_OOR = 0,
+	NIX_SQOPERR_CTX_FAULT = 1,
+	NIX_SQOPERR_CTX_POISON = 2,
+	NIX_SQOPERR_DISABLED = 3,
+	NIX_SQOPERR_SIZE_ERR = 4,
+	NIX_SQOPERR_OFLOW = 5,
+	NIX_SQOPERR_SQB_NULL = 6,
+	NIX_SQOPERR_SQB_FAULT = 7,
+	NIX_SQOPERR_SQE_SZ_ZERO = 8,
+	NIX_SQOPERR_MAX,
+};
+
+enum nix_mnqerr_e {
+	NIX_MNQERR_SQ_CTX_FAULT = 0,
+	NIX_MNQERR_SQ_CTX_POISON = 1,
+	NIX_MNQERR_SQB_FAULT = 2,
+	NIX_MNQERR_SQB_POISON = 3,
+	NIX_MNQERR_TOTAL_ERR = 4,
+	NIX_MNQERR_LSO_ERR = 5,
+	NIX_MNQERR_CQ_QUERY_ERR = 6,
+	NIX_MNQERR_MAX_SQE_SIZE_ERR = 7,
+	NIX_MNQERR_MAXLEN_ERR = 8,
+	NIX_MNQERR_SQE_SIZEM1_ZERO = 9,
+	NIX_MNQERR_MAX,
+};
+
+enum nix_snd_status_e {
+	NIX_SND_STATUS_GOOD = 0x0,
+	NIX_SND_STATUS_SQ_CTX_FAULT = 0x1,
+	NIX_SND_STATUS_SQ_CTX_POISON = 0x2,
+	NIX_SND_STATUS_SQB_FAULT = 0x3,
+	NIX_SND_STATUS_SQB_POISON = 0x4,
+	NIX_SND_STATUS_HDR_ERR = 0x5,
+	NIX_SND_STATUS_EXT_ERR = 0x6,
+	NIX_SND_STATUS_JUMP_FAULT = 0x7,
+	NIX_SND_STATUS_JUMP_POISON = 0x8,
+	NIX_SND_STATUS_CRC_ERR = 0x9,
+	NIX_SND_STATUS_IMM_ERR = 0x10,
+	NIX_SND_STATUS_SG_ERR = 0x11,
+	NIX_SND_STATUS_MEM_ERR = 0x12,
+	NIX_SND_STATUS_INVALID_SUBDC = 0x13,
+	NIX_SND_STATUS_SUBDC_ORDER_ERR = 0x14,
+	NIX_SND_STATUS_DATA_FAULT = 0x15,
+	NIX_SND_STATUS_DATA_POISON = 0x16,
+	NIX_SND_STATUS_NPC_DROP_ACTION = 0x17,
+	NIX_SND_STATUS_LOCK_VIOL = 0x18,
+	NIX_SND_STATUS_NPC_UCAST_CHAN_ERR = 0x19,
+	NIX_SND_STATUS_NPC_MCAST_CHAN_ERR = 0x20,
+	NIX_SND_STATUS_NPC_MCAST_ABORT = 0x21,
+	NIX_SND_STATUS_NPC_VTAG_PTR_ERR = 0x22,
+	NIX_SND_STATUS_NPC_VTAG_SIZE_ERR = 0x23,
+	NIX_SND_STATUS_SEND_MEM_FAULT = 0x24,
+	NIX_SND_STATUS_SEND_STATS_ERR = 0x25,
+	NIX_SND_STATUS_MAX,
+};
+
 #endif /* OTX2_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f42b1d4e0c67..3f3ec8ffc4dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -18,6 +18,31 @@
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
 
+static int otx2_nix_cq_op_status(struct otx2_nic *pfvf,
+				 struct otx2_cq_queue *cq)
+{
+	u64 incr = (u64)(cq->cq_idx) << 32;
+	u64 status;
+
+	status = otx2_atomic64_fetch_add(incr, pfvf->cq_op_addr);
+
+	if (unlikely(status & BIT_ULL(CQ_OP_STAT_OP_ERR) ||
+		     status & BIT_ULL(CQ_OP_STAT_CQ_ERR))) {
+		dev_err(pfvf->dev, "CQ stopped due to error");
+		return -EINVAL;
+	}
+
+	cq->cq_tail = status & 0xFFFFF;
+	cq->cq_head = (status >> 20) & 0xFFFFF;
+	if (cq->cq_tail < cq->cq_head)
+		cq->pend_cqe = (cq->cqe_cnt - cq->cq_head) +
+				cq->cq_tail;
+	else
+		cq->pend_cqe = cq->cq_tail - cq->cq_head;
+
+	return 0;
+}
+
 static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
 {
 	struct nix_cqe_hdr_s *cqe_hdr;
@@ -318,7 +343,14 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
 		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
 		    !cqe->sg.seg_addr) {
@@ -334,6 +366,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		cqe->sg.seg_addr = 0x00;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -368,7 +401,14 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
 		if (unlikely(!cqe)) {
 			if (!processed_cqe)
@@ -380,6 +420,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -936,10 +977,16 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	int processed_cqe = 0;
 	u64 iova, pa;
 
-	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
-		if (!cqe->sg.subdc)
-			continue;
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
 		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		if (cqe->sg.segs > 1) {
 			otx2_free_rcv_seg(pfvf, cqe, cq->cq_idx);
 			continue;
@@ -965,7 +1012,16 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 
 	sq = &pfvf->qset.sq[cq->cint_idx];
 
-	while ((cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq))) {
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
+		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		sg = &sq->sg[cqe->comp.sqe_id];
 		skb = (struct sk_buff *)sg->skb;
 		if (skb) {
@@ -973,7 +1029,6 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 			dev_kfree_skb_any(skb);
 			sg->skb = (u64)NULL;
 		}
-		processed_cqe++;
 	}
 
 	/* Free CQEs to HW */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 3ff1ad79c001..6a97631ff226 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -56,6 +56,9 @@
  */
 #define CQ_QCOUNT_DEFAULT	1
 
+#define CQ_OP_STAT_OP_ERR       63
+#define CQ_OP_STAT_CQ_ERR       46
+
 struct queue_stats {
 	u64	bytes;
 	u64	pkts;
@@ -122,6 +125,8 @@ struct otx2_cq_queue {
 	u16			pool_ptrs;
 	u32			cqe_cnt;
 	u32			cq_head;
+	u32			cq_tail;
+	u32			pend_cqe;
 	void			*cqe_base;
 	struct qmem		*cqe;
 	struct otx2_pool	*rbpool;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 73d2eba5262f..a47aa624f745 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -776,6 +776,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
 int prestera_rxtx_switch_init(struct prestera_switch *sw)
 {
 	struct prestera_rxtx *rxtx;
+	int err;
 
 	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
 	if (!rxtx)
@@ -783,7 +784,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
 
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
index 8a3100f32d3b..98ca5d1ed45d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1699,12 +1699,17 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 48dc121b2cb4..8e7177d4539e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -164,6 +164,36 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	return err;
 }
 
+static int
+mlx5_esw_bridge_changeupper_validate_netdev(void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct net_device *upper = info->upper_dev;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(upper) || !netif_is_lag_master(dev))
+		return 0;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		struct mlx5_core_dev *mdev;
+		struct mlx5e_priv *priv;
+
+		if (!mlx5e_eswitch_rep(lower))
+			continue;
+
+		priv = netdev_priv(lower);
+		mdev = priv->mdev;
+		if (!mlx5_lag_is_active(mdev))
+			return -EAGAIN;
+		if (!mlx5_lag_is_shared_fdb(mdev))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 						unsigned long event, void *ptr)
 {
@@ -171,6 +201,7 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		err = mlx5_esw_bridge_changeupper_validate_netdev(ptr);
 		break;
 
 	case NETDEV_CHANGEUPPER:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index b45954905845..8f86b62e49e3 100644
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
index 3b6b2e61139e..f4703f53bcdc 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7125,9 +7125,8 @@ static int s2io_card_up(struct s2io_nic *sp)
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
@@ -7165,18 +7164,16 @@ static int s2io_card_up(struct s2io_nic *sp)
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
@@ -7196,6 +7193,20 @@ static int s2io_card_up(struct s2io_nic *sp)
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
index 346145d3180e..057b7419404d 100644
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
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index b32f1f5d841f..fb9ff4ce9453 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -593,7 +593,6 @@ static int ehl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
-	plat->clk_ptp_rate = 200000000;
 	plat->use_phy_wol = 1;
 
 	plat->safety_feat_cfg->tsoee = 1;
@@ -618,6 +617,8 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -631,6 +632,8 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -647,6 +650,8 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 	plat->bus_id = 2;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -686,6 +691,8 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 	plat->bus_id = 3;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -721,7 +728,8 @@ static int tgl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
-	plat->clk_ptp_rate = 200000000;
+	plat->clk_ptp_rate = 204800000;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 
 	plat->safety_feat_cfg->tsoee = 1;
 	plat->safety_feat_cfg->mrxpee = 0;
@@ -741,7 +749,6 @@ static int tgl_sgmii_phy0_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
@@ -756,7 +763,6 @@ static int tgl_sgmii_phy1_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 2;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 220bb454626c..2ae59f94afe1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -75,20 +75,24 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-		if (!plat->mdio_bus_data)
-			return -ENOMEM;
+		if (!plat->mdio_bus_data) {
+			ret = -ENOMEM;
+			goto err_put_node;
+		}
 		plat->mdio_bus_data->needs_reset = true;
 	}
 
 	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg), GFP_KERNEL);
-	if (!plat->dma_cfg)
-		return -ENOMEM;
+	if (!plat->dma_cfg) {
+		ret = -ENOMEM;
+		goto err_put_node;
+	}
 
 	/* Enable pci device */
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", __func__);
-		return ret;
+		goto err_put_node;
 	}
 
 	/* Get the base address of device */
@@ -97,7 +101,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
 		if (ret)
-			return ret;
+			goto err_disable_device;
 		break;
 	}
 
@@ -108,7 +112,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	phy_mode = device_get_phy_mode(&pdev->dev);
 	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
-		return phy_mode;
+		ret = phy_mode;
+		goto err_disable_device;
 	}
 
 	plat->phy_interface = phy_mode;
@@ -125,6 +130,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.irq < 0) {
 		dev_err(&pdev->dev, "IRQ macirq not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
 	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
@@ -137,15 +143,31 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.lpi_irq < 0) {
 		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret)
+		goto err_disable_msi;
+
+	return ret;
+
+err_disable_msi:
+	pci_disable_msi(pdev);
+err_disable_device:
+	pci_disable_device(pdev);
+err_put_node:
+	of_node_put(plat->mdio_node);
+	return ret;
 }
 
 static void loongson_dwmac_remove(struct pci_dev *pdev)
 {
+	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
+	of_node_put(priv->plat->mdio_node);
 	stmmac_dvr_remove(&pdev->dev);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
@@ -155,6 +177,7 @@ static void loongson_dwmac_remove(struct pci_dev *pdev)
 		break;
 	}
 
+	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c7a6588d9398..e8b507f88fbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -272,11 +272,9 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
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
 
 static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index e226ecd95a2c..ca587fe28150 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -856,6 +856,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index cf0917b29e30..f175c098698d 100644
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
index d967b0748773..027b04795421 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -534,7 +534,7 @@ static int bpq_device_event(struct notifier_block *this,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !bpq_get_ax25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 71700f279278..4811bd1f3d74 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1386,7 +1386,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+					 bool active)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1410,7 +1411,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
-	rx_sc->active = true;
+	rx_sc->active = active;
 	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
@@ -1819,6 +1820,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -1863,7 +1865,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
-	bool was_active;
+	bool active = true;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1885,16 +1887,15 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
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
@@ -1918,7 +1919,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	rx_sc->active = was_active;
+	del_rx_sc(secy, sci);
+	free_rx_sc(rx_sc);
 	rtnl_unlock();
 	return ret;
 }
@@ -2061,6 +2063,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -2557,7 +2560,7 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	int i;
 
-	if (secy->n_rx_sc > 0)
+	if (secy->rx_sc)
 		return true;
 
 	for (i = 0; i < MACSEC_NUM_AN; i++)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6363459ba1d0..cdc238dda1e1 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1521,8 +1521,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
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
index 9909f430d723..575077998d8a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1949,17 +1949,25 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
+			WARN_ON_ONCE(1);
+			err = -ENOMEM;
 			atomic_long_inc(&tun->dev->rx_dropped);
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
index 89d31adc3809..5037ef82be46 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -325,6 +325,7 @@ static int lapbeth_open(struct net_device *dev)
 
 	err = lapb_register(dev, &lapbeth_callbacks);
 	if (err != LAPB_OK) {
+		napi_disable(&lapbeth->napi);
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
 	}
@@ -446,7 +447,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index f793324ad0b7..562ecfd50742 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -247,11 +247,7 @@ int ath11k_regd_update(struct ath11k *ar)
 		goto err;
 	}
 
-	rtnl_lock();
-	wiphy_lock(ar->hw->wiphy);
-	ret = regulatory_set_wiphy_regd_sync(ar->hw->wiphy, regd_copy);
-	wiphy_unlock(ar->hw->wiphy);
-	rtnl_unlock();
+	ret = regulatory_set_wiphy_regd(ar->hw->wiphy, regd_copy);
 
 	kfree(regd_copy);
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 2fe88b8be348..01df23835be0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -232,6 +232,7 @@ static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
  */
 static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 {
+	enum ipc_pcie_sleep_state sleep_state = IPC_PCIE_D0L12;
 	union acpi_object *object;
 	acpi_handle handle_acpi;
 
@@ -242,12 +243,16 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	}
 
 	object = acpi_evaluate_dsm(handle_acpi, &wwan_acpi_guid, 0, 3, NULL);
+	if (!object)
+		goto default_ret;
+
+	if (object->integer.value == 3)
+		sleep_state = IPC_PCIE_D3L2;
 
-	if (object && object->integer.value == 3)
-		return IPC_PCIE_D3L2;
+	kfree(object);
 
 default_ret:
-	return IPC_PCIE_D0L12;
+	return sleep_state;
 }
 
 static int ipc_pcie_probe(struct pci_dev *pci,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 92f064a8f837..3449f877e19f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -167,6 +167,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->max_mtu = ETH_MAX_MTU;
 
 	iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	iosm_dev->needs_free_netdev = true;
 
 	iosm_dev->netdev_ops = &ipc_inm_ops;
 }
diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 6872782e8dd8..ef70bb7c88ad 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -582,6 +582,7 @@ static void mhi_mbim_setup(struct net_device *ndev)
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = MHI_MAX_BUF_SZ - ndev->needed_headroom;
 	ndev->tx_queue_len = 1000;
+	ndev->needs_free_netdev = true;
 }
 
 static const struct wwan_ops mhi_mbim_wwan_ops = {
diff --git a/drivers/phy/ralink/phy-mt7621-pci.c b/drivers/phy/ralink/phy-mt7621-pci.c
index 5e6530f545b5..85888ab2d307 100644
--- a/drivers/phy/ralink/phy-mt7621-pci.c
+++ b/drivers/phy/ralink/phy-mt7621-pci.c
@@ -280,7 +280,8 @@ static struct phy *mt7621_pcie_phy_of_xlate(struct device *dev,
 }
 
 static const struct soc_device_attribute mt7621_pci_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static const struct regmap_config mt7621_pci_phy_regmap_config = {
diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index cd0747ab6267..27f7e2292cf0 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -532,6 +532,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(child, "reg", &index);
 		if (ret || index > usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
+			if (!ret)
+				ret = -EINVAL;
 			goto put_child;
 		}
 
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 1cd168e32810..5a3a3cd89214 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -984,8 +984,16 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
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
 
 	thermal_profile_setup();
 
diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 1ce6f948e9a4..f88c5d451f09 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -315,6 +315,9 @@ static int qcom_swrm_cmd_fifo_wr_cmd(struct qcom_swrm_ctrl *swrm, u8 cmd_data,
 	if (swrm_wait_for_wr_fifo_avail(swrm))
 		return SDW_CMD_FAIL_OTHER;
 
+	if (cmd_id == SWR_BROADCAST_CMD_ID)
+		reinit_completion(&swrm->broadcast);
+
 	/* Its assumed that write is okay as we do not get any status back */
 	swrm->reg_write(swrm, SWRM_CMD_FIFO_WR_CMD, val);
 
@@ -348,6 +351,12 @@ static int qcom_swrm_cmd_fifo_rd_cmd(struct qcom_swrm_ctrl *swrm,
 
 	val = swrm_get_packed_reg_val(&swrm->rcmd_id, len, dev_addr, reg_addr);
 
+	/*
+	 * Check for outstanding cmd wrt. write fifo depth to avoid
+	 * overflow as read will also increase write fifo cnt.
+	 */
+	swrm_wait_for_wr_fifo_avail(swrm);
+
 	/* wait for FIFO RD to complete to avoid overflow */
 	usleep_range(100, 105);
 	swrm->reg_write(swrm, SWRM_CMD_FIFO_RD_CMD, val);
diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
index 564e2f42cebd..299712accfe9 100644
--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -85,11 +85,12 @@ static int tb_path_find_src_hopid(struct tb_port *src,
  * @dst_hopid: HopID to the @dst (%-1 if don't care)
  * @last: Last port is filled here if not %NULL
  * @name: Name of the path
+ * @alloc_hopid: Allocate HopIDs for the ports
  *
  * Follows a path starting from @src and @src_hopid to the last output
- * port of the path. Allocates HopIDs for the visited ports. Call
- * tb_path_free() to release the path and allocated HopIDs when the path
- * is not needed anymore.
+ * port of the path. Allocates HopIDs for the visited ports (if
+ * @alloc_hopid is true). Call tb_path_free() to release the path and
+ * allocated HopIDs when the path is not needed anymore.
  *
  * Note function discovers also incomplete paths so caller should check
  * that the @dst port is the expected one. If it is not, the path can be
@@ -99,7 +100,8 @@ static int tb_path_find_src_hopid(struct tb_port *src,
  */
 struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 				 struct tb_port *dst, int dst_hopid,
-				 struct tb_port **last, const char *name)
+				 struct tb_port **last, const char *name,
+				 bool alloc_hopid)
 {
 	struct tb_port *out_port;
 	struct tb_regs_hop hop;
@@ -156,6 +158,7 @@ struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 	path->tb = src->sw->tb;
 	path->path_length = num_hops;
 	path->activated = true;
+	path->alloc_hopid = alloc_hopid;
 
 	path->hops = kcalloc(num_hops, sizeof(*path->hops), GFP_KERNEL);
 	if (!path->hops) {
@@ -177,13 +180,14 @@ struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 			goto err;
 		}
 
-		if (tb_port_alloc_in_hopid(p, h, h) < 0)
+		if (alloc_hopid && tb_port_alloc_in_hopid(p, h, h) < 0)
 			goto err;
 
 		out_port = &sw->ports[hop.out_port];
 		next_hop = hop.next_hop;
 
-		if (tb_port_alloc_out_hopid(out_port, next_hop, next_hop) < 0) {
+		if (alloc_hopid &&
+		    tb_port_alloc_out_hopid(out_port, next_hop, next_hop) < 0) {
 			tb_port_release_in_hopid(p, h);
 			goto err;
 		}
@@ -263,6 +267,8 @@ struct tb_path *tb_path_alloc(struct tb *tb, struct tb_port *src, int src_hopid,
 		return NULL;
 	}
 
+	path->alloc_hopid = true;
+
 	in_hopid = src_hopid;
 	out_port = NULL;
 
@@ -345,17 +351,19 @@ struct tb_path *tb_path_alloc(struct tb *tb, struct tb_port *src, int src_hopid,
  */
 void tb_path_free(struct tb_path *path)
 {
-	int i;
-
-	for (i = 0; i < path->path_length; i++) {
-		const struct tb_path_hop *hop = &path->hops[i];
-
-		if (hop->in_port)
-			tb_port_release_in_hopid(hop->in_port,
-						 hop->in_hop_index);
-		if (hop->out_port)
-			tb_port_release_out_hopid(hop->out_port,
-						  hop->next_hop_index);
+	if (path->alloc_hopid) {
+		int i;
+
+		for (i = 0; i < path->path_length; i++) {
+			const struct tb_path_hop *hop = &path->hops[i];
+
+			if (hop->in_port)
+				tb_port_release_in_hopid(hop->in_port,
+							 hop->in_hop_index);
+			if (hop->out_port)
+				tb_port_release_out_hopid(hop->out_port,
+							  hop->next_hop_index);
+		}
 	}
 
 	kfree(path->hops);
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index b805b6939794..0c3e1d14cddc 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -105,10 +105,37 @@ static void tb_remove_dp_resources(struct tb_switch *sw)
 	}
 }
 
-static void tb_discover_tunnels(struct tb_switch *sw)
+static void tb_discover_dp_resource(struct tb *tb, struct tb_port *port)
+{
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_port *p;
+
+	list_for_each_entry(p, &tcm->dp_resources, list) {
+		if (p == port)
+			return;
+	}
+
+	tb_port_dbg(port, "DP %s resource available discovered\n",
+		    tb_port_is_dpin(port) ? "IN" : "OUT");
+	list_add_tail(&port->list, &tcm->dp_resources);
+}
+
+static void tb_discover_dp_resources(struct tb *tb)
 {
-	struct tb *tb = sw->tb;
 	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_tunnel *tunnel;
+
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
+		if (tb_tunnel_is_dp(tunnel))
+			tb_discover_dp_resource(tb, tunnel->dst_port);
+	}
+}
+
+static void tb_switch_discover_tunnels(struct tb_switch *sw,
+				       struct list_head *list,
+				       bool alloc_hopids)
+{
+	struct tb *tb = sw->tb;
 	struct tb_port *port;
 
 	tb_switch_for_each_port(sw, port) {
@@ -116,24 +143,41 @@ static void tb_discover_tunnels(struct tb_switch *sw)
 
 		switch (port->config.type) {
 		case TB_TYPE_DP_HDMI_IN:
-			tunnel = tb_tunnel_discover_dp(tb, port);
+			tunnel = tb_tunnel_discover_dp(tb, port, alloc_hopids);
 			break;
 
 		case TB_TYPE_PCIE_DOWN:
-			tunnel = tb_tunnel_discover_pci(tb, port);
+			tunnel = tb_tunnel_discover_pci(tb, port, alloc_hopids);
 			break;
 
 		case TB_TYPE_USB3_DOWN:
-			tunnel = tb_tunnel_discover_usb3(tb, port);
+			tunnel = tb_tunnel_discover_usb3(tb, port, alloc_hopids);
 			break;
 
 		default:
 			break;
 		}
 
-		if (!tunnel)
-			continue;
+		if (tunnel)
+			list_add_tail(&tunnel->list, list);
+	}
+
+	tb_switch_for_each_port(sw, port) {
+		if (tb_port_has_remote(port)) {
+			tb_switch_discover_tunnels(port->remote->sw, list,
+						   alloc_hopids);
+		}
+	}
+}
 
+static void tb_discover_tunnels(struct tb *tb)
+{
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_tunnel *tunnel;
+
+	tb_switch_discover_tunnels(tb->root_switch, &tcm->tunnel_list, true);
+
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
 		if (tb_tunnel_is_pci(tunnel)) {
 			struct tb_switch *parent = tunnel->dst_port->sw;
 
@@ -146,13 +190,6 @@ static void tb_discover_tunnels(struct tb_switch *sw)
 			pm_runtime_get_sync(&tunnel->src_port->sw->dev);
 			pm_runtime_get_sync(&tunnel->dst_port->sw->dev);
 		}
-
-		list_add_tail(&tunnel->list, &tcm->tunnel_list);
-	}
-
-	tb_switch_for_each_port(sw, port) {
-		if (tb_port_has_remote(port))
-			tb_discover_tunnels(port->remote->sw);
 	}
 }
 
@@ -1384,7 +1421,9 @@ static int tb_start(struct tb *tb)
 	/* Full scan to discover devices added before the driver was loaded. */
 	tb_scan_switch(tb->root_switch);
 	/* Find out tunnels created by the boot firmware */
-	tb_discover_tunnels(tb->root_switch);
+	tb_discover_tunnels(tb);
+	/* Add DP resources from the DP tunnels created by the boot firmware */
+	tb_discover_dp_resources(tb);
 	/*
 	 * If the boot firmware did not create USB 3.x tunnels create them
 	 * now for the whole topology.
@@ -1444,6 +1483,8 @@ static int tb_resume_noirq(struct tb *tb)
 {
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_tunnel *tunnel, *n;
+	unsigned int usb3_delay = 0;
+	LIST_HEAD(tunnels);
 
 	tb_dbg(tb, "resuming...\n");
 
@@ -1454,8 +1495,31 @@ static int tb_resume_noirq(struct tb *tb)
 	tb_free_invalid_tunnels(tb);
 	tb_free_unplugged_children(tb->root_switch);
 	tb_restore_children(tb->root_switch);
-	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
+
+	/*
+	 * If we get here from suspend to disk the boot firmware or the
+	 * restore kernel might have created tunnels of its own. Since
+	 * we cannot be sure they are usable for us we find and tear
+	 * them down.
+	 */
+	tb_switch_discover_tunnels(tb->root_switch, &tunnels, false);
+	list_for_each_entry_safe_reverse(tunnel, n, &tunnels, list) {
+		if (tb_tunnel_is_usb3(tunnel))
+			usb3_delay = 500;
+		tb_tunnel_deactivate(tunnel);
+		tb_tunnel_free(tunnel);
+	}
+
+	/* Re-create our tunnels now */
+	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list) {
+		/* USB3 requires delay before it can be re-activated */
+		if (tb_tunnel_is_usb3(tunnel)) {
+			msleep(usb3_delay);
+			/* Only need to do it once */
+			usb3_delay = 0;
+		}
 		tb_tunnel_restart(tunnel);
+	}
 	if (!list_empty(&tcm->tunnel_list)) {
 		/*
 		 * the pcie links need some time to get going.
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index b535d296d37e..8922217d580c 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -354,6 +354,7 @@ enum tb_path_port {
  *	      when deactivating this path
  * @hops: Path hops
  * @path_length: How many hops the path uses
+ * @alloc_hopid: Does this path consume port HopID
  *
  * A path consists of a number of hops (see &struct tb_path_hop). To
  * establish a PCIe tunnel two paths have to be created between the two
@@ -374,6 +375,7 @@ struct tb_path {
 	bool clear_fc;
 	struct tb_path_hop *hops;
 	int path_length;
+	bool alloc_hopid;
 };
 
 /* HopIDs 0-7 are reserved by the Thunderbolt protocol */
@@ -957,7 +959,8 @@ int tb_dp_port_enable(struct tb_port *port, bool enable);
 
 struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 				 struct tb_port *dst, int dst_hopid,
-				 struct tb_port **last, const char *name);
+				 struct tb_port **last, const char *name,
+				 bool alloc_hopid);
 struct tb_path *tb_path_alloc(struct tb *tb, struct tb_port *src, int src_hopid,
 			      struct tb_port *dst, int dst_hopid, int link_nr,
 			      const char *name);
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index bd98c719bf55..500a0afe3073 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -207,12 +207,14 @@ static int tb_pci_init_path(struct tb_path *path)
  * tb_tunnel_discover_pci() - Discover existing PCIe tunnels
  * @tb: Pointer to the domain structure
  * @down: PCIe downstream adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @down adapter is active, follows the tunnel to the PCIe upstream
  * adapter and back. Returns the discovered tunnel or %NULL if there was
  * no tunnel.
  */
-struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down)
+struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down,
+					 bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path *path;
@@ -233,7 +235,7 @@ struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down)
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_PCI_HOPID, NULL, -1,
-				&tunnel->dst_port, "PCIe Up");
+				&tunnel->dst_port, "PCIe Up", alloc_hopid);
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_pci_port_enable(down, false);
@@ -244,7 +246,7 @@ struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down)
 		goto err_free;
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_PCI_HOPID, NULL,
-				"PCIe Down");
+				"PCIe Down", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_PCI_PATH_DOWN] = path;
@@ -761,6 +763,7 @@ static int tb_dp_init_video_path(struct tb_path *path)
  * tb_tunnel_discover_dp() - Discover existing Display Port tunnels
  * @tb: Pointer to the domain structure
  * @in: DP in adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @in adapter is active, follows the tunnel to the DP out adapter
  * and back. Returns the discovered tunnel or %NULL if there was no
@@ -768,7 +771,8 @@ static int tb_dp_init_video_path(struct tb_path *path)
  *
  * Return: DP tunnel or %NULL if no tunnel found.
  */
-struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in)
+struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
+					bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_port *port;
@@ -787,7 +791,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in)
 	tunnel->src_port = in;
 
 	path = tb_path_discover(in, TB_DP_VIDEO_HOPID, NULL, -1,
-				&tunnel->dst_port, "Video");
+				&tunnel->dst_port, "Video", alloc_hopid);
 	if (!path) {
 		/* Just disable the DP IN port */
 		tb_dp_port_enable(in, false);
@@ -797,14 +801,15 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in)
 	if (tb_dp_init_video_path(tunnel->paths[TB_DP_VIDEO_PATH_OUT]))
 		goto err_free;
 
-	path = tb_path_discover(in, TB_DP_AUX_TX_HOPID, NULL, -1, NULL, "AUX TX");
+	path = tb_path_discover(in, TB_DP_AUX_TX_HOPID, NULL, -1, NULL, "AUX TX",
+				alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_DP_AUX_PATH_OUT] = path;
 	tb_dp_init_aux_path(tunnel->paths[TB_DP_AUX_PATH_OUT]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, in, TB_DP_AUX_RX_HOPID,
-				&port, "AUX RX");
+				&port, "AUX RX", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_DP_AUX_PATH_IN] = path;
@@ -1344,12 +1349,14 @@ static void tb_usb3_init_path(struct tb_path *path)
  * tb_tunnel_discover_usb3() - Discover existing USB3 tunnels
  * @tb: Pointer to the domain structure
  * @down: USB3 downstream adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @down adapter is active, follows the tunnel to the USB3 upstream
  * adapter and back. Returns the discovered tunnel or %NULL if there was
  * no tunnel.
  */
-struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down)
+struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down,
+					  bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path *path;
@@ -1370,7 +1377,7 @@ struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down)
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_USB3_HOPID, NULL, -1,
-				&tunnel->dst_port, "USB3 Down");
+				&tunnel->dst_port, "USB3 Down", alloc_hopid);
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_usb3_port_enable(down, false);
@@ -1380,7 +1387,7 @@ struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down)
 	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_USB3_HOPID, NULL,
-				"USB3 Up");
+				"USB3 Up", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_USB3_PATH_UP] = path;
diff --git a/drivers/thunderbolt/tunnel.h b/drivers/thunderbolt/tunnel.h
index a92027431697..bb4d1f1d6d0b 100644
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -64,10 +64,12 @@ struct tb_tunnel {
 	int allocated_down;
 };
 
-struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down);
+struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down,
+					 bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 				      struct tb_port *down);
-struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in);
+struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
+					bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 				     struct tb_port *out, int link_nr,
 				     int max_up, int max_down);
@@ -77,7 +79,8 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 				      int receive_ring);
 bool tb_tunnel_match_dma(const struct tb_tunnel *tunnel, int transmit_path,
 			 int transmit_ring, int receive_path, int receive_ring);
-struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down);
+struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down,
+					  bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_usb3(struct tb *tb, struct tb_port *up,
 				       struct tb_port *down, int max_up,
 				       int max_down);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f4015556cafa..2fd46093e5bb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2404,7 +2404,9 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 		fs_info->dev_root = root;
 	}
 	/* Initialize fs_info for all devices in any case */
-	btrfs_init_devices_late(fs_info);
+	ret = btrfs_init_devices_late(fs_info);
+	if (ret)
+		goto out;
 
 	/* If IGNOREDATACSUMS is set don't bother reading the csum root. */
 	if (!btrfs_test_opt(fs_info, IGNOREDATACSUMS)) {
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 3a4099a2bf05..3df990497254 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -199,7 +199,7 @@ void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f22d91e2392..c886ec81c5d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6841,18 +6841,18 @@ static bool dev_args_match_fs_devices(const struct btrfs_dev_lookup_args *args,
 static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
 				  const struct btrfs_device *device)
 {
-	ASSERT((args->devid != (u64)-1) || args->missing);
+	if (args->missing) {
+		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
+		    !device->bdev)
+			return true;
+		return false;
+	}
 
-	if ((args->devid != (u64)-1) && device->devid != args->devid)
+	if (device->devid != args->devid)
 		return false;
 	if (args->uuid && memcmp(device->uuid, args->uuid, BTRFS_UUID_SIZE) != 0)
 		return false;
-	if (!args->missing)
-		return true;
-	if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
-	    !device->bdev)
-		return true;
-	return false;
+	return true;
 }
 
 /*
@@ -7681,10 +7681,11 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
+int btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices, *seed_devs;
 	struct btrfs_device *device;
+	int ret = 0;
 
 	fs_devices->fs_info = fs_info;
 
@@ -7693,12 +7694,18 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 		device->fs_info = fs_info;
 
 	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
-		list_for_each_entry(device, &seed_devs->devices, dev_list)
+		list_for_each_entry(device, &seed_devs->devices, dev_list) {
 			device->fs_info = fs_info;
+			ret = btrfs_get_dev_zone_info(device, false);
+			if (ret)
+				break;
+		}
 
 		seed_devs->fs_info = fs_info;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
 }
 
 static u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index dfd7457709b3..b49fa784e5ba 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -539,7 +539,7 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_get_dev_stats *stats);
-void btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
+int btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
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
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 96c5cab5c8ae..6d21f9bc6de1 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2243,7 +2243,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_transaction_info *ti;
 	int err;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2282,7 +2282,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2778,11 +2778,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
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
index 2883ab625f61..663e68c22db8 100644
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
index c8bfc01da5d7..16994598a8db 100644
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
index b3d5f97f16cd..865e658535b1 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -240,7 +240,7 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 						      poffset - lfi);
 			else {
 				if (!copy_name) {
-					copy_name = kmalloc(UDF_NAME_LEN,
+					copy_name = kmalloc(UDF_NAME_LEN_CS0,
 							    GFP_NOFS);
 					if (!copy_name) {
 						fi = ERR_PTR(-ENOMEM);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9eac202fbcfd..e28792ca25a1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -337,6 +337,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -969,7 +970,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 818cd594e922..84efd8dd139d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2022,6 +2022,7 @@ int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
 void sock_map_unhash(struct sock *sk);
+void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5625e19ae95b..3d04b48e502d 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -328,6 +328,27 @@ struct bpf_verifier_state {
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
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 0c742cdf413c..ba015a77238a 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -96,6 +96,7 @@ struct sk_psock {
 	spinlock_t			link_lock;
 	refcount_t			refcnt;
 	void (*saved_unhash)(struct sock *sk);
+	void (*saved_destroy)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
@@ -381,7 +382,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index fa1d6af0164e..d683251a0b40 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -5,6 +5,7 @@
 #ifndef __SOC_OTX2_ASM_H
 #define __SOC_OTX2_ASM_H
 
+#include <linux/types.h>
 #if defined(CONFIG_ARM64)
 /*
  * otx2_lmt_flush is used for LMT store operation.
@@ -34,9 +35,23 @@
 			 : [rf] "+r"(val)		\
 			 : [rs] "r"(addr));		\
 })
+
+static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
+{
+	u64 result;
+
+	asm volatile (".cpu  generic+lse\n"
+		      "ldadda %x[i], %x[r], [%[b]]"
+		      : [r] "=r" (result), "+m" (*ptr)
+		      : [i] "r" (incr), [b] "r" (ptr)
+		      : "memory");
+	return result;
+}
+
 #else
 #define otx2_lmt_flush(ioaddr)          ({ 0; })
 #define cn10k_lmt_flush(val, addr)	({ addr = val; })
+#define otx2_atomic64_fetch_add(incr, ptr)	({ incr; })
 #endif
 
 #endif /* __SOC_OTX2_ASM_H */
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 463d1ba2232a..3d61a0ae055d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -426,7 +426,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c3a4158e838e..8a73a165ac76 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -770,12 +770,17 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
  */
 static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
 {
+	void *new_arr;
+
 	if (!new_n || old_n == new_n)
 		goto out;
 
-	arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
-	if (!arr)
+	new_arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
+	if (!new_arr) {
+		kfree(arr);
 		return NULL;
+	}
+	arr = new_arr;
 
 	if (new_n > old_n)
 		memset(arr + old_n * size, 0, (new_n - old_n) * size);
@@ -5629,31 +5634,15 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
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
-}
-
-static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
-{
-	struct bpf_verifier_state *vstate = env->cur_state;
-	int i;
-
-	for (i = 0; i <= vstate->curframe; i++)
-		__clear_all_pkt_pointers(env, vstate->frame[i]);
+	}));
 }
 
 enum {
@@ -5682,41 +5671,28 @@ static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range
 		reg->range = AT_PKT_END;
 }
 
-static void release_reg_references(struct bpf_verifier_env *env,
-				   struct bpf_func_state *state,
-				   int ref_obj_id)
-{
-	struct bpf_reg_state *regs = state->regs, *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
-			mark_reg_unknown(env, regs, i);
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		if (reg->ref_obj_id == ref_obj_id)
-			__mark_reg_unknown(env, reg);
-	}
-}
-
 /* The pointer with the specified id has released its reference to kernel
  * resources. Identify all copies of the same pointer and clear the reference.
  */
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
@@ -8216,34 +8192,14 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
-static void __find_good_pkt_pointers(struct bpf_func_state *state,
-				     struct bpf_reg_state *dst_reg,
-				     enum bpf_reg_type type, int new_range)
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
-	int new_range, i;
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
+	int new_range;
 
 	if (dst_reg->off < 0 ||
 	    (dst_reg->off == 0 && range_right_open))
@@ -8308,9 +8264,11 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
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
@@ -8799,7 +8757,7 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 
 		if (!reg_may_point_to_spin_lock(reg)) {
 			/* For not-NULL ptr, reg->ref_obj_id will be reset
-			 * in release_reg_references().
+			 * in release_reference().
 			 *
 			 * reg->id is still used by spin_lock ptr. Other
 			 * than spin_lock ptr type, reg->id can be reset.
@@ -8809,22 +8767,6 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
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
@@ -8832,10 +8774,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
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
@@ -8844,8 +8785,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 		 */
 		WARN_ON_ONCE(release_reference_state(state, id));
 
-	for (i = 0; i <= vstate->curframe; i++)
-		__mark_ptr_or_null_regs(vstate->frame[i], id, is_null);
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		mark_ptr_or_null_reg(state, reg, id, is_null);
+	}));
 }
 
 static bool try_match_pkt_pointers(const struct bpf_insn *insn,
@@ -8958,23 +8900,11 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 {
 	struct bpf_func_state *state;
 	struct bpf_reg_state *reg;
-	int i, j;
 
-	for (i = 0; i <= vstate->curframe; i++) {
-		state = vstate->frame[i];
-		for (j = 0; j < MAX_BPF_REG; j++) {
-			reg = &state->regs[j];
-			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-				*reg = *known_reg;
-		}
-
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
diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index e670fb6b1126..b039fd1f8a1d 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -441,6 +441,7 @@ static ssize_t dbgfs_mk_context_write(struct file *file,
 static int dbgfs_rm_context(char *name)
 {
 	struct dentry *root, *dir, **new_dirs;
+	struct inode *inode;
 	struct damon_ctx **new_ctxs;
 	int i, j;
 	int ret = 0;
@@ -456,6 +457,12 @@ static int dbgfs_rm_context(char *name)
 	if (!dir)
 		return -ENOENT;
 
+	inode = d_inode(dir);
+	if (!S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
 	if (!new_dirs) {
diff --git a/mm/memremap.c b/mm/memremap.c
index 8d743cbc2964..1a7539502bbc 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -327,6 +327,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3bbaf5f5353e..d0a7271a6cd5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -63,7 +63,7 @@ int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 	pte_t _dst_pte, *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
-	bool page_in_cache = page->mapping;
+	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
 	struct inode *inode;
 	pgoff_t offset, max_off;
diff --git a/net/can/af_can.c b/net/can/af_can.c
index cce2af10eb3e..4ddefa6a3e05 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -451,7 +451,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 8452b0fbb78c..82671a882716 100644
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
index 9cc607b2d3d2..6706bd3c8e9c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4010,23 +4010,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
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
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 736d8b035a67..f562f7e2bdc7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -720,6 +720,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	psock->eval = __SK_NONE;
 	psock->sk_proto = prot;
 	psock->saved_unhash = prot->unhash;
+	psock->saved_destroy = prot->destroy;
 	psock->saved_close = prot->close;
 	psock->saved_write_space = sk->sk_write_space;
 
@@ -796,16 +797,13 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
-void sk_psock_stop(struct sk_psock *psock, bool wait)
+void sk_psock_stop(struct sk_psock *psock)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
 	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
-
-	if (wait)
-		cancel_work_sync(&psock->work);
 }
 
 static void sk_psock_done_strp(struct sk_psock *psock);
@@ -843,7 +841,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 795b3acfb9fd..4f4bc163a223 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1524,6 +1524,29 @@ void sock_map_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
+void sock_map_destroy(struct sock *sk)
+{
+	void (*saved_destroy)(struct sock *sk);
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		if (sk->sk_prot->destroy)
+			sk->sk_prot->destroy(sk);
+		return;
+	}
+
+	saved_destroy = psock->saved_destroy;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	sk_psock_stop(psock);
+	sk_psock_put(sk, psock);
+	saved_destroy(sk);
+}
+EXPORT_SYMBOL_GPL(sock_map_destroy);
+
 void sock_map_close(struct sock *sk, long timeout)
 {
 	void (*saved_close)(struct sock *sk, long timeout);
@@ -1541,9 +1564,10 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
-	sk_psock_put(sk, psock);
+	sk_psock_stop(psock);
 	release_sock(sk);
+	cancel_work_sync(&psock->work);
+	sk_psock_put(sk, psock);
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5b4e170b6a34..fe1972aad279 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3536,7 +3536,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_REPAIR_OPTIONS:
 		if (!tp->repair)
 			err = -EINVAL;
-		else if (sk->sk_state == TCP_ESTABLISHED)
+		else if (sk->sk_state == TCP_ESTABLISHED && !tp->bytes_sent)
 			err = tcp_repair_options_est(sk, optval, optlen);
 		else
 			err = -EPERM;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 2c597a4e429a..5194c6870273 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -279,7 +279,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 {
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
-	u32 tosend, delta = 0;
+	u32 tosend, origsize, sent, delta = 0;
 	u32 eval = __SK_NONE;
 	int ret;
 
@@ -334,10 +334,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
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
@@ -376,7 +378,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		    msg->sg.data[msg->sg.start].page_link &&
 		    msg->sg.data[msg->sg.start].length) {
 			if (eval == __SK_REDIRECT)
-				sk_mem_charge(sk, msg->sg.size);
+				sk_mem_charge(sk, tosend - sent);
 			goto more_data;
 		}
 	}
@@ -541,6 +543,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
+	prot[TCP_BPF_BASE].destroy		= sock_map_destroy;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
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
diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 4141bc80cdfd..10b34bc4b67d 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -112,6 +112,9 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	/* TWT Information not supported yet */
+	twt->control |= IEEE80211_TWT_CONTROL_RX_DISABLED;
+
 	drv_add_twt_setup(sdata->local, sdata, &sta->sta, twt);
 out:
 	ieee80211_s1g_send_twt_setup(sdata, mgmt->sa, sdata->vif.addr, twt);
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 85cc1a28cbe9..cbbde0f73a08 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -375,12 +375,14 @@ static __init int mctp_init(void)
 
 	rc = mctp_neigh_init();
 	if (rc)
-		goto err_unreg_proto;
+		goto err_unreg_routes;
 
 	mctp_device_init();
 
 	return 0;
 
+err_unreg_routes:
+	mctp_routes_exit();
 err_unreg_proto:
 	proto_unregister(&mctp_proto);
 err_unreg_sock:
diff --git a/net/mctp/route.c b/net/mctp/route.c
index bbb13dbc9227..6aebb4a3eded 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1109,7 +1109,7 @@ int __init mctp_routes_init(void)
 	return register_pernet_subsys(&mctp_net_ops);
 }
 
-void __exit mctp_routes_exit(void)
+void mctp_routes_exit(void)
 {
 	unregister_pernet_subsys(&mctp_net_ops);
 	rtnl_unregister(PF_MCTP, RTM_DELROUTE);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 899f01c6c26c..227f03db7ee1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9884,7 +9884,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	mutex_lock(&nft_net->commit_mutex);
-	if (!list_empty(&nft_net->commit_list))
+	if (!list_empty(&nft_net->commit_list) ||
+	    !list_empty(&nft_net->module_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&nft_net->commit_mutex);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..2cce4033a70a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -290,6 +290,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
+				nfnl_unlock(subsys_id);
 				err = -EAGAIN;
 				break;
 			}
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 0749df80454d..ce00f271ca6b 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -880,7 +880,7 @@ static int tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
 	};
 
 	ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-	if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+	if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct tipc_name_table_query))
 		return -EINVAL;
 
 	depth = ntohl(ntq->depth);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 54c13ea7d977..7b19a2087db9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1083,6 +1083,8 @@ MODULE_FIRMWARE("regulatory.db");
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1092,9 +1094,13 @@ static int query_regdb_file(const char *alpha2)
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
index f0de22a6caf7..2477d28c2dab 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1676,7 +1676,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
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
index 0d7771fca9f0..6b8d15653749 100644
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
index b5b71a285119..c8042eb703c3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2687,6 +2687,9 @@ static const struct pci_device_id azx_ids[] = {
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
index 208933792787..801dd8d44953 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1306,6 +1306,7 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0de1dcd3b946..d34df61f1335 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9244,6 +9244,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 4526f1d1fd6e..550c6a72fb5b 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -741,6 +741,18 @@ get_alias_quirk(struct usb_device *dev, unsigned int id)
 	return NULL;
 }
 
+/* register card if we reach to the last interface or to the specified
+ * one given via option
+ */
+static int try_to_register_card(struct snd_usb_audio *chip, int ifnum)
+{
+	if (check_delayed_register_option(chip) == ifnum ||
+	    chip->last_iface == ifnum ||
+	    usb_interface_claimed(usb_ifnum_to_if(chip->dev, chip->last_iface)))
+		return snd_card_register(chip->card);
+	return 0;
+}
+
 /*
  * probe the active usb device
  *
@@ -879,15 +891,9 @@ static int usb_audio_probe(struct usb_interface *intf,
 		chip->need_delayed_register = false; /* clear again */
 	}
 
-	/* register card if we reach to the last interface or to the specified
-	 * one given via option
-	 */
-	if (check_delayed_register_option(chip) == ifnum ||
-	    usb_interface_claimed(usb_ifnum_to_if(dev, chip->last_iface))) {
-		err = snd_card_register(chip->card);
-		if (err < 0)
-			goto __error;
-	}
+	err = try_to_register_card(chip, ifnum);
+	if (err < 0)
+		goto __error_no_register;
 
 	if (chip->quirk_flags & QUIRK_FLAG_SHARE_MEDIA_DEVICE) {
 		/* don't want to fail when snd_media_device_create() fails */
@@ -906,6 +912,11 @@ static int usb_audio_probe(struct usb_interface *intf,
 	return 0;
 
  __error:
+	/* in the case of error in secondary interface, still try to register */
+	if (chip)
+		try_to_register_card(chip, ifnum);
+
+ __error_no_register:
 	if (chip) {
 		/* chip->active is inside the chip->card object,
 		 * decrement before memory is possibly returned.
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index f93201a830b5..95358f04341b 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2049,6 +2049,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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
index 8c3b0be909eb..879d8b1f301c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1611,6 +1611,7 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
+	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 8f38265bc81d..2c0838ee3eac 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -495,6 +495,11 @@
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
@@ -572,9 +577,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index d42d930a3ec4..e4c65d34fe74 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -278,6 +278,9 @@ int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
 	int err;
 	int fd;
 
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
 	fd = get_fd(&argc, &argv);
 	if (fd < 0)
 		return fd;
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 8e0163b7ef01..cdb7a347ceb5 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -4,6 +4,7 @@ PERF-GUI-VARS
 PERF-VERSION-FILE
 FEATURE-DUMP
 perf
+!include/perf/
 perf-read-vdso32
 perf-read-vdsox32
 perf-help
diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index db00ca6a67de..24e50fabb6c3 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -207,7 +207,7 @@ static void new_line_csv(struct perf_stat_config *config, void *ctx)
 
 	fputc('\n', os->fh);
 	if (os->prefix)
-		fprintf(os->fh, "%s%s", os->prefix, config->csv_sep);
+		fprintf(os->fh, "%s", os->prefix);
 	aggr_printout(config, os->evsel, os->id, os->nr);
 	for (i = 0; i < os->nfields; i++)
 		fputs(config->csv_sep, os->fh);
