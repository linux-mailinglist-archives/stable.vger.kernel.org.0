Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70CD6BE28D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjCQIF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCQIFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4B2B53FF;
        Fri, 17 Mar 2023 01:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5427F62214;
        Fri, 17 Mar 2023 08:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39BAC433D2;
        Fri, 17 Mar 2023 08:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040270;
        bh=6AUdfwAd6q0gVEPKMqKisV3ABTRxfu1D4wBZRFhSkrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+J/SReKFl3N66K2B1F2PZtSx4kIJwszJfmLDaOqj3GS1lbwvhKcFoeUulYkgnBDO
         SGNQruxotFkugRWh5H/Cbi9cBTbD5hfJyGNUbPh8rDUwOVx4AkTP+Mq0ws2fIuebKq
         trLeUpIlaJLxkb7IsU0T+Q3PZ82OZY3ecomPlSHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.103
Date:   Fri, 17 Mar 2023 09:04:24 +0100
Message-Id: <1679040264173@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679040264214179@kroah.com>
References: <1679040264214179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bcb102c91b19..4dbbc9531669 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2200,24 +2200,57 @@
 
 	ivrs_ioapic	[HW,X86-64]
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map IOAPIC-ID decimal 10 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map IOAPIC-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
+			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
+			* To map IOAPIC-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_hpet	[HW,X86-64]
 			Provide an override to the HPET-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map HPET-ID decimal 0 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map HPET-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_hpet=10@0001:00:14.0
+
+			Deprecated formats:
+			* To map HPET-ID decimal 0 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
+			* To map HPET-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map UART-HID:UID AMD0020:0 to
-			PCI device 00:14.5 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map UART-HID:UID AMD0020:0 to
+			PCI segment 0x1 and PCI device ID 00:14.5,
+			write the parameter as:
+				ivrs_acpihid=AMD0020:0@0001:00:14.5
+
+			Deprecated formats:
+			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
+			  PCI device ID 00:14.5, write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
+			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
+			  PCI device ID 00:14.5, write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index 4e5b26f03d5b..d036946bce7a 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -2929,7 +2929,7 @@ Produces::
               bash-1994  [000] ....  4342.324898: ima_get_action <-process_measurement
               bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get_action
               bash-1994  [000] ....  4342.324899: do_truncate <-do_last
-              bash-1994  [000] ....  4342.324899: should_remove_suid <-do_truncate
+              bash-1994  [000] ....  4342.324899: setattr_should_drop_suidgid <-do_truncate
               bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
               bash-1994  [000] ....  4342.324900: current_fs_time <-notify_change
               bash-1994  [000] ....  4342.324900: current_kernel_time <-current_fs_time
diff --git a/Makefile b/Makefile
index a7b664680ea3..75acfd6c0cf2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 102
+SUBLEVEL = 103
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -888,6 +888,7 @@ ifndef CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 dwarf-version-$(CONFIG_DEBUG_INFO_DWARF4) := 4
 dwarf-version-$(CONFIG_DEBUG_INFO_DWARF5) := 5
 DEBUG_CFLAGS	+= -gdwarf-$(dwarf-version-y)
+KBUILD_AFLAGS	+= -gdwarf-$(dwarf-version-y)
 endif
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
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
index c5d4551a1be7..53cbbb96f7eb 100644
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
index 386bd81ca12b..9669f3fa2aef 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -145,7 +145,7 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
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
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index a67fd54ccc57..8bea336fa5b7 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -68,11 +68,9 @@ static void iommu_debugfs_add(struct iommu_table *tbl)
 static void iommu_debugfs_del(struct iommu_table *tbl)
 {
 	char name[10];
-	struct dentry *liobn_entry;
 
 	sprintf(name, "%08lx", tbl->it_index);
-	liobn_entry = debugfs_lookup(name, iommu_debugfs_dir);
-	debugfs_remove(liobn_entry);
+	debugfs_lookup_and_remove(name, iommu_debugfs_dir);
 }
 #else
 static void iommu_debugfs_add(struct iommu_table *tbl){}
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 934d8ae66cc6..4406d7a89558 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -450,7 +450,7 @@ void vtime_flush(struct task_struct *tsk)
 #define calc_cputime_factors()
 #endif
 
-void __delay(unsigned long loops)
+void __no_kcsan __delay(unsigned long loops)
 {
 	unsigned long start;
 
@@ -471,7 +471,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-void udelay(unsigned long usecs)
+void __no_kcsan udelay(unsigned long usecs)
 {
 	__delay(tb_ticks_per_usec * usecs);
 }
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index a664d0c4344a..d4531902d8c6 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\
@@ -407,9 +408,12 @@ SECTIONS
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
index 9e73922e1e2e..d47d87c2d7e3 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -109,6 +109,6 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
 #define ftrace_init_nop ftrace_init_nop
 #endif
 
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
 
 #endif /* _ASM_RISCV_FTRACE_H */
diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index f36368de839f..3cd00332d70f 100644
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
index 47b43d8ee9a6..1bf92cfa6764 100644
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
index 765004b60513..e099961453cc 100644
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
 /*
  * The fix_to_virt(, idx) needs a const value (not a dynamic variable of
@@ -59,8 +62,15 @@ static int patch_insn_write(void *addr, const void *insn, size_t len)
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
@@ -121,13 +131,25 @@ NOKPROBE_SYMBOL(patch_text_cb);
 
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
index ee8ef91c8aaf..894ae66421a7 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -94,7 +94,7 @@ void notrace walk_stackframe(struct task_struct *task,
 	while (!kstack_end(ksp)) {
 		if (__kernel_text_address(pc) && unlikely(!fn(arg, pc)))
 			break;
-		pc = (*ksp++) - 0x4;
+		pc = READ_ONCE_NOCHECK(*ksp++) - 0x4;
 	}
 }
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 6084bd93d2f5..4f38b3c47e6d 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -33,25 +33,29 @@ void die(struct pt_regs *regs, const char *str)
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
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 1d94ffdf347b..5d0c45c13b5f 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -80,17 +80,6 @@ asm(
 
 #ifdef CONFIG_MODULES
 static char *ftrace_plt;
-
-asm(
-	"	.data\n"
-	"ftrace_plt_template:\n"
-	"	basr	%r1,%r0\n"
-	"	lg	%r1,0f-.(%r1)\n"
-	"	br	%r1\n"
-	"0:	.quad	ftrace_caller\n"
-	"ftrace_plt_template_end:\n"
-	"	.previous\n"
-);
 #endif /* CONFIG_MODULES */
 
 static const char *ftrace_shared_hotpatch_trampoline(const char **end)
@@ -116,7 +105,7 @@ static const char *ftrace_shared_hotpatch_trampoline(const char **end)
 
 bool ftrace_need_init_nop(void)
 {
-	return ftrace_shared_hotpatch_trampoline(NULL);
+	return true;
 }
 
 int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
@@ -175,28 +164,6 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	return 0;
 }
 
-static void ftrace_generate_nop_insn(struct ftrace_insn *insn)
-{
-	/* brcl 0,0 */
-	insn->opc = 0xc004;
-	insn->disp = 0;
-}
-
-static void ftrace_generate_call_insn(struct ftrace_insn *insn,
-				      unsigned long ip)
-{
-	unsigned long target;
-
-	/* brasl r0,ftrace_caller */
-	target = FTRACE_ADDR;
-#ifdef CONFIG_MODULES
-	if (is_module_addr((void *)ip))
-		target = (unsigned long)ftrace_plt;
-#endif /* CONFIG_MODULES */
-	insn->opc = 0xc005;
-	insn->disp = (target - ip) / 2;
-}
-
 static void brcl_disable(void *brcl)
 {
 	u8 op = 0x04; /* set mask field to zero */
@@ -207,23 +174,7 @@ static void brcl_disable(void *brcl)
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
-	struct ftrace_insn orig, new, old;
-
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		brcl_disable((void *)rec->ip);
-		return 0;
-	}
-
-	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
-		return -EFAULT;
-	/* Replace ftrace call with a nop. */
-	ftrace_generate_call_insn(&orig, rec->ip);
-	ftrace_generate_nop_insn(&new);
-
-	/* Verify that the to be replaced code matches what we expect. */
-	if (memcmp(&orig, &old, sizeof(old)))
-		return -EINVAL;
-	s390_kernel_write((void *) rec->ip, &new, sizeof(new));
+	brcl_disable((void *)rec->ip);
 	return 0;
 }
 
@@ -236,23 +187,7 @@ static void brcl_enable(void *brcl)
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	struct ftrace_insn orig, new, old;
-
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		brcl_enable((void *)rec->ip);
-		return 0;
-	}
-
-	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
-		return -EFAULT;
-	/* Replace nop with an ftrace call. */
-	ftrace_generate_nop_insn(&orig);
-	ftrace_generate_call_insn(&new, rec->ip);
-
-	/* Verify that the to be replaced code matches what we expect. */
-	if (memcmp(&orig, &old, sizeof(old)))
-		return -EINVAL;
-	s390_kernel_write((void *) rec->ip, &new, sizeof(new));
+	brcl_enable((void *)rec->ip);
 	return 0;
 }
 
@@ -269,10 +204,7 @@ int __init ftrace_dyn_arch_init(void)
 
 void arch_ftrace_update_code(int command)
 {
-	if (ftrace_shared_hotpatch_trampoline(NULL))
-		ftrace_modify_all_code(command);
-	else
-		ftrace_run_stop_machine(command);
+	ftrace_modify_all_code(command);
 }
 
 static void __ftrace_sync(void *dummy)
@@ -281,10 +213,8 @@ static void __ftrace_sync(void *dummy)
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		/* Send SIGP to the other CPUs, so they see the new code. */
-		smp_call_function(__ftrace_sync, NULL, 1);
-	}
+	/* Send SIGP to the other CPUs, so they see the new code. */
+	smp_call_function(__ftrace_sync, NULL, 1);
 	return 0;
 }
 
@@ -299,10 +229,6 @@ static int __init ftrace_plt_init(void)
 		panic("cannot allocate ftrace plt\n");
 
 	start = ftrace_shared_hotpatch_trampoline(&end);
-	if (!start) {
-		start = ftrace_plt_template;
-		end = ftrace_plt_template_end;
-	}
 	memcpy(ftrace_plt, start, end - start);
 	set_memory_ro((unsigned long)ftrace_plt, 1);
 	return 0;
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 29059a1aed53..853b80770c6d 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
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
index c30e32097fb1..83bf26eaff2e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -904,6 +904,15 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 25530a908b4c..8c9e41ff2a24 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1295,6 +1295,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_apic_send_ipi);
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3d3f8dfb8045..b595a33860d7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -318,20 +318,24 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
-		 * AVIC hardware handles the generation of
-		 * IPIs when the specified Message Type is Fixed
-		 * (also known as fixed delivery mode) and
-		 * the Trigger Mode is edge-triggered. The hardware
-		 * also supports self and broadcast delivery modes
-		 * specified via the Destination Shorthand(DSH)
-		 * field of the ICRL. Logical and physical APIC ID
-		 * formats are supported. All other IPI types cause
-		 * a #VMEXIT, which needs to emulated.
+		 * Emulate IPIs that are not handled by AVIC hardware, which
+		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
+		 * if _any_ targets are invalid, e.g. if the logical mode mask
+		 * is a superset of running vCPUs.
+		 *
+		 * The exit is a trap, e.g. ICR holds the correct value and RIP
+		 * has been advanced, KVM is responsible only for emulating the
+		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
+		 * in which case KVM needs to emulate the ICR write as well in
+		 * order to clear the BUSY flag.
 		 */
-		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
-		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
+		if (icrl & APIC_ICR_BUSY)
+			kvm_apic_write_nodecode(vcpu, APIC_ICR);
+		else
+			kvm_apic_send_ipi(apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
@@ -341,8 +345,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index b43976e4b963..57451cf622d3 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -162,16 +162,6 @@ static inline u16 evmcs_read16(unsigned long field)
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
@@ -192,7 +182,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c849173b60c2..9ce45554d637 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2739,15 +2739,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
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
@@ -3781,6 +3772,22 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
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
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3789,8 +3796,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3834,8 +3840,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -6969,6 +6974,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2427b2261e51..76ce6f766d55 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -370,6 +370,7 @@ static int brd_alloc(int i)
 	struct brd_device *brd;
 	struct gendisk *disk;
 	char buf[DISK_NAME_LEN];
+	int err = -ENOMEM;
 
 	mutex_lock(&brd_devices_mutex);
 	list_for_each_entry(brd, &brd_devices, brd_list) {
@@ -420,16 +421,21 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
-	add_disk(disk);
+	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
 
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_free_dev:
 	mutex_lock(&brd_devices_mutex);
 	list_del(&brd->brd_list);
 	mutex_unlock(&brd_devices_mutex);
 	kfree(brd);
-	return -ENOMEM;
+	return err;
 }
 
 static void brd_probe(dev_t dev)
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c1ef1df42eb6..ade8b839e445 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1167,11 +1167,11 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 	return -ENOSPC;
 }
 
-static void nbd_bdev_reset(struct block_device *bdev)
+static void nbd_bdev_reset(struct nbd_device *nbd)
 {
-	if (bdev->bd_openers > 1)
+	if (nbd->disk->part0->bd_openers > 1)
 		return;
-	set_capacity(bdev->bd_disk, 0);
+	set_capacity(nbd->disk, 0);
 }
 
 static void nbd_parse_flags(struct nbd_device *nbd)
@@ -1337,7 +1337,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 	return nbd_set_size(nbd, config->bytesize, nbd_blksize(config));
 }
 
-static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *bdev)
+static int nbd_start_device_ioctl(struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
 	int ret;
@@ -1358,7 +1358,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 
 	flush_workqueue(nbd->recv_workq);
 	mutex_lock(&nbd->config_lock);
-	nbd_bdev_reset(bdev);
+	nbd_bdev_reset(nbd);
 	/* user requested, ignore socket errors */
 	if (test_bit(NBD_RT_DISCONNECT_REQUESTED, &config->runtime_flags))
 		ret = 0;
@@ -1372,7 +1372,7 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 {
 	nbd_clear_sock(nbd);
 	__invalidate_device(bdev, true);
-	nbd_bdev_reset(bdev);
+	nbd_bdev_reset(nbd);
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
 		nbd_config_put(nbd);
@@ -1418,7 +1418,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		config->flags = arg;
 		return 0;
 	case NBD_DO_IT:
-		return nbd_start_device_ioctl(nbd, bdev);
+		return nbd_start_device_ioctl(nbd);
 	case NBD_CLEAR_QUE:
 		/*
 		 * This is for compatibility only.  The queue is always cleared
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 427bf618c447..20dc2452815c 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -74,7 +74,8 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		20000	/* 20ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries (T3). */
+#define SSIF_REQ_RETRY_USEC	60000	/* 60ms between send retries (T6). */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
@@ -82,7 +83,9 @@
 #define	SSIF_RECV_RETRIES	250
 
 #define SSIF_MSG_MSEC		(SSIF_MSG_USEC / 1000)
+#define SSIF_REQ_RETRY_MSEC	(SSIF_REQ_RETRY_USEC / 1000)
 #define SSIF_MSG_JIFFIES	((SSIF_MSG_USEC * 1000) / TICK_NSEC)
+#define SSIF_REQ_RETRY_JIFFIES	((SSIF_REQ_RETRY_USEC * 1000) / TICK_NSEC)
 #define SSIF_MSG_PART_JIFFIES	((SSIF_MSG_PART_USEC * 1000) / TICK_NSEC)
 
 /*
@@ -229,6 +232,9 @@ struct ssif_info {
 	bool		    got_alert;
 	bool		    waiting_alert;
 
+	/* Used to inform the timeout that it should do a resend. */
+	bool		    do_resend;
+
 	/*
 	 * If set to true, this will request events the next time the
 	 * state machine is idle.
@@ -538,22 +544,28 @@ static void start_get(struct ssif_info *ssif_info)
 		  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
 }
 
+static void start_resend(struct ssif_info *ssif_info);
+
 static void retry_timeout(struct timer_list *t)
 {
 	struct ssif_info *ssif_info = from_timer(ssif_info, t, retry_timer);
 	unsigned long oflags, *flags;
-	bool waiting;
+	bool waiting, resend;
 
 	if (ssif_info->stopping)
 		return;
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
+	resend = ssif_info->do_resend;
+	ssif_info->do_resend = false;
 	waiting = ssif_info->waiting_alert;
 	ssif_info->waiting_alert = false;
 	ipmi_ssif_unlock_cond(ssif_info, flags);
 
 	if (waiting)
 		start_get(ssif_info);
+	if (resend)
+		start_resend(ssif_info);
 }
 
 static void watch_timeout(struct timer_list *t)
@@ -602,8 +614,6 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static void start_resend(struct ssif_info *ssif_info);
-
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
 {
@@ -909,7 +919,13 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	if (result < 0) {
 		ssif_info->retries_left--;
 		if (ssif_info->retries_left > 0) {
-			start_resend(ssif_info);
+			/*
+			 * Wait the retry timeout time per the spec,
+			 * then redo the send.
+			 */
+			ssif_info->do_resend = true;
+			mod_timer(&ssif_info->retry_timer,
+				  jiffies + SSIF_REQ_RETRY_JIFFIES);
 			return;
 		}
 
@@ -1322,8 +1338,10 @@ static int do_cmd(struct i2c_client *client, int len, unsigned char *msg,
 	ret = i2c_smbus_write_block_data(client, SSIF_IPMI_REQUEST, len, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry1;
+		}
 		return -ENODEV;
 	}
 
@@ -1464,8 +1482,10 @@ static int start_multipart_test(struct i2c_client *client,
 					 32, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry_write;
+		}
 		dev_err(&client->dev, "Could not write multi-part start, though the BMC said it could handle it.  Just limit sends to one part.\n");
 		return ret;
 	}
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
index 0cde8fb9e30d..529bb6c6ac6f 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -461,8 +461,9 @@ static int soc15_read_register(struct amdgpu_device *adev, u32 se_num,
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
index a1e4c7905ebb..1fcb5f8aea20 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1052,6 +1052,7 @@ static void drm_atomic_connector_print_state(struct drm_printer *p,
 	drm_printf(p, "connector[%u]: %s\n", connector->base.id, connector->name);
 	drm_printf(p, "\tcrtc=%s\n", state->crtc ? state->crtc->name : "(null)");
 	drm_printf(p, "\tself_refresh_aware=%d\n", state->self_refresh_aware);
+	drm_printf(p, "\tmax_requested_bpc=%d\n", state->max_requested_bpc);
 
 	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 		if (state->writeback_job && state->writeback_job->fb)
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 5e2750eb3810..b8c49ba65254 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -153,8 +153,8 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_RING(ring, 1);
 
 	/* Enable local preemption for finegrain preemption */
-	OUT_PKT7(ring, CP_PREEMPT_ENABLE_GLOBAL, 1);
-	OUT_RING(ring, 0x02);
+	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
+	OUT_RING(ring, 0x1);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
@@ -801,7 +801,7 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_RBBM_AHB_CNTL2, 0x0000003F);
 
 	/* Set the highest bank bit */
-	if (adreno_is_a540(adreno_gpu))
+	if (adreno_is_a540(adreno_gpu) || adreno_is_a530(adreno_gpu))
 		regbit = 2;
 	else
 		regbit = 1;
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 8abc9a2b114a..e0eef47dae63 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -63,7 +63,7 @@ static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 		struct msm_ringbuffer *ring = gpu->rb[i];
 
 		spin_lock_irqsave(&ring->preempt_lock, flags);
-		empty = (get_wptr(ring) == ring->memptrs->rptr);
+		empty = (get_wptr(ring) == gpu->funcs->get_rptr(gpu, ring));
 		spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 		if (!empty)
@@ -208,6 +208,7 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
+		a5xx_gpu->preempt[i]->rptr_addr = shadowptr(a5xx_gpu, gpu->rb[i]);
 	}
 
 	/* Write a 0 to signal that we aren't switching pagetables */
@@ -259,7 +260,6 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE;
 
-	ptr->rptr_addr = shadowptr(a5xx_gpu, ring);
 	ptr->counter = counters_iova;
 
 	return 0;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 700d65e39feb..4c65259eecb9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -375,19 +375,19 @@ static const struct dpu_ctl_cfg sdm845_ctl[] = {
 static const struct dpu_ctl_cfg sc7180_ctl[] = {
 	{
 	.name = "ctl_0", .id = CTL_0,
-	.base = 0x1000, .len = 0xE4,
+	.base = 0x1000, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	},
 	{
 	.name = "ctl_1", .id = CTL_1,
-	.base = 0x1200, .len = 0xE4,
+	.base = 0x1200, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	},
 	{
 	.name = "ctl_2", .id = CTL_2,
-	.base = 0x1400, .len = 0xE4,
+	.base = 0x1400, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	},
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 83e6ccad7728..fc2fb1019ea1 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -640,8 +640,8 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 	int ret = 0;
 	uint32_t i, j;
 
-	post_deps = kmalloc_array(nr_syncobjs, sizeof(*post_deps),
-	                          GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	post_deps = kcalloc(nr_syncobjs, sizeof(*post_deps),
+			    GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!post_deps)
 		return ERR_PTR(-ENOMEM);
 
@@ -656,7 +656,6 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 		}
 
 		post_deps[i].point = syncobj_desc.point;
-		post_deps[i].chain = NULL;
 
 		if (syncobj_desc.flags) {
 			ret = -EINVAL;
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index d7b9f7f8c9e3..0722b907bfcf 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2622,14 +2622,6 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
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
@@ -2645,7 +2637,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 {
 	struct nv50_core *core = nv50_disp(dev)->core;
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
 
 	if (resume || runtime)
 		core->func->init(core);
@@ -2658,13 +2649,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
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
index 8d048bacd6f0..e1e62674e82d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -694,18 +694,6 @@ nv50_wndw_notify(struct nvif_notify *notify)
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
index f4e0c5080034..6c64864da455 100644
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
index ce91a6d8532f..50ea582be591 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -85,6 +85,10 @@
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
 #define LOOP_TIMEOUT	2000000
+
+#define IVRS_GET_SBDF_ID(seg, bus, dev, fd)	(((seg & 0xffff) << 16) | ((bus & 0xff) << 8) \
+						 | ((dev & 0x1f) << 3) | (fn & 0x7))
+
 /*
  * ACPI table definitions
  *
@@ -3146,24 +3150,32 @@ static int __init parse_amd_iommu_options(char *str)
 
 static int __init parse_ivrs_ioapic(char *str)
 {
-	unsigned int bus, dev, fn;
-	int ret, id, i;
-	u16 devid;
+	u32 seg = 0, bus, dev, fn;
+	int id, i;
+	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
 
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-		return 1;
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_ioapic%s option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+	return 1;
+
+found:
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
 			str);
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_ioapic_map_size++;
@@ -3176,24 +3188,32 @@ static int __init parse_ivrs_ioapic(char *str)
 
 static int __init parse_ivrs_hpet(char *str)
 {
-	unsigned int bus, dev, fn;
-	int ret, id, i;
-	u16 devid;
+	u32 seg = 0, bus, dev, fn;
+	int id, i;
+	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
 
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_hpet%s\n", str);
-		return 1;
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_hpet%s option format deprecated; use ivrs_hpet=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_hpet%s\n", str);
+	return 1;
+
+found:
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
 			str);
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_hpet_map_size++;
@@ -3204,19 +3224,53 @@ static int __init parse_ivrs_hpet(char *str)
 	return 1;
 }
 
+#define ACPIID_LEN (ACPIHID_UID_LEN + ACPIHID_HID_LEN)
+
 static int __init parse_ivrs_acpihid(char *str)
 {
-	u32 bus, dev, fn;
-	char *hid, *uid, *p;
-	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
-	int ret, i;
+	u32 seg = 0, bus, dev, fn;
+	char *hid, *uid, *p, *addr;
+	char acpiid[ACPIID_LEN] = {0};
+	int i;
 
-	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-		return 1;
+	addr = strchr(str, '@');
+	if (!addr) {
+		addr = strchr(str, '=');
+		if (!addr)
+			goto not_found;
+
+		++addr;
+
+		if (strlen(addr) > ACPIID_LEN)
+			goto not_found;
+
+		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
+		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
+			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
+				str, acpiid, seg, bus, dev, fn);
+			goto found;
+		}
+		goto not_found;
 	}
 
+	/* We have the '@', make it the terminator to get just the acpiid */
+	*addr++ = 0;
+
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
+	if (sscanf(str, "=%s", acpiid) != 1)
+		goto not_found;
+
+	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
+	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
+		goto found;
+
+not_found:
+	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
+	return 1;
+
+found:
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
@@ -3236,8 +3290,7 @@ static int __init parse_ivrs_acpihid(char *str)
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
-	early_acpihid_map[i].devid =
-		((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	early_acpihid_map[i].devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 	early_acpihid_map[i].cmd_line	= true;
 
 	return 1;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 9a3dd55aaa1c..6dbc43b414ca 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -186,6 +186,9 @@ int intel_pasid_alloc_table(struct device *dev)
 attach_out:
 	device_attach_pasid_table(info, pasid_table);
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -276,6 +279,10 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			free_pgtable_page(entries);
 			goto retry;
 		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 
 	return &entries[index];
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
index db5a19babe67..a141552531f7 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2776,7 +2776,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
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
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c1505de23957..7bcfa3be95e2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -388,6 +388,24 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 		mt7530_write(priv, MT7530_ATA1 + (i * 4), reg[i]);
 }
 
+/* Set up switch core clock for MT7530 */
+static void mt7530_pll_setup(struct mt7530_priv *priv)
+{
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
+
+	/* Set core clock into 500Mhz */
+	core_write(priv, CORE_GSWPLL_GRP2,
+		   RG_GSWPLL_POSDIV_500M(1) |
+		   RG_GSWPLL_FBKDIV_500M(25));
+
+	/* Enable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1,
+		   RG_GSWPLL_EN_PRE |
+		   RG_GSWPLL_POSDIV_200M(2) |
+		   RG_GSWPLL_FBKDIV_200M(32));
+}
+
 /* Setup TX circuit including relevant PAD and driving */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -448,21 +466,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
 		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Setup core clock for MT7530 */
-	/* Disable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1, 0);
-
-	/* Set core clock into 500Mhz */
-	core_write(priv, CORE_GSWPLL_GRP2,
-		   RG_GSWPLL_POSDIV_500M(1) |
-		   RG_GSWPLL_FBKDIV_500M(25));
-
-	/* Enable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1,
-		   RG_GSWPLL_EN_PRE |
-		   RG_GSWPLL_POSDIV_200M(2) |
-		   RG_GSWPLL_FBKDIV_200M(32));
-
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
@@ -2163,6 +2166,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7530_pll_setup(priv);
+
 	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index fa2a43d465db..f8fd65ab663e 100644
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
index 110088e662ea..99a344175a75 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -474,6 +474,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f64df4d53289..4e98e34fc46b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2999,7 +2999,7 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 
 static void bnxt_free_tpa_info(struct bnxt *bp)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -3007,8 +3007,10 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
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
@@ -3017,14 +3019,13 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 
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
@@ -3038,12 +3039,12 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 
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
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 24001035910e..60f73e775bee 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3998,6 +3998,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 		 * SFP modules only ever use page 0.
 		 */
 		if (page == 0 || !(data[0x2] & 0x4)) {
+			u32 copy_len;
+
 			/* If i2c bus is busy due to slow page change or
 			 * link management access, call can fail. This is normal.
 			 * So we retry this a few times.
@@ -4021,8 +4023,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 			}
 
 			/* Make sure we have enough room for the new block */
-			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
-				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
+			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE, ee->len - i);
+			memcpy(data + i, value, copy_len);
 		}
 	}
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index a7213db38804..fed49d6a178d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -811,6 +811,9 @@ bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
+#define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
+#define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
+
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
 void rvu_program_channels(struct rvu *rvu);
@@ -826,6 +829,8 @@ static inline void rvu_dbg_init(struct rvu *rvu) {}
 static inline void rvu_dbg_exit(struct rvu *rvu) {}
 #endif
 
+int rvu_ndc_fix_locked_cacheline(struct rvu *rvu, int blkaddr);
+
 /* RVU Switch */
 void rvu_switch_enable(struct rvu *rvu);
 void rvu_switch_disable(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 66d34699f160..4dddf6ec3be8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -196,9 +196,6 @@ enum cpt_eng_type {
 	CPT_IE_TYPE = 3,
 };
 
-#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
-						blk_addr, NDC_AF_CONST) & 0xFF)
-
 #define rvu_dbg_NULL NULL
 #define rvu_dbg_open_NULL NULL
 
@@ -1009,6 +1006,7 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 	struct nix_hw *nix_hw;
 	struct rvu *rvu;
 	int bank, max_bank;
+	u64 ndc_af_const;
 
 	if (blk_addr == BLKADDR_NDC_NPA0) {
 		rvu = s->private;
@@ -1017,7 +1015,8 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 		rvu = nix_hw->rvu;
 	}
 
-	max_bank = NDC_MAX_BANK(rvu, blk_addr);
+	ndc_af_const = rvu_read64(rvu, blk_addr, NDC_AF_CONST);
+	max_bank = FIELD_GET(NDC_AF_BANK_MASK, ndc_af_const);
 	for (bank = 0; bank < max_bank; bank++) {
 		seq_printf(s, "BANK:%d\n", bank);
 		seq_printf(s, "\tHits:\t%lld\n",
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 09892703cfd4..d274d552924a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -797,6 +797,7 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 	struct nix_aq_res_s *result;
 	int timeout = 1000;
 	u64 reg, head;
+	int ret;
 
 	result = (struct nix_aq_res_s *)aq->res->base;
 
@@ -820,9 +821,22 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 			return -EBUSY;
 	}
 
-	if (result->compcode != NIX_AQ_COMP_GOOD)
+	if (result->compcode != NIX_AQ_COMP_GOOD) {
 		/* TODO: Replace this with some error code */
+		if (result->compcode == NIX_AQ_COMP_CTX_FAULT ||
+		    result->compcode == NIX_AQ_COMP_LOCKERR ||
+		    result->compcode == NIX_AQ_COMP_CTX_POISON) {
+			ret = rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX0_RX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX0_TX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX1_RX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX1_TX);
+			if (ret)
+				dev_err(rvu->dev,
+					"%s: Not able to unlock cachelines\n", __func__);
+		}
+
 		return -EBUSY;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 70bd036ed76e..4f5ca5ab13a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2018 Marvell.
  *
  */
-
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
@@ -42,9 +42,18 @@ static int npa_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 			return -EBUSY;
 	}
 
-	if (result->compcode != NPA_AQ_COMP_GOOD)
+	if (result->compcode != NPA_AQ_COMP_GOOD) {
 		/* TODO: Replace this with some error code */
+		if (result->compcode == NPA_AQ_COMP_CTX_FAULT ||
+		    result->compcode == NPA_AQ_COMP_LOCKERR ||
+		    result->compcode == NPA_AQ_COMP_CTX_POISON) {
+			if (rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NPA0))
+				dev_err(rvu->dev,
+					"%s: Not able to unlock cachelines\n", __func__);
+		}
+
 		return -EBUSY;
+	}
 
 	return 0;
 }
@@ -545,3 +554,48 @@ void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf)
 
 	npa_ctx_free(rvu, pfvf);
 }
+
+/* Due to an Hardware errata, in some corner cases, AQ context lock
+ * operations can result in a NDC way getting into an illegal state
+ * of not valid but locked.
+ *
+ * This API solves the problem by clearing the lock bit of the NDC block.
+ * The operation needs to be done for each line of all the NDC banks.
+ */
+int rvu_ndc_fix_locked_cacheline(struct rvu *rvu, int blkaddr)
+{
+	int bank, max_bank, line, max_line, err;
+	u64 reg, ndc_af_const;
+
+	/* Set the ENABLE bit(63) to '0' */
+	reg = rvu_read64(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL);
+	rvu_write64(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL, reg & GENMASK_ULL(62, 0));
+
+	/* Poll until the BUSY bits(47:32) are set to '0' */
+	err = rvu_poll_reg(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL, GENMASK_ULL(47, 32), true);
+	if (err) {
+		dev_err(rvu->dev, "Timed out while polling for NDC CAM busy bits.\n");
+		return err;
+	}
+
+	ndc_af_const = rvu_read64(rvu, blkaddr, NDC_AF_CONST);
+	max_bank = FIELD_GET(NDC_AF_BANK_MASK, ndc_af_const);
+	max_line = FIELD_GET(NDC_AF_BANK_LINE_MASK, ndc_af_const);
+	for (bank = 0; bank < max_bank; bank++) {
+		for (line = 0; line < max_line; line++) {
+			/* Check if 'cache line valid bit(63)' is not set
+			 * but 'cache line lock bit(60)' is set and on
+			 * success, reset the lock bit(60).
+			 */
+			reg = rvu_read64(rvu, blkaddr,
+					 NDC_AF_BANKX_LINEX_METADATA(bank, line));
+			if (!(reg & BIT_ULL(63)) && (reg & BIT_ULL(60))) {
+				rvu_write64(rvu, blkaddr,
+					    NDC_AF_BANKX_LINEX_METADATA(bank, line),
+					    reg & ~BIT_ULL(60));
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 21f1ed4e222f..d81b63a0d430 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -670,6 +670,7 @@
 #define NDC_AF_INTR_ENA_W1S		(0x00068)
 #define NDC_AF_INTR_ENA_W1C		(0x00070)
 #define NDC_AF_ACTIVE_PC		(0x00078)
+#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
 #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
 #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
 #define NDC_AF_BLK_RST			(0x002F0)
@@ -685,6 +686,8 @@
 		(0x00F00 | (a) << 5 | (b) << 4)
 #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
 #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
+#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
+		(0x10000 | (a) << 12 | (b) << 3)
 
 /* LBK */
 #define LBK_CONST			(0x10ull)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index cc6a5b2f24e3..bb1acdb0c62b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -363,7 +363,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
 	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
-		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK |
+		   MAC_MCR_RX_FIFO_CLR_DIS;
 
 	/* Only update control register when needed! */
 	if (mcr_new != mcr_cur)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f2d90639d7ed..d60260e00a3f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -369,6 +369,7 @@
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
 #define MAC_MCR_RX_EN		BIT(13)
+#define MAC_MCR_RX_FIFO_CLR_DIS	BIT(12)
 #define MAC_MCR_BACKOFF_EN	BIT(9)
 #define MAC_MCR_BACKPR_EN	BIT(8)
 #define MAC_MCR_FORCE_RX_FC	BIT(5)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d56f65338ea6..728e68971c39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1262,6 +1262,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 9f1f2b6c97d4..230f2fcf9c46 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -342,6 +342,37 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
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
@@ -355,6 +386,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
+	.link_change_notify = lan88xx_link_change_notify,
 
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 996842a1a9a3..73485383db4e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3052,8 +3052,6 @@ static int phy_probe(struct device *dev)
 	if (phydrv->flags & PHY_IS_INTERNAL)
 		phydev->is_internal = true;
 
-	mutex_lock(&phydev->lock);
-
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -3121,12 +3119,10 @@ static int phy_probe(struct device *dev)
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
 
@@ -3136,9 +3132,7 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
-	mutex_lock(&phydev->lock);
 	phydev->state = PHY_DOWN;
-	mutex_unlock(&phydev->lock);
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 636b0907a598..04e628788f1b 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -57,8 +57,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
-	u16 intmask = 0;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -66,12 +64,10 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
-		if (priv->energy_enable)
-			intmask |= MII_LAN83C185_ISF_INT7;
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+		rc = phy_write(phydev, MII_LAN83C185_IM,
+			       MII_LAN83C185_ISF_INT_PHYLIB_EVENTS);
 	} else {
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
 
@@ -83,13 +79,7 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	int irq_status, irq_enabled;
-
-	irq_enabled = phy_read(phydev, MII_LAN83C185_IM);
-	if (irq_enabled < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
+	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
 	if (irq_status < 0) {
@@ -97,7 +87,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & irq_enabled))
+	if (!(irq_status & MII_LAN83C185_ISF_INT_PHYLIB_EVENTS))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3e1a83a22fdd..5700c9d20a3e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1950,33 +1950,8 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 static void lan78xx_link_status_change(struct net_device *net)
 {
 	struct phy_device *phydev = net->phydev;
-	int temp;
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
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
 
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
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
-	}
+	phy_print_status(phydev);
 }
 
 static int irq_map(struct irq_domain *d, unsigned int irq,
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 051c43a2a52f..5f97dcf08dd0 100644
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
index cd8146dbdd45..61186829d1f6 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -943,7 +943,8 @@ config I2C_MULTI_INSTANTIATE
 
 config MLX_PLATFORM
 	tristate "Mellanox Technologies platform support"
-	depends on I2C && REGMAP
+	depends on I2C
+	select REGMAP
 	help
 	  This option enables system support for the Mellanox Technologies
 	  platform. The Mellanox systems provide data center networking
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3eae3aa5ad1d..cd10880378a6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1521,6 +1521,27 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		}
 	}
 
+	/*
+	 * If there is no mechanism for controlling the regulator then
+	 * flag it as always_on so we don't end up duplicating checks
+	 * for this so much.  Note that we could control the state of
+	 * a supply to control the output on a regulator that has no
+	 * direct control.
+	 */
+	if (!rdev->ena_pin && !ops->enable) {
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
+		if (rdev->supply)
+			rdev->constraints->always_on =
+				rdev->supply->rdev->constraints->always_on;
+		else
+			rdev->constraints->always_on = true;
+	}
+
+	if (rdev->desc->off_on_delay)
+		rdev->last_off = ktime_get_boottime();
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
@@ -1554,8 +1575,6 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
-	} else if (rdev->desc->off_on_delay) {
-		rdev->last_off = ktime_get();
 	}
 
 	print_constraints(rdev);
@@ -2610,7 +2629,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 		 * this regulator was disabled.
 		 */
 		ktime_t end = ktime_add_us(rdev->last_off, rdev->desc->off_on_delay);
-		s64 remaining = ktime_us_delta(end, ktime_get());
+		s64 remaining = ktime_us_delta(end, ktime_get_boottime());
 
 		if (remaining > 0)
 			_regulator_enable_delay(remaining);
@@ -2849,7 +2868,7 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 0165dad80300..28b201c44326 100644
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
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 650210d2abb4..02d7ab119f80 100644
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
diff --git a/drivers/staging/rtl8723bs/core/rtw_ap.c b/drivers/staging/rtl8723bs/core/rtw_ap.c
index 6064dd6a76b4..674592e914e2 100644
--- a/drivers/staging/rtl8723bs/core/rtw_ap.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ap.c
@@ -891,7 +891,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 		&ie_len,
 		(pbss_network->ie_length - _BEACON_IE_OFFSET_)
 	);
-	if (p !=  NULL) {
+	if (p) {
 		memcpy(supportRate, p + 2, ie_len);
 		supportRateNum = ie_len;
 	}
@@ -903,7 +903,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 		&ie_len,
 		pbss_network->ie_length - _BEACON_IE_OFFSET_
 	);
-	if (p !=  NULL) {
+	if (p) {
 		memcpy(supportRate + supportRateNum, p + 2, ie_len);
 		supportRateNum += ie_len;
 	}
@@ -991,7 +991,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 			break;
 		}
 
-		if ((p == NULL) || (ie_len == 0))
+		if (!p || ie_len == 0)
 			break;
 	}
 
@@ -1021,7 +1021,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 				break;
 			}
 
-			if ((p == NULL) || (ie_len == 0))
+			if (!p || ie_len == 0)
 				break;
 		}
 	}
@@ -1145,7 +1145,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	psta = rtw_get_stainfo(&padapter->stapriv, pbss_network->mac_address);
 	if (!psta) {
 		psta = rtw_alloc_stainfo(&padapter->stapriv, pbss_network->mac_address);
-		if (psta == NULL)
+		if (!psta)
 			return _FAIL;
 	}
 
@@ -1275,7 +1275,7 @@ u8 rtw_ap_set_pairwise_key(struct adapter *padapter, struct sta_info *psta)
 	}
 
 	psetstakey_para = rtw_zmalloc(sizeof(struct set_stakey_parm));
-	if (psetstakey_para == NULL) {
+	if (!psetstakey_para) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1311,12 +1311,12 @@ static int rtw_ap_set_key(
 	int res = _SUCCESS;
 
 	pcmd = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (pcmd == NULL) {
+	if (!pcmd) {
 		res = _FAIL;
 		goto exit;
 	}
 	psetkeyparm = rtw_zmalloc(sizeof(struct setkey_parm));
-	if (psetkeyparm == NULL) {
+	if (!psetkeyparm) {
 		kfree(pcmd);
 		res = _FAIL;
 		goto exit;
@@ -1474,11 +1474,11 @@ static void update_bcn_wps_ie(struct adapter *padapter)
 		&wps_ielen
 	);
 
-	if (pwps_ie == NULL || wps_ielen == 0)
+	if (!pwps_ie || wps_ielen == 0)
 		return;
 
 	pwps_ie_src = pmlmepriv->wps_beacon_ie;
-	if (pwps_ie_src == NULL)
+	if (!pwps_ie_src)
 		return;
 
 	wps_offset = (uint)(pwps_ie - ie);
diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index 93e3a4c9e115..5f4f603b3b36 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -251,7 +251,7 @@ int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
 {
 	unsigned long irqL;
 
-	if (obj == NULL)
+	if (!obj)
 		goto exit;
 
 	/* spin_lock_bh(&queue->lock); */
@@ -319,7 +319,7 @@ int rtw_enqueue_cmd(struct cmd_priv *pcmdpriv, struct cmd_obj *cmd_obj)
 	int res = _FAIL;
 	struct adapter *padapter = pcmdpriv->padapter;
 
-	if (cmd_obj == NULL)
+	if (!cmd_obj)
 		goto exit;
 
 	cmd_obj->padapter = padapter;
@@ -484,7 +484,7 @@ int rtw_cmd_thread(void *context)
 		/* call callback function for post-processed */
 		if (pcmd->cmdcode < ARRAY_SIZE(rtw_cmd_callback)) {
 			pcmd_callback = rtw_cmd_callback[pcmd->cmdcode].callback;
-			if (pcmd_callback == NULL) {
+			if (!pcmd_callback) {
 				rtw_free_cmd_obj(pcmd);
 			} else {
 				/* todo: !!! fill rsp_buf to pcmd->rsp if (pcmd->rsp!= NULL) */
@@ -503,7 +503,7 @@ int rtw_cmd_thread(void *context)
 	/*  free all cmd_obj resources */
 	do {
 		pcmd = rtw_dequeue_cmd(pcmdpriv);
-		if (pcmd == NULL) {
+		if (!pcmd) {
 			rtw_unregister_cmd_alive(padapter);
 			break;
 		}
@@ -542,11 +542,11 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 		rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_SCAN, 1);
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL)
+	if (!ph2c)
 		return _FAIL;
 
 	psurveyPara = rtw_zmalloc(sizeof(struct sitesurvey_parm));
-	if (psurveyPara == NULL) {
+	if (!psurveyPara) {
 		kfree(ph2c);
 		return _FAIL;
 	}
@@ -604,13 +604,13 @@ u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pbsetdataratepara = rtw_zmalloc(sizeof(struct setdatarate_parm));
-	if (pbsetdataratepara == NULL) {
+	if (!pbsetdataratepara) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -640,7 +640,7 @@ u8 rtw_createbss_cmd(struct adapter  *padapter)
 	u8 res = _SUCCESS;
 
 	pcmd = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (pcmd == NULL) {
+	if (!pcmd) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -673,7 +673,7 @@ int rtw_startbss_cmd(struct adapter  *padapter, int flags)
 	} else {
 		/* need enqueue, prepare cmd_obj and enqueue */
 		pcmd = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (pcmd == NULL) {
+		if (!pcmd) {
 			res = _FAIL;
 			goto exit;
 		}
@@ -725,7 +725,7 @@ u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 	u8 *ptmp = NULL;
 
 	pcmd = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (pcmd == NULL) {
+	if (!pcmd) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -837,7 +837,7 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms, bool enqueu
 
 	/* prepare cmd parameter */
 	param = rtw_zmalloc(sizeof(*param));
-	if (param == NULL) {
+	if (!param) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -846,7 +846,7 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms, bool enqueu
 	if (enqueue) {
 		/* need enqueue, prepare cmd_obj and enqueue */
 		cmdobj = rtw_zmalloc(sizeof(*cmdobj));
-		if (cmdobj == NULL) {
+		if (!cmdobj) {
 			res = _FAIL;
 			kfree(param);
 			goto exit;
@@ -874,7 +874,7 @@ u8 rtw_setopmode_cmd(struct adapter  *padapter, enum ndis_802_11_network_infrast
 
 	psetop = rtw_zmalloc(sizeof(struct setopmode_parm));
 
-	if (psetop == NULL) {
+	if (!psetop) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -882,7 +882,7 @@ u8 rtw_setopmode_cmd(struct adapter  *padapter, enum ndis_802_11_network_infrast
 
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (ph2c == NULL) {
+		if (!ph2c) {
 			kfree(psetop);
 			res = _FAIL;
 			goto exit;
@@ -910,7 +910,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 	u8 res = _SUCCESS;
 
 	psetstakey_para = rtw_zmalloc(sizeof(struct set_stakey_parm));
-	if (psetstakey_para == NULL) {
+	if (!psetstakey_para) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -932,14 +932,14 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (ph2c == NULL) {
+		if (!ph2c) {
 			kfree(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
 
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
-		if (psetstakey_rsp == NULL) {
+		if (!psetstakey_rsp) {
 			kfree(ph2c);
 			kfree(psetstakey_para);
 			res = _FAIL;
@@ -977,20 +977,20 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 enqueu
 		}
 	} else {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (ph2c == NULL) {
+		if (!ph2c) {
 			res = _FAIL;
 			goto exit;
 		}
 
 		psetstakey_para = rtw_zmalloc(sizeof(struct set_stakey_parm));
-		if (psetstakey_para == NULL) {
+		if (!psetstakey_para) {
 			kfree(ph2c);
 			res = _FAIL;
 			goto exit;
 		}
 
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
-		if (psetstakey_rsp == NULL) {
+		if (!psetstakey_rsp) {
 			kfree(ph2c);
 			kfree(psetstakey_para);
 			res = _FAIL;
@@ -1022,13 +1022,13 @@ u8 rtw_addbareq_cmd(struct adapter *padapter, u8 tid, u8 *addr)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	paddbareq_parm = rtw_zmalloc(sizeof(struct addBaReq_parm));
-	if (paddbareq_parm == NULL) {
+	if (!paddbareq_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1054,13 +1054,13 @@ u8 rtw_reset_securitypriv_cmd(struct adapter *padapter)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1089,13 +1089,13 @@ u8 rtw_free_assoc_resources_cmd(struct adapter *padapter)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1125,13 +1125,13 @@ u8 rtw_dynamic_chk_wk_cmd(struct adapter *padapter)
 
 	/* only  primary padapter does this cmd */
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1173,7 +1173,7 @@ u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue, u8 swconf
 
 	/* prepare cmd parameter */
 	setChannelPlan_param = rtw_zmalloc(sizeof(struct SetChannelPlan_param));
-	if (setChannelPlan_param == NULL) {
+	if (!setChannelPlan_param) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -1182,7 +1182,7 @@ u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue, u8 swconf
 	if (enqueue) {
 		/* need enqueue, prepare cmd_obj and enqueue */
 		pcmdobj = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (pcmdobj == NULL) {
+		if (!pcmdobj) {
 			kfree(setChannelPlan_param);
 			res = _FAIL;
 			goto exit;
@@ -1432,13 +1432,13 @@ u8 rtw_lps_ctrl_wk_cmd(struct adapter *padapter, u8 lps_ctrl_type, u8 enqueue)
 
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (ph2c == NULL) {
+		if (!ph2c) {
 			res = _FAIL;
 			goto exit;
 		}
 
 		pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-		if (pdrvextra_cmd_parm == NULL) {
+		if (!pdrvextra_cmd_parm) {
 			kfree(ph2c);
 			res = _FAIL;
 			goto exit;
@@ -1474,13 +1474,13 @@ u8 rtw_dm_in_lps_wk_cmd(struct adapter *padapter)
 
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1540,13 +1540,13 @@ u8 rtw_dm_ra_mask_wk_cmd(struct adapter *padapter, u8 *psta)
 
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1575,13 +1575,13 @@ u8 rtw_ps_cmd(struct adapter *padapter)
 	u8 res = _SUCCESS;
 
 	ppscmd = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ppscmd == NULL) {
+	if (!ppscmd) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ppscmd);
 		res = _FAIL;
 		goto exit;
@@ -1647,13 +1647,13 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1741,13 +1741,13 @@ u8 rtw_c2h_packet_wk_cmd(struct adapter *padapter, u8 *pbuf, u16 length)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1776,13 +1776,13 @@ u8 rtw_c2h_wk_cmd(struct adapter *padapter, u8 *c2h_evt)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	pdrvextra_cmd_parm = rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
-	if (pdrvextra_cmd_parm == NULL) {
+	if (!pdrvextra_cmd_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -1957,7 +1957,7 @@ void rtw_createbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 	struct wlan_bssid_ex *pnetwork = (struct wlan_bssid_ex *)pcmd->parmbuf;
 	struct wlan_network *tgt_network = &(pmlmepriv->cur_network);
 
-	if (pcmd->parmbuf == NULL)
+	if (!pcmd->parmbuf)
 		goto exit;
 
 	if (pcmd->res != H2C_SUCCESS)
@@ -1980,9 +1980,9 @@ void rtw_createbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 	} else {
 		pwlan = rtw_alloc_network(pmlmepriv);
 		spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
-		if (pwlan == NULL) {
+		if (!pwlan) {
 			pwlan = rtw_get_oldest_wlan_network(&pmlmepriv->scanned_queue);
-			if (pwlan == NULL) {
+			if (!pwlan) {
 				spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 				goto createbss_cmd_fail;
 			}
diff --git a/drivers/staging/rtl8723bs/core/rtw_ioctl_set.c b/drivers/staging/rtl8723bs/core/rtw_ioctl_set.c
index 5cfde7176617..8c11daff2d59 100644
--- a/drivers/staging/rtl8723bs/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ioctl_set.c
@@ -370,7 +370,7 @@ u8 rtw_set_802_11_bssid_list_scan(struct adapter *padapter, struct ndis_802_11_s
 	struct	mlme_priv 	*pmlmepriv = &padapter->mlmepriv;
 	u8 res = true;
 
-	if (padapter == NULL) {
+	if (!padapter) {
 		res = false;
 		goto exit;
 	}
@@ -481,7 +481,7 @@ u16 rtw_get_cur_max_rate(struct adapter *adapter)
 		return 0;
 
 	psta = rtw_get_stainfo(&adapter->stapriv, get_bssid(pmlmepriv));
-	if (psta == NULL)
+	if (!psta)
 		return 0;
 
 	short_GI = query_ra_short_GI(psta);
diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 952c3e14d1b3..26c40042d2be 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -439,7 +439,7 @@ struct	wlan_network	*rtw_get_oldest_wlan_network(struct __queue *scanned_queue)
 		pwlan = list_entry(plist, struct wlan_network, list);
 
 		if (!pwlan->fixed) {
-			if (oldest == NULL || time_after(oldest->last_scanned, pwlan->last_scanned))
+			if (!oldest || time_after(oldest->last_scanned, pwlan->last_scanned))
 				oldest = pwlan;
 		}
 	}
@@ -542,7 +542,7 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 			/* TODO: don't select network in the same ess as oldest if it's new enough*/
 		}
 
-		if (oldest == NULL || time_after(oldest->last_scanned, pnetwork->last_scanned))
+		if (!oldest || time_after(oldest->last_scanned, pnetwork->last_scanned))
 			oldest = pnetwork;
 
 	}
@@ -1816,7 +1816,7 @@ static int rtw_check_join_candidate(struct mlme_priv *mlme
 			goto exit;
 	}
 
-	if (*candidate == NULL || (*candidate)->network.rssi < competitor->network.rssi) {
+	if (!*candidate || (*candidate)->network.rssi < competitor->network.rssi) {
 		*candidate = competitor;
 		updated = true;
 	}
diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index 1a4b4c75c4bf..e923f306cf0c 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -742,11 +742,11 @@ unsigned int OnAuth(struct adapter *padapter, union recv_frame *precv_frame)
 	}
 
 	pstat = rtw_get_stainfo(pstapriv, sa);
-	if (pstat == NULL) {
+	if (!pstat) {
 
 		/*  allocate a new one */
 		pstat = rtw_alloc_stainfo(pstapriv, sa);
-		if (pstat == NULL) {
+		if (!pstat) {
 			status = WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA;
 			goto auth_fail;
 		}
@@ -814,7 +814,7 @@ unsigned int OnAuth(struct adapter *padapter, union recv_frame *precv_frame)
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + 4 + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&ie_len,
 					len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_ - 4);
 
-			if ((p == NULL) || (ie_len <= 0)) {
+			if (!p || ie_len <= 0) {
 				status = WLAN_STATUS_CHALLENGE_FAIL;
 				goto auth_fail;
 			}
@@ -1034,7 +1034,7 @@ unsigned int OnAssocReq(struct adapter *padapter, union recv_frame *precv_frame)
 
 	/*  check if the supported rate is ok */
 	p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + ie_offset, WLAN_EID_SUPP_RATES, &ie_len, pkt_len - WLAN_HDR_A3_LEN - ie_offset);
-	if (p == NULL) {
+	if (!p) {
 		/*  use our own rate set as statoin used */
 		/* memcpy(supportRate, AP_BSSRATE, AP_BSSRATE_LEN); */
 		/* supportRateNum = AP_BSSRATE_LEN; */
@@ -1047,7 +1047,7 @@ unsigned int OnAssocReq(struct adapter *padapter, union recv_frame *precv_frame)
 
 		p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + ie_offset, WLAN_EID_EXT_SUPP_RATES, &ie_len,
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
-		if (p !=  NULL) {
+		if (p) {
 
 			if (supportRateNum <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
@@ -1294,7 +1294,7 @@ unsigned int OnAssocReq(struct adapter *padapter, union recv_frame *precv_frame)
 	/* get a unique AID */
 	if (pstat->aid == 0) {
 		for (pstat->aid = 1; pstat->aid <= NUM_STA; pstat->aid++)
-			if (pstapriv->sta_aid[pstat->aid - 1] == NULL)
+			if (!pstapriv->sta_aid[pstat->aid - 1])
 				break;
 
 		/* if (pstat->aid > NUM_STA) { */
@@ -1940,7 +1940,7 @@ static struct xmit_frame *_alloc_mgtxmitframe(struct xmit_priv *pxmitpriv, bool
 		goto exit;
 
 	pxmitbuf = rtw_alloc_xmitbuf_ext(pxmitpriv);
-	if (pxmitbuf == NULL) {
+	if (!pxmitbuf) {
 		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		pmgntframe = NULL;
 		goto exit;
@@ -2293,7 +2293,7 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	struct wlan_bssid_ex		*cur_network = &(pmlmeinfo->network);
 	unsigned int	rate_len;
 
-	if (da == NULL)
+	if (!da)
 		return;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
@@ -2617,7 +2617,7 @@ void issue_auth(struct adapter *padapter, struct sta_info *psta, unsigned short
 	__le16 le_tmp;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
+	if (!pmgntframe)
 		return;
 
 	/* update attribute */
@@ -2748,7 +2748,7 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 	__le16 lestatus, le_tmp;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
+	if (!pmgntframe)
 		return;
 
 	/* update attribute */
@@ -2836,7 +2836,7 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 				break;
 			}
 
-			if ((pbuf == NULL) || (ie_len == 0)) {
+			if (!pbuf || ie_len == 0) {
 				break;
 			}
 		}
@@ -2880,7 +2880,7 @@ void issue_assocreq(struct adapter *padapter)
 	u8 vs_ie_length = 0;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
+	if (!pmgntframe)
 		goto exit;
 
 	/* update attribute */
@@ -3057,7 +3057,7 @@ static int _issue_nulldata(struct adapter *padapter, unsigned char *da,
 	pmlmeinfo = &(pmlmeext->mlmext_info);
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
+	if (!pmgntframe)
 		goto exit;
 
 	/* update attribute */
@@ -3196,7 +3196,7 @@ static int _issue_qos_nulldata(struct adapter *padapter, unsigned char *da,
 	struct mlme_ext_info *pmlmeinfo = &(pmlmeext->mlmext_info);
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
+	if (!pmgntframe)
 		goto exit;
 
 	/* update attribute */
@@ -3309,7 +3309,7 @@ static int _issue_deauth(struct adapter *padapter, unsigned char *da,
 	__le16 le_tmp;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL) {
+	if (!pmgntframe) {
 		goto exit;
 	}
 
@@ -3635,7 +3635,7 @@ static void issue_action_BSSCoexistPacket(struct adapter *padapter)
 	action = ACT_PUBLIC_BSSCOEXIST;
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL) {
+	if (!pmgntframe) {
 		return;
 	}
 
@@ -3702,7 +3702,7 @@ static void issue_action_BSSCoexistPacket(struct adapter *padapter)
 			pbss_network = (struct wlan_bssid_ex *)&pnetwork->network;
 
 			p = rtw_get_ie(pbss_network->ies + _FIXED_IE_LENGTH_, WLAN_EID_HT_CAPABILITY, &len, pbss_network->ie_length - _FIXED_IE_LENGTH_);
-			if ((p == NULL) || (len == 0)) {/* non-HT */
+			if (!p || len == 0) {/* non-HT */
 
 				if (pbss_network->configuration.ds_config <= 0)
 					continue;
@@ -3765,7 +3765,7 @@ unsigned int send_delba(struct adapter *padapter, u8 initiator, u8 *addr)
 			return _SUCCESS;
 
 	psta = rtw_get_stainfo(pstapriv, addr);
-	if (psta == NULL)
+	if (!psta)
 		return _SUCCESS;
 
 	if (initiator == 0) {/*  recipient */
@@ -4637,13 +4637,13 @@ void report_del_sta_event(struct adapter *padapter, unsigned char *MacAddr, unsi
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
 	pcmd_obj = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (pcmd_obj == NULL) {
+	if (!pcmd_obj) {
 		return;
 	}
 
 	cmdsz = (sizeof(struct stadel_event) + sizeof(struct C2HEvent_Header));
 	pevtcmd = rtw_zmalloc(cmdsz);
-	if (pevtcmd == NULL) {
+	if (!pevtcmd) {
 		kfree(pcmd_obj);
 		return;
 	}
@@ -4689,12 +4689,12 @@ void report_add_sta_event(struct adapter *padapter, unsigned char *MacAddr, int
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
 	pcmd_obj = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (pcmd_obj == NULL)
+	if (!pcmd_obj)
 		return;
 
 	cmdsz = (sizeof(struct stassoc_event) + sizeof(struct C2HEvent_Header));
 	pevtcmd = rtw_zmalloc(cmdsz);
-	if (pevtcmd == NULL) {
+	if (!pevtcmd) {
 		kfree(pcmd_obj);
 		return;
 	}
@@ -5143,12 +5143,12 @@ void survey_timer_hdl(struct timer_list *t)
 		}
 
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-		if (ph2c == NULL) {
+		if (!ph2c) {
 			goto exit_survey_timer_hdl;
 		}
 
 		psurveyPara = rtw_zmalloc(sizeof(struct sitesurvey_parm));
-		if (psurveyPara == NULL) {
+		if (!psurveyPara) {
 			kfree(ph2c);
 			goto exit_survey_timer_hdl;
 		}
@@ -5777,7 +5777,7 @@ u8 chk_bmc_sleepq_cmd(struct adapter *padapter)
 	u8 res = _SUCCESS;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -5801,13 +5801,13 @@ u8 set_tx_beacon_cmd(struct adapter *padapter)
 	int len_diff = 0;
 
 	ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
-	if (ph2c == NULL) {
+	if (!ph2c) {
 		res = _FAIL;
 		goto exit;
 	}
 
 	ptxBeacon_parm = rtw_zmalloc(sizeof(struct Tx_Beacon_param));
-	if (ptxBeacon_parm == NULL) {
+	if (!ptxBeacon_parm) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
@@ -5867,7 +5867,7 @@ u8 mlme_evt_hdl(struct adapter *padapter, unsigned char *pbuf)
 	void (*event_callback)(struct adapter *dev, u8 *pbuf);
 	struct evt_priv *pevt_priv = &(padapter->evtpriv);
 
-	if (pbuf == NULL)
+	if (!pbuf)
 		goto _abort_event_;
 
 	peventbuf = (uint *)pbuf;
diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index b050bf62e3b9..ac731415f733 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -51,7 +51,7 @@ void rtw_wep_encrypt(struct adapter *padapter, u8 *pxmitframe)
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct arc4_ctx *ctx = &psecuritypriv->xmit_arc4_ctx;
 
-	if (((struct xmit_frame *)pxmitframe)->buf_addr == NULL)
+	if (!((struct xmit_frame *)pxmitframe)->buf_addr)
 		return;
 
 	hw_hdr_offset = TXDESC_OFFSET;
@@ -476,7 +476,7 @@ u32 rtw_tkip_encrypt(struct adapter *padapter, u8 *pxmitframe)
 	struct arc4_ctx *ctx = &psecuritypriv->xmit_arc4_ctx;
 	u32 res = _SUCCESS;
 
-	if (((struct xmit_frame *)pxmitframe)->buf_addr == NULL)
+	if (!((struct xmit_frame *)pxmitframe)->buf_addr)
 		return _FAIL;
 
 	hw_hdr_offset = TXDESC_OFFSET;
@@ -1043,7 +1043,7 @@ u32 rtw_aes_encrypt(struct adapter *padapter, u8 *pxmitframe)
 
 	u32 res = _SUCCESS;
 
-	if (((struct xmit_frame *)pxmitframe)->buf_addr == NULL)
+	if (!((struct xmit_frame *)pxmitframe)->buf_addr)
 		return _FAIL;
 
 	hw_hdr_offset = TXDESC_OFFSET;
diff --git a/drivers/staging/rtl8723bs/include/rtw_security.h b/drivers/staging/rtl8723bs/include/rtw_security.h
index a68b73858462..7587fa888527 100644
--- a/drivers/staging/rtl8723bs/include/rtw_security.h
+++ b/drivers/staging/rtl8723bs/include/rtw_security.h
@@ -107,13 +107,13 @@ struct security_priv {
 
 	u32 dot118021XGrpPrivacy;	/*  This specify the privacy algthm. used for Grp key */
 	u32 dot118021XGrpKeyid;		/*  key id used for Grp Key (tx key index) */
-	union Keytype	dot118021XGrpKey[BIP_MAX_KEYID];	/*  802.1x Group Key, for inx0 and inx1 */
-	union Keytype	dot118021XGrptxmickey[BIP_MAX_KEYID];
-	union Keytype	dot118021XGrprxmickey[BIP_MAX_KEYID];
+	union Keytype	dot118021XGrpKey[BIP_MAX_KEYID + 1];	/*  802.1x Group Key, for inx0 and inx1 */
+	union Keytype	dot118021XGrptxmickey[BIP_MAX_KEYID + 1];
+	union Keytype	dot118021XGrprxmickey[BIP_MAX_KEYID + 1];
 	union pn48		dot11Grptxpn;			/*  PN48 used for Grp Key xmit. */
 	union pn48		dot11Grprxpn;			/*  PN48 used for Grp Key recv. */
 	u32 dot11wBIPKeyid;						/*  key id used for BIP Key (tx key index) */
-	union Keytype	dot11wBIPKey[6];		/*  BIP Key, for index4 and index5 */
+	union Keytype	dot11wBIPKey[BIP_MAX_KEYID + 1];	/*  BIP Key, for index4 and index5 */
 	union pn48		dot11wBIPtxpn;			/*  PN48 used for Grp Key xmit. */
 	union pn48		dot11wBIPrxpn;			/*  PN48 used for Grp Key recv. */
 
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 499ac3a77512..b33424a9e83b 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -113,13 +113,10 @@ static struct ieee80211_supported_band *rtw_spt_band_alloc(
 	struct ieee80211_supported_band *spt_band = NULL;
 	int n_channels, n_bitrates;
 
-	if (band == NL80211_BAND_2GHZ)
-	{
+	if (band == NL80211_BAND_2GHZ) {
 		n_channels = RTW_2G_CHANNELS_NUM;
 		n_bitrates = RTW_G_RATES_NUM;
-	}
-	else
-	{
+	} else {
 		goto exit;
 	}
 
@@ -135,8 +132,7 @@ static struct ieee80211_supported_band *rtw_spt_band_alloc(
 	spt_band->n_channels = n_channels;
 	spt_band->n_bitrates = n_bitrates;
 
-	if (band == NL80211_BAND_2GHZ)
-	{
+	if (band == NL80211_BAND_2GHZ) {
 		rtw_2g_channels_init(spt_band->channels);
 		rtw_2g_rates_init(spt_band->bitrates);
 	}
@@ -235,8 +231,7 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 	{
 		u16 wapi_len = 0;
 
-		if (rtw_get_wapi_ie(pnetwork->network.ies, pnetwork->network.ie_length, NULL, &wapi_len) > 0)
-		{
+		if (rtw_get_wapi_ie(pnetwork->network.ies, pnetwork->network.ie_length, NULL, &wapi_len) > 0) {
 			if (wapi_len > 0)
 				goto exit;
 		}
@@ -244,8 +239,7 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 
 	/* To reduce PBC Overlap rate */
 	/* spin_lock_bh(&pwdev_priv->scan_req_lock); */
-	if (adapter_wdev_data(padapter)->scan_request)
-	{
+	if (adapter_wdev_data(padapter)->scan_request) {
 		u8 *psr = NULL, sr = 0;
 		struct ndis_802_11_ssid *pssid = &pnetwork->network.ssid;
 		struct cfg80211_scan_request *request = adapter_wdev_data(padapter)->scan_request;
@@ -258,14 +252,12 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 		if (wpsie && wpsielen > 0)
 			psr = rtw_get_wps_attr_content(wpsie,  wpsielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
 
-		if (sr != 0)
-		{
-			if (request->n_ssids == 1 && request->n_channels == 1) /*  it means under processing WPS */
-			{
+		if (sr != 0) {
+			/* it means under processing WPS */
+			if (request->n_ssids == 1 && request->n_channels == 1) {
 				if (ssids[0].ssid_len != 0 &&
 				    (pssid->ssid_length != ssids[0].ssid_len ||
-				     memcmp(pssid->ssid, ssids[0].ssid, ssids[0].ssid_len)))
-				{
+				     memcmp(pssid->ssid, ssids[0].ssid, ssids[0].ssid_len))) {
 					if (psr)
 						*psr = 0; /* clear sr */
 				}
@@ -358,7 +350,7 @@ int rtw_cfg80211_check_bss(struct adapter *padapter)
 	bss = cfg80211_get_bss(padapter->rtw_wdev->wiphy, notify_channel,
 			pnetwork->mac_address, pnetwork->ssid.ssid,
 			pnetwork->ssid.ssid_length,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	cfg80211_put_bss(padapter->rtw_wdev->wiphy, bss);
 
@@ -375,23 +367,18 @@ void rtw_cfg80211_ibss_indicate_connect(struct adapter *padapter)
 	struct ieee80211_channel *chan;
 
 	if (pwdev->iftype != NL80211_IFTYPE_ADHOC)
-	{
 		return;
-	}
 
 	if (!rtw_cfg80211_check_bss(padapter)) {
 		struct wlan_bssid_ex  *pnetwork = &(padapter->mlmeextpriv.mlmext_info.network);
 		struct wlan_network *scanned = pmlmepriv->cur_network_scanned;
 
-		if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true)
-		{
+		if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true) {
 
 			memcpy(&cur_network->network, pnetwork, sizeof(struct wlan_bssid_ex));
 			rtw_cfg80211_inform_bss(padapter, cur_network);
-		}
-		else
-		{
-			if (scanned == NULL) {
+		} else {
+			if (!scanned) {
 				rtw_warn_on(1);
 				return;
 			}
@@ -432,7 +419,7 @@ void rtw_cfg80211_indicate_connect(struct adapter *padapter)
 		struct wlan_bssid_ex  *pnetwork = &(padapter->mlmeextpriv.mlmext_info.network);
 		struct wlan_network *scanned = pmlmepriv->cur_network_scanned;
 
-		if (scanned == NULL) {
+		if (!scanned) {
 			rtw_warn_on(1);
 			goto check_bss;
 		}
@@ -473,9 +460,7 @@ void rtw_cfg80211_indicate_connect(struct adapter *padapter)
 		roam_info.resp_ie_len =
 			pmlmepriv->assoc_rsp_len-sizeof(struct ieee80211_hdr_3addr)-6;
 		cfg80211_roamed(padapter->pnetdev, &roam_info, GFP_ATOMIC);
-	}
-	else
-	{
+	} else {
 		cfg80211_connect_result(padapter->pnetdev, cur_network->network.mac_address
 			, pmlmepriv->assoc_req+sizeof(struct ieee80211_hdr_3addr)+2
 			, pmlmepriv->assoc_req_len-sizeof(struct ieee80211_hdr_3addr)-2
@@ -527,51 +512,41 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
 
-	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len)
-	{
+	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len) {
 		ret =  -EINVAL;
 		goto exit;
 	}
 
 	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
 	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff)
-	{
-		if (param->u.crypt.idx >= WEP_KEYS)
-		{
+	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+		if (param->u.crypt.idx >= WEP_KEYS) {
 			ret = -EINVAL;
 			goto exit;
 		}
-	}
-	else
-	{
+	} else {
 		psta = rtw_get_stainfo(pstapriv, param->sta_addr);
 		if (!psta)
 			/* ret = -EINVAL; */
 			goto exit;
 	}
 
-	if (strcmp(param->u.crypt.alg, "none") == 0 && (psta == NULL))
+	if (strcmp(param->u.crypt.alg, "none") == 0 && !psta)
 		goto exit;
 
-	if (strcmp(param->u.crypt.alg, "WEP") == 0 && (psta == NULL))
-	{
+	if (strcmp(param->u.crypt.alg, "WEP") == 0 && !psta) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0))
-		{
+		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
 			ret = -EINVAL;
 			goto exit;
 		}
 
 		if (wep_key_len > 0)
-		{
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-		}
 
-		if (psecuritypriv->bWepDefaultKeyIdxSet == 0)
-		{
+		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
 			/* wep default key has not been set, so use this key index as default key. */
 
 			psecuritypriv->dot11AuthAlgrthm = dot11AuthAlgrthm_Auto;
@@ -579,8 +554,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 
-			if (wep_key_len == 13)
-			{
+			if (wep_key_len == 13) {
 				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 			}
@@ -598,24 +572,18 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 	}
 
-
-	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) /* group key */
-	{
-		if (param->u.crypt.set_tx == 0) /* group key */
-		{
-			if (strcmp(param->u.crypt.alg, "WEP") == 0)
-			{
+	/* group key */
+	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
+		/* group key */
+		if (param->u.crypt.set_tx == 0) {
+			if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 				if (param->u.crypt.key_len == 13)
-				{
 						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-				}
 
-			}
-			else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-			{
+			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
@@ -627,15 +595,11 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 				psecuritypriv->busetkipkey = true;
 
-			}
-			else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-			{
+			} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-			}
-			else
-			{
+			} else {
 				psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 			}
 
@@ -648,8 +612,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
 
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta)
-			{
+			if (pbcmc_sta) {
 				pbcmc_sta->ieee8021x_blocked = false;
 				pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
 			}
@@ -660,24 +623,16 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 	}
 
-	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) /*  psk/802_1x */
-	{
-		if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		{
-			if (param->u.crypt.set_tx == 1) /* pairwise key */
-			{
+	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) { /*  psk/802_1x */
+		if (check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
+			if (param->u.crypt.set_tx == 1) { /* pairwise key */
 				memcpy(psta->dot118021x_UncstKey.skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
-				if (strcmp(param->u.crypt.alg, "WEP") == 0)
-				{
+				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 					psta->dot118021XPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
-					{
 						psta->dot118021XPrivacy = _WEP104_;
-					}
-				}
-				else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 					psta->dot118021XPrivacy = _TKIP_;
 
 					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
@@ -687,14 +642,10 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 					psecuritypriv->busetkipkey = true;
 
-				}
-				else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 
 					psta->dot118021XPrivacy = _AES_;
-				}
-				else
-				{
+				} else {
 					psta->dot118021XPrivacy = _NO_PRIVACY_;
 				}
 
@@ -704,21 +655,14 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 				psta->bpairwise_key_installed = true;
 
-			}
-			else/* group key??? */
-			{
-				if (strcmp(param->u.crypt.alg, "WEP") == 0)
-				{
+			} else { /* group key??? */
+				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
-					{
 						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-					}
-				}
-				else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
@@ -730,15 +674,11 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 					psecuritypriv->busetkipkey = true;
 
-				}
-				else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-				}
-				else
-				{
+				} else {
 					psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 				}
 
@@ -751,8 +691,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 				rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
 
 				pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-				if (pbcmc_sta)
-				{
+				if (pbcmc_sta) {
 					pbcmc_sta->ieee8021x_blocked = false;
 					pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
 				}
@@ -772,6 +711,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len;
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -780,43 +720,39 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
 
-	if (param_len < (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len)
-	{
+	if (param_len < (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len) {
 		ret =  -EINVAL;
 		goto exit;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff)
-	{
-		if (param->u.crypt.idx >= WEP_KEYS
-			|| param->u.crypt.idx >= BIP_MAX_KEYID
-		)
-		{
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		{
+	if (param->sta_addr[0] != 0xff || param->sta_addr[1] != 0xff ||
+	    param->sta_addr[2] != 0xff || param->sta_addr[3] != 0xff ||
+	    param->sta_addr[4] != 0xff || param->sta_addr[5] != 0xff) {
 		ret = -EINVAL;
 		goto exit;
 	}
-	}
 
 	if (strcmp(param->u.crypt.alg, "WEP") == 0)
-	{
+		max_idx = WEP_KEYS - 1;
+	else
+		max_idx = BIP_MAX_KEYID;
+
+	if (param->u.crypt.idx > max_idx) {
+		netdev_err(dev, "Error crypt.idx %d > %d\n", param->u.crypt.idx, max_idx);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0))
-		{
+		if (wep_key_len <= 0) {
 			ret = -EINVAL;
 			goto exit;
 		}
 
-		if (psecuritypriv->bWepDefaultKeyIdxSet == 0)
-		{
+		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
 			/* wep default key has not been set, so use this key index as default key. */
 
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
@@ -825,8 +761,7 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 
-			if (wep_key_len == 13)
-			{
+			if (wep_key_len == 13) {
 				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 			}
@@ -843,13 +778,11 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 		goto exit;
 	}
 
-	if (padapter->securitypriv.dot11AuthAlgrthm == dot11AuthAlgrthm_8021X) /*  802_1x */
-	{
+	if (padapter->securitypriv.dot11AuthAlgrthm == dot11AuthAlgrthm_8021X) { /*  802_1x */
 		struct sta_info *psta, *pbcmc_sta;
 		struct sta_priv *pstapriv = &padapter->stapriv;
 
-		if (check_fwstate(pmlmepriv, WIFI_STATION_STATE | WIFI_MP_STATE) == true) /* sta mode */
-		{
+		if (check_fwstate(pmlmepriv, WIFI_STATION_STATE | WIFI_MP_STATE) == true) { /* sta mode */
 			psta = rtw_get_stainfo(pstapriv, get_bssid(pmlmepriv));
 			if (psta) {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
@@ -858,18 +791,15 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 
 
 				if ((padapter->securitypriv.ndisencryptstatus == Ndis802_11Encryption2Enabled) ||
-						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled))
-				{
+						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled)) {
 					psta->dot118021XPrivacy = padapter->securitypriv.dot11PrivacyAlgrthm;
 				}
 
-				if (param->u.crypt.set_tx == 1)/* pairwise key */
-				{
+				if (param->u.crypt.set_tx == 1) { /* pairwise key */
 
 					memcpy(psta->dot118021x_UncstKey.skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
-					if (strcmp(param->u.crypt.alg, "TKIP") == 0)/* set mic key */
-					{
+					if (strcmp(param->u.crypt.alg, "TKIP") == 0) { /* set mic key */
 						/* DEBUG_ERR(("\nset key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len)); */
 						memcpy(psta->dot11tkiptxmickey.skey, &(param->u.crypt.key[16]), 8);
 						memcpy(psta->dot11tkiprxmickey.skey, &(param->u.crypt.key[24]), 8);
@@ -879,11 +809,8 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 					}
 
 					rtw_setstakey_cmd(padapter, psta, true, true);
-				}
-				else/* group key */
-				{
-					if (strcmp(param->u.crypt.alg, "TKIP") == 0 || strcmp(param->u.crypt.alg, "CCMP") == 0)
-					{
+				} else { /* group key */
+					if (strcmp(param->u.crypt.alg, "TKIP") == 0 || strcmp(param->u.crypt.alg, "CCMP") == 0) {
 						memcpy(padapter->securitypriv.dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 						memcpy(padapter->securitypriv.dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
 						memcpy(padapter->securitypriv.dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
@@ -891,9 +818,7 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 
 						padapter->securitypriv.dot118021XGrpKeyid = param->u.crypt.idx;
 						rtw_set_key(padapter, &padapter->securitypriv, param->u.crypt.idx, 1, true);
-					}
-					else if (strcmp(param->u.crypt.alg, "BIP") == 0)
-					{
+					} else if (strcmp(param->u.crypt.alg, "BIP") == 0) {
 						/* save the IGTK key, length 16 bytes */
 						memcpy(padapter->securitypriv.dot11wBIPKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 						/*
@@ -907,25 +832,19 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 			}
 
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta == NULL)
-			{
+			if (!pbcmc_sta) {
 				/* DEBUG_ERR(("Set OID_802_11_ADD_KEY: bcmc stainfo is null\n")); */
-			}
-			else
-			{
+			} else {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
 				if (strcmp(param->u.crypt.alg, "none") != 0)
 					pbcmc_sta->ieee8021x_blocked = false;
 
 				if ((padapter->securitypriv.ndisencryptstatus == Ndis802_11Encryption2Enabled) ||
-						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled))
-				{
+						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled)) {
 					pbcmc_sta->dot118021XPrivacy = padapter->securitypriv.dot11PrivacyAlgrthm;
 				}
 			}
-		}
-		else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)) /* adhoc mode */
-		{
+		} else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)) { /* adhoc mode */
 		}
 	}
 
@@ -947,7 +866,7 @@ static int cfg80211_rtw_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	param_len = sizeof(struct ieee_param) + params->key_len;
 	param = rtw_malloc(param_len);
-	if (param == NULL)
+	if (!param)
 		return -1;
 
 	memset(param, 0, param_len);
@@ -983,39 +902,29 @@ static int cfg80211_rtw_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 
 	if (!mac_addr || is_broadcast_ether_addr(mac_addr))
-	{
 		param->u.crypt.set_tx = 0; /* for wpa/wpa2 group key */
-	} else {
+	else
 		param->u.crypt.set_tx = 1; /* for wpa/wpa2 pairwise key */
-	}
 
 	param->u.crypt.idx = key_index;
 
 	if (params->seq_len && params->seq)
-	{
 		memcpy(param->u.crypt.seq, (u8 *)params->seq, params->seq_len);
-	}
 
-	if (params->key_len && params->key)
-	{
+	if (params->key_len && params->key) {
 		param->u.crypt.key_len = params->key_len;
 		memcpy(param->u.crypt.key, (u8 *)params->key, params->key_len);
 	}
 
-	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) == true)
-	{
+	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) == true) {
 		ret =  rtw_cfg80211_set_encryption(ndev, param, param_len);
-	}
-	else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true)
-	{
+	} else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
 		if (mac_addr)
 			memcpy(param->sta_addr, (void *)mac_addr, ETH_ALEN);
 
 		ret = rtw_cfg80211_ap_set_encryption(ndev, param, param_len);
-	}
-        else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) == true
-                || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true)
-        {
+	} else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) == true
+                || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true) {
                 ret =  rtw_cfg80211_set_encryption(ndev, param, param_len);
         }
 
@@ -1041,8 +950,7 @@ static int cfg80211_rtw_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct adapter *padapter = rtw_netdev_priv(ndev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
-	if (key_index == psecuritypriv->dot11PrivacyKeyIndex)
-	{
+	if (key_index == psecuritypriv->dot11PrivacyKeyIndex) {
 		/* clear the flag of wep default key set. */
 		psecuritypriv->bWepDefaultKeyIdxSet = 0;
 	}
@@ -1058,16 +966,14 @@ static int cfg80211_rtw_set_default_key(struct wiphy *wiphy,
 	struct adapter *padapter = rtw_netdev_priv(ndev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
-	if ((key_index < WEP_KEYS) && ((psecuritypriv->dot11PrivacyAlgrthm == _WEP40_) || (psecuritypriv->dot11PrivacyAlgrthm == _WEP104_))) /* set wep default key */
-	{
+	if ((key_index < WEP_KEYS) && ((psecuritypriv->dot11PrivacyAlgrthm == _WEP40_) || (psecuritypriv->dot11PrivacyAlgrthm == _WEP104_))) { /* set wep default key */
 		psecuritypriv->ndisencryptstatus = Ndis802_11Encryption1Enabled;
 
 		psecuritypriv->dot11PrivacyKeyIndex = key_index;
 
 		psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 		psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-		if (psecuritypriv->dot11DefKeylen[key_index] == 13)
-		{
+		if (psecuritypriv->dot11DefKeylen[key_index] == 13) {
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 		}
@@ -1098,16 +1004,14 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 	}
 
 	psta = rtw_get_stainfo(pstapriv, (u8 *)mac);
-	if (psta == NULL) {
+	if (!psta) {
 		ret = -ENOENT;
 		goto exit;
 	}
 
 	/* for infra./P2PClient mode */
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE)
-		&& check_fwstate(pmlmepriv, _FW_LINKED)
-	)
-	{
+		&& check_fwstate(pmlmepriv, _FW_LINKED)) {
 		struct wlan_network  *cur_network = &(pmlmepriv->cur_network);
 
 		if (memcmp((u8 *)mac, cur_network->network.mac_address, ETH_ALEN)) {
@@ -1133,9 +1037,7 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 	if ((check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)
  || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE)
  || check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		&& check_fwstate(pmlmepriv, _FW_LINKED)
-	)
-	{
+		&& check_fwstate(pmlmepriv, _FW_LINKED)) {
 		/* TODO: should acquire station info... */
 	}
 
@@ -1155,8 +1057,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 	struct mlme_ext_priv *pmlmeext = &(padapter->mlmeextpriv);
 	int ret = 0;
 
-	if (adapter_to_dvobj(padapter)->processing_dev_remove == true)
-	{
+	if (adapter_to_dvobj(padapter)->processing_dev_remove == true) {
 		ret = -EPERM;
 		goto exit;
 	}
@@ -1175,8 +1076,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 
 	old_type = rtw_wdev->iftype;
 
-	if (old_type != type)
-	{
+	if (old_type != type) {
 		pmlmeext->action_public_rxseq = 0xffff;
 		pmlmeext->action_public_dialog_token = 0xff;
 	}
@@ -1198,8 +1098,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 
 	rtw_wdev->iftype = type;
 
-	if (rtw_set_802_11_infrastructure_mode(padapter, networkType) == false)
-	{
+	if (rtw_set_802_11_infrastructure_mode(padapter, networkType) == false) {
 		rtw_wdev->iftype = old_type;
 		ret = -EPERM;
 		goto exit;
@@ -1239,8 +1138,8 @@ void rtw_cfg80211_unlink_bss(struct adapter *padapter, struct wlan_network *pnet
 
 	bss = cfg80211_get_bss(wiphy, NULL/*notify_channel*/,
 		select_network->mac_address, select_network->ssid.ssid,
-		select_network->ssid.ssid_length, 0/*WLAN_CAPABILITY_ESS*/,
-		0/*WLAN_CAPABILITY_ESS*/);
+		select_network->ssid.ssid_length, IEEE80211_BSS_TYPE_ANY,
+		IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		cfg80211_unlink_bss(wiphy, bss);
@@ -1264,9 +1163,7 @@ void rtw_cfg80211_surveydone_event_callback(struct adapter *padapter)
 
 		/* report network only if the current channel set contains the channel to which this network belongs */
 		if (rtw_ch_set_search_ch(padapter->mlmeextpriv.channel_set, pnetwork->network.configuration.ds_config) >= 0
-			&& true == rtw_validate_ssid(&(pnetwork->network.ssid))
-		)
-		{
+			&& true == rtw_validate_ssid(&(pnetwork->network.ssid))) {
 			/* ev =translate_scan(padapter, a, pnetwork, ev, stop); */
 			rtw_cfg80211_inform_bss(padapter, pnetwork);
 		}
@@ -1283,13 +1180,10 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct adapter *padapter, char *b
 	u8 *wps_ie;
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 
-	if (len > 0)
-	{
+	if (len > 0) {
 		wps_ie = rtw_get_wps_ie(buf, len, NULL, &wps_ielen);
-		if (wps_ie)
-		{
-			if (pmlmepriv->wps_probe_req_ie)
-			{
+		if (wps_ie) {
+			if (pmlmepriv->wps_probe_req_ie) {
 				pmlmepriv->wps_probe_req_ie_len = 0;
 				kfree(pmlmepriv->wps_probe_req_ie);
 				pmlmepriv->wps_probe_req_ie = NULL;
@@ -1327,7 +1221,7 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 	struct rtw_wdev_priv *pwdev_priv;
 	struct mlme_priv *pmlmepriv;
 
-	if (ndev == NULL) {
+	if (!ndev) {
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -1341,10 +1235,8 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 	pwdev_priv->scan_request = request;
 	spin_unlock_bh(&pwdev_priv->scan_req_lock);
 
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true)
-	{
-		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS|_FW_UNDER_SURVEY|_FW_UNDER_LINKING) == true)
-		{
+	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
+		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS|_FW_UNDER_SURVEY|_FW_UNDER_LINKING) == true) {
 			need_indicate_scan_done = true;
 			goto check_need_indicate_scan_done;
 		}
@@ -1367,15 +1259,13 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 		goto check_need_indicate_scan_done;
 	}
 
-	if (pmlmepriv->LinkDetectInfo.bBusyTraffic == true)
-	{
+	if (pmlmepriv->LinkDetectInfo.bBusyTraffic == true) {
 		static unsigned long lastscantime = 0;
 		unsigned long passtime;
 
 		passtime = jiffies_to_msecs(jiffies - lastscantime);
 		lastscantime = jiffies;
-		if (passtime > 12000)
-		{
+		if (passtime > 12000) {
 			need_indicate_scan_done = true;
 			goto check_need_indicate_scan_done;
 		}
@@ -1414,9 +1304,7 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 	} else if (request->n_channels <= 4) {
 		for (j = request->n_channels - 1; j >= 0; j--)
 			for (i = 0; i < survey_times; i++)
-		{
 			memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
-		}
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, ch, survey_times * request->n_channels);
 	} else {
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, NULL, 0);
@@ -1425,14 +1313,11 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 
 
 	if (_status == false)
-	{
 		ret = -1;
-	}
 
 check_need_indicate_scan_done:
 	kfree(ssid);
-	if (need_indicate_scan_done)
-	{
+	if (need_indicate_scan_done) {
 		rtw_cfg80211_surveydone_event_callback(padapter);
 		rtw_cfg80211_indicate_scan_done(padapter, false);
 	}
@@ -1458,9 +1343,7 @@ static int rtw_cfg80211_set_wpa_version(struct security_priv *psecuritypriv, u32
 
 
 	if (wpa_version & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2))
-	{
 		psecuritypriv->ndisauthtype = Ndis802_11AuthModeWPAPSK;
-	}
 
 	return 0;
 
@@ -1571,7 +1454,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 	u8 *pwpa, *pwpa2;
 	u8 null_addr[] = {0, 0, 0, 0, 0, 0};
 
-	if (pie == NULL || !ielen) {
+	if (!pie || !ielen) {
 		/* Treat this as normal case, but need to clear WIFI_UNDER_WPS */
 		_clr_fwstate_(&padapter->mlmepriv, WIFI_UNDER_WPS);
 		goto exit;
@@ -1583,7 +1466,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 	}
 
 	buf = rtw_zmalloc(ielen);
-	if (buf == NULL) {
+	if (!buf) {
 		ret =  -ENOMEM;
 		goto exit;
 	}
@@ -1619,8 +1502,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 	if (pairwise_cipher == 0)
 		pairwise_cipher = WPA_CIPHER_NONE;
 
-	switch (group_cipher)
-	{
+	switch (group_cipher) {
 		case WPA_CIPHER_NONE:
 			padapter->securitypriv.dot118021XGrpPrivacy = _NO_PRIVACY_;
 			padapter->securitypriv.ndisencryptstatus = Ndis802_11EncryptionDisabled;
@@ -1643,8 +1525,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 			break;
 	}
 
-	switch (pairwise_cipher)
-	{
+	switch (pairwise_cipher) {
 		case WPA_CIPHER_NONE:
 			padapter->securitypriv.dot11PrivacyAlgrthm = _NO_PRIVACY_;
 			padapter->securitypriv.ndisencryptstatus = Ndis802_11EncryptionDisabled;
@@ -1765,8 +1646,7 @@ static int cfg80211_rtw_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 
 		rtw_wdev->iftype = NL80211_IFTYPE_STATION;
 
-		if (rtw_set_802_11_infrastructure_mode(padapter, Ndis802_11Infrastructure) == false)
-		{
+		if (rtw_set_802_11_infrastructure_mode(padapter, Ndis802_11Infrastructure) == false) {
 			rtw_wdev->iftype = old_type;
 			ret = -EPERM;
 			goto leave_ibss;
@@ -1826,9 +1706,8 @@ static int cfg80211_rtw_connect(struct wiphy *wiphy, struct net_device *ndev,
 		ret = -EBUSY;
 		goto exit;
 	}
-	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true) {
+	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
 		rtw_scan_abort(padapter);
-	}
 
 	psecuritypriv->ndisencryptstatus = Ndis802_11EncryptionDisabled;
 	psecuritypriv->dot11PrivacyAlgrthm = _NO_PRIVACY_;
@@ -1873,7 +1752,7 @@ static int cfg80211_rtw_connect(struct wiphy *wiphy, struct net_device *ndev,
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
 			pwep = rtw_malloc(wep_total_len);
-			if (pwep == NULL) {
+			if (!pwep) {
 				ret = -ENOMEM;
 				goto exit;
 			}
@@ -2321,9 +2200,8 @@ static int rtw_cfg80211_add_monitor_if(struct adapter *padapter, char *name, str
 	mon_ndev->ieee80211_ptr = mon_wdev;
 
 	ret = cfg80211_register_netdevice(mon_ndev);
-	if (ret) {
+	if (ret)
 		goto out;
-	}
 
 	*ndev = pwdev_priv->pmon_ndev = mon_ndev;
 	memcpy(pwdev_priv->ifname_mon, name, IFNAMSIZ+1);
@@ -2436,11 +2314,10 @@ static int rtw_add_beacon(struct adapter *adapter, const u8 *head, size_t head_l
 	rtw_ies_remove_ie(pbuf, &len, _BEACON_IE_OFFSET_, WLAN_EID_VENDOR_SPECIFIC, P2P_OUI, 4);
 	rtw_ies_remove_ie(pbuf, &len, _BEACON_IE_OFFSET_, WLAN_EID_VENDOR_SPECIFIC, WFD_OUI, 4);
 
-	if (rtw_check_beacon_data(adapter, pbuf,  len) == _SUCCESS) {
+	if (rtw_check_beacon_data(adapter, pbuf,  len) == _SUCCESS)
 		ret = 0;
-	} else {
+	else
 		ret = -EINVAL;
-	}
 
 
 	kfree(pbuf);
@@ -2708,7 +2585,7 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy,
 	struct adapter *padapter;
 	struct rtw_wdev_priv *pwdev_priv;
 
-	if (ndev == NULL) {
+	if (!ndev) {
 		ret = -EINVAL;
 		goto exit;
 	}
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 295121c268bd..0d2cb3e7ea4d 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -60,6 +60,7 @@ static int wpa_set_auth_algs(struct net_device *dev, u32 value)
 static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len, wep_total_len;
 	struct ndis_802_11_wep	 *pwep = NULL;
 	struct adapter *padapter = rtw_netdev_priv(dev);
@@ -74,19 +75,22 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		goto exit;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		if (param->u.crypt.idx >= WEP_KEYS ||
-		    param->u.crypt.idx >= BIP_MAX_KEYID) {
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		{
-			ret = -EINVAL;
-			goto exit;
-		}
+	if (param->sta_addr[0] != 0xff || param->sta_addr[1] != 0xff ||
+	    param->sta_addr[2] != 0xff || param->sta_addr[3] != 0xff ||
+	    param->sta_addr[4] != 0xff || param->sta_addr[5] != 0xff) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (strcmp(param->u.crypt.alg, "WEP") == 0)
+		max_idx = WEP_KEYS - 1;
+	else
+		max_idx = BIP_MAX_KEYID;
+
+	if (param->u.crypt.idx > max_idx) {
+		netdev_err(dev, "Error crypt.idx %d > %d\n", param->u.crypt.idx, max_idx);
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
@@ -98,9 +102,6 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if (wep_key_idx > WEP_KEYS)
-			return -EINVAL;
-
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
@@ -153,7 +154,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 
 		if (check_fwstate(pmlmepriv, WIFI_STATION_STATE | WIFI_MP_STATE) == true) { /* sta mode */
 			psta = rtw_get_stainfo(pstapriv, get_bssid(pmlmepriv));
-			if (psta == NULL) {
+			if (!psta) {
 				/* DEBUG_ERR(("Set wpa_set_encryption: Obtain Sta_info fail\n")); */
 			} else {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
@@ -206,7 +207,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 			}
 
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta == NULL) {
+			if (!pbcmc_sta) {
 				/* DEBUG_ERR(("Set OID_802_11_ADD_KEY: bcmc stainfo is null\n")); */
 			} else {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
@@ -236,9 +237,9 @@ static int rtw_set_wpa_ie(struct adapter *padapter, char *pie, unsigned short ie
 	int ret = 0;
 	u8 null_addr[] = {0, 0, 0, 0, 0, 0};
 
-	if ((ielen > MAX_WPA_IE_LEN) || (pie == NULL)) {
+	if (ielen > MAX_WPA_IE_LEN || !pie) {
 		_clr_fwstate_(&padapter->mlmepriv, WIFI_UNDER_WPS);
-		if (pie == NULL)
+		if (!pie)
 			return ret;
 		else
 			return -EINVAL;
@@ -246,7 +247,7 @@ static int rtw_set_wpa_ie(struct adapter *padapter, char *pie, unsigned short ie
 
 	if (ielen) {
 		buf = rtw_zmalloc(ielen);
-		if (buf == NULL) {
+		if (!buf) {
 			ret =  -ENOMEM;
 			goto exit;
 		}
@@ -491,7 +492,7 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 		return -EINVAL;
 
 	param = rtw_malloc(p->length);
-	if (param == NULL)
+	if (!param)
 		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
@@ -571,7 +572,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 			goto exit;
 	}
 
-	if (strcmp(param->u.crypt.alg, "none") == 0 && (psta == NULL)) {
+	if (strcmp(param->u.crypt.alg, "none") == 0 && !psta) {
 		/* todo:clear default encryption keys */
 
 		psecuritypriv->dot11AuthAlgrthm = dot11AuthAlgrthm_Open;
@@ -583,7 +584,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 	}
 
 
-	if (strcmp(param->u.crypt.alg, "WEP") == 0 && (psta == NULL)) {
+	if (strcmp(param->u.crypt.alg, "WEP") == 0 && !psta) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
@@ -1227,7 +1228,7 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 		return -EINVAL;
 
 	param = rtw_malloc(p->length);
-	if (param == NULL)
+	if (!param)
 		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index 23f4f706f935..279347be77c4 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -488,7 +488,7 @@ void rtw_unregister_netdevs(struct dvobj_priv *dvobj)
 
 	padapter = dvobj->padapters;
 
-	if (padapter == NULL)
+	if (!padapter)
 		return;
 
 	pnetdev = padapter->pnetdev;
@@ -594,7 +594,7 @@ struct dvobj_priv *devobj_init(void)
 	struct dvobj_priv *pdvobj = NULL;
 
 	pdvobj = rtw_zmalloc(sizeof(*pdvobj));
-	if (pdvobj == NULL)
+	if (!pdvobj)
 		return NULL;
 
 	mutex_init(&pdvobj->hw_init_mutex);
diff --git a/fs/attr.c b/fs/attr.c
index f581c4d00897..0ca14cbd4b8b 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,70 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(mnt_userns, inode,
+				 i_gid_into_mnt(mnt_userns, inode)))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
+/**
+ * setattr_should_drop_suidgid - determine whether the set{g,u}id bit needs to
+ *                               be dropped
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ *
+ * This function determines whether the set{g,u}id bits need to be removed.
+ * If the setuid bit needs to be removed ATTR_KILL_SUID is returned. If the
+ * setgid bit needs to be removed ATTR_KILL_SGID is returned. If both
+ * set{g,u}id bits need to be removed the corresponding mask of both flags is
+ * returned.
+ *
+ * Return: A mask of ATTR_KILL_S{G,U}ID indicating which - if any - setid bits
+ * to remove, 0 otherwise.
+ */
+int setattr_should_drop_suidgid(struct user_namespace *mnt_userns,
+				struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	kill |= setattr_should_drop_sgid(mnt_userns, inode);
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(setattr_should_drop_suidgid);
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -141,8 +205,7 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!in_group_p(mapped_gid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, mapped_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -257,8 +320,7 @@ void setattr_copy(struct user_namespace *mnt_userns, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 		kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-		if (!in_group_p(kgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, kgid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
@@ -383,7 +445,7 @@ int notify_change(struct user_namespace *mnt_userns, struct dentry *dentry,
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+		if (mode & S_ISGID) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
 				attr->ia_mode = inode->i_mode;
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5eea56789ccc..19f71c305b98 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1554,7 +1554,8 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 
 		btrfs_info(fs_info,
 			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
-				bg->start, div_u64(bg->used * 100, bg->length),
+				bg->start,
+				div64_u64(bg->used * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 10eddfa6c3d7..fa086a81a847 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -17,7 +17,6 @@
 #include "recoverd.h"
 #include "dir.h"
 #include "midcomms.h"
-#include "lowcomms.h"
 #include "config.h"
 #include "memory.h"
 #include "lock.h"
@@ -384,23 +383,23 @@ static int threads_start(void)
 {
 	int error;
 
-	error = dlm_scand_start();
+	/* Thread for sending/receiving messages for all lockspace's */
+	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm_scand thread %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto fail;
 	}
 
-	/* Thread for sending/receiving messages for all lockspace's */
-	error = dlm_midcomms_start();
+	error = dlm_scand_start();
 	if (error) {
-		log_print("cannot start dlm lowcomms %d", error);
-		goto scand_fail;
+		log_print("cannot start dlm_scand thread %d", error);
+		goto midcomms_fail;
 	}
 
 	return 0;
 
- scand_fail:
-	dlm_scand_stop();
+ midcomms_fail:
+	dlm_midcomms_stop();
  fail:
 	return error;
 }
@@ -705,7 +704,7 @@ int dlm_new_lockspace(const char *name, const char *cluster,
 	if (!ls_count) {
 		dlm_scand_stop();
 		dlm_midcomms_shutdown();
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	}
  out:
 	mutex_unlock(&ls_lock);
@@ -889,7 +888,7 @@ int dlm_release_lockspace(void *lockspace, int force)
 	if (!error)
 		ls_count--;
 	if (!ls_count)
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	mutex_unlock(&ls_lock);
 
 	return error;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index d56a8f88a385..1eb95ba7e777 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1959,10 +1959,6 @@ static const struct dlm_proto_ops dlm_sctp_ops = {
 int dlm_lowcomms_start(void)
 {
 	int error = -EINVAL;
-	int i;
-
-	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&connection_hash[i]);
 
 	init_local();
 	if (!dlm_local_count) {
@@ -1971,8 +1967,6 @@ int dlm_lowcomms_start(void)
 		goto fail;
 	}
 
-	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
-
 	error = work_start();
 	if (error)
 		goto fail_local;
@@ -2011,6 +2005,16 @@ int dlm_lowcomms_start(void)
 	return error;
 }
 
+void dlm_lowcomms_init(void)
+{
+	int i;
+
+	for (i = 0; i < CONN_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&connection_hash[i]);
+
+	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
+}
+
 void dlm_lowcomms_exit(void)
 {
 	struct dlm_node_addr *na, *safe;
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index 4ccae07cf005..26433632d171 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -35,6 +35,7 @@ extern int dlm_allow_conn;
 int dlm_lowcomms_start(void);
 void dlm_lowcomms_shutdown(void);
 void dlm_lowcomms_stop(void);
+void dlm_lowcomms_init(void);
 void dlm_lowcomms_exit(void);
 int dlm_lowcomms_close(int nodeid);
 struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index afc66a1346d3..974f7ebb3fe6 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -17,7 +17,7 @@
 #include "user.h"
 #include "memory.h"
 #include "config.h"
-#include "lowcomms.h"
+#include "midcomms.h"
 
 static int __init init_dlm(void)
 {
@@ -27,6 +27,8 @@ static int __init init_dlm(void)
 	if (error)
 		goto out;
 
+	dlm_midcomms_init();
+
 	error = dlm_lockspace_init();
 	if (error)
 		goto out_mem;
@@ -63,6 +65,7 @@ static int __init init_dlm(void)
  out_lockspace:
 	dlm_lockspace_exit();
  out_mem:
+	dlm_midcomms_exit();
 	dlm_memory_exit();
  out:
 	return error;
@@ -76,7 +79,7 @@ static void __exit exit_dlm(void)
 	dlm_config_exit();
 	dlm_memory_exit();
 	dlm_lockspace_exit();
-	dlm_lowcomms_exit();
+	dlm_midcomms_exit();
 	dlm_unregister_debugfs();
 }
 
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 702c14de7a4b..84a7a39fc12e 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1142,13 +1142,28 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh)
 }
 
 int dlm_midcomms_start(void)
+{
+	return dlm_lowcomms_start();
+}
+
+void dlm_midcomms_stop(void)
+{
+	dlm_lowcomms_stop();
+}
+
+void dlm_midcomms_init(void)
 {
 	int i;
 
 	for (i = 0; i < CONN_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(&node_hash[i]);
 
-	return dlm_lowcomms_start();
+	dlm_lowcomms_init();
+}
+
+void dlm_midcomms_exit(void)
+{
+	dlm_lowcomms_exit();
 }
 
 static void dlm_act_fin_ack_rcv(struct midcomms_node *node)
diff --git a/fs/dlm/midcomms.h b/fs/dlm/midcomms.h
index 579abc6929be..1a36b7834dfc 100644
--- a/fs/dlm/midcomms.h
+++ b/fs/dlm/midcomms.h
@@ -20,6 +20,9 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh);
 int dlm_midcomms_close(int nodeid);
 int dlm_midcomms_start(void);
+void dlm_midcomms_stop(void);
+void dlm_midcomms_init(void);
+void dlm_midcomms_exit(void);
 void dlm_midcomms_shutdown(void);
 void dlm_midcomms_add_member(int nodeid);
 void dlm_midcomms_remove_member(int nodeid);
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 4666b55b736e..5504f72bbbbe 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -292,15 +292,10 @@ void ext4_release_system_zone(struct super_block *sb)
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
@@ -329,7 +324,9 @@ int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
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
@@ -338,6 +335,17 @@ int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
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
index bc209f303327..80f0942fa165 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3698,6 +3698,9 @@ extern int ext4_inode_block_valid(struct inode *inode,
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
index 38ad09e802e4..6473786c44fe 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -158,7 +158,6 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0a63863bc58c..b2600e8021b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4549,8 +4549,13 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 
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
index 2e6d03e5790e..656c6ba66ca7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -184,6 +184,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0c7498a59943..e6718bfc6c55 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5888,7 +5888,8 @@ static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
 }
 
 /**
- * ext4_free_blocks() -- Free given blocks and update quota
+ * ext4_mb_clear_bb() -- helper function for freeing blocks.
+ *			Used by ext4_free_blocks()
  * @handle:		handle for this transaction
  * @inode:		inode
  * @bh:			optional buffer of the block to be freed
@@ -5896,9 +5897,9 @@ static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
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
@@ -5915,79 +5916,14 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
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
@@ -6005,6 +5941,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		overflow = EXT4_C2B(sbi, bit) + count -
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -6019,13 +5957,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
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
@@ -6096,7 +6029,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
-					 " group:%d block:%d count:%lu failed"
+					 " group:%u block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
 		} else
@@ -6148,6 +6081,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		block += count;
 		count = overflow;
 		put_bh(bitmap_bh);
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 		goto do_more;
 	}
 error_return:
@@ -6156,6 +6091,108 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
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
@@ -6212,11 +6249,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
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
index 1e6cc6c21d60..c79c61002a62 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1595,11 +1595,10 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
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
@@ -3660,7 +3659,8 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3827,9 +3827,20 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
@@ -3887,8 +3898,10 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
@@ -4017,6 +4030,11 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
index 18977ff8e493..03e224401b23 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -413,7 +413,8 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -427,10 +428,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
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
 
@@ -548,8 +550,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
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
index d6edf38de31b..bfcbfe2788bd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2789,6 +2789,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 
+	if (ext4_has_inline_data(inode))
+		error = ext4_find_inline_data_nolock(inode);
+
 cleanup:
 	if (error && (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count))) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 02840dadde5d..c68f1f8000f1 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -672,7 +672,7 @@ static int recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	/* truncate all the data during iput */
 	iput(inode);
 
-	err = f2fs_get_node_info(sbi, ino, &ni);
+	err = f2fs_get_node_info(sbi, ino, &ni, false);
 	if (err)
 		goto err_out;
 
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 6adf04725954..4fa62f98cb51 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1275,7 +1275,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 	psize = (loff_t)(cc->rpages[last_index]->index + 1) << PAGE_SHIFT;
 
-	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni, false);
 	if (err)
 		goto out_put_dnode;
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ee2909267a33..524d4b49a520 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1354,7 +1354,7 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	if (unlikely(is_inode_flag_set(dn->inode, FI_NO_ALLOC)))
 		return -EPERM;
 
-	err = f2fs_get_node_info(sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &ni, false);
 	if (err)
 		return err;
 
@@ -1796,7 +1796,7 @@ static int f2fs_xattr_fiemap(struct inode *inode,
 		if (!page)
 			return -ENOMEM;
 
-		err = f2fs_get_node_info(sbi, inode->i_ino, &ni);
+		err = f2fs_get_node_info(sbi, inode->i_ino, &ni, false);
 		if (err) {
 			f2fs_put_page(page, 1);
 			return err;
@@ -1828,7 +1828,7 @@ static int f2fs_xattr_fiemap(struct inode *inode,
 		if (!page)
 			return -ENOMEM;
 
-		err = f2fs_get_node_info(sbi, xnid, &ni);
+		err = f2fs_get_node_info(sbi, xnid, &ni, false);
 		if (err) {
 			f2fs_put_page(page, 1);
 			return err;
@@ -2688,7 +2688,7 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 		fio->need_lock = LOCK_REQ;
 	}
 
-	err = f2fs_get_node_info(fio->sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio->sbi, dn.nid, &ni, false);
 	if (err)
 		goto out_writepage;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a144471c5316..80e4f9afe86f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3416,7 +3416,7 @@ int f2fs_need_dentry_mark(struct f2fs_sb_info *sbi, nid_t nid);
 bool f2fs_is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid);
 bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino);
 int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
-						struct node_info *ni);
+				struct node_info *ni, bool checkpoint_context);
 pgoff_t f2fs_get_next_page_offset(struct dnode_of_data *dn, pgoff_t pgofs);
 int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode);
 int f2fs_truncate_inode_blocks(struct inode *inode, pgoff_t from);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 326c1a4c2a6a..3be34ea4e299 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1232,7 +1232,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 			if (ret)
 				return ret;
 
-			ret = f2fs_get_node_info(sbi, dn.nid, &ni);
+			ret = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 			if (ret) {
 				f2fs_put_dnode(&dn);
 				return ret;
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index fa1f5fb750b3..615b109570b0 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -944,7 +944,7 @@ static int gc_node_segment(struct f2fs_sb_info *sbi,
 			continue;
 		}
 
-		if (f2fs_get_node_info(sbi, nid, &ni)) {
+		if (f2fs_get_node_info(sbi, nid, &ni, false)) {
 			f2fs_put_page(node_page, 1);
 			continue;
 		}
@@ -1012,7 +1012,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (IS_ERR(node_page))
 		return false;
 
-	if (f2fs_get_node_info(sbi, nid, dni)) {
+	if (f2fs_get_node_info(sbi, nid, dni, false)) {
 		f2fs_put_page(node_page, 1);
 		return false;
 	}
@@ -1223,7 +1223,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni, false);
 	if (err)
 		goto put_out;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index bce1c2ae6d15..e4fc169a07f5 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -146,7 +146,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	if (err)
 		return err;
 
-	err = f2fs_get_node_info(fio.sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn->nid, &ni, false);
 	if (err) {
 		f2fs_truncate_data_blocks_range(dn, 1);
 		f2fs_put_dnode(dn);
@@ -797,7 +797,7 @@ int f2fs_inline_data_fiemap(struct inode *inode,
 		ilen = start + len;
 	ilen -= start;
 
-	err = f2fs_get_node_info(F2FS_I_SB(inode), inode->i_ino, &ni);
+	err = f2fs_get_node_info(F2FS_I_SB(inode), inode->i_ino, &ni, false);
 	if (err)
 		goto out;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index bd8960f4966b..94e21136d579 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -681,17 +681,19 @@ void f2fs_update_inode_page(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *node_page;
+	int count = 0;
 retry:
 	node_page = f2fs_get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(node_page)) {
 		int err = PTR_ERR(node_page);
 
-		if (err == -ENOMEM) {
-			cond_resched();
+		/* The node block was truncated. */
+		if (err == -ENOENT)
+			return;
+
+		if (err == -ENOMEM || ++count <= DEFAULT_RETRY_IO_COUNT)
 			goto retry;
-		} else if (err != -ENOENT) {
-			f2fs_stop_checkpoint(sbi, false);
-		}
+		f2fs_stop_checkpoint(sbi, false);
 		return;
 	}
 	f2fs_update_inode(inode, node_page);
@@ -888,7 +890,7 @@ void f2fs_handle_failed_inode(struct inode *inode)
 	 * so we can prevent losing this orphan when encoutering checkpoint
 	 * and following suddenly power-off.
 	 */
-	err = f2fs_get_node_info(sbi, inode->i_ino, &ni);
+	err = f2fs_get_node_info(sbi, inode->i_ino, &ni, false);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		set_inode_flag(inode, FI_FREE_NID);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f810c6bbeff0..89a7f6021c36 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -430,6 +430,10 @@ static void cache_nat_entry(struct f2fs_sb_info *sbi, nid_t nid,
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *new, *e;
 
+	/* Let's mitigate lock contention of nat_tree_lock during checkpoint */
+	if (rwsem_is_locked(&sbi->cp_global_sem))
+		return;
+
 	new = __alloc_nat_entry(sbi, nid, false);
 	if (!new)
 		return;
@@ -539,7 +543,7 @@ int f2fs_try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 }
 
 int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
-						struct node_info *ni)
+				struct node_info *ni, bool checkpoint_context)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
@@ -572,9 +576,10 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	 * nat_tree_lock. Therefore, we should retry, if we failed to grab here
 	 * while not bothering checkpoint.
 	 */
-	if (!rwsem_is_locked(&sbi->cp_global_sem)) {
+	if (!rwsem_is_locked(&sbi->cp_global_sem) || checkpoint_context) {
 		down_read(&curseg->journal_rwsem);
-	} else if (!down_read_trylock(&curseg->journal_rwsem)) {
+	} else if (rwsem_is_contended(&nm_i->nat_tree_lock) ||
+				!down_read_trylock(&curseg->journal_rwsem)) {
 		up_read(&nm_i->nat_tree_lock);
 		goto retry;
 	}
@@ -887,7 +892,7 @@ static int truncate_node(struct dnode_of_data *dn)
 	int err;
 	pgoff_t index;
 
-	err = f2fs_get_node_info(sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &ni, false);
 	if (err)
 		return err;
 
@@ -1286,7 +1291,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 		goto fail;
 
 #ifdef CONFIG_F2FS_CHECK_FS
-	err = f2fs_get_node_info(sbi, dn->nid, &new_ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &new_ni, false);
 	if (err) {
 		dec_valid_node_count(sbi, dn->inode, !ofs);
 		goto fail;
@@ -1352,7 +1357,7 @@ static int read_node_page(struct page *page, int op_flags)
 		return LOCKED_PAGE;
 	}
 
-	err = f2fs_get_node_info(sbi, page->index, &ni);
+	err = f2fs_get_node_info(sbi, page->index, &ni, false);
 	if (err)
 		return err;
 
@@ -1603,7 +1608,7 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 	nid = nid_of_node(page);
 	f2fs_bug_on(sbi, page->index != nid);
 
-	if (f2fs_get_node_info(sbi, nid, &ni))
+	if (f2fs_get_node_info(sbi, nid, &ni, !do_balance))
 		goto redirty_out;
 
 	if (wbc->for_reclaim) {
@@ -2708,7 +2713,7 @@ int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
 		goto recover_xnid;
 
 	/* 1: invalidate the previous xattr nid */
-	err = f2fs_get_node_info(sbi, prev_xnid, &ni);
+	err = f2fs_get_node_info(sbi, prev_xnid, &ni, false);
 	if (err)
 		return err;
 
@@ -2748,7 +2753,7 @@ int f2fs_recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct page *ipage;
 	int err;
 
-	err = f2fs_get_node_info(sbi, ino, &old_ni);
+	err = f2fs_get_node_info(sbi, ino, &old_ni, false);
 	if (err)
 		return err;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index ed21e34b59c7..ba7eeb3c2738 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -604,7 +604,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	f2fs_wait_on_page_writeback(dn.node_page, NODE, true, true);
 
-	err = f2fs_get_node_info(sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 	if (err)
 		goto err;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 194c0811fbdf..58dd4de41986 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -253,7 +253,7 @@ static int __revoke_inmem_pages(struct inode *inode,
 				goto next;
 			}
 
-			err = f2fs_get_node_info(sbi, dn.nid, &ni);
+			err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 			if (err) {
 				f2fs_put_dnode(&dn);
 				return err;
diff --git a/fs/file.c b/fs/file.c
index 214364e19d76..ee1c350ec58a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -646,6 +646,7 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
 		file = ERR_PTR(-EINVAL);
 		goto out_unlock;
 	}
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file) {
 		file = ERR_PTR(-EBADF);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cc95a1c37644..2b19d281351e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1295,7 +1295,7 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			return err;
 
 		if (fc->handle_killpriv_v2 &&
-		    should_remove_suid(file_dentry(file))) {
+		    setattr_should_drop_suidgid(&init_user_ns, file_inode(file))) {
 			goto writethrough;
 		}
 
diff --git a/fs/inode.c b/fs/inode.c
index 8279c700a2b7..079b64f9b756 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1864,41 +1864,13 @@ void touch_atime(const struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
 /*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
  * Negative value on error (change should be denied).
  */
-int dentry_needs_remove_privs(struct dentry *dentry)
+int dentry_needs_remove_privs(struct user_namespace *mnt_userns,
+			      struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	int mask = 0;
@@ -1907,7 +1879,7 @@ int dentry_needs_remove_privs(struct dentry *dentry)
 	if (IS_NOSEC(inode))
 		return 0;
 
-	mask = should_remove_suid(dentry);
+	mask = setattr_should_drop_suidgid(mnt_userns, inode);
 	ret = security_inode_need_killpriv(dentry);
 	if (ret < 0)
 		return ret;
@@ -1949,7 +1921,7 @@ int file_remove_privs(struct file *file)
 	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
 		return 0;
 
-	kill = dentry_needs_remove_privs(dentry);
+	kill = dentry_needs_remove_privs(file_mnt_user_ns(file), dentry);
 	if (kill < 0)
 		return kill;
 	if (kill)
@@ -2165,10 +2137,6 @@ void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(i_gid_into_mnt(mnt_userns, dir)) &&
-			 !capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
-			mode &= ~S_ISGID;
 	} else
 		inode_fsgid_set(inode, mnt_userns);
 	inode->i_mode = mode;
@@ -2324,3 +2292,53 @@ struct timespec64 current_time(struct inode *inode)
 	return timestamp_truncate(now, inode);
 }
 EXPORT_SYMBOL(current_time);
+
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @mnt_userns: User namespace of the mount the inode was created from
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_mnt(mnt_userns, dir)))
+		return mode;
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 9075490f21a6..46df4ce58e87 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,7 +149,9 @@ extern int vfs_open(const struct path *, struct file *);
  */
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
-extern int dentry_needs_remove_privs(struct dentry *dentry);
+int dentry_needs_remove_privs(struct user_namespace *, struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
@@ -229,3 +231,9 @@ struct xattr_ctx {
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
diff --git a/fs/locks.c b/fs/locks.c
index 82a4487e95b3..881fd16905c6 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1901,9 +1901,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	kuid_t uid = i_uid_into_mnt(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!uid_eq(current_fsuid(), uid)) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/namei.c b/fs/namei.c
index 81b31d9a063f..02e99606c65b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3000,6 +3000,65 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 }
 EXPORT_SYMBOL(unlock_rename);
 
+/**
+ * mode_strip_umask - handle vfs umask stripping
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode to be created in @dir
+ *
+ * Umask stripping depends on whether or not the filesystem supports POSIX
+ * ACLs. If the filesystem doesn't support it umask stripping is done directly
+ * in here. If the filesystem does support POSIX ACLs umask stripping is
+ * deferred until the filesystem calls posix_acl_create().
+ *
+ * Returns: mode
+ */
+static inline umode_t mode_strip_umask(const struct inode *dir, umode_t mode)
+{
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
+	return mode;
+}
+
+/**
+ * vfs_prepare_mode - prepare the mode to be used for a new inode
+ * @mnt_userns:		user namespace of the mount the inode was found from
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode
+ * @mask_perms:	allowed permission by the vfs
+ * @type:	type of file to be created
+ *
+ * This helper consolidates and enforces vfs restrictions on the @mode of a new
+ * object to be created.
+ *
+ * Umask stripping depends on whether the filesystem supports POSIX ACLs (see
+ * the kernel documentation for mode_strip_umask()). Moving umask stripping
+ * after setgid stripping allows the same ordering for both non-POSIX ACL and
+ * POSIX ACL supporting filesystems.
+ *
+ * Note that it's currently valid for @type to be 0 if a directory is created.
+ * Filesystems raise that flag individually and we need to check whether each
+ * filesystem can deal with receiving S_IFDIR from the vfs before we enforce a
+ * non-zero type.
+ *
+ * Returns: mode to be passed to the filesystem
+ */
+static inline umode_t vfs_prepare_mode(struct user_namespace *mnt_userns,
+				       const struct inode *dir, umode_t mode,
+				       umode_t mask_perms, umode_t type)
+{
+	mode = mode_strip_sgid(mnt_userns, dir, mode);
+	mode = mode_strip_umask(dir, mode);
+
+	/*
+	 * Apply the vfs mandated allowed permission mask and set the type of
+	 * file to be created before we call into the filesystem.
+	 */
+	mode &= (mask_perms & ~S_IFMT);
+	mode |= (type & S_IFMT);
+
+	return mode;
+}
+
 /**
  * vfs_create - create new file
  * @mnt_userns:	user namespace of the mount the inode was found from
@@ -3025,8 +3084,8 @@ int vfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 
 	if (!dir->i_op->create)
 		return -EACCES;	/* shouldn't it be ENOSYS? */
-	mode &= S_IALLUGO;
-	mode |= S_IFREG;
+
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3291,8 +3350,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (open_flag & O_CREAT) {
 		if (open_flag & O_EXCL)
 			open_flag &= ~O_TRUNC;
-		if (!IS_POSIXACL(dir->d_inode))
-			mode &= ~current_umask();
+		mode = vfs_prepare_mode(mnt_userns, dir->d_inode, mode, mode, mode);
 		if (likely(got_write))
 			create_error = may_o_create(mnt_userns, &nd->path,
 						    dentry, mode);
@@ -3525,8 +3583,7 @@ struct dentry *vfs_tmpfile(struct user_namespace *mnt_userns,
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
-	if (!IS_POSIXACL(dir))
-		mode &= ~current_umask();
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, mode, mode);
 	error = dir->i_op->tmpfile(mnt_userns, dir, child, mode);
 	if (error)
 		goto out_err;
@@ -3804,6 +3861,7 @@ int vfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!dir->i_op->mknod)
 		return -EPERM;
 
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, mode, mode);
 	error = devcgroup_inode_mknod(mode, dev);
 	if (error)
 		return error;
@@ -3854,9 +3912,8 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 	if (IS_ERR(dentry))
 		goto out1;
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mknod(&path, dentry, mode, dev);
+	error = security_path_mknod(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode), dev);
 	if (error)
 		goto out2;
 
@@ -3926,7 +3983,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!dir->i_op->mkdir)
 		return -EPERM;
 
-	mode &= (S_IRWXUGO|S_ISVTX);
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, S_IRWXUGO | S_ISVTX, 0);
 	error = security_inode_mkdir(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3954,9 +4011,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 	if (IS_ERR(dentry))
 		goto out_putname;
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mkdir(&path, dentry, mode);
+	error = security_path_mkdir(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode));
 	if (!error) {
 		struct user_namespace *mnt_userns;
 		mnt_userns = mnt_user_ns(path.mnt);
diff --git a/fs/namespace.c b/fs/namespace.c
index d946298691ed..c9b2983ae011 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3968,6 +3968,23 @@ static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 	return 0;
 }
 
+/**
+ * mnt_allow_writers() - check whether the attribute change allows writers
+ * @kattr: the new mount attributes
+ * @mnt: the mount to which @kattr will be applied
+ *
+ * Check whether thew new mount attributes in @kattr allow concurrent writers.
+ *
+ * Return: true if writers need to be held, false if not
+ */
+static inline bool mnt_allow_writers(const struct mount_kattr *kattr,
+				     const struct mount *mnt)
+{
+	return (!(kattr->attr_set & MNT_READONLY) ||
+		(mnt->mnt.mnt_flags & MNT_READONLY)) &&
+	       !kattr->mnt_userns;
+}
+
 static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 					   struct mount *mnt, int *err)
 {
@@ -3998,8 +4015,7 @@ static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 
 		last = m;
 
-		if ((kattr->attr_set & MNT_READONLY) &&
-		    !(m->mnt.mnt_flags & MNT_READONLY)) {
+		if (!mnt_allow_writers(kattr, m)) {
 			*err = mnt_hold_writers(m);
 			if (*err)
 				goto out;
@@ -4050,13 +4066,8 @@ static void mount_setattr_commit(struct mount_kattr *kattr,
 			WRITE_ONCE(m->mnt.mnt_flags, flags);
 		}
 
-		/*
-		 * We either set MNT_READONLY above so make it visible
-		 * before ~MNT_WRITE_HOLD or we failed to recursively
-		 * apply mount options.
-		 */
-		if ((kattr->attr_set & MNT_READONLY) &&
-		    (m->mnt.mnt_flags & MNT_WRITE_HOLD))
+		/* If we had to hold writers unblock them. */
+		if (m->mnt.mnt_flags & MNT_WRITE_HOLD)
 			mnt_unhold_writers(m);
 
 		if (!err && kattr->propagation)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index fc5f780fa235..92182d4be247 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1994,7 +1994,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && setattr_should_drop_suidgid(&init_user_ns, file_inode(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -2282,7 +2282,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
-		if (should_remove_suid(dentry)) {
+		if (setattr_should_drop_suidgid(&init_user_ns, inode)) {
 			if (meta_level == 0) {
 				ocfs2_inode_unlock_for_extent_tree(inode,
 								   &di_bh,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 11807034dd48..5b8237ceb8cc 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -197,6 +197,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	 * callers. */
 	if (S_ISDIR(mode))
 		set_nlink(inode, 2);
+	mode = mode_strip_sgid(&init_user_ns, dir, mode);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	status = dquot_initialize(inode);
 	if (status)
diff --git a/fs/open.c b/fs/open.c
index 5e322f188e83..e93c33069055 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -54,7 +54,7 @@ int do_truncate(struct user_namespace *mnt_userns, struct dentry *dentry,
 	}
 
 	/* Remove suid, sgid, and file capabilities on truncate too */
-	ret = dentry_needs_remove_privs(dentry);
+	ret = dentry_needs_remove_privs(mnt_userns, dentry);
 	if (ret < 0)
 		return ret;
 	if (ret)
@@ -671,10 +671,10 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		newattrs.ia_valid |= ATTR_GID;
 		newattrs.ia_gid = gid;
 	}
-	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |=
-			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	inode_lock(inode);
+	if (!S_ISDIR(inode->i_mode))
+		newattrs.ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV |
+				     setattr_should_drop_sgid(mnt_userns, inode);
 	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(mnt_userns, path->dentry, &newattrs,
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a151e04856af..594d22458881 100644
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
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73a36b7be3bd..fd2ad6a3019c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -851,9 +851,6 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				dblocks, rblocks, false, &tp);
 		if (error)
@@ -870,9 +867,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 240eb932c014..8cd0c3df253f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
 		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -911,7 +909,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -956,6 +953,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -1005,8 +1006,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1059,13 +1058,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
-
 	/* Change file size if needed */
 	if (new_size) {
 		struct iattr iattr;
@@ -1084,8 +1076,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4..1eb71275e5b0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -634,37 +634,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct user_namespace	*mnt_userns,
@@ -763,16 +732,6 @@ xfs_setattr_nonsize(
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -784,7 +743,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
@@ -795,15 +753,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1028,11 +981,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 278949056048..6a7909fdf446 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -13,7 +13,6 @@ extern const struct file_operations xfs_dir_file_operations;
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
 		struct dentry *dentry, struct iattr *vap);
 
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 5e1d29d8b2e7..3a82a13d880c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
@@ -283,7 +285,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(&init_user_ns, inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_disk_size = iattr->ia_size;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e28792ca25a1..8471717c5085 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -903,7 +903,12 @@
 #define PRINTK_INDEX
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1e1ac116dd13..23ecfecdc450 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1941,6 +1941,8 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		      const struct inode *dir, umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
@@ -3131,7 +3133,7 @@ extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
-extern int should_remove_suid(struct dentry *);
+extern int setattr_should_drop_suidgid(struct user_namespace *, struct inode *);
 extern int file_remove_privs(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
@@ -3569,7 +3571,7 @@ int __init list_bdev_fs_names(char *buf, size_t size);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 4853538bf156..8a1e26473566 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3094,6 +3094,8 @@
 
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
index 1f9369b677fe..6c7126de5c17 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3655,6 +3655,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
 	struct btf *btf = env->btf;
 	u16 i;
 
+	env->resolve_mode = RESOLVE_TBD;
 	for_each_vsi_from(i, v->next_member, v->t, vsi) {
 		u32 var_type_id = vsi->type, type_id, type_size = 0;
 		const struct btf_type *var_type = btf_type_by_id(env->btf,
diff --git a/kernel/fork.c b/kernel/fork.c
index 3fb7e9e6a7b9..68eab6ce3085 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2829,7 +2829,7 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 298f9c12023c..e0b67784ac1e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -25,6 +25,9 @@ static DEFINE_MUTEX(irq_domain_mutex);
 
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity);
 static void irq_domain_check_hierarchy(struct irq_domain *domain);
 
 struct irqchip_fwid {
@@ -703,9 +706,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 #endif
 
-static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
-						  irq_hw_number_t hwirq,
-						  const struct irq_affinity_desc *affinity)
+static unsigned int irq_create_mapping_affinity_locked(struct irq_domain *domain,
+						       irq_hw_number_t hwirq,
+						       const struct irq_affinity_desc *affinity)
 {
 	struct device_node *of_node = irq_domain_get_of_node(domain);
 	int virq;
@@ -720,7 +723,7 @@ static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_domain_associate(domain, virq, hwirq)) {
+	if (irq_domain_associate_locked(domain, virq, hwirq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -756,14 +759,20 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
 		return 0;
 	}
 
+	mutex_lock(&irq_domain_mutex);
+
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
 		pr_debug("existing mapping on virq %d\n", virq);
-		return virq;
+		goto out;
 	}
 
-	return __irq_create_mapping_affinity(domain, hwirq, affinity);
+	virq = irq_create_mapping_affinity_locked(domain, hwirq, affinity);
+out:
+	mutex_unlock(&irq_domain_mutex);
+
+	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
@@ -830,6 +839,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	if (WARN_ON(type & ~IRQ_TYPE_SENSE_MASK))
 		type &= IRQ_TYPE_SENSE_MASK;
 
+	mutex_lock(&irq_domain_mutex);
+
 	/*
 	 * If we've already configured this interrupt,
 	 * don't do it again, or hell will break loose.
@@ -842,7 +853,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 * interrupt number.
 		 */
 		if (type == IRQ_TYPE_NONE || type == irq_get_trigger_type(virq))
-			return virq;
+			goto out;
 
 		/*
 		 * If the trigger type has not been set yet, then set
@@ -850,35 +861,45 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
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
-		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
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
@@ -1464,40 +1485,12 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
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
- * irq_domain_activate_irq(), is to program the hardware with preallocated
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
@@ -1516,24 +1509,18 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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
 
@@ -1544,6 +1531,48 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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
@@ -1902,6 +1931,13 @@ void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
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
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 1059ef6c3711..54cbaa971139 100644
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
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7f34c455651d..20ad554af369 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -187,6 +187,9 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
@@ -245,6 +248,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index bbe6569c9ad3..56e1047632f6 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -69,6 +69,9 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
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
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 43ea8cfd374b..7ff0da5f998a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -96,8 +96,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
-#define MIN_CHAINLEN	8u
-#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
+#define MIN_CHAINLEN	50u
+#define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 18a508783c28..8776e75b200f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -322,11 +322,12 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -337,7 +338,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 #else
-#define ctnetlink_dump_mark(a, b) (0)
+#define ctnetlink_dump_mark(a, b, c) (0)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -542,7 +543,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct, true) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -825,8 +826,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2759,7 +2759,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, true) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9ba3676ab37f..9bc0ab759ea4 100644
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
index d5ddf283ed8e..9cdb7df0801f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2172,16 +2172,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
 			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 			if (rc)
@@ -2190,6 +2188,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if ((sk->sk_state != SMC_ACTIVE) &&
+		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
+		   (sk->sk_state != SMC_INIT)) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback) {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 08ca797bb8a4..74a1c9116a78 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -806,6 +806,7 @@ EXPORT_SYMBOL_GPL(svc_set_num_threads);
 static int
 svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
+	struct svc_rqst	*rqstp;
 	struct task_struct *task;
 	unsigned int state = serv->sv_nrthreads-1;
 
@@ -814,7 +815,10 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
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
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0a59a00cb581..a96026dbdf94 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1969,8 +1969,9 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
-static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other,
+		     struct scm_cookie *scm, bool fds_sent)
 {
 	struct unix_sock *ousk = unix_sk(other);
 	struct sk_buff *skb;
@@ -1981,6 +1982,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (!skb)
 		return err;
 
+	err = unix_scm_to_skb(scm, skb, !fds_sent);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
 	skb_put(skb, 1);
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
@@ -2035,7 +2041,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	err = -EOPNOTSUPP;
 	if (msg->msg_flags & MSG_OOB) {
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (len)
 			len--;
 		else
@@ -2106,9 +2112,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
-		err = queue_oob(sock, msg, other);
+		err = queue_oob(sock, msg, other, &scm, fds_sent);
 		if (err)
 			goto out_err;
 		sent++;
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 452376c6f419..5919d61d9874 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -55,6 +55,9 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	struct sk_psock *psock;
 	int copied;
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return __unix_recvmsg(sk, msg, len, flags);
diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 217d21abc86e..36c920e71313 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -115,7 +115,7 @@ def parse_options():
     return args
 
 
-def main():
+def print_undefined_symbols():
     """Main function of this module."""
     args = parse_options()
 
@@ -467,5 +467,16 @@ def parse_kconfig_file(kfile):
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
diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index b11cfc86a3d0..664601ab1705 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -34,7 +34,7 @@ else
 endif
 
 FEATURE_USER = .bpf
-FEATURE_TESTS = libbfd disassembler-four-args
+FEATURE_TESTS = libbfd disassembler-four-args disassembler-init-styled
 FEATURE_DISPLAY = libbfd disassembler-four-args
 
 check_feat := 1
@@ -56,6 +56,9 @@ endif
 ifeq ($(feature-disassembler-four-args), 1)
 CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
+ifeq ($(feature-disassembler-init-styled), 1)
+CFLAGS += -DDISASM_INIT_STYLED
+endif
 
 $(OUTPUT)%.yacc.c: $(srctree)/tools/bpf/%.y
 	$(QUIET_BISON)$(YACC) -o $@ -d $<
diff --git a/tools/bpf/bpf_jit_disasm.c b/tools/bpf/bpf_jit_disasm.c
index c8ae95804728..a90a5d110f92 100644
--- a/tools/bpf/bpf_jit_disasm.c
+++ b/tools/bpf/bpf_jit_disasm.c
@@ -28,6 +28,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <limits.h>
+#include <tools/dis-asm-compat.h>
 
 #define CMD_ACTION_SIZE_BUFFER		10
 #define CMD_ACTION_READ_ALL		3
@@ -64,7 +65,9 @@ static void get_asm_insns(uint8_t *image, size_t len, int opcodes)
 	assert(bfdf);
 	assert(bfd_check_format(bfdf, bfd_object));
 
-	init_disassemble_info(&info, stdout, (fprintf_ftype) fprintf);
+	init_disassemble_info_compat(&info, stdout,
+				     (fprintf_ftype) fprintf,
+				     fprintf_styled);
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 	info.buffer = image;
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index cce52df3be06..11266c78557d 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -76,7 +76,7 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
+FEATURE_TESTS = libbfd disassembler-four-args disassembler-init-styled reallocarray zlib libcap \
 	clang-bpf-co-re
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-co-re
@@ -111,6 +111,9 @@ ifeq ($(feature-libcap), 1)
 CFLAGS += -DUSE_LIBCAP
 LIBS += -lcap
 endif
+ifeq ($(feature-disassembler-init-styled), 1)
+    CFLAGS += -DDISASM_INIT_STYLED
+endif
 
 include $(wildcard $(OUTPUT)*.d)
 
diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index 24734f2249d6..aaf99a0168c9 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <limits.h>
 #include <bpf/libbpf.h>
+#include <tools/dis-asm-compat.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -39,15 +40,12 @@ static void get_exec_path(char *tpath, size_t size)
 }
 
 static int oper_count;
-static int fprintf_json(void *out, const char *fmt, ...)
+static int printf_json(void *out, const char *fmt, va_list ap)
 {
-	va_list ap;
 	char *s;
 	int err;
 
-	va_start(ap, fmt);
 	err = vasprintf(&s, fmt, ap);
-	va_end(ap);
 	if (err < 0)
 		return -1;
 
@@ -73,6 +71,32 @@ static int fprintf_json(void *out, const char *fmt, ...)
 	return 0;
 }
 
+static int fprintf_json(void *out, const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = printf_json(out, fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
+static int fprintf_json_styled(void *out,
+			       enum disassembler_style style __maybe_unused,
+			       const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = printf_json(out, fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
 void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 		       const char *arch, const char *disassembler_options,
 		       const struct btf *btf,
@@ -99,11 +123,13 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 	assert(bfd_check_format(bfdf, bfd_object));
 
 	if (json_output)
-		init_disassemble_info(&info, stdout,
-				      (fprintf_ftype) fprintf_json);
+		init_disassemble_info_compat(&info, stdout,
+					     (fprintf_ftype) fprintf_json,
+					     fprintf_json_styled);
 	else
-		init_disassemble_info(&info, stdout,
-				      (fprintf_ftype) fprintf);
+		init_disassemble_info_compat(&info, stdout,
+					     (fprintf_ftype) fprintf,
+					     fprintf_styled);
 
 	/* Update architecture info for offload. */
 	if (arch) {
diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 6abde487bba1..f027281f0a7e 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -69,6 +69,7 @@ FEATURE_TESTS_BASIC :=                  \
         libaio				\
         libzstd				\
         disassembler-four-args		\
+        disassembler-init-styled	\
         file-handle
 
 # FEATURE_TESTS_BASIC + FEATURE_TESTS_EXTRA is the complete list
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 69a43d9ea331..aa3b0d75e44b 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -18,6 +18,7 @@ FILES=                                          \
          test-libbfd.bin                        \
          test-libbfd-buildid.bin		\
          test-disassembler-four-args.bin        \
+         test-disassembler-init-styled.bin	\
          test-reallocarray.bin			\
          test-libbfd-liberty.bin                \
          test-libbfd-liberty-z.bin              \
@@ -239,6 +240,9 @@ $(OUTPUT)test-libbfd-buildid.bin:
 $(OUTPUT)test-disassembler-four-args.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
 
+$(OUTPUT)test-disassembler-init-styled.bin:
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
+
 $(OUTPUT)test-reallocarray.bin:
 	$(BUILD)
 
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 5ffafb967b6e..957c02c7b163 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -166,6 +166,10 @@
 # include "test-disassembler-four-args.c"
 #undef main
 
+#define main main_test_disassembler_init_styled
+# include "test-disassembler-init-styled.c"
+#undef main
+
 #define main main_test_libzstd
 # include "test-libzstd.c"
 #undef main
diff --git a/tools/build/feature/test-disassembler-init-styled.c b/tools/build/feature/test-disassembler-init-styled.c
new file mode 100644
index 000000000000..f1ce0ec3bee9
--- /dev/null
+++ b/tools/build/feature/test-disassembler-init-styled.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <dis-asm.h>
+
+int main(void)
+{
+	struct disassemble_info info;
+
+	init_disassemble_info(&info, stdout,
+			      NULL, NULL);
+
+	return 0;
+}
diff --git a/tools/include/tools/dis-asm-compat.h b/tools/include/tools/dis-asm-compat.h
new file mode 100644
index 000000000000..70f331e23ed3
--- /dev/null
+++ b/tools/include/tools/dis-asm-compat.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
+#ifndef _TOOLS_DIS_ASM_COMPAT_H
+#define _TOOLS_DIS_ASM_COMPAT_H
+
+#include <stdio.h>
+#include <dis-asm.h>
+
+/* define types for older binutils version, to centralize ifdef'ery a bit */
+#ifndef DISASM_INIT_STYLED
+enum disassembler_style {DISASSEMBLER_STYLE_NOT_EMPTY};
+typedef int (*fprintf_styled_ftype) (void *, enum disassembler_style, const char*, ...);
+#endif
+
+/*
+ * Trivial fprintf wrapper to be used as the fprintf_styled_func argument to
+ * init_disassemble_info_compat() when normal fprintf suffices.
+ */
+static inline int fprintf_styled(void *out,
+				 enum disassembler_style style,
+				 const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	(void)style;
+
+	va_start(args, fmt);
+	r = vfprintf(out, fmt, args);
+	va_end(args);
+
+	return r;
+}
+
+/*
+ * Wrapper for init_disassemble_info() that hides version
+ * differences. Depending on binutils version and architecture either
+ * fprintf_func or fprintf_styled_func will be called.
+ */
+static inline void init_disassemble_info_compat(struct disassemble_info *info,
+						void *stream,
+						fprintf_ftype unstyled_func,
+						fprintf_styled_ftype styled_func)
+{
+#ifdef DISASM_INIT_STYLED
+	init_disassemble_info(info, stream,
+			      unstyled_func,
+			      styled_func);
+#else
+	(void)styled_func;
+	init_disassemble_info(info, stream,
+			      unstyled_func);
+#endif
+}
+
+#endif /* _TOOLS_DIS_ASM_COMPAT_H */
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 35e1f2a52435..2c30a2b577d3 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -296,6 +296,7 @@ FEATURE_CHECK_LDFLAGS-libpython := $(PYTHON_EMBED_LDOPTS)
 FEATURE_CHECK_LDFLAGS-libaio = -lrt
 
 FEATURE_CHECK_LDFLAGS-disassembler-four-args = -lbfd -lopcodes -ldl
+FEATURE_CHECK_LDFLAGS-disassembler-init-styled = -lbfd -lopcodes -ldl
 
 CORE_CFLAGS += -fno-omit-frame-pointer
 CORE_CFLAGS += -ggdb3
@@ -872,13 +873,16 @@ ifndef NO_LIBBFD
     ifeq ($(feature-libbfd-liberty), 1)
       EXTLIBS += -lbfd -lopcodes -liberty
       FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -ldl
+      FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -ldl
     else
       ifeq ($(feature-libbfd-liberty-z), 1)
         EXTLIBS += -lbfd -lopcodes -liberty -lz
         FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -lz -ldl
+        FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -lz -ldl
       endif
     endif
     $(call feature_check,disassembler-four-args)
+    $(call feature_check,disassembler-init-styled)
   endif
 
   ifeq ($(feature-libbfd-buildid), 1)
@@ -992,6 +996,10 @@ ifeq ($(feature-disassembler-four-args), 1)
     CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
 
+ifeq ($(feature-disassembler-init-styled), 1)
+    CFLAGS += -DDISASM_INIT_STYLED
+endif
+
 ifeq (${IS_64_BIT}, 1)
   ifndef NO_PERF_READ_VDSO32
     $(call feature_check,compile-32)
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f15c146e0054..8e7a65a8d86e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -463,6 +463,7 @@ static int perf_event__repipe_buildid_mmap2(struct perf_tool *tool,
 			dso->hit = 1;
 		}
 		dso__put(dso);
+		perf_event__repipe(tool, event, sample, machine);
 		return 0;
 	}
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index aad65c95c371..0b709e3ead2a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -558,12 +558,7 @@ static int enable_counters(void)
 			return err;
 	}
 
-	/*
-	 * We need to enable counters only if:
-	 * - we don't have tracee (attaching to task or cpu)
-	 * - we have initial delay configured
-	 */
-	if (!target__none(&target)) {
+	if (!target__enable_on_exec(&target)) {
 		if (!all_counters_use_bpf)
 			evlist__enable(evsel_list);
 	}
@@ -941,7 +936,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			return err;
 	}
 
-	if (stat_config.initial_delay) {
+	if (target.initial_delay) {
 		pr_info(EVLIST_DISABLED_MSG);
 	} else {
 		err = enable_counters();
@@ -953,8 +948,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__start_workload(evsel_list);
 
-	if (stat_config.initial_delay > 0) {
-		usleep(stat_config.initial_delay * USEC_PER_MSEC);
+	if (target.initial_delay > 0) {
+		usleep(target.initial_delay * USEC_PER_MSEC);
 		err = enable_counters();
 		if (err)
 			return -1;
@@ -1244,7 +1239,7 @@ static struct option stat_options[] = {
 		     "aggregate counts per thread", AGGR_THREAD),
 	OPT_SET_UINT(0, "per-node", &stat_config.aggr_mode,
 		     "aggregate counts per numa node", AGGR_NODE),
-	OPT_INTEGER('D', "delay", &stat_config.initial_delay,
+	OPT_INTEGER('D', "delay", &target.initial_delay,
 		    "ms to wait before starting measurement after program start (-1: start with events disabled)"),
 	OPT_CALLBACK_NOOPT(0, "metric-only", &stat_config.metric_only, NULL,
 			"Only print computed metrics. No raw values", enable_metric_only),
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0bae061b2d6d..a5e87c7f4f4e 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1694,6 +1694,7 @@ static int dso__disassemble_filename(struct dso *dso, char *filename, size_t fil
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
 #include <linux/btf.h>
+#include <tools/dis-asm-compat.h>
 
 static int symbol__disassemble_bpf(struct symbol *sym,
 				   struct annotate_args *args)
@@ -1736,9 +1737,9 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 		ret = errno;
 		goto out;
 	}
-	init_disassemble_info(&info, s,
-			      (fprintf_ftype) fprintf);
-
+	init_disassemble_info_compat(&info, s,
+				     (fprintf_ftype) fprintf,
+				     fprintf_styled);
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 09ea334586f2..5a0b3db1cab1 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -576,11 +576,7 @@ int create_perf_stat_counter(struct evsel *evsel,
 	if (evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
 
-		/*
-		 * In case of initial_delay we enable tracee
-		 * events manually.
-		 */
-		if (target__none(target) && !config->initial_delay)
+		if (target__enable_on_exec(target))
 			attr->enable_on_exec = 1;
 	}
 
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 32c8527de347..977616cf69e4 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -137,7 +137,6 @@ struct perf_stat_config {
 	FILE			*output;
 	unsigned int		 interval;
 	unsigned int		 timeout;
-	int			 initial_delay;
 	unsigned int		 unit_width;
 	unsigned int		 metric_only_len;
 	int			 times;
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index daec6cba500d..880f1af7f6ad 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -18,6 +18,7 @@ struct target {
 	bool	     per_thread;
 	bool	     use_bpf;
 	bool	     hybrid;
+	int	     initial_delay;
 	const char   *attr_map;
 };
 
@@ -72,6 +73,17 @@ static inline bool target__none(struct target *target)
 	return !target__has_task(target) && !target__has_cpu(target);
 }
 
+static inline bool target__enable_on_exec(struct target *target)
+{
+	/*
+	 * Normally enable_on_exec should be set if:
+	 *  1) The tracee process is forked (not attaching to existed task or cpu).
+	 *  2) And initial_delay is not configured.
+	 * Otherwise, we enable tracee events manually.
+	 */
+	return target__none(target) && !target->initial_delay;
+}
+
 static inline bool target__has_per_thread(struct target *target)
 {
 	return target->system_wide && target->per_thread;
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 032f2de6e14e..462dc47420b6 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3ffed093d3ea..1cb2530831f4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -157,6 +157,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -257,50 +259,57 @@ static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 	return true;
 }
 
+static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  unsigned int req, cpumask_var_t tmp,
+				  int current_cpu)
+{
+	int cpu;
+
+	kvm_make_request(req, vcpu);
+
+	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+		return;
+
+	/*
+	 * tmp can be "unavailable" if cpumasks are allocated off stack as
+	 * allocation of the mask is deliberately not fatal and is handled by
+	 * falling back to kicking all online CPUs.
+	 */
+	if (!cpumask_available(tmp))
+		return;
+
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_request_needs_ipi(), which could result in sending an IPI
+	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
+	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
+	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * after this point is also OK, as the requirement is only that KVM wait
+	 * for vCPUs that were reading SPTEs _before_ any changes were
+	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
+	 */
+	if (kvm_request_needs_ipi(vcpu, req)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != -1 && cpu != current_cpu)
+			__cpumask_set_cpu(cpu, tmp);
+	}
+}
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, cpu, me;
 	struct kvm_vcpu *vcpu;
+	int i, me;
 	bool called;
 
 	me = get_cpu();
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
-		    vcpu == except)
-			continue;
-
-		kvm_make_request(req, vcpu);
-
-		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu || vcpu == except)
 			continue;
-
-		/*
-		 * tmp can be "unavailable" if cpumasks are allocated off stack
-		 * as allocation of the mask is deliberately not fatal and is
-		 * handled by falling back to kicking all online CPUs.
-		 */
-		if (!cpumask_available(tmp))
-			continue;
-
-		/*
-		 * Note, the vCPU could get migrated to a different pCPU at any
-		 * point after kvm_request_needs_ipi(), which could result in
-		 * sending an IPI to the previous pCPU.  But, that's ok because
-		 * the purpose of the IPI is to ensure the vCPU returns to
-		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
-		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
-		 * ok, as the requirement is only that KVM wait for vCPUs that
-		 * were reading SPTEs _before_ any changes were finalized.  See
-		 * kvm_vcpu_kick() for more details on handling requests.
-		 */
-		if (kvm_request_needs_ipi(vcpu, req)) {
-			cpu = READ_ONCE(vcpu->cpu);
-			if (cpu != -1 && cpu != me)
-				__cpumask_set_cpu(cpu, tmp);
-		}
+		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -312,14 +321,25 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
-	cpumask_var_t cpus;
+	struct kvm_vcpu *vcpu;
+	struct cpumask *cpus;
 	bool called;
+	int i, me;
 
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
+	me = get_cpu();
+
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+	}
 
-	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	put_cpu();
 
-	free_cpumask_var(cpus);
 	return called;
 }
 
@@ -5619,20 +5639,22 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_3;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
+					    GFP_KERNEL, cpu_to_node(cpu))) {
+			r = -ENOMEM;
+			goto out_free_4;
+		}
+	}
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_4;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -5641,13 +5663,28 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-	WARN_ON(r);
+	if (WARN_ON_ONCE(r))
+		goto err_vfio;
+
+	/*
+	 * Registration _must_ be the very last thing done, as this exposes
+	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 */
+	r = misc_register(&kvm_dev);
+	if (r) {
+		pr_err("kvm: misc device register failed\n");
+		goto err_register;
+	}
 
 	return 0;
 
-out_unreg:
+err_register:
+	kvm_vfio_ops_exit();
+err_vfio:
 	kvm_async_pf_deinit();
-out_free:
+out_free_4:
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5667,8 +5704,18 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
-	debugfs_remove_recursive(kvm_debugfs_dir);
+	int cpu;
+
+	/*
+	 * Note, unregistering /dev/kvm doesn't strictly need to come first,
+	 * fops_get(), a.k.a. try_module_get(), prevents acquiring references
+	 * to KVM while the module is being stopped.
+	 */
 	misc_deregister(&kvm_dev);
+
+	debugfs_remove_recursive(kvm_debugfs_dir);
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
