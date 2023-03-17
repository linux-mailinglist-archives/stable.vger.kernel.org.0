Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676496BE285
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCQIE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjCQIEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93C0B420E;
        Fri, 17 Mar 2023 01:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4657B823F2;
        Fri, 17 Mar 2023 08:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC61AC4339B;
        Fri, 17 Mar 2023 08:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040264;
        bh=GFuITLpF+xOYT2oHKIi3DUtJ1/KLKB3j0tgGd5lvRpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAaBR/cvwY9m117Ub3kXv1V5y8giw10kPVY9tmOacNl1odrols8apZILMHhu7gEBk
         4sfkfdwzth9Gs+g2OHg69IUHlOmP3mLPJ99Pu3ZoaA+Zb7oERTCTJ4slwu4DjZHnGQ
         aiYK6Ch7NNEnDyCFjjLZHLLhW3tntZQdyyAdULZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.175
Date:   Fri, 17 Mar 2023 09:04:19 +0100
Message-Id: <1679040259231186@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679040259217113@kroah.com>
References: <1679040259217113@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 92accf2ddc08..e6b09052f222 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 174
+SUBLEVEL = 175
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index 5b60c248de9e..cbefa5a77384 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -146,10 +146,8 @@ apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
 	base = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr;
 	symtab = (Elf64_Sym *)sechdrs[symindex].sh_addr;
 
-	/* The small sections were sorted to the end of the segment.
-	   The following should definitely cover them.  */
-	gp = (u64)me->core_layout.base + me->core_layout.size - 0x8000;
 	got = sechdrs[me->arch.gotsecindex].sh_addr;
+	gp = got + 0x8000;
 
 	for (i = 0; i < n; i++) {
 		unsigned long r_sym = ELF64_R_SYM (rela[i].r_info);
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 16892f0d05ad..538b6a1b198b 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -25,7 +25,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
-	spin_lock(&efi_rt_lock);					\
+	raw_spin_lock(&efi_rt_lock);					\
 })
 
 #define arch_efi_call_virt(p, f, args...)				\
@@ -37,12 +37,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
-	spin_unlock(&efi_rt_lock);					\
+	raw_spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
-extern spinlock_t efi_rt_lock;
+extern raw_spinlock_t efi_rt_lock;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 72f432d23ec5..3ee3b3daca47 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -144,7 +144,7 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	return s;
 }
 
-DEFINE_SPINLOCK(efi_rt_lock);
+DEFINE_RAW_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 
diff --git a/arch/mips/include/asm/mach-rc32434/pci.h b/arch/mips/include/asm/mach-rc32434/pci.h
index 9a6eefd12757..3eb767c8a4ee 100644
--- a/arch/mips/include/asm/mach-rc32434/pci.h
+++ b/arch/mips/include/asm/mach-rc32434/pci.h
@@ -374,7 +374,7 @@ struct pci_msu {
 				 PCI_CFG04_STAT_SSE | \
 				 PCI_CFG04_STAT_PE)
 
-#define KORINA_CNFG1		((KORINA_STAT<<16)|KORINA_CMD)
+#define KORINA_CNFG1		(KORINA_STAT | KORINA_CMD)
 
 #define KORINA_REVID		0
 #define KORINA_CLASS_CODE	0
diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
index 73f8c998c64d..d4f5f159d6f2 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
@@ -10,7 +10,6 @@
 
 / {
 	model = "fsl,T1040RDB-REV-A";
-	compatible = "fsl,T1040RDB-REV-A";
 };
 
 &seville_port0 {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 1d20f0f77a92..ba9b54d35f57 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -436,7 +436,7 @@ void vtime_flush(struct task_struct *tsk)
 #define calc_cputime_factors()
 #endif
 
-void __delay(unsigned long loops)
+void __no_kcsan __delay(unsigned long loops)
 {
 	unsigned long start;
 
@@ -457,7 +457,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-void udelay(unsigned long usecs)
+void __no_kcsan udelay(unsigned long usecs)
 {
 	__delay(tb_ticks_per_usec * usecs);
 }
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4a1f494ef03f..fabe6cf10bd2 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
@@ -378,9 +379,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }
diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 04dad3380041..bc745900c163 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -83,6 +83,6 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
 #define ftrace_init_nop ftrace_init_nop
 #endif
 
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
 
 #endif /* _ASM_RISCV_FTRACE_H */
diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index 7fee806805c1..ad254da85e61 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -3,6 +3,9 @@
  * Copyright (C) 2020 SiFive
  */
 
+#ifndef _ASM_RISCV_INSN_H
+#define _ASM_RISCV_INSN_H
+
 #include <linux/bits.h>
 
 /* The bit field of immediate value in I-type instruction */
@@ -217,3 +220,5 @@ static inline bool is_ ## INSN_NAME ## _insn(long insn) \
 	(RVC_X(x_, RVC_B_IMM_5_OPOFF, RVC_B_IMM_5_MASK) << RVC_B_IMM_5_OFF) | \
 	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
+
+#endif /* _ASM_RISCV_INSN_H */
diff --git a/arch/riscv/include/asm/patch.h b/arch/riscv/include/asm/patch.h
index 9a7d7346001e..98d9de07cba1 100644
--- a/arch/riscv/include/asm/patch.h
+++ b/arch/riscv/include/asm/patch.h
@@ -9,4 +9,6 @@
 int patch_text_nosync(void *addr, const void *insns, size_t len);
 int patch_text(void *addr, u32 insn);
 
+extern int riscv_patch_in_stop_machine;
+
 #endif /* _ASM_RISCV_PATCH_H */
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 765b62434f30..8693dfcffb02 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -15,11 +15,21 @@
 int ftrace_arch_code_modify_prepare(void) __acquires(&text_mutex)
 {
 	mutex_lock(&text_mutex);
+
+	/*
+	 * The code sequences we use for ftrace can't be patched while the
+	 * kernel is running, so we need to use stop_machine() to modify them
+	 * for now.  This doesn't play nice with text_mutex, we use this flag
+	 * to elide the check.
+	 */
+	riscv_patch_in_stop_machine = true;
+
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void) __releases(&text_mutex)
 {
+	riscv_patch_in_stop_machine = false;
 	mutex_unlock(&text_mutex);
 	return 0;
 }
@@ -109,9 +119,9 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 {
 	int out;
 
-	ftrace_arch_code_modify_prepare();
+	mutex_lock(&text_mutex);
 	out = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
-	ftrace_arch_code_modify_post_process();
+	mutex_unlock(&text_mutex);
 
 	return out;
 }
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 1612e11f7bf6..c3fced410e74 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -11,6 +11,7 @@
 #include <asm/kprobes.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
+#include <asm/ftrace.h>
 #include <asm/patch.h>
 
 struct patch_insn {
@@ -19,6 +20,8 @@ struct patch_insn {
 	atomic_t cpu_count;
 };
 
+int riscv_patch_in_stop_machine = false;
+
 #ifdef CONFIG_MMU
 static void *patch_map(void *addr, int fixmap)
 {
@@ -55,8 +58,15 @@ static int patch_insn_write(void *addr, const void *insn, size_t len)
 	 * Before reaching here, it was expected to lock the text_mutex
 	 * already, so we don't need to give another lock here and could
 	 * ensure that it was safe between each cores.
+	 *
+	 * We're currently using stop_machine() for ftrace & kprobes, and while
+	 * that ensures text_mutex is held before installing the mappings it
+	 * does not ensure text_mutex is held by the calling thread.  That's
+	 * safe but triggers a lockdep failure, so just elide it for that
+	 * specific case.
 	 */
-	lockdep_assert_held(&text_mutex);
+	if (!riscv_patch_in_stop_machine)
+		lockdep_assert_held(&text_mutex);
 
 	if (across_pages)
 		patch_map(addr + len, FIX_TEXT_POKE1);
@@ -117,13 +127,25 @@ NOKPROBE_SYMBOL(patch_text_cb);
 
 int patch_text(void *addr, u32 insn)
 {
+	int ret;
 	struct patch_insn patch = {
 		.addr = addr,
 		.insn = insn,
 		.cpu_count = ATOMIC_INIT(0),
 	};
 
-	return stop_machine_cpuslocked(patch_text_cb,
-				       &patch, cpu_online_mask);
+	/*
+	 * kprobes takes text_mutex, before calling patch_text(), but as we call
+	 * calls stop_machine(), the lockdep assertion in patch_insn_write()
+	 * gets confused by the context in which the lock is taken.
+	 * Instead, ensure the lock is held before calling stop_machine(), and
+	 * set riscv_patch_in_stop_machine to skip the check in
+	 * patch_insn_write().
+	 */
+	lockdep_assert_held(&text_mutex);
+	riscv_patch_in_stop_machine = true;
+	ret = stop_machine_cpuslocked(patch_text_cb, &patch, cpu_online_mask);
+	riscv_patch_in_stop_machine = false;
+	return ret;
 }
 NOKPROBE_SYMBOL(patch_text);
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 1e53fbe5eb78..9c34735c1e77 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -96,7 +96,7 @@ void notrace walk_stackframe(struct task_struct *task,
 	while (!kstack_end(ksp)) {
 		if (__kernel_text_address(pc) && unlikely(fn(pc, arg)))
 			break;
-		pc = (*ksp++) - 0x4;
+		pc = READ_ONCE_NOCHECK(*ksp++) - 0x4;
 	}
 }
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 23fe03ca7ec7..227253fde33c 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -31,25 +31,29 @@ void die(struct pt_regs *regs, const char *str)
 {
 	static int die_counter;
 	int ret;
+	long cause;
+	unsigned long flags;
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
 	pr_emerg("%s [#%d]\n", str, ++die_counter);
 	print_modules();
-	show_regs(regs);
+	if (regs)
+		show_regs(regs);
 
-	ret = notify_die(DIE_OOPS, str, regs, 0, regs->cause, SIGSEGV);
+	cause = regs ? regs->cause : -1;
+	ret = notify_die(DIE_OOPS, str, regs, 0, cause, SIGSEGV);
 
-	if (regs && kexec_should_crash(current))
+	if (kexec_should_crash(current))
 		crash_kexec(regs);
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irq(&die_lock);
+	spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index d7291eb0d0c0..1c65c38ec9a3 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
diff --git a/arch/um/kernel/vmlinux.lds.S b/arch/um/kernel/vmlinux.lds.S
index 16e49bfa2b42..53d719c04ba9 100644
--- a/arch/um/kernel/vmlinux.lds.S
+++ b/arch/um/kernel/vmlinux.lds.S
@@ -1,4 +1,4 @@
-
+#define RUNTIME_DISCARD_EXIT
 KERNEL_STACK_SIZE = 4096 * (1 << CONFIG_KERNEL_STACK_ORDER);
 
 #ifdef CONFIG_LD_SCRIPT_STATIC
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ec3fa4dc9031..89a9b7754476 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -932,6 +932,15 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 011929a63823..9180155d5d89 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -166,16 +166,6 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -196,7 +186,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 enum nested_evmptrld_status {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37cbd3fdd85..2c5d8b9f9873 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2725,15 +2725,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 		if (!loaded_vmcs->msr_bitmap)
 			goto out_vmcs;
 		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
-
-		if (IS_ENABLED(CONFIG_HYPERV) &&
-		    static_branch_unlikely(&enable_evmcs) &&
-		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
-			struct hv_enlightened_vmcs *evmcs =
-				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
-
-			evmcs->hv_enlightenments_control.msr_bitmap = 1;
-		}
 	}
 
 	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
@@ -3794,6 +3785,22 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
 		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
 }
 
+static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
+{
+	/*
+	 * When KVM is a nested hypervisor on top of Hyper-V and uses
+	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
+	 * bitmap has changed.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
+}
+
 static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
@@ -3803,8 +3810,7 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3849,8 +3855,7 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -7029,6 +7034,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err < 0)
 		goto free_pml;
 
+	/*
+	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
+	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
+	 * feature only for vmcs01, KVM currently isn't equipped to realize any
+	 * performance benefits from enabling it for vmcs02.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
+	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		evmcs->hv_enlightenments_control.msr_bitmap = 1;
+	}
+
 	/* The MSR bitmap starts with all ones */
 	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index badb90352bf3..1f9ccc661d57 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -705,15 +705,15 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				     struct bfq_io_cq *bic,
 				     struct bfq_group *bfqg)
 {
-	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
-	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
+	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, false);
+	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, true);
 	struct bfq_entity *entity;
 
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
 		if (entity->sched_data != &bfqg->sched_data) {
-			bic_set_bfqq(bic, NULL, 0);
+			bic_set_bfqq(bic, NULL, false);
 			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
@@ -748,8 +748,8 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 * request from the old cgroup.
 				 */
 				bfq_put_cooperator(sync_bfqq);
+				bic_set_bfqq(bic, NULL, true);
 				bfq_release_process_ref(bfqd, sync_bfqq);
-				bic_set_bfqq(bic, NULL, 1);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7c4b8d0635eb..6687b805bab3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -373,6 +373,12 @@ struct bfq_queue *bic_to_bfqq(struct bfq_io_cq *bic, bool is_sync)
 
 void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync)
 {
+	struct bfq_queue *old_bfqq = bic->bfqq[is_sync];
+
+	/* Clear bic pointer if bfqq is detached from this bic */
+	if (old_bfqq && old_bfqq->bic == bic)
+		old_bfqq->bic = NULL;
+
 	bic->bfqq[is_sync] = bfqq;
 }
 
@@ -2810,7 +2816,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	/*
 	 * Merge queues (that is, let bic redirect its requests to new_bfqq)
 	 */
-	bic_set_bfqq(bic, new_bfqq, 1);
+	bic_set_bfqq(bic, new_bfqq, true);
 	bfq_mark_bfqq_coop(new_bfqq);
 	/*
 	 * new_bfqq now belongs to at least two bics (it is a shared queue):
@@ -4977,9 +4983,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfqq->bic = NULL;
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
@@ -5065,9 +5070,11 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		bfq_release_process_ref(bfqd, bfqq);
-		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic);
+		struct bfq_queue *old_bfqq = bfqq;
+
+		bfqq = bfq_get_queue(bfqd, bio, false, bic);
 		bic_set_bfqq(bic, bfqq, false);
+		bfq_release_process_ref(bfqd, old_bfqq);
 	}
 
 	bfqq = bic_to_bfqq(bic, true);
@@ -6009,7 +6016,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 		return bfqq;
 	}
 
-	bic_set_bfqq(bic, NULL, 1);
+	bic_set_bfqq(bic, NULL, true);
 
 	bfq_put_cooperator(bfqq);
 
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 92eda5b2f134..883b4a341012 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -503,7 +503,7 @@ static void panic_halt_ipmi_heartbeat(void)
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_add(1, &panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -513,7 +513,7 @@ static void panic_halt_ipmi_heartbeat(void)
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_sub(1, &panic_done_count);
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -537,12 +537,12 @@ static void panic_halt_ipmi_set_timeout(void)
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
-	atomic_add(1, &panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = __ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
 	if (rv) {
-		atomic_sub(1, &panic_done_count);
+		atomic_sub(2, &panic_done_count);
 		pr_warn("Unable to extend the watchdog timeout\n");
 	} else {
 		if (send_heartbeat_now)
diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index 0913d3eb8d51..cd266021d010 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -143,8 +143,12 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 
 	ret = -EIO;
 	virt = acpi_os_map_iomem(start, len);
-	if (!virt)
+	if (!virt) {
+		dev_warn(&chip->dev, "%s: Failed to map ACPI memory\n", __func__);
+		/* try EFI log next */
+		ret = -ENODEV;
 		goto err;
+	}
 
 	memcpy_fromio(log->bios_event_log, virt, len);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 7212b9900e0a..994e6635b834 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -382,8 +382,9 @@ static int soc15_read_register(struct amdgpu_device *adev, u32 se_num,
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(soc15_allowed_read_registers); i++) {
 		en = &soc15_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-			reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
 					+ en->reg_offset))
 			continue;
 
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 58527f151984..98b659981f1a 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1010,6 +1010,7 @@ static void drm_atomic_connector_print_state(struct drm_printer *p,
 	drm_printf(p, "connector[%u]: %s\n", connector->base.id, connector->name);
 	drm_printf(p, "\tcrtc=%s\n", state->crtc ? state->crtc->name : "(null)");
 	drm_printf(p, "\tself_refresh_aware=%d\n", state->self_refresh_aware);
+	drm_printf(p, "\tmax_requested_bpc=%d\n", state->max_requested_bpc);
 
 	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 		if (state->writeback_job && state->writeback_job->fb)
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 4034a4bac7f0..69b2e5509d67 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -49,7 +49,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	else
 		addr = i915_gem_object_pin_map(vma->obj,
@@ -91,7 +91,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 		return;
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 0ca7e53db112..6f84db97e20e 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -36,7 +36,7 @@ void a5xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 		OUT_RING(ring, upper_32_bits(shadowptr(a5xx_gpu, ring)));
 	}
 
-	spin_lock_irqsave(&ring->lock, flags);
+	spin_lock_irqsave(&ring->preempt_lock, flags);
 
 	/* Copy the shadow to the actual register */
 	ring->cur = ring->next;
@@ -44,7 +44,7 @@ void a5xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 	/* Make sure to wrap wptr if we need to */
 	wptr = get_wptr(ring);
 
-	spin_unlock_irqrestore(&ring->lock, flags);
+	spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 	/* Make sure everything is posted before making a decision */
 	mb();
@@ -144,8 +144,8 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_RING(ring, 1);
 
 	/* Enable local preemption for finegrain preemption */
-	OUT_PKT7(ring, CP_PREEMPT_ENABLE_GLOBAL, 1);
-	OUT_RING(ring, 0x02);
+	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
+	OUT_RING(ring, 0x1);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 7e04509c4e1f..b8e71ad6f8d8 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -45,9 +45,9 @@ static inline void update_wptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 	if (!ring)
 		return;
 
-	spin_lock_irqsave(&ring->lock, flags);
+	spin_lock_irqsave(&ring->preempt_lock, flags);
 	wptr = get_wptr(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
+	spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 	gpu_write(gpu, REG_A5XX_CP_RB_WPTR, wptr);
 }
@@ -62,9 +62,9 @@ static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 		bool empty;
 		struct msm_ringbuffer *ring = gpu->rb[i];
 
-		spin_lock_irqsave(&ring->lock, flags);
-		empty = (get_wptr(ring) == ring->memptrs->rptr);
-		spin_unlock_irqrestore(&ring->lock, flags);
+		spin_lock_irqsave(&ring->preempt_lock, flags);
+		empty = (get_wptr(ring) == gpu->funcs->get_rptr(gpu, ring));
+		spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 		if (!empty)
 			return ring;
@@ -132,9 +132,9 @@ void a5xx_preempt_trigger(struct msm_gpu *gpu)
 	}
 
 	/* Make sure the wptr doesn't update while we're in motion */
-	spin_lock_irqsave(&ring->lock, flags);
+	spin_lock_irqsave(&ring->preempt_lock, flags);
 	a5xx_gpu->preempt[ring->id]->wptr = get_wptr(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
+	spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 	/* Set the address of the incoming preemption record */
 	gpu_write64(gpu, REG_A5XX_CP_CONTEXT_SWITCH_RESTORE_ADDR_LO,
@@ -210,6 +210,7 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
+		a5xx_gpu->preempt[i]->rptr_addr = shadowptr(a5xx_gpu, gpu->rb[i]);
 	}
 
 	/* Write a 0 to signal that we aren't switching pagetables */
@@ -261,7 +262,6 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE;
 
-	ptr->rptr_addr = shadowptr(a5xx_gpu, ring);
 	ptr->counter = counters_iova;
 
 	return 0;
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index dffc133b8b1c..29b40acedb38 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -65,7 +65,7 @@ static void a6xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 		OUT_RING(ring, upper_32_bits(shadowptr(a6xx_gpu, ring)));
 	}
 
-	spin_lock_irqsave(&ring->lock, flags);
+	spin_lock_irqsave(&ring->preempt_lock, flags);
 
 	/* Copy the shadow to the actual register */
 	ring->cur = ring->next;
@@ -73,7 +73,7 @@ static void a6xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 	/* Make sure to wrap wptr if we need to */
 	wptr = get_wptr(ring);
 
-	spin_unlock_irqrestore(&ring->lock, flags);
+	spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 	/* Make sure everything is posted before making a decision */
 	mb();
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index aa5c60a7132d..c4e5037512b9 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -494,8 +494,8 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 	int ret = 0;
 	uint32_t i, j;
 
-	post_deps = kmalloc_array(nr_syncobjs, sizeof(*post_deps),
-	                          GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	post_deps = kcalloc(nr_syncobjs, sizeof(*post_deps),
+			    GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!post_deps)
 		return ERR_PTR(-ENOMEM);
 
@@ -510,7 +510,6 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 		}
 
 		post_deps[i].point = syncobj_desc.point;
-		post_deps[i].chain = NULL;
 
 		if (syncobj_desc.flags) {
 			ret = -EINVAL;
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index 935bf9b1d941..1b6958e908dc 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -46,7 +46,7 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->memptrs_iova = memptrs_iova;
 
 	INIT_LIST_HEAD(&ring->submits);
-	spin_lock_init(&ring->lock);
+	spin_lock_init(&ring->preempt_lock);
 
 	snprintf(name, sizeof(name), "gpu-ring-%d", ring->id);
 
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index 0987d6bf848c..4956d1bc5d0e 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -46,7 +46,12 @@ struct msm_ringbuffer {
 	struct msm_rbmemptrs *memptrs;
 	uint64_t memptrs_iova;
 	struct msm_fence_context *fctx;
-	spinlock_t lock;
+
+	/*
+	 * preempt_lock protects preemption and serializes wptr updates against
+	 * preemption.  Can be aquired from irq context.
+	 */
+	spinlock_t preempt_lock;
 };
 
 struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index c2d34c91e840..804ea035fa46 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2555,14 +2555,6 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
-
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_fini(wndw);
-	}
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		if (encoder->encoder_type != DRM_MODE_ENCODER_DPMST)
@@ -2578,7 +2570,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 {
 	struct nv50_core *core = nv50_disp(dev)->core;
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
 
 	if (resume || runtime)
 		core->func->init(core);
@@ -2591,13 +2582,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 		}
 	}
 
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_init(wndw);
-	}
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index f07916ffe42c..831125b4453d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -690,18 +690,6 @@ nv50_wndw_notify(struct nvif_notify *notify)
 	return NVIF_NOTIFY_KEEP;
 }
 
-void
-nv50_wndw_fini(struct nv50_wndw *wndw)
-{
-	nvif_notify_put(&wndw->notify);
-}
-
-void
-nv50_wndw_init(struct nv50_wndw *wndw)
-{
-	nvif_notify_get(&wndw->notify);
-}
-
 static const u64 nv50_cursor_format_modifiers[] = {
 	DRM_FORMAT_MOD_LINEAR,
 	DRM_FORMAT_MOD_INVALID,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.h b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
index 3278e2880034..77bf124319fb 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
@@ -38,10 +38,9 @@ struct nv50_wndw {
 
 int nv50_wndw_new_(const struct nv50_wndw_func *, struct drm_device *,
 		   enum drm_plane_type, const char *name, int index,
-		   const u32 *format, enum nv50_disp_interlock_type,
-		   u32 interlock_data, u32 heads, struct nv50_wndw **);
-void nv50_wndw_init(struct nv50_wndw *);
-void nv50_wndw_fini(struct nv50_wndw *);
+		   const u32 *format, u32 heads,
+		   enum nv50_disp_interlock_type, u32 interlock_data,
+		   struct nv50_wndw **);
 void nv50_wndw_flush_set(struct nv50_wndw *, u32 *interlock,
 			 struct nv50_wndw_atom *);
 void nv50_wndw_flush_clr(struct nv50_wndw *, u32 *interlock, bool flush,
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ce822347f747..603f625a74e5 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3124,15 +3124,26 @@ static int __init parse_ivrs_hpet(char *str)
 	return 1;
 }
 
+#define ACPIID_LEN (ACPIHID_UID_LEN + ACPIHID_HID_LEN)
+
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
+	char acpiid[ACPIID_LEN] = {0};
 	int i;
 
 	addr = strchr(str, '@');
 	if (!addr) {
+		addr = strchr(str, '=');
+		if (!addr)
+			goto not_found;
+
+		++addr;
+
+		if (strlen(addr) > ACPIID_LEN)
+			goto not_found;
+
 		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
 		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
 			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
@@ -3145,6 +3156,9 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
 	if (sscanf(str, "=%s", acpiid) != 1)
 		goto not_found;
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 86fd49ae7f61..80d6412e2c54 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -24,7 +24,6 @@
 /*
  * Intel IOMMU system wide PASID name space:
  */
-static DEFINE_SPINLOCK(pasid_lock);
 u32 intel_pasid_max_id = PASID_MAX;
 
 int vcmd_alloc_pasid(struct intel_iommu *iommu, u32 *pasid)
@@ -187,6 +186,9 @@ int intel_pasid_alloc_table(struct device *dev)
 attach_out:
 	device_attach_pasid_table(info, pasid_table);
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -259,19 +261,29 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 	dir_index = pasid >> PASID_PDE_SHIFT;
 	index = pasid & PASID_PTE_MASK;
 
-	spin_lock(&pasid_lock);
+retry:
 	entries = get_pasid_table_from_pde(&dir[dir_index]);
 	if (!entries) {
 		entries = alloc_pgtable_page(info->iommu->node);
-		if (!entries) {
-			spin_unlock(&pasid_lock);
+		if (!entries)
 			return NULL;
-		}
 
-		WRITE_ONCE(dir[dir_index].val,
-			   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT);
+		/*
+		 * The pasid directory table entry won't be freed after
+		 * allocation. No worry about the race with free and
+		 * clear. However, this entry might be populated by others
+		 * while we are preparing it. Use theirs with a retry.
+		 */
+		if (cmpxchg64(&dir[dir_index].val, 0ULL,
+			      (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
+			free_pgtable_page(entries);
+			goto retry;
+		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
-	spin_unlock(&pasid_lock);
 
 	return &entries[index];
 }
diff --git a/drivers/irqchip/irq-aspeed-vic.c b/drivers/irqchip/irq-aspeed-vic.c
index 6567ed782f82..58717cd44f99 100644
--- a/drivers/irqchip/irq-aspeed-vic.c
+++ b/drivers/irqchip/irq-aspeed-vic.c
@@ -71,7 +71,7 @@ static void vic_init_hw(struct aspeed_vic *vic)
 	writel(0, vic->base + AVIC_INT_SELECT);
 	writel(0, vic->base + AVIC_INT_SELECT + 4);
 
-	/* Some interrupts have a programable high/low level trigger
+	/* Some interrupts have a programmable high/low level trigger
 	 * (4 GPIO direct inputs), for now we assume this was configured
 	 * by firmware. We read which ones are edge now.
 	 */
@@ -203,7 +203,7 @@ static int __init avic_of_init(struct device_node *node,
 	}
 	vic->base = regs;
 
-	/* Initialize soures, all masked */
+	/* Initialize sources, all masked */
 	vic_init_hw(vic);
 
 	/* Ready to receive interrupts */
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 7d776c905b7d..1c2c5bd5a9fc 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -310,7 +310,7 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 
 		if (data->can_wake) {
 			/* This IRQ chip can wake the system, set all
-			 * relevant child interupts in wake_enabled mask
+			 * relevant child interrupts in wake_enabled mask
 			 */
 			gc->wake_enabled = 0xffffffff;
 			gc->wake_enabled &= ~gc->unused;
diff --git a/drivers/irqchip/irq-csky-apb-intc.c b/drivers/irqchip/irq-csky-apb-intc.c
index 5a2ec43b7ddd..ab91afa86755 100644
--- a/drivers/irqchip/irq-csky-apb-intc.c
+++ b/drivers/irqchip/irq-csky-apb-intc.c
@@ -176,7 +176,7 @@ gx_intc_init(struct device_node *node, struct device_node *parent)
 	writel(0x0, reg_base + GX_INTC_NEN63_32);
 
 	/*
-	 * Initial mask reg with all unmasked, because we only use enalbe reg
+	 * Initial mask reg with all unmasked, because we only use enable reg
 	 */
 	writel(0x0, reg_base + GX_INTC_NMASK31_00);
 	writel(0x0, reg_base + GX_INTC_NMASK63_32);
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index fbec07d634ad..4116b48e60af 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -371,7 +371,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	 * the MSI data is the absolute value within the range from
 	 * spi_start to (spi_start + num_spis).
 	 *
-	 * Broadom NS2 GICv2m implementation has an erratum where the MSI data
+	 * Broadcom NS2 GICv2m implementation has an erratum where the MSI data
 	 * is 'spi_number - 32'
 	 *
 	 * Reading that register fails on the Graviton implementation
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d8cb5bcd6b10..5ec091c64d47 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1492,7 +1492,7 @@ static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
 	 *
 	 * Ideally, we'd issue a VMAPTI to set the doorbell to its LPI
 	 * value or to 1023, depending on the enable bit. But that
-	 * would be issueing a mapping for an /existing/ DevID+EventID
+	 * would be issuing a mapping for an /existing/ DevID+EventID
 	 * pair, which is UNPREDICTABLE. Instead, let's issue a VMOVI
 	 * to the /same/ vPE, using this opportunity to adjust the
 	 * doorbell. Mouahahahaha. We loves it, Precious.
@@ -3122,7 +3122,7 @@ static void its_cpu_init_lpis(void)
 
 		/*
 		 * It's possible for CPU to receive VLPIs before it is
-		 * sheduled as a vPE, especially for the first CPU, and the
+		 * scheduled as a vPE, especially for the first CPU, and the
 		 * VLPI with INTID larger than 2^(IDbits+1) will be considered
 		 * as out of range and dropped by GIC.
 		 * So we initialize IDbits to known value to avoid VLPI drop.
@@ -3613,7 +3613,7 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 
 	/*
 	 * If all interrupts have been freed, start mopping the
-	 * floor. This is conditionned on the device not being shared.
+	 * floor. This is conditioned on the device not being shared.
 	 */
 	if (!its_dev->shared &&
 	    bitmap_empty(its_dev->event_map.lpi_map,
@@ -4187,7 +4187,7 @@ static int its_sgi_set_affinity(struct irq_data *d,
 {
 	/*
 	 * There is no notion of affinity for virtual SGIs, at least
-	 * not on the host (since they can only be targetting a vPE).
+	 * not on the host (since they can only be targeting a vPE).
 	 * Tell the kernel we've done whatever it asked for.
 	 */
 	irq_data_update_effective_affinity(d, mask_val);
@@ -4232,7 +4232,7 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
 	/*
 	 * Locking galore! We can race against two different events:
 	 *
-	 * - Concurent vPE affinity change: we must make sure it cannot
+	 * - Concurrent vPE affinity change: we must make sure it cannot
 	 *   happen, or we'll talk to the wrong redistributor. This is
 	 *   identical to what happens with vLPIs.
 	 *
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 4c8f18f0cecf..2805969e4f15 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1456,7 +1456,7 @@ static int gic_irq_domain_translate(struct irq_domain *d,
 
 		/*
 		 * Make it clear that broken DTs are... broken.
-		 * Partitionned PPIs are an unfortunate exception.
+		 * Partitioned PPIs are an unfortunate exception.
 		 */
 		WARN_ON(*type == IRQ_TYPE_NONE &&
 			fwspec->param[0] != GIC_IRQ_TYPE_PARTITION);
diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 90e1ad6e3612..a4eb8a2181c7 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -180,7 +180,7 @@ static void pch_pic_reset(struct pch_pic *priv)
 	int i;
 
 	for (i = 0; i < PIC_COUNT; i++) {
-		/* Write vectore ID */
+		/* Write vectored ID */
 		writeb(priv->ht_vec_base + i, priv->base + PCH_INT_HTVEC(i));
 		/* Hardcode route to HT0 Lo */
 		writeb(1, priv->base + PCH_INT_ROUTE(i));
diff --git a/drivers/irqchip/irq-meson-gpio.c b/drivers/irqchip/irq-meson-gpio.c
index bc7aebcc96e9..e50676ce2ec8 100644
--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -227,7 +227,7 @@ meson_gpio_irq_request_channel(struct meson_gpio_irq_controller *ctl,
 
 	/*
 	 * Get the hwirq number assigned to this channel through
-	 * a pointer the channel_irq table. The added benifit of this
+	 * a pointer the channel_irq table. The added benefit of this
 	 * method is that we can also retrieve the channel index with
 	 * it, using the table base.
 	 */
diff --git a/drivers/irqchip/irq-mtk-cirq.c b/drivers/irqchip/irq-mtk-cirq.c
index 69ba8ce3c178..9bca0918078e 100644
--- a/drivers/irqchip/irq-mtk-cirq.c
+++ b/drivers/irqchip/irq-mtk-cirq.c
@@ -217,7 +217,7 @@ static void mtk_cirq_resume(void)
 {
 	u32 value;
 
-	/* flush recored interrupts, will send signals to parent controller */
+	/* flush recorded interrupts, will send signals to parent controller */
 	value = readl_relaxed(cirq_data->base + CIRQ_CONTROL);
 	writel_relaxed(value | CIRQ_FLUSH, cirq_data->base + CIRQ_CONTROL);
 
diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index a671938fd97f..d1f5740cd575 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -58,7 +58,7 @@ struct icoll_priv {
 static struct icoll_priv icoll_priv;
 static struct irq_domain *icoll_domain;
 
-/* calculate bit offset depending on number of intterupt per register */
+/* calculate bit offset depending on number of interrupt per register */
 static u32 icoll_intr_bitshift(struct irq_data *d, u32 bit)
 {
 	/*
@@ -68,7 +68,7 @@ static u32 icoll_intr_bitshift(struct irq_data *d, u32 bit)
 	return bit << ((d->hwirq & 3) << 3);
 }
 
-/* calculate mem offset depending on number of intterupt per register */
+/* calculate mem offset depending on number of interrupt per register */
 static void __iomem *icoll_intr_reg(struct irq_data *d)
 {
 	/* offset = hwirq / intr_per_reg * 0x10 */
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index fb78d6623556..9ea94456b178 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -189,7 +189,7 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 	 * 3) spurious irq
 	 * So if we immediately get a reading of 0, check the irq-pending reg
 	 * to differentiate between 2 and 3. We only do this once to avoid
-	 * the extra check in the common case of 1 hapening after having
+	 * the extra check in the common case of 1 happening after having
 	 * read the vector-reg once.
 	 */
 	hwirq = readl(irq_ic_data->irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index 532d0ae172d9..ca1f593f4d13 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -78,7 +78,7 @@ struct ti_sci_inta_vint_desc {
  * struct ti_sci_inta_irq_domain - Structure representing a TISCI based
  *				   Interrupt Aggregator IRQ domain.
  * @sci:		Pointer to TISCI handle
- * @vint:		TISCI resource pointer representing IA inerrupts.
+ * @vint:		TISCI resource pointer representing IA interrupts.
  * @global_event:	TISCI resource pointer representing global events.
  * @vint_list:		List of the vints active in the system
  * @vint_mutex:		Mutex to protect vint_list
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index e46036374227..62f3d29f9042 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -163,7 +163,7 @@ static struct syscore_ops vic_syscore_ops = {
 };
 
 /**
- * vic_pm_init - initicall to register VIC pm
+ * vic_pm_init - initcall to register VIC pm
  *
  * This is called via late_initcall() to register
  * the resources for the VICs due to the early
@@ -397,7 +397,7 @@ static void __init vic_clear_interrupts(void __iomem *base)
 /*
  * The PL190 cell from ARM has been modified by ST to handle 64 interrupts.
  * The original cell has 32 interrupts, while the modified one has 64,
- * replocating two blocks 0x00..0x1f in 0x20..0x3f. In that case
+ * replicating two blocks 0x00..0x1f in 0x20..0x3f. In that case
  * the probe function is called twice, with base set to offset 000
  *  and 020 within the page. We call this "second block".
  */
diff --git a/drivers/irqchip/irq-xilinx-intc.c b/drivers/irqchip/irq-xilinx-intc.c
index 1d3d273309bd..8cd1bfc73057 100644
--- a/drivers/irqchip/irq-xilinx-intc.c
+++ b/drivers/irqchip/irq-xilinx-intc.c
@@ -210,7 +210,7 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
 
 	/*
 	 * Disable all external interrupts until they are
-	 * explicity requested.
+	 * explicitly requested.
 	 */
 	xintc_write(irqc, IER, 0);
 
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 29f48c2028b6..e90ad1b78e93 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -34,8 +34,8 @@
 #endif
 
 struct wf_lm75_sensor {
-	int			ds1775 : 1;
-	int			inited : 1;
+	unsigned int		ds1775 : 1;
+	unsigned int		inited : 1;
 	struct i2c_client	*i2c;
 	struct wf_sensor	sens;
 };
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index c8706cfb83fd..714c1e14074e 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -273,8 +273,8 @@ struct smu_cpu_power_sensor {
 	struct list_head	link;
 	struct wf_sensor	*volts;
 	struct wf_sensor	*amps;
-	int			fake_volts : 1;
-	int			quadratic : 1;
+	unsigned int		fake_volts : 1;
+	unsigned int		quadratic : 1;
 	struct wf_sensor	sens;
 };
 #define to_smu_cpu_power(c) container_of(c, struct smu_cpu_power_sensor, sens)
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 8f0812e85901..92a5f9aff9b5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2748,7 +2748,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
 					     0, 1, 1, 1);
-	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_ANALOGUE_GAIN,
 					0, 1023, 1, 0);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 22e524b69806..a56c844d7f81 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -130,6 +130,23 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 				"gpio-ir-recv-irq", gpio_dev);
 }
 
+static int gpio_ir_recv_remove(struct platform_device *pdev)
+{
+	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
+	struct device *pmdev = gpio_dev->pmdev;
+
+	if (pmdev) {
+		pm_runtime_get_sync(pmdev);
+		cpu_latency_qos_remove_request(&gpio_dev->qos);
+
+		pm_runtime_disable(pmdev);
+		pm_runtime_put_noidle(pmdev);
+		pm_runtime_set_suspended(pmdev);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int gpio_ir_recv_suspend(struct device *dev)
 {
@@ -189,6 +206,7 @@ MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
 
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
+	.remove = gpio_ir_recv_remove,
 	.driver = {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 9960127f612e..bb999e67d773 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -890,13 +890,13 @@ static void bgmac_chip_reset_idm_config(struct bgmac *bgmac)
 
 		if (iost & BGMAC_BCMA_IOST_ATTACHED) {
 			flags = BGMAC_BCMA_IOCTL_SW_CLKEN;
-			if (!bgmac->has_robosw)
+			if (bgmac->in_init || !bgmac->has_robosw)
 				flags |= BGMAC_BCMA_IOCTL_SW_RESET;
 		}
 		bgmac_clk_enable(bgmac, flags);
 	}
 
-	if (iost & BGMAC_BCMA_IOST_ATTACHED && !bgmac->has_robosw)
+	if (iost & BGMAC_BCMA_IOST_ATTACHED && (bgmac->in_init || !bgmac->has_robosw))
 		bgmac_idm_write(bgmac, BCMA_IOCTL,
 				bgmac_idm_read(bgmac, BCMA_IOCTL) &
 				~BGMAC_BCMA_IOCTL_SW_RESET);
@@ -1490,6 +1490,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	struct net_device *net_dev = bgmac->net_dev;
 	int err;
 
+	bgmac->in_init = true;
+
 	bgmac_chip_intrs_off(bgmac);
 
 	net_dev->irq = bgmac->irq;
@@ -1542,6 +1544,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
 
+	bgmac->in_init = false;
+
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
 		dev_err(bgmac->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 351c598a3ec6..d1200b27af1e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -512,6 +512,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c4a768ce8c99..6928c0b578ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2854,7 +2854,7 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 
 static void bnxt_free_tpa_info(struct bnxt *bp)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -2862,8 +2862,10 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 		kfree(rxr->rx_tpa_idx_map);
 		rxr->rx_tpa_idx_map = NULL;
 		if (rxr->rx_tpa) {
-			kfree(rxr->rx_tpa[0].agg_arr);
-			rxr->rx_tpa[0].agg_arr = NULL;
+			for (j = 0; j < bp->max_tpa; j++) {
+				kfree(rxr->rx_tpa[j].agg_arr);
+				rxr->rx_tpa[j].agg_arr = NULL;
+			}
 		}
 		kfree(rxr->rx_tpa);
 		rxr->rx_tpa = NULL;
@@ -2872,14 +2874,13 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 
 static int bnxt_alloc_tpa_info(struct bnxt *bp)
 {
-	int i, j, total_aggs = 0;
+	int i, j;
 
 	bp->max_tpa = MAX_TPA;
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		if (!bp->max_tpa_v2)
 			return 0;
 		bp->max_tpa = max_t(u16, bp->max_tpa_v2, MAX_TPA_P5);
-		total_aggs = bp->max_tpa * MAX_SKB_FRAGS;
 	}
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
@@ -2893,12 +2894,12 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 
 		if (!(bp->flags & BNXT_FLAG_CHIP_P5))
 			continue;
-		agg = kcalloc(total_aggs, sizeof(*agg), GFP_KERNEL);
-		rxr->rx_tpa[0].agg_arr = agg;
-		if (!agg)
-			return -ENOMEM;
-		for (j = 1; j < bp->max_tpa; j++)
-			rxr->rx_tpa[j].agg_arr = agg + j * MAX_SKB_FRAGS;
+		for (j = 0; j < bp->max_tpa; j++) {
+			agg = kcalloc(MAX_SKB_FRAGS, sizeof(*agg), GFP_KERNEL);
+			if (!agg)
+				return -ENOMEM;
+			rxr->rx_tpa[j].agg_arr = agg;
+		}
 		rxr->rx_tpa_idx_map = kzalloc(sizeof(*rxr->rx_tpa_idx_map),
 					      GFP_KERNEL);
 		if (!rxr->rx_tpa_idx_map)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 217dc67c48fa..a8319295f1ab 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -354,7 +354,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
 	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
-		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK |
+		   MAC_MCR_RX_FIFO_CLR_DIS;
 
 	/* Only update control register when needed! */
 	if (mcr_new != mcr_cur)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 54a7cd93cc0f..0ca3223ad545 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -339,6 +339,7 @@
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
 #define MAC_MCR_RX_EN		BIT(13)
+#define MAC_MCR_RX_FIFO_CLR_DIS	BIT(12)
 #define MAC_MCR_BACKOFF_EN	BIT(9)
 #define MAC_MCR_BACKPR_EN	BIT(8)
 #define MAC_MCR_FORCE_RX_FC	BIT(5)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1ec000d4c770..04c59102a286 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1145,6 +1145,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index a644e8e5071c..375bbd60b38a 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -326,6 +326,37 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static void lan88xx_link_change_notify(struct phy_device *phydev)
+{
+	int temp;
+
+	/* At forced 100 F/H mode, chip may fail to set mode correctly
+	 * when cable is switched between long(~50+m) and short one.
+	 * As workaround, set to 10 before setting to 100
+	 * at forced 100 F/H mode.
+	 */
+	if (!phydev->autoneg && phydev->speed == 100) {
+		/* disable phy interrupt */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+
+		temp = phy_read(phydev, MII_BMCR);
+		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
+		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
+		temp |= BMCR_SPEED100;
+		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
+
+		/* clear pending interrupt generated while workaround */
+		temp = phy_read(phydev, LAN88XX_INT_STS);
+
+		/* enable phy interrupt back */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+	}
+}
+
 static struct phy_driver microchip_phy_driver[] = {
 {
 	.phy_id		= 0x0007c130,
@@ -339,6 +370,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
+	.link_change_notify = lan88xx_link_change_notify,
 
 	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3ef5aa6b72a7..e771e0e8a9bc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2833,8 +2833,6 @@ static int phy_probe(struct device *dev)
 	if (phydrv->flags & PHY_IS_INTERNAL)
 		phydev->is_internal = true;
 
-	mutex_lock(&phydev->lock);
-
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -2903,12 +2901,10 @@ static int phy_probe(struct device *dev)
 	phydev->state = PHY_READY;
 
 out:
-	/* Assert the reset signal */
+	/* Re-assert the reset signal on error */
 	if (err)
 		phy_device_reset(phydev, 1);
 
-	mutex_unlock(&phydev->lock);
-
 	return err;
 }
 
@@ -2918,9 +2914,7 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
-	mutex_lock(&phydev->lock);
 	phydev->state = PHY_DOWN;
-	mutex_unlock(&phydev->lock);
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 6f7b70522d92..667984efeb3b 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -824,20 +824,19 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 				u32 length, u8 *data)
 {
 	int i;
-	int ret;
 	u32 buf;
 	unsigned long timeout;
 
-	ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+	lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 
 	if (buf & OTP_PWR_DN_PWRDN_N_) {
 		/* clear it and wait to be cleared */
-		ret = lan78xx_write_reg(dev, OTP_PWR_DN, 0);
+		lan78xx_write_reg(dev, OTP_PWR_DN, 0);
 
 		timeout = jiffies + HZ;
 		do {
 			usleep_range(1, 10);
-			ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+			lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_PWR_DN");
@@ -847,18 +846,18 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 	}
 
 	for (i = 0; i < length; i++) {
-		ret = lan78xx_write_reg(dev, OTP_ADDR1,
+		lan78xx_write_reg(dev, OTP_ADDR1,
 					((offset + i) >> 8) & OTP_ADDR1_15_11);
-		ret = lan78xx_write_reg(dev, OTP_ADDR2,
+		lan78xx_write_reg(dev, OTP_ADDR2,
 					((offset + i) & OTP_ADDR2_10_3));
 
-		ret = lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
-		ret = lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
+		lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
+		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_STATUS, &buf);
+			lan78xx_read_reg(dev, OTP_STATUS, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_STATUS");
@@ -866,7 +865,7 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 			}
 		} while (buf & OTP_STATUS_BUSY_);
 
-		ret = lan78xx_read_reg(dev, OTP_RD_DATA, &buf);
+		lan78xx_read_reg(dev, OTP_RD_DATA, &buf);
 
 		data[i] = (u8)(buf & 0xFF);
 	}
@@ -878,20 +877,19 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 				 u32 length, u8 *data)
 {
 	int i;
-	int ret;
 	u32 buf;
 	unsigned long timeout;
 
-	ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+	lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 
 	if (buf & OTP_PWR_DN_PWRDN_N_) {
 		/* clear it and wait to be cleared */
-		ret = lan78xx_write_reg(dev, OTP_PWR_DN, 0);
+		lan78xx_write_reg(dev, OTP_PWR_DN, 0);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+			lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_PWR_DN completion");
@@ -901,21 +899,21 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 	}
 
 	/* set to BYTE program mode */
-	ret = lan78xx_write_reg(dev, OTP_PRGM_MODE, OTP_PRGM_MODE_BYTE_);
+	lan78xx_write_reg(dev, OTP_PRGM_MODE, OTP_PRGM_MODE_BYTE_);
 
 	for (i = 0; i < length; i++) {
-		ret = lan78xx_write_reg(dev, OTP_ADDR1,
+		lan78xx_write_reg(dev, OTP_ADDR1,
 					((offset + i) >> 8) & OTP_ADDR1_15_11);
-		ret = lan78xx_write_reg(dev, OTP_ADDR2,
+		lan78xx_write_reg(dev, OTP_ADDR2,
 					((offset + i) & OTP_ADDR2_10_3));
-		ret = lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
-		ret = lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
-		ret = lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
+		lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
+		lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
+		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_STATUS, &buf);
+			lan78xx_read_reg(dev, OTP_STATUS, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "Timeout on OTP_STATUS completion");
@@ -1040,7 +1038,6 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 			container_of(param, struct lan78xx_priv, set_multicast);
 	struct lan78xx_net *dev = pdata->dev;
 	int i;
-	int ret;
 
 	netif_dbg(dev, drv, dev->net, "deferred multicast write 0x%08x\n",
 		  pdata->rfe_ctl);
@@ -1049,14 +1046,14 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 			       DP_SEL_VHF_HASH_LEN, pdata->mchash_table);
 
 	for (i = 1; i < NUM_OF_MAF; i++) {
-		ret = lan78xx_write_reg(dev, MAF_HI(i), 0);
-		ret = lan78xx_write_reg(dev, MAF_LO(i),
+		lan78xx_write_reg(dev, MAF_HI(i), 0);
+		lan78xx_write_reg(dev, MAF_LO(i),
 					pdata->pfilter_table[i][1]);
-		ret = lan78xx_write_reg(dev, MAF_HI(i),
+		lan78xx_write_reg(dev, MAF_HI(i),
 					pdata->pfilter_table[i][0]);
 	}
 
-	ret = lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
+	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
 }
 
 static void lan78xx_set_multicast(struct net_device *netdev)
@@ -1126,7 +1123,6 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 				      u16 lcladv, u16 rmtadv)
 {
 	u32 flow = 0, fct_flow = 0;
-	int ret;
 	u8 cap;
 
 	if (dev->fc_autoneg)
@@ -1149,10 +1145,10 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 		  (cap & FLOW_CTRL_RX ? "enabled" : "disabled"),
 		  (cap & FLOW_CTRL_TX ? "enabled" : "disabled"));
 
-	ret = lan78xx_write_reg(dev, FCT_FLOW, fct_flow);
+	lan78xx_write_reg(dev, FCT_FLOW, fct_flow);
 
 	/* threshold value should be set before enabling flow */
-	ret = lan78xx_write_reg(dev, FLOW, flow);
+	lan78xx_write_reg(dev, FLOW, flow);
 
 	return 0;
 }
@@ -1673,11 +1669,10 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
 static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 {
 	u32 addr_lo, addr_hi;
-	int ret;
 	u8 addr[6];
 
-	ret = lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
-	ret = lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
+	lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
+	lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
 
 	addr[0] = addr_lo & 0xFF;
 	addr[1] = (addr_lo >> 8) & 0xFF;
@@ -1710,12 +1705,12 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 			  (addr[2] << 16) | (addr[3] << 24);
 		addr_hi = addr[4] | (addr[5] << 8);
 
-		ret = lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
-		ret = lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+		lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
+		lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
 	}
 
-	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	ether_addr_copy(dev->net->dev_addr, addr);
 }
@@ -1848,33 +1843,8 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 static void lan78xx_link_status_change(struct net_device *net)
 {
 	struct phy_device *phydev = net->phydev;
-	int ret, temp;
-
-	/* At forced 100 F/H mode, chip may fail to set mode correctly
-	 * when cable is switched between long(~50+m) and short one.
-	 * As workaround, set to 10 before setting to 100
-	 * at forced 100 F/H mode.
-	 */
-	if (!phydev->autoneg && (phydev->speed == 100)) {
-		/* disable phy interrupt */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		ret = phy_write(phydev, LAN88XX_INT_MASK, temp);
 
-		temp = phy_read(phydev, MII_BMCR);
-		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
-		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
-		temp |= BMCR_SPEED100;
-		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
-
-		/* clear pending interrupt generated while workaround */
-		temp = phy_read(phydev, LAN88XX_INT_STS);
-
-		/* enable phy interrupt back */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
-		ret = phy_write(phydev, LAN88XX_INT_MASK, temp);
-	}
+	phy_print_status(phydev);
 }
 
 static int irq_map(struct irq_domain *d, unsigned int irq,
@@ -1927,14 +1897,13 @@ static void lan78xx_irq_bus_sync_unlock(struct irq_data *irqd)
 	struct lan78xx_net *dev =
 			container_of(data, struct lan78xx_net, domain_data);
 	u32 buf;
-	int ret;
 
 	/* call register access here because irq_bus_lock & irq_bus_sync_unlock
 	 * are only two callbacks executed in non-atomic contex.
 	 */
-	ret = lan78xx_read_reg(dev, INT_EP_CTL, &buf);
+	lan78xx_read_reg(dev, INT_EP_CTL, &buf);
 	if (buf != data->irqenable)
-		ret = lan78xx_write_reg(dev, INT_EP_CTL, data->irqenable);
+		lan78xx_write_reg(dev, INT_EP_CTL, data->irqenable);
 
 	mutex_unlock(&data->irq_lock);
 }
@@ -2001,7 +1970,6 @@ static void lan78xx_remove_irq_domain(struct lan78xx_net *dev)
 static int lan8835_fixup(struct phy_device *phydev)
 {
 	int buf;
-	int ret;
 	struct lan78xx_net *dev = netdev_priv(phydev->attached_dev);
 
 	/* LED2/PME_N/IRQ_N/RGMII_ID pin to IRQ_N mode */
@@ -2011,11 +1979,11 @@ static int lan8835_fixup(struct phy_device *phydev)
 	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8010, buf);
 
 	/* RGMII MAC TXC Delay Enable */
-	ret = lan78xx_write_reg(dev, MAC_RGMII_ID,
+	lan78xx_write_reg(dev, MAC_RGMII_ID,
 				MAC_RGMII_ID_TXC_DELAY_EN_);
 
 	/* RGMII TX DLL Tune Adjust */
-	ret = lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
+	lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
 
 	dev->interface = PHY_INTERFACE_MODE_RGMII_TXID;
 
@@ -2199,28 +2167,27 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 
 static int lan78xx_set_rx_max_frame_length(struct lan78xx_net *dev, int size)
 {
-	int ret = 0;
 	u32 buf;
 	bool rxenabled;
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 
 	rxenabled = ((buf & MAC_RX_RXEN_) != 0);
 
 	if (rxenabled) {
 		buf &= ~MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		lan78xx_write_reg(dev, MAC_RX, buf);
 	}
 
 	/* add 4 to size for FCS */
 	buf &= ~MAC_RX_MAX_SIZE_MASK_;
 	buf |= (((size + 4) << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
 
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
 	if (rxenabled) {
 		buf |= MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		lan78xx_write_reg(dev, MAC_RX, buf);
 	}
 
 	return 0;
@@ -2277,13 +2244,12 @@ static int lan78xx_change_mtu(struct net_device *netdev, int new_mtu)
 	int ll_mtu = new_mtu + netdev->hard_header_len;
 	int old_hard_mtu = dev->hard_mtu;
 	int old_rx_urb_size = dev->rx_urb_size;
-	int ret;
 
 	/* no second zero-length packet read wanted after mtu-sized packets */
 	if ((ll_mtu % dev->maxpacket) == 0)
 		return -EDOM;
 
-	ret = lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
+	lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
 
 	netdev->mtu = new_mtu;
 
@@ -2306,7 +2272,6 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	struct lan78xx_net *dev = netdev_priv(netdev);
 	struct sockaddr *addr = p;
 	u32 addr_lo, addr_hi;
-	int ret;
 
 	if (netif_running(netdev))
 		return -EBUSY;
@@ -2323,12 +2288,12 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	addr_hi = netdev->dev_addr[4] |
 		  netdev->dev_addr[5] << 8;
 
-	ret = lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
-	ret = lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+	lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
+	lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
 
 	/* Added to support MAC address changes */
-	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	return 0;
 }
@@ -2340,7 +2305,6 @@ static int lan78xx_set_features(struct net_device *netdev,
 	struct lan78xx_net *dev = netdev_priv(netdev);
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
@@ -2364,7 +2328,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 
 	spin_unlock_irqrestore(&pdata->rfe_ctl_lock, flags);
 
-	ret = lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
+	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
 
 	return 0;
 }
@@ -3820,7 +3784,6 @@ static u16 lan78xx_wakeframe_crc16(const u8 *buf, int len)
 static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 {
 	u32 buf;
-	int ret;
 	int mask_index;
 	u16 crc;
 	u32 temp_wucsr;
@@ -3829,26 +3792,26 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	const u8 ipv6_multicast[3] = { 0x33, 0x33 };
 	const u8 arp_type[2] = { 0x08, 0x06 };
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+	lan78xx_read_reg(dev, MAC_TX, &buf);
 	buf &= ~MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_write_reg(dev, MAC_TX, buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 	buf &= ~MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
-	ret = lan78xx_write_reg(dev, WUCSR, 0);
-	ret = lan78xx_write_reg(dev, WUCSR2, 0);
-	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	lan78xx_write_reg(dev, WUCSR, 0);
+	lan78xx_write_reg(dev, WUCSR2, 0);
+	lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
 
 	temp_wucsr = 0;
 
 	temp_pmt_ctl = 0;
-	ret = lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
+	lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
 	temp_pmt_ctl &= ~PMT_CTL_RES_CLR_WKP_EN_;
 	temp_pmt_ctl |= PMT_CTL_RES_CLR_WKP_STS_;
 
 	for (mask_index = 0; mask_index < NUM_OF_WUF_CFG; mask_index++)
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
 
 	mask_index = 0;
 	if (wol & WAKE_PHY) {
@@ -3877,30 +3840,30 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 
 		/* set WUF_CFG & WUF_MASK for IPv4 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv4_multicast, 3);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
 					WUF_CFGX_EN_ |
 					WUF_CFGX_TYPE_MCAST_ |
 					(0 << WUF_CFGX_OFFSET_SHIFT_) |
 					(crc & WUF_CFGX_CRC16_MASK_));
 
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		/* for IPv6 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv6_multicast, 2);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
 					WUF_CFGX_EN_ |
 					WUF_CFGX_TYPE_MCAST_ |
 					(0 << WUF_CFGX_OFFSET_SHIFT_) |
 					(crc & WUF_CFGX_CRC16_MASK_));
 
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -3921,16 +3884,16 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		 * for packettype (offset 12,13) = ARP (0x0806)
 		 */
 		crc = lan78xx_wakeframe_crc16(arp_type, 2);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
 					WUF_CFGX_EN_ |
 					WUF_CFGX_TYPE_ALL_ |
 					(0 << WUF_CFGX_OFFSET_SHIFT_) |
 					(crc & WUF_CFGX_CRC16_MASK_));
 
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -3938,7 +3901,7 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
 
-	ret = lan78xx_write_reg(dev, WUCSR, temp_wucsr);
+	lan78xx_write_reg(dev, WUCSR, temp_wucsr);
 
 	/* when multiple WOL bits are set */
 	if (hweight_long((unsigned long)wol) > 1) {
@@ -3946,16 +3909,16 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl &= ~PMT_CTL_SUS_MODE_MASK_;
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
-	ret = lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
+	lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
 
 	/* clear WUPS */
-	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	lan78xx_read_reg(dev, PMT_CTL, &buf);
 	buf |= PMT_CTL_WUPS_MASK_;
-	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	lan78xx_write_reg(dev, PMT_CTL, buf);
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 	buf |= MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
 	return 0;
 }
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 5e300788be52..808d73050afd 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -249,6 +249,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -262,6 +265,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index a1858689d6e1..84c5b922f245 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1195,7 +1195,8 @@ config I2C_MULTI_INSTANTIATE
 
 config MLX_PLATFORM
 	tristate "Mellanox Technologies platform support"
-	depends on I2C && REGMAP
+	depends on I2C
+	select REGMAP
 	help
 	  This option enables system support for the Mellanox Technologies
 	  platform. The Mellanox systems provide data center networking
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 1b9e1442e6a5..d5c7b70bd4de 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -642,12 +642,17 @@ static void dasd_diag_setup_blk_queue(struct dasd_block *block)
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
 }
 
+static int dasd_diag_pe_handler(struct dasd_device *device, __u8 tbvpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_diag_discipline = {
 	.owner = THIS_MODULE,
 	.name = "DIAG",
 	.ebcname = "DIAG",
 	.check_device = dasd_diag_check_device,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_diag_pe_handler,
 	.fill_geometry = dasd_diag_fill_geometry,
 	.setup_blk_queue = dasd_diag_setup_blk_queue,
 	.start_IO = dasd_start_diag,
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 1a44e321b54e..b159575a2760 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -803,13 +803,18 @@ static void dasd_fba_setup_blk_queue(struct dasd_block *block)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
 
+static int dasd_fba_pe_handler(struct dasd_device *device, __u8 tbvpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_fba_discipline = {
 	.owner = THIS_MODULE,
 	.name = "FBA ",
 	.ebcname = "FBA ",
 	.check_device = dasd_fba_check_characteristics,
 	.do_analysis = dasd_fba_do_analysis,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_fba_pe_handler,
 	.setup_blk_queue = dasd_fba_setup_blk_queue,
 	.fill_geometry = dasd_fba_fill_geometry,
 	.start_IO = dasd_start_IO,
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index e8a06d85d6f7..5d7d35ca5eb4 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -298,7 +298,6 @@ struct dasd_discipline {
 	 * e.g. verify that new path is compatible with the current
 	 * configuration.
 	 */
-	int (*verify_path)(struct dasd_device *, __u8);
 	int (*pe_handler)(struct dasd_device *, __u8);
 
 	/*
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d664c4650b2d..fae032324210 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -180,6 +180,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	scsi_proc_hostdir_rm(shost->hostt);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
@@ -321,6 +322,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
 	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index c088a848776e..2d5b1d597866 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1517,6 +1517,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 
+#define MEGASAS_MAX_SUPPORTED_LD_IDS		240
+
 #define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 83f69c33b01a..ec10d35b4685 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -358,7 +358,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 		ld = MR_TargetIdToLdGet(i, drv_map);
 
 		/* For non existing VDs, iterate to next VD*/
-		if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
+		if (ld >= MEGASAS_MAX_SUPPORTED_LD_IDS)
 			continue;
 
 		raid = MR_LdRaidGet(ld, drv_map);
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 8e6ca23ed172..eed5b855dd94 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -294,15 +294,10 @@ void ext4_release_system_zone(struct super_block *sb)
 		call_rcu(&system_blks->rcu, ext4_destroy_system_zone);
 }
 
-/*
- * Returns 1 if the passed-in block region (start_blk,
- * start_blk+count) is valid; 0 if some part of the block region
- * overlaps with some other filesystem metadata blocks.
- */
-int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
-			  unsigned int count)
+int ext4_sb_block_valid(struct super_block *sb, struct inode *inode,
+				ext4_fsblk_t start_blk, unsigned int count)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_system_blocks *system_blks;
 	struct ext4_system_zone *entry;
 	struct rb_node *n;
@@ -331,7 +326,9 @@ int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else {
-			ret = (entry->ino == inode->i_ino);
+			ret = 0;
+			if (inode)
+				ret = (entry->ino == inode->i_ino);
 			break;
 		}
 	}
@@ -340,6 +337,17 @@ int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
 	return ret;
 }
 
+/*
+ * Returns 1 if the passed-in block region (start_blk,
+ * start_blk+count) is valid; 0 if some part of the block region
+ * overlaps with some other filesystem metadata blocks.
+ */
+int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
+			  unsigned int count)
+{
+	return ext4_sb_block_valid(inode->i_sb, inode, start_blk, count);
+}
+
 int ext4_check_blockref(const char *function, unsigned int line,
 			struct inode *inode, __le32 *p, unsigned int max)
 {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 81dc61f1c557..246573a4e804 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3536,6 +3536,9 @@ extern int ext4_inode_block_valid(struct inode *inode,
 				  unsigned int count);
 extern int ext4_check_blockref(const char *, unsigned int,
 			       struct inode *, __le32 *, unsigned int);
+extern int ext4_sb_block_valid(struct super_block *sb, struct inode *inode,
+				ext4_fsblk_t start_blk, unsigned int count);
+
 
 /* extents.c */
 struct ext4_ext_path;
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index 4493ef0c715e..cdf9bfe10137 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -486,6 +486,8 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 		keys[0].fmr_physical = bofs;
 	if (keys[1].fmr_physical >= eofs)
 		keys[1].fmr_physical = eofs - 1;
+	if (keys[1].fmr_physical < keys[0].fmr_physical)
+		return 0;
 	start_fsb = keys[0].fmr_physical;
 	end_fsb = keys[1].fmr_physical;
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 77377befbb1c..61cb50e8fcb7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -157,7 +157,6 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 355343cf4609..1a654a1f3f46 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4639,8 +4639,13 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 
 	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		int err;
+
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		return ext4_find_inline_data_nolock(inode);
+		err = ext4_find_inline_data_nolock(inode);
+		if (!err && ext4_has_inline_data(inode))
+			ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return err;
 	} else
 		EXT4_I(inode)->i_inline_off = 0;
 	return 0;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 240d792db9f7..53bdc67a815f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -180,6 +180,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d5ca02a7766e..843840c2aced 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5303,7 +5303,8 @@ static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
 }
 
 /**
- * ext4_free_blocks() -- Free given blocks and update quota
+ * ext4_mb_clear_bb() -- helper function for freeing blocks.
+ *			Used by ext4_free_blocks()
  * @handle:		handle for this transaction
  * @inode:		inode
  * @bh:			optional buffer of the block to be freed
@@ -5311,9 +5312,9 @@ static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
  * @count:		number of blocks to be freed
  * @flags:		flags used by ext4_free_blocks
  */
-void ext4_free_blocks(handle_t *handle, struct inode *inode,
-		      struct buffer_head *bh, ext4_fsblk_t block,
-		      unsigned long count, int flags)
+static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
+			       ext4_fsblk_t block, unsigned long count,
+			       int flags)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
@@ -5330,79 +5331,14 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 
-	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
-		return;
-	}
-
-	might_sleep();
-	if (bh) {
-		if (block)
-			BUG_ON(block != bh->b_blocknr);
-		else
-			block = bh->b_blocknr;
-	}
-
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
 	    !ext4_inode_block_valid(inode, block, count)) {
-		ext4_error(sb, "Freeing blocks not in datazone - "
-			   "block = %llu, count = %lu", block, count);
+		ext4_error(sb, "Freeing blocks in system zone - "
+			   "Block = %llu, count = %lu", block, count);
+		/* err = 0. ext4_std_error should be a no op */
 		goto error_return;
 	}
-
-	ext4_debug("freeing block %llu\n", block);
-	trace_ext4_free_blocks(inode, block, count, flags);
-
-	if (bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-		BUG_ON(count > 1);
-
-		ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
-			    inode, bh, block);
-	}
-
-	/*
-	 * If the extent to be freed does not begin on a cluster
-	 * boundary, we need to deal with partial clusters at the
-	 * beginning and end of the extent.  Normally we will free
-	 * blocks at the beginning or the end unless we are explicitly
-	 * requested to avoid doing so.
-	 */
-	overflow = EXT4_PBLK_COFF(sbi, block);
-	if (overflow) {
-		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
-			overflow = sbi->s_cluster_ratio - overflow;
-			block += overflow;
-			if (count > overflow)
-				count -= overflow;
-			else
-				return;
-		} else {
-			block -= overflow;
-			count += overflow;
-		}
-	}
-	overflow = EXT4_LBLK_COFF(sbi, count);
-	if (overflow) {
-		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
-			if (count > overflow)
-				count -= overflow;
-			else
-				return;
-		} else
-			count += sbi->s_cluster_ratio - overflow;
-	}
-
-	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-		int i;
-		int is_metadata = flags & EXT4_FREE_BLOCKS_METADATA;
-
-		for (i = 0; i < count; i++) {
-			cond_resched();
-			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
-			ext4_forget(handle, is_metadata, inode, bh, block + i);
-		}
-	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
 
 do_more:
 	overflow = 0;
@@ -5420,6 +5356,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		overflow = EXT4_C2B(sbi, bit) + count -
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -5434,13 +5372,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, gdp), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, gdp), block, count) ||
-	    in_range(block, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group)) {
-
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -5510,7 +5443,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
-					 " group:%d block:%d count:%lu failed"
+					 " group:%u block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
 		} else
@@ -5562,6 +5495,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		block += count;
 		count = overflow;
 		put_bh(bitmap_bh);
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 		goto do_more;
 	}
 error_return:
@@ -5570,6 +5505,108 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	return;
 }
 
+/**
+ * ext4_free_blocks() -- Free given blocks and update quota
+ * @handle:		handle for this transaction
+ * @inode:		inode
+ * @bh:			optional buffer of the block to be freed
+ * @block:		starting physical block to be freed
+ * @count:		number of blocks to be freed
+ * @flags:		flags used by ext4_free_blocks
+ */
+void ext4_free_blocks(handle_t *handle, struct inode *inode,
+		      struct buffer_head *bh, ext4_fsblk_t block,
+		      unsigned long count, int flags)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned int overflow;
+	struct ext4_sb_info *sbi;
+
+	sbi = EXT4_SB(sb);
+
+	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
+		ext4_free_blocks_simple(inode, block, count);
+		return;
+	}
+
+	might_sleep();
+	if (bh) {
+		if (block)
+			BUG_ON(block != bh->b_blocknr);
+		else
+			block = bh->b_blocknr;
+	}
+
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
+		ext4_error(sb, "Freeing blocks not in datazone - "
+			   "block = %llu, count = %lu", block, count);
+		return;
+	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
+
+	ext4_debug("freeing block %llu\n", block);
+	trace_ext4_free_blocks(inode, block, count, flags);
+
+	if (bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		BUG_ON(count > 1);
+
+		ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
+			    inode, bh, block);
+	}
+
+	/*
+	 * If the extent to be freed does not begin on a cluster
+	 * boundary, we need to deal with partial clusters at the
+	 * beginning and end of the extent.  Normally we will free
+	 * blocks at the beginning or the end unless we are explicitly
+	 * requested to avoid doing so.
+	 */
+	overflow = EXT4_PBLK_COFF(sbi, block);
+	if (overflow) {
+		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
+			overflow = sbi->s_cluster_ratio - overflow;
+			block += overflow;
+			if (count > overflow)
+				count -= overflow;
+			else
+				return;
+		} else {
+			block -= overflow;
+			count += overflow;
+		}
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
+	}
+	overflow = EXT4_LBLK_COFF(sbi, count);
+	if (overflow) {
+		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
+			if (count > overflow)
+				count -= overflow;
+			else
+				return;
+		} else
+			count += sbi->s_cluster_ratio - overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
+	}
+
+	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		int i;
+		int is_metadata = flags & EXT4_FREE_BLOCKS_METADATA;
+
+		for (i = 0; i < count; i++) {
+			cond_resched();
+			if (is_metadata)
+				bh = sb_find_get_block(inode->i_sb, block + i);
+			ext4_forget(handle, is_metadata, inode, bh, block + i);
+		}
+	}
+
+	ext4_mb_clear_bb(handle, inode, block, count, flags);
+	return;
+}
+
 /**
  * ext4_group_add_blocks() -- Add given blocks to an existing group
  * @handle:			handle to this transaction
@@ -5626,11 +5663,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
-	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group)) {
+	if (!ext4_sb_block_valid(sb, NULL, block, count)) {
 		ext4_error(sb, "Adding blocks in system zones - "
 			   "Block = %llu, count = %lu",
 			   block, count);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7ec7c9c16a39..1f47aeca7142 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1512,11 +1512,10 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, fname, res_dir,
 					     &has_inline_data);
-		if (has_inline_data) {
-			if (inlined)
-				*inlined = 1;
+		if (inlined)
+			*inlined = has_inline_data;
+		if (has_inline_data)
 			goto cleanup_and_exit;
-		}
 	}
 
 	if ((namelen <= 2) && (name[0] == '.') &&
@@ -3698,7 +3697,8 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3863,9 +3863,20 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
-	if (IS_ERR(old.bh))
-		return PTR_ERR(old.bh);
+	/*
+	 * We need to protect against old.inode directory getting converted
+	 * from inline directory format into a normal one.
+	 */
+	if (S_ISDIR(old.inode->i_mode))
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
+
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
+	if (IS_ERR(old.bh)) {
+		retval = PTR_ERR(old.bh);
+		goto unlock_moved_dir;
+	}
+
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3923,8 +3934,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval)
+		if (retval) {
+			inode_unlock(old.inode);
 			goto end_rename;
+		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
@@ -4053,6 +4066,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
+
+unlock_moved_dir:
+	if (S_ISDIR(old.inode->i_mode))
+		inode_unlock(old.inode);
+
 	return retval;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4569075a7da0..a94cc7b22d7e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -416,7 +416,8 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -430,10 +431,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 		io_submit_init_bio(io, bh);
 		io->io_bio->bi_write_hint = inode->i_write_hint;
 	}
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -551,8 +553,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 		nr_submitted++;
 		clear_buffer_dirty(bh);
 	} while ((bh = bh->b_this_page) != head);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b80ad5a7b05c..60e122761352 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2804,6 +2804,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 
+	if (ext4_has_inline_data(inode))
+		error = ext4_find_inline_data_nolock(inode);
+
 cleanup:
 	if (error && (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count))) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
diff --git a/fs/file.c b/fs/file.c
index 97a0cd31faec..173d318208b8 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -677,6 +677,7 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 81876284a83c..d114774ecdea 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -442,7 +442,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)block) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d233f9e4b9c6..44103f9487c9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -906,7 +906,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 607bee9271bd..b89a8ac83d1b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -116,7 +116,7 @@ enum {
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_common_data.affinity
  * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
  *			  support stacked irqchips, which indicates skipping
- *			  all descendent irqchips.
+ *			  all descendant irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
@@ -302,7 +302,7 @@ static inline bool irqd_is_level_type(struct irq_data *d)
 
 /*
  * Must only be called of irqchip.irq_set_affinity() or low level
- * hieararchy domain allocation functions.
+ * hierarchy domain allocation functions.
  */
 static inline void irqd_set_single_target(struct irq_data *d)
 {
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 5745491303e0..fdb22e0f9a91 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -32,7 +32,7 @@ struct pt_regs;
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @threads_handled:	stats field for deferred spurious detection of threaded handlers
- * @threads_handled_last: comparator field for deferred spurious detection of theraded handlers
+ * @threads_handled_last: comparator field for deferred spurious detection of threaded handlers
  * @lock:		locking for SMP
  * @affinity_hint:	hint to user space for preferred irq affinity
  * @affinity_notify:	context for notification of affinity changes
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index ea5a337e0f8b..9b9743f7538c 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -256,7 +256,7 @@ static inline struct fwnode_handle *irq_domain_alloc_fwnode(phys_addr_t *pa)
 }
 
 void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2e1935917c24..4b34a5c12599 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3115,6 +3115,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 82d0e41b76f2..faa108b1ba67 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -17,6 +17,13 @@ static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
 	return false;
 }
 
+static inline void nf_tproxy_twsk_deschedule_put(struct inet_timewait_sock *tw)
+{
+	local_bh_disable();
+	inet_twsk_deschedule_put(tw);
+	local_bh_enable();
+}
+
 /* assign a socket to the skb -- consumes sk */
 static inline void nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 11b612e94e4e..cb80d18a49b5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3541,6 +3541,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
 	struct btf *btf = env->btf;
 	u16 i;
 
+	env->resolve_mode = RESOLVE_TBD;
 	for_each_vsi_from(i, v->next_member, v->t, vsi) {
 		u32 var_type_id = vsi->type, type_id, type_size = 0;
 		const struct btf_type *var_type = btf_type_by_id(env->btf,
diff --git a/kernel/fork.c b/kernel/fork.c
index 68efe2a0b4fb..a5bc0c6a00fd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2726,7 +2726,7 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	 * - make the CLONE_DETACHED bit reuseable for clone3
 	 * - make the CSIGNAL bits reuseable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 621d8dd157bc..e7d284261d45 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -811,7 +811,7 @@ void handle_edge_irq(struct irq_desc *desc)
 		/*
 		 * When another irq arrived while we were handling
 		 * one, we could have masked the irq.
-		 * Renable it, if it was not disabled in meantime.
+		 * Reenable it, if it was not disabled in meantime.
 		 */
 		if (unlikely(desc->istate & IRQS_PENDING)) {
 			if (!irqd_irq_disabled(&desc->irq_data) &&
diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index 0b0cdf206dc4..7fe6cffe7d0d 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -13,7 +13,7 @@
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
- * Each architecture has to answer this themself.
+ * Each architecture has to answer this themselves.
  */
 static void ack_bad(struct irq_data *data)
 {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9b0914a063f9..6c009a033c73 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -31,7 +31,7 @@ static int __init irq_affinity_setup(char *str)
 	cpulist_parse(str, irq_default_affinity);
 	/*
 	 * Set at least the boot cpu. We don't want to end up with
-	 * bugreports caused by random comandline masks
+	 * bugreports caused by random commandline masks
 	 */
 	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
 	return 1;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1720998933f8..fd3f7c16c299 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -25,6 +25,9 @@ static DEFINE_MUTEX(irq_domain_mutex);
 
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity);
 static void irq_domain_check_hierarchy(struct irq_domain *domain);
 
 struct irqchip_fwid {
@@ -53,7 +56,7 @@ EXPORT_SYMBOL_GPL(irqchip_fwnode_ops);
  * @name:	Optional user provided domain name
  * @pa:		Optional user-provided physical address
  *
- * Allocate a struct irqchip_fwid, and return a poiner to the embedded
+ * Allocate a struct irqchip_fwid, and return a pointer to the embedded
  * fwnode_handle (or NULL on failure).
  *
  * Note: The types IRQCHIP_FWNODE_NAMED and IRQCHIP_FWNODE_NAMED_ID are
@@ -114,23 +117,12 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
 
-/**
- * __irq_domain_add() - Allocate a new irq_domain data structure
- * @fwnode: firmware node for the interrupt controller
- * @size: Size of linear map; 0 for radix mapping only
- * @hwirq_max: Maximum number of interrupts supported by controller
- * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
- *              direct mapping
- * @ops: domain callbacks
- * @host_data: Controller private data pointer
- *
- * Allocates and initializes an irq_domain structure.
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
-				    irq_hw_number_t hwirq_max, int direct_max,
-				    const struct irq_domain_ops *ops,
-				    void *host_data)
+static struct irq_domain *__irq_domain_create(struct fwnode_handle *fwnode,
+					      unsigned int size,
+					      irq_hw_number_t hwirq_max,
+					      int direct_max,
+					      const struct irq_domain_ops *ops,
+					      void *host_data)
 {
 	struct irqchip_fwid *fwid;
 	struct irq_domain *domain;
@@ -207,12 +199,44 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
 	domain->revmap_direct_max_irq = direct_max;
 	irq_domain_check_hierarchy(domain);
 
+	return domain;
+}
+
+static void __irq_domain_publish(struct irq_domain *domain)
+{
 	mutex_lock(&irq_domain_mutex);
 	debugfs_add_domain_dir(domain);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Added domain %s\n", domain->name);
+}
+
+/**
+ * __irq_domain_add() - Allocate a new irq_domain data structure
+ * @fwnode: firmware node for the interrupt controller
+ * @size: Size of linear map; 0 for radix mapping only
+ * @hwirq_max: Maximum number of interrupts supported by controller
+ * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
+ *              direct mapping
+ * @ops: domain callbacks
+ * @host_data: Controller private data pointer
+ *
+ * Allocates and initializes an irq_domain structure.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data)
+{
+	struct irq_domain *domain;
+
+	domain = __irq_domain_create(fwnode, size, hwirq_max, direct_max,
+				     ops, host_data);
+	if (domain)
+		__irq_domain_publish(domain);
+
 	return domain;
 }
 EXPORT_SYMBOL_GPL(__irq_domain_add);
@@ -637,6 +661,34 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
+static unsigned int irq_create_mapping_affinity_locked(struct irq_domain *domain,
+						       irq_hw_number_t hwirq,
+						       const struct irq_affinity_desc *affinity)
+{
+	struct device_node *of_node = irq_domain_get_of_node(domain);
+	int virq;
+
+	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
+
+	/* Allocate a virtual interrupt number */
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      affinity);
+	if (virq <= 0) {
+		pr_debug("-> virq allocation failed\n");
+		return 0;
+	}
+
+	if (irq_domain_associate_locked(domain, virq, hwirq)) {
+		irq_free_desc(virq);
+		return 0;
+	}
+
+	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
+		hwirq, of_node_full_name(of_node), virq);
+
+	return virq;
+}
+
 /**
  * irq_create_mapping_affinity() - Map a hardware interrupt into linux irq space
  * @domain: domain owning this hardware interrupt or NULL for default domain
@@ -649,47 +701,31 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
  * on the number returned from that call.
  */
 unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
-				       irq_hw_number_t hwirq,
-				       const struct irq_affinity_desc *affinity)
+					 irq_hw_number_t hwirq,
+					 const struct irq_affinity_desc *affinity)
 {
-	struct device_node *of_node;
 	int virq;
 
-	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
-
-	/* Look for default domain if nececssary */
+	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL) {
 		WARN(1, "%s(, %lx) called with NULL domain\n", __func__, hwirq);
 		return 0;
 	}
-	pr_debug("-> using domain @%p\n", domain);
 
-	of_node = irq_domain_get_of_node(domain);
+	mutex_lock(&irq_domain_mutex);
 
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
-		pr_debug("-> existing mapping on virq %d\n", virq);
-		return virq;
-	}
-
-	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
-				      affinity);
-	if (virq <= 0) {
-		pr_debug("-> virq allocation failed\n");
-		return 0;
+		pr_debug("existing mapping on virq %d\n", virq);
+		goto out;
 	}
 
-	if (irq_domain_associate(domain, virq, hwirq)) {
-		irq_free_desc(virq);
-		return 0;
-	}
-
-	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
-		hwirq, of_node_full_name(of_node), virq);
+	virq = irq_create_mapping_affinity_locked(domain, hwirq, affinity);
+out:
+	mutex_unlock(&irq_domain_mutex);
 
 	return virq;
 }
@@ -793,6 +829,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	if (WARN_ON(type & ~IRQ_TYPE_SENSE_MASK))
 		type &= IRQ_TYPE_SENSE_MASK;
 
+	mutex_lock(&irq_domain_mutex);
+
 	/*
 	 * If we've already configured this interrupt,
 	 * don't do it again, or hell will break loose.
@@ -805,7 +843,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 * interrupt number.
 		 */
 		if (type == IRQ_TYPE_NONE || type == irq_get_trigger_type(virq))
-			return virq;
+			goto out;
 
 		/*
 		 * If the trigger type has not been set yet, then set
@@ -813,35 +851,45 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 */
 		if (irq_get_trigger_type(virq) == IRQ_TYPE_NONE) {
 			irq_data = irq_get_irq_data(virq);
-			if (!irq_data)
-				return 0;
+			if (!irq_data) {
+				virq = 0;
+				goto out;
+			}
 
 			irqd_set_trigger_type(irq_data, type);
-			return virq;
+			goto out;
 		}
 
 		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
 			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
-		return 0;
+		virq = 0;
+		goto out;
 	}
 
 	if (irq_domain_is_hierarchy(domain)) {
-		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, fwspec);
-		if (virq <= 0)
-			return 0;
+		virq = irq_domain_alloc_irqs_locked(domain, -1, 1, NUMA_NO_NODE,
+						    fwspec, false, NULL);
+		if (virq <= 0) {
+			virq = 0;
+			goto out;
+		}
 	} else {
 		/* Create mapping */
-		virq = irq_create_mapping(domain, hwirq);
+		virq = irq_create_mapping_affinity_locked(domain, hwirq, NULL);
 		if (!virq)
-			return virq;
+			goto out;
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (WARN_ON(!irq_data))
-		return 0;
+	if (WARN_ON(!irq_data)) {
+		virq = 0;
+		goto out;
+	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);
+out:
+	mutex_unlock(&irq_domain_mutex);
 
 	return virq;
 }
@@ -893,7 +941,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 {
 	struct irq_data *data;
 
-	/* Look for default domain if nececssary */
+	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL)
@@ -1083,12 +1131,15 @@ struct irq_domain *irq_domain_create_hierarchy(struct irq_domain *parent,
 	struct irq_domain *domain;
 
 	if (size)
-		domain = irq_domain_create_linear(fwnode, size, ops, host_data);
+		domain = __irq_domain_create(fwnode, size, size, 0, ops, host_data);
 	else
-		domain = irq_domain_create_tree(fwnode, ops, host_data);
+		domain = __irq_domain_create(fwnode, 0, ~0, 0, ops, host_data);
+
 	if (domain) {
 		domain->parent = parent;
 		domain->flags |= flags;
+
+		__irq_domain_publish(domain);
 	}
 
 	return domain;
@@ -1405,40 +1456,12 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
 	return domain->ops->alloc(domain, irq_base, nr_irqs, arg);
 }
 
-/**
- * __irq_domain_alloc_irqs - Allocate IRQs from domain
- * @domain:	domain to allocate from
- * @irq_base:	allocate specified IRQ number if irq_base >= 0
- * @nr_irqs:	number of IRQs to allocate
- * @node:	NUMA node id for memory allocation
- * @arg:	domain specific argument
- * @realloc:	IRQ descriptors have already been allocated if true
- * @affinity:	Optional irq affinity mask for multiqueue devices
- *
- * Allocate IRQ numbers and initialized all data structures to support
- * hierarchy IRQ domains.
- * Parameter @realloc is mainly to support legacy IRQs.
- * Returns error code or allocated IRQ number
- *
- * The whole process to setup an IRQ has been split into two steps.
- * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
- * descriptor and required hardware resources. The second step,
- * irq_domain_activate_irq(), is to program hardwares with preallocated
- * resources. In this way, it's easier to rollback when failing to
- * allocate resources.
- */
-int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
-			    unsigned int nr_irqs, int node, void *arg,
-			    bool realloc, const struct irq_affinity_desc *affinity)
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity)
 {
 	int i, ret, virq;
 
-	if (domain == NULL) {
-		domain = irq_default_domain;
-		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
-			return -EINVAL;
-	}
-
 	if (realloc && irq_base >= 0) {
 		virq = irq_base;
 	} else {
@@ -1457,24 +1480,18 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 		goto out_free_desc;
 	}
 
-	mutex_lock(&irq_domain_mutex);
 	ret = irq_domain_alloc_irqs_hierarchy(domain, virq, nr_irqs, arg);
-	if (ret < 0) {
-		mutex_unlock(&irq_domain_mutex);
+	if (ret < 0)
 		goto out_free_irq_data;
-	}
 
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
-		if (ret) {
-			mutex_unlock(&irq_domain_mutex);
+		if (ret)
 			goto out_free_irq_data;
-		}
 	}
-	
+
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_insert_irq(virq + i);
-	mutex_unlock(&irq_domain_mutex);
 
 	return virq;
 
@@ -1485,6 +1502,48 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 	return ret;
 }
 
+/**
+ * __irq_domain_alloc_irqs - Allocate IRQs from domain
+ * @domain:	domain to allocate from
+ * @irq_base:	allocate specified IRQ number if irq_base >= 0
+ * @nr_irqs:	number of IRQs to allocate
+ * @node:	NUMA node id for memory allocation
+ * @arg:	domain specific argument
+ * @realloc:	IRQ descriptors have already been allocated if true
+ * @affinity:	Optional irq affinity mask for multiqueue devices
+ *
+ * Allocate IRQ numbers and initialized all data structures to support
+ * hierarchy IRQ domains.
+ * Parameter @realloc is mainly to support legacy IRQs.
+ * Returns error code or allocated IRQ number
+ *
+ * The whole process to setup an IRQ has been split into two steps.
+ * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
+ * descriptor and required hardware resources. The second step,
+ * irq_domain_activate_irq(), is to program the hardware with preallocated
+ * resources. In this way, it's easier to rollback when failing to
+ * allocate resources.
+ */
+int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+			    unsigned int nr_irqs, int node, void *arg,
+			    bool realloc, const struct irq_affinity_desc *affinity)
+{
+	int ret;
+
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
+			return -EINVAL;
+	}
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_alloc_irqs_locked(domain, irq_base, nr_irqs, node, arg,
+					   realloc, affinity);
+	mutex_unlock(&irq_domain_mutex);
+
+	return ret;
+}
+
 /* The irq_data was moved, fix the revmap to refer to the new location */
 static void irq_domain_fix_revmap(struct irq_data *d)
 {
@@ -1842,6 +1901,13 @@ void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
 	irq_set_handler_data(virq, handler_data);
 }
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity)
+{
+	return -EINVAL;
+}
+
 static void irq_domain_check_hierarchy(struct irq_domain *domain)
 {
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 437b073dc487..0159925054fa 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -341,7 +341,7 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
 	 * If the interrupt is not yet activated, just store the affinity
 	 * mask and do not call the chip driver at all. On activation the
 	 * driver has to make sure anyway that the interrupt is in a
-	 * useable state so startup works.
+	 * usable state so startup works.
 	 */
 	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) ||
 	    irqd_is_activated(data) || !irqd_affinity_on_activate(data))
@@ -999,7 +999,7 @@ static void irq_finalize_oneshot(struct irq_desc *desc,
 	 * to IRQS_INPROGRESS and the irq line is masked forever.
 	 *
 	 * This also serializes the state of shared oneshot handlers
-	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * versus "desc->threads_oneshot |= action->thread_mask;" in
 	 * irq_wake_thread(). See the comment there which explains the
 	 * serialization.
 	 */
@@ -1877,7 +1877,7 @@ static struct irqaction *__free_irq(struct irq_desc *desc, void *dev_id)
 	/* Last action releases resources */
 	if (!desc->action) {
 		/*
-		 * Reaquire bus lock as irq_release_resources() might
+		 * Reacquire bus lock as irq_release_resources() might
 		 * require it to deallocate resources over the slow bus.
 		 */
 		chip_bus_lock(desc);
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index b47d95b68ac1..4457f3e966d0 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -5,7 +5,7 @@
  *
  * This file is licensed under GPLv2.
  *
- * This file contains common code to support Message Signalled Interrupt for
+ * This file contains common code to support Message Signaled Interrupts for
  * PCI compatible and non PCI compatible devices.
  */
 #include <linux/types.h>
diff --git a/kernel/irq/timings.c b/kernel/irq/timings.c
index 1f981162648a..00d45b6bd8f8 100644
--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -490,7 +490,7 @@ static inline void irq_timings_store(int irq, struct irqt_stat *irqs, u64 ts)
 
 	/*
 	 * The interrupt triggered more than one second apart, that
-	 * ends the sequence as predictible for our purpose. In this
+	 * ends the sequence as predictable for our purpose. In this
 	 * case, assume we have the beginning of a sequence and the
 	 * timestamp is the first value. As it is impossible to
 	 * predict anything at this point, return.
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index d29731a30b8e..73717917d816 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -274,6 +274,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	if (ret < 0)
 		goto error;
 
+	ret = -ENOMEM;
 	pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
 	if (!pages)
 		goto error;
diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index b02e1292f7f1..24488a4e2d26 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -134,6 +134,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct usb_device *usbdev;
 	int res;
 
+	if (what == NETDEV_UNREGISTER && dev->reg_state >= NETREG_UNREGISTERED)
+		return 0;
+
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
 	      strcmp(dev->dev.parent->driver->name, "cdc_ncm") == 0))
diff --git a/net/core/dev.c b/net/core/dev.c
index 8cbcb6a104f2..413c2a08d79d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6111,6 +6111,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
 
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	kmem_cache_free(skbuff_head_cache, skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 668a9d0fbbc6..09cdefe5e1c8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -659,7 +659,6 @@ static void kfree_skbmem(struct sk_buff *skb)
 
 void skb_release_head_state(struct sk_buff *skb)
 {
-	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	if (skb->destructor) {
 		WARN_ON(in_irq());
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index b2bae0b0e42a..61cb2341f50f 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -38,7 +38,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
 					    hp->source, lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index a1ac0e3d8c60..163668531a57 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -477,6 +477,7 @@ int ila_xlat_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 6bac68fb27a3..3fe4f15e01dc 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -63,7 +63,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 					    lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f8ba3bc25cf3..c9ca857f1068 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -317,11 +317,12 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct,
+			       bool dump)
 {
 	u32 mark = READ_ONCE(ct->mark);
 
-	if (!mark)
+	if (!mark && !dump)
 		return 0;
 
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
@@ -332,7 +333,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 #else
-#define ctnetlink_dump_mark(a, b) (0)
+#define ctnetlink_dump_mark(a, b, c) (0)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -537,7 +538,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct, true) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -816,8 +817,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2734,7 +2734,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, true) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 3f4785be066a..e0e116865511 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1446,8 +1446,8 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 41cbc7c89c9d..8ab84926816f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1988,16 +1988,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = -EPIPE;
+	int rc;
 
 	smc = smc_sk(sk);
 	lock_sock(sk);
-	if ((sk->sk_state != SMC_ACTIVE) &&
-	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
-	    (sk->sk_state != SMC_INIT))
-		goto out;
 
+	/* SMC does not support connect with fastopen */
 	if (msg->msg_flags & MSG_FASTOPEN) {
+		/* not connected yet, fallback */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
@@ -2005,6 +2003,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if ((sk->sk_state != SMC_ACTIVE) &&
+		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
+		   (sk->sk_state != SMC_INIT)) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback)
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d38788cd9433..af657a482ad2 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -800,6 +800,7 @@ EXPORT_SYMBOL_GPL(svc_set_num_threads);
 static int
 svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
+	struct svc_rqst	*rqstp;
 	struct task_struct *task;
 	unsigned int state = serv->sv_nrthreads-1;
 
@@ -808,7 +809,10 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 		task = choose_victim(serv, pool, &state);
 		if (task == NULL)
 			break;
-		kthread_stop(task);
+		rqstp = kthread_data(task);
+		/* Did we lose a race to svo_function threadfn? */
+		if (kthread_stop(task) == -EINTR)
+			svc_exit_thread(rqstp);
 		nrservs++;
 	} while (nrservs < 0);
 	return 0;
diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 1548f9ce4682..697972432bbe 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -113,7 +113,7 @@ def parse_options():
     return args
 
 
-def main():
+def print_undefined_symbols():
     """Main function of this module."""
     args = parse_options()
 
@@ -472,5 +472,16 @@ def parse_kconfig_file(kfile):
     return defined, references
 
 
+def main():
+    try:
+        print_undefined_symbols()
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
+
+
 if __name__ == "__main__":
     main()
diff --git a/scripts/clang-tools/run-clang-tools.py b/scripts/clang-tools/run-clang-tools.py
index f754415af398..f42699134f1c 100755
--- a/scripts/clang-tools/run-clang-tools.py
+++ b/scripts/clang-tools/run-clang-tools.py
@@ -60,14 +60,21 @@ def run_analysis(entry):
 
 
 def main():
-    args = parse_arguments()
+    try:
+        args = parse_arguments()
 
-    lock = multiprocessing.Lock()
-    pool = multiprocessing.Pool(initializer=init, initargs=(lock, args))
-    # Read JSON data into the datastore variable
-    with open(args.path, "r") as f:
-        datastore = json.load(f)
-        pool.map(run_analysis, datastore)
+        lock = multiprocessing.Lock()
+        pool = multiprocessing.Pool(initializer=init, initargs=(lock, args))
+        # Read JSON data into the datastore variable
+        with open(args.path, "r") as f:
+            datastore = json.load(f)
+            pool.map(run_analysis, datastore)
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
 
 
 if __name__ == "__main__":
diff --git a/scripts/diffconfig b/scripts/diffconfig
index d5da5fa05d1d..43f0f3d273ae 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -65,7 +65,7 @@ def print_config(op, config, value, new_value):
         else:
             print(" %s %s -> %s" % (config, value, new_value))
 
-def main():
+def show_diff():
     global merge_style
 
     # parse command line args
@@ -129,4 +129,16 @@ def main():
     for config in new:
         print_config("+", config, None, b[config])
 
-main()
+def main():
+    try:
+        show_diff()
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
+
+
+if __name__ == '__main__':
+    main()
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 4e15e8167310..67697d8ea59a 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
