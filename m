Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E065ACFE0
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiIEKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbiIEKMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0F05006F;
        Mon,  5 Sep 2022 03:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47D7FB81012;
        Mon,  5 Sep 2022 10:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304BFC433D6;
        Mon,  5 Sep 2022 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372742;
        bh=7kTrqpBIx/lgA1DHZVEgpbaZO4aWbWK9F7UO9hdx77w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6g+272lYtEqQ9ktp6upZ9jFPYS5jVaxzzaqbJsx/WIqA6PRqTIA8Z8a7N+wlmlRi
         UXYcByYk6zh651srnQ0+bukR+WGwHlLQhbBbbj9F3WpTl4jkGEo/Qeo50D9EvWYs8G
         S0wlTj+F+YdxqJ0mxw8BhPu8aHMH0uNib5feb1ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.257
Date:   Mon,  5 Sep 2022 12:12:12 +0200
Message-Id: <1662372732249227@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <1662372732116209@kroah.com>
References: <1662372732116209@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
index 9393c50b5afc..c98fd11907cc 100644
--- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
@@ -230,6 +230,20 @@ The possible values in this file are:
      * - 'Mitigation: Clear CPU buffers'
        - The processor is vulnerable and the CPU buffer clearing mitigation is
          enabled.
+     * - 'Unknown: No mitigations'
+       - The processor vulnerability status is unknown because it is
+	 out of Servicing period. Mitigation is not attempted.
+
+Definitions:
+------------
+
+Servicing period: The process of providing functional and security updates to
+Intel processors or platforms, utilizing the Intel Platform Update (IPU)
+process or other similar mechanisms.
+
+End of Servicing Updates (ESU): ESU is the date at which Intel will no
+longer provide Servicing, such as through IPU or other similar update
+processes. ESU dates will typically be aligned to end of quarter.
 
 If the processor is vulnerable then the following information is appended to
 the above information:
diff --git a/Makefile b/Makefile
index ac79aef4520b..18ccab9a01b0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 256
+SUBLEVEL = 257
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index b37d185e0e84..3dda6ff32efd 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -98,7 +98,7 @@ extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only);
-extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
+extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 06941c1fe418..92bb53460401 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -65,9 +65,6 @@ static __init const u8 *kaslr_get_cmdline(void *fdt)
 	return default_cmdline;
 }
 
-extern void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size,
-				       pgprot_t prot);
-
 /*
  * This routine will be executed with the kernel mapped at its default virtual
  * address, and if it returns successfully, the kernel will be remapped, and
@@ -96,7 +93,7 @@ u64 __init kaslr_early_init(u64 dt_phys)
 	 * attempt at mapping the FDT in setup_machine()
 	 */
 	early_fixmap_init();
-	fdt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+	fdt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
 	if (!fdt)
 		return 0;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b3354ff94e79..43e9786f1d60 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -183,9 +183,13 @@ static void __init smp_build_mpidr_hash(void)
 
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
-	void *dt_virt = fixmap_remap_fdt(dt_phys);
+	int size;
+	void *dt_virt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
 	const char *name;
 
+	if (dt_virt)
+		memblock_reserve(dt_phys, size);
+
 	if (!dt_virt || !early_init_dt_scan(dt_virt)) {
 		pr_crit("\n"
 			"Error: invalid device tree blob at physical address %pa (virtual address 0x%p)\n"
@@ -197,6 +201,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 			cpu_relax();
 	}
 
+	/* Early fixups are done, map the FDT as read-only now */
+	fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
+
 	name = of_flat_dt_get_machine_name();
 	if (!name)
 		return;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b0a83dbed2dc..7042fbb6d92b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -859,7 +859,7 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
-void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
+void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
 	int offset;
@@ -912,19 +912,6 @@ void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 	return dt_virt;
 }
 
-void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
-{
-	void *dt_virt;
-	int size;
-
-	dt_virt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
-	if (!dt_virt)
-		return NULL;
-
-	memblock_reserve(dt_phys, size);
-	return dt_virt;
-}
-
 int __init arch_ioremap_pud_supported(void)
 {
 	/*
diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index c16af267362e..a8b5ad11c7a4 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -121,7 +121,7 @@
 #define R1(i) (((i)>>21)&0x1f)
 #define R2(i) (((i)>>16)&0x1f)
 #define R3(i) ((i)&0x1f)
-#define FR3(i) ((((i)<<1)&0x1f)|(((i)>>6)&1))
+#define FR3(i) ((((i)&0x1f)<<1)|(((i)>>6)&1))
 #define IM(i,n) (((i)>>1&((1<<(n-1))-1))|((i)&1?((0-1L)<<(n-1)):0))
 #define IM5_2(i) IM((i)>>16,5)
 #define IM5_3(i) IM((i),5)
diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index 3452e18bb1ca..38105ba35c81 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -437,7 +437,7 @@ __init int hypfs_diag_init(void)
 	int rc;
 
 	if (diag204_probe()) {
-		pr_err("The hardware system does not support hypfs\n");
+		pr_info("The hardware system does not support hypfs\n");
 		return -ENODATA;
 	}
 	if (diag204_info_type == DIAG204_INFO_EXT) {
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index e4d17d9ea93d..4af5c0dd9fbe 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -494,9 +494,9 @@ static int __init hypfs_init(void)
 	hypfs_vm_exit();
 fail_hypfs_diag_exit:
 	hypfs_diag_exit();
+	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 fail_dbfs_exit:
 	hypfs_dbfs_exit();
-	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 	return rc;
 }
 device_initcall(hypfs_init)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 99ef537e548a..5772ef90dd26 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -75,6 +75,18 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 	memcpy(dst, src, arch_task_struct_size);
 	dst->thread.fpu.regs = dst->thread.fpu.fprs;
+
+	/*
+	 * Don't transfer over the runtime instrumentation or the guarded
+	 * storage control block pointers. These fields are cleared here instead
+	 * of in copy_thread() to avoid premature freeing of associated memory
+	 * on fork() failure. Wait to clear the RI flag because ->stack still
+	 * refers to the source thread.
+	 */
+	dst->thread.ri_cb = NULL;
+	dst->thread.gs_cb = NULL;
+	dst->thread.gs_bc_cb = NULL;
+
 	return 0;
 }
 
@@ -131,13 +143,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long new_stackp,
 	frame->childregs.flags = 0;
 	if (new_stackp)
 		frame->childregs.gprs[15] = new_stackp;
-
-	/* Don't copy runtime instrumentation info */
-	p->thread.ri_cb = NULL;
+	/*
+	 * Clear the runtime instrumentation flag after the above childregs
+	 * copy. The CB pointer was already cleared in arch_dup_task_struct().
+	 */
 	frame->childregs.psw.mask &= ~PSW_MASK_RI;
-	/* Don't copy guarded storage control block */
-	p->thread.gs_cb = NULL;
-	p->thread.gs_bc_cb = NULL;
 
 	/* Set a new TLS ?  */
 	if (clone_flags & CLONE_SETTLS) {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index a6e3c7022245..d64b180caeda 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -455,7 +455,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
+	if ((trans_exc_code & store_indication) == 0x400)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	down_read(&mm->mmap_sem);
 
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 89145ea183d6..e9b79bac9b2a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -396,6 +396,7 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(26) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a36be6786043..501d09d59abc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -396,7 +396,8 @@ static void __init mmio_select_mitigation(void)
 	u64 ia32_cap;
 
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
-	    cpu_mitigations_off()) {
+	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
+	     cpu_mitigations_off()) {
 		mmio_mitigation = MMIO_MITIGATION_OFF;
 		return;
 	}
@@ -501,6 +502,8 @@ static void __init md_clear_update_mitigation(void)
 		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
+	else if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		pr_info("MMIO Stale Data: Unknown: No mitigations\n");
 }
 
 static void __init md_clear_select_mitigation(void)
@@ -1868,6 +1871,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static ssize_t mmio_stale_data_show_state(char *buf)
 {
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return sysfs_emit(buf, "Unknown: No mitigations\n");
+
 	if (mmio_mitigation == MMIO_MITIGATION_OFF)
 		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
 
@@ -1995,6 +2001,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 		return srbds_show_state(buf);
 
 	case X86_BUG_MMIO_STALE_DATA:
+	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
 	default:
@@ -2051,6 +2058,9 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
 
 ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
+	else
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3ab35d5426b7..653ced7cb396 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -955,6 +955,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_EIBRS_PBRSB		BIT(8)
+#define NO_MMIO			BIT(9)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -972,6 +973,11 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
+	VULNWL_INTEL(TIGERLAKE,			NO_MMIO),
+	VULNWL_INTEL(TIGERLAKE_L,		NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE,			NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE_L,		NO_MMIO),
+
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
@@ -989,9 +995,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1006,13 +1012,13 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	{}
 };
 
@@ -1152,10 +1158,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	 * Affected CPU list is generally enough to enumerate the vulnerability,
 	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
 	 * not want the guest to enumerate the bug.
+	 *
+	 * Set X86_BUG_MMIO_UNKNOWN for CPUs that are neither in the blacklist,
+	 * nor in the whitelist and also don't enumerate MSR ARCH_CAP MMIO bits.
 	 */
-	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
-	    !arch_cap_mmio_immune(ia32_cap))
-		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+	if (!arch_cap_mmio_immune(ia32_cap)) {
+		if (cpu_matches(cpu_vuln_blacklist, MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+		else if (!cpu_matches(cpu_vuln_whitelist, NO_MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
+	}
 
 	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
 	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 4f17c1c94949..5c48d2c4cabe 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -89,22 +89,27 @@ static struct orc_entry *orc_find(unsigned long ip);
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
 {
 	struct ftrace_ops *ops;
-	unsigned long caller;
+	unsigned long tramp_addr, offset;
 
 	ops = ftrace_ops_trampoline(ip);
 	if (!ops)
 		return NULL;
 
+	/* Set tramp_addr to the start of the code copied by the trampoline */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
-		caller = (unsigned long)ftrace_regs_call;
+		tramp_addr = (unsigned long)ftrace_regs_caller;
 	else
-		caller = (unsigned long)ftrace_call;
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	/* Now place tramp_addr to the location within the trampoline ip is at */
+	offset = ip - ops->trampoline;
+	tramp_addr += offset;
 
 	/* Prevent unlikely recursion */
-	if (ip == caller)
+	if (ip == tramp_addr)
 		return NULL;
 
-	return orc_find(caller);
+	return orc_find(tramp_addr);
 }
 #else
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c31a76485c9c..12eb48980df7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1351,6 +1351,11 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	info->lo_number = lo->lo_number;
 	info->lo_offset = lo->lo_offset;
 	info->lo_sizelimit = lo->lo_sizelimit;
+
+	/* loff_t vars have been assigned __u64 */
+	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
+		return -EOVERFLOW;
+
 	info->lo_flags = lo->lo_flags;
 	memcpy(info->lo_file_name, lo->lo_file_name, LO_NAME_SIZE);
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
index 411f89218e01..cb5c44b339e0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
@@ -452,6 +452,11 @@ void optc1_enable_optc_clock(struct timing_generator *optc, bool enable)
 				OTG_CLOCK_ON, 1,
 				1, 1000);
 	} else  {
+
+		//last chance to clear underflow, otherwise, it will always there due to clock is off.
+		if (optc->funcs->is_optc_underflow_occurred(optc) == true)
+			optc->funcs->clear_optc_underflow(optc);
+
 		REG_UPDATE_2(OTG_CLOCK_CONTROL,
 				OTG_CLOCK_GATE_DIS, 0,
 				OTG_CLOCK_EN, 0);
diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index a3b151b29bd7..fc616db4231b 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -134,6 +134,11 @@ static int steam_recv_report(struct steam_device *steam,
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 
@@ -165,6 +170,11 @@ static int steam_send_report(struct steam_device *steam,
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c4ba2d28dd73..6a5c5ce85d85 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -354,10 +354,13 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct hidraw_list *list = file->private_data;
 	unsigned long flags;
+	int i;
 
 	mutex_lock(&minors_lock);
 
 	spin_lock_irqsave(&hidraw_table[minor]->list_lock, flags);
+	for (i = list->tail; i < list->head; i++)
+		kfree(list->buffer[i].value);
 	list_del(&list->node);
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	kfree(list);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4594a1ee88b9..38cbde906133 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5937,6 +5937,7 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	__md_stop_writes(mddev);
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index bbb5ff16abd6..4cbb39bfb7da 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2602,6 +2602,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
+		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index b3eaef31b767..a6bb7e915f74 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1977,30 +1977,24 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
  */
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 {
-	/* check that the bond is not initialized yet */
-	if (!MAC_ADDRESS_EQUAL(&(BOND_AD_INFO(bond).system.sys_mac_addr),
-				bond->dev->dev_addr)) {
-
-		BOND_AD_INFO(bond).aggregator_identifier = 0;
-
-		BOND_AD_INFO(bond).system.sys_priority =
-			bond->params.ad_actor_sys_prio;
-		if (is_zero_ether_addr(bond->params.ad_actor_system))
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->dev->dev_addr);
-		else
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->params.ad_actor_system);
+	BOND_AD_INFO(bond).aggregator_identifier = 0;
+	BOND_AD_INFO(bond).system.sys_priority =
+		bond->params.ad_actor_sys_prio;
+	if (is_zero_ether_addr(bond->params.ad_actor_system))
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->dev->dev_addr);
+	else
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->params.ad_actor_system);
 
-		/* initialize how many times this module is called in one
-		 * second (should be about every 100ms)
-		 */
-		ad_ticks_per_sec = tick_resolution;
+	/* initialize how many times this module is called in one
+	 * second (should be about every 100ms)
+	 */
+	ad_ticks_per_sec = tick_resolution;
 
-		bond_3ad_initiate_agg_selection(bond,
-						AD_AGGREGATOR_SELECTION_TIMER *
-						ad_ticks_per_sec);
-	}
+	bond_3ad_initiate_agg_selection(bond,
+					AD_AGGREGATOR_SELECTION_TIMER *
+					ad_ticks_per_sec);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index b3e0d8bb5cbd..eec68cc9288c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -1066,7 +1066,6 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	struct cyclecounter cc;
 	unsigned long flags;
 	u32 incval = 0;
-	u32 tsauxc = 0;
 	u32 fuse0 = 0;
 
 	/* For some of the boards below this mask is technically incorrect.
@@ -1101,18 +1100,6 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	case ixgbe_mac_x550em_a:
 	case ixgbe_mac_X550:
 		cc.read = ixgbe_ptp_read_X550;
-
-		/* enable SYSTIME counter */
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMR, 0);
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
-		tsauxc = IXGBE_READ_REG(hw, IXGBE_TSAUXC);
-		IXGBE_WRITE_REG(hw, IXGBE_TSAUXC,
-				tsauxc & ~IXGBE_TSAUXC_DISABLE_SYSTIME);
-		IXGBE_WRITE_REG(hw, IXGBE_TSIM, IXGBE_TSIM_TXTS);
-		IXGBE_WRITE_REG(hw, IXGBE_EIMS, IXGBE_EIMS_TIMESYNC);
-
-		IXGBE_WRITE_FLUSH(hw);
 		break;
 	case ixgbe_mac_X540:
 		cc.read = ixgbe_ptp_read_82599;
@@ -1144,6 +1131,50 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 }
 
+/**
+ * ixgbe_ptp_init_systime - Initialize SYSTIME registers
+ * @adapter: the ixgbe private board structure
+ *
+ * Initialize and start the SYSTIME registers.
+ */
+static void ixgbe_ptp_init_systime(struct ixgbe_adapter *adapter)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+	u32 tsauxc;
+
+	switch (hw->mac.type) {
+	case ixgbe_mac_X550EM_x:
+	case ixgbe_mac_x550em_a:
+	case ixgbe_mac_X550:
+		tsauxc = IXGBE_READ_REG(hw, IXGBE_TSAUXC);
+
+		/* Reset SYSTIME registers to 0 */
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMR, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
+
+		/* Reset interrupt settings */
+		IXGBE_WRITE_REG(hw, IXGBE_TSIM, IXGBE_TSIM_TXTS);
+		IXGBE_WRITE_REG(hw, IXGBE_EIMS, IXGBE_EIMS_TIMESYNC);
+
+		/* Activate the SYSTIME counter */
+		IXGBE_WRITE_REG(hw, IXGBE_TSAUXC,
+				tsauxc & ~IXGBE_TSAUXC_DISABLE_SYSTIME);
+		break;
+	case ixgbe_mac_X540:
+	case ixgbe_mac_82599EB:
+		/* Reset SYSTIME registers to 0 */
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
+		break;
+	default:
+		/* Other devices aren't supported */
+		return;
+	};
+
+	IXGBE_WRITE_FLUSH(hw);
+}
+
 /**
  * ixgbe_ptp_reset
  * @adapter: the ixgbe private board structure
@@ -1170,6 +1201,8 @@ void ixgbe_ptp_reset(struct ixgbe_adapter *adapter)
 
 	ixgbe_ptp_start_cyclecounter(adapter);
 
+	ixgbe_ptp_init_systime(adapter);
+
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	timecounter_init(&adapter->hw_tc, &adapter->hw_cc,
 			 ktime_to_ns(ktime_get_real()));
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 0bcc07f346c3..2e517e30c5ac 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -193,7 +193,7 @@ static struct notifier_block ipvtap_notifier_block __read_mostly = {
 	.notifier_call	= ipvtap_device_event,
 };
 
-static int ipvtap_init(void)
+static int __init ipvtap_init(void)
 {
 	int err;
 
@@ -227,7 +227,7 @@ static int ipvtap_init(void)
 }
 module_init(ipvtap_init);
 
-static void ipvtap_exit(void)
+static void __exit ipvtap_exit(void)
 {
 	rtnl_link_unregister(&ipvtap_link_ops);
 	unregister_netdevice_notifier(&ipvtap_notifier_block);
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 8d2dbf607bd1..66b9c5826ec0 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -798,6 +798,7 @@ static int amd_gpio_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct amd_gpio *gpio_dev = platform_get_drvdata(pdev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -806,7 +807,9 @@ static int amd_gpio_suspend(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
@@ -817,6 +820,7 @@ static int amd_gpio_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct amd_gpio *gpio_dev = platform_get_drvdata(pdev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -825,7 +829,10 @@ static int amd_gpio_resume(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
+		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0c2ba075bc71..f3701b4e374b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1858,7 +1858,7 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 	host_dev->handle_error_wq =
 			alloc_ordered_workqueue("storvsc_error_wq_%d",
-						WQ_MEM_RECLAIM,
+						0,
 						host->host_no);
 	if (!host_dev->handle_error_wq)
 		goto err_out2;
diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 1dcf02e12af4..8ae010f07d7d 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -616,6 +616,11 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		return -EINVAL;
 	}
 
+	if (!var->pixclock) {
+		DPRINTK("pixclock is zero\n");
+		return -EINVAL;
+	}
+
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index f141b45ce349..6adee94637a9 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -369,6 +369,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	name = xattr_full_name(handler, name);
 	return btrfs_setxattr(NULL, inode, name, buffer, size, flags);
 }
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index ea5987bb0b84..40e03afa9ad1 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -100,7 +100,7 @@ static inline bool memory_contains(void *begin, void *end, void *virt,
 /**
  * memory_intersects - checks if the region occupied by an object intersects
  *                     with another memory region
- * @begin: virtual address of the beginning of the memory regien
+ * @begin: virtual address of the beginning of the memory region
  * @end: virtual address of the end of the memory region
  * @virt: virtual address of the memory object
  * @size: size of the memory object
@@ -113,7 +113,10 @@ static inline bool memory_intersects(void *begin, void *end, void *virt,
 {
 	void *vend = virt + size;
 
-	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+	if (virt < end && vend > begin)
+		return true;
+
+	return false;
 }
 
 /**
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index c6935be7c6ca..954ffe32f622 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -94,10 +94,6 @@ struct ebt_table {
 	struct ebt_replace_kernel *table;
 	unsigned int valid_hooks;
 	rwlock_t lock;
-	/* e.g. could be the table explicitly only allows certain
-	 * matches, targets, ... 0 == let it in */
-	int (*check)(const struct ebt_table_info *info,
-	   unsigned int valid_hooks);
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
 	struct module *me;
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 91ccae946716..c80bd129e939 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -39,12 +39,15 @@ struct anon_vma {
 	atomic_t refcount;
 
 	/*
-	 * Count of child anon_vmas and VMAs which points to this anon_vma.
+	 * Count of child anon_vmas. Equals to the count of all anon_vmas that
+	 * have ->parent pointing to this one, including itself.
 	 *
 	 * This counter is used for making decision about reusing anon_vma
 	 * instead of forking new one. See comments in function anon_vma_clone.
 	 */
-	unsigned degree;
+	unsigned long num_children;
+	/* Count of VMAs whose ->anon_vma pointer points to this object. */
+	unsigned long num_active_vmas;
 
 	struct anon_vma *parent;	/* Parent of this anon_vma */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f92d5ae6d04e..fd4899236037 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -528,10 +528,6 @@ struct sched_dl_entity {
 	 * task has to wait for a replenishment to be performed at the
 	 * next firing of dl_timer.
 	 *
-	 * @dl_boosted tells if we are boosted due to DI. If so we are
-	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section);
-	 *
 	 * @dl_yielded tells if task gave up the CPU before consuming
 	 * all its available runtime during the last job.
 	 *
@@ -546,7 +542,6 @@ struct sched_dl_entity {
 	 * overruns.
 	 */
 	unsigned int			dl_throttled      : 1;
-	unsigned int			dl_boosted        : 1;
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
@@ -565,6 +560,15 @@ struct sched_dl_entity {
 	 * time.
 	 */
 	struct hrtimer inactive_timer;
+
+#ifdef CONFIG_RT_MUTEXES
+	/*
+	 * Priority Inheritance. When a DEADLINE scheduling entity is boosted
+	 * pi_se points to the donor, otherwise points to the dl_se it belongs
+	 * to (the original one/itself).
+	 */
+	struct sched_dl_entity *pi_se;
+#endif
 };
 
 union rcu_special {
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index c76a5e9894da..8f42f6f3af86 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -43,7 +43,7 @@ extern unsigned int sysctl_net_busy_poll __read_mostly;
 
 static inline bool net_busy_loop_on(void)
 {
-	return sysctl_net_busy_poll;
+	return READ_ONCE(sysctl_net_busy_poll);
 }
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index fba78047fb37..57404292c6d1 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -111,6 +111,7 @@ struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pa
 
 	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, true);
 	if (ret < 0) {
+		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
 		audit_mark = ERR_PTR(ret);
 	}
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 099191716d4c..b2fcad8635bc 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1709,11 +1709,12 @@ static struct kprobe *__disable_kprobe(struct kprobe *p)
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
 			/*
-			 * If kprobes_all_disarmed is set, orig_p
-			 * should have already been disarmed, so
-			 * skip unneed disarming process.
+			 * Don't be lazy here.  Even if 'kprobes_all_disarmed'
+			 * is false, 'orig_p' might not have been armed yet.
+			 * Note arm_all_kprobes() __tries__ to arm all kprobes
+			 * on the best effort basis.
 			 */
-			if (!kprobes_all_disarmed) {
+			if (!kprobes_all_disarmed && !kprobe_disabled(orig_p)) {
 				ret = disarm_kprobe(orig_p, true);
 				if (ret) {
 					p->flags &= ~KPROBE_FLAG_DISABLED;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 32af895bd86b..a03464249771 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3869,20 +3869,21 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		if (!dl_prio(p->normal_prio) ||
 		    (pi_task && dl_prio(pi_task->prio) &&
 		     dl_entity_preempt(&pi_task->dl, &p->dl))) {
-			p->dl.dl_boosted = 1;
+			p->dl.pi_se = pi_task->dl.pi_se;
 			queue_flag |= ENQUEUE_REPLENISH;
-		} else
-			p->dl.dl_boosted = 0;
+		} else {
+			p->dl.pi_se = &p->dl;
+		}
 		p->sched_class = &dl_sched_class;
 	} else if (rt_prio(prio)) {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (oldprio < prio)
 			queue_flag |= ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
 	} else {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (rt_prio(oldprio))
 			p->rt.timeout = 0;
 		p->sched_class = &fair_sched_class;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index beec5081a55a..29ed5d8d30d6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -43,6 +43,28 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
 
+#ifdef CONFIG_RT_MUTEXES
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->pi_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return pi_of(dl_se) != dl_se;
+}
+#else
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SMP
 static inline struct dl_bw *dl_bw_of(int i)
 {
@@ -657,7 +679,7 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	WARN_ON(dl_se->dl_boosted);
+	WARN_ON(is_dl_boosted(dl_se));
 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
 
 	/*
@@ -695,21 +717,20 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
  * could happen are, typically, a entity voluntarily trying to overcome its
  * runtime, or it just underestimated it during sched_setattr().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se,
-				struct sched_dl_entity *pi_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	BUG_ON(pi_se->dl_runtime <= 0);
+	BUG_ON(pi_of(dl_se)->dl_runtime <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
 	 * Just go with full inherited parameters.
 	 */
 	if (dl_se->dl_deadline == 0) {
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -722,8 +743,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_se->dl_period;
-		dl_se->runtime += pi_se->dl_runtime;
+		dl_se->deadline += pi_of(dl_se)->dl_period;
+		dl_se->runtime += pi_of(dl_se)->dl_runtime;
 	}
 
 	/*
@@ -737,8 +758,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
 		printk_deferred_once("sched: DL replenish lagged too much\n");
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded)
@@ -771,8 +792,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
  * task with deadline equal to period this is the same of using
  * dl_period instead of dl_deadline in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
-			       struct sched_dl_entity *pi_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
 	u64 left, right;
 
@@ -794,9 +814,9 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (pi_se->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
+	left = (pi_of(dl_se)->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
 	right = ((dl_se->deadline - t) >> DL_SCALE) *
-		(pi_se->dl_runtime >> DL_SCALE);
+		(pi_of(dl_se)->dl_runtime >> DL_SCALE);
 
 	return dl_time_before(right, left);
 }
@@ -881,24 +901,23 @@ static inline bool dl_is_implicit(struct sched_dl_entity *dl_se)
  * Please refer to the comments update_dl_revised_wakeup() function to find
  * more about the Revised CBS rule.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se,
-			     struct sched_dl_entity *pi_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
-	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
+	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
 		if (unlikely(!dl_is_implicit(dl_se) &&
 			     !dl_time_before(dl_se->deadline, rq_clock(rq)) &&
-			     !dl_se->dl_boosted)){
+			     !is_dl_boosted(dl_se))) {
 			update_dl_revised_wakeup(dl_se, rq);
 			return;
 		}
 
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 }
 
@@ -997,7 +1016,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * The task might have been boosted by someone else and might be in the
 	 * boosting/deboosting path, its not throttled.
 	 */
-	if (dl_se->dl_boosted)
+	if (is_dl_boosted(dl_se))
 		goto unlock;
 
 	/*
@@ -1025,7 +1044,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * but do not enqueue -- wait for our wakeup to do that.
 	 */
 	if (!task_on_rq_queued(p)) {
-		replenish_dl_entity(dl_se, dl_se);
+		replenish_dl_entity(dl_se);
 		goto unlock;
 	}
 
@@ -1115,7 +1134,7 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 	    dl_time_before(rq_clock(rq), dl_next_period(dl_se))) {
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(p)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(p)))
 			return;
 		dl_se->dl_throttled = 1;
 		if (dl_se->runtime > 0)
@@ -1246,7 +1265,7 @@ static void update_curr_dl(struct rq *rq)
 			dl_se->dl_overrun = 1;
 
 		__dequeue_task_dl(rq, curr, 0);
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(curr)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(curr)))
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
@@ -1440,8 +1459,7 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 }
 
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se,
-		  struct sched_dl_entity *pi_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
 
@@ -1452,9 +1470,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se,
 	 */
 	if (flags & ENQUEUE_WAKEUP) {
 		task_contending(dl_se, flags);
-		update_dl_entity(dl_se, pi_se);
+		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
-		replenish_dl_entity(dl_se, pi_se);
+		replenish_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_RESTORE) &&
 		  dl_time_before(dl_se->deadline,
 				 rq_clock(rq_of_dl_rq(dl_rq_of_se(dl_se))))) {
@@ -1471,28 +1489,40 @@ static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct task_struct *pi_task = rt_mutex_get_top_task(p);
-	struct sched_dl_entity *pi_se = &p->dl;
-
-	/*
-	 * Use the scheduling parameters of the top pi-waiter task if:
-	 * - we have a top pi-waiter which is a SCHED_DEADLINE task AND
-	 * - our dl_boosted is set (i.e. the pi-waiter's (absolute) deadline is
-	 *   smaller than our deadline OR we are a !SCHED_DEADLINE task getting
-	 *   boosted due to a SCHED_DEADLINE pi-waiter).
-	 * Otherwise we keep our runtime and deadline.
-	 */
-	if (pi_task && dl_prio(pi_task->normal_prio) && p->dl.dl_boosted) {
-		pi_se = &pi_task->dl;
+	if (is_dl_boosted(&p->dl)) {
+		/*
+		 * Because of delays in the detection of the overrun of a
+		 * thread's runtime, it might be the case that a thread
+		 * goes to sleep in a rt mutex with negative runtime. As
+		 * a consequence, the thread will be throttled.
+		 *
+		 * While waiting for the mutex, this thread can also be
+		 * boosted via PI, resulting in a thread that is throttled
+		 * and boosted at the same time.
+		 *
+		 * In this case, the boost overrides the throttle.
+		 */
+		if (p->dl.dl_throttled) {
+			/*
+			 * The replenish timer needs to be canceled. No
+			 * problem if it fires concurrently: boosted threads
+			 * are ignored in dl_task_timer().
+			 */
+			hrtimer_try_to_cancel(&p->dl.dl_timer);
+			p->dl.dl_throttled = 0;
+		}
 	} else if (!dl_prio(p->normal_prio)) {
 		/*
-		 * Special case in which we have a !SCHED_DEADLINE task
-		 * that is going to be deboosted, but exceeds its
-		 * runtime while doing so. No point in replenishing
-		 * it, as it's going to return back to its original
-		 * scheduling class after this.
+		 * Special case in which we have a !SCHED_DEADLINE task that is going
+		 * to be deboosted, but exceeds its runtime while doing so. No point in
+		 * replenishing it, as it's going to return back to its original
+		 * scheduling class after this. If it has been throttled, we need to
+		 * clear the flag, otherwise the task may wake up as throttled after
+		 * being boosted again with no means to replenish the runtime and clear
+		 * the throttle.
 		 */
-		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		p->dl.dl_throttled = 0;
+		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
 		return;
 	}
 
@@ -1529,7 +1559,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		return;
 	}
 
-	enqueue_dl_entity(&p->dl, pi_se, flags);
+	enqueue_dl_entity(&p->dl, flags);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -2691,11 +2721,14 @@ void __dl_clear_params(struct task_struct *p)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
-	dl_se->dl_boosted		= 0;
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+
+#ifdef CONFIG_RT_MUTEXES
+	dl_se->pi_se			= dl_se;
+#endif
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index df556175be50..acd7e1221774 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -257,6 +257,7 @@ COND_SYSCALL_COMPAT(keyctl);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 998d141488a9..d2272fff2f59 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2748,6 +2748,16 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 
 	ftrace_startup_enable(command);
 
+	/*
+	 * If ftrace is in an undefined state, we just remove ops from list
+	 * to prevent the NULL pointer, instead of totally rolling it back and
+	 * free trampoline, because those actions could cause further damage.
+	 */
+	if (unlikely(ftrace_disabled)) {
+		__unregister_ftrace_function(ops);
+		return -ENODEV;
+	}
+
 	ops->flags &= ~FTRACE_OPS_FL_ADDING;
 
 	return 0;
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index d01f47135239..b805702de84d 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -27,10 +27,16 @@
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
+	/* Paired with WRITE_ONCE() in .proc_handler().
+	 * Changing two values seperately could be inconsistent
+	 * and some message could be lost.  (See: net_ratelimit_state).
+	 */
+	int interval = READ_ONCE(rs->interval);
+	int burst = READ_ONCE(rs->burst);
 	unsigned long flags;
 	int ret;
 
-	if (!rs->interval)
+	if (!interval)
 		return 1;
 
 	/*
@@ -45,7 +51,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	if (!rs->begin)
 		rs->begin = jiffies;
 
-	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+	if (time_is_before_jiffies(rs->begin + interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
 				printk_deferred(KERN_WARNING
@@ -57,7 +63,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin   = jiffies;
 		rs->printed = 0;
 	}
-	if (rs->burst && rs->burst > rs->printed) {
+	if (burst && burst > rs->printed) {
 		rs->printed++;
 		ret = 1;
 	} else {
diff --git a/mm/mmap.c b/mm/mmap.c
index 590840c3a3b5..5ee3c91450de 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1640,8 +1640,12 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
 		return 0;
 
-	/* Do we need to track softdirty? */
-	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
+	/*
+	 * Do we need to track softdirty? hugetlb does not support softdirty
+	 * tracking yet.
+	 */
+	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY) &&
+	    !is_vm_hugetlb_page(vma))
 		return 1;
 
 	/* Specialty mapping? */
@@ -2568,6 +2572,18 @@ static void unmap_region(struct mm_struct *mm,
 	tlb_gather_mmu(&tlb, mm, start, end);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
+
+	/*
+	 * Ensure we have no stale TLB entries by the time this mapping is
+	 * removed from the rmap.
+	 * Note that we don't have to worry about nested flushes here because
+	 * we're holding the mm semaphore for removing the mapping - so any
+	 * concurrent flush in this region has to be coming through the rmap,
+	 * and we synchronize against that using the rmap lock.
+	 */
+	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
+		tlb_flush_mmu(&tlb);
+
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
diff --git a/mm/rmap.c b/mm/rmap.c
index e578eb942317..3c2a43938152 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -82,7 +82,8 @@ static inline struct anon_vma *anon_vma_alloc(void)
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
 		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->degree = 1;	/* Reference for first vma */
+		anon_vma->num_children = 0;
+		anon_vma->num_active_vmas = 0;
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -190,6 +191,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 		anon_vma = anon_vma_alloc();
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
+		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
 	}
 
@@ -199,8 +201,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_link(vma, avc, anon_vma);
-		/* vma reference or self-parent link for new root */
-		anon_vma->degree++;
+		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
 	}
@@ -279,19 +280,19 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
-		 * Reuse existing anon_vma if its degree lower than two,
-		 * that means it has no vma and only one anon_vma child.
+		 * Reuse existing anon_vma if it has no vma and only one
+		 * anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
-		 * will always reuse it. Root anon_vma is never reused:
+		 * Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
-		if (!dst->anon_vma && anon_vma != src->anon_vma &&
-				anon_vma->degree < 2)
+		if (!dst->anon_vma &&
+		    anon_vma->num_children < 2 &&
+		    anon_vma->num_active_vmas == 0)
 			dst->anon_vma = anon_vma;
 	}
 	if (dst->anon_vma)
-		dst->anon_vma->degree++;
+		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
 
@@ -341,6 +342,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma = anon_vma_alloc();
 	if (!anon_vma)
 		goto out_error;
+	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
@@ -361,7 +363,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->degree++;
+	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
@@ -393,7 +395,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		 * to free them outside the lock.
 		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root.rb_root)) {
-			anon_vma->parent->degree--;
+			anon_vma->parent->num_children--;
 			continue;
 		}
 
@@ -401,7 +403,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma)
-		vma->anon_vma->degree--;
+		vma->anon_vma->num_active_vmas--;
 	unlock_anon_vma_root(root);
 
 	/*
@@ -412,7 +414,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		VM_WARN_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->num_children);
+		VM_WARN_ON(anon_vma->num_active_vmas);
 		put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0dfc47adccb1..65d20bdff023 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1826,11 +1826,11 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				c = l2cap_chan_hold_unless_zero(c);
-				if (c) {
-					read_unlock(&chan_list_lock);
-					return c;
-				}
+				if (!l2cap_chan_hold_unless_zero(c))
+					continue;
+
+				read_unlock(&chan_list_lock);
+				return c;
 			}
 
 			/* Closest match */
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 276b60262981..b21c8a317be7 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -33,18 +33,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)&initial_chain,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~(1 << NF_BR_BROUTING))
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table broute_table = {
 	.name		= "broute",
 	.table		= &initial_table,
 	.valid_hooks	= 1 << NF_BR_BROUTING,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 550324c516ee..c71795e4c18c 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -42,18 +42,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~FILTER_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_filter = {
 	.name		= "filter",
 	.table		= &initial_table,
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index c0fb3ca518af..44dde9e635e2 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -42,18 +42,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~NAT_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_nat = {
 	.name		= "nat",
 	.table		= &initial_table,
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f59230e4fc29..ea27bacbd005 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1003,8 +1003,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	/* the table doesn't like it */
-	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
+	if (repl->valid_hooks != t->valid_hooks)
 		goto free_unlock;
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
@@ -1197,11 +1196,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	if (ret != 0)
 		goto free_chainstack;
 
-	if (table->check && table->check(newinfo, table->valid_hooks)) {
-		ret = -EINVAL;
-		goto free_chainstack;
-	}
-
 	table->private = newinfo;
 	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
diff --git a/net/core/dev.c b/net/core/dev.c
index 42f6ff8b9703..880b096eef8a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4474,7 +4474,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_rx(skb);
 
@@ -4794,7 +4794,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_receive_skb(skb);
 
@@ -5146,7 +5146,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
@@ -5176,7 +5176,7 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		net_timestamp_check(netdev_tstamp_prequeue, skb);
+		net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 		skb_list_del_init(skb);
 		if (!skb_defer_rx_timestamp(skb))
 			list_add_tail(&skb->list, &sublist);
@@ -5851,7 +5851,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		net_rps_action_and_irq_enable(sd);
 	}
 
-	napi->weight = dev_rx_weight;
+	napi->weight = READ_ONCE(dev_rx_weight);
 	while (again) {
 		struct sk_buff *skb;
 
@@ -6335,8 +6335,8 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(netdev_budget_usecs);
-	int budget = netdev_budget;
+		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
+	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6233e9856016..73042407eb5b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -224,11 +224,26 @@ static int neigh_del_timer(struct neighbour *n)
 	return 0;
 }
 
-static void pneigh_queue_purge(struct sk_buff_head *list)
+static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 {
+	struct sk_buff_head tmp;
+	unsigned long flags;
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(list)) != NULL) {
+	skb_queue_head_init(&tmp);
+	spin_lock_irqsave(&list->lock, flags);
+	skb = skb_peek(list);
+	while (skb != NULL) {
+		struct sk_buff *skb_next = skb_peek_next(skb, list);
+		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
+			__skb_unlink(skb, list);
+			__skb_queue_tail(&tmp, skb);
+		}
+		skb = skb_next;
+	}
+	spin_unlock_irqrestore(&list->lock, flags);
+
+	while ((skb = __skb_dequeue(&tmp))) {
 		dev_put(skb->dev);
 		kfree_skb(skb);
 	}
@@ -297,9 +312,9 @@ int neigh_ifdown(struct neigh_table *tbl, struct net_device *dev)
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev);
 	pneigh_ifdown_and_unlock(tbl, dev);
-
-	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	if (skb_queue_empty_lockless(&tbl->proxy_queue))
+		del_timer_sync(&tbl->proxy_timer);
 	return 0;
 }
 EXPORT_SYMBOL(neigh_ifdown);
@@ -1614,7 +1629,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	/* It is not clean... Fix it to unload IPv6 module safely */
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, NULL);
 	neigh_ifdown(tbl, NULL);
 	if (atomic_read(&tbl->entries))
 		pr_crit("neighbour leakage\n");
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c623c129d0ab..e0be1f8651bb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4377,7 +4377,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
diff --git a/net/core/sock.c b/net/core/sock.c
index 79f085df52ce..cd23a8e4556c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2856,7 +2856,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	sk->sk_napi_id		=	0;
-	sk->sk_ll_usec		=	sysctl_net_busy_read;
+	sk->sk_ll_usec		=	READ_ONCE(sysctl_net_busy_read);
 #endif
 
 	sk->sk_max_pacing_rate = ~0U;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 0a0bf8062365..d7e39167ceca 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -231,14 +231,17 @@ static int set_default_qdisc(struct ctl_table *table, int write,
 static int proc_do_dev_weight(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int ret;
+	static DEFINE_MUTEX(dev_weight_mutex);
+	int ret, weight;
 
+	mutex_lock(&dev_weight_mutex);
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (ret != 0)
-		return ret;
-
-	dev_rx_weight = weight_p * dev_weight_rx_bias;
-	dev_tx_weight = weight_p * dev_weight_tx_bias;
+	if (!ret && write) {
+		weight = READ_ONCE(weight_p);
+		WRITE_ONCE(dev_rx_weight, weight * dev_weight_rx_bias);
+		WRITE_ONCE(dev_tx_weight, weight * dev_weight_tx_bias);
+	}
+	mutex_unlock(&dev_weight_mutex);
 
 	return ret;
 }
diff --git a/net/key/af_key.c b/net/key/af_key.c
index af67e0d265c0..337c6bc8211e 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1707,9 +1707,12 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 		pfk->registered |= (1<<hdr->sadb_msg_satype);
 	}
 
+	mutex_lock(&pfkey_mutex);
 	xfrm_probe_algs();
 
 	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&pfkey_mutex);
+
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 56cddadb65d0..92e0514f624f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -117,7 +117,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	---help---
 	This option enables for the list of known conntrack entries
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index e259454b6a64..4fac2d9a4b88 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -81,9 +81,21 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nft_data **data)
 {
-	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
-						    (1 << NF_INET_PRE_ROUTING) |
-						    (1 << NF_INET_FORWARD));
+	unsigned int hooks;
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_FORWARD);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
 static struct nft_expr_type nft_osf_type;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index fd87216bc0a9..5732b32ab932 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -332,6 +332,8 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
+	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
@@ -339,11 +341,15 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	priv->sreg        = nft_parse_register(tb[NFTA_PAYLOAD_SREG]);
 
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
-		priv->csum_type =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
-	if (tb[NFTA_PAYLOAD_CSUM_OFFSET])
-		priv->csum_offset =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
+	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
+		err = nft_parse_u32_check(tb[NFTA_PAYLOAD_CSUM_OFFSET], U8_MAX,
+					  &csum_offset);
+		if (err < 0)
+			return err;
+
+		priv->csum_offset = csum_offset;
+	}
 	if (tb[NFTA_PAYLOAD_CSUM_FLAGS]) {
 		u32 flags;
 
@@ -354,13 +360,14 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_validate_register_load(priv->sreg, priv->len);
 }
@@ -398,6 +405,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 {
 	enum nft_payload_bases base;
 	unsigned int offset, len;
+	int err;
 
 	if (tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
@@ -423,8 +431,13 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_PAYLOAD_DREG] == NULL)
 		return ERR_PTR(-EINVAL);
 
-	offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
-	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_LEN], U8_MAX, &len);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
 	    base != NFT_PAYLOAD_LL_HEADER)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 8ae948fd9dcf..3fc55c81f16a 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -104,6 +104,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index c318e5c9f6df..56eea298b8ef 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -99,7 +99,8 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if (!rose_loopback_neigh->dev) {
+			if (!rose_loopback_neigh->dev &&
+			    !rose_loopback_neigh->loopback) {
 				kfree_skb(skb);
 				continue;
 			}
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index cad2586c3473..c966dacf1130 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -397,7 +397,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 
 void __qdisc_run(struct Qdisc *q)
 {
-	int quota = dev_tx_weight;
+	int quota = READ_ONCE(dev_tx_weight);
 	int packets;
 
 	while (qdisc_restart(q, &packets)) {
diff --git a/net/socket.c b/net/socket.c
index e5cc9f2b981e..a5167f03c31d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1619,7 +1619,7 @@ int __sys_listen(int fd, int backlog)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
-		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
+		somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
 		if ((unsigned int)backlog > somaxconn)
 			backlog = somaxconn;
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 3582f77bab6a..1cd21a8c4dea 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2403,6 +2403,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
+				xfrm_pol_put(pols[0]);
 				return 0;
 			}
 			pols[1]->curlft.use_time = ktime_get_real_seconds();
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 51884c7b8069..4eac2ecb35fb 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -51,8 +51,7 @@ obj := $(KBUILD_EXTMOD)
 src := $(obj)
 
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
-include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
-             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
 endif
 
 include scripts/Makefile.lib
diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 3c789d03b629..0ae7a7415414 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -359,15 +359,15 @@ static struct bpf_align_test tests[] = {
 			 * is still (4n), fixed offset is not changed.
 			 * Also, we create a new reg->id.
 			 */
-			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (18)
 			 * which is 20.  Then the variable offset is (4n), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
-			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
 		},
 	},
 	{
@@ -410,15 +410,15 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{9, "R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* Packet pointer has (4n+2) offset */
-			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* Newly read value in R6 was shifted left by 2, so has
 			 * known alignment of 4.
 			 */
@@ -426,15 +426,15 @@ static struct bpf_align_test tests[] = {
 			/* Added (4n) to packet pointer's (4n+2) var_off, giving
 			 * another (4n+2).
 			 */
-			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
-			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
+			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 		},
 	},
 	{
@@ -469,11 +469,11 @@ static struct bpf_align_test tests[] = {
 		.matches = {
 			{4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
 			/* (ptr - ptr) << 2 == unknown, (4n) */
-			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
 			/* (4n) + 14 == (4n+2).  We blow our bounds, because
 			 * the add could overflow.
 			 */
-			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
 			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 			/* packet pointer + nonnegative (4n+2) */
@@ -528,7 +528,7 @@ static struct bpf_align_test tests[] = {
 			/* New unknown value in R7 is (4n) */
 			{11, "R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Subtracting it from R6 blows our unsigned bounds */
-			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
+			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>= 0 */
 			{14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* At the time the word size load is performed from R5,
@@ -537,7 +537,8 @@ static struct bpf_align_test tests[] = {
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
+
 		},
 	},
 	{
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 858e55143233..9a103bd3542c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -9108,10 +9108,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9166,10 +9166,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9279,9 +9279,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9451,9 +9451,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9564,10 +9564,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9622,10 +9622,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9735,9 +9735,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9907,9 +9907,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
