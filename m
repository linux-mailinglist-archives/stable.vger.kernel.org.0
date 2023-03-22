Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7156C5430
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCVSxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjCVSxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658FA423D;
        Wed, 22 Mar 2023 11:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAC5862214;
        Wed, 22 Mar 2023 18:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43193C433D2;
        Wed, 22 Mar 2023 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511190;
        bh=1F+5o+uK40vUlqQ6vHligMAT42G55ytlpOM/O6x/GDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/s8c+h+CN39vrVPNyPy5VaBc+hOSlaVeEQbS1eV//sTaQtkoOtpnMofDTN8X8KO1
         0u2xh66AOp7ICGCkdrRCL2ulg6w8ipa/ftaXOdckRvcnVLF/hvqwvUbwiaUnLqgWFn
         qNSdtt/n8tQO4zD/xeVNGIkJ1wa9m9jU55c26qSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.21
Date:   Wed, 22 Mar 2023 19:52:53 +0100
Message-Id: <167951117357159@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <16795111732969@kroah.com>
References: <16795111732969@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 2b55f71e2ae1..b5e8b8af8afb 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1221,7 +1221,7 @@ defined:
 	return
 	-ECHILD and it will be called again in ref-walk mode.
 
-``_weak_revalidate``
+``d_weak_revalidate``
 	called when the VFS needs to revalidate a "jumped" dentry.  This
 	is called when a path-walk ends at dentry that was not acquired
 	by doing a lookup in the parent directory.  This includes "/",
diff --git a/Makefile b/Makefile
index a842ec6d1932..0a9f0770bdf3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 20
+SUBLEVEL = 21
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index 786735dcc8d6..d2b7d5df132a 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -135,16 +135,17 @@ static int get_timer_irq(void)
 
 int constant_clockevent_init(void)
 {
-	int irq;
 	unsigned int cpu = smp_processor_id();
 	unsigned long min_delta = 0x600;
 	unsigned long max_delta = (1UL << 48) - 1;
 	struct clock_event_device *cd;
-	static int timer_irq_installed = 0;
+	static int irq = 0, timer_irq_installed = 0;
 
-	irq = get_timer_irq();
-	if (irq < 0)
-		pr_err("Failed to map irq %d (timer)\n", irq);
+	if (!timer_irq_installed) {
+		irq = get_timer_irq();
+		if (irq < 0)
+			pr_err("Failed to map irq %d (timer)\n", irq);
+	}
 
 	cd = &per_cpu(constant_clockevent_device, cpu);
 
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 4fd630efe39d..894d48cd0492 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -146,19 +146,6 @@ CFLAGS-$(CONFIG_PPC32)	+= $(call cc-option, $(MULTIPLEWORD))
 
 CFLAGS-$(CONFIG_PPC32)	+= $(call cc-option,-mno-readonly-in-sdata)
 
-ifdef CONFIG_PPC_BOOK3S_64
-ifdef CONFIG_CPU_LITTLE_ENDIAN
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power8
-else
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power4
-endif
-CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power10,	\
-				  $(call cc-option,-mtune=power9,	\
-				  $(call cc-option,-mtune=power8)))
-else ifdef CONFIG_PPC_BOOK3E_64
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
-endif
-
 ifdef CONFIG_FUNCTION_TRACER
 CC_FLAGS_FTRACE := -pg
 ifdef CONFIG_MPROFILE_KERNEL
@@ -166,11 +153,12 @@ CC_FLAGS_FTRACE += -mprofile-kernel
 endif
 endif
 
-CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
-AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
+CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += -mcpu=$(CONFIG_TARGET_CPU)
+AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += -mcpu=$(CONFIG_TARGET_CPU)
 
-CFLAGS-$(CONFIG_E5500_CPU) += $(call cc-option,-mcpu=e500mc64,-mcpu=powerpc64)
-CFLAGS-$(CONFIG_E6500_CPU) += $(call cc-option,-mcpu=e6500,$(E5500_CPU))
+CFLAGS-$(CONFIG_POWERPC64_CPU) += $(call cc-option,-mtune=power10,	\
+				  $(call cc-option,-mtune=power9,	\
+				  $(call cc-option,-mtune=power8)))
 
 asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
 
@@ -213,10 +201,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # often slow when they are implemented at all
 KBUILD_CFLAGS		+= $(call cc-option,-mno-string)
 
-cpu-as-$(CONFIG_40x)		+= -Wa,-m405
-cpu-as-$(CONFIG_44x)		+= -Wa,-m440
 cpu-as-$(CONFIG_ALTIVEC)	+= $(call as-option,-Wa$(comma)-maltivec)
-cpu-as-$(CONFIG_PPC_E500)		+= -Wa,-me500
 
 # When using '-many -mpower4' gas will first try and find a matching power4
 # mnemonic and failing that it will allow any valid mnemonic that GAS knows
@@ -224,7 +209,6 @@ cpu-as-$(CONFIG_PPC_E500)		+= -Wa,-me500
 # LLVM IAS doesn't understand either flag: https://github.com/ClangBuiltLinux/linux/issues/675
 # but LLVM IAS only supports ISA >= 2.06 for Book3S 64 anyway...
 cpu-as-$(CONFIG_PPC_BOOK3S_64)	+= $(call as-option,-Wa$(comma)-mpower4) $(call as-option,-Wa$(comma)-many)
-cpu-as-$(CONFIG_PPC_E500MC)	+= $(call as-option,-Wa$(comma)-me500mc)
 
 KBUILD_AFLAGS += $(cpu-as-y)
 KBUILD_CFLAGS += $(cpu-as-y)
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index d32d95aea5d6..295f76df13b5 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -39,13 +39,19 @@ BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 $(LINUXINCLUDE)
 
 ifdef CONFIG_PPC64_BOOT_WRAPPER
-ifdef CONFIG_CPU_LITTLE_ENDIAN
-BOOTCFLAGS	+= -m64 -mcpu=powerpc64le
+BOOTCFLAGS	+= -m64
 else
-BOOTCFLAGS	+= -m64 -mcpu=powerpc64
+BOOTCFLAGS	+= -m32
 endif
+
+ifdef CONFIG_TARGET_CPU_BOOL
+BOOTCFLAGS	+= -mcpu=$(CONFIG_TARGET_CPU)
+else ifdef CONFIG_PPC64_BOOT_WRAPPER
+ifdef CONFIG_CPU_LITTLE_ENDIAN
+BOOTCFLAGS	+= -mcpu=powerpc64le
 else
-BOOTCFLAGS	+= -m32 -mcpu=powerpc
+BOOTCFLAGS	+= -mcpu=powerpc64
+endif
 endif
 
 BOOTCFLAGS	+= -isystem $(shell $(BOOTCC) -print-file-name=include)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 2bef19cc1b98..af46aa88422b 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -271,11 +271,16 @@ static bool access_error(bool is_write, bool is_exec, struct vm_area_struct *vma
 	}
 
 	/*
-	 * Check for a read fault.  This could be caused by a read on an
-	 * inaccessible page (i.e. PROT_NONE), or a Radix MMU execute-only page.
+	 * VM_READ, VM_WRITE and VM_EXEC all imply read permissions, as
+	 * defined in protection_map[].  Read faults can only be caused by
+	 * a PROT_NONE mapping, or with a PROT_EXEC-only mapping on Radix.
 	 */
-	if (unlikely(!(vma->vm_flags & VM_READ)))
+	if (unlikely(!vma_is_accessible(vma)))
 		return true;
+
+	if (unlikely(radix_enabled() && ((vma->vm_flags & VM_ACCESS_FLAGS) == VM_EXEC)))
+		return true;
+
 	/*
 	 * We should ideally do the vma pkey access check here. But in the
 	 * fault path, handle_mm_fault() also does the same check. To avoid
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 0c4eed9aea80..54d655a647ce 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -118,19 +118,18 @@ endchoice
 
 choice
 	prompt "CPU selection"
-	default GENERIC_CPU
 	help
 	  This will create a kernel which is optimised for a particular CPU.
 	  The resulting kernel may not run on other CPUs, so use this with care.
 
 	  If unsure, select Generic.
 
-config GENERIC_CPU
+config POWERPC64_CPU
 	bool "Generic (POWER5 and PowerPC 970 and above)"
 	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
 	select PPC_64S_HASH_MMU
 
-config GENERIC_CPU
+config POWERPC64_CPU
 	bool "Generic (POWER8 and above)"
 	depends on PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
 	select ARCH_HAS_FAST_MULTIPLIER
@@ -143,6 +142,7 @@ config POWERPC_CPU
 config CELL_CPU
 	bool "Cell Broadband Engine"
 	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
+	depends on !CC_IS_CLANG
 	select PPC_64S_HASH_MMU
 
 config PPC_970_CPU
@@ -184,10 +184,12 @@ config E5500_CPU
 config E6500_CPU
 	bool "Freescale e6500"
 	depends on PPC64 && PPC_E500
+	depends on !CC_IS_CLANG
 
 config 405_CPU
 	bool "40x family"
 	depends on 40x
+	depends on !CC_IS_CLANG
 
 config 440_CPU
 	bool "440 (44x family)"
@@ -196,22 +198,27 @@ config 440_CPU
 config 464_CPU
 	bool "464 (44x family)"
 	depends on 44x
+	depends on !CC_IS_CLANG
 
 config 476_CPU
 	bool "476 (47x family)"
 	depends on PPC_47x
+	depends on !CC_IS_CLANG
 
 config 860_CPU
 	bool "8xx family"
 	depends on PPC_8xx
+	depends on !CC_IS_CLANG
 
 config E300C2_CPU
 	bool "e300c2 (832x)"
 	depends on PPC_BOOK3S_32
+	depends on !CC_IS_CLANG
 
 config E300C3_CPU
 	bool "e300c3 (831x)"
 	depends on PPC_BOOK3S_32
+	depends on !CC_IS_CLANG
 
 config G4_CPU
 	bool "G4 (74xx)"
@@ -228,13 +235,12 @@ config E500MC_CPU
 
 config TOOLCHAIN_DEFAULT_CPU
 	bool "Rely on the toolchain's implicit default CPU"
-	depends on PPC32
 
 endchoice
 
 config TARGET_CPU_BOOL
 	bool
-	default !GENERIC_CPU && !TOOLCHAIN_DEFAULT_CPU
+	default !TOOLCHAIN_DEFAULT_CPU
 
 config TARGET_CPU
 	string
@@ -246,6 +252,10 @@ config TARGET_CPU
 	default "power8" if POWER8_CPU
 	default "power9" if POWER9_CPU
 	default "power10" if POWER10_CPU
+	default "e5500" if E5500_CPU
+	default "e6500" if E6500_CPU
+	default "power4" if POWERPC64_CPU && !CPU_LITTLE_ENDIAN
+	default "power8" if POWERPC64_CPU && CPU_LITTLE_ENDIAN
 	default "405" if 405_CPU
 	default "440" if 440_CPU
 	default "464" if 464_CPU
diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index 5ff1f19fd45c..0099dc116168 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,8 +19,6 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
-	/* A local tlb flush is needed before user execution can resume. */
-	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 907b9efd39a8..801019381dea 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,24 +22,6 @@ static inline void local_flush_tlb_page(unsigned long addr)
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
-
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 80ce9caba8d2..0f784e3d307b 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,16 +196,6 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
-#ifdef CONFIG_SMP
-	else {
-		cpumask_t *mask = &mm->context.tlb_stale_mask;
-
-		if (cpumask_test_cpu(cpu, mask)) {
-			cpumask_clear_cpu(cpu, mask);
-			local_flush_tlb_all_asid(cntx & asid_mask);
-		}
-	}
-#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
@@ -215,12 +205,24 @@ static void set_mm_noasid(struct mm_struct *mm)
 	local_flush_tlb_all();
 }
 
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
-	if (static_branch_unlikely(&use_asid_allocator))
-		set_mm_asid(mm, cpu);
-	else
-		set_mm_noasid(mm);
+	/*
+	 * The mm_cpumask indicates which harts' TLBs contain the virtual
+	 * address mapping of the mm. Compared to noasid, using asid
+	 * can't guarantee that stale TLB entries are invalidated because
+	 * the asid mechanism wouldn't flush TLB for every switch_mm for
+	 * performance. So when using asid, keep all CPUs footmarks in
+	 * cpumask() until mm reset.
+	 */
+	cpumask_set_cpu(cpu, mm_cpumask(next));
+	if (static_branch_unlikely(&use_asid_allocator)) {
+		set_mm_asid(next, cpu);
+	} else {
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+		set_mm_noasid(next);
+	}
 }
 
 static int __init asids_init(void)
@@ -274,7 +276,8 @@ static int __init asids_init(void)
 }
 early_initcall(asids_init);
 #else
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
 	/* Nothing to do here when there is no MMU */
 }
@@ -327,10 +330,7 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 */
 	cpu = smp_processor_id();
 
-	cpumask_clear_cpu(cpu, mm_cpumask(prev));
-	cpumask_set_cpu(cpu, mm_cpumask(next));
-
-	set_mm(next, cpu);
+	set_mm(prev, next, cpu);
 
 	flush_icache_deferred(next, cpu);
 }
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index ce7dfc81bb3f..37ed760d007c 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,7 +5,23 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-#include <asm/tlbflush.h>
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
 
 void flush_tlb_all(void)
 {
@@ -15,7 +31,6 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
-	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	unsigned int cpuid;
 	bool broadcast;
@@ -29,15 +44,6 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
-		/*
-		 * TLB will be immediately flushed on harts concurrently
-		 * executing this MM context. TLB flush on other harts
-		 * is deferred until this MM context migrates there.
-		 */
-		cpumask_setall(pmask);
-		cpumask_clear_cpu(cpuid, pmask);
-		cpumask_andnot(pmask, pmask, cmask);
-
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {
diff --git a/arch/s390/boot/ipl_report.c b/arch/s390/boot/ipl_report.c
index 9b14045065b6..74b5cd264862 100644
--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ static unsigned long find_bootdata_space(struct ipl_rb_components *comps,
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size &&
 	    intersects(initrd_data.start, initrd_data.size, safe_addr, size))
 		safe_addr = initrd_data.start + initrd_data.size;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 73cdc5539384..2c99f9552b2f 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -544,8 +544,7 @@ static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
 	return r;
 }
 
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources)
+int zpci_setup_bus_resources(struct zpci_dev *zdev)
 {
 	unsigned long addr, size, flags;
 	struct resource *res;
@@ -581,7 +580,6 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 			return -ENOMEM;
 		}
 		zdev->bars[i].res = res;
-		pci_add_resource(resources, res);
 	}
 	zdev->has_resources = 1;
 
@@ -590,17 +588,23 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 
 static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
 {
+	struct resource *res;
 	int i;
 
+	pci_lock_rescan_remove();
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-		if (!zdev->bars[i].size || !zdev->bars[i].res)
+		res = zdev->bars[i].res;
+		if (!res)
 			continue;
 
+		release_resource(res);
+		pci_bus_remove_resource(zdev->zbus->bus, res);
 		zpci_free_iomap(zdev, zdev->bars[i].map_idx);
-		release_resource(zdev->bars[i].res);
-		kfree(zdev->bars[i].res);
+		zdev->bars[i].res = NULL;
+		kfree(res);
 	}
 	zdev->has_resources = 0;
+	pci_unlock_rescan_remove();
 }
 
 int pcibios_device_add(struct pci_dev *pdev)
diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 6a8da1b742ae..a99926af2b69 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -41,9 +41,7 @@ static int zpci_nb_devices;
  */
 static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 {
-	struct resource_entry *window, *n;
-	struct resource *res;
-	int rc;
+	int rc, i;
 
 	if (!zdev_enabled(zdev)) {
 		rc = zpci_enable_device(zdev);
@@ -57,10 +55,10 @@ static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 	}
 
 	if (!zdev->has_resources) {
-		zpci_setup_bus_resources(zdev, &zdev->zbus->resources);
-		resource_list_for_each_entry_safe(window, n, &zdev->zbus->resources) {
-			res = window->res;
-			pci_bus_add_resource(zdev->zbus->bus, res, 0);
+		zpci_setup_bus_resources(zdev);
+		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+			if (zdev->bars[i].res)
+				pci_bus_add_resource(zdev->zbus->bus, zdev->bars[i].res, 0);
 		}
 	}
 
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index e96c9860e064..af9f0ac79a1b 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -30,8 +30,7 @@ static inline void zpci_zdev_get(struct zpci_dev *zdev)
 
 int zpci_alloc_domain(int domain);
 void zpci_free_domain(int domain);
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources);
+int zpci_setup_bus_resources(struct zpci_dev *zdev);
 
 static inline struct zpci_dev *zdev_from_bus(struct pci_bus *bus,
 					     unsigned int devfn)
diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index b3c1ae084180..d2e95d1d4db7 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -1,6 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
 core-y += arch/x86/crypto/
 
+#
+# Disable SSE and other FP/SIMD instructions to match normal x86
+#
+KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
+KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
+
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b8357d6ecd47..b63be696b776 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -128,8 +128,9 @@ struct snp_psc_desc {
 	struct psc_entry entries[VMGEXIT_PSC_MAX_ENTRY];
 } __packed;
 
-/* Guest message request error code */
+/* Guest message request error codes */
 #define SNP_GUEST_REQ_INVALID_LEN	BIT_ULL(32)
+#define SNP_GUEST_REQ_ERR_BUSY		BIT_ULL(33)
 
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..236fda748ae9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,20 +256,22 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
 
 /*
- * For AVIC, the max index allowed for physical APIC ID
- * table is 0xff (255).
+ * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
+ * 0xff is a broadcast to all CPUs, i.e. can't be targeted individually.
  */
 #define AVIC_MAX_PHYSICAL_ID		0XFEULL
 
 /*
- * For x2AVIC, the max index allowed for physical APIC ID
- * table is 0x1ff (511).
+ * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
+static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2c8ec5c71712..e228d58ee264 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2365,6 +2365,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 1dafbdc5ac31..84f23327caed 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -374,7 +374,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 {
 	struct resctrl_schema *s;
 	struct rdtgroup *rdtgrp;
-	struct rdt_domain *dom;
 	struct rdt_resource *r;
 	char *tok, *resname;
 	int ret = 0;
@@ -403,10 +402,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		goto out;
 	}
 
-	list_for_each_entry(s, &resctrl_schema_all, list) {
-		list_for_each_entry(dom, &s->res->domains, list)
-			memset(dom->staged_config, 0, sizeof(dom->staged_config));
-	}
+	rdt_staged_configs_clear();
 
 	while ((tok = strsep(&buf, "\n")) != NULL) {
 		resname = strim(strsep(&tok, ":"));
@@ -451,6 +447,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	}
 
 out:
+	rdt_staged_configs_clear();
 	rdtgroup_kn_unlock(of->kn);
 	cpus_read_unlock();
 	return ret ?: nbytes;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5f7128686cfd..0b5c6c76f6f7 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -537,5 +537,6 @@ bool has_busy_rmid(struct rdt_resource *r, struct rdt_domain *d);
 void __check_limbo(struct rdt_domain *d, bool force_free);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void __init thread_throttle_mode_init(void);
+void rdt_staged_configs_clear(void);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 87b670d540b8..c7f1c7cb1963 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -78,6 +78,19 @@ void rdt_last_cmd_printf(const char *fmt, ...)
 	va_end(ap);
 }
 
+void rdt_staged_configs_clear(void)
+{
+	struct rdt_resource *r;
+	struct rdt_domain *dom;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	for_each_alloc_capable_rdt_resource(r) {
+		list_for_each_entry(dom, &r->domains, list)
+			memset(dom->staged_config, 0, sizeof(dom->staged_config));
+	}
+}
+
 /*
  * Trivial allocator for CLOSIDs. Since h/w only supports a small number,
  * we can keep a bitmap of free CLOSIDs in a single integer.
@@ -2851,7 +2864,9 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 {
 	struct resctrl_schema *s;
 	struct rdt_resource *r;
-	int ret;
+	int ret = 0;
+
+	rdt_staged_configs_clear();
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
@@ -2862,20 +2877,22 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 		} else {
 			ret = rdtgroup_init_cat(s, rdtgrp->closid);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 
 		ret = resctrl_arch_update_domains(r, rdtgrp->closid);
 		if (ret < 0) {
 			rdt_last_cmd_puts("Failed to initialize allocations\n");
-			return ret;
+			goto out;
 		}
 
 	}
 
 	rdtgrp->mode = RDT_MODE_SHAREABLE;
 
-	return 0;
+out:
+	rdt_staged_configs_clear();
+	return ret;
 }
 
 static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 2a4be92fd144..6233c5b4c10b 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -134,9 +134,11 @@ SYM_TYPED_FUNC_START(ftrace_stub)
 	RET
 SYM_FUNC_END(ftrace_stub)
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 SYM_TYPED_FUNC_START(ftrace_stub_graph)
 	RET
 SYM_FUNC_END(ftrace_stub_graph)
+#endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a428c62330d3..c680ac6342bb 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2183,9 +2183,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 	struct ghcb *ghcb;
 	int ret;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		return -ENODEV;
-
 	if (!fw_err)
 		return -EINVAL;
 
@@ -2212,15 +2209,26 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 	if (ret)
 		goto e_put;
 
-	if (ghcb->save.sw_exit_info_2) {
-		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN)
-			input->data_npages = ghcb_get_rbx(ghcb);
+	*fw_err = ghcb->save.sw_exit_info_2;
+	switch (*fw_err) {
+	case 0:
+		break;
 
-		*fw_err = ghcb->save.sw_exit_info_2;
+	case SNP_GUEST_REQ_ERR_BUSY:
+		ret = -EAGAIN;
+		break;
 
+	case SNP_GUEST_REQ_INVALID_LEN:
+		/* Number of expected pages are returned in RBX */
+		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+			input->data_npages = ghcb_get_rbx(ghcb);
+			ret = -ENOSPC;
+			break;
+		}
+		fallthrough;
+	default:
 		ret = -EIO;
+		break;
 	}
 
 e_put:
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 97ad0661f963..e910ec5a0cc0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,19 +27,29 @@
 #include "irq.h"
 #include "svm.h"
 
-/* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS		8
-#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
+/*
+ * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
+ * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
+ * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ *
+ * For the vCPU ID, use however many bits are currently allowed for the max
+ * guest physical APIC ID (limited by the size of the physical ID table), and
+ * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
+ * size of the GATag is defined by hardware (32 bits), but is an opaque value
+ * as far as hardware is concerned.
+ */
+#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
-#define AVIC_VM_ID_BITS			24
-#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
-#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
+#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
-#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
 						(y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index df8995977ec2..1d00f7824da1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2999,7 +2999,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3025,6 +3025,13 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					   vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
+		return -EINVAL;
+
+	if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    CC(ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -3036,7 +3043,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index f415498d3175..d94ebd8acdfd 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -600,7 +600,8 @@ void __init sme_enable(struct boot_params *bp)
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fe0a3a882f46..aa67a52c5a06 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2711,6 +2711,7 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 	struct blk_mq_hw_ctx *this_hctx = NULL;
 	struct blk_mq_ctx *this_ctx = NULL;
 	struct request *requeue_list = NULL;
+	struct request **requeue_lastp = &requeue_list;
 	unsigned int depth = 0;
 	LIST_HEAD(list);
 
@@ -2721,10 +2722,10 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 			this_hctx = rq->mq_hctx;
 			this_ctx = rq->mq_ctx;
 		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			rq_list_add(&requeue_list, rq);
+			rq_list_add_tail(&requeue_lastp, rq);
 			continue;
 		}
-		list_add_tail(&rq->queuelist, &list);
+		list_add(&rq->queuelist, &list);
 		depth++;
 	} while (!rq_list_empty(plug->mq_list));
 
diff --git a/drivers/acpi/pptt.c b/drivers/acpi/pptt.c
index c91342dcbcd6..ced3eb15bd8b 100644
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -537,16 +537,19 @@ static int topology_get_acpi_cpu_tag(struct acpi_table_header *table,
 static struct acpi_table_header *acpi_get_pptt(void)
 {
 	static struct acpi_table_header *pptt;
+	static bool is_pptt_checked;
 	acpi_status status;
 
 	/*
 	 * PPTT will be used at runtime on every CPU hotplug in path, so we
 	 * don't need to call acpi_put_table() to release the table mapping.
 	 */
-	if (!pptt) {
+	if (!pptt && !is_pptt_checked) {
 		status = acpi_get_table(ACPI_SIG_PPTT, 0, &pptt);
 		if (ACPI_FAILURE(status))
 			acpi_pptt_warn_missing();
+
+		is_pptt_checked = true;
 	}
 
 	return pptt;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 981464e561df..793ae876918c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1853,35 +1853,44 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
+	struct cgroup_subsys_state *cmd_blkcg_css = cmd->blkcg_css;
+	struct cgroup_subsys_state *cmd_memcg_css = cmd->memcg_css;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	const bool write = op_is_write(req_op(rq));
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
+	const bool use_aio = cmd->use_aio;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
 	}
 
-	if (cmd->blkcg_css)
-		kthread_associate_blkcg(cmd->blkcg_css);
-	if (cmd->memcg_css)
+	if (cmd_blkcg_css)
+		kthread_associate_blkcg(cmd_blkcg_css);
+	if (cmd_memcg_css)
 		old_memcg = set_active_memcg(
-			mem_cgroup_from_css(cmd->memcg_css));
+			mem_cgroup_from_css(cmd_memcg_css));
 
+	/*
+	 * do_req_filebacked() may call blk_mq_complete_request() synchronously
+	 * or asynchronously if using aio. Hence, do not touch 'cmd' after
+	 * do_req_filebacked() has returned unless we are sure that 'cmd' has
+	 * not yet been completed.
+	 */
 	ret = do_req_filebacked(lo, rq);
 
-	if (cmd->blkcg_css)
+	if (cmd_blkcg_css)
 		kthread_associate_blkcg(NULL);
 
-	if (cmd->memcg_css) {
+	if (cmd_memcg_css) {
 		set_active_memcg(old_memcg);
-		css_put(cmd->memcg_css);
+		css_put(cmd_memcg_css);
 	}
  failed:
 	/* complete non-aio request */
-	if (!cmd->use_aio || ret) {
+	if (!use_aio || ret) {
 		if (ret == -EOPNOTSUPP)
 			cmd->ret = ret;
 		else
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 1f154f92f4c2..af419af9a0f4 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1393,8 +1393,7 @@ static inline void nullb_complete_cmd(struct nullb_cmd *cmd)
 	case NULL_IRQ_SOFTIRQ:
 		switch (cmd->nq->dev->queue_mode) {
 		case NULL_Q_MQ:
-			if (likely(!blk_should_fake_timeout(cmd->rq->q)))
-				blk_mq_complete_request(cmd->rq);
+			blk_mq_complete_request(cmd->rq);
 			break;
 		case NULL_Q_BIO:
 			/*
@@ -1655,7 +1654,8 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->rq = bd->rq;
 	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
-	cmd->fake_timeout = should_timeout_request(bd->rq);
+	cmd->fake_timeout = should_timeout_request(bd->rq) ||
+		blk_should_fake_timeout(bd->rq->q);
 
 	blk_mq_start_request(bd->rq);
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index fb855da971ee..9fa821fa76b0 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -972,6 +972,8 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	print_version();
 
 	hp = mdesc_grab();
+	if (!hp)
+		return -ENODEV;
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index d79905f3e174..5da82f2bdd21 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -92,7 +92,7 @@ config COMMON_CLK_RK808
 config COMMON_CLK_HI655X
 	tristate "Clock driver for Hi655x" if EXPERT
 	depends on (MFD_HI655X_PMIC || COMPILE_TEST)
-	depends on REGMAP
+	select REGMAP
 	default MFD_HI655X_PMIC
 	help
 	  This driver supports the hi655x PMIC clock. This
diff --git a/drivers/cpuidle/cpuidle-psci-domain.c b/drivers/cpuidle/cpuidle-psci-domain.c
index 821984947ed9..fe0664472520 100644
--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -103,7 +103,8 @@ static void psci_pd_remove(void)
 	struct psci_pd_provider *pd_provider, *it;
 	struct generic_pm_domain *genpd;
 
-	list_for_each_entry_safe(pd_provider, it, &psci_pd_providers, link) {
+	list_for_each_entry_safe_reverse(pd_provider, it,
+					 &psci_pd_providers, link) {
 		of_genpd_del_provider(pd_provider->node);
 
 		genpd = of_genpd_remove_last(pd_provider->node);
diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index ff5cabe70a2b..6587fa8570dc 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -206,7 +206,7 @@ static int do_feature_check_call(const u32 api_id)
 	}
 
 	/* Add new entry if not present */
-	feature_data = kmalloc(sizeof(*feature_data), GFP_KERNEL);
+	feature_data = kmalloc(sizeof(*feature_data), GFP_ATOMIC);
 	if (!feature_data)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 087147f09933..3b8825a3e233 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1695,7 +1695,7 @@ static int psp_hdcp_initialize(struct psp_context *psp)
 	psp->hdcp_context.context.mem_context.shared_mem_size = PSP_HDCP_SHARED_MEM_SIZE;
 	psp->hdcp_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->hdcp_context.context.initialized) {
+	if (!psp->hdcp_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->hdcp_context.context.mem_context);
 		if (ret)
 			return ret;
@@ -1762,7 +1762,7 @@ static int psp_dtm_initialize(struct psp_context *psp)
 	psp->dtm_context.context.mem_context.shared_mem_size = PSP_DTM_SHARED_MEM_SIZE;
 	psp->dtm_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->dtm_context.context.initialized) {
+	if (!psp->dtm_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->dtm_context.context.mem_context);
 		if (ret)
 			return ret;
@@ -1830,7 +1830,7 @@ static int psp_rap_initialize(struct psp_context *psp)
 	psp->rap_context.context.mem_context.shared_mem_size = PSP_RAP_SHARED_MEM_SIZE;
 	psp->rap_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->rap_context.context.initialized) {
+	if (!psp->rap_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->rap_context.context.mem_context);
 		if (ret)
 			return ret;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 65a1d4f9004b..a75e1af77365 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -59,6 +59,7 @@ static int kfd_gtt_sa_init(struct kfd_dev *kfd, unsigned int buf_size,
 				unsigned int chunk_size);
 static void kfd_gtt_sa_fini(struct kfd_dev *kfd);
 
+static int kfd_resume_iommu(struct kfd_dev *kfd);
 static int kfd_resume(struct kfd_dev *kfd);
 
 static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
@@ -634,7 +635,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	svm_migrate_init(kfd->adev);
 
-	if (kgd2kfd_resume_iommu(kfd))
+	if (kfd_resume_iommu(kfd))
 		goto device_iommu_error;
 
 	if (kfd_resume(kfd))
@@ -782,6 +783,14 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 }
 
 int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
+{
+	if (!kfd->init_complete)
+		return 0;
+
+	return kfd_resume_iommu(kfd);
+}
+
+static int kfd_resume_iommu(struct kfd_dev *kfd)
 {
 	int err = 0;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 729d26d648af..2880ed96ac2e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -778,16 +778,13 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	struct kfd_event_waiter *event_waiters;
 	uint32_t i;
 
-	event_waiters = kmalloc_array(num_events,
-					sizeof(struct kfd_event_waiter),
-					GFP_KERNEL);
+	event_waiters = kcalloc(num_events, sizeof(struct kfd_event_waiter),
+				GFP_KERNEL);
 	if (!event_waiters)
 		return NULL;
 
-	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
+	for (i = 0; i < num_events; i++)
 		init_wait(&event_waiters[i].wait);
-		event_waiters[i].activated = false;
-	}
 
 	return event_waiters;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 8c5045711264..c20e9f76f021 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -992,8 +992,5 @@ void dcn30_prepare_bandwidth(struct dc *dc,
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
-
-	dc_dmub_srv_p_state_delegate(dc,
-		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index d70c64a9fcb2..26fc5cad7a77 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1883,6 +1883,7 @@ int dcn32_populate_dml_pipes_from_context(
 	bool subvp_in_use = false;
 	uint8_t is_pipe_split_expected[MAX_PIPES] = {0};
 	struct dc_crtc_timing *timing;
+	bool vsr_odm_support = false;
 
 	dcn20_populate_dml_pipes_from_context(dc, context, pipes, fast_validate);
 
@@ -1900,12 +1901,15 @@ int dcn32_populate_dml_pipes_from_context(
 		timing = &pipe->stream->timing;
 
 		pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_dal;
+		vsr_odm_support = (res_ctx->pipe_ctx[i].stream->src.width >= 5120 &&
+				res_ctx->pipe_ctx[i].stream->src.width > res_ctx->pipe_ctx[i].stream->dst.width);
 		if (context->stream_count == 1 &&
 				context->stream_status[0].plane_count == 1 &&
 				!dc_is_hdmi_signal(res_ctx->pipe_ctx[i].stream->signal) &&
 				is_h_timing_divisible_by_2(res_ctx->pipe_ctx[i].stream) &&
 				pipe->stream->timing.pix_clk_100hz * 100 > DCN3_2_VMIN_DISPCLK_HZ &&
-				dc->debug.enable_single_display_2to1_odm_policy) {
+				dc->debug.enable_single_display_2to1_odm_policy &&
+				!vsr_odm_support) { //excluding 2to1 ODM combine on >= 5k vsr
 			pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_2to1;
 		}
 		pipe_cnt++;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 479e2c1a1301..49da8119b28e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1802,7 +1802,10 @@ static unsigned int CalculateVMAndRowBytes(
 	}
 
 	if (SurfaceTiling == dm_sw_linear) {
-		*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
+		if (PTEBufferSizeInRequests == 0)
+			*dpte_row_height = 1;
+		else
+			*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
 		*dpte_row_width_ub = (dml_ceil(((double) SwathWidth - 1) / *PixelPTEReqWidth, 1) + 1) * *PixelPTEReqWidth;
 		*PixelPTEBytesPerRow = *dpte_row_width_ub / *PixelPTEReqWidth * *PTERequestSize;
 	} else if (ScanDirection != dm_vert) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
index f77401709d83..2162ecd1057d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
@@ -27,7 +27,7 @@
 // *** IMPORTANT ***
 // SMU TEAM: Always increment the interface version if
 // any structure is changed in this file
-#define PMFW_DRIVER_IF_VERSION 7
+#define PMFW_DRIVER_IF_VERSION 8
 
 typedef struct {
   int32_t value;
@@ -198,7 +198,7 @@ typedef struct {
   uint16_t SkinTemp;
   uint16_t DeviceState;
   uint16_t CurTemp;                     //[centi-Celsius]
-  uint16_t spare2;
+  uint16_t FilterAlphaValue;
 
   uint16_t AverageGfxclkFrequency;
   uint16_t AverageFclkFrequency;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index 992163e66f7b..bffa6247c3cd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -29,7 +29,7 @@
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x37
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x08
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x37
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 697e98a0a20a..75f18681e984 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2143,16 +2143,9 @@ static int sienna_cichlid_set_default_od_settings(struct smu_context *smu)
 		(OverDriveTable_t *)smu->smu_table.boot_overdrive_table;
 	OverDriveTable_t *user_od_table =
 		(OverDriveTable_t *)smu->smu_table.user_overdrive_table;
+	OverDriveTable_t user_od_table_bak;
 	int ret = 0;
 
-	/*
-	 * For S3/S4/Runpm resume, no need to setup those overdrive tables again as
-	 *   - either they already have the default OD settings got during cold bootup
-	 *   - or they have some user customized OD settings which cannot be overwritten
-	 */
-	if (smu->adev->in_suspend)
-		return 0;
-
 	ret = smu_cmn_update_table(smu, SMU_TABLE_OVERDRIVE,
 				   0, (void *)boot_od_table, false);
 	if (ret) {
@@ -2163,7 +2156,23 @@ static int sienna_cichlid_set_default_od_settings(struct smu_context *smu)
 	sienna_cichlid_dump_od_table(smu, boot_od_table);
 
 	memcpy(od_table, boot_od_table, sizeof(OverDriveTable_t));
-	memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+
+	/*
+	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
+	 * but we have to preserve user defined values in "user_od_table".
+	 */
+	if (!smu->adev->in_suspend) {
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		smu->user_dpm_profile.user_od = false;
+	} else if (smu->user_dpm_profile.user_od) {
+		memcpy(&user_od_table_bak, user_od_table, sizeof(OverDriveTable_t));
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		user_od_table->GfxclkFmin = user_od_table_bak.GfxclkFmin;
+		user_od_table->GfxclkFmax = user_od_table_bak.GfxclkFmax;
+		user_od_table->UclkFmin = user_od_table_bak.UclkFmin;
+		user_od_table->UclkFmax = user_od_table_bak.UclkFmax;
+		user_od_table->VddGfxOffset = user_od_table_bak.VddGfxOffset;
+	}
 
 	return 0;
 }
@@ -2373,6 +2382,20 @@ static int sienna_cichlid_od_edit_dpm_table(struct smu_context *smu,
 	return ret;
 }
 
+static int sienna_cichlid_restore_user_od_settings(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTable_t *od_table = table_context->overdrive_table;
+	OverDriveTable_t *user_od_table = table_context->user_overdrive_table;
+	int res;
+
+	res = smu_v11_0_restore_user_od_settings(smu);
+	if (res == 0)
+		memcpy(od_table, user_od_table, sizeof(OverDriveTable_t));
+
+	return res;
+}
+
 static int sienna_cichlid_run_btc(struct smu_context *smu)
 {
 	int res;
@@ -4400,7 +4423,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.set_soft_freq_limited_range = smu_v11_0_set_soft_freq_limited_range,
 	.set_default_od_settings = sienna_cichlid_set_default_od_settings,
 	.od_edit_dpm_table = sienna_cichlid_od_edit_dpm_table,
-	.restore_user_od_settings = smu_v11_0_restore_user_od_settings,
+	.restore_user_od_settings = sienna_cichlid_restore_user_od_settings,
 	.run_btc = sienna_cichlid_run_btc,
 	.set_power_source = smu_v11_0_set_power_source,
 	.get_pp_feature_mask = smu_cmn_get_pp_feature_mask,
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 8b68a3c1e6ab..b87ed4238fc8 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1351,10 +1351,13 @@ EXPORT_SYMBOL(drm_gem_lru_move_tail);
  *
  * @lru: The LRU to scan
  * @nr_to_scan: The number of pages to try to reclaim
+ * @remaining: The number of pages left to reclaim, should be initialized by caller
  * @shrink: Callback to try to shrink/reclaim the object.
  */
 unsigned long
-drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
+drm_gem_lru_scan(struct drm_gem_lru *lru,
+		 unsigned int nr_to_scan,
+		 unsigned long *remaining,
 		 bool (*shrink)(struct drm_gem_object *obj))
 {
 	struct drm_gem_lru still_in_lru;
@@ -1393,8 +1396,10 @@ drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
 		 * hit shrinker in response to trying to get backing pages
 		 * for this obj (ie. while it's lock is already held)
 		 */
-		if (!dma_resv_trylock(obj->resv))
+		if (!dma_resv_trylock(obj->resv)) {
+			*remaining += obj->size >> PAGE_SHIFT;
 			goto tail;
+		}
 
 		if (shrink(obj)) {
 			freed += obj->size >> PAGE_SHIFT;
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 7af9da886d4e..5fdc608043e7 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -622,11 +622,14 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	int ret;
 
 	if (obj->import_attach) {
-		/* Drop the reference drm_gem_mmap_obj() acquired.*/
-		drm_gem_object_put(obj);
 		vma->vm_private_data = NULL;
+		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
+
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		if (!ret)
+			drm_gem_object_put(obj);
 
-		return dma_buf_mmap(obj->dma_buf, vma, 0);
+		return ret;
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 135dbcab62b2..63b7105e818a 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1604,6 +1604,8 @@ struct intel_psr {
 	bool psr2_sel_fetch_cff_enabled;
 	bool req_psr2_sdp_prior_scanline;
 	u8 sink_sync_latency;
+	u8 io_wake_lines;
+	u8 fast_wake_lines;
 	ktime_t last_entry_attempt;
 	ktime_t last_exit;
 	bool sink_not_reliable;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 15c3e448aa0e..bf18423c7a00 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -542,6 +542,14 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 	val |= EDP_PSR2_FRAME_BEFORE_SU(max_t(u8, intel_dp->psr.sink_sync_latency + 1, 2));
 	val |= intel_psr2_get_tp_time(intel_dp);
 
+	if (DISPLAY_VER(dev_priv) >= 12) {
+		if (intel_dp->psr.io_wake_lines < 9 &&
+		    intel_dp->psr.fast_wake_lines < 9)
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		else
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_3;
+	}
+
 	/* Wa_22012278275:adl-p */
 	if (IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_E0)) {
 		static const u8 map[] = {
@@ -558,31 +566,21 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 		 * Still using the default IO_BUFFER_WAKE and FAST_WAKE, see
 		 * comments bellow for more information
 		 */
-		u32 tmp, lines = 7;
-
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		u32 tmp;
 
-		tmp = map[lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.io_wake_lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_IO_BUFFER_WAKE_SHIFT;
 		val |= tmp;
 
-		tmp = map[lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.fast_wake_lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_FAST_WAKE_MIN_SHIFT;
 		val |= tmp;
 	} else if (DISPLAY_VER(dev_priv) >= 12) {
-		/*
-		 * TODO: 7 lines of IO_BUFFER_WAKE and FAST_WAKE are default
-		 * values from BSpec. In order to setting an optimal power
-		 * consumption, lower than 4k resolution mode needs to decrease
-		 * IO_BUFFER_WAKE and FAST_WAKE. And higher than 4K resolution
-		 * mode needs to increase IO_BUFFER_WAKE and FAST_WAKE.
-		 */
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
-		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= TGL_EDP_PSR2_FAST_WAKE(7);
+		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= TGL_EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
-		val |= EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= EDP_PSR2_FAST_WAKE(7);
+		val |= EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	}
 
 	if (intel_dp->psr.req_psr2_sdp_prior_scanline)
@@ -837,6 +835,46 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 	return true;
 }
 
+static bool _compute_psr2_wake_times(struct intel_dp *intel_dp,
+				     struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+	int io_wake_lines, io_wake_time, fast_wake_lines, fast_wake_time;
+	u8 max_wake_lines;
+
+	if (DISPLAY_VER(i915) >= 12) {
+		io_wake_time = 42;
+		/*
+		 * According to Bspec it's 42us, but based on testing
+		 * it is not enough -> use 45 us.
+		 */
+		fast_wake_time = 45;
+		max_wake_lines = 12;
+	} else {
+		io_wake_time = 50;
+		fast_wake_time = 32;
+		max_wake_lines = 8;
+	}
+
+	io_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, io_wake_time);
+	fast_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, fast_wake_time);
+
+	if (io_wake_lines > max_wake_lines ||
+	    fast_wake_lines > max_wake_lines)
+		return false;
+
+	if (i915->params.psr_safest_params)
+		io_wake_lines = fast_wake_lines = max_wake_lines;
+
+	/* According to Bspec lower limit should be set as 7 lines. */
+	intel_dp->psr.io_wake_lines = max(io_wake_lines, 7);
+	intel_dp->psr.fast_wake_lines = max(fast_wake_lines, 7);
+
+	return true;
+}
+
 static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 				    struct intel_crtc_state *crtc_state)
 {
@@ -930,6 +968,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	if (!_compute_psr2_wake_times(intel_dp, crtc_state)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, Unable to use long enough wake times\n");
+		return false;
+	}
+
 	if (HAS_PSR2_SEL_FETCH(dev_priv)) {
 		if (!intel_psr2_sel_fetch_config_valid(intel_dp, crtc_state) &&
 		    !HAS_PSR_HW_TRACKING(dev_priv)) {
diff --git a/drivers/gpu/drm/i915/display/intel_snps_phy.c b/drivers/gpu/drm/i915/display/intel_snps_phy.c
index 937cefd6f78f..3326c79c78a0 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -1418,6 +1418,36 @@ static const struct intel_mpllb_state dg2_hdmi_262750 = {
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_267300 = {
+	.clock = 267300,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 7) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 3),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 74) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 30146) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 36699),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_268500 = {
 	.clock = 268500,
 	.ref_control =
@@ -1508,6 +1538,36 @@ static const struct intel_mpllb_state dg2_hdmi_241500 = {
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_319890 = {
+	.clock = 319890,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 6) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 2),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 94) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 64094) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 13631),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_497750 = {
 	.clock = 497750,
 	.ref_control =
@@ -1695,8 +1755,10 @@ static const struct intel_mpllb_state * const dg2_hdmi_tables[] = {
 	&dg2_hdmi_209800,
 	&dg2_hdmi_241500,
 	&dg2_hdmi_262750,
+	&dg2_hdmi_267300,
 	&dg2_hdmi_268500,
 	&dg2_hdmi_296703,
+	&dg2_hdmi_319890,
 	&dg2_hdmi_497750,
 	&dg2_hdmi_592000,
 	&dg2_hdmi_593407,
diff --git a/drivers/gpu/drm/i915/gt/intel_sseu.h b/drivers/gpu/drm/i915/gt/intel_sseu.h
index aa87d3832d60..d7e8c374f153 100644
--- a/drivers/gpu/drm/i915/gt/intel_sseu.h
+++ b/drivers/gpu/drm/i915/gt/intel_sseu.h
@@ -27,7 +27,7 @@ struct drm_printer;
  * is only relevant to pre-Xe_HP platforms (Xe_HP and beyond use the
  * I915_MAX_SS_FUSE_BITS value below).
  */
-#define GEN_MAX_SS_PER_HSW_SLICE	6
+#define GEN_MAX_SS_PER_HSW_SLICE	8
 
 /*
  * Maximum number of 32-bit registers used by hardware to express the
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 7412abf166a8..a9fea115f2d2 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -422,12 +422,12 @@ replace_barrier(struct i915_active *ref, struct i915_active_fence *active)
 	 * we can use it to substitute for the pending idle-barrer
 	 * request that we want to emit on the kernel_context.
 	 */
-	__active_del_barrier(ref, node_from_active(active));
-	return true;
+	return __active_del_barrier(ref, node_from_active(active));
 }
 
 int i915_active_add_request(struct i915_active *ref, struct i915_request *rq)
 {
+	u64 idx = i915_request_timeline(rq)->fence_context;
 	struct dma_fence *fence = &rq->fence;
 	struct i915_active_fence *active;
 	int err;
@@ -437,16 +437,19 @@ int i915_active_add_request(struct i915_active *ref, struct i915_request *rq)
 	if (err)
 		return err;
 
-	active = active_instance(ref, i915_request_timeline(rq)->fence_context);
-	if (!active) {
-		err = -ENOMEM;
-		goto out;
-	}
+	do {
+		active = active_instance(ref, idx);
+		if (!active) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (replace_barrier(ref, active)) {
+			RCU_INIT_POINTER(active->fence, NULL);
+			atomic_dec(&ref->count);
+		}
+	} while (unlikely(is_barrier(active)));
 
-	if (replace_barrier(ref, active)) {
-		RCU_INIT_POINTER(active->fence, NULL);
-		atomic_dec(&ref->count);
-	}
 	if (!__i915_active_fence_set(active, fence))
 		__i915_active_acquire(ref);
 
diff --git a/drivers/gpu/drm/meson/meson_vpp.c b/drivers/gpu/drm/meson/meson_vpp.c
index 154837688ab0..5df1957c8e41 100644
--- a/drivers/gpu/drm/meson/meson_vpp.c
+++ b/drivers/gpu/drm/meson/meson_vpp.c
@@ -100,6 +100,8 @@ void meson_vpp_init(struct meson_drm *priv)
 			       priv->io_base + _REG(VPP_DOLBY_CTRL));
 		writel_relaxed(0x1020080,
 				priv->io_base + _REG(VPP_DUMMY_DATA1));
+		writel_relaxed(0x42020,
+				priv->io_base + _REG(VPP_DUMMY_DATA));
 	} else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		writel_relaxed(0xf, priv->io_base + _REG(DOLBY_PATH_CTRL));
 
diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 1de14e67f96b..31f054c903a4 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -107,6 +107,7 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 		bool (*shrink)(struct drm_gem_object *obj);
 		bool cond;
 		unsigned long freed;
+		unsigned long remaining;
 	} stages[] = {
 		/* Stages of progressively more aggressive/expensive reclaim: */
 		{ &priv->lru.dontneed, purge,        true },
@@ -116,14 +117,18 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 	};
 	long nr = sc->nr_to_scan;
 	unsigned long freed = 0;
+	unsigned long remaining = 0;
 
 	for (unsigned i = 0; (nr > 0) && (i < ARRAY_SIZE(stages)); i++) {
 		if (!stages[i].cond)
 			continue;
 		stages[i].freed =
-			drm_gem_lru_scan(stages[i].lru, nr, stages[i].shrink);
+			drm_gem_lru_scan(stages[i].lru, nr,
+					&stages[i].remaining,
+					 stages[i].shrink);
 		nr -= stages[i].freed;
 		freed += stages[i].freed;
+		remaining += stages[i].remaining;
 	}
 
 	if (freed) {
@@ -132,7 +137,7 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 				     stages[3].freed);
 	}
 
-	return (freed > 0) ? freed : SHRINK_STOP;
+	return (freed > 0 && remaining > 0) ? freed : SHRINK_STOP;
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -182,10 +187,12 @@ msm_gem_shrinker_vmap(struct notifier_block *nb, unsigned long event, void *ptr)
 		NULL,
 	};
 	unsigned idx, unmapped = 0;
+	unsigned long remaining = 0;
 
 	for (idx = 0; lrus[idx] && unmapped < vmap_shrink_limit; idx++) {
 		unmapped += drm_gem_lru_scan(lrus[idx],
 					     vmap_shrink_limit - unmapped,
+					     &remaining,
 					     vmap_shrink);
 	}
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 4e83a1891f3e..666a5e53fe19 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -282,7 +282,7 @@ static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 	if (pm_runtime_active(pfdev->dev))
 		mmu_hw_do_operation(pfdev, mmu, iova, size, AS_COMMAND_FLUSH_PT);
 
-	pm_runtime_put_sync_autosuspend(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
 }
 
 static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index d06ffd99d86e..7910c5853f0a 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -95,12 +95,12 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -119,6 +119,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
diff --git a/drivers/gpu/drm/ttm/ttm_device.c b/drivers/gpu/drm/ttm/ttm_device.c
index e7147e304637..b84f74807ca1 100644
--- a/drivers/gpu/drm/ttm/ttm_device.c
+++ b/drivers/gpu/drm/ttm/ttm_device.c
@@ -158,7 +158,7 @@ int ttm_device_swapout(struct ttm_device *bdev, struct ttm_operation_ctx *ctx,
 			struct ttm_buffer_object *bo = res->bo;
 			uint32_t num_pages;
 
-			if (!bo)
+			if (!bo || bo->resource != res)
 				continue;
 
 			num_pages = PFN_UP(bo->base.size);
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 9ff8660b50ad..208e9434cb28 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -597,7 +597,7 @@ void virtio_gpu_cmd_transfer_to_host_2d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
@@ -1019,7 +1019,7 @@ void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 51b3d16c3223..6e4c92b500b8 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -488,10 +488,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
 		val = (temp - val) / 1000;
 
 		if (sattr->index != 1) {
-			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
+			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF) << 4;
 		} else {
-			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
+			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF);
 		}
 
@@ -556,11 +556,11 @@ static ssize_t temp_st_show(struct device *dev, struct device_attribute *attr,
 		val = data->enh_acoustics[0] & 0xf;
 		break;
 	case 1:
-		val = (data->enh_acoustics[1] >> 4) & 0xf;
+		val = data->enh_acoustics[1] & 0xf;
 		break;
 	case 2:
 	default:
-		val = data->enh_acoustics[1] & 0xf;
+		val = (data->enh_acoustics[1] >> 4) & 0xf;
 		break;
 	}
 
diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index e06186986444..f3a4c5633b1e 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -772,7 +772,7 @@ static int ina3221_probe_child_from_dt(struct device *dev,
 		return ret;
 	} else if (val > INA3221_CHANNEL3) {
 		dev_err(dev, "invalid reg %d of %pOFn\n", val, child);
-		return ret;
+		return -EINVAL;
 	}
 
 	input = &ina->inputs[val];
diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index 72489d5d7eaf..d88e883c7492 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -323,6 +323,7 @@ static int ltc2992_config_gpio(struct ltc2992_state *st)
 	st->gc.label = name;
 	st->gc.parent = &st->client->dev;
 	st->gc.owner = THIS_MODULE;
+	st->gc.can_sleep = true;
 	st->gc.base = -1;
 	st->gc.names = st->gpio_names;
 	st->gc.ngpio = ARRAY_SIZE(st->gpio_names);
diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index ec5f932fc6f0..1ac2b2f4c570 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -301,6 +301,7 @@ static int adm1266_config_gpio(struct adm1266_data *data)
 	data->gc.label = name;
 	data->gc.parent = &data->client->dev;
 	data->gc.owner = THIS_MODULE;
+	data->gc.can_sleep = true;
 	data->gc.base = -1;
 	data->gc.names = data->gpio_names;
 	data->gc.ngpio = ARRAY_SIZE(data->gpio_names);
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 75fc770c9e40..3daaf2237832 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -16,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/pmbus.h>
 #include <linux/gpio/driver.h>
+#include <linux/timekeeping.h>
 #include "pmbus.h"
 
 enum chips { ucd9000, ucd90120, ucd90124, ucd90160, ucd90320, ucd9090,
@@ -65,6 +67,7 @@ struct ucd9000_data {
 	struct gpio_chip gpio;
 #endif
 	struct dentry *debugfs;
+	ktime_t write_time;
 };
 #define to_ucd9000_data(_info) container_of(_info, struct ucd9000_data, info)
 
@@ -73,6 +76,73 @@ struct ucd9000_debugfs_entry {
 	u8 index;
 };
 
+/*
+ * It has been observed that the UCD90320 randomly fails register access when
+ * doing another access right on the back of a register write. To mitigate this
+ * make sure that there is a minimum delay between a write access and the
+ * following access. The 250us is based on experimental data. At a delay of
+ * 200us the issue seems to go away. Add a bit of extra margin to allow for
+ * system to system differences.
+ */
+#define UCD90320_WAIT_DELAY_US 250
+
+static inline void ucd90320_wait(const struct ucd9000_data *data)
+{
+	s64 delta = ktime_us_delta(ktime_get(), data->write_time);
+
+	if (delta < UCD90320_WAIT_DELAY_US)
+		udelay(UCD90320_WAIT_DELAY_US - delta);
+}
+
+static int ucd90320_read_word_data(struct i2c_client *client, int page,
+				   int phase, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	if (reg >= PMBUS_VIRT_BASE)
+		return -ENXIO;
+
+	ucd90320_wait(data);
+	return pmbus_read_word_data(client, page, phase, reg);
+}
+
+static int ucd90320_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	ucd90320_wait(data);
+	return pmbus_read_byte_data(client, page, reg);
+}
+
+static int ucd90320_write_word_data(struct i2c_client *client, int page,
+				    int reg, u16 word)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_word_data(client, page, reg, word);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
+static int ucd90320_write_byte(struct i2c_client *client, int page, u8 value)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_byte(client, page, value);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
 static int ucd9000_get_fan_config(struct i2c_client *client, int fan)
 {
 	int fan_config = 0;
@@ -598,6 +668,11 @@ static int ucd9000_probe(struct i2c_client *client)
 		info->read_byte_data = ucd9000_read_byte_data;
 		info->func[0] |= PMBUS_HAVE_FAN12 | PMBUS_HAVE_STATUS_FAN12
 		  | PMBUS_HAVE_FAN34 | PMBUS_HAVE_STATUS_FAN34;
+	} else if (mid->driver_data == ucd90320) {
+		info->read_byte_data = ucd90320_read_byte_data;
+		info->read_word_data = ucd90320_read_word_data;
+		info->write_byte = ucd90320_write_byte;
+		info->write_word_data = ucd90320_write_word_data;
 	}
 
 	ucd9000_probe_gpio(client, mid, data);
diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 47bbe47e062f..7d5f7441aceb 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -758,7 +758,7 @@ static int tmp51x_probe(struct i2c_client *client)
 static struct i2c_driver tmp51x_driver = {
 	.driver = {
 		.name	= "tmp51x",
-		.of_match_table = of_match_ptr(tmp51x_of_match),
+		.of_match_table = tmp51x_of_match,
 	},
 	.probe_new	= tmp51x_probe,
 	.id_table	= tmp51x_id,
diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 5cde837bfd09..d1abea49f01b 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -761,6 +761,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 25debded65a8..cfa52c6369d0 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -850,6 +850,10 @@ void icc_node_destroy(int id)
 
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return;
+
+	kfree(node->links);
 	kfree(node);
 }
 EXPORT_SYMBOL_GPL(icc_node_destroy);
@@ -1029,54 +1033,68 @@ int icc_nodes_remove(struct icc_provider *provider)
 EXPORT_SYMBOL_GPL(icc_nodes_remove);
 
 /**
- * icc_provider_add() - add a new interconnect provider
- * @provider: the interconnect provider that will be added into topology
+ * icc_provider_init() - initialize a new interconnect provider
+ * @provider: the interconnect provider to initialize
+ *
+ * Must be called before adding nodes to the provider.
+ */
+void icc_provider_init(struct icc_provider *provider)
+{
+	WARN_ON(!provider->set);
+
+	INIT_LIST_HEAD(&provider->nodes);
+}
+EXPORT_SYMBOL_GPL(icc_provider_init);
+
+/**
+ * icc_provider_register() - register a new interconnect provider
+ * @provider: the interconnect provider to register
  *
  * Return: 0 on success, or an error code otherwise
  */
-int icc_provider_add(struct icc_provider *provider)
+int icc_provider_register(struct icc_provider *provider)
 {
-	if (WARN_ON(!provider->set))
-		return -EINVAL;
 	if (WARN_ON(!provider->xlate && !provider->xlate_extended))
 		return -EINVAL;
 
 	mutex_lock(&icc_lock);
-
-	INIT_LIST_HEAD(&provider->nodes);
 	list_add_tail(&provider->provider_list, &icc_providers);
-
 	mutex_unlock(&icc_lock);
 
-	dev_dbg(provider->dev, "interconnect provider added to topology\n");
+	dev_dbg(provider->dev, "interconnect provider registered\n");
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(icc_provider_add);
+EXPORT_SYMBOL_GPL(icc_provider_register);
 
 /**
- * icc_provider_del() - delete previously added interconnect provider
- * @provider: the interconnect provider that will be removed from topology
+ * icc_provider_deregister() - deregister an interconnect provider
+ * @provider: the interconnect provider to deregister
  */
-void icc_provider_del(struct icc_provider *provider)
+void icc_provider_deregister(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
-	if (provider->users) {
-		pr_warn("interconnect provider still has %d users\n",
-			provider->users);
-		mutex_unlock(&icc_lock);
-		return;
-	}
-
-	if (!list_empty(&provider->nodes)) {
-		pr_warn("interconnect provider still has nodes\n");
-		mutex_unlock(&icc_lock);
-		return;
-	}
+	WARN_ON(provider->users);
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);
 }
+EXPORT_SYMBOL_GPL(icc_provider_deregister);
+
+int icc_provider_add(struct icc_provider *provider)
+{
+	icc_provider_init(provider);
+
+	return icc_provider_register(provider);
+}
+EXPORT_SYMBOL_GPL(icc_provider_add);
+
+void icc_provider_del(struct icc_provider *provider)
+{
+	WARN_ON(!list_empty(&provider->nodes));
+
+	icc_provider_deregister(provider);
+}
 EXPORT_SYMBOL_GPL(icc_provider_del);
 
 static int of_count_icc_providers(struct device_node *np)
diff --git a/drivers/interconnect/imx/imx.c b/drivers/interconnect/imx/imx.c
index 823d9be9771a..979ed610f704 100644
--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -295,6 +295,9 @@ int imx_icc_register(struct platform_device *pdev,
 	provider->xlate = of_icc_xlate_onecell;
 	provider->data = data;
 	provider->dev = dev->parent;
+
+	icc_provider_init(provider);
+
 	platform_set_drvdata(pdev, imx_provider);
 
 	if (settings) {
@@ -306,20 +309,18 @@ int imx_icc_register(struct platform_device *pdev,
 		}
 	}
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
+	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	if (ret)
 		return ret;
-	}
 
-	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	ret = icc_provider_register(provider);
 	if (ret)
-		goto provider_del;
+		goto err_unregister_nodes;
 
 	return 0;
 
-provider_del:
-	icc_provider_del(provider);
+err_unregister_nodes:
+	imx_icc_unregister_nodes(&imx_provider->provider);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(imx_icc_register);
@@ -328,9 +329,8 @@ void imx_icc_unregister(struct platform_device *pdev)
 {
 	struct imx_icc_provider *imx_provider = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&imx_provider->provider);
 	imx_icc_unregister_nodes(&imx_provider->provider);
-
-	icc_provider_del(&imx_provider->provider);
 }
 EXPORT_SYMBOL_GPL(imx_icc_unregister);
 
diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 39e43b957599..6a9e6b563320 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -506,7 +506,6 @@ int qnoc_probe(struct platform_device *pdev)
 	}
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = qcom_icc_set;
 	provider->pre_aggregate = qcom_icc_pre_bw_aggregate;
@@ -514,12 +513,7 @@ int qnoc_probe(struct platform_device *pdev)
 	provider->xlate_extended = qcom_icc_xlate_extended;
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -527,7 +521,7 @@ int qnoc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -541,17 +535,26 @@ int qnoc_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
-	if (of_get_child_count(dev->of_node) > 0)
-		return of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (of_get_child_count(dev->of_node) > 0) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret)
+			goto err_deregister_provider;
+	}
 
 	return 0;
-err:
+
+err_deregister_provider:
+	icc_provider_deregister(provider);
+err_remove_nodes:
 	icc_nodes_remove(provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(provider);
 
 	return ret;
 }
@@ -561,9 +564,9 @@ int qnoc_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index fd17291c61eb..fdb5e58e408b 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -192,9 +192,10 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	provider->pre_aggregate = qcom_icc_pre_aggregate;
 	provider->aggregate = qcom_icc_aggregate;
 	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
+	icc_provider_init(provider);
+
 	qp->dev = dev;
 	qp->bcms = desc->bcms;
 	qp->num_bcms = desc->num_bcms;
@@ -203,10 +204,6 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	if (IS_ERR(qp->voter))
 		return PTR_ERR(qp->voter);
 
-	ret = icc_provider_add(provider);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < qp->num_bcms; i++)
 		qcom_icc_bcm_init(qp->bcms[i], dev);
 
@@ -218,7 +215,7 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 		node = icc_node_create(qn->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qn->name;
@@ -232,16 +229,27 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	}
 
 	data->num_nodes = num_nodes;
+
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
-	if (of_get_child_count(dev->of_node) > 0)
-		return of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (of_get_child_count(dev->of_node) > 0) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret)
+			goto err_deregister_provider;
+	}
 
 	return 0;
-err:
+
+err_deregister_provider:
+	icc_provider_deregister(provider);
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_rpmh_probe);
@@ -250,8 +258,8 @@ int qcom_icc_rpmh_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
diff --git a/drivers/interconnect/qcom/msm8974.c b/drivers/interconnect/qcom/msm8974.c
index 5ea192f1141d..1828deaca443 100644
--- a/drivers/interconnect/qcom/msm8974.c
+++ b/drivers/interconnect/qcom/msm8974.c
@@ -692,7 +692,6 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		return ret;
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = msm8974_icc_set;
 	provider->aggregate = icc_std_aggregate;
@@ -700,11 +699,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	provider->data = data;
 	provider->get_bw = msm8974_get_bw;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		goto err_disable_clks;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -712,7 +707,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err_del_icc;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -729,15 +724,16 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 
-err_del_icc:
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-
-err_disable_clks:
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
 	return ret;
@@ -747,9 +743,9 @@ static int msm8974_icc_remove(struct platform_device *pdev)
 {
 	struct msm8974_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index ddbdf0943f94..333adb21e717 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -216,8 +216,8 @@ static int qcom_osm_l3_remove(struct platform_device *pdev)
 {
 	struct qcom_osm_l3_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
@@ -303,14 +303,9 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	provider->set = qcom_osm_l3_set;
 	provider->aggregate = icc_std_aggregate;
 	provider->xlate = of_icc_xlate_onecell;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -333,12 +328,15 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 err:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
 
 	return ret;
 }
diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index 6559d8cf8068..72e42603823b 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 	struct icc_node *parent_node, *node = priv->node;
 
+	icc_provider_deregister(&priv->provider);
+
 	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
 	if (parent_node && !IS_ERR(parent_node))
 		icc_link_destroy(node, parent_node);
 
 	icc_nodes_remove(&priv->provider);
-	icc_provider_del(&priv->provider);
 
 	return 0;
 }
@@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 	provider->inter_set = true;
 	provider->data = priv;
 
-	ret = icc_provider_add(provider);
-	if (ret < 0)
-		return ret;
+	icc_provider_init(provider);
 
 	icc_node = icc_node_create(pdev->id);
-	if (IS_ERR(icc_node)) {
-		ret = PTR_ERR(icc_node);
-		goto err_prov_del;
-	}
+	if (IS_ERR(icc_node))
+		return PTR_ERR(icc_node);
 
 	priv->node = icc_node;
 	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
@@ -149,6 +146,9 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 				 &priv->bus_clk_ratio))
 		priv->bus_clk_ratio = EXYNOS_ICC_DEFAULT_BUS_CLK_RATIO;
 
+	icc_node->data = priv;
+	icc_node_add(icc_node, provider);
+
 	/*
 	 * Register a PM QoS request for the parent (devfreq) device.
 	 */
@@ -157,9 +157,6 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_node_del;
 
-	icc_node->data = priv;
-	icc_node_add(icc_node, provider);
-
 	icc_parent_node = exynos_icc_get_parent(bus_dev->of_node);
 	if (IS_ERR(icc_parent_node)) {
 		ret = PTR_ERR(icc_parent_node);
@@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 			goto err_pmqos_del;
 	}
 
+	ret = icc_provider_register(provider);
+	if (ret < 0)
+		goto err_pmqos_del;
+
 	return 0;
 
 err_pmqos_del:
 	dev_pm_qos_remove_request(&priv->qos_req);
 err_node_del:
 	icc_nodes_remove(provider);
-err_prov_del:
-	icc_provider_del(provider);
+
 	return ret;
 }
 
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 998a5cfdbc4e..662d219c39bf 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -16,6 +16,10 @@ if MD
 config BLK_DEV_MD
 	tristate "RAID support"
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
+	# BLOCK_LEGACY_AUTOLOAD requirement should be removed
+	# after relevant mdadm enhancements - to make "names=yes"
+	# the default - are widely available.
+	select BLOCK_LEGACY_AUTOLOAD
 	help
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 2201d2a26353..c90442feb6dc 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -488,7 +488,7 @@ static enum m5mols_restype __find_restype(u32 code)
 	do {
 		if (code == m5mols_default_ffmt[type].code)
 			return type;
-	} while (type++ != SIZE_DEFAULT_FFMT);
+	} while (++type != SIZE_DEFAULT_FFMT);
 
 	return 0;
 }
diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index 2f7a58a9df1a..b38b565b308e 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -769,16 +769,12 @@ static int tegra_mc_interconnect_setup(struct tegra_mc *mc)
 	mc->provider.aggregate = mc->soc->icc_ops->aggregate;
 	mc->provider.xlate_extended = mc->soc->icc_ops->xlate_extended;
 
-	err = icc_provider_add(&mc->provider);
-	if (err)
-		return err;
+	icc_provider_init(&mc->provider);
 
 	/* create Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_MC);
-	if (IS_ERR(node)) {
-		err = PTR_ERR(node);
-		goto del_provider;
-	}
+	if (IS_ERR(node))
+		return PTR_ERR(node);
 
 	node->name = "Memory Controller";
 	icc_node_add(node, &mc->provider);
@@ -805,12 +801,14 @@ static int tegra_mc_interconnect_setup(struct tegra_mc *mc)
 			goto remove_nodes;
 	}
 
+	err = icc_provider_register(&mc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&mc->provider);
-del_provider:
-	icc_provider_del(&mc->provider);
 
 	return err;
 }
diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index 85bc936c02f9..00ed2b6a0d1b 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -1351,15 +1351,13 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1380,12 +1378,14 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 
diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index 25ba3c5e4ad6..d1f01f80dcbd 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -1034,15 +1034,13 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1063,12 +1061,14 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 
diff --git a/drivers/memory/tegra/tegra30-emc.c b/drivers/memory/tegra/tegra30-emc.c
index 9ba2a9e5316b..1ea3792beb86 100644
--- a/drivers/memory/tegra/tegra30-emc.c
+++ b/drivers/memory/tegra/tegra30-emc.c
@@ -1546,15 +1546,13 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1575,12 +1573,14 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index bb9bbf1c927b..dd18440a90c5 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1817,7 +1817,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1850,8 +1849,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				 * command to send.
 				 */
 				if (host->mrq->stop) {
-					atmci_writel(host, ATMCI_IER,
-					             ATMCI_CMDRDY);
 					atmci_send_stop_cmd(host, data);
 					state = STATE_SENDING_STOP;
 				} else {
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index c2333c7acac9..101581d83982 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -369,7 +369,7 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 					MAX_POWER_ON_TIMEOUT, false, host, val,
 					reg);
 		if (ret)
-			dev_warn(mmc_dev(host->mmc), "Power on failed\n");
+			dev_info(mmc_dev(host->mmc), "Power on failed\n");
 	}
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fce9301c8ebb..45d3cb557de7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1774,6 +1774,19 @@ void bond_lower_state_changed(struct slave *slave)
 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
 } while (0)
 
+/* The bonding driver uses ether_setup() to convert a master bond device
+ * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ */
+static void bond_ether_setup(struct net_device *bond_dev)
+{
+	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+
+	ether_setup(bond_dev);
+	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
@@ -1865,10 +1878,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 			if (slave_dev->type != ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else {
-				ether_setup(bond_dev);
-				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-			}
+			else
+				bond_ether_setup(bond_dev);
 
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
@@ -2288,9 +2299,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			eth_hw_addr_random(bond_dev);
 		if (bond_dev->type != ARPHRD_ETHER) {
 			dev_close(bond_dev);
-			ether_setup(bond_dev);
-			bond_dev->flags |= IFF_MASTER;
-			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+			bond_ether_setup(bond_dev);
 		}
 	}
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index c68f48cd1ec0..07f6776bba12 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -272,7 +272,7 @@ static const u16 ksz8795_regs[] = {
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
-	[P_XMII_CTRL_1]			= 0x56,
+	[P_XMII_CTRL_1]			= 0x06,
 };
 
 static const u32 ksz8795_masks[] = {
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1e0b8bcd59e6..1757d6a2c72a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
-		/* PLL frequency: 125MHz */
-		ncpo1 = 0x0c80;
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
@@ -462,38 +460,40 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
-	/* Lower Tx Driving for TRGMII path */
-	for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-	/* Disable MT7530 core and TRGMII Tx clocks */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-		   REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	/* Setup the MT7530 TRGMII Tx Clock */
-	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
-	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
-	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP4,
-		   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
-		   RG_SYSPLL_BIAS_LPF_EN);
-	core_write(priv, CORE_PLL_GROUP2,
-		   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
-		   RG_SYSPLL_POSDIV(1));
-	core_write(priv, CORE_PLL_GROUP7,
-		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
-		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
-
-	/* Enable MT7530 core and TRGMII Tx clocks */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-		 REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	if (!trgint)
+	if (trgint) {
+		/* Lower Tx Driving for TRGMII path */
+		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
+			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+		/* Disable MT7530 core and TRGMII Tx clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+
+		/* Setup the MT7530 TRGMII Tx Clock */
+		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
+		core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
+		core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP4,
+			   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
+			   RG_SYSPLL_BIAS_LPF_EN);
+		core_write(priv, CORE_PLL_GROUP2,
+			   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
+			   RG_SYSPLL_POSDIV(1));
+		core_write(priv, CORE_PLL_GROUP7,
+			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
+			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+		/* Enable MT7530 core and TRGMII Tx clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
+			 REG_GSWCK_EN | REG_TRGMIICK_EN);
+	} else {
 		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
+	}
+
 	return 0;
 }
 
@@ -2206,7 +2206,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3b8b2d0fbafa..3a6db36574ad 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3549,7 +3549,7 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return ETH_DATA_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -3557,6 +3557,17 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	/* For families where we don't know how to alter the MTU,
+	 * just accept any value up to ETH_DATA_LEN
+	 */
+	if (!chip->info->ops->port_set_jumbo_size &&
+	    !chip->info->ops->set_max_frame_size) {
+		if (new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		new_mtu += EDSA_HLEN;
 
@@ -3565,9 +3576,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
 	else if (chip->info->ops->set_max_frame_size)
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
-	else
-		if (new_mtu > 1522)
-			ret = -EINVAL;
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 25129e723b57..2dc8d215a591 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -412,6 +412,25 @@ int aq_xdp_xmit(struct net_device *dev, int num_frames,
 	return num_frames - drop;
 }
 
+static struct sk_buff *aq_xdp_build_skb(struct xdp_buff *xdp,
+					struct net_device *dev,
+					struct aq_ring_buff_s *buff)
+{
+	struct xdp_frame *xdpf;
+	struct sk_buff *skb;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return NULL;
+
+	skb = xdp_build_skb_from_frame(xdpf, dev);
+	if (!skb)
+		return NULL;
+
+	aq_get_rxpages_xdp(buff, xdp);
+	return skb;
+}
+
 static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 				       struct xdp_buff *xdp,
 				       struct aq_ring_s *rx_ring,
@@ -431,7 +450,7 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 
 	prog = READ_ONCE(rx_ring->xdp_prog);
 	if (!prog)
-		goto pass;
+		return aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
@@ -442,17 +461,12 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-pass:
-		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
-			goto out_aborted;
-		skb = xdp_build_skb_from_frame(xdpf, aq_nic->ndev);
+		skb = aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 		if (!skb)
 			goto out_aborted;
 		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
 		++rx_ring->stats.rx.xdp_pass;
 		u64_stats_update_end(&rx_ring->stats.rx.syncp);
-		aq_get_rxpages_xdp(buff, xdp);
 		return skb;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index daec9ce04531..54bb4d9a0d1e 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -78,6 +78,7 @@ static int sni_82596_probe(struct platform_device *dev)
 	void __iomem *mpu_addr;
 	void __iomem *ca_addr;
 	u8 __iomem *eth_addr;
+	u8 mac[ETH_ALEN];
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
@@ -109,12 +110,13 @@ static int sni_82596_probe(struct platform_device *dev)
 		goto probe_failed;
 
 	/* someone seems to like messed up stuff */
-	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
-	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
-	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
-	netdevice->dev_addr[3] = readb(eth_addr + 0x08);
-	netdevice->dev_addr[4] = readb(eth_addr + 0x07);
-	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
+	mac[0] = readb(eth_addr + 0x0b);
+	mac[1] = readb(eth_addr + 0x0a);
+	mac[2] = readb(eth_addr + 0x09);
+	mac[3] = readb(eth_addr + 0x08);
+	mac[4] = readb(eth_addr + 0x07);
+	mac[5] = readb(eth_addr + 0x06);
+	eth_hw_addr_set(netdevice, mac);
 	iounmap(eth_addr);
 
 	if (netdevice->irq < 0) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d30bc38725e9..da0cf87d3a1c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15491,6 +15491,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	int err;
 	int v_idx;
 
+	pci_set_drvdata(pf->pdev, pf);
 	pci_save_state(pf->pdev);
 
 	/* set up periodic task facility */
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e04871379baa..ca6b877fdde8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -485,6 +485,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_UNPLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
@@ -926,16 +927,11 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
-	/* We can directly unplug aux device here only if the flag bit
-	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
-	 * could race with ice_plug_aux_dev() called from
-	 * ice_service_task(). In this case we only clear that bit now and
-	 * aux device will be unplugged later once ice_plug_aux_device()
-	 * called from ice_service_task() finishes (see ice_service_task()).
+	/* defer unplug to service task to avoid RTNL lock and
+	 * clear PLUG bit so that pending plugs don't interfere
 	 */
-	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-		ice_unplug_aux_dev(pf);
-
+	clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3c6bb3f9ac78..cfc57cfc46e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2326,18 +2326,15 @@ static void ice_service_task(struct work_struct *work)
 		}
 	}
 
-	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
-		/* Plug aux device per request */
-		ice_plug_aux_dev(pf);
+	/* unplug aux dev per request, if an unplug request came in
+	 * while processing a plug request, this will handle it
+	 */
+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
 
-		/* Mark plugging as done but check whether unplug was
-		 * requested during ice_plug_aux_dev() call
-		 * (e.g. from ice_clear_rdma_cap()) and if so then
-		 * plug aux device.
-		 */
-		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-			ice_unplug_aux_dev(pf);
-	}
+	/* Plug aux device per request */
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
 
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 65468cdc2587..41ee081eb887 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -173,8 +173,6 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	}
 	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
 
-	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
-
 	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
 	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
 	if (err)
@@ -189,10 +187,11 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
+	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
+
 	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
 	if (err)
 		return err;
-	ice_clean_rx_ring(rx_ring);
 
 	ice_qvec_toggle_napi(vsi, q_vector, false);
 	ice_qp_clean_rings(vsi, q_idx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 26a23047f1f3..bc76fe6b0623 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -313,7 +313,6 @@ struct mlx5e_params {
 		} channel;
 	} mqprio;
 	bool rx_cqe_compress_def;
-	bool tunneled_offload_en;
 	struct dim_cq_moder rx_cq_moderation;
 	struct dim_cq_moder tx_cq_moderation;
 	struct mlx5e_packet_merge_param packet_merge;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index e6f64d890fb3..83bb0811e774 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -745,8 +745,6 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 		if (err)
 			goto out;
 
-		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
-						      misc_parameters.vxlan_vni);
 		esw_attr->rx_tun_attr->decap_vport = vport_num;
 	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
 		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index b92d541b5286..0c23340bfcc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -89,8 +89,8 @@ struct mlx5e_macsec_rx_sc {
 };
 
 struct mlx5e_macsec_umr {
+	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	dma_addr_t dma_addr;
-	u8 ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	u32 mkey;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 142ed2d98cd5..609a49c1e09e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4911,8 +4911,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* TX inline */
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 
-	params->tunneled_offload_en = mlx5_tunnel_inner_ft_supported(mdev);
-
 	/* AF_XDP */
 	params->xsk = xsk;
 
@@ -5216,7 +5214,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	}
 
 	features = MLX5E_RX_RES_FEATURE_PTP;
-	if (priv->channels.params.tunneled_offload_en)
+	if (mlx5_tunnel_inner_ft_supported(mdev))
 		features |= MLX5E_RX_RES_FEATURE_INNER_FT;
 	err = mlx5e_rx_res_init(priv->rx_res, priv->mdev, features,
 				priv->max_nch, priv->drop_rq.rqn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 794cd8dfe9c9..0f744131c686 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -707,7 +707,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
 
 	params->mqprio.num_tc       = 1;
-	params->tunneled_offload_en = false;
 	if (rep->vport != MLX5_VPORT_UPLINK)
 		params->vlan_strip_disable = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c1cf3917baa4..73af062a8783 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2401,13 +2401,13 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		err = mlx5e_tc_set_attr_rx_tun(flow, spec);
 		if (err)
 			return err;
-	} else if (tunnel && tunnel->tunnel_type == MLX5E_TC_TUNNEL_TYPE_VXLAN) {
+	} else if (tunnel) {
 		struct mlx5_flow_spec *tmp_spec;
 
 		tmp_spec = kvzalloc(sizeof(*tmp_spec), GFP_KERNEL);
 		if (!tmp_spec) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for vxlan tmp spec");
-			netdev_warn(priv->netdev, "Failed to allocate memory for vxlan tmp spec");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for tunnel tmp spec");
+			netdev_warn(priv->netdev, "Failed to allocate memory for tunnel tmp spec");
 			return -ENOMEM;
 		}
 		memcpy(tmp_spec, spec, sizeof(*tmp_spec));
@@ -4054,6 +4054,7 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 
 	esw_attr->dest_int_port = dest_int_port;
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	esw_attr->split_count = out_index;
 
 	/* Forward to root fdb for matching against the new source vport */
 	attr->dest_chain = 0;
@@ -4311,9 +4312,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	/* always set IP version for indirect table handling */
-	flow->attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
-
 	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
 	if (err)
 		goto err_free;
@@ -5162,6 +5160,16 @@ int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 
 void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 {
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+
+	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+	priv = netdev_priv(rpriv->netdev);
+	esw = priv->mdev->priv.eswitch;
+
+	mlx5e_tc_clean_fdb_peer_flows(esw);
+
 	mlx5e_tc_tun_cleanup(uplink_priv->encap);
 
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 48241317a535..edd5f09440f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -82,7 +82,6 @@ struct mlx5_flow_attr {
 	struct mlx5_flow_table *dest_ft;
 	u8 inner_match_level;
 	u8 outer_match_level;
-	u8 ip_version;
 	u8 tun_ip_version;
 	int tunnel_id; /* mapped tunnel id */
 	u32 flags;
@@ -129,7 +128,6 @@ struct mlx5_rx_tun_attr {
 		__be32 v4;
 		struct in6_addr v6;
 	} dst_ip; /* Valid if decap_vport is not zero */
-	u32 vni;
 };
 
 #define MLX5E_TC_TABLE_CHAIN_TAG_BITS 16
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index c9a91158e99c..8a94870c5b43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -16,18 +16,12 @@
 #include "lib/fs_chains.h"
 #include "en/mod_hdr.h"
 
-#define MLX5_ESW_INDIR_TABLE_SIZE 128
-#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
+#define MLX5_ESW_INDIR_TABLE_SIZE 2
+#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
 #define MLX5_ESW_INDIR_TABLE_FWD_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 1)
 
 struct mlx5_esw_indir_table_rule {
-	struct list_head list;
 	struct mlx5_flow_handle *handle;
-	union {
-		__be32 v4;
-		struct in6_addr v6;
-	} dst_ip;
-	u32 vni;
 	struct mlx5_modify_hdr *mh;
 	refcount_t refcnt;
 };
@@ -38,12 +32,10 @@ struct mlx5_esw_indir_table_entry {
 	struct mlx5_flow_group *recirc_grp;
 	struct mlx5_flow_group *fwd_grp;
 	struct mlx5_flow_handle *fwd_rule;
-	struct list_head recirc_rules;
-	int recirc_cnt;
+	struct mlx5_esw_indir_table_rule *recirc_rule;
 	int fwd_ref;
 
 	u16 vport;
-	u8 ip_version;
 };
 
 struct mlx5_esw_indir_table {
@@ -89,7 +81,6 @@ mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
 	return esw_attr->in_rep->vport == MLX5_VPORT_UPLINK &&
 		vf_sf_vport &&
 		esw->dev == dest_mdev &&
-		attr->ip_version &&
 		attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE;
 }
 
@@ -101,27 +92,8 @@ mlx5_esw_indir_table_decap_vport(struct mlx5_flow_attr *attr)
 	return esw_attr->rx_tun_attr ? esw_attr->rx_tun_attr->decap_vport : 0;
 }
 
-static struct mlx5_esw_indir_table_rule *
-mlx5_esw_indir_table_rule_lookup(struct mlx5_esw_indir_table_entry *e,
-				 struct mlx5_esw_flow_attr *attr)
-{
-	struct mlx5_esw_indir_table_rule *rule;
-
-	list_for_each_entry(rule, &e->recirc_rules, list)
-		if (rule->vni == attr->rx_tun_attr->vni &&
-		    !memcmp(&rule->dst_ip, &attr->rx_tun_attr->dst_ip,
-			    sizeof(attr->rx_tun_attr->dst_ip)))
-			goto found;
-	return NULL;
-
-found:
-	refcount_inc(&rule->refcnt);
-	return rule;
-}
-
 static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 					 struct mlx5_flow_attr *attr,
-					 struct mlx5_flow_spec *spec,
 					 struct mlx5_esw_indir_table_entry *e)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
@@ -130,73 +102,18 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_esw_indir_table_rule *rule;
 	struct mlx5_flow_act flow_act = {};
-	struct mlx5_flow_spec *rule_spec;
 	struct mlx5_flow_handle *handle;
 	int err = 0;
 	u32 data;
 
-	rule = mlx5_esw_indir_table_rule_lookup(e, esw_attr);
-	if (rule)
+	if (e->recirc_rule) {
+		refcount_inc(&e->recirc_rule->refcnt);
 		return 0;
-
-	if (e->recirc_cnt == MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX)
-		return -EINVAL;
-
-	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
-	if (!rule_spec)
-		return -ENOMEM;
-
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (!rule) {
-		err = -ENOMEM;
-		goto out;
 	}
 
-	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS |
-					   MLX5_MATCH_MISC_PARAMETERS |
-					   MLX5_MATCH_MISC_PARAMETERS_2;
-	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version)) {
-		MLX5_SET(fte_match_param, rule_spec->match_criteria,
-			 outer_headers.ip_version, 0xf);
-		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_version,
-			 attr->ip_version);
-	} else if (attr->ip_version) {
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.ethertype);
-		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ethertype,
-			 (attr->ip_version == 4 ? ETH_P_IP : ETH_P_IPV6));
-	} else {
-		err = -EOPNOTSUPP;
-		goto err_ethertype;
-	}
-
-	if (attr->ip_version == 4) {
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-		MLX5_SET(fte_match_param, rule_spec->match_value,
-			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(esw_attr->rx_tun_attr->dst_ip.v4));
-	} else if (attr->ip_version == 6) {
-		int len = sizeof(struct in6_addr);
-
-		memset(MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       0xff, len);
-		memcpy(MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &esw_attr->rx_tun_attr->dst_ip.v6, len);
-	}
-
-	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-			 misc_parameters.vxlan_vni);
-	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters.vxlan_vni,
-		 MLX5_GET(fte_match_param, spec->match_value, misc_parameters.vxlan_vni));
-
-	MLX5_SET(fte_match_param, rule_spec->match_criteria,
-		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
-	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
-		 mlx5_eswitch_get_vport_metadata_for_match(esw_attr->in_mdev->priv.eswitch,
-							   MLX5_VPORT_UPLINK));
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
 
 	/* Modify flow source to recirculate packet */
 	data = mlx5_eswitch_get_vport_metadata_for_set(esw, esw_attr->rx_tun_attr->decap_vport);
@@ -219,13 +136,14 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	flow_act.flags = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	flow_act.fg = e->recirc_grp;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = mlx5_chains_get_table(chains, 0, 1, 0);
 	if (IS_ERR(dest.ft)) {
 		err = PTR_ERR(dest.ft);
 		goto err_table;
 	}
-	handle = mlx5_add_flow_rules(e->ft, rule_spec, &flow_act, &dest, 1);
+	handle = mlx5_add_flow_rules(e->ft, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto err_handle;
@@ -233,14 +151,10 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 
 	mlx5e_mod_hdr_dealloc(&mod_acts);
 	rule->handle = handle;
-	rule->vni = esw_attr->rx_tun_attr->vni;
 	rule->mh = flow_act.modify_hdr;
-	memcpy(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
-	       sizeof(esw_attr->rx_tun_attr->dst_ip));
 	refcount_set(&rule->refcnt, 1);
-	list_add(&rule->list, &e->recirc_rules);
-	e->recirc_cnt++;
-	goto out;
+	e->recirc_rule = rule;
+	return 0;
 
 err_handle:
 	mlx5_chains_put_table(chains, 0, 1, 0);
@@ -250,89 +164,44 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 err_mod_hdr_regc1:
 	mlx5e_mod_hdr_dealloc(&mod_acts);
 err_mod_hdr_regc0:
-err_ethertype:
 	kfree(rule);
-out:
-	kvfree(rule_spec);
 	return err;
 }
 
 static void mlx5_esw_indir_table_rule_put(struct mlx5_eswitch *esw,
-					  struct mlx5_flow_attr *attr,
 					  struct mlx5_esw_indir_table_entry *e)
 {
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_esw_indir_table_rule *rule = e->recirc_rule;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
-	struct mlx5_esw_indir_table_rule *rule;
 
-	list_for_each_entry(rule, &e->recirc_rules, list)
-		if (rule->vni == esw_attr->rx_tun_attr->vni &&
-		    !memcmp(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
-			    sizeof(esw_attr->rx_tun_attr->dst_ip)))
-			goto found;
-
-	return;
+	if (!rule)
+		return;
 
-found:
 	if (!refcount_dec_and_test(&rule->refcnt))
 		return;
 
 	mlx5_del_flow_rules(rule->handle);
 	mlx5_chains_put_table(chains, 0, 1, 0);
 	mlx5_modify_header_dealloc(esw->dev, rule->mh);
-	list_del(&rule->list);
 	kfree(rule);
-	e->recirc_cnt--;
+	e->recirc_rule = NULL;
 }
 
-static int mlx5_create_indir_recirc_group(struct mlx5_eswitch *esw,
-					  struct mlx5_flow_attr *attr,
-					  struct mlx5_flow_spec *spec,
-					  struct mlx5_esw_indir_table_entry *e)
+static int mlx5_create_indir_recirc_group(struct mlx5_esw_indir_table_entry *e)
 {
 	int err = 0, inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	u32 *in, *match;
+	u32 *in;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
-	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS |
-		 MLX5_MATCH_MISC_PARAMETERS | MLX5_MATCH_MISC_PARAMETERS_2);
-	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
-
-	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version))
-		MLX5_SET(fte_match_param, match, outer_headers.ip_version, 0xf);
-	else
-		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ethertype);
-
-	if (attr->ip_version == 4) {
-		MLX5_SET_TO_ONES(fte_match_param, match,
-				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-	} else if (attr->ip_version == 6) {
-		memset(MLX5_ADDR_OF(fte_match_param, match,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       0xff, sizeof(struct in6_addr));
-	} else {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	MLX5_SET_TO_ONES(fte_match_param, match, misc_parameters.vxlan_vni);
-	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
-		 mlx5_eswitch_get_vport_metadata_mask());
 	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX);
 	e->recirc_grp = mlx5_create_flow_group(e->ft, in);
-	if (IS_ERR(e->recirc_grp)) {
+	if (IS_ERR(e->recirc_grp))
 		err = PTR_ERR(e->recirc_grp);
-		goto out;
-	}
 
-	INIT_LIST_HEAD(&e->recirc_rules);
-	e->recirc_cnt = 0;
-
-out:
 	kvfree(in);
 	return err;
 }
@@ -366,6 +235,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	flow_act.fg = e->fwd_grp;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
@@ -384,7 +254,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 
 static struct mlx5_esw_indir_table_entry *
 mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr,
-				  struct mlx5_flow_spec *spec, u16 vport, bool decap)
+				  u16 vport, bool decap)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
@@ -412,15 +282,14 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 	}
 	e->ft = ft;
 	e->vport = vport;
-	e->ip_version = attr->ip_version;
 	e->fwd_ref = !decap;
 
-	err = mlx5_create_indir_recirc_group(esw, attr, spec, e);
+	err = mlx5_create_indir_recirc_group(e);
 	if (err)
 		goto recirc_grp_err;
 
 	if (decap) {
-		err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
+		err = mlx5_esw_indir_table_rule_get(esw, attr, e);
 		if (err)
 			goto recirc_rule_err;
 	}
@@ -430,13 +299,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 		goto fwd_grp_err;
 
 	hash_add(esw->fdb_table.offloads.indir->table, &e->hlist,
-		 vport << 16 | attr->ip_version);
+		 vport << 16);
 
 	return e;
 
 fwd_grp_err:
 	if (decap)
-		mlx5_esw_indir_table_rule_put(esw, attr, e);
+		mlx5_esw_indir_table_rule_put(esw, e);
 recirc_rule_err:
 	mlx5_destroy_flow_group(e->recirc_grp);
 recirc_grp_err:
@@ -447,13 +316,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 }
 
 static struct mlx5_esw_indir_table_entry *
-mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_version)
+mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport)
 {
 	struct mlx5_esw_indir_table_entry *e;
-	u32 key = vport << 16 | ip_version;
+	u32 key = vport << 16;
 
 	hash_for_each_possible(esw->fdb_table.offloads.indir->table, e, hlist, key)
-		if (e->vport == vport && e->ip_version == ip_version)
+		if (e->vport == vport)
 			return e;
 
 	return NULL;
@@ -461,24 +330,23 @@ mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_ver
 
 struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 						 struct mlx5_flow_attr *attr,
-						 struct mlx5_flow_spec *spec,
 						 u16 vport, bool decap)
 {
 	struct mlx5_esw_indir_table_entry *e;
 	int err;
 
 	mutex_lock(&esw->fdb_table.offloads.indir->lock);
-	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
+	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
 	if (e) {
 		if (!decap) {
 			e->fwd_ref++;
 		} else {
-			err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
+			err = mlx5_esw_indir_table_rule_get(esw, attr, e);
 			if (err)
 				goto out_err;
 		}
 	} else {
-		e = mlx5_esw_indir_table_entry_create(esw, attr, spec, vport, decap);
+		e = mlx5_esw_indir_table_entry_create(esw, attr, vport, decap);
 		if (IS_ERR(e)) {
 			err = PTR_ERR(e);
 			esw_warn(esw->dev, "Failed to create indirection table, err %d.\n", err);
@@ -494,22 +362,21 @@ struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 }
 
 void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			      struct mlx5_flow_attr *attr,
 			      u16 vport, bool decap)
 {
 	struct mlx5_esw_indir_table_entry *e;
 
 	mutex_lock(&esw->fdb_table.offloads.indir->lock);
-	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
+	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
 	if (!e)
 		goto out;
 
 	if (!decap)
 		e->fwd_ref--;
 	else
-		mlx5_esw_indir_table_rule_put(esw, attr, e);
+		mlx5_esw_indir_table_rule_put(esw, e);
 
-	if (e->fwd_ref || e->recirc_cnt)
+	if (e->fwd_ref || e->recirc_rule)
 		goto out;
 
 	hash_del(&e->hlist);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
index 21d56b49d14b..036f5b3a341b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
@@ -13,10 +13,8 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir);
 
 struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 						 struct mlx5_flow_attr *attr,
-						 struct mlx5_flow_spec *spec,
 						 u16 vport, bool decap);
 void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			      struct mlx5_flow_attr *attr,
 			      u16 vport, bool decap);
 
 bool
@@ -44,7 +42,6 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir)
 static inline struct mlx5_flow_table *
 mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 			 struct mlx5_flow_attr *attr,
-			 struct mlx5_flow_spec *spec,
 			 u16 vport, bool decap)
 {
 	return ERR_PTR(-EOPNOTSUPP);
@@ -52,7 +49,6 @@ mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 
 static inline void
 mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			 struct mlx5_flow_attr *attr,
 			 u16 vport, bool decap)
 {
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 235f6f0a7052..34790a82a097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -178,15 +178,14 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 
 static int
 esw_setup_decap_indir(struct mlx5_eswitch *esw,
-		      struct mlx5_flow_attr *attr,
-		      struct mlx5_flow_spec *spec)
+		      struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_table *ft;
 
 	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
-	ft = mlx5_esw_indir_table_get(esw, attr, spec,
+	ft = mlx5_esw_indir_table_get(esw, attr,
 				      mlx5_esw_indir_table_decap_vport(attr), true);
 	return PTR_ERR_OR_ZERO(ft);
 }
@@ -196,7 +195,7 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 			struct mlx5_flow_attr *attr)
 {
 	if (mlx5_esw_indir_table_decap_vport(attr))
-		mlx5_esw_indir_table_put(esw, attr,
+		mlx5_esw_indir_table_put(esw,
 					 mlx5_esw_indir_table_decap_vport(attr),
 					 true);
 }
@@ -219,7 +218,6 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 		  struct mlx5_flow_act *flow_act,
 		  struct mlx5_eswitch *esw,
 		  struct mlx5_flow_attr *attr,
-		  struct mlx5_flow_spec *spec,
 		  int i)
 {
 	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
@@ -227,7 +225,7 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 	dest[i].ft = attr->dest_ft;
 
 	if (mlx5_esw_indir_table_decap_vport(attr))
-		return esw_setup_decap_indir(esw, attr, spec);
+		return esw_setup_decap_indir(esw, attr);
 	return 0;
 }
 
@@ -282,7 +280,7 @@ static void esw_put_dest_tables_loop(struct mlx5_eswitch *esw, struct mlx5_flow_
 			mlx5_chains_put_table(chains, 0, 1, 0);
 		else if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
 						     esw_attr->dests[i].mdev))
-			mlx5_esw_indir_table_put(esw, attr, esw_attr->dests[i].rep->vport,
+			mlx5_esw_indir_table_put(esw, esw_attr->dests[i].rep->vport,
 						 false);
 }
 
@@ -368,7 +366,6 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 		      struct mlx5_flow_act *flow_act,
 		      struct mlx5_eswitch *esw,
 		      struct mlx5_flow_attr *attr,
-		      struct mlx5_flow_spec *spec,
 		      bool ignore_flow_lvl,
 		      int *i)
 {
@@ -383,7 +380,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 			flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 		dest[*i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 
-		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr, spec,
+		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr,
 						       esw_attr->dests[j].rep->vport, false);
 		if (IS_ERR(dest[*i].ft)) {
 			err = PTR_ERR(dest[*i].ft);
@@ -392,7 +389,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 	}
 
 	if (mlx5_esw_indir_table_decap_vport(attr)) {
-		err = esw_setup_decap_indir(esw, attr, spec);
+		err = esw_setup_decap_indir(esw, attr);
 		if (err)
 			goto err_indir_tbl_get;
 	}
@@ -490,14 +487,14 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
 	} else if (esw_is_indir_table(esw, attr)) {
-		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
+		err = esw_setup_indir_table(dest, flow_act, esw, attr, true, i);
 	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
 		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
 	} else {
 		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
 
 		if (attr->dest_ft) {
-			err = esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
+			err = esw_setup_ft_dest(dest, flow_act, esw, attr, *i);
 			(*i)++;
 		} else if (attr->dest_chain) {
 			err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
@@ -699,11 +696,11 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	for (i = 0; i < esw_attr->split_count; i++) {
-		if (esw_is_indir_table(esw, attr))
-			err = esw_setup_indir_table(dest, &flow_act, esw, attr, spec, false, &i);
-		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
-			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
-							       &i);
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			/* Source port rewrite (forward to ovs internal port or statck device) isn't
+			 * supported in the rule of split action.
+			 */
+			err = -EOPNOTSUPP;
 		else
 			esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 038ae0fcf9d4..aed4e896179a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -70,7 +70,6 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
-	params->tunneled_offload_en = false;
 
 	/* CQE compression is not supported for IPoIB */
 	params->rx_cqe_compress_def = false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f07175549a87..59914f66857d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1339,8 +1339,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
 	mlx5_sf_dev_table_destroy(dev);
-	mlx5_sriov_detach(dev);
 	mlx5_eswitch_disable(dev->priv.eswitch);
+	mlx5_sriov_detach(dev);
 	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sf_hw_table_destroy(dev);
@@ -1752,11 +1752,11 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
 	 * fw_reset before unregistering the devlink.
 	 */
 	mlx5_drain_fw_reset(dev);
-	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 64d4e7125e9b..95dc67fb3001 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
+static u32 mlx5_get_ec_function(u32 function)
+{
+	return function >> 16;
+}
+
+static u32 mlx5_get_func_id(u32 function)
+{
+	return function & 0xffff;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -665,20 +675,22 @@ static int optimal_reclaimed_pages(void)
 }
 
 static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
-				   struct rb_root *root, u16 func_id)
+				   struct rb_root *root, u32 function)
 {
 	u64 recl_pages_to_jiffies = msecs_to_jiffies(mlx5_tout_ms(dev, RECLAIM_PAGES));
 	unsigned long end = jiffies + recl_pages_to_jiffies;
 
 	while (!RB_EMPTY_ROOT(root)) {
+		u32 ec_function = mlx5_get_ec_function(function);
+		u32 function_id = mlx5_get_func_id(function);
 		int nclaimed;
 		int err;
 
-		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
-				    &nclaimed, false, mlx5_core_is_ecpf(dev));
+		err = reclaim_pages(dev, function_id, optimal_reclaimed_pages(),
+				    &nclaimed, false, ec_function);
 		if (err) {
-			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
-				       err, func_id);
+			mlx5_core_warn(dev, "reclaim_pages err (%d) func_id=0x%x ec_func=0x%x\n",
+				       err, function_id, ec_function);
 			return err;
 		}
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff71..67ecdb9e708f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2931,6 +2931,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 
 static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 {
+	refcount_set(&mlxsw_sp->parsing.parsing_depth_ref, 0);
 	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
 	mlxsw_sp->parsing.vxlan_udp_dport = MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT;
 	mutex_init(&mlxsw_sp->parsing.lock);
@@ -2939,6 +2940,7 @@ static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	mutex_destroy(&mlxsw_sp->parsing.lock);
+	WARN_ON_ONCE(refcount_read(&mlxsw_sp->parsing.parsing_depth_ref));
 }
 
 struct mlxsw_sp_ipv6_addr_node {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 48f1fa62a4fd..ab0aa1a61d4a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10313,11 +10313,23 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 					      old_inc_parsing_depth);
 	return err;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	bool old_inc_parsing_depth = mlxsw_sp->router->inc_parsing_depth;
+
+	mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp, old_inc_parsing_depth,
+					      false);
+}
 #else
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 {
 	return 0;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+}
 #endif
 
 static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
@@ -10547,6 +10559,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
 err_dscp_init:
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
@@ -10587,6 +10600,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mlxsw_core_flush_owq();
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d61cd32ec3b6..86a93cac2647 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5083,6 +5083,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6190adf965bc..f55eed092f25 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f54849a3823..894e2690c643 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1455,8 +1455,6 @@ static int ravb_phy_init(struct net_device *ndev)
 		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -2379,6 +2377,8 @@ static int ravb_mdio_init(struct ravb_private *priv)
 {
 	struct platform_device *pdev = priv->pdev;
 	struct device *dev = &pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 	int error;
 
 	/* Bitbang init */
@@ -2400,6 +2400,14 @@ static int ravb_mdio_init(struct ravb_private *priv)
 	if (error)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 71a499113308..14dc5833c465 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2029,8 +2029,6 @@ static int sh_eth_phy_init(struct net_device *ndev)
 	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -3074,6 +3072,8 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	struct bb_info *bitbang;
 	struct platform_device *pdev = mdp->pdev;
 	struct device *dev = &mdp->pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 
 	/* create bit control struct for PHY */
 	bitbang = devm_kzalloc(dev, sizeof(struct bb_info), GFP_KERNEL);
@@ -3108,6 +3108,14 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	if (ret)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 8addee6d04bd..734a817d3c94 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -287,6 +287,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index acda6cbd0238..bdf4c8be2d53 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -433,6 +433,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..71712ea25403 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;
 
 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 047c581457e3..5813b07242ce 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -79,7 +79,7 @@
 #define SGMII_ABILITY			BIT(0)
 
 #define VEND1_MII_BASIC_CONFIG		0xAFC6
-#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_REV		BIT(4)
 #define MII_BASIC_CONFIG_SGMII		0x9
 #define MII_BASIC_CONFIG_RGMII		0x7
 #define MII_BASIC_CONFIG_RMII		0x5
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 00d9eff91dcf..df2c5435c5c4 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -199,8 +199,11 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452ff4da..5d6454fedb3f 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2200,6 +2200,13 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (rx_cmd_a & RX_CMD_A_LEN) - RXW_PADDING;
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x\n", rx_cmd_a);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bd385ccd0d18..a71786b3e7ba 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -701,7 +701,8 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	u32 frame_sz;
 
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
-	    skb_shinfo(skb)->nr_frags) {
+	    skb_shinfo(skb)->nr_frags ||
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		u32 size, len, max_head_size, off;
 		struct sk_buff *nskb;
 		struct page *page;
@@ -766,9 +767,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 
 		consume_skb(skb);
 		skb = nskb;
-	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
-		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
-		goto drop;
 	}
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index ed9c5e2cf3ad..a187f0e0b0f7 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -175,6 +175,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	arg.phy = phy;
 	init_completion(&arg.done);
 	cntx = phy->out_urb->context;
 	phy->out_urb->context = &arg;
diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 755460a73c0d..d2aa9f766738 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -282,13 +282,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2031fd960549..a95e48b51da6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -779,16 +779,26 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		range = page_address(ns->ctrl->discard_page);
 	}
 
-	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
-		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
-
-		if (n < segments) {
-			range[n].cattr = cpu_to_le32(0);
-			range[n].nlb = cpu_to_le32(nlb);
-			range[n].slba = cpu_to_le64(slba);
+	if (queue_max_discard_segments(req->q) == 1) {
+		u64 slba = nvme_sect_to_lba(ns, blk_rq_pos(req));
+		u32 nlb = blk_rq_sectors(req) >> (ns->lba_shift - 9);
+
+		range[0].cattr = cpu_to_le32(0);
+		range[0].nlb = cpu_to_le32(nlb);
+		range[0].slba = cpu_to_le64(slba);
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
+			u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
+
+			if (n < segments) {
+				range[n].cattr = cpu_to_le32(0);
+				range[n].nlb = cpu_to_le32(nlb);
+				range[n].slba = cpu_to_le64(slba);
+			}
+			n++;
 		}
-		n++;
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 778f94e9a445..100f774bc97f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3525,6 +3525,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 683b75a992b3..3235baf7cc6b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -755,8 +755,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_sq *sq = req->sq;
+
 	__nvmet_req_complete(req, status);
-	percpu_ref_put(&req->sq->ref);
+	percpu_ref_put(&sq->ref);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_complete);
 
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 3cef835b375f..feafa378bf8e 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -76,6 +76,27 @@ struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n)
 }
 EXPORT_SYMBOL_GPL(pci_bus_resource_n);
 
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+	int i;
+
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++) {
+		if (bus->resource[i] == res) {
+			bus->resource[i] = NULL;
+			return;
+		}
+	}
+
+	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
+		if (bus_res->res == res) {
+			list_del(&bus_res->list);
+			kfree(bus_res);
+			return;
+		}
+	}
+}
+
 void pci_bus_remove_resources(struct pci_bus *bus)
 {
 	int i;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 85e66574ec41..45a2fd6584d1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -341,9 +341,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8a438f248a82..de6914d57402 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -903,6 +903,7 @@ struct scmd_priv {
  * @admin_reply_ephase:Admin reply queue expected phase
  * @admin_reply_base: Admin reply queue base virtual address
  * @admin_reply_dma: Admin reply queue base dma address
+ * @admin_reply_q_in_use: Queue is handled by poll/ISR
  * @ready_timeout: Controller ready timeout
  * @intr_info: Interrupt cookie pointer
  * @intr_info_count: Number of interrupt cookies
@@ -1056,6 +1057,7 @@ struct mpi3mr_ioc {
 	u8 admin_reply_ephase;
 	void *admin_reply_base;
 	dma_addr_t admin_reply_dma;
+	atomic_t admin_reply_q_in_use;
 
 	u32 ready_timeout;
 
@@ -1391,4 +1393,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc);
 void mpi3mr_free_enclosure_list(struct mpi3mr_ioc *mrioc);
+int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc);
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1e4467ea8472..74fa7f90399e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -415,7 +415,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		    le64_to_cpu(scsi_reply->sense_data_buffer_address));
 }
 
-static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
+int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 {
 	u32 exp_phase = mrioc->admin_reply_ephase;
 	u32 admin_reply_ci = mrioc->admin_reply_ci;
@@ -423,12 +423,17 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	u64 reply_dma = 0;
 	struct mpi3_default_reply_descriptor *reply_desc;
 
+	if (!atomic_add_unless(&mrioc->admin_reply_q_in_use, 1, 1))
+		return 0;
+
 	reply_desc = (struct mpi3_default_reply_descriptor *)mrioc->admin_reply_base +
 	    admin_reply_ci;
 
 	if ((le16_to_cpu(reply_desc->reply_flags) &
-	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
+	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+		atomic_dec(&mrioc->admin_reply_q_in_use);
 		return 0;
+	}
 
 	do {
 		if (mrioc->unrecoverable)
@@ -454,6 +459,7 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	writel(admin_reply_ci, &mrioc->sysif_regs->admin_reply_queue_ci);
 	mrioc->admin_reply_ci = admin_reply_ci;
 	mrioc->admin_reply_ephase = exp_phase;
+	atomic_dec(&mrioc->admin_reply_q_in_use);
 
 	return num_admin_replies;
 }
@@ -2605,6 +2611,7 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc)
 	mrioc->admin_reply_ci = 0;
 	mrioc->admin_reply_ephase = 1;
 	mrioc->admin_reply_base = NULL;
+	atomic_set(&mrioc->admin_reply_q_in_use, 0);
 
 	if (!mrioc->admin_req_base) {
 		mrioc->admin_req_base = dma_alloc_coherent(&mrioc->pdev->dev,
@@ -3814,27 +3821,34 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
 	mpi3mr_print_ioc_info(mrioc);
 
-	dprint_init(mrioc, "allocating config page buffers\n");
-	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
-	if (!mrioc->cfg_page)
-		goto out_failed_noretry;
-
-	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
+	if (!mrioc->cfg_page) {
+		dprint_init(mrioc, "allocating config page buffers\n");
+		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
+		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
+		if (!mrioc->cfg_page) {
+			retval = -1;
+			goto out_failed_noretry;
+		}
+	}
 
-	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc,
-		    "%s :Failed to allocated reply sense buffers %d\n",
-		    __func__, retval);
-		goto out_failed_noretry;
+	if (!mrioc->init_cmds.reply) {
+		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc,
+			    "%s :Failed to allocated reply sense buffers %d\n",
+			    __func__, retval);
+			goto out_failed_noretry;
+		}
 	}
 
-	retval = mpi3mr_alloc_chain_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-		    retval);
-		goto out_failed_noretry;
+	if (!mrioc->chain_sgl_list) {
+		retval = mpi3mr_alloc_chain_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+			    retval);
+			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_issue_iocinit(mrioc);
@@ -3880,8 +3894,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		dprint_init(mrioc, "allocating memory for throttle groups\n");
 		sz = sizeof(struct mpi3mr_throttle_group_info);
 		mrioc->throttle_groups = kcalloc(mrioc->num_io_throttle_group, sz, GFP_KERNEL);
-		if (!mrioc->throttle_groups)
+		if (!mrioc->throttle_groups) {
+			retval = -1;
 			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_enable_events(mrioc);
@@ -3901,6 +3917,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller initialization failed\n");
 	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
@@ -4013,6 +4030,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		ioc_err(mrioc,
 		    "cannot create minimum number of operational queues expected:%d created:%d\n",
 		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		retval = -1;
 		goto out_failed_noretry;
 	}
 
@@ -4079,6 +4097,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller %s is failed\n",
 	    (is_resume)?"resume":"re-initialization");
@@ -4156,6 +4175,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
 	if (mrioc->admin_reply_base)
 		memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
+	atomic_set(&mrioc->admin_reply_q_in_use, 0);
 
 	if (mrioc->init_cmds.reply) {
 		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
@@ -4351,13 +4371,20 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-
+	if (mrioc->cfg_page) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
+		    mrioc->cfg_page, mrioc->cfg_page_dma);
+		mrioc->cfg_page = NULL;
+	}
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
 		mrioc->pel_seqnum_virt = NULL;
 	}
 
+	kfree(mrioc->throttle_groups);
+	mrioc->throttle_groups = NULL;
+
 	kfree(mrioc->logdata_buf);
 	mrioc->logdata_buf = NULL;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6eaeba41072c..6d55698ea4d1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3720,6 +3720,7 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 		mpi3mr_poll_pend_io_completions(mrioc);
 		mpi3mr_ioc_enable_intr(mrioc);
 		mpi3mr_poll_pend_io_completions(mrioc);
+		mpi3mr_process_admin_reply_q(mrioc);
 	}
 	switch (tm_type) {
 	case MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
@@ -5077,6 +5078,8 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
+	struct mpi3mr_hba_port *port, *hba_port_next;
+	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
 
 	if (!shost)
 		return;
@@ -5116,6 +5119,28 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_free_mem(mrioc);
 	mpi3mr_cleanup_resources(mrioc);
 
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
+	    &mrioc->sas_expander_list, list) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		mpi3mr_expander_node_remove(mrioc, sas_expander);
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	}
+	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
+		ioc_info(mrioc,
+		    "removing hba_port entry: %p port: %d from hba_port list\n",
+		    port, port->port_id);
+		list_del(&port->list);
+		kfree(port);
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	if (mrioc->sas_hba.num_phys) {
+		kfree(mrioc->sas_hba.phy);
+		mrioc->sas_hba.phy = NULL;
+		mrioc->sas_hba.num_phys = 0;
+	}
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3b61815979da..50263ba4f842 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,9 +9,6 @@
 
 #include "mpi3mr.h"
 
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_sas_node *sas_expander);
-
 /**
  * mpi3mr_post_transport_req - Issue transport requests and wait
  * @mrioc: Adapter instance reference
@@ -2163,7 +2160,7 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
  *
  * Return nothing.
  */
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_node *sas_expander)
 {
 	struct mpi3mr_sas_port *mr_sas_port, *next;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e5ecd6ada6cd..e8a4750f6ec4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -785,7 +785,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
-	if ((sas_port_add(port))) {
+	if (!port || (sas_port_add(port))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		goto out_fail;
@@ -824,6 +824,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			    mpt3sas_port->remote_identify.sas_address;
 	}
 
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_delete_port;
+	}
+
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if ((sas_rphy_add(rphy))) {
@@ -831,6 +837,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			__FILE__, __LINE__, __func__);
 		sas_rphy_free(rphy);
 		rphy = NULL;
+		goto out_delete_port;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -857,7 +864,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    rphy_to_expander_device(rphy), hba_port->port_id);
 	return mpt3sas_port;
 
- out_fail:
+out_delete_port:
+	sas_port_delete(port);
+
+out_fail:
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..24c4c9254359 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -326,6 +326,9 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE] __aligned(4);
 	int result;
 
+	if (sdev->no_vpd_size)
+		return SCSI_DEFAULT_VPD_LEN;
+
 	/*
 	 * Fetch the VPD page header to find out how big the page
 	 * is. This is done to prevent problems on legacy devices
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c7080454aea9..bc9d280417f6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -134,7 +134,7 @@ static struct {
 	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2},
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES},
+	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES | BLIST_NO_VPD_SIZE},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
@@ -188,6 +188,7 @@ static struct {
 	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d149b218715e..d12f2dcb4040 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1056,6 +1056,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (*bflags & BLIST_NO_VPD_SIZE)
+		sdev->no_vpd_size = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 00526fd37d7b..e55fb16fdc5a 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -138,6 +138,7 @@
 
 static DEFINE_SPINLOCK(svs_lock);
 
+#ifdef CONFIG_DEBUG_FS
 #define debug_fops_ro(name)						\
 	static int svs_##name##_debug_open(struct inode *inode,		\
 					   struct file *filp)		\
@@ -170,6 +171,7 @@ static DEFINE_SPINLOCK(svs_lock);
 	}
 
 #define svs_dentry_data(name)	{__stringify(name), &svs_##name##_debug_fops}
+#endif
 
 /**
  * enum svsb_phase - svs bank phase enumeration
@@ -628,6 +630,7 @@ static int svs_adjust_pm_opp_volts(struct svs_bank *svsb)
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int svs_dump_debug_show(struct seq_file *m, void *p)
 {
 	struct svs_platform *svsp = (struct svs_platform *)m->private;
@@ -843,6 +846,7 @@ static int svs_create_debug_cmds(struct svs_platform *svsp)
 
 	return 0;
 }
+#endif /* CONFIG_DEBUG_FS */
 
 static u32 interpolate(u32 f0, u32 f1, u32 v0, u32 v1, u32 fx)
 {
@@ -2444,11 +2448,13 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_iounmap;
 	}
 
+#ifdef CONFIG_DEBUG_FS
 	ret = svs_create_debug_cmds(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs create debug cmds fail: %d\n", ret);
 		goto svs_probe_iounmap;
 	}
+#endif
 
 	return 0;
 
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index f8e99995eee9..d94c3811a8f7 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -106,8 +106,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 
diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index 8aad15622a2e..8adfaa183f77 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -34,7 +34,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 0;
 	}
 
@@ -42,7 +42,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
 		up->lsr_saved_flags &= ~UART_LSR_BI;
 		port->serial_in(port, UART_RX);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 1;
 	}
 
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index b0f62345bc84..583a340f9934 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -253,8 +253,9 @@ config SERIAL_8250_ASPEED_VUART
 	tristate "Aspeed Virtual UART"
 	depends on SERIAL_8250
 	depends on OF
-	depends on REGMAP && MFD_SYSCON
+	depends on MFD_SYSCON
 	depends on ARCH_ASPEED || COMPILE_TEST
+	select REGMAP
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 434f83168546..4fce15296f31 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1311,7 +1311,7 @@ config SERIAL_FSL_LPUART
 
 config SERIAL_FSL_LPUART_CONSOLE
 	bool "Console on Freescale lpuart serial port"
-	depends on SERIAL_FSL_LPUART
+	depends on SERIAL_FSL_LPUART=y
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 	help
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index f9d667ce1619..c51883f34ac2 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2184,9 +2184,15 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* wait transmit engin complete */
-	lpuart32_write(&sport->port, 0, UARTMODIR);
-	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
+	 * asserted.
+	 */
+	if (!(old_ctrl & UARTCTRL_SBK)) {
+		lpuart32_write(&sport->port, 0, UARTMODIR);
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	}
 
 	/* disable transmit and receive */
 	lpuart32_write(&sport->port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),
diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 058fbe28107e..25fc4120b618 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -96,6 +96,7 @@ struct mlx5_vdpa_dev {
 	struct mlx5_control_vq cvq;
 	struct workqueue_struct *wq;
 	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
+	bool suspended;
 };
 
 int mlx5_vdpa_alloc_pd(struct mlx5_vdpa_dev *dev, u32 *pdn, u16 uid);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 3a6dbbc6440d..daac3ab31478 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2411,7 +2411,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_mr;
 
-	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK))
+	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
 		goto err_mr;
 
 	restore_channels_info(ndev);
@@ -2579,6 +2579,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	clear_vqs_ready(ndev);
 	mlx5_vdpa_destroy_mr(&ndev->mvdev);
 	ndev->mvdev.status = 0;
+	ndev->mvdev.suspended = false;
 	ndev->cur_num_vqs = 0;
 	ndev->mvdev.cvq.received_desc = 0;
 	ndev->mvdev.cvq.completed_desc = 0;
@@ -2815,6 +2816,8 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	struct mlx5_vdpa_virtqueue *mvq;
 	int i;
 
+	mlx5_vdpa_info(mvdev, "suspending device\n");
+
 	down_write(&ndev->reslock);
 	ndev->nb_registered = false;
 	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
@@ -2824,6 +2827,7 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 		suspend_vq(ndev, mvq);
 	}
 	mlx5_vdpa_cvq_suspend(mvdev);
+	mvdev->suspended = true;
 	up_write(&ndev->reslock);
 	return 0;
 }
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index cb88891b44a8..61bde476cf9c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -66,6 +66,7 @@ static void vdpasim_vq_notify(struct vringh *vring)
 static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
 	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
@@ -74,6 +75,18 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (struct vring_used *)
 			  (uintptr_t)vq->device_addr);
 
+	vq->vring.last_avail_idx = last_avail_idx;
+
+	/*
+	 * Since vdpa_sim does not support receive inflight descriptors as a
+	 * destination of a migration, let's set both avail_idx and used_idx
+	 * the same at vq start.  This is how vhost-user works in a
+	 * VHOST_SET_VRING_BASE call.
+	 *
+	 * Although the simple fix is to set last_used_idx at
+	 * vdpasim_set_vq_state, it would be reset at vdpasim_queue_ready.
+	 */
+	vq->vring.last_used_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 8fe267ca3e76..281287fae89f 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -645,8 +645,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
 	struct virtio_pci_modern_device *mdev = NULL;
 
 	mdev = vp_vdpa_mgtdev->mdev;
-	vp_modern_remove(mdev);
 	vdpa_mgmtdev_unregister(&vp_vdpa_mgtdev->mgtdev);
+	vp_modern_remove(mdev);
 	kfree(vp_vdpa_mgtdev->mgtdev.id_table);
 	kfree(mdev);
 	kfree(vp_vdpa_mgtdev);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfde..b7657984dd8d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1134,6 +1134,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 
 err_attach:
 	iommu_domain_free(v->domain);
+	v->domain = NULL;
 	return ret;
 }
 
@@ -1178,6 +1179,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 			vhost_vdpa_remove_as(v, asid);
 	}
 
+	vhost_vdpa_free_domain(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 }
@@ -1250,7 +1252,6 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index f1c1c95c1fdf..2ecb97c619b7 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -358,16 +358,21 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	if (pci_enable_device(dp) < 0) {
+	rc = pci_enable_device(dp);
+	if (rc < 0) {
 		dev_err(&dp->dev, "Cannot enable PCI device\n");
 		goto err_out;
 	}
 
-	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
+	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 	addr = pci_resource_start(dp, 0);
-	if (addr == 0)
+	if (addr == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 
 	p = framebuffer_alloc(0, &dp->dev);
 	if (p == NULL) {
@@ -417,7 +422,8 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 
 	init_chips(p, addr);
 
-	if (register_framebuffer(p) < 0) {
+	rc = register_framebuffer(p);
+	if (rc < 0) {
 		dev_err(&dp->dev,"C&T 65550 framebuffer failed to register\n");
 		goto err_unmap;
 	}
diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 583cbcf09446..a3cf1f764f29 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -309,17 +309,18 @@ void fb_deferred_io_open(struct fb_info *info,
 			 struct inode *inode,
 			 struct file *file)
 {
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
 	file->f_mapping->a_ops = &fb_deferred_io_aops;
+	fbdefio->open_count++;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
-void fb_deferred_io_release(struct fb_info *info)
+static void fb_deferred_io_lastclose(struct fb_info *info)
 {
-	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *page;
 	int i;
 
-	BUG_ON(!fbdefio);
 	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
@@ -328,13 +329,21 @@ void fb_deferred_io_release(struct fb_info *info)
 		page->mapping = NULL;
 	}
 }
+
+void fb_deferred_io_release(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	if (!--fbdefio->open_count)
+		fb_deferred_io_lastclose(info);
+}
 EXPORT_SYMBOL_GPL(fb_deferred_io_release);
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	fb_deferred_io_release(info);
+	fb_deferred_io_lastclose(info);
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 3feb6e40d56d..ef8a4c5fc687 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -921,6 +921,28 @@ SETUP_HCRX(struct stifb_info *fb)
 
 /* ------------------- driver specific functions --------------------------- */
 
+static int
+stifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (var->xres != fb->info.var.xres ||
+	    var->yres != fb->info.var.yres ||
+	    var->bits_per_pixel != fb->info.var.bits_per_pixel)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->grayscale = fb->info.var.grayscale;
+	var->red.length = fb->info.var.red.length;
+	var->green.length = fb->info.var.green.length;
+	var->blue.length = fb->info.var.blue.length;
+
+	return 0;
+}
+
 static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
@@ -1145,6 +1167,7 @@ stifb_init_display(struct stifb_info *fb)
 
 static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= stifb_check_var,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
 	.fb_fillrect	= stifb_fillrect,
@@ -1164,6 +1187,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	struct stifb_info *fb;
 	struct fb_info *info;
 	unsigned long sti_rom_address;
+	char modestr[32];
 	char *dev_name;
 	int bpp, xres, yres;
 
@@ -1342,6 +1366,9 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
+	scnprintf(modestr, sizeof(modestr), "%dx%d-%d", xres, yres, bpp);
+	fb_find_mode(&info->var, info, modestr, NULL, 0, NULL, bpp);
+
 	/* This has to be done !!! */
 	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
 		goto out_err1;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 6de888bce1bb..741d12f75726 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -31,6 +31,9 @@
 #define AAD_LEN		48
 #define MSG_HDR_VER	1
 
+#define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
+#define SNP_REQ_RETRY_DELAY		(2*HZ)
+
 struct snp_guest_crypto {
 	struct crypto_aead *tfm;
 	u8 *iv, *authtag;
@@ -320,26 +323,14 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	return __enc_payload(snp_dev, req, payload, sz);
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, int msg_ver,
-				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz, __u64 *fw_err)
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, __u64 *fw_err)
 {
-	unsigned long err;
-	u64 seqno;
+	unsigned long err = 0xff, override_err = 0;
+	unsigned long req_start = jiffies;
+	unsigned int override_npages = 0;
 	int rc;
 
-	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
-	if (!seqno)
-		return -EIO;
-
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
-
-	/* Encrypt the userspace provided payload */
-	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
-	if (rc)
-		return rc;
-
+retry_request:
 	/*
 	 * Call firmware to process the request. In this function the encrypted
 	 * message enters shared memory with the host. So after this call the
@@ -347,18 +338,24 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	 * prevent reuse of the IV.
 	 */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+	switch (rc) {
+	case -ENOSPC:
+		/*
+		 * If the extended guest request fails due to having too
+		 * small of a certificate data buffer, retry the same
+		 * guest request without the extended data request in
+		 * order to increment the sequence number and thus avoid
+		 * IV reuse.
+		 */
+		override_npages = snp_dev->input.data_npages;
+		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
-	/*
-	 * If the extended guest request fails due to having too small of a
-	 * certificate data buffer, retry the same guest request without the
-	 * extended data request in order to increment the sequence number
-	 * and thus avoid IV reuse.
-	 */
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-	    err == SNP_GUEST_REQ_INVALID_LEN) {
-		const unsigned int certs_npages = snp_dev->input.data_npages;
-
-		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+		/*
+		 * Override the error to inform callers the given extended
+		 * request buffer size was too small and give the caller the
+		 * required buffer size.
+		 */
+		override_err	= SNP_GUEST_REQ_INVALID_LEN;
 
 		/*
 		 * If this call to the firmware succeeds, the sequence number can
@@ -368,15 +365,20 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 		 * of the VMPCK and the error code being propagated back to the
 		 * user as an ioctl() return code.
 		 */
-		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+		goto retry_request;
 
-		/*
-		 * Override the error to inform callers the given extended
-		 * request buffer size was too small and give the caller the
-		 * required buffer size.
-		 */
-		err = SNP_GUEST_REQ_INVALID_LEN;
-		snp_dev->input.data_npages = certs_npages;
+	/*
+	 * The host may return SNP_GUEST_REQ_ERR_EBUSY if the request has been
+	 * throttled. Retry in the driver to avoid returning and reusing the
+	 * message sequence number on a different message.
+	 */
+	case -EAGAIN:
+		if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
+			rc = -ETIMEDOUT;
+			break;
+		}
+		schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
+		goto retry_request;
 	}
 
 	/*
@@ -388,7 +390,10 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	snp_inc_msg_seqno(snp_dev);
 
 	if (fw_err)
-		*fw_err = err;
+		*fw_err = override_err ?: err;
+
+	if (override_npages)
+		snp_dev->input.data_npages = override_npages;
 
 	/*
 	 * If an extended guest request was issued and the supplied certificate
@@ -396,29 +401,49 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	 * prevent IV reuse. If the standard request was successful, return -EIO
 	 * back to the caller as would have originally been returned.
 	 */
-	if (!rc && err == SNP_GUEST_REQ_INVALID_LEN)
+	if (!rc && override_err == SNP_GUEST_REQ_INVALID_LEN)
+		return -EIO;
+
+	return rc;
+}
+
+static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, int msg_ver,
+				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
+				u32 resp_sz, __u64 *fw_err)
+{
+	u64 seqno;
+	int rc;
+
+	/* Get message sequence and verify that its a non-zero */
+	seqno = snp_get_msg_seqno(snp_dev);
+	if (!seqno)
 		return -EIO;
 
+	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+
+	/* Encrypt the userspace provided payload */
+	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
+	if (rc)
+		return rc;
+
+	rc = __handle_guest_request(snp_dev, exit_code, fw_err);
 	if (rc) {
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
-			  rc, *fw_err);
-		goto disable_vmpck;
+		if (rc == -EIO && *fw_err == SNP_GUEST_REQ_INVALID_LEN)
+			return rc;
+
+		dev_alert(snp_dev->dev, "Detected error from ASP request. rc: %d, fw_err: %llu\n", rc, *fw_err);
+		snp_disable_vmpck(snp_dev);
+		return rc;
 	}
 
 	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
 	if (rc) {
-		dev_alert(snp_dev->dev,
-			  "Detected unexpected decode failure from ASP. rc: %d\n",
-			  rc);
-		goto disable_vmpck;
+		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
+		snp_disable_vmpck(snp_dev);
+		return rc;
 	}
 
 	return 0;
-
-disable_vmpck:
-	snp_disable_vmpck(snp_dev);
-	return rc;
 }
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
@@ -705,6 +730,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	void __iomem *mapping;
 	int ret;
 
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return -ENODEV;
+
 	if (!dev->platform_data)
 		return -ENODEV;
 
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 442718cf61b8..7a2862c10afb 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -233,15 +233,32 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
 
-		rc = SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+		} else {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMPOUND_FID,
+						COMPOUND_FID,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 381babc1212c..d827b7547ffa 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -425,7 +425,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
-		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 3851d0aaa288..c961b90f92b9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -297,7 +297,7 @@ static int
 __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		struct smb_rqst *rqst)
 {
-	int rc = 0;
+	int rc;
 	struct kvec *iov;
 	int n_vec;
 	unsigned int send_length = 0;
@@ -308,6 +308,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -316,14 +317,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto smbd_done;
 	}
 
+	rc = -EAGAIN;
 	if (ssocket == NULL)
-		return -EAGAIN;
+		goto out;
 
+	rc = -ERESTARTSYS;
 	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		goto out;
 	}
 
+	rc = 0;
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
 
@@ -434,7 +438,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -853,9 +858,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1146,9 +1149,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1398,9 +1399,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1541,9 +1540,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34c87fcfd061..eea11ad84e68 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4807,13 +4807,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
-	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		ext4_error_inode(inode, function, line, 0,
-				 "iget: root inode unallocated");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
-
 	if ((flags & EXT4_IGET_HANDLE) &&
 	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
 		ret = -ESTALE;
@@ -4886,11 +4879,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	 * NeilBrown 1999oct15
 	 */
 	if (inode->i_nlink == 0) {
-		if ((inode->i_mode == 0 ||
+		if ((inode->i_mode == 0 || flags & EXT4_IGET_SPECIAL ||
 		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
 		    ino != EXT4_BOOT_LOADER_INO) {
-			/* this inode is deleted */
-			ret = -ESTALE;
+			/* this inode is deleted or unallocated */
+			if (flags & EXT4_IGET_SPECIAL) {
+				ext4_error_inode(inode, function, line, 0,
+						 "iget: special inode unallocated");
+				ret = -EFSCORRUPTED;
+			} else
+				ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 800d631c920b..56f09598448b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3884,10 +3884,8 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval) {
-			inode_unlock(old.inode);
+		if (retval)
 			goto end_rename;
-		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 801160099958..2528e8216c33 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5967,8 +5967,11 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!really_read_only && journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev = cpu_to_le32(journal_devnum);
-
-		/* Make sure we flush the recovery flag to disk. */
+		ext4_commit_super(sb);
+	}
+	if (!really_read_only && journal_inum &&
+	    journal_inum != le32_to_cpu(es->s_journal_inum)) {
+		es->s_journal_inum = cpu_to_le32(journal_inum);
 		ext4_commit_super(sb);
 	}
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e0eb6eb02a83..b17c1b90e122 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -386,6 +386,17 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	struct inode *inode;
 	int err;
 
+	/*
+	 * We have to check for this corruption early as otherwise
+	 * iget_locked() could wait indefinitely for the state of our
+	 * parent inode.
+	 */
+	if (parent->i_ino == ea_ino) {
+		ext4_error(parent->i_sb,
+			   "Parent and EA inode have the same ino %lu", ea_ino);
+		return -EFSCORRUPTED;
+	}
+
 	inode = ext4_iget(parent->i_sb, ea_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index ba86acbe12d3..0479096b96e4 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -137,19 +137,18 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
-	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
 	jffs2_dbg(1, "%s()\n", __func__);
 
-	if (pageofs > inode->i_size) {
-		/* Make new hole frag from old EOF to new page */
+	if (pos > inode->i_size) {
+		/* Make new hole frag from old EOF to new position */
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
 
-		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
-			  (unsigned int)inode->i_size, pageofs);
+		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new position\n",
+			  (unsigned int)inode->i_size, (uint32_t)pos);
 
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
@@ -169,10 +168,10 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ri.mode = cpu_to_jemode(inode->i_mode);
 		ri.uid = cpu_to_je16(i_uid_read(inode));
 		ri.gid = cpu_to_je16(i_gid_read(inode));
-		ri.isize = cpu_to_je32(max((uint32_t)inode->i_size, pageofs));
+		ri.isize = cpu_to_je32((uint32_t)pos);
 		ri.atime = ri.ctime = ri.mtime = cpu_to_je32(JFFS2_NOW());
 		ri.offset = cpu_to_je32(inode->i_size);
-		ri.dsize = cpu_to_je32(pageofs - inode->i_size);
+		ri.dsize = cpu_to_je32((uint32_t)pos - inode->i_size);
 		ri.csize = cpu_to_je32(0);
 		ri.compr = JFFS2_COMPR_ZERO;
 		ri.node_crc = cpu_to_je32(crc32(0, &ri, sizeof(ri)-8));
@@ -202,7 +201,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			goto out_err;
 		}
 		jffs2_complete_reservation(c);
-		inode->i_size = pageofs;
+		inode->i_size = pos;
 		mutex_unlock(&f->sem);
 	}
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1d65f6ef00ca..0394505fdce3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 6b65b0dfb4fb..288c6feda5de 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -447,11 +447,11 @@ struct drm_bridge_funcs {
 	 *
 	 * The returned array must be allocated with kmalloc() and will be
 	 * freed by the caller. If the allocation fails, NULL should be
-	 * returned. num_output_fmts must be set to the returned array size.
+	 * returned. num_input_fmts must be set to the returned array size.
 	 * Formats listed in the returned array should be listed in decreasing
 	 * preference order (the core will try all formats until it finds one
 	 * that works). When the format is not supported NULL should be
-	 * returned and num_output_fmts should be set to 0.
+	 * returned and num_input_fmts should be set to 0.
 	 *
 	 * This method is called on all elements of the bridge chain as part of
 	 * the bus format negotiation process that happens in
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index bd42f25e449c..60b2dda8d964 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -472,7 +472,9 @@ int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 void drm_gem_lru_init(struct drm_gem_lru *lru, struct mutex *lock);
 void drm_gem_lru_remove(struct drm_gem_object *obj);
 void drm_gem_lru_move_tail(struct drm_gem_lru *lru, struct drm_gem_object *obj);
-unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
+unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru,
+			       unsigned int nr_to_scan,
+			       unsigned long *remaining,
 			       bool (*shrink)(struct drm_gem_object *obj));
 
 #endif /* __DRM_GEM_H__ */
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d6119c5d1069..a9764cbf7f8d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -228,6 +228,12 @@ static inline unsigned short req_get_ioprio(struct request *req)
 	*(listptr) = rq;				\
 } while (0)
 
+#define rq_list_add_tail(lastpptr, rq)	do {		\
+	(rq)->rq_next = NULL;				\
+	**(lastpptr) = rq;				\
+	*(lastpptr) = &rq->rq_next;			\
+} while (0)
+
 #define rq_list_pop(listptr)				\
 ({							\
 	struct request *__req = NULL;			\
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 486c4e3b6d6a..c7f0f14e1f74 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -212,6 +212,7 @@ struct fb_deferred_io {
 	/* delay between mkwrite and deferred handler */
 	unsigned long delay;
 	bool sort_pagereflist; /* sort pagelist by offset */
+	int open_count; /* number of opened files; protected by fb_info lock */
 	struct mutex lock; /* mutex that protects the pageref list */
 	struct list_head pagereflist; /* list of pagerefs for touched pages */
 	/* callback */
diff --git a/include/linux/interconnect-provider.h b/include/linux/interconnect-provider.h
index cd5c5a27557f..d12cd18aab3f 100644
--- a/include/linux/interconnect-provider.h
+++ b/include/linux/interconnect-provider.h
@@ -122,6 +122,9 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst);
 void icc_node_add(struct icc_node *node, struct icc_provider *provider);
 void icc_node_del(struct icc_node *node);
 int icc_nodes_remove(struct icc_provider *provider);
+void icc_provider_init(struct icc_provider *provider);
+int icc_provider_register(struct icc_provider *provider);
+void icc_provider_deregister(struct icc_provider *provider);
 int icc_provider_add(struct icc_provider *provider);
 void icc_provider_del(struct icc_provider *provider);
 struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec);
@@ -167,6 +170,15 @@ static inline int icc_nodes_remove(struct icc_provider *provider)
 	return -ENOTSUPP;
 }
 
+static inline void icc_provider_init(struct icc_provider *provider) { }
+
+static inline int icc_provider_register(struct icc_provider *provider)
+{
+	return -ENOTSUPP;
+}
+
+static inline void icc_provider_deregister(struct icc_provider *provider) { }
+
 static inline int icc_provider_add(struct icc_provider *provider)
 {
 	return -ENOTSUPP;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba2bd604359d..b072449b0f1a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -294,9 +294,11 @@ struct hh_cache {
  * relationship HH alignment <= LL alignment.
  */
 #define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
-	((((dev)->hard_header_len+(dev)->needed_headroom+(extra))&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
 struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cb538bc57971..d20695184e0b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1417,6 +1417,7 @@ void pci_bus_add_resource(struct pci_bus *bus, struct resource *res,
 			  unsigned int flags);
 struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
 void pci_bus_remove_resources(struct pci_bus *bus);
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res);
 int devm_request_pci_bus_resources(struct device *dev,
 				   struct list_head *resources);
 
diff --git a/include/linux/sh_intc.h b/include/linux/sh_intc.h
index c255273b0281..37ad81058d6a 100644
--- a/include/linux/sh_intc.h
+++ b/include/linux/sh_intc.h
@@ -97,7 +97,10 @@ struct intc_hw_desc {
 	unsigned int nr_subgroups;
 };
 
-#define _INTC_ARRAY(a) a, __same_type(a, NULL) ? 0 : sizeof(a)/sizeof(*a)
+#define _INTC_SIZEOF_OR_ZERO(a) (_Generic(a,                 \
+                                 typeof(NULL):  0,           \
+                                 default:       sizeof(a)))
+#define _INTC_ARRAY(a) a, _INTC_SIZEOF_OR_ZERO(a)/sizeof(*a)
 
 #define INTC_HW_DESC(vectors, groups, mask_regs,	\
 		     prio_regs,	sense_regs, ack_regs)	\
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 4b33b95eb8be..b01421902cfc 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -231,12 +231,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  *
- * When lockdep is enabled, we make sure to always do the RCU portions of
- * the tracepoint code, regardless of whether tracing is on. However,
- * don't check if the condition is false, due to interaction with idle
- * instrumentation. This lets us find RCU issues triggered with tracepoints
- * even when this tracepoint is off. This code has no purpose other than
- * poking RCU a bit.
+ * When lockdep is enabled, we make sure to always test if RCU is
+ * "watching" regardless if the tracepoint is enabled or not. Tracepoints
+ * require RCU to be active, and it should always warn at the tracepoint
+ * site if it is not watching, as it will need to be active when the
+ * tracepoint is enabled.
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto)		\
 	extern int __traceiter_##name(data_proto);			\
@@ -249,9 +248,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 				TP_ARGS(args),				\
 				TP_CONDITION(cond), 0);			\
 		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
-			rcu_read_lock_sched_notrace();			\
-			rcu_dereference_sched(__tracepoint_##name.funcs);\
-			rcu_read_unlock_sched_notrace();		\
+			WARN_ON_ONCE(!rcu_is_watching());		\
 		}							\
 	}								\
 	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c36656d8ac6c..006858ed04e8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -145,6 +145,7 @@ struct scsi_device {
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 
+#define SCSI_DEFAULT_VPD_LEN	255	/* default SCSI VPD page size (max) */
 	struct scsi_vpd __rcu *vpd_pg0;
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
@@ -214,6 +215,7 @@ struct scsi_device {
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
+	unsigned no_vpd_size:1;		/* No VPD size reported in header */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c7..6b548dc2c496 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,7 +32,8 @@
 #define BLIST_IGN_MEDIA_CHANGE	((__force blist_flags_t)(1ULL << 11))
 /* do not do automatic start on add */
 #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
-#define __BLIST_UNUSED_13	((__force blist_flags_t)(1ULL << 13))
+/* do not ask for VPD page size first on some broken targets */
+#define BLIST_NO_VPD_SIZE	((__force blist_flags_t)(1ULL << 13))
 #define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
 #define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
 #define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
@@ -74,8 +75,7 @@
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
 			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
-#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_13 | \
-			     __BLIST_UNUSED_14 | \
+#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_14 | \
 			     __BLIST_UNUSED_15 | \
 			     __BLIST_UNUSED_16 | \
 			     __BLIST_UNUSED_24 | \
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7d5b544cfc30..3526389ac218 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -84,6 +84,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *src_file;
 	int ret;
 
+	if (msg->len)
+		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
@@ -120,7 +122,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0, true))
 		ret = -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3b9e86108f43..227ada724029 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2170,7 +2170,7 @@ static void perf_group_detach(struct perf_event *event)
 		/* Inherit group flags from the previous leader */
 		sibling->group_caps = event->group_caps;
 
-		if (!RB_EMPTY_NODE(&event->group_node)) {
+		if (sibling->attach_state & PERF_ATTACH_CONTEXT) {
 			add_event_to_groups(sibling, event->ctx);
 
 			if (sibling->state == PERF_EVENT_STATE_ACTIVE)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6f726ea0fde0..59062fedeaf7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1537,7 +1537,8 @@ static struct dyn_ftrace *lookup_rec(unsigned long start, unsigned long end)
 	key.flags = end;	/* overload flags, as it is unsigned long */
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (end < pg->records[0].ip ||
+		if (pg->index == 0 ||
+		    end < pg->records[0].ip ||
 		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec = bsearch(&key, pg->records, pg->index,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f70765780ed3..888980257340 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5120,6 +5120,8 @@ loff_t tracing_lseek(struct file *file, loff_t offset, int whence)
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index da3bfe8625d9..e3df03cdecbc 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1330,6 +1330,9 @@ static const char *hist_field_name(struct hist_field *field,
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 
diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index d440ddd5fd8b..c4945f8adc11 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -492,6 +492,10 @@ static int start_cpu_kthread(unsigned int cpu)
 {
 	struct task_struct *kthread;
 
+	/* Do not start a new hwlatd thread if it is already running */
+	if (per_cpu(hwlat_per_cpu_data, cpu).kthread)
+		return 0;
+
 	kthread = kthread_run_on_cpu(kthread_fn, NULL, cpu, "hwlatd/%u");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
@@ -584,9 +588,6 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 	 */
 	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 
-	for_each_online_cpu(cpu)
-		per_cpu(hwlat_per_cpu_data, cpu).kthread = NULL;
-
 	for_each_cpu(cpu, current_mask) {
 		retval = start_cpu_kthread(cpu);
 		if (retval)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0729973d486a..b8d654963df8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2004,7 +2004,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd;
+	pmd_t _pmd, old_pmd;
 	int i;
 
 	/*
@@ -2015,7 +2015,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	 *
 	 * See Documentation/mm/mmu_notifier.rst
 	 */
-	pmdp_huge_clear_flush(vma, haddr, pmd);
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -2024,6 +2024,8 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		pte_t *pte, entry;
 		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
+		if (pmd_uffd_wp(old_pmd))
+			entry = pte_mkuffd_wp(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
diff --git a/mm/mincore.c b/mm/mincore.c
index fa200c14185f..1eb6aac88d84 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -33,7 +33,7 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
 	 */
-	present = pte && !huge_pte_none(huge_ptep_get(pte));
+	present = pte && !huge_pte_none_mostly(huge_ptep_get(pte));
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
diff --git a/net/9p/client.c b/net/9p/client.c
index 554a4b11f4fe..af59c3f2ec2e 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1284,7 +1284,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd4..5fe075bf479e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1852,6 +1852,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int new_master_mtu;
 	int old_master_mtu;
 	int mtu_limit;
+	int overhead;
 	int cpu_mtu;
 	int err;
 
@@ -1880,9 +1881,10 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			largest_mtu = slave_mtu;
 	}
 
-	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
+	overhead = dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu + overhead);
 	old_master_mtu = master->mtu;
-	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	new_master_mtu = largest_mtu + overhead;
 	if (new_master_mtu > mtu_limit)
 		return -ERANGE;
 
@@ -1917,8 +1919,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
-		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
+		dsa_port_mtu_change(cpu_dp, old_master_mtu - overhead);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b5736ef16ed2..390f4be7f7be 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -576,6 +576,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index cd8b2f7a8f34..f0750c06d5ff 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -828,8 +828,14 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
 
-	if (sk->sk_family != tb->family)
+	if (sk->sk_family != tb->family) {
+		if (sk->sk_family == AF_INET)
+			return net_eq(ib2_net(tb), net) && tb->port == port &&
+				tb->l3mdev == l3mdev &&
+				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+
 		return false;
+	}
 
 	if (sk->sk_family == AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 019f3b0839c5..24961b304dad 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -614,10 +614,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
-	if (headroom > dev->needed_headroom)
-		dev->needed_headroom = headroom;
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		goto tx_dropped;
 	}
@@ -800,10 +800,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c69f4d966024..925594dbeb92 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3608,7 +3608,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write(th, NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2fb4c6ad7243..afc922c88d17 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1241,8 +1241,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index eb0295d90039..fc3fddeb6f36 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -83,7 +83,7 @@ struct iucv_irq_data {
 	u16 ippathid;
 	u8  ipflags1;
 	u8  iptype;
-	u32 res2[8];
+	u32 res2[9];
 };
 
 struct iucv_irq_list {
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5e38a0abbaba..1c69e476f4ad 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -987,9 +987,13 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	return ret;
 }
 
+static struct lock_class_key mptcp_slock_keys[2];
+static struct lock_class_key mptcp_keys[2];
+
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	bool is_ipv6 = sk->sk_family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct socket *ssock;
@@ -1006,6 +1010,18 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (!newsk)
 		return -EINVAL;
 
+	/* The subflow socket lock is acquired in a nested to the msk one
+	 * in several places, even by the TCP stack, and this msk is a kernel
+	 * socket: lockdep complains. Instead of propagating the _nested
+	 * modifiers in several places, re-init the lock class for the msk
+	 * socket to an mptcp specific one.
+	 */
+	sock_lock_init_class_and_name(newsk,
+				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
+				      &mptcp_slock_keys[is_ipv6],
+				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
+				      &mptcp_keys[is_ipv6]);
+
 	lock_sock(newsk);
 	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
 	release_sock(newsk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c4971bc42f60..1e10a38ccf9d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -358,7 +358,6 @@ void mptcp_subflow_reset(struct sock *ssk)
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
@@ -560,7 +559,7 @@ static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
-static struct proto tcpv6_prot_override;
+static struct proto tcpv6_prot_override __ro_after_init;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -846,7 +845,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 }
 
 static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
-static struct proto tcp_prot_override;
+static struct proto tcp_prot_override __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,
@@ -1376,6 +1375,13 @@ static void subflow_error_report(struct sock *ssk)
 {
 	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
 
+	/* bail early if this is a no-op, so that we avoid introducing a
+	 * problematic lockdep dependency between TCP accept queue lock
+	 * and msk socket spinlock
+	 */
+	if (!sk->sk_socket)
+		return;
+
 	mptcp_data_lock(sk);
 	if (!sock_owned_by_user(sk))
 		__mptcp_error_report(sk);
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 2a0adc497bbb..026b4f87d96c 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -43,7 +43,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	u32 plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e5fd6995e4bf..353c090f8891 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -226,7 +226,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5086adfe731c..5ed64b2bd15e 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -235,7 +235,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 53f63bfbaf5f..89105e95b452 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -114,6 +114,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	union smc_host_cursor cfed;
 	int rc;
 
+	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
+		return -ENOBUFS;
+
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c19d4b7c1f28..0208dfb35345 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1459,7 +1459,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
 	/* cancel free_work sync, will terminate when lgr->freeing is set */
-	cancel_delayed_work_sync(&lgr->free_work);
+	cancel_delayed_work(&lgr->free_work);
 	lgr->terminating = 1;
 
 	/* kill remaining link group connections */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4d4de49f7ab6..7320d676ce3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8815,7 +8815,7 @@ static bool cfg80211_off_channel_oper_allowed(struct wireless_dev *wdev,
 		struct cfg80211_chan_def *chandef;
 
 		chandef = wdev_chandef(wdev, link_id);
-		if (!chandef)
+		if (!chandef || !chandef->chan)
 			continue;
 
 		/*
@@ -10699,8 +10699,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 
 static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device *rdev,
 					      const u8 *ssid, int ssid_len,
-					      struct nlattr **attrs,
-					      const u8 **bssid_out)
+					      struct nlattr **attrs)
 {
 	struct ieee80211_channel *chan;
 	struct cfg80211_bss *bss;
@@ -10727,7 +10726,6 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 	if (!bss)
 		return ERR_PTR(-ENOENT);
 
-	*bssid_out = bssid;
 	return bss;
 }
 
@@ -10737,7 +10735,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct cfg80211_assoc_request req = {};
 	struct nlattr **attrs = NULL;
-	const u8 *bssid, *ssid;
+	const u8 *ap_addr, *ssid;
 	unsigned int link_id;
 	int err, ssid_len;
 
@@ -10874,6 +10872,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 
 		req.ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+		ap_addr = req.ap_mld_addr;
 
 		attrs = kzalloc(attrsize, GFP_KERNEL);
 		if (!attrs)
@@ -10899,8 +10898,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 				goto free;
 			}
 			req.links[link_id].bss =
-				nl80211_assoc_bss(rdev, ssid, ssid_len, attrs,
-						  &bssid);
+				nl80211_assoc_bss(rdev, ssid, ssid_len, attrs);
 			if (IS_ERR(req.links[link_id].bss)) {
 				err = PTR_ERR(req.links[link_id].bss);
 				req.links[link_id].bss = NULL;
@@ -10951,10 +10949,10 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		if (req.link_id >= 0)
 			return -EINVAL;
 
-		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
-					    &bssid);
+		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs);
 		if (IS_ERR(req.bss))
 			return PTR_ERR(req.bss);
+		ap_addr = req.bss->bssid;
 	}
 
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
@@ -10967,7 +10965,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 			dev->ieee80211_ptr->conn_owner_nlportid =
 				info->snd_portid;
 			memcpy(dev->ieee80211_ptr->disconnect_bssid,
-			       bssid, ETH_ALEN);
+			       ap_addr, ETH_ALEN);
 		}
 
 		wdev_unlock(dev->ieee80211_ptr);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0f88cb6fc3c2..2f4cf976b59a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2649,11 +2649,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 			goto error;
 		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
-			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
-			goto error;
-		}
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b7c9f1dd5e42..992575f1e976 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1226,10 +1226,12 @@ static void (*conf_changed_callback)(void);
 
 void conf_set_changed(bool val)
 {
-	if (conf_changed_callback && conf_changed != val)
-		conf_changed_callback();
+	bool changed = conf_changed != val;
 
 	conf_changed = val;
+
+	if (conf_changed_callback && changed)
+		conf_changed_callback();
 }
 
 bool conf_get_changed(void)
diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index ae31bb127594..317bdf6dcbef 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -472,6 +472,15 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 81c4a45254ff..77a592f21947 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -328,14 +328,15 @@ enum {
 #define needs_eld_notify_link(chip)	false
 #endif
 
-#define CONTROLLER_IN_GPU(pci) (((pci)->device == 0x0a0c) || \
+#define CONTROLLER_IN_GPU(pci) (((pci)->vendor == 0x8086) &&         \
+				       (((pci)->device == 0x0a0c) || \
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
 					((pci)->device == 0x490d) || \
 					((pci)->device == 0x4f90) || \
 					((pci)->device == 0x4f91) || \
-					((pci)->device == 0x4f92))
+					((pci)->device == 0x4f92)))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d4819890374b..28ac6c159b2a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9446,6 +9446,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8b8a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8b, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8d, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8f, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
@@ -9538,6 +9539,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index 68b4fa352354..0102574025e9 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -547,7 +547,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[] = {
 	{
 		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
-		.sof_tplg_filename = "sof-adl-es83x6", /* the tplg suffix is added at run time */
+		.sof_tplg_filename = "sof-adl-es8336", /* the tplg suffix is added at run time */
 		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
 					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
 					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index cda33ded29be..41a29047ff01 100644
--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -183,9 +183,9 @@ int q6prm_set_lpass_clock(struct device *dev, int clk_id, int clk_attr, int clk_
 			  unsigned int freq)
 {
 	if (freq)
-		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 
-	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 }
 EXPORT_SYMBOL_GPL(q6prm_set_lpass_clock);
 
diff --git a/sound/soc/sof/intel/pci-apl.c b/sound/soc/sof/intel/pci-apl.c
index 998e219011f0..ad8431b13125 100644
--- a/sound/soc/sof/intel/pci-apl.c
+++ b/sound/soc/sof/intel/pci-apl.c
@@ -72,6 +72,7 @@ static const struct sof_dev_desc glk_desc = {
 	.nocodec_tplg_filename = "sof-glk-nocodec.tplg",
 	.ops = &sof_apl_ops,
 	.ops_init = sof_apl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-cnl.c b/sound/soc/sof/intel/pci-cnl.c
index c797356f7028..33677ce8de41 100644
--- a/sound/soc/sof/intel/pci-cnl.c
+++ b/sound/soc/sof/intel/pci-cnl.c
@@ -45,6 +45,7 @@ static const struct sof_dev_desc cnl_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc cfl_desc = {
@@ -102,6 +103,7 @@ static const struct sof_dev_desc cml_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-icl.c b/sound/soc/sof/intel/pci-icl.c
index 48f24f8ace26..9a42a4ea1a5e 100644
--- a/sound/soc/sof/intel/pci-icl.c
+++ b/sound/soc/sof/intel/pci-icl.c
@@ -73,6 +73,7 @@ static const struct sof_dev_desc jsl_desc = {
 	.nocodec_tplg_filename = "sof-jsl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-mtl.c b/sound/soc/sof/intel/pci-mtl.c
index 9f39da984e9f..4dae256536bf 100644
--- a/sound/soc/sof/intel/pci-mtl.c
+++ b/sound/soc/sof/intel/pci-mtl.c
@@ -43,6 +43,7 @@ static const struct sof_dev_desc mtl_desc = {
 	.nocodec_tplg_filename = "sof-mtl-nocodec.tplg",
 	.ops = &sof_mtl_ops,
 	.ops_init = sof_mtl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-skl.c b/sound/soc/sof/intel/pci-skl.c
index 3a99dc444f92..5b4bccf81965 100644
--- a/sound/soc/sof/intel/pci-skl.c
+++ b/sound/soc/sof/intel/pci-skl.c
@@ -38,6 +38,7 @@ static struct sof_dev_desc skl_desc = {
 	.nocodec_tplg_filename = "sof-skl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static struct sof_dev_desc kbl_desc = {
@@ -61,6 +62,7 @@ static struct sof_dev_desc kbl_desc = {
 	.nocodec_tplg_filename = "sof-kbl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index 4cfe4f242fc5..ccaf0ff9eb1c 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -45,6 +45,7 @@ static const struct sof_dev_desc tgl_desc = {
 	.nocodec_tplg_filename = "sof-tgl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc tglh_desc = {
@@ -101,6 +102,7 @@ static const struct sof_dev_desc ehl_desc = {
 	.nocodec_tplg_filename = "sof-ehl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adls_desc = {
@@ -129,6 +131,7 @@ static const struct sof_dev_desc adls_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_desc = {
@@ -157,6 +160,7 @@ static const struct sof_dev_desc adl_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_n_desc = {
@@ -185,6 +189,7 @@ static const struct sof_dev_desc adl_n_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpls_desc = {
@@ -213,6 +218,7 @@ static const struct sof_dev_desc rpls_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpl_desc = {
@@ -241,6 +247,7 @@ static const struct sof_dev_desc rpl_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index 0aa87a8add5d..2363a7cc0b57 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -46,7 +46,7 @@
 #define SOF_IPC4_NODE_INDEX_INTEL_SSP(x) (((x) & 0xf) << 4)
 
 /* Node ID for DMIC type DAI copiers */
-#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) (((x) & 0x7) << 5)
+#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) ((x) & 0x7)
 
 #define SOF_IPC4_GAIN_ALL_CHANNELS_MASK 0xffffffff
 #define SOF_IPC4_VOL_ZERO_DB	0x7fffffff
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f7900e75d230..05400462c779 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -10,12 +10,14 @@ endif
 CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
 CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
 CLANG_TARGET_FLAGS_hexagon      := hexagon-linux-musl
+CLANG_TARGET_FLAGS_i386         := i386-linux-gnu
 CLANG_TARGET_FLAGS_m68k         := m68k-linux-gnu
 CLANG_TARGET_FLAGS_mips         := mipsel-linux-gnu
 CLANG_TARGET_FLAGS_powerpc      := powerpc64le-linux-gnu
 CLANG_TARGET_FLAGS_riscv        := riscv64-linux-gnu
 CLANG_TARGET_FLAGS_s390         := s390x-linux-gnu
 CLANG_TARGET_FLAGS_x86          := x86_64-linux-gnu
+CLANG_TARGET_FLAGS_x86_64       := x86_64-linux-gnu
 CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
 
 ifeq ($(CROSS_COMPILE),)
diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 2b5d6ff87373..2d84c7a0be6b 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -59,6 +59,8 @@ class devlink_ports(object):
         assert stderr == ""
         ports = json.loads(stdout)['port']
 
+        validate_devlink_output(ports, 'flavour')
+
         for port in ports:
             if dev in port:
                 if ports[port]['flavour'] == 'physical':
@@ -220,6 +222,27 @@ def split_splittable_port(port, k, lanes, dev):
     unsplit(port.bus_info)
 
 
+def validate_devlink_output(devlink_data, target_property=None):
+    """
+    Determine if test should be skipped by checking:
+      1. devlink_data contains values
+      2. The target_property exist in devlink_data
+    """
+    skip_reason = None
+    if any(devlink_data.values()):
+        if target_property:
+            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
+            for key in devlink_data:
+                if target_property in devlink_data[key]:
+                    skip_reason = None
+    else:
+        skip_reason = 'devlink output is empty, test skipped'
+
+    if skip_reason:
+        print(skip_reason)
+        sys.exit(KSFT_SKIP)
+
+
 def make_parser():
     parser = argparse.ArgumentParser(description='A test for port splitting.')
     parser.add_argument('--dev',
@@ -240,12 +263,9 @@ def main(cmdline=None):
         stdout, stderr = run_command(cmd)
         assert stderr == ""
 
+        validate_devlink_output(json.loads(stdout))
         devs = json.loads(stdout)['dev']
-        if devs:
-            dev = list(devs.keys())[0]
-        else:
-            print("no devlink device was found, test skipped")
-            sys.exit(KSFT_SKIP)
+        dev = list(devs.keys())[0]
 
     cmd = "devlink dev show %s" % dev
     stdout, stderr = run_command(cmd)
@@ -255,6 +275,7 @@ def main(cmdline=None):
 
     ports = devlink_ports(dev)
 
+    found_max_lanes = False
     for port in ports.if_names:
         max_lanes = get_max_lanes(port.name)
 
@@ -277,6 +298,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        found_max_lanes = True
+
+    if not found_max_lanes:
+        print(f"Test not started, no port of device {dev} reports max_lanes")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
