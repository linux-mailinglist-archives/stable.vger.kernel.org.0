Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7334A61AE
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiBAQ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:57:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42604 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiBAQ47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:56:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2090460AFF;
        Tue,  1 Feb 2022 16:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AEAC340ED;
        Tue,  1 Feb 2022 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643734618;
        bh=pxF45B69d96nfjFlFj3jbIbh6xO/bG1kp6jCM2P/5AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD9YX4Qiw7U4hJyuUg7R3KLvgNkQGpbS2rfQDcjUUncWjFfSr+JkowbbSX9P/8IgY
         g9+wz46A+GBR1PhmnCZuVVzh2HC45+xgea1MzG22afiJ7wJKSOaa9pLdTUjE3la5wX
         FZvWxUZw9n9ob5E35Rc5QrIi6kKPcXNUMUTVSsx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.19
Date:   Tue,  1 Feb 2022 17:56:49 +0100
Message-Id: <164373460818719@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164373460813536@kroah.com>
References: <164373460813536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index f2b3439edcc2..860fe651d645 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -92,7 +92,8 @@ Triggers can be set on more than one psi metric and more than one trigger
 for the same psi metric can be specified. However for each trigger a separate
 file descriptor is required to be able to poll it separately from others,
 therefore for each trigger a separate open() syscall should be made even
-when opening the same psi interface file.
+when opening the same psi interface file. Write operations to a file descriptor
+with an already existing psi trigger will fail with EBUSY.
 
 Monitors activate only when system enters stall state for the monitored
 psi metric and deactivates upon exit from the stall state. While system is
diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index 0968b40aef1e..e3501bfa22e9 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -31,7 +31,7 @@ tcan4x5x: tcan4x5x@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		spi-max-frequency = <10000000>;
-		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
+		bosch,mram-cfg = <0x0 0 0 16 0 0 1 1>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <14 IRQ_TYPE_LEVEL_LOW>;
 		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
diff --git a/Makefile b/Makefile
index 385286f987d8..463d46a9e617 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 18
+SUBLEVEL = 19
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index e2b1fd558bf3..11bb9d12485f 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -259,6 +259,7 @@
  */
 #define ALT_UP(instr...)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 9997:	instr							;\
 	.if . - 9997b == 2					;\
@@ -270,6 +271,7 @@
 	.popsection
 #define ALT_UP_B(label)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 	W(b)	. + (label - 9998b)					;\
 	.popsection
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 9e6b97286307..8aeff55aebfa 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -96,6 +96,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define __ALT_SMP_ASM(smp, up)						\
 	"9998:	" smp "\n"						\
 	"	.pushsection \".alt.smp.init\", \"a\"\n"		\
+	"	.align	2\n"						\
 	"	.long	9998b - .\n"					\
 	"	" up "\n"						\
 	"	.popsection\n"
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 36fbc3329252..32dbfd81f42a 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <asm/memory.h>
 #include <asm/domain.h>
+#include <asm/unaligned.h>
 #include <asm/unified.h>
 #include <asm/compiler.h>
 
@@ -497,7 +498,10 @@ do {									\
 	}								\
 	default: __err = __get_user_bad(); break;			\
 	}								\
-	*(type *)(dst) = __val;						\
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))		\
+		put_unaligned(__val, (type *)(dst));			\
+	else								\
+		*(type *)(dst) = __val; /* aligned by caller */		\
 	if (__err)							\
 		goto err_label;						\
 } while (0)
@@ -507,7 +511,9 @@ do {									\
 	const type *__pk_ptr = (dst);					\
 	unsigned long __dst = (unsigned long)__pk_ptr;			\
 	int __err = 0;							\
-	type __val = *(type *)src;					\
+	type __val = IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)	\
+		     ? get_unaligned((type *)(src))			\
+		     : *(type *)(src);	/* aligned by caller */		\
 	switch (sizeof(type)) {						\
 	case 1: __put_user_asm_byte(__val, __dst, __err, ""); break;	\
 	case 2:	__put_user_asm_half(__val, __dst, __err, ""); break;	\
diff --git a/arch/arm/probes/kprobes/Makefile b/arch/arm/probes/kprobes/Makefile
index 14db56f49f0a..6159010dac4a 100644
--- a/arch/arm/probes/kprobes/Makefile
+++ b/arch/arm/probes/kprobes/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+KASAN_SANITIZE_actions-common.o := n
+KASAN_SANITIZE_actions-arm.o := n
+KASAN_SANITIZE_actions-thumb.o := n
 obj-$(CONFIG_KPROBES)		+= core.o actions-common.o checkers-common.o
 obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
 test-kprobes-objs		:= test-core.o
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0418399e0a20..c5d009715402 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -38,7 +38,10 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	write_sysreg_el1(val, SYS_SPSR);
+	if (has_vhe())
+		write_sysreg_el1(val, SYS_SPSR);
+	else
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..4c77ff556f0a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -921,13 +921,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 */
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
-	if (need_flush) {
-		kvm_pte_t *pte_follow = kvm_pte_follow(pte, mm_ops);
-
-		dcache_clean_inval_poc((unsigned long)pte_follow,
-				    (unsigned long)pte_follow +
-					    kvm_granule_size(level));
-	}
+	if (need_flush && mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 
 	if (childp)
 		mm_ops->put_page(childp);
@@ -1089,15 +1085,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
-	kvm_pte_t *pte_follow;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
 
-	pte_follow = kvm_pte_follow(pte, mm_ops);
-	dcache_clean_inval_poc((unsigned long)pte_follow,
-			    (unsigned long)pte_follow +
-				    kvm_granule_size(level));
+	if (mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 	return 0;
 }
 
diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index acb55a41260d..2bcdd7d3a1ad 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -76,5 +76,5 @@ static void pci_fixup_video(struct pci_dev *pdev)
 		}
 	}
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
diff --git a/arch/mips/loongson64/vbios_quirk.c b/arch/mips/loongson64/vbios_quirk.c
index 9a29e94d3db1..3115d4de982c 100644
--- a/arch/mips/loongson64/vbios_quirk.c
+++ b/arch/mips/loongson64/vbios_quirk.c
@@ -3,7 +3,7 @@
 #include <linux/pci.h>
 #include <loongson.h>
 
-static void pci_fixup_radeon(struct pci_dev *pdev)
+static void pci_fixup_video(struct pci_dev *pdev)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
 
@@ -22,8 +22,7 @@ static void pci_fixup_radeon(struct pci_dev *pdev)
 	res->flags = IORESOURCE_MEM | IORESOURCE_ROM_SHADOW |
 		     IORESOURCE_PCI_FIXED;
 
-	dev_info(&pdev->dev, "BAR %d: assigned %pR for Radeon ROM\n",
-		 PCI_ROM_RESOURCE, res);
+	dev_info(&pdev->dev, "Video device with shadowed ROM at %pR\n", res);
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, 0x9615,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_radeon);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, 0x9615,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index f5be185cbdf8..94ad7acfd056 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -143,6 +143,8 @@ static __always_inline void update_user_segments(u32 val)
 	update_user_segment(15, val);
 }
 
+int __init find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 19b6942c6969..eaf3a562bf1e 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -39,7 +39,6 @@ struct kvm_nested_guest {
 	pgd_t *shadow_pgtable;		/* our page table for this guest */
 	u64 l1_gr_to_hr;		/* L1's addr of part'n-scoped table */
 	u64 process_table;		/* process table entry for this guest */
-	u64 hfscr;			/* HFSCR that the L1 requested for this nested guest */
 	long refcnt;			/* number of pointers to this struct */
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 080a7feb7731..0d81a9bf3765 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -814,6 +814,7 @@ struct kvm_vcpu_arch {
 
 	/* For support of nested guests */
 	struct kvm_nested_guest *nested;
+	u64 nested_hfscr;	/* HFSCR that the L1 requested for the nested guest */
 	u32 nested_vcpu_id;
 	gpa_t nested_io_gpr;
 #endif
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index baea657bc868..bca31a61e57f 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -498,6 +498,7 @@
 #define PPC_RAW_LDX(r, base, b)		(0x7c00002a | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_LHZ(r, base, i)		(0xa0000000 | ___PPC_RT(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_LHBRX(r, base, b)	(0x7c00062c | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
+#define PPC_RAW_LWBRX(r, base, b)	(0x7c00042c | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_LDBRX(r, base, b)	(0x7c000428 | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_STWCX(s, a, b)		(0x7c00012d | ___PPC_RS(s) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_CMPWI(a, i)		(0x2c000000 | ___PPC_RA(a) | IMM_L(i))
diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index c60ebd04b2ed..61b968d9fba7 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -90,7 +90,7 @@ static inline void syscall_get_arguments(struct task_struct *task,
 	unsigned long val, mask = -1UL;
 	unsigned int n = 6;
 
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		mask = 0xffffffff;
 
 	while (n--) {
@@ -115,7 +115,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(struct task_struct *task)
 {
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		return AUDIT_ARCH_PPC;
 	else if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
 		return AUDIT_ARCH_PPC64LE;
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index b4ec6c7dd72e..2a4ea0e213a9 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -165,8 +165,10 @@ static inline bool test_thread_local_flags(unsigned int flags)
 
 #ifdef CONFIG_COMPAT
 #define is_32bit_task()	(test_thread_flag(TIF_32BIT))
+#define is_tsk_32bit_task(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT))
 #else
 #define is_32bit_task()	(IS_ENABLED(CONFIG_PPC32))
+#define is_tsk_32bit_task(tsk)	(IS_ENABLED(CONFIG_PPC32))
 #endif
 
 #if defined(CONFIG_PPC64)
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 86e40db2dec5..b1b23b4d56ba 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -11,6 +11,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_early_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index 4b1ff94e67eb..4c6d1a8dcefe 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -30,6 +30,7 @@ COMPAT_SYS_CALL_TABLE:
 	.ifc \srr,srr
 	mfspr	r11,SPRN_SRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r11,r11,2
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
@@ -40,6 +41,7 @@ COMPAT_SYS_CALL_TABLE:
 	.else
 	mfspr	r11,SPRN_HSRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r11,r11,2
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 94da0d25eb12..a2fd1db29f7e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1731,7 +1731,6 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 
 static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	int r;
 	int srcu_idx;
 
@@ -1831,7 +1830,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		 * it into a HEAI.
 		 */
 		if (!(vcpu->arch.hfscr_permitted & (1UL << cause)) ||
-					(nested->hfscr & (1UL << cause))) {
+				(vcpu->arch.nested_hfscr & (1UL << cause))) {
 			vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
 
 			/*
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 89295b52a97c..6c4e0e93105f 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -362,7 +362,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
-	l2->hfscr = l2_hv.hfscr;
+	vcpu->arch.nested_hfscr = l2_hv.hfscr;
 	vcpu->arch.regs = l2_regs;
 
 	/* Guest must always run with ME enabled, HV disabled. */
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 99a7c9132422..54be64203b2a 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -19,6 +19,9 @@ CFLAGS_code-patching.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_feature-fixups.o += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += alloc.o code-patching.o feature-fixups.o pmem.o test_code-patching.o
 
 ifndef CONFIG_KASAN
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 27061583a010..203735caf691 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -76,7 +76,7 @@ unsigned long p_block_mapped(phys_addr_t pa)
 	return 0;
 }
 
-static int find_free_bat(void)
+int __init find_free_bat(void)
 {
 	int b;
 	int n = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
@@ -100,7 +100,7 @@ static int find_free_bat(void)
  * - block size has to be a power of two. This is calculated by finding the
  *   highest bit set to 1.
  */
-static unsigned int block_size(unsigned long base, unsigned long top)
+unsigned int bat_block_size(unsigned long base, unsigned long top)
 {
 	unsigned int max_size = SZ_256M;
 	unsigned int base_shift = (ffs(base) - 1) & 31;
@@ -145,7 +145,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 	int idx;
 
 	while ((idx = find_free_bat()) != -1 && base != top) {
-		unsigned int size = block_size(base, top);
+		unsigned int size = bat_block_size(base, top);
 
 		if (size < 128 << 10)
 			break;
@@ -196,18 +196,17 @@ void mmu_mark_initmem_nx(void)
 	int nb = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
 	int i;
 	unsigned long base = (unsigned long)_stext - PAGE_OFFSET;
-	unsigned long top = (unsigned long)_etext - PAGE_OFFSET;
+	unsigned long top = ALIGN((unsigned long)_etext - PAGE_OFFSET, SZ_128K);
 	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
 	unsigned long size;
 
-	for (i = 0; i < nb - 1 && base < top && top - base > (128 << 10);) {
-		size = block_size(base, top);
+	for (i = 0; i < nb - 1 && base < top;) {
+		size = bat_block_size(base, top);
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
 	}
 	if (base < top) {
-		size = block_size(base, top);
-		size = max(size, 128UL << 10);
+		size = bat_block_size(base, top);
 		if ((top - base) > size) {
 			size <<= 1;
 			if (strict_kernel_rwx_enabled() && base + size > border)
diff --git a/arch/powerpc/mm/kasan/book3s_32.c b/arch/powerpc/mm/kasan/book3s_32.c
index 35b287b0a8da..450a67ef0bbe 100644
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -10,48 +10,51 @@ int __init kasan_init_region(void *start, size_t size)
 {
 	unsigned long k_start = (unsigned long)kasan_mem_to_shadow(start);
 	unsigned long k_end = (unsigned long)kasan_mem_to_shadow(start + size);
-	unsigned long k_cur = k_start;
-	int k_size = k_end - k_start;
-	int k_size_base = 1 << (ffs(k_size) - 1);
+	unsigned long k_nobat = k_start;
+	unsigned long k_cur;
+	phys_addr_t phys;
 	int ret;
-	void *block;
 
-	block = memblock_alloc(k_size, k_size_base);
-
-	if (block && k_size_base >= SZ_128K && k_start == ALIGN(k_start, k_size_base)) {
-		int shift = ffs(k_size - k_size_base);
-		int k_size_more = shift ? 1 << (shift - 1) : 0;
-
-		setbat(-1, k_start, __pa(block), k_size_base, PAGE_KERNEL);
-		if (k_size_more >= SZ_128K)
-			setbat(-1, k_start + k_size_base, __pa(block) + k_size_base,
-			       k_size_more, PAGE_KERNEL);
-		if (v_block_mapped(k_start))
-			k_cur = k_start + k_size_base;
-		if (v_block_mapped(k_start + k_size_base))
-			k_cur = k_start + k_size_base + k_size_more;
-
-		update_bats();
+	while (k_nobat < k_end) {
+		unsigned int k_size = bat_block_size(k_nobat, k_end);
+		int idx = find_free_bat();
+
+		if (idx == -1)
+			break;
+		if (k_size < SZ_128K)
+			break;
+		phys = memblock_phys_alloc_range(k_size, k_size, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			break;
+
+		setbat(idx, k_nobat, phys, k_size, PAGE_KERNEL);
+		k_nobat += k_size;
 	}
+	if (k_nobat != k_start)
+		update_bats();
 
-	if (!block)
-		block = memblock_alloc(k_size, PAGE_SIZE);
-	if (!block)
-		return -ENOMEM;
+	if (k_nobat < k_end) {
+		phys = memblock_phys_alloc_range(k_end - k_nobat, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			return -ENOMEM;
+	}
 
 	ret = kasan_init_shadow_page_tables(k_start, k_end);
 	if (ret)
 		return ret;
 
-	kasan_update_early_region(k_start, k_cur, __pte(0));
+	kasan_update_early_region(k_start, k_nobat, __pte(0));
 
-	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_nobat; k_cur < k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_off_k(k_cur);
-		void *va = block + k_cur - k_start;
-		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
+		pte_t pte = pfn_pte(PHYS_PFN(phys + k_cur - k_nobat), PAGE_KERNEL);
 
 		__set_pte_at(&init_mm, k_cur, pte_offset_kernel(pmd, k_cur), pte, 0);
 	}
 	flush_tlb_kernel_range(k_start, k_end);
+	memset(kasan_mem_to_shadow(start), 0, k_end - k_start);
+
 	return 0;
 }
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 90ce75f0f1e2..8acf8a611a26 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -23,15 +23,15 @@ static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
 	memset32(area, BREAKPOINT_INSTRUCTION, size / 4);
 }
 
-/* Fix the branch target addresses for subprog calls */
-static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
-				       struct codegen_context *ctx, u32 *addrs)
+/* Fix updated addresses (for subprog calls, ldimm64, et al) during extra pass */
+static int bpf_jit_fixup_addresses(struct bpf_prog *fp, u32 *image,
+				   struct codegen_context *ctx, u32 *addrs)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	bool func_addr_fixed;
 	u64 func_addr;
 	u32 tmp_idx;
-	int i, ret;
+	int i, j, ret;
 
 	for (i = 0; i < fp->len; i++) {
 		/*
@@ -66,6 +66,23 @@ static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
 			 * of the JITed sequence remains unchanged.
 			 */
 			ctx->idx = tmp_idx;
+		} else if (insn[i].code == (BPF_LD | BPF_IMM | BPF_DW)) {
+			tmp_idx = ctx->idx;
+			ctx->idx = addrs[i] / 4;
+#ifdef CONFIG_PPC32
+			PPC_LI32(ctx->b2p[insn[i].dst_reg] - 1, (u32)insn[i + 1].imm);
+			PPC_LI32(ctx->b2p[insn[i].dst_reg], (u32)insn[i].imm);
+			for (j = ctx->idx - addrs[i] / 4; j < 4; j++)
+				EMIT(PPC_RAW_NOP());
+#else
+			func_addr = ((u64)(u32)insn[i].imm) | (((u64)(u32)insn[i + 1].imm) << 32);
+			PPC_LI64(b2p[insn[i].dst_reg], func_addr);
+			/* overwrite rest with nops */
+			for (j = ctx->idx - addrs[i] / 4; j < 5; j++)
+				EMIT(PPC_RAW_NOP());
+#endif
+			ctx->idx = tmp_idx;
+			i++;
 		}
 	}
 
@@ -193,13 +210,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		/*
 		 * Do not touch the prologue and epilogue as they will remain
 		 * unchanged. Only fix the branch target address for subprog
-		 * calls in the body.
+		 * calls in the body, and ldimm64 instructions.
 		 *
 		 * This does not change the offsets and lengths of the subprog
 		 * call instruction sequences and hence, the size of the JITed
 		 * image as well.
 		 */
-		bpf_jit_fixup_subprog_calls(fp, code_base, &cgctx, addrs);
+		bpf_jit_fixup_addresses(fp, code_base, &cgctx, addrs);
 
 		/* There is no need to perform the usual passes. */
 		goto skip_codegen_passes;
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 0da31d41d413..bce5eda85170 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -191,6 +191,9 @@ void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 fun
 
 	if (image && rel < 0x2000000 && rel >= -0x2000000) {
 		PPC_BL_ABS(func);
+		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_NOP());
 	} else {
 		/* Load function address into r0 */
 		EMIT(PPC_RAW_LIS(_R0, IMM_H(func)));
@@ -289,6 +292,8 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		bool func_addr_fixed;
 		u64 func_addr;
 		u32 true_cond;
+		u32 tmp_idx;
+		int j;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -836,8 +841,12 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 * 16 byte instruction that uses two 'struct bpf_insn'
 		 */
 		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
+			tmp_idx = ctx->idx;
 			PPC_LI32(dst_reg_h, (u32)insn[i + 1].imm);
 			PPC_LI32(dst_reg, (u32)insn[i].imm);
+			/* padding to allow full 4 instructions for later patching */
+			for (j = ctx->idx - tmp_idx; j < 4; j++)
+				EMIT(PPC_RAW_NOP());
 			/* Adjust for two bpf instructions */
 			addrs[++i] = ctx->idx * 4;
 			break;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 8b5157ccfeba..57e1b6680365 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -318,6 +318,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		u64 imm64;
 		u32 true_cond;
 		u32 tmp_idx;
+		int j;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -632,17 +633,21 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				EMIT(PPC_RAW_MR(dst_reg, b2p[TMP_REG_1]));
 				break;
 			case 64:
-				/*
-				 * Way easier and faster(?) to store the value
-				 * into stack and then use ldbrx
-				 *
-				 * ctx->seen will be reliable in pass2, but
-				 * the instructions generated will remain the
-				 * same across all passes
-				 */
+				/* Store the value to stack and then use byte-reverse loads */
 				PPC_BPF_STL(dst_reg, 1, bpf_jit_stack_local(ctx));
 				EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], 1, bpf_jit_stack_local(ctx)));
-				EMIT(PPC_RAW_LDBRX(dst_reg, 0, b2p[TMP_REG_1]));
+				if (cpu_has_feature(CPU_FTR_ARCH_206)) {
+					EMIT(PPC_RAW_LDBRX(dst_reg, 0, b2p[TMP_REG_1]));
+				} else {
+					EMIT(PPC_RAW_LWBRX(dst_reg, 0, b2p[TMP_REG_1]));
+					if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+						EMIT(PPC_RAW_SLDI(dst_reg, dst_reg, 32));
+					EMIT(PPC_RAW_LI(b2p[TMP_REG_2], 4));
+					EMIT(PPC_RAW_LWBRX(b2p[TMP_REG_2], b2p[TMP_REG_2], b2p[TMP_REG_1]));
+					if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+						EMIT(PPC_RAW_SLDI(b2p[TMP_REG_2], b2p[TMP_REG_2], 32));
+					EMIT(PPC_RAW_OR(dst_reg, dst_reg, b2p[TMP_REG_2]));
+				}
 				break;
 			}
 			break;
@@ -806,9 +811,13 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
 			imm64 = ((u64)(u32) insn[i].imm) |
 				    (((u64)(u32) insn[i+1].imm) << 32);
+			tmp_idx = ctx->idx;
+			PPC_LI64(dst_reg, imm64);
+			/* padding to allow full 5 instructions for later patching */
+			for (j = ctx->idx - tmp_idx; j < 5; j++)
+				EMIT(PPC_RAW_NOP());
 			/* Adjust for two bpf instructions */
 			addrs[++i] = ctx->idx * 4;
-			PPC_LI64(dst_reg, imm64);
 			break;
 
 		/*
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index bef6b1abce70..e78de7050947 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1326,9 +1326,20 @@ static void power_pmu_disable(struct pmu *pmu)
 		 * Otherwise provide a warning if there is PMI pending, but
 		 * no counter is found overflown.
 		 */
-		if (any_pmc_overflown(cpuhw))
-			clear_pmi_irq_pending();
-		else
+		if (any_pmc_overflown(cpuhw)) {
+			/*
+			 * Since power_pmu_disable runs under local_irq_save, it
+			 * could happen that code hits a PMC overflow without PMI
+			 * pending in paca. Hence only clear PMI pending if it was
+			 * set.
+			 *
+			 * If a PMI is pending, then MSR[EE] must be disabled (because
+			 * the masked PMI handler disabling EE). So it is safe to
+			 * call clear_pmi_irq_pending().
+			 */
+			if (pmi_irq_pending())
+				clear_pmi_irq_pending();
+		} else
 			WARN_ON(pmi_irq_pending());
 
 		val = mmcra = cpuhw->mmcr.mmcra;
diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
index 33f973ff9744..e8f15dbb89d0 100644
--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -20,6 +20,7 @@
 
 static char local_guest[] = "        ";
 static char all_guests[] = "*       ";
+static char *all_groups = all_guests;
 static char *guest_query;
 
 struct diag2fc_data {
@@ -62,10 +63,11 @@ static int diag2fc(int size, char* query, void *addr)
 
 	memcpy(parm_list.userid, query, NAME_LEN);
 	ASCEBC(parm_list.userid, NAME_LEN);
-	parm_list.addr = (unsigned long) addr ;
+	memcpy(parm_list.aci_grp, all_groups, NAME_LEN);
+	ASCEBC(parm_list.aci_grp, NAME_LEN);
+	parm_list.addr = (unsigned long)addr;
 	parm_list.size = size;
 	parm_list.fmt = 0x02;
-	memset(parm_list.aci_grp, 0x40, NAME_LEN);
 	rc = -1;
 
 	diag_stat_inc(DIAG_STAT_X2FC);
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index b01ba460b7ca..a805ea5cb92d 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -33,7 +33,7 @@
 #define DEBUGP(fmt , ...)
 #endif
 
-#define PLT_ENTRY_SIZE 20
+#define PLT_ENTRY_SIZE 22
 
 void *module_alloc(unsigned long size)
 {
@@ -340,27 +340,26 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
 		if (info->plt_initialized == 0) {
-			unsigned int insn[5];
-			unsigned int *ip = me->core_layout.base +
-					   me->arch.plt_offset +
-					   info->plt_offset;
-
-			insn[0] = 0x0d10e310;	/* basr 1,0  */
-			insn[1] = 0x100a0004;	/* lg	1,10(1) */
+			unsigned char insn[PLT_ENTRY_SIZE];
+			char *plt_base;
+			char *ip;
+
+			plt_base = me->core_layout.base + me->arch.plt_offset;
+			ip = plt_base + info->plt_offset;
+			*(int *)insn = 0x0d10e310;	/* basr 1,0  */
+			*(int *)&insn[4] = 0x100c0004;	/* lg	1,12(1) */
 			if (IS_ENABLED(CONFIG_EXPOLINE) && !nospec_disable) {
-				unsigned int *ij;
-				ij = me->core_layout.base +
-					me->arch.plt_offset +
-					me->arch.plt_size - PLT_ENTRY_SIZE;
-				insn[2] = 0xa7f40000 +	/* j __jump_r1 */
-					(unsigned int)(u16)
-					(((unsigned long) ij - 8 -
-					  (unsigned long) ip) / 2);
+				char *jump_r1;
+
+				jump_r1 = plt_base + me->arch.plt_size -
+					PLT_ENTRY_SIZE;
+				/* brcl	0xf,__jump_r1 */
+				*(short *)&insn[8] = 0xc0f4;
+				*(int *)&insn[10] = (jump_r1 - (ip + 8)) / 2;
 			} else {
-				insn[2] = 0x07f10000;	/* br %r1 */
+				*(int *)&insn[8] = 0x07f10000;	/* br %r1 */
 			}
-			insn[3] = (unsigned int) (val >> 32);
-			insn[4] = (unsigned int) val;
+			*(long *)&insn[14] = val;
 
 			write(ip, insn, sizeof(insn));
 			info->plt_initialized = 1;
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 20f8e1868853..a50f2ff1b00e 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -273,7 +273,14 @@ static int notrace s390_validate_registers(union mci mci, int umode)
 		/* Validate vector registers */
 		union ctlreg0 cr0;
 
-		if (!mci.vr) {
+		/*
+		 * The vector validity must only be checked if not running a
+		 * KVM guest. For KVM guests the machine check is forwarded by
+		 * KVM and it is the responsibility of the guest to take
+		 * appropriate actions. The host vector or FPU values have been
+		 * saved by KVM and will be restored by KVM.
+		 */
+		if (!mci.vr && !test_cpu_flag(CIF_MCCK_GUEST)) {
 			/*
 			 * Vector registers can't be restored. If the kernel
 			 * currently uses vector registers the system is
@@ -316,11 +323,21 @@ static int notrace s390_validate_registers(union mci mci, int umode)
 	if (cr2.gse) {
 		if (!mci.gs) {
 			/*
-			 * Guarded storage register can't be restored and
-			 * the current processes uses guarded storage.
-			 * It has to be terminated.
+			 * 2 cases:
+			 * - machine check in kernel or userspace
+			 * - machine check while running SIE (KVM guest)
+			 * For kernel or userspace the userspace values of
+			 * guarded storage control can not be recreated, the
+			 * process must be terminated.
+			 * For SIE the guest values of guarded storage can not
+			 * be recreated. This is either due to a bug or due to
+			 * GS being disabled in the guest. The guest will be
+			 * notified by KVM code and the guests machine check
+			 * handling must take care of this.  The host values
+			 * are saved by KVM and are not affected.
 			 */
-			kill_task = 1;
+			if (!test_cpu_flag(CIF_MCCK_GUEST))
+				kill_task = 1;
 		} else {
 			load_gs_cb((struct gs_cb *)mcesa->guarded_storage_save_area);
 		}
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 03e6555aa8f1..dcf455525cfc 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6187,6 +6187,19 @@ __init int intel_pmu_init(void)
 			pmu->num_counters = x86_pmu.num_counters;
 			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
 		}
+
+		/*
+		 * Quirk: For some Alder Lake machine, when all E-cores are disabled in
+		 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
+		 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
+		 * mistakenly add extra counters for P-cores. Correct the number of
+		 * counters here.
+		 */
+		if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
+			pmu->num_counters = x86_pmu.num_counters;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
+		}
+
 		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 3660f698fb2a..ed869443efb2 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5482,7 +5482,7 @@ static struct intel_uncore_type icx_uncore_imc = {
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
 	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
-	.event_descs	= hswep_uncore_imc_events,
+	.event_descs	= snr_uncore_imc_events,
 	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
 	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
 	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77ab14bcd477..01759199d723 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1487,6 +1487,7 @@ struct kvm_x86_ops {
 };
 
 struct kvm_x86_nested_ops {
+	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 08831acc1d03..c0c57bd05f02 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -400,7 +400,7 @@ static void threshold_restart_bank(void *_tr)
 	u32 hi, lo;
 
 	/* sysfs write might race against an offline operation */
-	if (this_cpu_read(threshold_banks))
+	if (!this_cpu_read(threshold_banks) && !tr->set_lvt_off)
 		return;
 
 	rdmsr(tr->b->address, lo, hi);
diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index bb9a46a804bf..baafbb37be67 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d8f9aa2605e6..91c2dc9f198d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2623,7 +2623,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	cancel_apic_timer(apic);
 	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 510b833cbd39..de80ae42d044 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -942,9 +942,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 /*
  * Forcibly leave nested mode in order to be able to reset the VCPU later on.
  */
-void svm_leave_nested(struct vcpu_svm *svm)
+void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
@@ -1313,7 +1313,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 		return 0;
 	}
@@ -1378,7 +1378,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 
 	if (is_guest_mode(vcpu))
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 	else
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
@@ -1432,6 +1432,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_x86_nested_ops svm_nested_ops = {
+	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e64f16237b60..980abc437cda 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -281,7 +281,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
-			svm_leave_nested(svm);
+			svm_leave_nested(vcpu);
 			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
@@ -303,7 +303,11 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 				return ret;
 			}
 
-			if (svm_gp_erratum_intercept)
+			/*
+			 * Never intercept #GP for SEV guests, KVM can't
+			 * decrypt guest memory to workaround the erratum.
+			 */
+			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
 	}
@@ -1176,9 +1180,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
 	 * We intercept those #GP and allow access to them anyway
-	 * as VMware does.
+	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
+	 * decrypt guest memory to decode the faulting instruction.
 	 */
-	if (enable_vmware_backdoor)
+	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
@@ -2233,10 +2238,6 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 	if (error_code)
 		goto reinject;
 
-	/* All SVM instructions expect page aligned RAX */
-	if (svm->vmcb->save.rax & ~PAGE_MASK)
-		goto reinject;
-
 	/* Decode the instruction for usage later */
 	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
 		goto reinject;
@@ -2254,8 +2255,13 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
-	} else
+	} else {
+		/* All SVM instructions expect page aligned RAX */
+		if (svm->vmcb->save.rax & ~PAGE_MASK)
+			goto reinject;
+
 		return emulate_svm_instr(vcpu, opcode);
+	}
 
 reinject:
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
@@ -4407,8 +4413,13 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/* Emulation is always possible when KVM has access to all guest state. */
+	if (!sev_guest(vcpu->kvm))
+		return true;
+
 	/*
-	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
+	 * to guest register state.
 	 */
 	if (sev_es_guest(vcpu->kvm))
 		return false;
@@ -4456,21 +4467,11 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	if (likely(!insn || insn_len))
 		return true;
 
-	/*
-	 * If RIP is invalid, go ahead with emulation which will cause an
-	 * internal error exit.
-	 */
-	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
-		return true;
-
 	cr4 = kvm_read_cr4(vcpu);
 	smep = cr4 & X86_CR4_SMEP;
 	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
-		if (!sev_guest(vcpu->kvm))
-			return true;
-
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d30db599e10..ff0855c03c91 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -461,7 +461,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
-void svm_leave_nested(struct vcpu_svm *svm);
+void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e97a11abc1d8..a0193b11c381 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6748,6 +6748,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 }
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
+	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b80edffe02c..33cb06518124 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3453,6 +3453,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
+		kvm_update_cpuid_runtime(vcpu);
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
@@ -4727,8 +4728,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
-		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm)
+		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
+			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
+		}
 
 		vcpu->arch.smi_pending = events->smi.pending;
 
@@ -10987,7 +10990,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
+		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
 	}
 
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
@@ -11006,8 +11010,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		eax = 0x600;
 	kvm_rdx_write(vcpu, eax);
 
-	vcpu->arch.ia32_xss = 0;
-
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 2edd86649468..615a76d70019 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -353,8 +353,8 @@ static void pci_fixup_video(struct pci_dev *pdev)
 		}
 	}
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
 
 
 static const struct dmi_system_id msi_k8t_dmi_table[] = {
diff --git a/block/bio.c b/block/bio.c
index a6fb6a0b4295..25f1ed261100 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -567,7 +567,8 @@ void bio_truncate(struct bio *bio, unsigned new_size)
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			zero_user(bv.bv_page, bv.bv_offset + offset,
+				  bv.bv_len - offset);
 			truncated = true;
 		}
 		done += bv.bv_len;
diff --git a/block/blk-core.c b/block/blk-core.c
index c2d912d0c976..d42a0f3ff736 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1293,20 +1293,32 @@ void blk_account_io_start(struct request *rq)
 }
 
 static unsigned long __part_start_io_acct(struct block_device *part,
-					  unsigned int sectors, unsigned int op)
+					  unsigned int sectors, unsigned int op,
+					  unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
-	unsigned long now = READ_ONCE(jiffies);
 
 	part_stat_lock();
-	update_io_ticks(part, now, false);
+	update_io_ticks(part, start_time, false);
 	part_stat_inc(part, ios[sgrp]);
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_stat_local_inc(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
-	return now;
+	return start_time;
+}
+
+/**
+ * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ * @start_time:	start time that should be passed back to bio_end_io_acct().
+ */
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
+{
+	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			     bio_op(bio), start_time);
 }
+EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
 
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
@@ -1316,14 +1328,15 @@ static unsigned long __part_start_io_acct(struct block_device *part,
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
+	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+				    bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
 {
-	return __part_start_io_acct(disk->part0, sectors, op);
+	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
 }
 EXPORT_SYMBOL(disk_start_io_acct);
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 847f33ffc4ae..9fa86288b78a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -719,6 +719,13 @@ void __init efi_systab_report_header(const efi_table_hdr_t *systab_hdr,
 		systab_hdr->revision >> 16,
 		systab_hdr->revision & 0xffff,
 		vendor);
+
+	if (IS_ENABLED(CONFIG_X86_64) &&
+	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
+	    !strcmp(vendor, "Apple")) {
+		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n");
+		efi.runtime_version = EFI_1_10_SYSTEM_TABLE_REVISION;
+	}
 }
 
 static __initdata char memory_type_name[][13] = {
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2363fee9211c..9cc556013d08 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -119,9 +119,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if (image->image_base != _text)
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
 
-	if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
-		efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n",
-			EFI_KIMG_ALIGN >> 10);
+	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
+		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
+			SEGMENT_ALIGN >> 10);
 
 	kernel_size = _edata - _text;
 	kernel_memsize = kernel_size + (_end - _edata);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 89a237b5864c..0294d0cc4759 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1879,7 +1879,6 @@ static noinline bool dcn30_internal_validate_bw(
 	dc->res_pool->funcs->update_soc_for_wm_a(dc, context);
 	pipe_cnt = dc->res_pool->funcs->populate_dml_pipes(dc, context, pipes, fast_validate);
 
-	DC_FP_START();
 	if (!pipe_cnt) {
 		out = true;
 		goto validate_out;
@@ -2103,7 +2102,6 @@ static noinline bool dcn30_internal_validate_bw(
 	out = false;
 
 validate_out:
-	DC_FP_END();
 	return out;
 }
 
@@ -2304,7 +2302,9 @@ bool dcn30_validate_bandwidth(struct dc *dc,
 
 	BW_VAL_TRACE_COUNT();
 
+	DC_FP_START();
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
+	DC_FP_END();
 
 	if (pipe_cnt == 0)
 		goto validate_out;
diff --git a/drivers/gpu/drm/ast/ast_tables.h b/drivers/gpu/drm/ast/ast_tables.h
index d9eb353a4bf0..dbe1cc620f6e 100644
--- a/drivers/gpu/drm/ast/ast_tables.h
+++ b/drivers/gpu/drm/ast/ast_tables.h
@@ -282,8 +282,6 @@ static const struct ast_vbios_enhtable res_1360x768[] = {
 };
 
 static const struct ast_vbios_enhtable res_1600x900[] = {
-	{1800, 1600, 24, 80, 1000,  900, 1, 3, VCLK108,		/* 60Hz */
-	 (SyncPP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo), 60, 3, 0x3A },
 	{1760, 1600, 48, 32, 926, 900, 3, 5, VCLK97_75,		/* 60Hz CVT RB */
 	 (SyncNP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
 	  AST2500PreCatchCRT), 60, 1, 0x3A },
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index ff1416cd609a..a1e4c7905ebb 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1310,8 +1310,10 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 
 	DRM_DEBUG_ATOMIC("checking %p\n", state);
 
-	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i)
-		requested_crtc |= drm_crtc_mask(crtc);
+	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i) {
+		if (new_crtc_state->enable)
+			requested_crtc |= drm_crtc_mask(crtc);
+	}
 
 	for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
 		ret = drm_atomic_plane_check(old_plane_state, new_plane_state);
@@ -1360,8 +1362,10 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 		}
 	}
 
-	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i)
-		affected_crtc |= drm_crtc_mask(crtc);
+	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i) {
+		if (new_crtc_state->enable)
+			affected_crtc |= drm_crtc_mask(crtc);
+	}
 
 	/*
 	 * For commits that allow modesets drivers can add other CRTCs to the
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
index 225fa5879ebd..90488ab8c6d8 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -469,8 +469,8 @@ int etnaviv_ioctl_gem_submit(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 
-	if (args->stream_size > SZ_64K || args->nr_relocs > SZ_64K ||
-	    args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
+	if (args->stream_size > SZ_128K || args->nr_relocs > SZ_128K ||
+	    args->nr_bos > SZ_128K || args->nr_pmrs > 128) {
 		DRM_ERROR("submit arguments out of size limits\n");
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 723074aae5b6..b681c45520bb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1557,6 +1557,8 @@ static int a6xx_pm_suspend(struct msm_gpu *gpu)
 		for (i = 0; i < gpu->nr_rings; i++)
 			a6xx_gpu->shadow[i] = 0;
 
+	gpu->suspend_count++;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
index a98e964c3b6f..355894a3b48c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
@@ -26,9 +26,16 @@ static void dpu_setup_dspp_pcc(struct dpu_hw_dspp *ctx,
 		struct dpu_hw_pcc_cfg *cfg)
 {
 
-	u32 base = ctx->cap->sblk->pcc.base;
+	u32 base;
 
-	if (!ctx || !base) {
+	if (!ctx) {
+		DRM_ERROR("invalid ctx %pK\n", ctx);
+		return;
+	}
+
+	base = ctx->cap->sblk->pcc.base;
+
+	if (!base) {
 		DRM_ERROR("invalid ctx %pK pcc base 0x%x\n", ctx, base);
 		return;
 	}
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index fc280cc43494..122fadcf7cc1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -40,7 +40,12 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 
 	of_node_put(phy_node);
 
-	if (!phy_pdev || !msm_dsi->phy) {
+	if (!phy_pdev) {
+		DRM_DEV_ERROR(&pdev->dev, "%s: phy driver is not ready\n", __func__);
+		return -EPROBE_DEFER;
+	}
+	if (!msm_dsi->phy) {
+		put_device(&phy_pdev->dev);
 		DRM_DEV_ERROR(&pdev->dev, "%s: phy driver is not ready\n", __func__);
 		return -EPROBE_DEFER;
 	}
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 8c65ef6968ca..a878b8b079c6 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -806,12 +806,14 @@ int msm_dsi_phy_enable(struct msm_dsi_phy *phy,
 			struct msm_dsi_phy_clk_request *clk_req,
 			struct msm_dsi_phy_shared_timings *shared_timings)
 {
-	struct device *dev = &phy->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!phy || !phy->cfg->ops.enable)
 		return -EINVAL;
 
+	dev = &phy->pdev->dev;
+
 	ret = dsi_phy_enable_resource(phy);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "%s: resource enable failed, %d\n",
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 737453b6e596..94f948ef279d 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -97,10 +97,15 @@ static int msm_hdmi_get_phy(struct hdmi *hdmi)
 
 	of_node_put(phy_node);
 
-	if (!phy_pdev || !hdmi->phy) {
+	if (!phy_pdev) {
 		DRM_DEV_ERROR(&pdev->dev, "phy driver is not ready\n");
 		return -EPROBE_DEFER;
 	}
+	if (!hdmi->phy) {
+		DRM_DEV_ERROR(&pdev->dev, "phy driver is not ready\n");
+		put_device(&phy_pdev->dev);
+		return -EPROBE_DEFER;
+	}
 
 	hdmi->phy_dev = get_device(&phy_pdev->dev);
 
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 27f737a253c7..bbf999c66517 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -437,7 +437,7 @@ static int msm_init_vram(struct drm_device *dev)
 		of_node_put(node);
 		if (ret)
 			return ret;
-		size = r.end - r.start;
+		size = r.end - r.start + 1;
 		DRM_INFO("using VRAM carveout: %lx@%pa\n", size, &r.start);
 
 		/* if we have no IOMMU, then we need to use carveout allocator.
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index ca873a3b98db..f2d05bff4245 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1660,6 +1660,13 @@ static int balloon_connect_vsp(struct hv_device *dev)
 	unsigned long t;
 	int ret;
 
+	/*
+	 * max_pkt_size should be large enough for one vmbus packet header plus
+	 * our receive buffer size. Hyper-V sends messages up to
+	 * HV_HYP_PAGE_SIZE bytes long on balloon channel.
+	 */
+	dev->channel->max_pkt_size = HV_HYP_PAGE_SIZE * 2;
+
 	ret = vmbus_open(dev->channel, dm_ring_size, dm_ring_size, NULL, 0,
 			 balloon_onchannelcallback, dev);
 	if (ret)
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index d519aca4a9d6..fb6d14d213a1 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -662,6 +662,9 @@ static int adt7470_fan_write(struct device *dev, u32 attr, int channel, long val
 	struct adt7470_data *data = dev_get_drvdata(dev);
 	int err;
 
+	if (val <= 0)
+		return -EINVAL;
+
 	val = FAN_RPM_TO_PERIOD(val);
 	val = clamp_val(val, 1, 65534);
 
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 74019dff2550..1c9493c70813 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -373,7 +373,7 @@ static const struct lm90_params lm90_params[] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
 		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
-		.max_convrate = 8,
+		.max_convrate = 7,
 	},
 	[lm86] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
@@ -394,12 +394,13 @@ static const struct lm90_params lm90_params[] = {
 		.max_convrate = 9,
 	},
 	[max6646] = {
-		.flags = LM90_HAVE_CRIT,
+		.flags = LM90_HAVE_CRIT | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6654] = {
+		.flags = LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
@@ -418,7 +419,7 @@ static const struct lm90_params lm90_params[] = {
 	},
 	[max6680] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_CRIT
-		  | LM90_HAVE_CRIT_ALRM_SWP,
+		  | LM90_HAVE_CRIT_ALRM_SWP | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 	},
@@ -848,7 +849,7 @@ static int lm90_update_device(struct device *dev)
 		 * Re-enable ALERT# output if it was originally enabled and
 		 * relevant alarms are all clear
 		 */
-		if (!(data->config_orig & 0x80) &&
+		if ((client->irq || !(data->config_orig & 0x80)) &&
 		    !(data->alarms & data->alert_alarms)) {
 			if (data->config & 0x80) {
 				dev_dbg(&client->dev, "Re-enabling ALERT#\n");
@@ -1807,22 +1808,22 @@ static bool lm90_is_tripped(struct i2c_client *client, u16 *status)
 
 	if (st & LM90_STATUS_LLOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 0);
+				   hwmon_temp_min_alarm, 0);
 	if (st & LM90_STATUS_RLOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 1);
+				   hwmon_temp_min_alarm, 1);
 	if (st2 & MAX6696_STATUS2_R2LOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 2);
+				   hwmon_temp_min_alarm, 2);
 	if (st & LM90_STATUS_LHIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 0);
+				   hwmon_temp_max_alarm, 0);
 	if (st & LM90_STATUS_RHIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 1);
+				   hwmon_temp_max_alarm, 1);
 	if (st2 & MAX6696_STATUS2_R2HIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 2);
+				   hwmon_temp_max_alarm, 2);
 
 	return true;
 }
diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index fd9f275592d2..568614edd88f 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -62,7 +62,7 @@ static struct irq_chip realtek_ictl_irq = {
 
 static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(hw, &realtek_ictl_irq, handle_level_irq);
+	irq_set_chip_and_handler(irq, &realtek_ictl_irq, handle_level_irq);
 
 	return 0;
 }
@@ -95,7 +95,8 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
  * SoC interrupts are cascaded to MIPS CPU interrupts according to the
  * interrupt-map in the device tree. Each SoC interrupt gets 4 bits for
  * the CPU interrupt in an Interrupt Routing Register. Max 32 SoC interrupts
- * thus go into 4 IRRs.
+ * thus go into 4 IRRs. A routing value of '0' means the interrupt is left
+ * disconnected. Routing values {1..15} connect to output lines {0..14}.
  */
 static int __init map_interrupts(struct device_node *node, struct irq_domain *domain)
 {
@@ -134,7 +135,7 @@ static int __init map_interrupts(struct device_node *node, struct irq_domain *do
 		of_node_put(cpu_ictl);
 
 		cpu_int = be32_to_cpup(imap + 2);
-		if (cpu_int > 7)
+		if (cpu_int > 7 || cpu_int < 2)
 			return -EINVAL;
 
 		if (!(mips_irqs_set & BIT(cpu_int))) {
@@ -143,7 +144,8 @@ static int __init map_interrupts(struct device_node *node, struct irq_domain *do
 			mips_irqs_set |= BIT(cpu_int);
 		}
 
-		regs[(soc_int * 4) / 32] |= cpu_int << (soc_int * 4) % 32;
+		/* Use routing values (1..6) for CPU interrupts (2..7) */
+		regs[(soc_int * 4) / 32] |= (cpu_int - 1) << (soc_int * 4) % 32;
 		imap += 3;
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 671bb454f164..b75ff6b2b952 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -489,7 +489,7 @@ static void start_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
-	io->start_time = bio_start_io_acct(bio);
+	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -535,7 +535,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
 
-	start_io_acct(io);
+	io->start_time = jiffies;
 
 	return io;
 }
@@ -1514,9 +1514,6 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->sector = bio->bi_iter.bi_sector;
 }
 
-#define __dm_part_stat_sub(part, field, subnd)	\
-	(part_stat_get(part, field) -= (subnd))
-
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
@@ -1553,23 +1550,12 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 						  GFP_NOIO, &md->queue->bio_split);
 			ci.io->orig_bio = b;
 
-			/*
-			 * Adjust IO stats for each split, otherwise upon queue
-			 * reentry there will be redundant IO accounting.
-			 * NOTE: this is a stop-gap fix, a proper fix involves
-			 * significant refactoring of DM core's bio splitting
-			 * (by eliminating DM's splitting and just using bio_split)
-			 */
-			part_stat_lock();
-			__dm_part_stat_sub(dm_disk(md)->part0,
-					   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
-			part_stat_unlock();
-
 			bio_chain(b, bio);
 			trace_block_split(b, bio->bi_iter.bi_sector);
 			ret = submit_bio_noacct(bio);
 		}
 	}
+	start_io_acct(ci.io);
 
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
diff --git a/drivers/mtd/nand/raw/mpc5121_nfc.c b/drivers/mtd/nand/raw/mpc5121_nfc.c
index cb293c50acb8..5b9271b9c326 100644
--- a/drivers/mtd/nand/raw/mpc5121_nfc.c
+++ b/drivers/mtd/nand/raw/mpc5121_nfc.c
@@ -291,7 +291,6 @@ static int ads5121_chipselect_init(struct mtd_info *mtd)
 /* Control chips select signal on ADS5121 board */
 static void ads5121_select_chip(struct nand_chip *nand, int chip)
 {
-	struct mtd_info *mtd = nand_to_mtd(nand);
 	struct mpc5121_nfc_prv *prv = nand_get_controller_data(nand);
 	u8 v;
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c2a8421e7845..25713d623215 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -336,6 +336,9 @@ m_can_fifo_read(struct m_can_classdev *cdev,
 	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->read_fifo(cdev, addr_offset, val, val_count);
 }
 
@@ -346,6 +349,9 @@ m_can_fifo_write(struct m_can_classdev *cdev,
 	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->write_fifo(cdev, addr_offset, val, val_count);
 }
 
diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index ca80dbaf7a3f..26e212b8ca7a 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -12,7 +12,7 @@
 #define TCAN4X5X_SPI_INSTRUCTION_WRITE (0x61 << 24)
 #define TCAN4X5X_SPI_INSTRUCTION_READ (0x41 << 24)
 
-#define TCAN4X5X_MAX_REGISTER 0x8ffc
+#define TCAN4X5X_MAX_REGISTER 0x87fc
 
 static int tcan4x5x_regmap_gather_write(void *context,
 					const void *reg, size_t reg_len,
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index c1d4042671f9..b1273dce4795 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -815,7 +815,7 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction);
+		   enum dma_data_direction, gfp_t gfp_flags);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 959352fceead..68552848d388 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -746,9 +746,9 @@ static void gve_free_rings(struct gve_priv *priv)
 
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction dir)
+		   enum dma_data_direction dir, gfp_t gfp_flags)
 {
-	*page = alloc_page(GFP_KERNEL);
+	*page = alloc_page(gfp_flags);
 	if (!*page) {
 		priv->page_alloc_fail++;
 		return -ENOMEM;
@@ -792,7 +792,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	for (i = 0; i < pages; i++) {
 		err = gve_alloc_page(priv, &priv->pdev->dev, &qpl->pages[i],
 				     &qpl->page_buses[i],
-				     gve_qpl_dma_dir(priv, id));
+				     gve_qpl_dma_dir(priv, id), GFP_KERNEL);
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 16169f291ad9..629d8ed08fc6 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -79,7 +79,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
+			     GFP_ATOMIC);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8500621b2cd4..7b18b4fd9e54 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fee7d9e79f8c..417a08d600b8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2496,8 +2496,7 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
-		hclgevf_enable_vector(&hdev->misc_vector, true);
+	hclgevf_enable_vector(&hdev->misc_vector, true);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 352ffe982d84..5c7371dc8384 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2424,6 +2424,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
 	u32 reset_state;
+	int num_fails = 0;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
@@ -2477,11 +2478,23 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
-			if (rc) {
-				/* give backing device time to settle down */
+			if (rc)
+				num_fails++;
+			else
+				num_fails = 0;
+
+			/* If auto-priority-failover is enabled we can get
+			 * back to back failovers during resets, resulting
+			 * in at least two failed resets (from high-priority
+			 * backing device to low-priority one and then back)
+			 * If resets continue to fail beyond that, give the
+			 * adapter some time to settle down before retrying.
+			 */
+			if (num_fails >= 3) {
 				netdev_dbg(adapter->netdev,
-					   "[S:%s] Hard reset failed, waiting 60 secs\n",
-					   adapter_state_to_string(adapter->state));
+					   "[S:%s] Hard reset failed %d times, waiting 60 secs\n",
+					   adapter_state_to_string(adapter->state),
+					   num_fails);
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
@@ -3662,11 +3675,25 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 	struct device *dev = &adapter->vdev->dev;
 	union ibmvnic_crq crq;
 	int max_entries;
+	int cap_reqs;
+
+	/* We send out 6 or 7 REQUEST_CAPABILITY CRQs below (depending on
+	 * the PROMISC flag). Initialize this count upfront. When the tasklet
+	 * receives a response to all of these, it will send the next protocol
+	 * message (QUERY_IP_OFFLOAD).
+	 */
+	if (!(adapter->netdev->flags & IFF_PROMISC) ||
+	    adapter->promisc_supported)
+		cap_reqs = 7;
+	else
+		cap_reqs = 6;
 
 	if (!retry) {
 		/* Sub-CRQ entries are 32 byte long */
 		int entries_page = 4 * PAGE_SIZE / (sizeof(u64) * 4);
 
+		atomic_set(&adapter->running_cap_crqs, cap_reqs);
+
 		if (adapter->min_tx_entries_per_subcrq > entries_page ||
 		    adapter->min_rx_add_entries_per_subcrq > entries_page) {
 			dev_err(dev, "Fatal, invalid entries per sub-crq\n");
@@ -3727,44 +3754,45 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 					adapter->opt_rx_comp_queues;
 
 		adapter->req_rx_add_queues = adapter->max_rx_add_queues;
+	} else {
+		atomic_add(cap_reqs, &adapter->running_cap_crqs);
 	}
-
 	memset(&crq, 0, sizeof(crq));
 	crq.request_capability.first = IBMVNIC_CRQ_CMD;
 	crq.request_capability.cmd = REQUEST_CAPABILITY;
 
 	crq.request_capability.capability = cpu_to_be16(REQ_TX_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_tx_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_RX_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_rx_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_RX_ADD_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_rx_add_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability =
 	    cpu_to_be16(REQ_TX_ENTRIES_PER_SUBCRQ);
 	crq.request_capability.number =
 	    cpu_to_be64(adapter->req_tx_entries_per_subcrq);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability =
 	    cpu_to_be16(REQ_RX_ADD_ENTRIES_PER_SUBCRQ);
 	crq.request_capability.number =
 	    cpu_to_be64(adapter->req_rx_add_entries_per_subcrq);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_MTU);
 	crq.request_capability.number = cpu_to_be64(adapter->req_mtu);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	if (adapter->netdev->flags & IFF_PROMISC) {
@@ -3772,16 +3800,21 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 			crq.request_capability.capability =
 			    cpu_to_be16(PROMISC_REQUESTED);
 			crq.request_capability.number = cpu_to_be64(1);
-			atomic_inc(&adapter->running_cap_crqs);
+			cap_reqs--;
 			ibmvnic_send_crq(adapter, &crq);
 		}
 	} else {
 		crq.request_capability.capability =
 		    cpu_to_be16(PROMISC_REQUESTED);
 		crq.request_capability.number = cpu_to_be64(0);
-		atomic_inc(&adapter->running_cap_crqs);
+		cap_reqs--;
 		ibmvnic_send_crq(adapter, &crq);
 	}
+
+	/* Keep at end to catch any discrepancy between expected and actual
+	 * CRQs sent.
+	 */
+	WARN_ON(cap_reqs != 0);
 }
 
 static int pending_scrq(struct ibmvnic_adapter *adapter,
@@ -4175,118 +4208,132 @@ static void send_query_map(struct ibmvnic_adapter *adapter)
 static void send_query_cap(struct ibmvnic_adapter *adapter)
 {
 	union ibmvnic_crq crq;
+	int cap_reqs;
+
+	/* We send out 25 QUERY_CAPABILITY CRQs below.  Initialize this count
+	 * upfront. When the tasklet receives a response to all of these, it
+	 * can send out the next protocol messaage (REQUEST_CAPABILITY).
+	 */
+	cap_reqs = 25;
+
+	atomic_set(&adapter->running_cap_crqs, cap_reqs);
 
-	atomic_set(&adapter->running_cap_crqs, 0);
 	memset(&crq, 0, sizeof(crq));
 	crq.query_capability.first = IBMVNIC_CRQ_CMD;
 	crq.query_capability.cmd = QUERY_CAPABILITY;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_TX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_RX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_RX_ADD_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_TX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_RX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_RX_ADD_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MIN_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MIN_RX_ADD_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MAX_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MAX_RX_ADD_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(TCP_IP_OFFLOAD);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(PROMISC_SUPPORTED);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_MTU);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_MTU);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_MULTICAST_FILTERS);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(VLAN_HEADER_INSERTION);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(RX_VLAN_HEADER_INSERTION);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_TX_SG_ENTRIES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(RX_SG_SUPPORTED);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(OPT_TX_COMP_SUB_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(OPT_RX_COMP_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_RX_BUFADD_Q_PER_RX_COMP_Q);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_RXBA_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(TX_RX_DESC_REQ);
-	atomic_inc(&adapter->running_cap_crqs);
+
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
+
+	/* Keep at end to catch any discrepancy between expected and actual
+	 * CRQs sent.
+	 */
+	WARN_ON(cap_reqs != 0);
 }
 
 static void send_query_ip_offload(struct ibmvnic_adapter *adapter)
@@ -4591,6 +4638,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	char *name;
 
 	atomic_dec(&adapter->running_cap_crqs);
+	netdev_dbg(adapter->netdev, "Outstanding request-caps: %d\n",
+		   atomic_read(&adapter->running_cap_crqs));
 	switch (be16_to_cpu(crq->request_capability_rsp.capability)) {
 	case REQ_TX_QUEUES:
 		req_value = &adapter->req_tx_queues;
@@ -5268,12 +5317,6 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
 		}
-
-		/* remain in tasklet until all
-		 * capabilities responses are received
-		 */
-		if (!adapter->wait_capability)
-			done = true;
 	}
 	/* if capabilities CRQ's were sent in this tasklet, the following
 	 * tasklet must wait until all responses are received
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index b10bc59c5700..389df4d86ab4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -174,7 +174,6 @@ enum i40e_interrupt_policy {
 
 struct i40e_lump_tracking {
 	u16 num_entries;
-	u16 search_hint;
 	u16 list[0];
 #define I40E_PILE_VALID_BIT  0x8000
 #define I40E_IWARP_IRQ_PILE_ID  (I40E_PILE_VALID_BIT - 2)
@@ -848,12 +847,12 @@ struct i40e_vsi {
 	struct rtnl_link_stats64 net_stats_offsets;
 	struct i40e_eth_stats eth_stats;
 	struct i40e_eth_stats eth_stats_offsets;
-	u32 tx_restart;
-	u32 tx_busy;
+	u64 tx_restart;
+	u64 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
-	u32 rx_buf_failed;
-	u32 rx_page_failed;
+	u64 rx_buf_failed;
+	u64 rx_page_failed;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 2c1b1da1220e..1e57cc8c47d7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -240,7 +240,7 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
 		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
 	dev_info(&pf->pdev->dev,
-		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
+		 "    tx_restart = %llu, tx_busy = %llu, rx_buf_failed = %llu, rx_page_failed = %llu\n",
 		 vsi->tx_restart, vsi->tx_busy,
 		 vsi->rx_buf_failed, vsi->rx_page_failed);
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index cc1cefdd4cda..20c8c0231e2c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -196,10 +196,6 @@ int i40e_free_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem)
  * @id: an owner id to stick on the items assigned
  *
  * Returns the base item index of the lump, or negative for error
- *
- * The search_hint trick and lack of advanced fit-finding only work
- * because we're highly likely to have all the same size lump requests.
- * Linear search time and any fragmentation should be minimal.
  **/
 static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 			 u16 needed, u16 id)
@@ -214,8 +210,21 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 		return -EINVAL;
 	}
 
-	/* start the linear search with an imperfect hint */
-	i = pile->search_hint;
+	/* Allocate last queue in the pile for FDIR VSI queue
+	 * so it doesn't fragment the qp_pile
+	 */
+	if (pile == pf->qp_pile && pf->vsi[id]->type == I40E_VSI_FDIR) {
+		if (pile->list[pile->num_entries - 1] & I40E_PILE_VALID_BIT) {
+			dev_err(&pf->pdev->dev,
+				"Cannot allocate queue %d for I40E_VSI_FDIR\n",
+				pile->num_entries - 1);
+			return -ENOMEM;
+		}
+		pile->list[pile->num_entries - 1] = id | I40E_PILE_VALID_BIT;
+		return pile->num_entries - 1;
+	}
+
+	i = 0;
 	while (i < pile->num_entries) {
 		/* skip already allocated entries */
 		if (pile->list[i] & I40E_PILE_VALID_BIT) {
@@ -234,7 +243,6 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 			for (j = 0; j < needed; j++)
 				pile->list[i+j] = id | I40E_PILE_VALID_BIT;
 			ret = i;
-			pile->search_hint = i + j;
 			break;
 		}
 
@@ -257,7 +265,7 @@ static int i40e_put_lump(struct i40e_lump_tracking *pile, u16 index, u16 id)
 {
 	int valid_id = (id | I40E_PILE_VALID_BIT);
 	int count = 0;
-	int i;
+	u16 i;
 
 	if (!pile || index >= pile->num_entries)
 		return -EINVAL;
@@ -269,8 +277,6 @@ static int i40e_put_lump(struct i40e_lump_tracking *pile, u16 index, u16 id)
 		count++;
 	}
 
-	if (count && index < pile->search_hint)
-		pile->search_hint = index;
 
 	return count;
 }
@@ -772,9 +778,9 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
 	struct i40e_eth_stats *es;     /* device's eth stats */
-	u32 tx_restart, tx_busy;
+	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u32 rx_page, rx_buf;
+	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -10574,15 +10580,9 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 	i40e_get_oem_version(&pf->hw);
 
-	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    ((hw->aq.fw_maj_ver == 4 && hw->aq.fw_min_ver <= 33) ||
-	     hw->aq.fw_maj_ver < 4) && hw->mac.type == I40E_MAC_XL710) {
-		/* The following delay is necessary for 4.33 firmware and older
-		 * to recover after EMP reset. 200 ms should suffice but we
-		 * put here 300 ms to be sure that FW is ready to operate
-		 * after reset.
-		 */
-		mdelay(300);
+	if (test_and_clear_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state)) {
+		/* The following delay is necessary for firmware update. */
+		mdelay(1000);
 	}
 
 	/* re-verify the eeprom if we just had an EMP reset */
@@ -11792,7 +11792,6 @@ static int i40e_init_interrupt_scheme(struct i40e_pf *pf)
 		return -ENOMEM;
 
 	pf->irq_pile->num_entries = vectors;
-	pf->irq_pile->search_hint = 0;
 
 	/* track first vector for misc interrupts, ignore return */
 	(void)i40e_get_lump(pf, pf->irq_pile, 1, I40E_PILE_VALID_BIT - 1);
@@ -12595,7 +12594,6 @@ static int i40e_sw_init(struct i40e_pf *pf)
 		goto sw_init_done;
 	}
 	pf->qp_pile->num_entries = pf->hw.func_caps.num_tx_qp;
-	pf->qp_pile->search_hint = 0;
 
 	pf->tx_timeout_recovery_level = 1;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 8d0588a27a05..1908eed4fa5e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -413,6 +413,9 @@
 #define I40E_VFINT_DYN_CTLN(_INTVF) (0x00024800 + ((_INTVF) * 4)) /* _i=0...511 */ /* Reset: VFR */
 #define I40E_VFINT_DYN_CTLN_CLEARPBA_SHIFT 1
 #define I40E_VFINT_DYN_CTLN_CLEARPBA_MASK I40E_MASK(0x1, I40E_VFINT_DYN_CTLN_CLEARPBA_SHIFT)
+#define I40E_VFINT_ICR0_ADMINQ_SHIFT 30
+#define I40E_VFINT_ICR0_ADMINQ_MASK I40E_MASK(0x1, I40E_VFINT_ICR0_ADMINQ_SHIFT)
+#define I40E_VFINT_ICR0_ENA(_VF) (0x0002C000 + ((_VF) * 4)) /* _i=0...127 */ /* Reset: CORER */
 #define I40E_VPINT_AEQCTL(_VF) (0x0002B800 + ((_VF) * 4)) /* _i=0...127 */ /* Reset: CORER */
 #define I40E_VPINT_AEQCTL_MSIX_INDX_SHIFT 0
 #define I40E_VPINT_AEQCTL_ITR_INDX_SHIFT 11
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 048f1678ab8a..c6f643e54c4f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1376,6 +1376,32 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 	return aq_ret;
 }
 
+/**
+ * i40e_sync_vfr_reset
+ * @hw: pointer to hw struct
+ * @vf_id: VF identifier
+ *
+ * Before trigger hardware reset, we need to know if no other process has
+ * reserved the hardware for any reset operations. This check is done by
+ * examining the status of the RSTAT1 register used to signal the reset.
+ **/
+static int i40e_sync_vfr_reset(struct i40e_hw *hw, int vf_id)
+{
+	u32 reg;
+	int i;
+
+	for (i = 0; i < I40E_VFR_WAIT_COUNT; i++) {
+		reg = rd32(hw, I40E_VFINT_ICR0_ENA(vf_id)) &
+			   I40E_VFINT_ICR0_ADMINQ_MASK;
+		if (reg)
+			return 0;
+
+		usleep_range(100, 200);
+	}
+
+	return -EAGAIN;
+}
+
 /**
  * i40e_trigger_vf_reset
  * @vf: pointer to the VF structure
@@ -1390,9 +1416,11 @@ static void i40e_trigger_vf_reset(struct i40e_vf *vf, bool flr)
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
 	u32 reg, reg_idx, bit_idx;
+	bool vf_active;
+	u32 radq;
 
 	/* warn the VF */
-	clear_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states);
+	vf_active = test_and_clear_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states);
 
 	/* Disable VF's configuration API during reset. The flag is re-enabled
 	 * in i40e_alloc_vf_res(), when it's safe again to access VF's VSI.
@@ -1406,7 +1434,19 @@ static void i40e_trigger_vf_reset(struct i40e_vf *vf, bool flr)
 	 * just need to clean up, so don't hit the VFRTRIG register.
 	 */
 	if (!flr) {
-		/* reset VF using VPGEN_VFRTRIG reg */
+		/* Sync VFR reset before trigger next one */
+		radq = rd32(hw, I40E_VFINT_ICR0_ENA(vf->vf_id)) &
+			    I40E_VFINT_ICR0_ADMINQ_MASK;
+		if (vf_active && !radq)
+			/* waiting for finish reset by virtual driver */
+			if (i40e_sync_vfr_reset(hw, vf->vf_id))
+				dev_info(&pf->pdev->dev,
+					 "Reset VF %d never finished\n",
+				vf->vf_id);
+
+		/* Reset VF using VPGEN_VFRTRIG reg. It is also setting
+		 * in progress state in rstat1 register.
+		 */
 		reg = rd32(hw, I40E_VPGEN_VFRTRIG(vf->vf_id));
 		reg |= I40E_VPGEN_VFRTRIG_VFSWR_MASK;
 		wr32(hw, I40E_VPGEN_VFRTRIG(vf->vf_id), reg);
@@ -2617,6 +2657,59 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 				       aq_ret);
 }
 
+/**
+ * i40e_check_enough_queue - find big enough queue number
+ * @vf: pointer to the VF info
+ * @needed: the number of items needed
+ *
+ * Returns the base item index of the queue, or negative for error
+ **/
+static int i40e_check_enough_queue(struct i40e_vf *vf, u16 needed)
+{
+	unsigned int  i, cur_queues, more, pool_size;
+	struct i40e_lump_tracking *pile;
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	cur_queues = vsi->alloc_queue_pairs;
+
+	/* if current allocated queues are enough for need */
+	if (cur_queues >= needed)
+		return vsi->base_queue;
+
+	pile = pf->qp_pile;
+	if (cur_queues > 0) {
+		/* if the allocated queues are not zero
+		 * just check if there are enough queues for more
+		 * behind the allocated queues.
+		 */
+		more = needed - cur_queues;
+		for (i = vsi->base_queue + cur_queues;
+			i < pile->num_entries; i++) {
+			if (pile->list[i] & I40E_PILE_VALID_BIT)
+				break;
+
+			if (more-- == 1)
+				/* there is enough */
+				return vsi->base_queue;
+		}
+	}
+
+	pool_size = 0;
+	for (i = 0; i < pile->num_entries; i++) {
+		if (pile->list[i] & I40E_PILE_VALID_BIT) {
+			pool_size = 0;
+			continue;
+		}
+		if (needed <= ++pool_size)
+			/* there is enough */
+			return i;
+	}
+
+	return -ENOMEM;
+}
+
 /**
  * i40e_vc_request_queues_msg
  * @vf: pointer to the VF info
@@ -2651,6 +2744,12 @@ static int i40e_vc_request_queues_msg(struct i40e_vf *vf, u8 *msg)
 			 req_pairs - cur_pairs,
 			 pf->queues_left);
 		vfres->num_queue_pairs = pf->queues_left + cur_pairs;
+	} else if (i40e_check_enough_queue(vf, req_pairs) < 0) {
+		dev_warn(&pf->pdev->dev,
+			 "VF %d requested %d more queues, but there is not enough for it.\n",
+			 vf->vf_id,
+			 req_pairs - cur_pairs);
+		vfres->num_queue_pairs = cur_pairs;
 	} else {
 		/* successful request */
 		vf->num_req_queues = req_pairs;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 49575a640a84..03c42fd0fea1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -19,6 +19,7 @@
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
 #define I40E_VF_STATE_WAIT_COUNT	20
+#define I40E_VFR_WAIT_COUNT		100
 
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 154877706a0e..26ad71842b3b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -698,6 +698,9 @@ enum nix_af_status {
 	NIX_AF_ERR_INVALID_BANDPROF = -426,
 	NIX_AF_ERR_IPOLICER_NOTSUPP = -427,
 	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
+	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
+	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
+	NIX_AF_ERR_LINK_CREDITS  = -431,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 07b0eafccad8..b3803577324e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -251,22 +251,19 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 	if (!rpm || lmac_id >= rpm->lmac_count)
 		return -ENODEV;
 	lmac_type = rpm->mac_ops->get_lmac_type(rpm, lmac_id);
-	if (lmac_type == LMAC_MODE_100G_R) {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
-
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
-	} else {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1);
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1, cfg);
+
+	if (lmac_type == LMAC_MODE_QSGMII || lmac_type == LMAC_MODE_SGMII) {
+		dev_err(&rpm->pdev->dev, "loopback not supported for LPC mode\n");
+		return 0;
 	}
 
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
+
+	if (enable)
+		cfg |= RPMX_MTI_PCS_LBK;
+	else
+		cfg &= ~RPMX_MTI_PCS_LBK;
+	rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
+
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 90dc5343827f..11ef46e72ddd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -520,8 +520,11 @@ static void rvu_block_reset(struct rvu *rvu, int blkaddr, u64 rst_reg)
 
 	rvu_write64(rvu, blkaddr, rst_reg, BIT_ULL(0));
 	err = rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true);
-	if (err)
-		dev_err(rvu->dev, "HW block:%d reset failed\n", blkaddr);
+	if (err) {
+		dev_err(rvu->dev, "HW block:%d reset timeout retrying again\n", blkaddr);
+		while (rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true) == -EBUSY)
+			;
+	}
 }
 
 static void rvu_reset_all_blocks(struct rvu *rvu)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 49d822a98ada..f001579569a2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1131,6 +1131,8 @@ static void print_nix_cn10k_sq_ctx(struct seq_file *m,
 	seq_printf(m, "W3: head_offset\t\t\t%d\nW3: smenq_next_sqb_vld\t\t%d\n\n",
 		   sq_ctx->head_offset, sq_ctx->smenq_next_sqb_vld);
 
+	seq_printf(m, "W3: smq_next_sq_vld\t\t%d\nW3: smq_pend\t\t\t%d\n",
+		   sq_ctx->smq_next_sq_vld, sq_ctx->smq_pend);
 	seq_printf(m, "W4: next_sqb \t\t\t%llx\n\n", sq_ctx->next_sqb);
 	seq_printf(m, "W5: tail_sqb \t\t\t%llx\n\n", sq_ctx->tail_sqb);
 	seq_printf(m, "W6: smenq_sqb \t\t\t%llx\n\n", sq_ctx->smenq_sqb);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6970540dc470..959266894cf1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -28,6 +28,7 @@ static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
 static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
 static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
 				     u32 leaf_prof);
+static const char *nix_get_ctx_name(int ctype);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -511,11 +512,11 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	lmac_chan_cnt = cfg & 0xFF;
 
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
-	sdp_chan_cnt = cfg & 0xFFF;
-
 	cgx_bpid_cnt = hw->cgx_links * lmac_chan_cnt;
 	lbk_bpid_cnt = hw->lbk_links * ((cfg >> 16) & 0xFF);
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
+	sdp_chan_cnt = cfg & 0xFFF;
 	sdp_bpid_cnt = hw->sdp_links * sdp_chan_cnt;
 
 	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
@@ -1061,10 +1062,68 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
+static int rvu_nix_verify_aq_ctx(struct rvu *rvu, struct nix_hw *nix_hw,
+				 struct nix_aq_enq_req *req, u8 ctype)
+{
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	int rc, word;
+
+	if (req->ctype != NIX_AQ_CTYPE_CQ)
+		return 0;
+
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp,
+				 req->hdr.pcifunc, ctype, req->qidx);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch %s%d context of PFFUNC 0x%x\n",
+			__func__, nix_get_ctx_name(ctype), req->qidx,
+			req->hdr.pcifunc);
+		return rc;
+	}
+
+	/* Make copy of original context & mask which are required
+	 * for resubmission
+	 */
+	memcpy(&aq_req.cq_mask, &req->cq_mask, sizeof(struct nix_cq_ctx_s));
+	memcpy(&aq_req.cq, &req->cq, sizeof(struct nix_cq_ctx_s));
+
+	/* exclude fields which HW can update */
+	aq_req.cq_mask.cq_err       = 0;
+	aq_req.cq_mask.wrptr        = 0;
+	aq_req.cq_mask.tail         = 0;
+	aq_req.cq_mask.head	    = 0;
+	aq_req.cq_mask.avg_level    = 0;
+	aq_req.cq_mask.update_time  = 0;
+	aq_req.cq_mask.substream    = 0;
+
+	/* Context mask (cq_mask) holds mask value of fields which
+	 * are changed in AQ WRITE operation.
+	 * for example cq.drop = 0xa;
+	 *	       cq_mask.drop = 0xff;
+	 * Below logic performs '&' between cq and cq_mask so that non
+	 * updated fields are masked out for request and response
+	 * comparison
+	 */
+	for (word = 0; word < sizeof(struct nix_cq_ctx_s) / sizeof(u64);
+	     word++) {
+		*(u64 *)((u8 *)&aq_rsp.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+		*(u64 *)((u8 *)&aq_req.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+	}
+
+	if (memcmp(&aq_req.cq, &aq_rsp.cq, sizeof(struct nix_cq_ctx_s)))
+		return NIX_AF_ERR_AQ_CTX_RETRY_WRITE;
+
+	return 0;
+}
+
 static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 			       struct nix_aq_enq_rsp *rsp)
 {
 	struct nix_hw *nix_hw;
+	int err, retries = 5;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
@@ -1075,7 +1134,24 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	if (!nix_hw)
 		return NIX_AF_ERR_INVALID_NIXBLK;
 
-	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+retry:
+	err = rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+
+	/* HW errata 'AQ Modification to CQ could be discarded on heavy traffic'
+	 * As a work around perfrom CQ context read after each AQ write. If AQ
+	 * read shows AQ write is not updated perform AQ write again.
+	 */
+	if (!err && req->op == NIX_AQ_INSTOP_WRITE) {
+		err = rvu_nix_verify_aq_ctx(rvu, nix_hw, req, NIX_AQ_CTYPE_CQ);
+		if (err == NIX_AF_ERR_AQ_CTX_RETRY_WRITE) {
+			if (retries--)
+				goto retry;
+			else
+				return NIX_AF_ERR_CQ_CTX_WRITE_ERR;
+		}
+	}
+
+	return err;
 }
 
 static const char *nix_get_ctx_name(int ctype)
@@ -3815,8 +3891,8 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 			    NIX_AF_TL1X_SW_XOFF(schq), BIT_ULL(0));
 	}
 
-	rc = -EBUSY;
-	poll_tmo = jiffies + usecs_to_jiffies(10000);
+	rc = NIX_AF_ERR_LINK_CREDITS;
+	poll_tmo = jiffies + usecs_to_jiffies(200000);
 	/* Wait for credits to return */
 	do {
 		if (time_after(jiffies, poll_tmo))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 5efb4174e82d..87f18e32b463 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -402,6 +402,7 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 			      int blkaddr, int index, struct mcam_entry *entry,
 			      bool *enable)
 {
+	struct rvu_npc_mcam_rule *rule;
 	u16 owner, target_func;
 	struct rvu_pfvf *pfvf;
 	u64 rx_action;
@@ -423,6 +424,12 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 	      test_bit(NIXLF_INITIALIZED, &pfvf->flags)))
 		*enable = false;
 
+	/* fix up not needed for the rules added by user(ntuple filters) */
+	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+		if (rule->entry == index)
+			return;
+	}
+
 	/* copy VF default entry action to the VF mcam entry */
 	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
 						 target_func);
@@ -489,8 +496,8 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	}
 
 	/* PF installing VF rule */
-	if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
-		npc_fixup_vf_rule(rvu, mcam, blkaddr, index, entry, &enable);
+	if (is_npc_intf_rx(intf) && actindex < mcam->bmap_entries)
+		npc_fixup_vf_rule(rvu, mcam, blkaddr, actindex, entry, &enable);
 
 	/* Set 'action' */
 	rvu_write64(rvu, blkaddr,
@@ -916,7 +923,8 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
 	int actindex, index, bank, entry;
-	bool enable;
+	struct rvu_npc_mcam_rule *rule;
+	bool enable, update;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
 		return;
@@ -924,6 +932,14 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	mutex_lock(&mcam->lock);
 	for (index = 0; index < mcam->bmap_entries; index++) {
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
+			update = true;
+			/* update not needed for the rules added via ntuple filters */
+			list_for_each_entry(rule, &mcam->mcam_rules, list) {
+				if (rule->entry == index)
+					update = false;
+			}
+			if (!update)
+				continue;
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
 			entry = index & (mcam->banksize - 1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 51ddc7b81d0b..ca404d51d9f5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1098,14 +1098,6 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 		write_req.cntr = rule->cntr;
 	}
 
-	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
-						    &write_rsp);
-	if (err) {
-		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
-		if (new)
-			kfree(rule);
-		return err;
-	}
 	/* update rule */
 	memcpy(&rule->packet, &dummy.packet, sizeof(rule->packet));
 	memcpy(&rule->mask, &dummy.mask, sizeof(rule->mask));
@@ -1129,6 +1121,18 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (req->default_rule)
 		pfvf->def_ucast_rule = rule;
 
+	/* write to mcam entry registers */
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
+						    &write_rsp);
+	if (err) {
+		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
+		if (new) {
+			list_del(&rule->list);
+			kfree(rule);
+		}
+		return err;
+	}
+
 	/* VF's MAC address is being changed via PF  */
 	if (pf_set_vfs_mac) {
 		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a51ecd771d07..637450de189c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -591,6 +591,7 @@ static inline void __cn10k_aura_freeptr(struct otx2_nic *pfvf, u64 aura,
 			size++;
 		tar_addr |=  ((size - 1) & 0x7) << 4;
 	}
+	dma_wmb();
 	memcpy((u64 *)lmt_info->lmt_addr, ptrs, sizeof(u64) * num_ptrs);
 	/* Perform LMTST flush */
 	cn10k_lmt_flush(val, tar_addr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53a3e8de1a51..b1894d4045b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -386,7 +386,12 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 		dst_mdev->msg_size = mbox_hdr->msg_size;
 		dst_mdev->num_msgs = num_msgs;
 		err = otx2_sync_mbox_msg(dst_mbox);
-		if (err) {
+		/* Error code -EIO indicate there is a communication failure
+		 * to the AF. Rest of the error codes indicate that AF processed
+		 * VF messages and set the error codes in response messages
+		 * (if any) so simply forward responses to VF.
+		 */
+		if (err == -EIO) {
 			dev_warn(pf->dev,
 				 "AF not responding to VF%d messages\n", vf);
 			/* restore PF mbase and exit */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index fac788718c04..4578c64953ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -22,21 +22,21 @@
 #define ETHER_CLK_SEL_RMII_CLK_EN BIT(2)
 #define ETHER_CLK_SEL_RMII_CLK_RST BIT(3)
 #define ETHER_CLK_SEL_DIV_SEL_2 BIT(4)
-#define ETHER_CLK_SEL_DIV_SEL_20 BIT(0)
+#define ETHER_CLK_SEL_DIV_SEL_20 0
 #define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
 #define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
 #define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
 #define ETHER_CLK_SEL_FREQ_SEL_2P5M	0
-#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN 0
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
-#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  BIT(0)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  0
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC BIT(12)
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV BIT(13)
-#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 0
 #define ETHER_CLK_SEL_TX_CLK_O_RMII_I	 BIT(14)
 #define ETHER_CLK_SEL_TX_O_E_N_IN	 BIT(15)
-#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 BIT(0)
+#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 0
 #define ETHER_CLK_SEL_RMII_CLK_SEL_RX_C	 BIT(16)
 
 #define ETHER_CLK_SEL_RX_TX_CLK_EN (ETHER_CLK_SEL_RX_CLK_EN | ETHER_CLK_SEL_TX_CLK_EN)
@@ -96,31 +96,41 @@ static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 	val |= ETHER_CLK_SEL_TX_O_E_N_IN;
 	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 
+	/* Set Clock-Mux, Start clock, Set TX_O direction */
 	switch (dwmac->phy_intf_sel) {
 	case ETHER_CONFIG_INTF_RGMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_RMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN |
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
 			ETHER_CLK_SEL_RMII_CLK_SEL_RX_C;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_RST;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_EN | ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_MII:
 	default:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
-			ETHER_CLK_SEL_RMII_CLK_EN;
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	}
 
-	/* Start clock */
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-	val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
-	val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
 	spin_unlock_irqrestore(&dwmac->lock, flags);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06e5431cf51d..9f3d18abf62b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -899,6 +899,9 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	int ret;
 
+	if (priv->plat->ptp_clk_freq_config)
+		priv->plat->ptp_clk_freq_config(priv);
+
 	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE);
 	if (ret)
 		return ret;
@@ -921,8 +924,6 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
-
 	return 0;
 }
 
@@ -3237,7 +3238,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3247,7 +3248,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3304,13 +3305,13 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	stmmac_mmc_setup(priv);
 
-	if (init_ptp) {
-		ret = stmmac_init_ptp(priv);
-		if (ret == -EOPNOTSUPP)
-			netdev_warn(priv->dev, "PTP not supported by HW\n");
-		else if (ret)
-			netdev_warn(priv->dev, "PTP init failed\n");
-	}
+	ret = stmmac_init_ptp(priv);
+	if (ret == -EOPNOTSUPP)
+		netdev_warn(priv->dev, "PTP not supported by HW\n");
+	else if (ret)
+		netdev_warn(priv->dev, "PTP init failed\n");
+	else if (ptp_register)
+		stmmac_ptp_register(priv);
 
 	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index be9b58b2abf9..ac8bc1c8614d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -297,9 +297,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 {
 	int i;
 
-	if (priv->plat->ptp_clk_freq_config)
-		priv->plat->ptp_clk_freq_config(priv);
-
 	for (i = 0; i < priv->dma_cap.pps_out_num; i++) {
 		if (i >= STMMAC_PPS_MAX)
 			break;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 6bb5ac51d23c..f8e591d69d2c 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1144,7 +1144,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
 					       int size)
 {
-	struct page_pool_params pp_params;
+	struct page_pool_params pp_params = {};
 	struct page_pool *pool;
 
 	pp_params.order = 0;
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 6ddacbdb224b..528d57a43539 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -950,9 +950,7 @@ static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __
 		ym = memdup_user(data, sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
-		if (ym->cmd != SIOCYAMSMCS)
-			return -EINVAL;
-		if (ym->bitrate > YAM_MAXBITRATE) {
+		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
 			kfree(ym);
 			return -EINVAL;
 		}
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 83aea5c5cd03..db26ff8ce7db 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -768,6 +768,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54616S",
 	/* PHY_GBIT_FEATURES */
+	.soft_reset     = genphy_soft_reset,
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm54616s_config_aneg,
 	.config_intr	= bcm_phy_config_intr,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 4f9990b47a37..28f4a383aba7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1746,6 +1746,9 @@ void phy_detach(struct phy_device *phydev)
 	    phy_driver_is_genphy_10g(phydev))
 		device_release_driver(&phydev->mdio.dev);
 
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	/*
 	 * The phydev might go away on the put_device() below, so avoid
 	 * a use-after-free bug by reading the underlying bus first.
@@ -1757,9 +1760,6 @@ void phy_detach(struct phy_device *phydev)
 		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);
-
-	/* Assert the reset signal */
-	phy_device_reset(phydev, 1);
 }
 EXPORT_SYMBOL(phy_detach);
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 7362f8c3271c..ef2c6a09eb0f 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -651,6 +651,11 @@ struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 	else if (ret < 0)
 		return ERR_PTR(ret);
 
+	if (!fwnode_device_is_available(ref.fwnode)) {
+		fwnode_handle_put(ref.fwnode);
+		return NULL;
+	}
+
 	bus = sfp_bus_get(ref.fwnode);
 	fwnode_handle_put(ref.fwnode);
 	if (!bus)
diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index 2bebc9b2d163..49dd5a200998 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -92,7 +92,7 @@ static int rpmsg_eptdev_destroy(struct device *dev, void *data)
 	/* wake up any blocked readers */
 	wake_up_interruptible(&eptdev->readq);
 
-	device_del(&eptdev->dev);
+	cdev_device_del(&eptdev->cdev, &eptdev->dev);
 	put_device(&eptdev->dev);
 
 	return 0;
@@ -335,7 +335,6 @@ static void rpmsg_eptdev_release_device(struct device *dev)
 
 	ida_simple_remove(&rpmsg_ept_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(eptdev->dev.devt));
-	cdev_del(&eptdev->cdev);
 	kfree(eptdev);
 }
 
@@ -380,19 +379,13 @@ static int rpmsg_eptdev_create(struct rpmsg_ctrldev *ctrldev,
 	dev->id = ret;
 	dev_set_name(dev, "rpmsg%d", ret);
 
-	ret = cdev_add(&eptdev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&eptdev->cdev, &eptdev->dev);
 	if (ret)
 		goto free_ept_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_eptdev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	return ret;
 
 free_ept_ida:
@@ -461,7 +454,6 @@ static void rpmsg_ctrldev_release_device(struct device *dev)
 
 	ida_simple_remove(&rpmsg_ctrl_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(dev->devt));
-	cdev_del(&ctrldev->cdev);
 	kfree(ctrldev);
 }
 
@@ -496,19 +488,13 @@ static int rpmsg_chrdev_probe(struct rpmsg_device *rpdev)
 	dev->id = ret;
 	dev_set_name(&ctrldev->dev, "rpmsg_ctrl%d", ret);
 
-	ret = cdev_add(&ctrldev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&ctrldev->cdev, &ctrldev->dev);
 	if (ret)
 		goto free_ctrl_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_ctrldev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(&rpdev->dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	dev_set_drvdata(&rpdev->dev, ctrldev);
 
 	return ret;
@@ -534,7 +520,7 @@ static void rpmsg_chrdev_remove(struct rpmsg_device *rpdev)
 	if (ret)
 		dev_warn(&rpdev->dev, "failed to nuke endpoints: %d\n", ret);
 
-	device_del(&ctrldev->dev);
+	cdev_device_del(&ctrldev->cdev, &ctrldev->dev);
 	put_device(&ctrldev->dev);
 }
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d24cafe02708..511bf8e0a436 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -521,6 +521,8 @@ static void zfcp_fc_adisc_handler(void *data)
 		goto out;
 	}
 
+	/* re-init to undo drop from zfcp_fc_adisc() */
+	port->d_id = ntoh24(adisc_resp->adisc_port_id);
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
@@ -534,6 +536,7 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
 	struct Scsi_Host *shost = adapter->scsi_host;
+	u32 d_id;
 	int ret;
 
 	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_ATOMIC);
@@ -558,7 +561,15 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
 	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &fc_req->ct_els,
+	d_id = port->d_id; /* remember as destination for send els below */
+	/*
+	 * Force fresh GID_PN lookup on next port recovery.
+	 * Must happen after request setup and before sending request,
+	 * to prevent race with port->d_id re-init in zfcp_fc_adisc_handler().
+	 */
+	port->d_id = 0;
+
+	ret = zfcp_fsf_send_els(adapter, d_id, &fc_req->ct_els,
 				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_fc_req_cache, fc_req);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8863a74e6c57..a8ce854c4684 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -82,7 +82,7 @@ static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba);
 static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba);
 static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 				  struct device *parent, int npiv);
-static void bnx2fc_destroy_work(struct work_struct *work);
+static void bnx2fc_port_destroy(struct fcoe_port *port);
 
 static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev);
 static struct bnx2fc_interface *bnx2fc_interface_lookup(struct net_device
@@ -907,9 +907,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				__bnx2fc_destroy(interface);
 		}
 		mutex_unlock(&bnx2fc_dev_lock);
-
-		/* Ensure ALL destroy work has been completed before return */
-		flush_workqueue(bnx2fc_wq);
 		return;
 
 	default:
@@ -1215,8 +1212,8 @@ static int bnx2fc_vport_destroy(struct fc_vport *vport)
 	mutex_unlock(&n_port->lp_mutex);
 	bnx2fc_free_vport(interface->hba, port->lport);
 	bnx2fc_port_shutdown(port->lport);
+	bnx2fc_port_destroy(port);
 	bnx2fc_interface_put(interface);
-	queue_work(bnx2fc_wq, &port->destroy_work);
 	return 0;
 }
 
@@ -1525,7 +1522,6 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	port->lport = lport;
 	port->priv = interface;
 	port->get_netdev = bnx2fc_netdev;
-	INIT_WORK(&port->destroy_work, bnx2fc_destroy_work);
 
 	/* Configure fcoe_port */
 	rc = bnx2fc_lport_config(lport);
@@ -1653,8 +1649,8 @@ static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 	bnx2fc_interface_cleanup(interface);
 	bnx2fc_stop(interface);
 	list_del(&interface->list);
+	bnx2fc_port_destroy(port);
 	bnx2fc_interface_put(interface);
-	queue_work(bnx2fc_wq, &port->destroy_work);
 }
 
 /**
@@ -1694,15 +1690,12 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	return rc;
 }
 
-static void bnx2fc_destroy_work(struct work_struct *work)
+static void bnx2fc_port_destroy(struct fcoe_port *port)
 {
-	struct fcoe_port *port;
 	struct fc_lport *lport;
 
-	port = container_of(work, struct fcoe_port, destroy_work);
 	lport = port->lport;
-
-	BNX2FC_HBA_DBG(lport, "Entered bnx2fc_destroy_work\n");
+	BNX2FC_HBA_DBG(lport, "Entered %s, destroying lport %p\n", __func__, lport);
 
 	bnx2fc_if_destroy(lport);
 }
@@ -2556,9 +2549,6 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 			__bnx2fc_destroy(interface);
 	mutex_unlock(&bnx2fc_dev_lock);
 
-	/* Ensure ALL destroy work has been completed before return */
-	flush_workqueue(bnx2fc_wq);
-
 	bnx2fc_ulp_stop(hba);
 	/* unregister cnic device */
 	if (test_and_clear_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic))
diff --git a/drivers/scsi/elx/libefc/efc_els.c b/drivers/scsi/elx/libefc/efc_els.c
index 24db0accb256..5f690378fe9a 100644
--- a/drivers/scsi/elx/libefc/efc_els.c
+++ b/drivers/scsi/elx/libefc/efc_els.c
@@ -46,18 +46,14 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 
 	efc = node->efc;
 
-	spin_lock_irqsave(&node->els_ios_lock, flags);
-
 	if (!node->els_io_enabled) {
 		efc_log_err(efc, "els io alloc disabled\n");
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
 	els = mempool_alloc(efc->els_io_pool, GFP_ATOMIC);
 	if (!els) {
 		atomic_add_return(1, &efc->els_io_alloc_failed_count);
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
@@ -74,7 +70,6 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 					      &els->io.req.phys, GFP_DMA);
 	if (!els->io.req.virt) {
 		mempool_free(els, efc->els_io_pool);
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
@@ -94,10 +89,11 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 
 		/* add els structure to ELS IO list */
 		INIT_LIST_HEAD(&els->list_entry);
+		spin_lock_irqsave(&node->els_ios_lock, flags);
 		list_add_tail(&els->list_entry, &node->els_ios_list);
+		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 	}
 
-	spin_unlock_irqrestore(&node->els_ios_lock, flags);
 	return els;
 }
 
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 1d92d2a84889..09a14f7c79f4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -318,6 +318,7 @@ static struct tty_driver *gsm_tty_driver;
 #define GSM1_ESCAPE_BITS	0x20
 #define XON			0x11
 #define XOFF			0x13
+#define ISO_IEC_646_MASK	0x7F
 
 static const struct tty_port_operations gsm_port_ops;
 
@@ -527,7 +528,8 @@ static int gsm_stuff_frame(const u8 *input, u8 *output, int len)
 	int olen = 0;
 	while (len--) {
 		if (*input == GSM1_SOF || *input == GSM1_ESCAPE
-		    || *input == XON || *input == XOFF) {
+		    || (*input & ISO_IEC_646_MASK) == XON
+		    || (*input & ISO_IEC_646_MASK) == XOFF) {
 			*output++ = GSM1_ESCAPE;
 			*output++ = *input++ ^ GSM1_ESCAPE_BITS;
 			olen++;
diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index bce28729dd7b..be8626234627 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -83,8 +83,17 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		port->mapsize = resource_size(&resource);
 
 		/* Check for shifted address mapping */
-		if (of_property_read_u32(np, "reg-offset", &prop) == 0)
+		if (of_property_read_u32(np, "reg-offset", &prop) == 0) {
+			if (prop >= port->mapsize) {
+				dev_warn(&ofdev->dev, "reg-offset %u exceeds region size %pa\n",
+					 prop, &port->mapsize);
+				ret = -EINVAL;
+				goto err_unprepare;
+			}
+
 			port->mapbase += prop;
+			port->mapsize -= prop;
+		}
 
 		port->iotype = UPIO_MEM;
 		if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index f7d89440076a..114a49da564a 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5203,8 +5203,30 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS400,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0dc0 */
 		pbn_b2_4_115200 },
+	/* Brainboxes Devices */
 	/*
-	 * BrainBoxes UC-260
+	* Brainboxes UC-101
+	*/
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0BA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-235/246
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0AA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-257
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0861,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-260/271/701/756
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0D21,
 		PCI_ANY_ID, PCI_ANY_ID,
@@ -5212,7 +5234,81 @@ static const struct pci_device_id serial_pci_tbl[] = {
 		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0E34,
 		PCI_ANY_ID, PCI_ANY_ID,
-		 PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-268
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0841,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-275/279
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0881,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_8_115200 },
+	/*
+	 * Brainboxes UC-302
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x08E1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-310
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08C1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-313
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08A3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-320/324
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A61,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-346
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0B02,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-357
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A81,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A83,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-368
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0C41,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-420/431
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0921,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
 		pbn_b2_4_115200 },
 	/*
 	 * Perle PCI-RAS cards
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6ec34260d6b1..da54f827c5ef 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1615,8 +1615,12 @@ static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		mctrl &= ~TIOCM_RTS;
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+			mctrl &= ~TIOCM_RTS;
+		else
+			mctrl |= TIOCM_RTS;
+	}
 
 	cr = pl011_read(uap, REG_CR);
 
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 3366914dad7a..200cd293d14d 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -575,7 +575,7 @@ static void stm32_usart_start_tx(struct uart_port *port)
 	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {
diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index 55c73b1d8704..d00ff98dffab 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
 /* Indicate the cdns3 core was power lost before */
 bool cdns_power_is_lost(struct cdns *cdns)
 {
-	if (cdns->version == CDNS3_CONTROLLER_V1) {
-		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
+	if (cdns->version == CDNS3_CONTROLLER_V0) {
+		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
 			return true;
 	} else {
-		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
+		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
 			return true;
 	}
 	return false;
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 4169cf40a03b..8f8405b0d608 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -39,8 +39,11 @@ static int ulpi_match(struct device *dev, struct device_driver *driver)
 	struct ulpi *ulpi = to_ulpi_dev(dev);
 	const struct ulpi_device_id *id;
 
-	/* Some ULPI devices don't have a vendor id so rely on OF match */
-	if (ulpi->id.vendor == 0)
+	/*
+	 * Some ULPI devices don't have a vendor id
+	 * or provide an id_table so rely on OF match.
+	 */
+	if (ulpi->id.vendor == 0 || !drv->id_table)
 		return of_driver_match_device(dev, driver);
 
 	for (id = drv->id_table; id->vendor; id++)
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 16bab9826127..dd3c288fa952 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1563,6 +1563,13 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
+		/*
+		 * Order the write of urb->use_count above before the read
+		 * of urb->reject below.  Pairs with the memory barriers in
+		 * usb_kill_urb() and usb_poison_urb().
+		 */
+		smp_mb__after_atomic();
+
 		atomic_dec(&urb->dev->urbnum);
 		if (atomic_read(&urb->reject))
 			wake_up(&usb_kill_urb_queue);
@@ -1665,6 +1672,13 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
+	/*
+	 * Order the write of urb->use_count above before the read
+	 * of urb->reject below.  Pairs with the memory barriers in
+	 * usb_kill_urb() and usb_poison_urb().
+	 */
+	smp_mb__after_atomic();
+
 	if (unlikely(atomic_read(&urb->reject)))
 		wake_up(&usb_kill_urb_queue);
 	usb_put_urb(urb);
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 30727729a44c..33d62d7e3929 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -715,6 +715,12 @@ void usb_kill_urb(struct urb *urb)
 	if (!(urb && urb->dev && urb->ep))
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	usb_hcd_unlink_urb(urb, -ENOENT);
 	wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
@@ -756,6 +762,12 @@ void usb_poison_urb(struct urb *urb)
 	if (!urb)
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	if (!urb->dev || !urb->ep)
 		return;
diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index 9cc3ad701a29..a6f3a9b38789 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -99,17 +99,29 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 	struct device		*dev = priv_data->dev;
 	struct reset_control	*crst, *hibrst, *apbrst;
 	struct phy		*usb3_phy;
-	int			ret;
+	int			ret = 0;
 	u32			reg;
 
-	usb3_phy = devm_phy_get(dev, "usb3-phy");
-	if (PTR_ERR(usb3_phy) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
+	if (IS_ERR(usb3_phy)) {
+		ret = PTR_ERR(usb3_phy);
+		dev_err_probe(dev, ret,
+			      "failed to get USB3 PHY\n");
 		goto err;
-	} else if (IS_ERR(usb3_phy)) {
-		usb3_phy = NULL;
 	}
 
+	/*
+	 * The following core resets are not required unless a USB3 PHY
+	 * is used, and the subsequent register settings are not required
+	 * unless a core reset is performed (they should be set properly
+	 * by the first-stage boot loader, but may be reverted by a core
+	 * reset). They may also break the configuration if USB3 is actually
+	 * in use but the usb3-phy entry is missing from the device tree.
+	 * Therefore, skip these operations in this case.
+	 */
+	if (!usb3_phy)
+		goto skip_usb3_phy;
+
 	crst = devm_reset_control_get_exclusive(dev, "usb_crst");
 	if (IS_ERR(crst)) {
 		ret = PTR_ERR(crst);
@@ -188,6 +200,7 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 		goto err;
 	}
 
+skip_usb3_phy:
 	/*
 	 * This routes the USB DMA traffic to go through FPD path instead
 	 * of reaching DDR directly. This traffic routing is needed to
diff --git a/drivers/usb/gadget/function/f_sourcesink.c b/drivers/usb/gadget/function/f_sourcesink.c
index 1abf08e5164a..6803cd60cc6d 100644
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -584,6 +584,7 @@ static int source_sink_start_ep(struct f_sourcesink *ss, bool is_in,
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index c1edcc9b13ce..dc570ce4e831 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -437,6 +437,9 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int ret;
 
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
 	ret = xhci_priv_suspend_quirk(hcd);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 29191d33c0e3..1a05e3dcfec8 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2301,6 +2301,16 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
 		US_FL_SCM_MULT_TARG ),
 
+/*
+ * Reported by DocMAX <mail@vacharakis.de>
+ * and Thomas Weißschuh <linux@weissschuh.net>
+ */
+UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+		"VIA Labs, Inc.",
+		"VL817 SATA Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index c15eec9cc460..7d540afdb7cc 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -75,9 +75,25 @@ static int tcpci_write16(struct tcpci *tcpci, unsigned int reg, u16 val)
 static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
 {
 	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
+	bool vconn_pres;
+	enum typec_cc_polarity polarity = TYPEC_POLARITY_CC1;
 	unsigned int reg;
 	int ret;
 
+	ret = regmap_read(tcpci->regmap, TCPC_POWER_STATUS, &reg);
+	if (ret < 0)
+		return ret;
+
+	vconn_pres = !!(reg & TCPC_POWER_STATUS_VCONN_PRES);
+	if (vconn_pres) {
+		ret = regmap_read(tcpci->regmap, TCPC_TCPC_CTRL, &reg);
+		if (ret < 0)
+			return ret;
+
+		if (reg & TCPC_TCPC_CTRL_ORIENTATION)
+			polarity = TYPEC_POLARITY_CC2;
+	}
+
 	switch (cc) {
 	case TYPEC_CC_RA:
 		reg = (TCPC_ROLE_CTRL_CC_RA << TCPC_ROLE_CTRL_CC1_SHIFT) |
@@ -112,6 +128,16 @@ static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
 		break;
 	}
 
+	if (vconn_pres) {
+		if (polarity == TYPEC_POLARITY_CC2) {
+			reg &= ~(TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT);
+			reg |= (TCPC_ROLE_CTRL_CC_OPEN << TCPC_ROLE_CTRL_CC1_SHIFT);
+		} else {
+			reg &= ~(TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT);
+			reg |= (TCPC_ROLE_CTRL_CC_OPEN << TCPC_ROLE_CTRL_CC2_SHIFT);
+		}
+	}
+
 	ret = regmap_write(tcpci->regmap, TCPC_ROLE_CTRL, reg);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/usb/typec/tcpm/tcpci.h b/drivers/usb/typec/tcpm/tcpci.h
index 2be7a77d400e..b2edd45f13c6 100644
--- a/drivers/usb/typec/tcpm/tcpci.h
+++ b/drivers/usb/typec/tcpm/tcpci.h
@@ -98,6 +98,7 @@
 #define TCPC_POWER_STATUS_SOURCING_VBUS	BIT(4)
 #define TCPC_POWER_STATUS_VBUS_DET	BIT(3)
 #define TCPC_POWER_STATUS_VBUS_PRES	BIT(2)
+#define TCPC_POWER_STATUS_VCONN_PRES	BIT(1)
 #define TCPC_POWER_STATUS_SINKING_VBUS	BIT(0)
 
 #define TCPC_FAULT_STATUS		0x1f
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 59d4fa2443f2..5fce795b69c7 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:
@@ -5263,6 +5264,10 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 	case PR_SWAP_SNK_SRC_SOURCE_ON:
 		/* Do nothing, vsafe0v is expected during transition */
 		break;
+	case SNK_ATTACH_WAIT:
+	case SNK_DEBOUNCED:
+		/*Do nothing, still waiting for VSAFE5V for connect */
+		break;
 	default:
 		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
 			tcpm_set_state(port, SNK_UNATTACHED, 0);
diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index bff96d64dddf..6db7c8ddd51c 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -325,7 +325,7 @@ static int ucsi_ccg_init(struct ucsi_ccg *uc)
 		if (status < 0)
 			return status;
 
-		if (!data)
+		if (!(data & DEV_INT))
 			return 0;
 
 		status = ccg_write(uc, CCGX_RAB_INTR_REG, &data, sizeof(data));
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 23999df52739..c8e0ea27caf1 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -287,8 +287,6 @@ struct hvfb_par {
 
 static uint screen_width = HVFB_WIDTH;
 static uint screen_height = HVFB_HEIGHT;
-static uint screen_width_max = HVFB_WIDTH;
-static uint screen_height_max = HVFB_HEIGHT;
 static uint screen_depth;
 static uint screen_fb_size;
 static uint dio_fb_size; /* FB size for deferred IO */
@@ -582,7 +580,6 @@ static int synthvid_get_supported_resolution(struct hv_device *hdev)
 	int ret = 0;
 	unsigned long t;
 	u8 index;
-	int i;
 
 	memset(msg, 0, sizeof(struct synthvid_msg));
 	msg->vid_hdr.type = SYNTHVID_RESOLUTION_REQUEST;
@@ -613,13 +610,6 @@ static int synthvid_get_supported_resolution(struct hv_device *hdev)
 		goto out;
 	}
 
-	for (i = 0; i < msg->resolution_resp.resolution_count; i++) {
-		screen_width_max = max_t(unsigned int, screen_width_max,
-		    msg->resolution_resp.supported_resolution[i].width);
-		screen_height_max = max_t(unsigned int, screen_height_max,
-		    msg->resolution_resp.supported_resolution[i].height);
-	}
-
 	screen_width =
 		msg->resolution_resp.supported_resolution[index].width;
 	screen_height =
@@ -941,7 +931,7 @@ static void hvfb_get_option(struct fb_info *info)
 
 	if (x < HVFB_WIDTH_MIN || y < HVFB_HEIGHT_MIN ||
 	    (synthvid_ver_ge(par->synthvid_version, SYNTHVID_VERSION_WIN10) &&
-	    (x > screen_width_max || y > screen_height_max)) ||
+	    (x * y * screen_depth / 8 > screen_fb_size)) ||
 	    (par->synthvid_version == SYNTHVID_VERSION_WIN8 &&
 	     x * y * screen_depth / 8 > SYNTHVID_FB_SIZE_WIN8) ||
 	    (par->synthvid_version == SYNTHVID_VERSION_WIN7 &&
@@ -1194,8 +1184,8 @@ static int hvfb_probe(struct hv_device *hdev,
 	}
 
 	hvfb_get_option(info);
-	pr_info("Screen resolution: %dx%d, Color depth: %d\n",
-		screen_width, screen_height, screen_depth);
+	pr_info("Screen resolution: %dx%d, Color depth: %d, Frame buffer size: %d\n",
+		screen_width, screen_height, screen_depth, screen_fb_size);
 
 	ret = hvfb_getmem(hdev, info);
 	if (ret) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cc61813213d8..0b6b9c3283ff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3098,10 +3098,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	btrfs_inode_lock(inode, 0);
 	err = btrfs_delete_subvolume(dir, dentry);
 	btrfs_inode_unlock(inode, 0);
-	if (!err) {
-		fsnotify_rmdir(dir, dentry);
-		d_delete(dentry);
-	}
+	if (!err)
+		d_delete_notify(dir, dentry);
 
 out_dput:
 	dput(dentry);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 8be4da2e2b82..09900a9015ea 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2217,6 +2217,7 @@ static int unsafe_request_wait(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
+	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2234,37 +2235,45 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * The mdsc->max_sessions is unlikely to be changed
+	 * mostly, here we will retry it by reallocating the
+	 * sessions array memory to get rid of the mdsc->mutex
+	 * lock.
+	 */
+retry:
+	max_sessions = mdsc->max_sessions;
+
 	/*
 	 * Trigger to flush the journal logs in all the relevant MDSes
 	 * manually, or in the worst case we must wait at most 5 seconds
 	 * to wait the journal logs to be flushed by the MDSes periodically.
 	 */
-	if (req1 || req2) {
+	if ((req1 || req2) && likely(max_sessions)) {
 		struct ceph_mds_session **sessions = NULL;
 		struct ceph_mds_session *s;
 		struct ceph_mds_request *req;
-		unsigned int max;
 		int i;
 
-		/*
-		 * The mdsc->max_sessions is unlikely to be changed
-		 * mostly, here we will retry it by reallocating the
-		 * sessions arrary memory to get rid of the mdsc->mutex
-		 * lock.
-		 */
-retry:
-		max = mdsc->max_sessions;
-		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
-		if (!sessions)
-			return -ENOMEM;
+		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		if (!sessions) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		spin_lock(&ci->i_unsafe_lock);
 		if (req1) {
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max)) {
+				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					for (i = 0; i < max_sessions; i++) {
+						s = sessions[i];
+						if (s)
+							ceph_put_mds_session(s);
+					}
+					kfree(sessions);
 					goto retry;
 				}
 				if (!sessions[s->s_mds]) {
@@ -2277,8 +2286,14 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max)) {
+				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					for (i = 0; i < max_sessions; i++) {
+						s = sessions[i];
+						if (s)
+							ceph_put_mds_session(s);
+					}
+					kfree(sessions);
 					goto retry;
 				}
 				if (!sessions[s->s_mds]) {
@@ -2299,7 +2314,7 @@ static int unsafe_request_wait(struct inode *inode)
 		spin_unlock(&ci->i_ceph_lock);
 
 		/* send flush mdlog request to MDSes */
-		for (i = 0; i < max; i++) {
+		for (i = 0; i < max_sessions; i++) {
 			s = sessions[i];
 			if (s) {
 				send_flush_mdlog(s);
@@ -2316,15 +2331,19 @@ static int unsafe_request_wait(struct inode *inode)
 					ceph_timeout_jiffies(req1->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req1);
 	}
 	if (req2) {
 		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
 					ceph_timeout_jiffies(req2->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req2);
 	}
+
+out:
+	if (req1)
+		ceph_mdsc_put_request(req1);
+	if (req2)
+		ceph_mdsc_put_request(req2);
 	return err;
 }
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e873c2ba7a7f..6180df6f8e61 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -577,6 +577,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct inode *inode;
 	struct timespec64 now;
+	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_vino vino = { .ino = req->r_deleg_ino,
 				  .snap = CEPH_NOSNAP };
@@ -626,6 +627,12 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 
 	ceph_file_layout_to_legacy(lo, &in.layout);
+	/* lo is private, so pool_ns can't change */
+	pool_ns = rcu_dereference_raw(lo->pool_ns);
+	if (pool_ns) {
+		iinfo.pool_ns_len = pool_ns->len;
+		iinfo.pool_ns_data = pool_ns->str;
+	}
 
 	down_read(&mdsc->snap_rwsem);
 	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
@@ -744,8 +751,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 				restore_deleg_ino(dir, req->r_deleg_ino);
 				ceph_mdsc_put_request(req);
 				try_async = false;
+				ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 				goto retry;
 			}
+			ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 			goto out_req;
 		}
 	}
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 1466b5d01cbb..d3cd2a94d1e8 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1780,8 +1780,8 @@ void configfs_unregister_group(struct config_group *group)
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
+	d_drop(dentry);
 	fsnotify_rmdir(d_inode(parent), dentry);
-	d_delete(dentry);
 	inode_unlock(d_inode(parent));
 
 	dput(dentry);
@@ -1922,10 +1922,10 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
-	fsnotify_rmdir(d_inode(root), dentry);
 	inode_unlock(d_inode(dentry));
 
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_rmdir(d_inode(root), dentry);
 
 	inode_unlock(d_inode(root));
 
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 42e5a766d33c..4f25015aa534 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -621,8 +621,8 @@ void devpts_pty_kill(struct dentry *dentry)
 
 	dentry->d_fsdata = NULL;
 	drop_nlink(dentry->d_inode);
-	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	d_drop(dentry);
+	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 }
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f713b91537f4..993913c585fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7718,10 +7718,15 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 	unsigned long flags;
 	bool first_add = false;
+	unsigned long delay = HZ;
 
 	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
+	/* if we are mid-quiesce then do not delay */
+	if (node->rsrc_data->quiesce)
+		delay = 0;
+
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node = list_first_entry(&ctx->rsrc_ref_list,
 					    struct io_rsrc_node, node);
@@ -7734,7 +7739,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 35302bc192eb..bd9ac9891604 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2970,6 +2970,7 @@ struct journal_head *jbd2_journal_grab_journal_head(struct buffer_head *bh)
 	jbd_unlock_bh_journal_head(bh);
 	return jh;
 }
+EXPORT_SYMBOL(jbd2_journal_grab_journal_head);
 
 static void __journal_remove_journal_head(struct buffer_head *bh)
 {
@@ -3022,6 +3023,7 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
 		jbd_unlock_bh_journal_head(bh);
 	}
 }
+EXPORT_SYMBOL(jbd2_journal_put_journal_head);
 
 /*
  * Initialize jbd inode head
diff --git a/fs/namei.c b/fs/namei.c
index 1946d9667790..3bb65f48fe1d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3975,13 +3975,12 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 	dentry->d_inode->i_flags |= S_DEAD;
 	dont_mount(dentry);
 	detach_mounts(dentry);
-	fsnotify_rmdir(dir, dentry);
 
 out:
 	inode_unlock(dentry->d_inode);
 	dput(dentry);
 	if (!error)
-		d_delete(dentry);
+		d_delete_notify(dir, dentry);
 	return error;
 }
 EXPORT_SYMBOL(vfs_rmdir);
@@ -4103,7 +4102,6 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
 			if (!error) {
 				dont_mount(dentry);
 				detach_mounts(dentry);
-				fsnotify_unlink(dir, dentry);
 			}
 		}
 	}
@@ -4111,9 +4109,11 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
 	inode_unlock(target);
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
-	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+	if (!error && dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		fsnotify_unlink(dir, dentry);
+	} else if (!error) {
 		fsnotify_link_count(target);
-		d_delete(dentry);
+		d_delete_notify(dir, dentry);
 	}
 
 	return error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5b68c44848ca..ed79c1bd84a2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1982,6 +1982,24 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 
 no_open:
 	res = nfs_lookup(dir, dentry, lookup_flags);
+	if (!res) {
+		inode = d_inode(dentry);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode))
+			res = ERR_PTR(-ENOTDIR);
+		else if (inode && S_ISREG(inode->i_mode))
+			res = ERR_PTR(-EOPENSTALE);
+	} else if (!IS_ERR(res)) {
+		inode = d_inode(res);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-ENOTDIR);
+		} else if (inode && S_ISREG(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-EOPENSTALE);
+		}
+	}
 	if (switched) {
 		d_lookup_done(dentry);
 		if (!res)
@@ -2382,6 +2400,8 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 
 	trace_nfs_link_enter(inode, dir, dentry);
 	d_drop(dentry);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_inode(inode);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
 		ihold(inode);
@@ -2470,6 +2490,8 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		}
 	}
 
+	if (S_ISREG(old_inode->i_mode))
+		nfs_sync_inode(old_inode);
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry, NULL);
 	if (IS_ERR(task)) {
 		error = PTR_ERR(task);
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 5ed04d6be9a5..cb73c1292562 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1249,7 +1249,8 @@ static void nfsdfs_remove_file(struct inode *dir, struct dentry *dentry)
 	clear_ncl(d_inode(dentry));
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_unlink(dir, dentry);
 	dput(dentry);
 	WARN_ON_ONCE(ret);
 }
@@ -1340,8 +1341,8 @@ void nfsd_client_rmdir(struct dentry *dentry)
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
 	WARN_ON_ONCE(ret);
+	d_drop(dentry);
 	fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	inode_unlock(dir);
 }
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 481017e1dac5..166c8918c825 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1251,26 +1251,23 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret = 1;
+	int ret;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
-	if (!buffer_jbd(bg_bh))
+	jh = jbd2_journal_grab_journal_head(bg_bh);
+	if (!jh)
 		return 1;
 
-	jbd_lock_bh_journal_head(bg_bh);
-	if (buffer_jbd(bg_bh)) {
-		jh = bh2jh(bg_bh);
-		spin_lock(&jh->b_state_lock);
-		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-		if (bg)
-			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-		else
-			ret = 1;
-		spin_unlock(&jh->b_state_lock);
-	}
-	jbd_unlock_bh_journal_head(bg_bh);
+	spin_lock(&jh->b_state_lock);
+	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+	if (bg)
+		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	else
+		ret = 1;
+	spin_unlock(&jh->b_state_lock);
+	jbd2_journal_put_journal_head(jh);
 
 	return ret;
 }
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1d6b7a50736b..ea8f6cd01f50 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -258,10 +258,6 @@ int udf_expand_file_adinicb(struct inode *inode)
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
-	struct writeback_control udf_wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-	};
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 	if (!iinfo->i_lenAlloc) {
@@ -305,8 +301,10 @@ int udf_expand_file_adinicb(struct inode *inode)
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
+	set_page_dirty(page);
+	unlock_page(page);
 	up_write(&iinfo->i_data_sem);
-	err = inode->i_data.a_ops->writepage(page, &udf_wbc);
+	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		lock_page(page);
@@ -317,6 +315,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	put_page(page);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0a9fdcbbab83..be8e7a55d803 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1947,6 +1947,7 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 12d3a7d308ab..a9477c14fad5 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -212,6 +212,42 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode,
 	fsnotify_name(dir, FS_CREATE, inode, &new_dentry->d_name, 0);
 }
 
+/*
+ * fsnotify_delete - @dentry was unlinked and unhashed
+ *
+ * Caller must make sure that dentry->d_name is stable.
+ *
+ * Note: unlike fsnotify_unlink(), we have to pass also the unlinked inode
+ * as this may be called after d_delete() and old_dentry may be negative.
+ */
+static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
+				   struct dentry *dentry)
+{
+	__u32 mask = FS_DELETE;
+
+	if (S_ISDIR(inode->i_mode))
+		mask |= FS_ISDIR;
+
+	fsnotify_name(dir, mask, inode, &dentry->d_name, 0);
+}
+
+/**
+ * d_delete_notify - delete a dentry and call fsnotify_delete()
+ * @dentry: The dentry to delete
+ *
+ * This helper is used to guaranty that the unlinked inode cannot be found
+ * by lookup of this name after fsnotify_delete() event has been delivered.
+ */
+static inline void d_delete_notify(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+
+	ihold(inode);
+	d_delete(dentry);
+	fsnotify_delete(dir, inode, dentry);
+	iput(inode);
+}
+
 /*
  * fsnotify_unlink - 'name' was unlinked
  *
@@ -219,10 +255,10 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode,
  */
 static inline void fsnotify_unlink(struct inode *dir, struct dentry *dentry)
 {
-	/* Expected to be called before d_delete() */
-	WARN_ON_ONCE(d_is_negative(dentry));
+	if (WARN_ON_ONCE(d_is_negative(dentry)))
+		return;
 
-	fsnotify_dirent(dir, dentry, FS_DELETE);
+	fsnotify_delete(dir, d_inode(dentry), dentry);
 }
 
 /*
@@ -242,10 +278,10 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	/* Expected to be called before d_delete() */
-	WARN_ON_ONCE(d_is_negative(dentry));
+	if (WARN_ON_ONCE(d_is_negative(dentry)))
+		return;
 
-	fsnotify_dirent(dir, dentry, FS_DELETE | FS_ISDIR);
+	fsnotify_delete(dir, d_inode(dentry), dentry);
 }
 
 /*
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73a52aba448f..90c2d7f3c7a8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1511,11 +1511,18 @@ static inline u8 page_kasan_tag(const struct page *page)
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
-	if (kasan_enabled()) {
-		tag ^= 0xff;
-		page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
-		page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
-	}
+	unsigned long old_flags, flags;
+
+	if (!kasan_enabled())
+		return;
+
+	tag ^= 0xff;
+	old_flags = READ_ONCE(page->flags);
+	do {
+		flags = old_flags;
+		flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
+		flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
+	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
 }
 
 static inline void page_kasan_tag_reset(struct page *page)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ce81cc96a98d..fba54624191a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2636,6 +2636,7 @@ struct packet_type {
 					      struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*af_packet_net;
 	void			*af_packet_priv;
 	struct list_head	list;
 };
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ae1f0c8b7562..6cce33e7e7ac 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -680,18 +680,6 @@ struct perf_event {
 	u64				total_time_running;
 	u64				tstamp;
 
-	/*
-	 * timestamp shadows the actual context timing but it can
-	 * be safely used in NMI interrupt context. It reflects the
-	 * context time as it was when the event was last scheduled in,
-	 * or when ctx_sched_in failed to schedule the event because we
-	 * run out of PMC.
-	 *
-	 * ctx_time already accounts for ctx->timestamp. Therefore to
-	 * compute ctx_time for a sample, simply add perf_clock().
-	 */
-	u64				shadow_ctx_time;
-
 	struct perf_event_attr		attr;
 	u16				header_size;
 	u16				id_header_size;
@@ -838,6 +826,7 @@ struct perf_event_context {
 	 */
 	u64				time;
 	u64				timestamp;
+	u64				timeoffset;
 
 	/*
 	 * These fields let us detect when two contexts have both
@@ -920,6 +909,8 @@ struct bpf_perf_event_data_kern {
 struct perf_cgroup_info {
 	u64				time;
 	u64				timestamp;
+	u64				timeoffset;
+	int				active;
 };
 
 struct perf_cgroup {
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 65eb1476ac70..57823b30c2d3 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -24,18 +24,17 @@ void psi_memstall_enter(unsigned long *flags);
 void psi_memstall_leave(unsigned long *flags);
 
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
-
-#ifdef CONFIG_CGROUPS
-int psi_cgroup_alloc(struct cgroup *cgrp);
-void psi_cgroup_free(struct cgroup *cgrp);
-void cgroup_move_task(struct task_struct *p, struct css_set *to);
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
+
+#ifdef CONFIG_CGROUPS
+int psi_cgroup_alloc(struct cgroup *cgrp);
+void psi_cgroup_free(struct cgroup *cgrp);
+void cgroup_move_task(struct task_struct *p, struct css_set *to);
 #endif
 
 #else /* CONFIG_PSI */
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 0819c82dba92..6f190002a202 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -140,9 +140,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
diff --git a/include/linux/usb/role.h b/include/linux/usb/role.h
index 031f148ab373..b5deafd91f67 100644
--- a/include/linux/usb/role.h
+++ b/include/linux/usb/role.h
@@ -91,6 +91,12 @@ fwnode_usb_role_switch_get(struct fwnode_handle *node)
 
 static inline void usb_role_switch_put(struct usb_role_switch *sw) { }
 
+static inline struct usb_role_switch *
+usb_role_switch_find_by_fwnode(const struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline struct usb_role_switch *
 usb_role_switch_register(struct device *parent,
 			 const struct usb_role_switch_desc *desc)
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688..e7ce719838b5 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -6,6 +6,8 @@
 #define RTR_SOLICITATION_INTERVAL	(4*HZ)
 #define RTR_SOLICITATION_MAX_INTERVAL	(3600*HZ)	/* 1 hour */
 
+#define MIN_VALID_LIFETIME		(2*3600)	/* 2 hours */
+
 #define TEMP_VALID_LIFETIME		(7*86400)
 #define TEMP_PREFERRED_LIFETIME		(86400)
 #define REGEN_MAX_RETRY			(3)
diff --git a/include/net/ip.h b/include/net/ip.h
index 9192444f2964..0106c6590ee7 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -520,19 +520,18 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	/* We had many attacks based on IPID, use the private
+	 * generator as much as we can.
+	 */
+	if (sk && inet_sk(sk)->inet_daddr) {
+		iph->id = htons(inet_sk(sk)->inet_id);
+		inet_sk(sk)->inet_id += segs;
+		return;
+	}
 	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
-		/* This is only to work around buggy Windows95/2000
-		 * VJ compression implementations.  If the ID field
-		 * does not change, they drop every other packet in
-		 * a TCP stream using header compression.
-		 */
-		if (sk && inet_sk(sk)->inet_daddr) {
-			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += segs;
-		} else {
-			iph->id = 0;
-		}
+		iph->id = 0;
 	} else {
+		/* Unfortunately we need the big hammer to get a suitable IPID */
 		__ip_select_ident(net, iph, segs);
 	}
 }
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 83b8070d1cc9..c85b040728d7 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -281,7 +281,7 @@ static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
 	fn = rcu_dereference(f6i->fib6_node);
 
 	if (fn) {
-		*cookie = fn->fn_sernum;
+		*cookie = READ_ONCE(fn->fn_sernum);
 		/* pairs with smp_wmb() in __fib6_update_sernum_upto_root() */
 		smp_rmb();
 		status = true;
diff --git a/include/net/route.h b/include/net/route.h
index 2e6c0e153e3a..2551f3f03b37 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -369,7 +369,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
 
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 2d04eb96d418..daaf407e9e49 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -925,18 +925,19 @@ TRACE_EVENT(rpc_socket_nospace,
 
 #define rpc_show_xprt_state(x)						\
 	__print_flags(x, "|",						\
-		{ (1UL << XPRT_LOCKED),		"LOCKED"},		\
-		{ (1UL << XPRT_CONNECTED),	"CONNECTED"},		\
-		{ (1UL << XPRT_CONNECTING),	"CONNECTING"},		\
-		{ (1UL << XPRT_CLOSE_WAIT),	"CLOSE_WAIT"},		\
-		{ (1UL << XPRT_BOUND),		"BOUND"},		\
-		{ (1UL << XPRT_BINDING),	"BINDING"},		\
-		{ (1UL << XPRT_CLOSING),	"CLOSING"},		\
-		{ (1UL << XPRT_OFFLINE),	"OFFLINE"},		\
-		{ (1UL << XPRT_REMOVE),		"REMOVE"},		\
-		{ (1UL << XPRT_CONGESTED),	"CONGESTED"},		\
-		{ (1UL << XPRT_CWND_WAIT),	"CWND_WAIT"},		\
-		{ (1UL << XPRT_WRITE_SPACE),	"WRITE_SPACE"})
+		{ BIT(XPRT_LOCKED),		"LOCKED" },		\
+		{ BIT(XPRT_CONNECTED),		"CONNECTED" },		\
+		{ BIT(XPRT_CONNECTING),		"CONNECTING" },		\
+		{ BIT(XPRT_CLOSE_WAIT),		"CLOSE_WAIT" },		\
+		{ BIT(XPRT_BOUND),		"BOUND" },		\
+		{ BIT(XPRT_BINDING),		"BINDING" },		\
+		{ BIT(XPRT_CLOSING),		"CLOSING" },		\
+		{ BIT(XPRT_OFFLINE),		"OFFLINE" },		\
+		{ BIT(XPRT_REMOVE),		"REMOVE" },		\
+		{ BIT(XPRT_CONGESTED),		"CONGESTED" },		\
+		{ BIT(XPRT_CWND_WAIT),		"CWND_WAIT" },		\
+		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" },	\
+		{ BIT(XPRT_SND_IS_COOKIE),	"SND_IS_COOKIE" })
 
 DECLARE_EVENT_CLASS(rpc_xprt_lifetime_class,
 	TP_PROTO(
@@ -1133,8 +1134,11 @@ DECLARE_EVENT_CLASS(xprt_writelock_event,
 			__entry->task_id = -1;
 			__entry->client_id = -1;
 		}
-		__entry->snd_task_id = xprt->snd_task ?
-					xprt->snd_task->tk_pid : -1;
+		if (xprt->snd_task &&
+		    !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
+			__entry->snd_task_id = xprt->snd_task->tk_pid;
+		else
+			__entry->snd_task_id = -1;
 	),
 
 	TP_printk("task:%u@%u snd_task:%u",
@@ -1178,8 +1182,12 @@ DECLARE_EVENT_CLASS(xprt_cong_event,
 			__entry->task_id = -1;
 			__entry->client_id = -1;
 		}
-		__entry->snd_task_id = xprt->snd_task ?
-					xprt->snd_task->tk_pid : -1;
+		if (xprt->snd_task &&
+		    !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
+			__entry->snd_task_id = xprt->snd_task->tk_pid;
+		else
+			__entry->snd_task_id = -1;
+
 		__entry->cong = xprt->cong;
 		__entry->cwnd = xprt->cwnd;
 		__entry->wait = test_bit(XPRT_CWND_WAIT, &xprt->state);
diff --git a/include/uapi/linux/cyclades.h b/include/uapi/linux/cyclades.h
new file mode 100644
index 000000000000..6225c5aebe06
--- /dev/null
+++ b/include/uapi/linux/cyclades.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_CYCLADES_H
+#define _UAPI_LINUX_CYCLADES_H
+
+#warning "Support for features provided by this header has been removed"
+#warning "Please consider updating your code"
+
+struct cyclades_monitor {
+	unsigned long int_count;
+	unsigned long char_count;
+	unsigned long char_max;
+	unsigned long char_last;
+};
+
+#define CYGETMON		0x435901
+#define CYGETTHRESH		0x435902
+#define CYSETTHRESH		0x435903
+#define CYGETDEFTHRESH		0x435904
+#define CYSETDEFTHRESH		0x435905
+#define CYGETTIMEOUT		0x435906
+#define CYSETTIMEOUT		0x435907
+#define CYGETDEFTIMEOUT		0x435908
+#define CYSETDEFTIMEOUT		0x435909
+#define CYSETRFLOW		0x43590a
+#define CYGETRFLOW		0x43590b
+#define CYSETRTSDTR_INV		0x43590c
+#define CYGETRTSDTR_INV		0x43590d
+#define CYZSETPOLLCYCLE		0x43590e
+#define CYZGETPOLLCYCLE		0x43590f
+#define CYGETCD1400VER		0x435910
+#define CYSETWAIT		0x435912
+#define CYGETWAIT		0x435913
+
+#endif /* _UAPI_LINUX_CYCLADES_H */
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 6e75bbee39f0..0dcaed4d3f4c 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -525,13 +525,14 @@ BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
 	   u32, size, u64, flags)
 {
 	struct pt_regs *regs;
-	long res;
+	long res = -EINVAL;
 
 	if (!try_get_task_stack(task))
 		return -EFAULT;
 
 	regs = task_pt_regs(task);
-	res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	if (regs)
+		res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
 	put_task_stack(task);
 
 	return res;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bb1a78ff1437..de8b4fa1e1fd 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
+	/* Allow only one trigger per file descriptor */
+	if (ctx->psi.trigger) {
+		cgroup_put(cgrp);
+		return -EBUSY;
+	}
+
 	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
@@ -3649,8 +3655,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&ctx->psi.trigger, new);
-
+	smp_store_release(&ctx->psi.trigger, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3689,7 +3694,7 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
 
-	psi_trigger_replace(&ctx->psi.trigger, NULL);
+	psi_trigger_destroy(ctx->psi.trigger);
 }
 
 bool cgroup_psi_enabled(void)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0fe6a65bbd58..c7581e3fb8ab 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -674,6 +674,23 @@ perf_event_set_state(struct perf_event *event, enum perf_event_state state)
 	WRITE_ONCE(event->state, state);
 }
 
+/*
+ * UP store-release, load-acquire
+ */
+
+#define __store_release(ptr, val)					\
+do {									\
+	barrier();							\
+	WRITE_ONCE(*(ptr), (val));					\
+} while (0)
+
+#define __load_acquire(ptr)						\
+({									\
+	__unqual_scalar_typeof(*(ptr)) ___p = READ_ONCE(*(ptr));	\
+	barrier();							\
+	___p;								\
+})
+
 #ifdef CONFIG_CGROUP_PERF
 
 static inline bool
@@ -719,34 +736,51 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
 	return t->time;
 }
 
-static inline void __update_cgrp_time(struct perf_cgroup *cgrp)
+static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
 {
-	struct perf_cgroup_info *info;
-	u64 now;
-
-	now = perf_clock();
+	struct perf_cgroup_info *t;
 
-	info = this_cpu_ptr(cgrp->info);
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	if (!__load_acquire(&t->active))
+		return t->time;
+	now += READ_ONCE(t->timeoffset);
+	return now;
+}
 
-	info->time += now - info->timestamp;
+static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bool adv)
+{
+	if (adv)
+		info->time += now - info->timestamp;
 	info->timestamp = now;
+	/*
+	 * see update_context_time()
+	 */
+	WRITE_ONCE(info->timeoffset, info->time - info->timestamp);
 }
 
-static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
+static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
 {
 	struct perf_cgroup *cgrp = cpuctx->cgrp;
 	struct cgroup_subsys_state *css;
+	struct perf_cgroup_info *info;
 
 	if (cgrp) {
+		u64 now = perf_clock();
+
 		for (css = &cgrp->css; css; css = css->parent) {
 			cgrp = container_of(css, struct perf_cgroup, css);
-			__update_cgrp_time(cgrp);
+			info = this_cpu_ptr(cgrp->info);
+
+			__update_cgrp_time(info, now, true);
+			if (final)
+				__store_release(&info->active, 0);
 		}
 	}
 }
 
 static inline void update_cgrp_time_from_event(struct perf_event *event)
 {
+	struct perf_cgroup_info *info;
 	struct perf_cgroup *cgrp;
 
 	/*
@@ -760,8 +794,10 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
 	/*
 	 * Do not update time when cgroup is not active
 	 */
-	if (cgroup_is_descendant(cgrp->css.cgroup, event->cgrp->css.cgroup))
-		__update_cgrp_time(event->cgrp);
+	if (cgroup_is_descendant(cgrp->css.cgroup, event->cgrp->css.cgroup)) {
+		info = this_cpu_ptr(event->cgrp->info);
+		__update_cgrp_time(info, perf_clock(), true);
+	}
 }
 
 static inline void
@@ -785,7 +821,8 @@ perf_cgroup_set_timestamp(struct task_struct *task,
 	for (css = &cgrp->css; css; css = css->parent) {
 		cgrp = container_of(css, struct perf_cgroup, css);
 		info = this_cpu_ptr(cgrp->info);
-		info->timestamp = ctx->timestamp;
+		__update_cgrp_time(info, ctx->timestamp, false);
+		__store_release(&info->active, 1);
 	}
 }
 
@@ -981,14 +1018,6 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	return ret;
 }
 
-static inline void
-perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
-{
-	struct perf_cgroup_info *t;
-	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	event->shadow_ctx_time = now - t->timestamp;
-}
-
 static inline void
 perf_cgroup_event_enable(struct perf_event *event, struct perf_event_context *ctx)
 {
@@ -1066,7 +1095,8 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
 {
 }
 
-static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
+static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx,
+						bool final)
 {
 }
 
@@ -1098,12 +1128,12 @@ perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
 {
 }
 
-static inline void
-perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+static inline u64 perf_cgroup_event_time(struct perf_event *event)
 {
+	return 0;
 }
 
-static inline u64 perf_cgroup_event_time(struct perf_event *event)
+static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
 {
 	return 0;
 }
@@ -1525,22 +1555,59 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 /*
  * Update the record of the current time in a context.
  */
-static void update_context_time(struct perf_event_context *ctx)
+static void __update_context_time(struct perf_event_context *ctx, bool adv)
 {
 	u64 now = perf_clock();
 
-	ctx->time += now - ctx->timestamp;
+	if (adv)
+		ctx->time += now - ctx->timestamp;
 	ctx->timestamp = now;
+
+	/*
+	 * The above: time' = time + (now - timestamp), can be re-arranged
+	 * into: time` = now + (time - timestamp), which gives a single value
+	 * offset to compute future time without locks on.
+	 *
+	 * See perf_event_time_now(), which can be used from NMI context where
+	 * it's (obviously) not possible to acquire ctx->lock in order to read
+	 * both the above values in a consistent manner.
+	 */
+	WRITE_ONCE(ctx->timeoffset, ctx->time - ctx->timestamp);
+}
+
+static void update_context_time(struct perf_event_context *ctx)
+{
+	__update_context_time(ctx, true);
 }
 
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	if (unlikely(!ctx))
+		return 0;
+
 	if (is_cgroup_event(event))
 		return perf_cgroup_event_time(event);
 
-	return ctx ? ctx->time : 0;
+	return ctx->time;
+}
+
+static u64 perf_event_time_now(struct perf_event *event, u64 now)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	if (unlikely(!ctx))
+		return 0;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_time_now(event, now);
+
+	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
+		return ctx->time;
+
+	now += READ_ONCE(ctx->timeoffset);
+	return now;
 }
 
 static enum event_type_t get_event_type(struct perf_event *event)
@@ -2346,7 +2413,7 @@ __perf_remove_from_context(struct perf_event *event,
 
 	if (ctx->is_active & EVENT_TIME) {
 		update_context_time(ctx);
-		update_cgrp_time_from_cpuctx(cpuctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
 	}
 
 	event_sched_out(event, cpuctx, ctx);
@@ -2357,6 +2424,9 @@ __perf_remove_from_context(struct perf_event *event,
 	list_del_event(event, ctx);
 
 	if (!ctx->nr_events && ctx->is_active) {
+		if (ctx == &cpuctx->ctx)
+			update_cgrp_time_from_cpuctx(cpuctx, true);
+
 		ctx->is_active = 0;
 		ctx->rotate_necessary = 0;
 		if (ctx->task) {
@@ -2388,7 +2458,11 @@ static void perf_remove_from_context(struct perf_event *event, unsigned long fla
 	 * event_function_call() user.
 	 */
 	raw_spin_lock_irq(&ctx->lock);
-	if (!ctx->is_active) {
+	/*
+	 * Cgroup events are per-cpu events, and must IPI because of
+	 * cgrp_cpuctx_list.
+	 */
+	if (!ctx->is_active && !is_cgroup_event(event)) {
 		__perf_remove_from_context(event, __get_cpu_context(ctx),
 					   ctx, (void *)flags);
 		raw_spin_unlock_irq(&ctx->lock);
@@ -2478,40 +2552,6 @@ void perf_event_disable_inatomic(struct perf_event *event)
 	irq_work_queue(&event->pending);
 }
 
-static void perf_set_shadow_time(struct perf_event *event,
-				 struct perf_event_context *ctx)
-{
-	/*
-	 * use the correct time source for the time snapshot
-	 *
-	 * We could get by without this by leveraging the
-	 * fact that to get to this function, the caller
-	 * has most likely already called update_context_time()
-	 * and update_cgrp_time_xx() and thus both timestamp
-	 * are identical (or very close). Given that tstamp is,
-	 * already adjusted for cgroup, we could say that:
-	 *    tstamp - ctx->timestamp
-	 * is equivalent to
-	 *    tstamp - cgrp->timestamp.
-	 *
-	 * Then, in perf_output_read(), the calculation would
-	 * work with no changes because:
-	 * - event is guaranteed scheduled in
-	 * - no scheduled out in between
-	 * - thus the timestamp would be the same
-	 *
-	 * But this is a bit hairy.
-	 *
-	 * So instead, we have an explicit cgroup call to remain
-	 * within the time source all along. We believe it
-	 * is cleaner and simpler to understand.
-	 */
-	if (is_cgroup_event(event))
-		perf_cgroup_set_shadow_time(event, event->tstamp);
-	else
-		event->shadow_ctx_time = event->tstamp - ctx->timestamp;
-}
-
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
@@ -2552,8 +2592,6 @@ event_sched_in(struct perf_event *event,
 
 	perf_pmu_disable(event->pmu);
 
-	perf_set_shadow_time(event, ctx);
-
 	perf_log_itrace_start(event);
 
 	if (event->pmu->add(event, PERF_EF_START)) {
@@ -2857,11 +2895,14 @@ perf_install_in_context(struct perf_event_context *ctx,
 	 * perf_event_attr::disabled events will not run and can be initialized
 	 * without IPI. Except when this is the first event for the context, in
 	 * that case we need the magic of the IPI to set ctx->is_active.
+	 * Similarly, cgroup events for the context also needs the IPI to
+	 * manipulate the cgrp_cpuctx_list.
 	 *
 	 * The IOC_ENABLE that is sure to follow the creation of a disabled
 	 * event will issue the IPI and reprogram the hardware.
 	 */
-	if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF && ctx->nr_events) {
+	if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF &&
+	    ctx->nr_events && !is_cgroup_event(event)) {
 		raw_spin_lock_irq(&ctx->lock);
 		if (ctx->task == TASK_TOMBSTONE) {
 			raw_spin_unlock_irq(&ctx->lock);
@@ -3247,16 +3288,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		return;
 	}
 
-	ctx->is_active &= ~event_type;
-	if (!(ctx->is_active & EVENT_ALL))
-		ctx->is_active = 0;
-
-	if (ctx->task) {
-		WARN_ON_ONCE(cpuctx->task_ctx != ctx);
-		if (!ctx->is_active)
-			cpuctx->task_ctx = NULL;
-	}
-
 	/*
 	 * Always update time if it was set; not only when it changes.
 	 * Otherwise we can 'forget' to update time for any but the last
@@ -3270,7 +3301,22 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (is_active & EVENT_TIME) {
 		/* update (and stop) ctx time */
 		update_context_time(ctx);
-		update_cgrp_time_from_cpuctx(cpuctx);
+		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
+		/*
+		 * CPU-release for the below ->is_active store,
+		 * see __load_acquire() in perf_event_time_now()
+		 */
+		barrier();
+	}
+
+	ctx->is_active &= ~event_type;
+	if (!(ctx->is_active & EVENT_ALL))
+		ctx->is_active = 0;
+
+	if (ctx->task) {
+		WARN_ON_ONCE(cpuctx->task_ctx != ctx);
+		if (!ctx->is_active)
+			cpuctx->task_ctx = NULL;
 	}
 
 	is_active ^= ctx->is_active; /* changed bits */
@@ -3707,13 +3753,19 @@ static noinline int visit_groups_merge(struct perf_cpu_context *cpuctx,
 	return 0;
 }
 
+/*
+ * Because the userpage is strictly per-event (there is no concept of context,
+ * so there cannot be a context indirection), every userpage must be updated
+ * when context time starts :-(
+ *
+ * IOW, we must not miss EVENT_TIME edges.
+ */
 static inline bool event_update_userpage(struct perf_event *event)
 {
 	if (likely(!atomic_read(&event->mmap_count)))
 		return false;
 
 	perf_event_update_time(event);
-	perf_set_shadow_time(event, event->ctx);
 	perf_event_update_userpage(event);
 
 	return true;
@@ -3797,13 +3849,23 @@ ctx_sched_in(struct perf_event_context *ctx,
 	     struct task_struct *task)
 {
 	int is_active = ctx->is_active;
-	u64 now;
 
 	lockdep_assert_held(&ctx->lock);
 
 	if (likely(!ctx->nr_events))
 		return;
 
+	if (is_active ^ EVENT_TIME) {
+		/* start ctx time */
+		__update_context_time(ctx, false);
+		perf_cgroup_set_timestamp(task, ctx);
+		/*
+		 * CPU-release for the below ->is_active store,
+		 * see __load_acquire() in perf_event_time_now()
+		 */
+		barrier();
+	}
+
 	ctx->is_active |= (event_type | EVENT_TIME);
 	if (ctx->task) {
 		if (!is_active)
@@ -3814,13 +3876,6 @@ ctx_sched_in(struct perf_event_context *ctx,
 
 	is_active ^= ctx->is_active; /* changed bits */
 
-	if (is_active & EVENT_TIME) {
-		/* start ctx time */
-		now = perf_clock();
-		ctx->timestamp = now;
-		perf_cgroup_set_timestamp(task, ctx);
-	}
-
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
@@ -4414,6 +4469,18 @@ static inline u64 perf_event_count(struct perf_event *event)
 	return local64_read(&event->count) + atomic64_read(&event->child_count);
 }
 
+static void calc_timer_values(struct perf_event *event,
+				u64 *now,
+				u64 *enabled,
+				u64 *running)
+{
+	u64 ctx_time;
+
+	*now = perf_clock();
+	ctx_time = perf_event_time_now(event, *now);
+	__perf_update_times(event, ctx_time, enabled, running);
+}
+
 /*
  * NMI-safe method to read a local event, that is an event that
  * is:
@@ -4473,10 +4540,9 @@ int perf_event_read_local(struct perf_event *event, u64 *value,
 
 	*value = local64_read(&event->count);
 	if (enabled || running) {
-		u64 now = event->shadow_ctx_time + perf_clock();
-		u64 __enabled, __running;
+		u64 __enabled, __running, __now;;
 
-		__perf_update_times(event, now, &__enabled, &__running);
+		calc_timer_values(event, &__now, &__enabled, &__running);
 		if (enabled)
 			*enabled = __enabled;
 		if (running)
@@ -5798,18 +5864,6 @@ static int perf_event_index(struct perf_event *event)
 	return event->pmu->event_idx(event);
 }
 
-static void calc_timer_values(struct perf_event *event,
-				u64 *now,
-				u64 *enabled,
-				u64 *running)
-{
-	u64 ctx_time;
-
-	*now = perf_clock();
-	ctx_time = event->shadow_ctx_time + *now;
-	__perf_update_times(event, ctx_time, enabled, running);
-}
-
 static void perf_event_init_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
@@ -6349,7 +6403,6 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ring_buffer_attach(event, rb);
 
 		perf_event_update_time(event);
-		perf_set_shadow_time(event, event->ctx);
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
 	} else {
diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index 105df4dfc783..52571dcad768 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -39,23 +39,20 @@ ssize_t pm_show_wakelocks(char *buf, bool show_active)
 {
 	struct rb_node *node;
 	struct wakelock *wl;
-	char *str = buf;
-	char *end = buf + PAGE_SIZE;
+	int len = 0;
 
 	mutex_lock(&wakelocks_lock);
 
 	for (node = rb_first(&wakelocks_tree); node; node = rb_next(node)) {
 		wl = rb_entry(node, struct wakelock, node);
 		if (wl->ws->active == show_active)
-			str += scnprintf(str, end - str, "%s ", wl->name);
+			len += sysfs_emit_at(buf, len, "%s ", wl->name);
 	}
-	if (str > buf)
-		str--;
 
-	str += scnprintf(str, end - str, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	mutex_unlock(&wakelocks_lock);
-	return (str - buf);
+	return len;
 }
 
 #if CONFIG_PM_WAKELOCKS_LIMIT > 0
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d41f966f5866..6420580f2730 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3422,7 +3422,6 @@ void set_task_rq_fair(struct sched_entity *se,
 	se->avg.last_update_time = n_last_update_time;
 }
 
-
 /*
  * When on migration a sched_entity joins/leaves the PELT hierarchy, we need to
  * propagate its contribution. The key to this propagation is the invariant
@@ -3490,7 +3489,6 @@ void set_task_rq_fair(struct sched_entity *se,
  * XXX: only do this for the part of runnable > running ?
  *
  */
-
 static inline void
 update_tg_cfs_util(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
@@ -3722,7 +3720,19 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 
 		r = removed_util;
 		sub_positive(&sa->util_avg, r);
-		sa->util_sum = sa->util_avg * divider;
+		sub_positive(&sa->util_sum, r * divider);
+		/*
+		 * Because of rounding, se->util_sum might ends up being +1 more than
+		 * cfs->util_sum. Although this is not a problem by itself, detaching
+		 * a lot of tasks with the rounding problem between 2 updates of
+		 * util_avg (~1ms) can make cfs->util_sum becoming null whereas
+		 * cfs_util_avg is not.
+		 * Check that util_sum is still above its lower bound for the new
+		 * util_avg. Given that period_contrib might have moved since the last
+		 * sync, we are only sure that util_sum must be above or equal to
+		 *    util_avg * minimum possible divider
+		 */
+		sa->util_sum = max_t(u32, sa->util_sum, sa->util_avg * PELT_MIN_DIVIDER);
 
 		r = removed_runnable;
 		sub_positive(&sa->runnable_avg, r);
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index b5add64d9698..3d2825408e3a 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -147,11 +147,11 @@
 #endif
 
 #ifdef CONFIG_RSEQ
-#define MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK		\
+#define MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK		\
 	(MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ			\
-	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ)
 #else
-#define MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK	0
+#define MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK	0
 #endif
 
 #define MEMBARRIER_CMD_BITMASK						\
@@ -159,7 +159,8 @@
 	| MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED			\
 	| MEMBARRIER_CMD_PRIVATE_EXPEDITED				\
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED			\
-	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK		\
+	| MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
 
 static void ipi_mb(void *info)
 {
diff --git a/kernel/sched/pelt.h b/kernel/sched/pelt.h
index e06071bf3472..c336f5f481bc 100644
--- a/kernel/sched/pelt.h
+++ b/kernel/sched/pelt.h
@@ -37,9 +37,11 @@ update_irq_load_avg(struct rq *rq, u64 running)
 }
 #endif
 
+#define PELT_MIN_DIVIDER	(LOAD_AVG_MAX - 1024)
+
 static inline u32 get_pelt_divider(struct sched_avg *avg)
 {
-	return LOAD_AVG_MAX - 1024 + avg->period_contrib;
+	return PELT_MIN_DIVIDER + avg->period_contrib;
 }
 
 static inline void cfs_se_util_change(struct sched_avg *avg)
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 69b19d3af690..422f3b0445cf 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1082,44 +1082,6 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 	return 0;
 }
 
-static int psi_io_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_IO);
-}
-
-static int psi_memory_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_MEM);
-}
-
-static int psi_cpu_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_CPU);
-}
-
-static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
-{
-	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
-
-	return single_open(file, psi_show, NULL);
-}
-
-static int psi_io_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_io_show);
-}
-
-static int psi_memory_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_memory_show);
-}
-
-static int psi_cpu_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_cpu_show);
-}
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res)
 {
@@ -1162,7 +1124,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1191,15 +1152,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	return t;
 }
 
-static void psi_trigger_destroy(struct kref *ref)
+void psi_trigger_destroy(struct psi_trigger *t)
 {
-	struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
-	struct psi_group *group = t->group;
+	struct psi_group *group;
 	struct task_struct *task_to_destroy = NULL;
 
-	if (static_branch_likely(&psi_disabled))
+	/*
+	 * We do not check psi_disabled since it might have been disabled after
+	 * the trigger got created.
+	 */
+	if (!t)
 		return;
 
+	group = t->group;
 	/*
 	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
 	 * from under a polling process.
@@ -1235,9 +1200,9 @@ static void psi_trigger_destroy(struct kref *ref)
 	mutex_unlock(&group->trigger_lock);
 
 	/*
-	 * Wait for both *trigger_ptr from psi_trigger_replace and
-	 * poll_task RCUs to complete their read-side critical sections
-	 * before destroying the trigger and optionally the poll_task
+	 * Wait for psi_schedule_poll_work RCU to complete its read-side
+	 * critical section before destroying the trigger and optionally the
+	 * poll_task.
 	 */
 	synchronize_rcu();
 	/*
@@ -1254,18 +1219,6 @@ static void psi_trigger_destroy(struct kref *ref)
 	kfree(t);
 }
 
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *new)
-{
-	struct psi_trigger *old = *trigger_ptr;
-
-	if (static_branch_likely(&psi_disabled))
-		return;
-
-	rcu_assign_pointer(*trigger_ptr, new);
-	if (old)
-		kref_put(&old->refcount, psi_trigger_destroy);
-}
-
 __poll_t psi_trigger_poll(void **trigger_ptr,
 				struct file *file, poll_table *wait)
 {
@@ -1275,27 +1228,57 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (static_branch_likely(&psi_disabled))
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	rcu_read_lock();
-
-	t = rcu_dereference(*(void __rcu __force **)trigger_ptr);
-	if (!t) {
-		rcu_read_unlock();
+	t = smp_load_acquire(trigger_ptr);
+	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
-	}
-	kref_get(&t->refcount);
-
-	rcu_read_unlock();
 
 	poll_wait(file, &t->event_wait, wait);
 
 	if (cmpxchg(&t->event, 1, 0) == 1)
 		ret |= EPOLLPRI;
 
-	kref_put(&t->refcount, psi_trigger_destroy);
-
 	return ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int psi_io_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_IO);
+}
+
+static int psi_memory_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_MEM);
+}
+
+static int psi_cpu_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_CPU);
+}
+
+static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
+{
+	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+
+	return single_open(file, psi_show, NULL);
+}
+
+static int psi_io_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_io_show);
+}
+
+static int psi_memory_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_memory_show);
+}
+
+static int psi_cpu_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_cpu_show);
+}
+
 static ssize_t psi_write(struct file *file, const char __user *user_buf,
 			 size_t nbytes, enum psi_res res)
 {
@@ -1316,14 +1299,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
 	buf[buf_size - 1] = '\0';
 
-	new = psi_trigger_create(&psi_system, buf, nbytes, res);
-	if (IS_ERR(new))
-		return PTR_ERR(new);
-
 	seq = file->private_data;
+
 	/* Take seq->lock to protect seq->private from concurrent writes */
 	mutex_lock(&seq->lock);
-	psi_trigger_replace(&seq->private, new);
+
+	/* Allow only one trigger per file descriptor */
+	if (seq->private) {
+		mutex_unlock(&seq->lock);
+		return -EBUSY;
+	}
+
+	new = psi_trigger_create(&psi_system, buf, nbytes, res);
+	if (IS_ERR(new)) {
+		mutex_unlock(&seq->lock);
+		return PTR_ERR(new);
+	}
+
+	smp_store_release(&seq->private, new);
 	mutex_unlock(&seq->lock);
 
 	return nbytes;
@@ -1358,7 +1351,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
@@ -1400,3 +1393,5 @@ static int __init psi_proc_init(void)
 	return 0;
 }
 module_init(psi_proc_init);
+
+#endif /* CONFIG_PROC_FS */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ce05ba041288..51a87a67e2ab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7749,7 +7749,8 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr)
 		err = kzalloc(sizeof(*err), GFP_KERNEL);
 		if (!err)
 			err = ERR_PTR(-ENOMEM);
-		tr->n_err_log_entries++;
+		else
+			tr->n_err_log_entries++;
 
 		return err;
 	}
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 12a735bd90a5..83efce3a87ca 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3581,6 +3581,7 @@ static int trace_action_create(struct hist_trigger_data *hist_data,
 
 			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
 			if (WARN_ON(var_ref_idx < 0)) {
+				kfree(p);
 				ret = var_ref_idx;
 				goto err;
 			}
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 16feb710ee63..804f64799fc1 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -184,6 +184,7 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 			kfree(new);
 		} else {
 			hlist_add_head(&new->node, hashent);
+			get_user_ns(new->ns);
 			spin_unlock_irq(&ucounts_lock);
 			return new;
 		}
@@ -204,6 +205,7 @@ void put_ucounts(struct ucounts *ucounts)
 	if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
 		hlist_del_init(&ucounts->node);
 		spin_unlock_irqrestore(&ucounts_lock, flags);
+		put_user_ns(ucounts->ns);
 		kfree(ucounts);
 	}
 }
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20e36126bbda..868a22df3285 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5782,6 +5782,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
+		if (ptr > (void *)skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data.");
+			break;
+		}
+
 		if (ev->length <= HCI_MAX_AD_LENGTH &&
 		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
@@ -5793,11 +5798,6 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 19f65ab91a02..10e63ea6a13e 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -560,10 +560,10 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		    !br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 			if (*state == BR_STATE_FORWARDING) {
 				*state = br_vlan_get_pvid_state(vg);
-				return br_vlan_state_allowed(*state, true);
-			} else {
-				return true;
+				if (!br_vlan_state_allowed(*state, true))
+					goto drop;
 			}
+			return true;
 		}
 	}
 	v = br_vlan_find(vg, *vid);
@@ -2105,7 +2105,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			goto out_err;
 		}
 		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
-		if (err && err != -EMSGSIZE)
+		/* if the dump completed without an error we return 0 here */
+		if (err != -EMSGSIZE)
 			goto out_err;
 	} else {
 		for_each_netdev_rcu(net, dev) {
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..88cc0ad7d386 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -190,12 +190,23 @@ static const struct seq_operations softnet_seq_ops = {
 	.show  = softnet_seq_show,
 };
 
-static void *ptype_get_idx(loff_t pos)
+static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
 {
+	struct list_head *ptype_list = NULL;
 	struct packet_type *pt = NULL;
+	struct net_device *dev;
 	loff_t i = 0;
 	int t;
 
+	for_each_netdev_rcu(seq_file_net(seq), dev) {
+		ptype_list = &dev->ptype_all;
+		list_for_each_entry_rcu(pt, ptype_list, list) {
+			if (i == pos)
+				return pt;
+			++i;
+		}
+	}
+
 	list_for_each_entry_rcu(pt, &ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -216,22 +227,40 @@ static void *ptype_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return *pos ? ptype_get_idx(*pos - 1) : SEQ_START_TOKEN;
+	return *pos ? ptype_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
 	int hash;
 
 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return ptype_get_idx(0);
+		return ptype_get_idx(seq, 0);
 
 	pt = v;
 	nxt = pt->list.next;
+	if (pt->dev) {
+		if (nxt != &pt->dev->ptype_all)
+			goto found;
+
+		dev = pt->dev;
+		for_each_netdev_continue_rcu(seq_file_net(seq), dev) {
+			if (!list_empty(&dev->ptype_all)) {
+				nxt = dev->ptype_all.next;
+				goto found;
+			}
+		}
+
+		nxt = ptype_all.next;
+		goto ptype_all;
+	}
+
 	if (pt->type == htons(ETH_P_ALL)) {
+ptype_all:
 		if (nxt != &ptype_all)
 			goto found;
 		hash = 0;
@@ -260,7 +289,8 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Type Device      Function\n");
-	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
+	else if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
+		 (!pt->dev || net_eq(dev_net(pt->dev), seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b83..a4d2eb691cbc 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,12 +162,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	if (ip_dont_fragment(sk, &rt->dst)) {
+	/* Do not bother generating IPID for small packets (eg SYNACK) */
+	if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
 		iph->frag_off = htons(IP_DF);
 		iph->id = 0;
 	} else {
 		iph->frag_off = 0;
-		__ip_select_ident(net, iph, 1);
+		/* TCP packets here are SYNACK with fat IPv4/TCP options.
+		 * Avoid using the hashed IP ident generator.
+		 */
+		if (sk->sk_protocol == IPPROTO_TCP)
+			iph->id = (__force __be16)prandom_u32();
+		else
+			__ip_select_ident(net, iph, 1);
 	}
 
 	if (opt && opt->opt.optlen) {
@@ -826,15 +833,24 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
 
-		if (iter.frag)
-			ip_options_fragment(iter.frag);
-
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
 			if (iter.frag) {
+				bool first_frag = (iter.offset == 0);
+
 				IPCB(iter.frag)->flags = IPCB(skb)->flags;
 				ip_fraglist_prepare(skb, &iter);
+				if (first_frag && IPCB(skb)->opt.optlen) {
+					/* ipcb->opt is not populated for frags
+					 * coming from __ip_make_skb(),
+					 * ip_options_fragment() needs optlen
+					 */
+					IPCB(iter.frag)->opt.optlen =
+						IPCB(skb)->opt.optlen;
+					ip_options_fragment(iter.frag);
+					ip_send_check(iter.iph);
+				}
 			}
 
 			skb->tstamp = tstamp;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1e44a43acfe2..086822cb1cc9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -220,7 +220,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bb446e60cf58..b8689052079c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -721,6 +721,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	int ret = -EINVAL;
 	int chk_addr_ret;
 
+	lock_sock(sk);
 	if (sk->sk_state != TCP_CLOSE || addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
@@ -740,7 +741,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
 	ret = 0;
-out:	return ret;
+out:
+	release_sock(sk);
+	return ret;
 }
 
 /*
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 846037e73723..bf1386542634 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2587,7 +2587,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 __u32 valid_lft, u32 prefered_lft)
 {
 	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
-	int create = 0;
+	int create = 0, update_lft = 0;
 
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
@@ -2631,19 +2631,32 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 		unsigned long now;
 		u32 stored_lft;
 
-		/* Update lifetime (RFC4862 5.5.3 e)
-		 * We deviate from RFC4862 by honoring all Valid Lifetimes to
-		 * improve the reaction of SLAAC to renumbering events
-		 * (draft-gont-6man-slaac-renum-06, Section 4.2)
-		 */
+		/* update lifetime (RFC2462 5.5.3 e) */
 		spin_lock_bh(&ifp->lock);
 		now = jiffies;
 		if (ifp->valid_lft > (now - ifp->tstamp) / HZ)
 			stored_lft = ifp->valid_lft - (now - ifp->tstamp) / HZ;
 		else
 			stored_lft = 0;
-
 		if (!create && stored_lft) {
+			const u32 minimum_lft = min_t(u32,
+				stored_lft, MIN_VALID_LIFETIME);
+			valid_lft = max(valid_lft, minimum_lft);
+
+			/* RFC4862 Section 5.5.3e:
+			 * "Note that the preferred lifetime of the
+			 *  corresponding address is always reset to
+			 *  the Preferred Lifetime in the received
+			 *  Prefix Information option, regardless of
+			 *  whether the valid lifetime is also reset or
+			 *  ignored."
+			 *
+			 * So we should always update prefered_lft here.
+			 */
+			update_lft = 1;
+		}
+
+		if (update_lft) {
 			ifp->valid_lft = valid_lft;
 			ifp->prefered_lft = prefered_lft;
 			ifp->tstamp = now;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0371d2c14145..a506e57c4032 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -111,7 +111,7 @@ void fib6_update_sernum(struct net *net, struct fib6_info *f6i)
 	fn = rcu_dereference_protected(f6i->fib6_node,
 			lockdep_is_held(&f6i->fib6_table->tb6_lock));
 	if (fn)
-		fn->fn_sernum = fib6_new_sernum(net);
+		WRITE_ONCE(fn->fn_sernum, fib6_new_sernum(net));
 }
 
 /*
@@ -589,12 +589,13 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 		spin_unlock_bh(&table->tb6_lock);
 		if (res > 0) {
 			cb->args[4] = 1;
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = READ_ONCE(w->root->fn_sernum);
 		}
 	} else {
-		if (cb->args[5] != w->root->fn_sernum) {
+		int sernum = READ_ONCE(w->root->fn_sernum);
+		if (cb->args[5] != sernum) {
 			/* Begin at the root if the tree changed */
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = sernum;
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
@@ -1344,7 +1345,7 @@ static void __fib6_update_sernum_upto_root(struct fib6_info *rt,
 	/* paired with smp_rmb() in fib6_get_cookie_safe() */
 	smp_wmb();
 	while (fn) {
-		fn->fn_sernum = sernum;
+		WRITE_ONCE(fn->fn_sernum, sernum);
 		fn = rcu_dereference_protected(fn->parent,
 				lockdep_is_held(&rt->fib6_table->tb6_lock));
 	}
@@ -2173,8 +2174,8 @@ static int fib6_clean_node(struct fib6_walker *w)
 	};
 
 	if (c->sernum != FIB6_NO_SERNUM_CHANGE &&
-	    w->node->fn_sernum != c->sernum)
-		w->node->fn_sernum = c->sernum;
+	    READ_ONCE(w->node->fn_sernum) != c->sernum)
+		WRITE_ONCE(w->node->fn_sernum, c->sernum);
 
 	if (!c->func) {
 		WARN_ON_ONCE(c->sernum == FIB6_NO_SERNUM_CHANGE);
@@ -2542,7 +2543,7 @@ static void ipv6_route_seq_setup_walk(struct ipv6_route_iter *iter,
 	iter->w.state = FWS_INIT;
 	iter->w.node = iter->w.root;
 	iter->w.args = iter;
-	iter->sernum = iter->w.root->fn_sernum;
+	iter->sernum = READ_ONCE(iter->w.root->fn_sernum);
 	INIT_LIST_HEAD(&iter->w.lh);
 	fib6_walker_link(net, &iter->w);
 }
@@ -2570,8 +2571,10 @@ static struct fib6_table *ipv6_route_seq_next_table(struct fib6_table *tbl,
 
 static void ipv6_route_check_sernum(struct ipv6_route_iter *iter)
 {
-	if (iter->sernum != iter->w.root->fn_sernum) {
-		iter->sernum = iter->w.root->fn_sernum;
+	int sernum = READ_ONCE(iter->w.root->fn_sernum);
+
+	if (iter->sernum != sernum) {
+		iter->sernum = sernum;
 		iter->w.state = FWS_INIT;
 		iter->w.node = iter->w.root;
 		WARN_ON(iter->w.skip);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 20a67efda47f..fa8da8ff35b4 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1036,14 +1036,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 
 		if (unlikely(!ipv6_chk_addr_and_flags(net, laddr, ldev, false,
 						      0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Local address not yet configured!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Local address not yet configured!\n",
+					    p->name);
 		else if (!(p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE) &&
 			 !ipv6_addr_is_multicast(raddr) &&
 			 unlikely(ipv6_chk_addr_and_flags(net, raddr, ldev,
 							  true, 0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Routing loop! Remote address found on this node!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Routing loop! Remote address found on this node!\n",
+					    p->name);
 		else
 			ret = 1;
 		rcu_read_unlock();
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0632382a5427..3c5bb4969220 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2802,7 +2802,7 @@ static void ip6_link_failure(struct sk_buff *skb)
 			if (from) {
 				fn = rcu_dereference(from->fib6_node);
 				if (fn && (rt->rt6i_flags & RTF_DEFAULT))
-					fn->fn_sernum = -1;
+					WRITE_ONCE(fn->fn_sernum, -1);
 			}
 		}
 		rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4712a90a1820..7f7997460764 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1922,15 +1922,17 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put(&ct->ct_general);
 		skb->_nfct = 0;
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
-			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 		/* Special case: TCP tracker reports an attempt to reopen a
 		 * closed/aborted connection. We have to go back and create a
 		 * fresh conntrack.
 		 */
 		if (ret == -NF_REPEAT)
 			goto repeat;
+
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
+		if (ret == -NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+
 		ret = -ret;
 		goto out;
 	}
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1bc7ef49e148..1a138e8d32d6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1738,6 +1738,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
@@ -3323,6 +3324,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.af_packet_net = sock_net(sk);
 
 	if (proto) {
 		po->prot_hook.type = proto;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 6be2672a65ea..df864e692267 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -157,7 +157,7 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
 	struct sk_buff *skb;
-	unsigned long resend_at, rto_j;
+	unsigned long resend_at;
 	rxrpc_seq_t cursor, seq, top;
 	ktime_t now, max_age, oldest, ack_ts;
 	int ix;
@@ -165,10 +165,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
-	rto_j = call->peer->rto_j;
-
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(rto_j));
+	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
@@ -213,7 +211,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	}
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
-	resend_at += jiffies + rto_j;
+	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer, retrans);
 	WRITE_ONCE(call->resend_at, resend_at);
 
 	if (unacked)
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 10f2bf2e9068..a45c83f22236 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -468,7 +468,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
-				ack_lost_at = rxrpc_get_rto_backoff(call->peer, retrans);
+				ack_lost_at = rxrpc_get_rto_backoff(call->peer, false);
 				ack_lost_at += nowj;
 				WRITE_ONCE(call->ack_lost_at, ack_lost_at);
 				rxrpc_reduce_call_timer(call, ack_lost_at, nowj,
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5067a6e5d4fd..5cbc32fee867 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1803,6 +1803,26 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	if (!hopt->rate.rate || !hopt->ceil.rate)
 		goto failure;
 
+	if (q->offload) {
+		/* Options not supported by the offload. */
+		if (hopt->rate.overhead || hopt->ceil.overhead) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
+			goto failure;
+		}
+		if (hopt->rate.mpu || hopt->ceil.mpu) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
+			goto failure;
+		}
+		if (hopt->quantum) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
+			goto failure;
+		}
+		if (hopt->prio) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
+			goto failure;
+		}
+	}
+
 	/* Keeping backward compatible with rate_table based iproute2 tc */
 	if (hopt->rate.linklayer == TC_LINKLAYER_UNAWARE)
 		qdisc_put_rtab(qdisc_get_rtab(&hopt->rate, tb[TCA_HTB_RTAB],
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 07ff719f3907..34608369b426 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -548,12 +548,17 @@ static void smc_stat_fallback(struct smc_sock *smc)
 	mutex_unlock(&net->smc.mutex_fback_rsn);
 }
 
-static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
+static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
-	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
+	wait_queue_head_t *clc_wait;
 	unsigned long flags;
 
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -567,18 +572,30 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * smc socket->wq, which should be removed
 		 * to clcsocket->wq during the fallback.
 		 */
+		clc_wait = sk_sleep(smc->clcsock->sk);
 		spin_lock_irqsave(&smc_wait->lock, flags);
 		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
 		list_splice_init(&smc_wait->head, &clc_wait->head);
 		spin_unlock(&clc_wait->lock);
 		spin_unlock_irqrestore(&smc_wait->lock, flags);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
+	return 0;
 }
 
 /* fall back during connect */
 static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 {
-	smc_switch_to_fallback(smc, reason_code);
+	struct net *net = sock_net(&smc->sk);
+	int rc = 0;
+
+	rc = smc_switch_to_fallback(smc, reason_code);
+	if (rc) { /* fallback fails */
+		this_cpu_inc(net->smc.smc_stats->clnt_hshake_err_cnt);
+		if (smc->sk.sk_state == SMC_INIT)
+			sock_put(&smc->sk); /* passive closing */
+		return rc;
+	}
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock = 0;
 	if (smc->sk.sk_state == SMC_INIT)
@@ -1384,11 +1401,12 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 {
 	/* RDMA setup failed, switch back to TCP */
 	smc_conn_abort(new_smc, local_first);
-	if (reason_code < 0) { /* error, no fallback possible */
+	if (reason_code < 0 ||
+	    smc_switch_to_fallback(new_smc, reason_code)) {
+		/* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
 	}
-	smc_switch_to_fallback(new_smc, reason_code);
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
 		if (smc_clc_send_decline(new_smc, reason_code, version) < 0) {
 			smc_listen_out_err(new_smc);
@@ -1761,8 +1779,11 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* check if peer is smc capable */
 	if (!tcp_sk(newclcsock->sk)->syn_smc) {
-		smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
-		smc_listen_out_connected(new_smc);
+		rc = smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
+		if (rc)
+			smc_listen_out_err(new_smc);
+		else
+			smc_listen_out_connected(new_smc);
 		return;
 	}
 
@@ -2048,7 +2069,9 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (msg->msg_flags & MSG_FASTOPEN) {
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			if (rc)
+				goto out;
 		} else {
 			rc = -EINVAL;
 			goto out;
@@ -2241,6 +2264,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	/* generic setsockopts reaching us here always apply to the
 	 * CLC socket
 	 */
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	if (unlikely(!smc->clcsock->ops->setsockopt))
 		rc = -EOPNOTSUPP;
 	else
@@ -2250,6 +2278,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk_error_report(sk);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -2266,7 +2295,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	case TCP_FASTOPEN_NO_COOKIE:
 		/* option not supported by SMC */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc = -EINVAL;
 		}
@@ -2309,13 +2338,23 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
 	struct smc_sock *smc;
+	int rc;
 
 	smc = smc_sk(sock->sk);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	/* socket options apply to the CLC socket */
-	if (unlikely(!smc->clcsock->ops->getsockopt))
+	if (unlikely(!smc->clcsock->ops->getsockopt)) {
+		mutex_unlock(&smc->clcsock_release_lock);
 		return -EOPNOTSUPP;
-	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
-					     optval, optlen);
+	}
+	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
+					   optval, optlen);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_ioctl(struct socket *sock, unsigned int cmd,
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index ee5336d73fdd..35588f0afa86 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -600,9 +600,9 @@ static int __rpc_rmdir(struct inode *dir, struct dentry *dentry)
 
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }
@@ -613,9 +613,9 @@ static int __rpc_unlink(struct inode *dir, struct dentry *dentry)
 
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_unlink(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index d0fe2fdce58c..db2a17559c3d 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -105,7 +105,6 @@ static void guest_code(void *arg)
 
 		if (cpu_has_svm()) {
 			run_guest(svm->vmcb, svm->vmcb_gpa);
-			svm->vmcb->save.rip += 3;
 			run_guest(svm->vmcb, svm->vmcb_gpa);
 		} else {
 			vmlaunch();
diff --git a/usr/include/Makefile b/usr/include/Makefile
index 1c2ae1368079..adc6cb258736 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -28,13 +28,13 @@ no-header-test += linux/am437x-vpfe.h
 no-header-test += linux/android/binder.h
 no-header-test += linux/android/binderfs.h
 no-header-test += linux/coda.h
+no-header-test += linux/cyclades.h
 no-header-test += linux/errqueue.h
 no-header-test += linux/fsmap.h
 no-header-test += linux/hdlc/ioctl.h
 no-header-test += linux/ivtv.h
 no-header-test += linux/kexec.h
 no-header-test += linux/matroxfb.h
-no-header-test += linux/nfc.h
 no-header-test += linux/omap3isp.h
 no-header-test += linux/omapfb.h
 no-header-test += linux/patchkey.h
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6bfd4e15d28..13aff136e6ee 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2104,7 +2104,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
