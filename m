Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD504646D1B
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLHKgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLHKfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:35:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4A6862E4;
        Thu,  8 Dec 2022 02:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B25F161EAA;
        Thu,  8 Dec 2022 10:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6FFC433D6;
        Thu,  8 Dec 2022 10:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495609;
        bh=BwSHQYSVxuywLyH6Ebr4KL1l/nMgJVr4O6xMXEpep/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMIw4kT4d9gcLN49PPaJFKMGTC8YFL2UJ9EPg3LbRWHoc4+I/KqB1gs/UO1u0EfM5
         LstVW2d4CJuuYjTwkVajraVYrj7z19i52uw9Xrr1VB34u8yV2Z2lMKIe1+SGvBOxHM
         iaw2OwvCsnAhdpGltu5j6Uq5uzI6n4H4yeCDF6QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.82
Date:   Thu,  8 Dec 2022 11:33:17 +0100
Message-Id: <167049559721037@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1670495597236120@kroah.com>
References: <1670495597236120@kroah.com>
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

diff --git a/Makefile b/Makefile
index cc0a1da24943..bc1cf1200b62 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 81
+SUBLEVEL = 82
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index d1181ead18e5..21344fbc89e5 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -660,7 +660,7 @@ usb1: gadget@fffb0000 {
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffb0000 0x4000>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 2>;
-				clocks = <&pmc PMC_TYPE_PERIPHERAL 11>, <&pmc PMC_TYPE_SYSTEM 2>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 11>, <&pmc PMC_TYPE_SYSTEM 1>;
 				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index dacca0684ea3..a3898bac5ae6 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -53,7 +53,12 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	 * the new page->flags are visible before the tags were updated.
 	 */
 	smp_wmb();
-	mte_clear_page_tags(page_address(page));
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_clear_page_tags(page_address(page));
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -69,7 +74,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!test_bit(PG_mte_tagged, &page->flags))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 7c4ef56265ee..fd6cabc6d033 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -62,7 +62,12 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
 	 * the new page->flags are visible before the tags were updated.
 	 */
 	smp_wmb();
-	mte_restore_page_tags(page_address(page), tags);
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_restore_page_tags(page_address(page), tags);
 
 	return true;
 }
diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index 618d7c5af1a2..e15a1c9f1cf8 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -23,6 +23,7 @@
 #define REG_L		__REG_SEL(ld, lw)
 #define REG_S		__REG_SEL(sd, sw)
 #define REG_SC		__REG_SEL(sc.d, sc.w)
+#define REG_AMOSWAP_AQ	__REG_SEL(amoswap.d.aq, amoswap.w.aq)
 #define REG_ASM		__REG_SEL(.dword, .word)
 #define SZREG		__REG_SEL(8, 4)
 #define LGREG		__REG_SEL(3, 2)
diff --git a/arch/riscv/include/asm/efi.h b/arch/riscv/include/asm/efi.h
index cc4f6787f937..1bb8662875dd 100644
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -10,6 +10,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ptrace.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -20,7 +21,10 @@ extern void efi_init(void);
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
-#define arch_efi_call_virt_setup()      efi_virtmap_load()
+#define arch_efi_call_virt_setup()      ({		\
+		sync_kernel_mappings(efi_mm.pgd);	\
+		efi_virtmap_load();			\
+	})
 #define arch_efi_call_virt_teardown()   efi_virtmap_unload()
 
 #define arch_efi_call_virt(p, f, args...) p->f(args)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 0af6933a7100..98e040332482 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -38,6 +38,13 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
+static inline void sync_kernel_mappings(pgd_t *pgd)
+{
+	memcpy(pgd + USER_PTRS_PER_PGD,
+	       init_mm.pgd + USER_PTRS_PER_PGD,
+	       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+}
+
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
@@ -46,9 +53,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (likely(pgd != NULL)) {
 		memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
 		/* Copy kernel mappings */
-		memcpy(pgd + USER_PTRS_PER_PGD,
-			init_mm.pgd + USER_PTRS_PER_PGD,
-			(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+		sync_kernel_mappings(pgd);
 	}
 	return pgd;
 }
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 7e52ad5d61ad..5ca2860cc06c 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -387,6 +387,19 @@ handle_syscall_trace_exit:
 
 #ifdef CONFIG_VMAP_STACK
 handle_kernel_stack_overflow:
+	/*
+	 * Takes the psuedo-spinlock for the shadow stack, in case multiple
+	 * harts are concurrently overflowing their kernel stacks.  We could
+	 * store any value here, but since we're overflowing the kernel stack
+	 * already we only have SP to use as a scratch register.  So we just
+	 * swap in the address of the spinlock, as that's definately non-zero.
+	 *
+	 * Pairs with a store_release in handle_bad_stack().
+	 */
+1:	la sp, spin_shadow_stack
+	REG_AMOSWAP_AQ sp, sp, (sp)
+	bnez sp, 1b
+
 	la sp, shadow_stack
 	addi sp, sp, SHADOW_OVERFLOW_STACK_SIZE
 
diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index ee79e6839b86..db41c676e5a2 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -15,6 +15,8 @@
 #include <linux/compiler.h>	/* For unreachable() */
 #include <linux/cpu.h>		/* For cpu_down() */
 #include <linux/reboot.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 /*
  * kexec_image_info - Print received image details
@@ -154,6 +156,37 @@ void crash_smp_send_stop(void)
 	cpus_stopped = 1;
 }
 
+static void machine_kexec_mask_interrupts(void)
+{
+	unsigned int i;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(i, desc) {
+		struct irq_chip *chip;
+		int ret;
+
+		chip = irq_desc_get_chip(desc);
+		if (!chip)
+			continue;
+
+		/*
+		 * First try to remove the active state. If this
+		 * fails, try to EOI the interrupt.
+		 */
+		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
+
+		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
+		    chip->irq_eoi)
+			chip->irq_eoi(&desc->irq_data);
+
+		if (chip->irq_mask)
+			chip->irq_mask(&desc->irq_data);
+
+		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
+			chip->irq_disable(&desc->irq_data);
+	}
+}
+
 /*
  * machine_crash_shutdown - Prepare to kexec after a kernel crash
  *
@@ -169,6 +202,8 @@ machine_crash_shutdown(struct pt_regs *regs)
 	crash_smp_send_stop();
 
 	crash_save_cpu(regs, smp_processor_id());
+	machine_kexec_mask_interrupts();
+
 	pr_info("Starting crashdump kernel...\n");
 }
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index ef81e9003ab8..14b84d09354a 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -331,10 +331,11 @@ subsys_initcall(topology_init);
 
 void free_initmem(void)
 {
-	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
-		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end),
-				  IS_ENABLED(CONFIG_64BIT) ?
-					set_memory_rw : set_memory_rw_nx);
+	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
+		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end), set_memory_rw_nx);
+		if (IS_ENABLED(CONFIG_64BIT))
+			set_kernel_memory(__init_begin, __init_end, set_memory_nx);
+	}
 
 	free_initmem_default(POISON_FREE_INITMEM);
 }
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 8c58aa5d2b36..2f4cd85fb651 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -218,11 +218,29 @@ asmlinkage unsigned long get_overflow_stack(void)
 		OVERFLOW_STACK_SIZE;
 }
 
+/*
+ * A pseudo spinlock to protect the shadow stack from being used by multiple
+ * harts concurrently.  This isn't a real spinlock because the lock side must
+ * be taken without a valid stack and only a single register, it's only taken
+ * while in the process of panicing anyway so the performance and error
+ * checking a proper spinlock gives us doesn't matter.
+ */
+unsigned long spin_shadow_stack;
+
 asmlinkage void handle_bad_stack(struct pt_regs *regs)
 {
 	unsigned long tsk_stk = (unsigned long)current->stack;
 	unsigned long ovf_stk = (unsigned long)this_cpu_ptr(overflow_stack);
 
+	/*
+	 * We're done with the shadow stack by this point, as we're on the
+	 * overflow stack.  Tell any other concurrent overflowing harts that
+	 * they can proceed with panicing by releasing the pseudo-spinlock.
+	 *
+	 * This pairs with an amoswap.aq in handle_kernel_stack_overflow.
+	 */
+	smp_store_release(&spin_shadow_stack, 0);
+
 	console_verbose();
 
 	pr_emerg("Insufficient stack space to handle exception!\n");
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index db6548509bb3..06e6b27f3bcc 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,7 @@ vdso-syms += flush_icache
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
 ccflags-y := -fno-stack-protector
+ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index f5ce9a0ab233..06c9f0eaa9ed 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -310,7 +310,7 @@ static inline void indirect_branch_prediction_barrier(void)
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
-extern void write_spec_ctrl_current(u64 val, bool force);
+extern void update_spec_ctrl_cond(u64 val);
 extern u64 spec_ctrl_current(void);
 
 /*
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7b15f7ef760d..8961f1031180 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -60,11 +60,18 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+/* Update SPEC_CTRL MSR and its cached copy unconditionally */
+static void update_spec_ctrl(u64 val)
+{
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 /*
  * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
  * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-void write_spec_ctrl_current(u64 val, bool force)
+void update_spec_ctrl_cond(u64 val)
 {
 	if (this_cpu_read(x86_spec_ctrl_current) == val)
 		return;
@@ -75,7 +82,7 @@ void write_spec_ctrl_current(u64 val, bool force)
 	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
 	 * forced the update can be delayed until that time.
 	 */
-	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+	if (!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
@@ -1328,7 +1335,7 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 
 	if (ia32_cap & ARCH_CAP_RRSBA) {
 		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 }
 
@@ -1450,7 +1457,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1564,7 +1571,7 @@ static void __init spectre_v2_select_mitigation(void)
 static void update_stibp_msr(void * __unused)
 {
 	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
-	write_spec_ctrl_current(val, true);
+	update_spec_ctrl(val);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1797,7 +1804,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+			update_spec_ctrl(x86_spec_ctrl_base);
 		}
 	}
 
@@ -2048,7 +2055,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 707376453525..bc9b4b93cf9b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -584,7 +584,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr, false);
+		update_spec_ctrl_cond(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba1749a770eb..4724289c8a7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2357,6 +2357,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 {
 	bool list_unstable;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
@@ -4007,16 +4008,17 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
 
-	if (is_tdp_mmu_fault)
+	if (is_tdp_mmu_fault) {
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
 				    pfn, prefault);
-	else
+	} else {
+		r = make_mmu_pages_available(vcpu);
+		if (r)
+			goto out_unlock;
 		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
 				 prefault, is_tdp);
+	}
 
 out_unlock:
 	if (is_tdp_mmu_fault)
diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index c3d783aca196..b42653707fdc 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -563,17 +563,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 {
 	struct memory_initiator *ia;
 	struct memory_initiator *ib;
-	unsigned long *p_nodes = priv;
 
 	ia = list_entry(a, struct memory_initiator, node);
 	ib = list_entry(b, struct memory_initiator, node);
 
-	set_bit(ia->processor_pxm, p_nodes);
-	set_bit(ib->processor_pxm, p_nodes);
-
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	struct memory_initiator *initiator;
+
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	list_for_each_entry(initiator, &initiators, node)
+		set_bit(initiator->processor_pxm, p_nodes);
+
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -610,7 +619,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	list_sort(NULL, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -644,8 +656,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
-	best = 0;
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1621ce818705..d69905233aff 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	if (!tpm_chip_start(chip)) {
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			tpm2_shutdown(chip, TPM2_SU_STATE);
 		else
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
 
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
 
 suspended:
diff --git a/drivers/clk/at91/at91rm9200.c b/drivers/clk/at91/at91rm9200.c
index 428a6f4b9ebc..8d36e615cd9d 100644
--- a/drivers/clk/at91/at91rm9200.c
+++ b/drivers/clk/at91/at91rm9200.c
@@ -40,7 +40,7 @@ static const struct clk_pll_characteristics rm9200_pll_characteristics = {
 };
 
 static const struct sck at91rm9200_systemck[] = {
-	{ .n = "udpck", .p = "usbck",    .id = 2 },
+	{ .n = "udpck", .p = "usbck",    .id = 1 },
 	{ .n = "uhpck", .p = "usbck",    .id = 4 },
 	{ .n = "pck0",  .p = "prog0",    .id = 8 },
 	{ .n = "pck1",  .p = "prog1",    .id = 9 },
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 0e7748df4be3..c51c5ed15aa7 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -32,7 +32,7 @@ static int riscv_clock_next_event(unsigned long delta,
 static unsigned int riscv_clock_event_irq;
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
+	.features		= CLOCK_EVT_FEAT_ONESHOT,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 4b1d62ebf8dd..c777aff164b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -315,8 +315,10 @@ static void amdgpu_connector_get_edid(struct drm_connector *connector)
 	if (!amdgpu_connector->edid) {
 		/* some laptops provide a hardcoded edid in rom for LCDs */
 		if (((connector->connector_type == DRM_MODE_CONNECTOR_LVDS) ||
-		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP)))
+		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP))) {
 			amdgpu_connector->edid = amdgpu_connector_get_hardcoded_edid(adev);
+			drm_connector_update_edid_property(connector, amdgpu_connector->edid);
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index 008a308a4eca..0c1022270790 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -149,6 +149,9 @@ int amdgpu_vcn_sw_init(struct amdgpu_device *adev)
 		break;
 	case CHIP_VANGOGH:
 		fw_name = FIRMWARE_VANGOGH;
+		if ((adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) &&
+		    (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
+			adev->vcn.indirect_sram = true;
 		break;
 	case CHIP_DIMGREY_CAVEFISH:
 		fw_name = FIRMWARE_DIMGREY_CAVEFISH;
diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index 127667e549c1..f25a2c80afcf 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -5,6 +5,7 @@ menu "Display Engine Configuration"
 config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
+	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	select DRM_AMD_DC_DCN if (X86 || PPC64) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
 	help
@@ -12,6 +13,12 @@ config DRM_AMD_DC
 	  support for AMDGPU. This adds required support for Vega and
 	  Raven ASICs.
 
+	  calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 || ARM64)
+	  architectures built with Clang (all released versions), whereby the stack
+	  frame gets blown up to well over 5k.  This would cause an immediate kernel
+	  panic on most architectures.  We'll revert this when the following bug report
+	  has been resolved: https://github.com/llvm/llvm-project/issues/41896.
+
 config DRM_AMD_DC_DCN
 	def_bool n
 	help
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 72e9b9b80c22..0ebabcc8827b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2997,13 +2997,12 @@ void amdgpu_dm_update_connector_after_detect(
 			aconnector->edid =
 				(struct edid *)sink->dc_edid.raw_edid;
 
-			drm_connector_update_edid_property(connector,
-							   aconnector->edid);
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
 						    aconnector->edid);
 		}
 
+		drm_connector_update_edid_property(connector, aconnector->edid);
 		amdgpu_dm_update_freesync_caps(connector, aconnector->edid);
 		update_connector_ext_caps(aconnector);
 	} else {
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 9bf9430209b0..0d915fe8b6e4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -5285,7 +5285,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 
 	if (IS_ERR(mst_state))
-		return -EINVAL;
+		return PTR_ERR(mst_state);
 
 	list_for_each_entry(pos, &mst_state->vcpis, next) {
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_internal.c b/drivers/gpu/drm/i915/gem/i915_gem_internal.c
index e5ae9c06510c..3c8de65bfb39 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_internal.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_internal.c
@@ -143,24 +143,10 @@ static const struct drm_i915_gem_object_ops i915_gem_object_internal_ops = {
 	.put_pages = i915_gem_object_put_pages_internal,
 };
 
-/**
- * i915_gem_object_create_internal: create an object with volatile pages
- * @i915: the i915 device
- * @size: the size in bytes of backing storage to allocate for the object
- *
- * Creates a new object that wraps some internal memory for private use.
- * This object is not backed by swappable storage, and as such its contents
- * are volatile and only valid whilst pinned. If the object is reaped by the
- * shrinker, its pages and data will be discarded. Equally, it is not a full
- * GEM object and so not valid for access from userspace. This makes it useful
- * for hardware interfaces like ringbuffers (which are pinned from the time
- * the request is written to the time the hardware stops accessing it), but
- * not for contexts (which need to be preserved when not active for later
- * reuse). Note that it is not cleared upon allocation.
- */
 struct drm_i915_gem_object *
-i915_gem_object_create_internal(struct drm_i915_private *i915,
-				phys_addr_t size)
+__i915_gem_object_create_internal(struct drm_i915_private *i915,
+				  const struct drm_i915_gem_object_ops *ops,
+				  phys_addr_t size)
 {
 	static struct lock_class_key lock_class;
 	struct drm_i915_gem_object *obj;
@@ -177,7 +163,7 @@ i915_gem_object_create_internal(struct drm_i915_private *i915,
 		return ERR_PTR(-ENOMEM);
 
 	drm_gem_private_object_init(&i915->drm, &obj->base, size);
-	i915_gem_object_init(obj, &i915_gem_object_internal_ops, &lock_class, 0);
+	i915_gem_object_init(obj, ops, &lock_class, 0);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 
 	/*
@@ -197,3 +183,25 @@ i915_gem_object_create_internal(struct drm_i915_private *i915,
 
 	return obj;
 }
+
+/**
+ * i915_gem_object_create_internal: create an object with volatile pages
+ * @i915: the i915 device
+ * @size: the size in bytes of backing storage to allocate for the object
+ *
+ * Creates a new object that wraps some internal memory for private use.
+ * This object is not backed by swappable storage, and as such its contents
+ * are volatile and only valid whilst pinned. If the object is reaped by the
+ * shrinker, its pages and data will be discarded. Equally, it is not a full
+ * GEM object and so not valid for access from userspace. This makes it useful
+ * for hardware interfaces like ringbuffers (which are pinned from the time
+ * the request is written to the time the hardware stops accessing it), but
+ * not for contexts (which need to be preserved when not active for later
+ * reuse). Note that it is not cleared upon allocation.
+ */
+struct drm_i915_gem_object *
+i915_gem_object_create_internal(struct drm_i915_private *i915,
+				phys_addr_t size)
+{
+	return __i915_gem_object_create_internal(i915, &i915_gem_object_internal_ops, size);
+}
diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
index 1aee5e6b1b23..b257666a26fc 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
@@ -244,6 +244,7 @@ static int gen6_ppgtt_init_scratch(struct gen6_ppgtt *ppgtt)
 	i915_gem_object_put(vm->scratch[1]);
 err_scratch0:
 	i915_gem_object_put(vm->scratch[0]);
+	vm->scratch[0] = NULL;
 	return ret;
 }
 
@@ -262,15 +263,13 @@ static void gen6_ppgtt_cleanup(struct i915_address_space *vm)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(i915_vm_to_ppgtt(vm));
 
-	__i915_vma_put(ppgtt->vma);
-
 	gen6_ppgtt_free_pd(ppgtt);
 	free_scratch(vm);
 
-	mutex_destroy(&ppgtt->flush);
-	mutex_destroy(&ppgtt->pin_mutex);
+	if (ppgtt->base.pd)
+		free_pd(&ppgtt->base.vm, ppgtt->base.pd);
 
-	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
+	mutex_destroy(&ppgtt->flush);
 }
 
 static int pd_vma_set_pages(struct i915_vma *vma)
@@ -331,37 +330,6 @@ static const struct i915_vma_ops pd_vma_ops = {
 	.unbind_vma = pd_vma_unbind,
 };
 
-static struct i915_vma *pd_vma_create(struct gen6_ppgtt *ppgtt, int size)
-{
-	struct i915_ggtt *ggtt = ppgtt->base.vm.gt->ggtt;
-	struct i915_vma *vma;
-
-	GEM_BUG_ON(!IS_ALIGNED(size, I915_GTT_PAGE_SIZE));
-	GEM_BUG_ON(size > ggtt->vm.total);
-
-	vma = i915_vma_alloc();
-	if (!vma)
-		return ERR_PTR(-ENOMEM);
-
-	i915_active_init(&vma->active, NULL, NULL, 0);
-
-	kref_init(&vma->ref);
-	mutex_init(&vma->pages_mutex);
-	vma->vm = i915_vm_get(&ggtt->vm);
-	vma->ops = &pd_vma_ops;
-	vma->private = ppgtt;
-
-	vma->size = size;
-	vma->fence_size = size;
-	atomic_set(&vma->flags, I915_VMA_GGTT);
-	vma->ggtt_view.type = I915_GGTT_VIEW_ROTATED; /* prevent fencing */
-
-	INIT_LIST_HEAD(&vma->obj_link);
-	INIT_LIST_HEAD(&vma->closed_link);
-
-	return vma;
-}
-
 int gen6_ppgtt_pin(struct i915_ppgtt *base, struct i915_gem_ww_ctx *ww)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(base);
@@ -378,24 +346,85 @@ int gen6_ppgtt_pin(struct i915_ppgtt *base, struct i915_gem_ww_ctx *ww)
 	if (atomic_add_unless(&ppgtt->pin_count, 1, 0))
 		return 0;
 
-	if (mutex_lock_interruptible(&ppgtt->pin_mutex))
-		return -EINTR;
+	/* grab the ppgtt resv to pin the object */
+	err = i915_vm_lock_objects(&ppgtt->base.vm, ww);
+	if (err)
+		return err;
 
 	/*
 	 * PPGTT PDEs reside in the GGTT and consists of 512 entries. The
 	 * allocator works in address space sizes, so it's multiplied by page
 	 * size. We allocate at the top of the GTT to avoid fragmentation.
 	 */
-	err = 0;
-	if (!atomic_read(&ppgtt->pin_count))
+	if (!atomic_read(&ppgtt->pin_count)) {
 		err = i915_ggtt_pin(ppgtt->vma, ww, GEN6_PD_ALIGN, PIN_HIGH);
+
+		GEM_BUG_ON(ppgtt->vma->fence);
+		clear_bit(I915_VMA_CAN_FENCE_BIT, __i915_vma_flags(ppgtt->vma));
+	}
 	if (!err)
 		atomic_inc(&ppgtt->pin_count);
-	mutex_unlock(&ppgtt->pin_mutex);
 
 	return err;
 }
 
+static int pd_dummy_obj_get_pages(struct drm_i915_gem_object *obj)
+{
+	obj->mm.pages = ZERO_SIZE_PTR;
+	return 0;
+}
+
+static void pd_dummy_obj_put_pages(struct drm_i915_gem_object *obj,
+				   struct sg_table *pages)
+{
+}
+
+static const struct drm_i915_gem_object_ops pd_dummy_obj_ops = {
+	.name = "pd_dummy_obj",
+	.get_pages = pd_dummy_obj_get_pages,
+	.put_pages = pd_dummy_obj_put_pages,
+};
+
+static struct i915_page_directory *
+gen6_alloc_top_pd(struct gen6_ppgtt *ppgtt)
+{
+	struct i915_ggtt * const ggtt = ppgtt->base.vm.gt->ggtt;
+	struct i915_page_directory *pd;
+	int err;
+
+	pd = __alloc_pd(I915_PDES);
+	if (unlikely(!pd))
+		return ERR_PTR(-ENOMEM);
+
+	pd->pt.base = __i915_gem_object_create_internal(ppgtt->base.vm.gt->i915,
+							&pd_dummy_obj_ops,
+							I915_PDES * SZ_4K);
+	if (IS_ERR(pd->pt.base)) {
+		err = PTR_ERR(pd->pt.base);
+		pd->pt.base = NULL;
+		goto err_pd;
+	}
+
+	pd->pt.base->base.resv = i915_vm_resv_get(&ppgtt->base.vm);
+	pd->pt.base->shares_resv_from = &ppgtt->base.vm;
+
+	ppgtt->vma = i915_vma_instance(pd->pt.base, &ggtt->vm, NULL);
+	if (IS_ERR(ppgtt->vma)) {
+		err = PTR_ERR(ppgtt->vma);
+		ppgtt->vma = NULL;
+		goto err_pd;
+	}
+
+	/* The dummy object we create is special, override ops.. */
+	ppgtt->vma->ops = &pd_vma_ops;
+	ppgtt->vma->private = ppgtt;
+	return pd;
+
+err_pd:
+	free_pd(&ppgtt->base.vm, pd);
+	return ERR_PTR(err);
+}
+
 void gen6_ppgtt_unpin(struct i915_ppgtt *base)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(base);
@@ -427,7 +456,6 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&ppgtt->flush);
-	mutex_init(&ppgtt->pin_mutex);
 
 	ppgtt_init(&ppgtt->base, gt);
 	ppgtt->base.vm.pd_shift = ilog2(SZ_4K * SZ_4K / sizeof(gen6_pte_t));
@@ -442,30 +470,19 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 	ppgtt->base.vm.alloc_pt_dma = alloc_pt_dma;
 	ppgtt->base.vm.pte_encode = ggtt->vm.pte_encode;
 
-	ppgtt->base.pd = __alloc_pd(I915_PDES);
-	if (!ppgtt->base.pd) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
 	err = gen6_ppgtt_init_scratch(ppgtt);
 	if (err)
-		goto err_pd;
+		goto err_put;
 
-	ppgtt->vma = pd_vma_create(ppgtt, GEN6_PD_SIZE);
-	if (IS_ERR(ppgtt->vma)) {
-		err = PTR_ERR(ppgtt->vma);
-		goto err_scratch;
+	ppgtt->base.pd = gen6_alloc_top_pd(ppgtt);
+	if (IS_ERR(ppgtt->base.pd)) {
+		err = PTR_ERR(ppgtt->base.pd);
+		goto err_put;
 	}
 
 	return &ppgtt->base;
 
-err_scratch:
-	free_scratch(&ppgtt->base.vm);
-err_pd:
-	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
-err_free:
-	mutex_destroy(&ppgtt->pin_mutex);
-	kfree(ppgtt);
+err_put:
+	i915_vm_put(&ppgtt->base.vm);
 	return ERR_PTR(err);
 }
diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.h b/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
index 6a61a5c3a85a..9b498ca76ac6 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
@@ -19,7 +19,6 @@ struct gen6_ppgtt {
 	u32 pp_dir;
 
 	atomic_t pin_count;
-	struct mutex pin_mutex;
 
 	bool scan_for_unused_pt;
 };
diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 6e0e52eeb87a..0cf604c5a6c2 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -196,7 +196,10 @@ static void gen8_ppgtt_cleanup(struct i915_address_space *vm)
 	if (intel_vgpu_active(vm->i915))
 		gen8_ppgtt_notify_vgt(ppgtt, false);
 
-	__gen8_ppgtt_cleanup(vm, ppgtt->pd, gen8_pd_top_count(vm), vm->top);
+	if (ppgtt->pd)
+		__gen8_ppgtt_cleanup(vm, ppgtt->pd,
+				     gen8_pd_top_count(vm), vm->top);
+
 	free_scratch(vm);
 }
 
@@ -656,8 +659,10 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 		struct drm_i915_gem_object *obj;
 
 		obj = vm->alloc_pt_dma(vm, I915_GTT_PAGE_SIZE_4K);
-		if (IS_ERR(obj))
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
 			goto free_scratch;
+		}
 
 		ret = map_pt_dma(vm, obj);
 		if (ret) {
@@ -676,7 +681,8 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 free_scratch:
 	while (i--)
 		i915_gem_object_put(vm->scratch[i]);
-	return -ENOMEM;
+	vm->scratch[0] = NULL;
+	return ret;
 }
 
 static int gen8_preallocate_top_level_pdp(struct i915_ppgtt *ppgtt)
@@ -753,6 +759,7 @@ gen8_alloc_top_pd(struct i915_address_space *vm)
  */
 struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt)
 {
+	struct i915_page_directory *pd;
 	struct i915_ppgtt *ppgtt;
 	int err;
 
@@ -779,44 +786,39 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt)
 	else
 		ppgtt->vm.alloc_pt_dma = alloc_pt_dma;
 
+	ppgtt->vm.pte_encode = gen8_pte_encode;
+
+	ppgtt->vm.bind_async_flags = I915_VMA_LOCAL_BIND;
+	ppgtt->vm.insert_entries = gen8_ppgtt_insert;
+	ppgtt->vm.insert_page = gen8_ppgtt_insert_entry;
+	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
+	ppgtt->vm.clear_range = gen8_ppgtt_clear;
+	ppgtt->vm.foreach = gen8_ppgtt_foreach;
+	ppgtt->vm.cleanup = gen8_ppgtt_cleanup;
+
 	err = gen8_init_scratch(&ppgtt->vm);
 	if (err)
-		goto err_free;
+		goto err_put;
 
-	ppgtt->pd = gen8_alloc_top_pd(&ppgtt->vm);
-	if (IS_ERR(ppgtt->pd)) {
-		err = PTR_ERR(ppgtt->pd);
-		goto err_free_scratch;
+	pd = gen8_alloc_top_pd(&ppgtt->vm);
+	if (IS_ERR(pd)) {
+		err = PTR_ERR(pd);
+		goto err_put;
 	}
+	ppgtt->pd = pd;
 
 	if (!i915_vm_is_4lvl(&ppgtt->vm)) {
 		err = gen8_preallocate_top_level_pdp(ppgtt);
 		if (err)
-			goto err_free_pd;
+			goto err_put;
 	}
 
-	ppgtt->vm.bind_async_flags = I915_VMA_LOCAL_BIND;
-	ppgtt->vm.insert_entries = gen8_ppgtt_insert;
-	ppgtt->vm.insert_page = gen8_ppgtt_insert_entry;
-	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
-	ppgtt->vm.clear_range = gen8_ppgtt_clear;
-	ppgtt->vm.foreach = gen8_ppgtt_foreach;
-
-	ppgtt->vm.pte_encode = gen8_pte_encode;
-
 	if (intel_vgpu_active(gt->i915))
 		gen8_ppgtt_notify_vgt(ppgtt, true);
 
-	ppgtt->vm.cleanup = gen8_ppgtt_cleanup;
-
 	return ppgtt;
 
-err_free_pd:
-	__gen8_ppgtt_cleanup(&ppgtt->vm, ppgtt->pd,
-			     gen8_pd_top_count(&ppgtt->vm), ppgtt->vm.top);
-err_free_scratch:
-	free_scratch(&ppgtt->vm);
-err_free:
-	kfree(ppgtt);
+err_put:
+	i915_vm_put(&ppgtt->vm);
 	return ERR_PTR(err);
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index a09820ada82c..952e7177409b 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -650,8 +650,13 @@ int intel_gt_wait_for_idle(struct intel_gt *gt, long timeout)
 			return -EINTR;
 	}
 
-	return timeout ? timeout : intel_uc_wait_for_idle(&gt->uc,
-							  remaining_timeout);
+	if (timeout)
+		return timeout;
+
+	if (remaining_timeout < 0)
+		remaining_timeout = 0;
+
+	return intel_uc_wait_for_idle(&gt->uc, remaining_timeout);
 }
 
 int intel_gt_init(struct intel_gt *gt)
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_requests.c b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
index edb881d75630..1dfd01668c79 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
@@ -199,7 +199,7 @@ out_active:	spin_lock(&timelines->lock);
 	if (remaining_timeout)
 		*remaining_timeout = timeout;
 
-	return active_count ? timeout : 0;
+	return active_count ? timeout ?: -ETIME : 0;
 }
 
 static void retire_work_handler(struct work_struct *work)
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
index e137dd32b5b8..2d3a979736cc 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -341,6 +341,9 @@ void free_scratch(struct i915_address_space *vm)
 {
 	int i;
 
+	if (!vm->scratch[0])
+		return;
+
 	for (i = 0; i <= vm->top; i++)
 		i915_gem_object_put(vm->scratch[i]);
 }
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 005b1cec7007..236cfee1cbf0 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1905,6 +1905,10 @@ int i915_gem_evict_vm(struct i915_address_space *vm);
 struct drm_i915_gem_object *
 i915_gem_object_create_internal(struct drm_i915_private *dev_priv,
 				phys_addr_t size);
+struct drm_i915_gem_object *
+__i915_gem_object_create_internal(struct drm_i915_private *dev_priv,
+				  const struct drm_i915_gem_object_ops *ops,
+				  phys_addr_t size);
 
 /* i915_gem_tiling.c */
 static inline bool i915_gem_object_needs_bit17_swizzle(struct drm_i915_gem_object *obj)
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 032129292957..42b84ebff057 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -242,10 +242,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	 */
 	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
 		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
-			if (host_bridge->device == tjmax_pci_table[i].device)
+			if (host_bridge->device == tjmax_pci_table[i].device) {
+				pci_dev_put(host_bridge);
 				return tjmax_pci_table[i].tjmax;
+			}
 		}
 	}
+	pci_dev_put(host_bridge);
 
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
@@ -533,6 +536,10 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 {
 	struct temp_data *tdata = pdata->core_data[indx];
 
+	/* if we errored on add then this is already gone */
+	if (!tdata)
+		return;
+
 	/* Remove the sysfs attributes */
 	sysfs_remove_group(&pdata->hwmon_dev->kobj, &tdata->attr_group);
 
diff --git a/drivers/hwmon/i5500_temp.c b/drivers/hwmon/i5500_temp.c
index 360f5aee1394..d4be03f43fb4 100644
--- a/drivers/hwmon/i5500_temp.c
+++ b/drivers/hwmon/i5500_temp.c
@@ -108,7 +108,7 @@ static int i5500_temp_probe(struct pci_dev *pdev,
 	u32 tstimer;
 	s8 tsfsc;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable device\n");
 		return err;
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index b2ab83c9fd9a..fe90f0536d76 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -502,6 +502,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index 58d3828e2ec0..14586b2fb17d 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -228,7 +228,7 @@ static int ina3221_read_value(struct ina3221_data *ina, unsigned int reg,
 	 * Shunt Voltage Sum register has 14-bit value with 1-bit shift
 	 * Other Shunt Voltage registers have 12 bits with 3-bit shift
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		*val = sign_extend32(regval >> 1, 14);
 	else
 		*val = sign_extend32(regval >> 3, 12);
@@ -465,7 +465,7 @@ static int ina3221_write_curr(struct device *dev, u32 attr,
 	 *     SHUNT_SUM: (1 / 40uV) << 1 = 1 / 20uV
 	 *     SHUNT[1-3]: (1 / 40uV) << 3 = 1 / 5uV
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 20) & 0xfffe;
 	else
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 5) & 0xfff8;
diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index 5423466de697..e918490f3ff7 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -396,7 +396,7 @@ static int ltc2947_read_temp(struct device *dev, const u32 attr, long *val,
 		return ret;
 
 	/* in milidegrees celcius, temp is given by: */
-	*val = (__val * 204) + 550;
+	*val = (__val * 204) + 5500;
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 2e4d05040e50..5e8853d3f8da 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1051,7 +1051,8 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
 	int i, result;
 	unsigned int temp;
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
-	int use_dma = i2c_imx->dma && msgs->len >= DMA_THRESHOLD && !block_data;
+	int use_dma = i2c_imx->dma && msgs->flags & I2C_M_DMA_SAFE &&
+		msgs->len >= DMA_THRESHOLD && !block_data;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
@@ -1217,7 +1218,8 @@ static int i2c_imx_xfer_common(struct i2c_adapter *adapter,
 			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg, atomic);
 		} else {
 			if (!atomic &&
-			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD)
+			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD &&
+				msgs[i].flags & I2C_M_DMA_SAFE)
 				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
 			else
 				result = i2c_imx_write(i2c_imx, &msgs[i], atomic);
diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 31e3d2c9d6bc..c1b679737240 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2362,8 +2362,17 @@ static struct platform_driver npcm_i2c_bus_driver = {
 
 static int __init npcm_i2c_init(void)
 {
+	int ret;
+
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	return platform_driver_register(&npcm_i2c_bus_driver);
+
+	ret = platform_driver_register(&npcm_i2c_bus_driver);
+	if (ret) {
+		debugfs_remove_recursive(npcm_i2c_debugfs_dir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(npcm_i2c_init);
 
diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index d4921385aaf7..b5f959bba422 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -245,14 +245,14 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4403_data *afe = iio_priv(indio_dev);
-	unsigned int reg = afe4403_channel_values[chan->address];
-	unsigned int field = afe4403_channel_leds[chan->address];
+	unsigned int reg, field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			reg = afe4403_channel_values[chan->address];
 			ret = afe4403_read(afe, reg, val);
 			if (ret)
 				return ret;
@@ -262,6 +262,7 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			field = afe4403_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[field], val);
 			if (ret)
 				return ret;
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index d8a27dfe074a..70f0f6f6351c 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -250,20 +250,20 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int value_reg = afe4404_channel_values[chan->address];
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int value_reg, led_field, offdac_field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			value_reg = afe4404_channel_values[chan->address];
 			ret = regmap_read(afe->regmap, value_reg, val);
 			if (ret)
 				return ret;
 			return IIO_VAL_INT;
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			ret = regmap_field_read(afe->fields[offdac_field], val);
 			if (ret)
 				return ret;
@@ -273,6 +273,7 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[led_field], val);
 			if (ret)
 				return ret;
@@ -295,19 +296,20 @@ static int afe4404_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int led_field, offdac_field;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			return regmap_field_write(afe->fields[offdac_field], val);
 		}
 		break;
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			return regmap_field_write(afe->fields[led_field], val);
 		}
 		break;
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index a62c7b4b8678..b46eac71941c 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -294,6 +294,8 @@ config RPR0521
 	tristate "ROHM RPR0521 ALS and proximity sensor driver"
 	depends on I2C
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here if you want to build support for ROHM's RPR0521
 	  ambient light and proximity sensor device.
diff --git a/drivers/input/touchscreen/raydium_i2c_ts.c b/drivers/input/touchscreen/raydium_i2c_ts.c
index 4d2d22a86977..bdb3e2c3ab79 100644
--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -210,12 +210,14 @@ static int raydium_i2c_send(struct i2c_client *client,
 
 		error = raydium_i2c_xfer(client, addr, xfer, ARRAY_SIZE(xfer));
 		if (likely(!error))
-			return 0;
+			goto out;
 
 		msleep(RM_RETRY_DELAY_MS);
 	} while (++tries < RM_MAX_RETRIES);
 
 	dev_err(&client->dev, "%s failed: %d\n", __func__, error);
+out:
+	kfree(tx_buf);
 	return error;
 }
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index f026bd269cb0..bff2420fc3e1 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -822,6 +822,7 @@ int __init dmar_dev_scope_init(void)
 			info = dmar_alloc_pci_notify_info(dev,
 					BUS_NOTIFY_ADD_DEVICE);
 			if (!info) {
+				pci_dev_put(dev);
 				return dmar_dev_scope_status;
 			} else {
 				dmar_pci_bus_add_dev(info);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index fa0cf1c3775d..751ff91af0ff 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4241,8 +4241,10 @@ static inline bool has_external_pci(void)
 	struct pci_dev *pdev = NULL;
 
 	for_each_pci_dev(pdev)
-		if (pdev->external_facing)
+		if (pdev->external_facing) {
+			pci_dev_put(pdev);
 			return true;
+		}
 
 	return false;
 }
diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
index ce879f6f8f82..144027035892 100644
--- a/drivers/media/common/videobuf2/frame_vector.c
+++ b/drivers/media/common/videobuf2/frame_vector.c
@@ -35,10 +35,7 @@
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		     struct frame_vector *vec)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	int ret = 0;
-	int err;
+	int ret;
 
 	if (nr_frames == 0)
 		return 0;
@@ -51,45 +48,17 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	ret = pin_user_pages_fast(start, nr_frames,
 				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
 				  (struct page **)(vec->ptrs));
-	if (ret > 0) {
-		vec->got_ref = true;
-		vec->is_pfns = false;
-		goto out_unlocked;
-	}
+	vec->got_ref = true;
+	vec->is_pfns = false;
+	vec->nr_frames = ret;
 
-	mmap_read_lock(mm);
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	ret = 0;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		vma = vma_lookup(mm, start);
-		if (!vma)
-			break;
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret == 0)
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/* Bail out if VMA doesn't completely cover the tail page. */
-		if (start < vma->vm_end)
-			break;
-	} while (ret < nr_frames);
-out:
-	mmap_read_unlock(mm);
-out_unlocked:
-	if (!ret)
-		ret = -EFAULT;
-	if (ret > 0)
-		vec->nr_frames = ret;
-	return ret;
+	if (likely(ret > 0))
+		return ret;
+
+	/* This used to (racily) return non-refcounted pfns. Let people know */
+	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
+	vec->nr_frames = 0;
+	return ret ? ret : -EFAULT;
 }
 EXPORT_SYMBOL(get_vaddr_frames);
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 47de3790058e..07eda6cc6767 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1482,6 +1482,11 @@ void mmc_init_erase(struct mmc_card *card)
 		card->pref_erase = 0;
 }
 
+static bool is_trim_arg(unsigned int arg)
+{
+	return (arg & MMC_TRIM_OR_DISCARD_ARGS) && arg != MMC_DISCARD_ARG;
+}
+
 static unsigned int mmc_mmc_erase_timeout(struct mmc_card *card,
 				          unsigned int arg, unsigned int qty)
 {
@@ -1764,7 +1769,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1794,7 +1799,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	 * identified by the card->eg_boundary flag.
 	 */
 	rem = card->erase_size - (from % card->erase_size);
-	if ((arg & MMC_TRIM_ARGS) && (card->eg_boundary) && (nr > rem)) {
+	if ((arg & MMC_TRIM_OR_DISCARD_ARGS) && card->eg_boundary && nr > rem) {
 		err = mmc_do_erase(card, from, from + rem - 1, arg);
 		from += rem;
 		if ((err) || (to <= from))
diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index 63524551a13a..4052f828f75e 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3181,7 +3181,8 @@ static int __mmc_test_register_dbgfs_file(struct mmc_card *card,
 	struct mmc_test_dbgfs_file *df;
 
 	if (card->debugfs_root)
-		debugfs_create_file(name, mode, card->debugfs_root, card, fops);
+		file = debugfs_create_file(name, mode, card->debugfs_root,
+					   card, fops);
 
 	df = kmalloc(sizeof(*df), GFP_KERNEL);
 	if (!df) {
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 71cec9bfe919..c6111adf8c08 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1495,7 +1495,7 @@ static void esdhc_cqe_enable(struct mmc_host *mmc)
 	 * system resume back.
 	 */
 	cqhci_writel(cq_host, 0, CQHCI_CTL);
-	if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT)
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
 		dev_err(mmc_dev(host->mmc),
 			"failed to exit halt state when enable CQE\n");
 
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index f5c519026b52..e85c95f3a868 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -457,7 +457,7 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	if (IS_ERR(sprd_host->pinctrl))
-		return 0;
+		goto reset;
 
 	switch (ios->signal_voltage) {
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -485,6 +485,8 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	/* Wait for 300 ~ 500 us for pin state stable */
 	usleep_range(300, 500);
+
+reset:
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 	return 0;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7728f26adb19..cda145c2ebb6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -338,6 +338,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -2257,11 +2258,46 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
 
+static bool sdhci_timing_has_preset(unsigned char timing)
+{
+	switch (timing) {
+	case MMC_TIMING_UHS_SDR12:
+	case MMC_TIMING_UHS_SDR25:
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+	case MMC_TIMING_UHS_DDR50:
+	case MMC_TIMING_MMC_DDR52:
+		return true;
+	};
+	return false;
+}
+
+static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
+{
+	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
+	       sdhci_timing_has_preset(timing);
+}
+
+static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
+{
+	/*
+	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
+	 * Frequency. Check if preset values need to be enabled, or the Driver
+	 * Strength needs updating. Note, clock changes are handled separately.
+	 */
+	return !host->preset_enabled &&
+	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
+}
+
 void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	if (ios->power_mode == MMC_POWER_UNDEFINED)
 		return;
 
@@ -2287,6 +2323,8 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -2313,6 +2351,17 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	host->ops->set_bus_width(host, ios->bus_width);
 
+	/*
+	 * Special case to avoid multiple clock changes during voltage
+	 * switching.
+	 */
+	if (!reinit_uhs &&
+	    turning_on_clk &&
+	    host->timing == ios->timing &&
+	    host->version >= SDHCI_SPEC_300 &&
+	    !sdhci_presetable_values_change(host, ios))
+		return;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if (!(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT)) {
@@ -2356,6 +2405,7 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -2383,19 +2433,14 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_uhs_signaling(host, ios->timing);
 		host->timing = ios->timing;
 
-		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
-				((ios->timing == MMC_TIMING_UHS_SDR12) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
-				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
-				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
+		if (sdhci_preset_needed(host, ios->timing)) {
 			u16 preset;
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
 			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
 						  preset);
+			host->drv_type = ios->drv_type;
 		}
 
 		/* Re-enable SD Clock */
@@ -3711,6 +3756,7 @@ int sdhci_resume_host(struct sdhci_host *host)
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -3773,6 +3819,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
 		/* Force clock and power re-program */
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 		mmc->ops->set_ios(mmc, &mmc->ios);
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 6c689be3e48f..6a5cc05576cd 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -523,6 +523,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */
diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index 194c86e0f340..8f6dccd5a587 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -264,22 +264,24 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"couldn't register device (err=%d)\n", err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "device registered (reg_base=0x%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_cc770dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c4596fbe6d2f..46ab6155795c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1931,7 +1931,7 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 	cdev->hclk = devm_clk_get(cdev->dev, "hclk");
 	cdev->cclk = devm_clk_get(cdev->dev, "cclk");
 
-	if (IS_ERR(cdev->cclk)) {
+	if (IS_ERR(cdev->hclk) || IS_ERR(cdev->cclk)) {
 		dev_err(cdev->dev, "no clock found\n");
 		ret = -ENODEV;
 	}
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8f184a852a0a..f2219aa2824b 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -120,7 +120,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
-		return ret;
+		goto err_free_dev;
 
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
@@ -132,7 +132,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = m_can_class_register(mcan_class);
 	if (ret)
-		goto err;
+		goto err_free_irq;
 
 	/* Enable interrupt control at CAN wrapper IP */
 	writel(0x1, base + CTL_CSR_INT_CTL_OFFSET);
@@ -144,8 +144,10 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	return 0;
 
-err:
+err_free_irq:
 	pci_free_irq_vectors(pci);
+err_free_dev:
+	m_can_class_free_dev(mcan_class->net);
 	return ret;
 }
 
@@ -161,6 +163,7 @@ static void m_can_pci_remove(struct pci_dev *pci)
 	writel(0x0, priv->base + CTL_CSR_INT_CTL_OFFSET);
 
 	m_can_class_unregister(mcan_class);
+	m_can_class_free_dev(mcan_class->net);
 	pci_free_irq_vectors(pci);
 }
 
diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
index d513fac50718..db3e767d5320 100644
--- a/drivers/net/can/sja1000/sja1000_isa.c
+++ b/drivers/net/can/sja1000/sja1000_isa.c
@@ -202,22 +202,24 @@ static int sja1000_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (reg_base=0x%p, irq=%d)\n",
 		 DRV_NAME, priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_sja1000dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index cd4e7f356e48..0e6faf962ebb 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2098,8 +2098,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		es58x_dev->netdev[channel_idx] = NULL;
+		free_candev(netdev);
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 0b6f29ee87b5..59a803e3c8d0 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -959,7 +959,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a9ef0544e30f..715859cb6560 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -13,6 +13,7 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_macsec.h"
+#include "aq_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -845,7 +846,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 
 	if (netif_running(ndev)) {
 		ndev_running = true;
-		dev_close(ndev);
+		aq_ndev_close(ndev);
 	}
 
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
@@ -861,7 +862,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		goto err_exit;
 
 	if (ndev_running)
-		err = dev_open(ndev, NULL);
+		err = aq_ndev_open(ndev);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index f069312463fb..45ed097bfe49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -53,7 +53,7 @@ struct net_device *aq_ndev_alloc(void)
 	return ndev;
 }
 
-static int aq_ndev_open(struct net_device *ndev)
+int aq_ndev_open(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
@@ -83,7 +83,7 @@ static int aq_ndev_open(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_close(struct net_device *ndev)
+int aq_ndev_close(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index a5a624b9ce73..2a562ab7a5af 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -14,5 +14,7 @@
 
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
+int aq_ndev_open(struct net_device *ndev);
+int aq_ndev_close(struct net_device *ndev);
 
 #endif /* AQ_MAIN_H */
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 36d52246bdc6..8cd371437c99 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1742,11 +1742,8 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	dma_addr = dma_map_single(&nic->pdev->dev, skb->data, skb->len,
 				  DMA_TO_DEVICE);
 	/* If we can't map the skb, have the upper layer try later */
-	if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
-		dev_kfree_skb_any(skb);
-		skb = NULL;
+	if (dma_mapping_error(&nic->pdev->dev, dma_addr))
 		return -ENOMEM;
-	}
 
 	/*
 	 * Use the last 4 bytes of the SKB payload packet as the CRC, used for
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..1b273446621c 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -32,6 +32,8 @@ struct workqueue_struct *fm10k_workqueue;
  **/
 static int __init fm10k_init_module(void)
 {
+	int ret;
+
 	pr_info("%s\n", fm10k_driver_string);
 	pr_info("%s\n", fm10k_copyright);
 
@@ -43,7 +45,13 @@ static int __init fm10k_init_module(void)
 
 	fm10k_dbg_init();
 
-	return fm10k_register_pci_driver();
+	ret = fm10k_register_pci_driver();
+	if (ret) {
+		fm10k_dbg_exit();
+		destroy_workqueue(fm10k_workqueue);
+	}
+
+	return ret;
 }
 module_init(fm10k_init_module);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ad6f6fe25057..19b5c5677584 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16494,6 +16494,8 @@ static struct pci_driver i40e_driver = {
  **/
 static int __init i40e_init_module(void)
 {
+	int err;
+
 	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
@@ -16511,7 +16513,14 @@ static int __init i40e_init_module(void)
 	}
 
 	i40e_dbg_init();
-	return pci_register_driver(&i40e_driver);
+	err = pci_register_driver(&i40e_driver);
+	if (err) {
+		destroy_workqueue(i40e_wq);
+		i40e_dbg_exit();
+		return err;
+	}
+
+	return 0;
 }
 module_init(i40e_init_module);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4b2e99be7ef5..82c4f1190e41 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1448,7 +1448,6 @@ static void iavf_fill_rss_lut(struct iavf_adapter *adapter)
 static int iavf_init_rss(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	int ret;
 
 	if (!RSS_PF(adapter)) {
 		/* Enable PCTYPES for RSS, TCP/UDP with IPv4/IPv6 */
@@ -1464,9 +1463,8 @@ static int iavf_init_rss(struct iavf_adapter *adapter)
 
 	iavf_fill_rss_lut(adapter);
 	netdev_rss_key_fill((void *)adapter->rss_key, adapter->rss_key_size);
-	ret = iavf_config_rss(adapter);
 
-	return ret;
+	return iavf_config_rss(adapter);
 }
 
 /**
@@ -4355,7 +4353,11 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
+
 	ret = pci_register_driver(&iavf_driver);
+	if (ret)
+		destroy_workqueue(iavf_wq);
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 7ef2e1241a76..0e7ff15af968 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4859,6 +4859,8 @@ static struct pci_driver ixgbevf_driver = {
  **/
 static int __init ixgbevf_init_module(void)
 {
+	int err;
+
 	pr_info("%s\n", ixgbevf_driver_string);
 	pr_info("%s\n", ixgbevf_copyright);
 	ixgbevf_wq = create_singlethread_workqueue(ixgbevf_driver_name);
@@ -4867,7 +4869,13 @@ static int __init ixgbevf_init_module(void)
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ixgbevf_driver);
+	err = pci_register_driver(&ixgbevf_driver);
+	if (err) {
+		destroy_workqueue(ixgbevf_wq);
+		return err;
+	}
+
+	return 0;
 }
 
 module_init(ixgbevf_init_module);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 85190f2f4d50..41c15a65fb45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1434,8 +1434,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 8f86b62e49e3..1b417b1d1cf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -309,6 +309,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index a19e8157c100..0f99d3612f89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -709,7 +709,7 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	int ret;
 
 	next_matcher = NULL;
-	list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+	list_for_each_entry(tmp_matcher, &tbl->matcher_list, list_node) {
 		if (tmp_matcher->prio >= matcher->prio) {
 			next_matcher = tmp_matcher;
 			break;
@@ -719,11 +719,11 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 
 	prev_matcher = NULL;
 	if (next_matcher && !first)
-		prev_matcher = list_prev_entry(next_matcher, matcher_list);
+		prev_matcher = list_prev_entry(next_matcher, list_node);
 	else if (!first)
 		prev_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -744,12 +744,12 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	}
 
 	if (prev_matcher)
-		list_add(&matcher->matcher_list, &prev_matcher->matcher_list);
+		list_add(&matcher->list_node, &prev_matcher->list_node);
 	else if (next_matcher)
-		list_add_tail(&matcher->matcher_list,
-			      &next_matcher->matcher_list);
+		list_add_tail(&matcher->list_node,
+			      &next_matcher->list_node);
 	else
-		list_add(&matcher->matcher_list, &tbl->matcher_list);
+		list_add(&matcher->list_node, &tbl->matcher_list);
 
 	return 0;
 }
@@ -922,7 +922,7 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	matcher->prio = priority;
 	matcher->match_criteria = match_criteria_enable;
 	refcount_set(&matcher->refcount, 1);
-	INIT_LIST_HEAD(&matcher->matcher_list);
+	INIT_LIST_HEAD(&matcher->list_node);
 
 	mlx5dr_domain_lock(tbl->dmn);
 
@@ -985,15 +985,15 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 	struct mlx5dr_domain *dmn = tbl->dmn;
 	int ret = 0;
 
-	if (list_is_last(&matcher->matcher_list, &tbl->matcher_list))
+	if (list_is_last(&matcher->list_node, &tbl->matcher_list))
 		next_matcher = NULL;
 	else
-		next_matcher = list_next_entry(matcher, matcher_list);
+		next_matcher = list_next_entry(matcher, list_node);
 
-	if (matcher->matcher_list.prev == &tbl->matcher_list)
+	if (matcher->list_node.prev == &tbl->matcher_list)
 		prev_matcher = NULL;
 	else
-		prev_matcher = list_prev_entry(matcher, matcher_list);
+		prev_matcher = list_prev_entry(matcher, list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -1013,7 +1013,7 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 			return ret;
 	}
 
-	list_del(&matcher->matcher_list);
+	list_del(&matcher->list_node);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 30ae3cda6d2e..0c7b57bf01d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -9,7 +9,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	struct mlx5dr_matcher *last_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -19,7 +19,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	if (!list_empty(&tbl->matcher_list))
 		last_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (tbl->dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX ||
 	    tbl->dmn->type == MLX5DR_DOMAIN_TYPE_FDB) {
@@ -68,6 +68,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 		}
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index bc206836af6a..9e2102f8bed1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -891,7 +891,7 @@ struct mlx5dr_matcher {
 	struct mlx5dr_table *tbl;
 	struct mlx5dr_matcher_rx_tx rx;
 	struct mlx5dr_matcher_rx_tx tx;
-	struct list_head matcher_list;
+	struct list_head list_node;
 	u32 prio;
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 057b7419404d..5d0cecf80b38 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -249,25 +249,26 @@ static void nixge_hw_dma_bd_release(struct net_device *ndev)
 	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < RX_BD_NUM; i++) {
-		phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						     phys);
-
-		dma_unmap_single(ndev->dev.parent, phys_addr,
-				 NIXGE_MAX_JUMBO_FRAME_SIZE,
-				 DMA_FROM_DEVICE);
-
-		skb = (struct sk_buff *)(uintptr_t)
-			nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						 sw_id_offset);
-		dev_kfree_skb(skb);
-	}
+	if (priv->rx_bd_v) {
+		for (i = 0; i < RX_BD_NUM; i++) {
+			phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							     phys);
+
+			dma_unmap_single(ndev->dev.parent, phys_addr,
+					 NIXGE_MAX_JUMBO_FRAME_SIZE,
+					 DMA_FROM_DEVICE);
+
+			skb = (struct sk_buff *)(uintptr_t)
+				nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							 sw_id_offset);
+			dev_kfree_skb(skb);
+		}
 
-	if (priv->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(*priv->rx_bd_v) * RX_BD_NUM,
 				  priv->rx_bd_v,
 				  priv->rx_bd_p);
+	}
 
 	if (priv->tx_skb)
 		devm_kfree(ndev->dev.parent, priv->tx_skb);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index bd0607680329..2fd5c6fdb500 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -2991,7 +2991,7 @@ static void qlcnic_83xx_recover_driver_lock(struct qlcnic_adapter *adapter)
 		QLCWRX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK, val);
 		dev_info(&adapter->pdev->dev,
 			 "%s: lock recovery initiated\n", __func__);
-		msleep(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
 		val = QLCRDX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK);
 		id = ((val >> 2) & 0xF);
 		if (id == adapter->portnum) {
@@ -3027,7 +3027,7 @@ int qlcnic_83xx_lock_driver(struct qlcnic_adapter *adapter)
 		if (status)
 			break;
 
-		msleep(QLC_83XX_DRV_LOCK_WAIT_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_WAIT_DELAY);
 		i++;
 
 		if (i == 1)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 12420239c8ca..77a19336abec 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2491,6 +2491,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 412abfabd28b..60638bf18f1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -745,6 +745,8 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
+	} else {
+		pr_debug("\tReceive Flow-Control OFF\n");
 	}
 	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8590249d4468..eba97adaf1fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1158,8 +1158,16 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_AUTO;
+	else if (rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_RX;
+	else if (!rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_TX;
+	else
+		priv->flow_ctrl = FLOW_OFF;
+
+	stmmac_mac_flow_ctrl(priv, duplex);
 
 	if (ctrl != old_ctrl)
 		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 901571c2626a..2298b3c38f89 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2054,7 +2054,7 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
 
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
-		if (port->ndev)
+		if (port->ndev && port->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(port->ndev);
 	}
 }
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1c1584fca632..40e745a1d185 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -120,7 +120,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* Associate the fwnode with the device structure so it
 		 * can be looked up later.
 		 */
-		phy->mdio.dev.fwnode = child;
+		phy->mdio.dev.fwnode = fwnode_handle_get(child);
 
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..1b7d588ff3c5 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -484,7 +484,14 @@ static int __init ntb_netdev_init_module(void)
 	rc = ntb_transport_register_client_dev(KBUILD_MODNAME);
 	if (rc)
 		return rc;
-	return ntb_transport_register_client(&ntb_netdev_client);
+
+	rc = ntb_transport_register_client(&ntb_netdev_client);
+	if (rc) {
+		ntb_transport_unregister_client_dev(KBUILD_MODNAME);
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ntb_netdev_init_module);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c5b92ffaffb9..996842a1a9a3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -215,6 +215,7 @@ static void phy_mdio_device_free(struct mdio_device *mdiodev)
 
 static void phy_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_phy_device(dev));
 }
 
@@ -1518,6 +1519,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 error_module_put:
 	module_put(d->driver->owner);
+	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 575077998d8a..a1dda57c812d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -687,7 +687,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (tun)
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
-		sock_put(&tfile->sk);
 	}
 }
 
@@ -703,6 +702,9 @@ static void tun_detach(struct tun_file *tfile, bool clean)
 	if (dev)
 		netdev_state_change(dev);
 	rtnl_unlock();
+
+	if (clean)
+		sock_put(&tfile->sk);
 }
 
 static void tun_detach_all(struct net_device *dev)
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index bdb2d32cdb6d..e323fe1ae538 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -830,8 +830,7 @@ void ipc_mux_ul_encoded_process(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 			ipc_mux->ul_data_pend_bytes);
 
 	/* Reset the skb settings. */
-	skb->tail = 0;
-	skb->len = 0;
+	skb_trim(skb, 0);
 
 	/* Add the consumed ADB to the free list. */
 	skb_queue_tail((&ipc_mux->ul_adb.free_list), skb);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.h b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
index 9b3a6d86ece7..289397c4ea6c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
@@ -122,7 +122,7 @@ struct iosm_protocol {
 	struct iosm_imem *imem;
 	struct ipc_rsp *rsp_ring[IPC_MEM_MSG_ENTRIES];
 	struct device *dev;
-	phys_addr_t phy_ap_shm;
+	dma_addr_t phy_ap_shm;
 	u32 old_msg_tail;
 };
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 92fe67bd2457..694373951b18 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3920,7 +3920,7 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	mutex_unlock(&ns->ctrl->subsys->lock);
 
 	/* guarantee not available in head->list */
-	synchronize_rcu();
+	synchronize_srcu(&ns->head->srcu);
 
 	/* wait for concurrent submissions */
 	if (nvme_mpath_clear_current_path(ns))
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 36b48e2ff642..fe199d568a4a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -151,11 +151,14 @@ void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
 	struct nvme_ns_head *head = ns->head;
 	sector_t capacity = get_capacity(head->disk);
 	int node;
+	int srcu_idx;
 
+	srcu_idx = srcu_read_lock(&head->srcu);
 	list_for_each_entry_rcu(ns, &head->list, siblings) {
 		if (capacity != get_capacity(ns->disk))
 			clear_bit(NVME_NS_READY, &ns->flags);
 	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
 
 	for_each_node(node)
 		rcu_assign_pointer(head->current_path[node], NULL);
diff --git a/drivers/nvmem/rmem.c b/drivers/nvmem/rmem.c
index b11c3c974b3d..80cb187f1481 100644
--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -37,9 +37,9 @@ static int rmem_read(void *context, unsigned int offset,
 	 * but as of Dec 2020 this isn't possible on arm64.
 	 */
 	addr = memremap(priv->mem->base, available, MEMREMAP_WB);
-	if (IS_ERR(addr)) {
+	if (!addr) {
 		dev_err(priv->dev, "Failed to remap memory region\n");
-		return PTR_ERR(addr);
+		return -ENOMEM;
 	}
 
 	count = memory_read_from_buffer(val, bytes, &off, addr, available);
diff --git a/drivers/of/property.c b/drivers/of/property.c
index a3483484a5a2..acf0d3110357 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -975,8 +975,10 @@ of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
 						       nargs, index, &of_args);
 	if (ret < 0)
 		return ret;
-	if (!args)
+	if (!args) {
+		of_node_put(of_args.np);
 		return 0;
+	}
 
 	args->nargs = of_args.args_count;
 	args->fwnode = of_fwnode_handle(of_args.np);
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 48f55991ae8c..32807aab9343 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -436,9 +436,14 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
 	writel(value, padcfg0);
 }
 
+static int __intel_gpio_get_gpio_mode(u32 value)
+{
+	return (value & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
 {
-	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+	return __intel_gpio_get_gpio_mode(readl(padcfg0));
 }
 
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
@@ -1659,6 +1664,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_data);
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1673,6 +1679,25 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	    gpiochip_line_is_irq(&pctrl->chip, intel_pin_to_gpio(pctrl, pin)))
 		return true;
 
+	/*
+	 * The firmware on some systems may configure GPIO pins to be
+	 * an interrupt source in so called "direct IRQ" mode. In such
+	 * cases the GPIO controller driver has no idea if those pins
+	 * are being used or not. At the same time, there is a known bug
+	 * in the firmwares that don't restore the pin settings correctly
+	 * after suspend, i.e. by an unknown reason the Rx value becomes
+	 * inverted.
+	 *
+	 * Hence, let's save and restore the pins that are configured
+	 * as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
+	 */
+	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
+	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+		return true;
+
 	return false;
 }
 
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 67bec7ea0f8b..414ee6bb8ac9 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -727,7 +727,7 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 
 	mux_bytes = pcs->width / BITS_PER_BYTE;
 
-	if (pcs->bits_per_mux) {
+	if (pcs->bits_per_mux && pcs->fmask) {
 		pcs->bits_per_pin = fls(pcs->fmask);
 		nr_pins = (pcs->size * BITS_PER_BYTE) / pcs->bits_per_pin;
 	} else {
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index b2dd0a4d2446..890b2cf02149 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -439,8 +439,7 @@ static unsigned int mx51_ecspi_clkdiv(struct spi_imx_data *spi_imx,
 	unsigned int pre, post;
 	unsigned int fin = spi_imx->spi_clk;
 
-	if (unlikely(fspi > fin))
-		return 0;
+	fspi = min(fspi, fin);
 
 	post = fls(fin) - fls(fspi);
 	if (fin > fspi << post)
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index fc166cc2c856..ce7ff7a0207f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -61,6 +61,53 @@ static void stm32_usart_clr_bits(struct uart_port *port, u32 reg, u32 bits)
 	writel_relaxed(val, port->membase + reg);
 }
 
+static unsigned int stm32_usart_tx_empty(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
+		return TIOCSER_TEMT;
+
+	return 0;
+}
+
+static void stm32_usart_rs485_rts_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	}
+}
+
+static void stm32_usart_rs485_rts_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	}
+}
+
 static void stm32_usart_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 					 u32 delay_DDE, u32 baud)
 {
@@ -149,6 +196,12 @@ static int stm32_usart_config_rs485(struct uart_port *port,
 
 	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
+	/* Adjust RTS polarity in case it's driven in software */
+	if (stm32_usart_tx_empty(port))
+		stm32_usart_rs485_rts_disable(port);
+	else
+		stm32_usart_rs485_rts_enable(port);
+
 	return 0;
 }
 
@@ -314,6 +367,14 @@ static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
 		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
+static void stm32_usart_tc_interrupt_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	stm32_usart_set_bits(port, ofs->cr1, USART_CR1_TCIE);
+}
+
 static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -325,6 +386,14 @@ static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
+static void stm32_usart_tc_interrupt_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TCIE);
+}
+
 static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -426,6 +495,13 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	u32 isr;
 	int ret;
 
+	if (!stm32_port->hw_flow_control &&
+	    port->rs485.flags & SER_RS485_ENABLED) {
+		stm32_port->txdone = false;
+		stm32_usart_tc_interrupt_disable(port);
+		stm32_usart_rs485_rts_enable(port);
+	}
+
 	if (port->x_char) {
 		if (stm32_port->tx_dma_busy)
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
@@ -465,8 +541,14 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit)) {
 		stm32_usart_tx_interrupt_disable(port);
+		if (!stm32_port->hw_flow_control &&
+		    port->rs485.flags & SER_RS485_ENABLED) {
+			stm32_port->txdone = true;
+			stm32_usart_tc_interrupt_enable(port);
+		}
+	}
 }
 
 static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
@@ -479,6 +561,13 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 
 	sr = readl_relaxed(port->membase + ofs->isr);
 
+	if (!stm32_port->hw_flow_control &&
+	    port->rs485.flags & SER_RS485_ENABLED &&
+	    (sr & USART_SR_TC)) {
+		stm32_usart_tc_interrupt_disable(port);
+		stm32_usart_rs485_rts_disable(port);
+	}
+
 	if ((sr & USART_SR_RTOF) && ofs->icr != UNDEF_REG)
 		writel_relaxed(USART_ICR_RTOCF,
 			       port->membase + ofs->icr);
@@ -518,17 +607,6 @@ static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static unsigned int stm32_usart_tx_empty(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-
-	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
-		return TIOCSER_TEMT;
-
-	return 0;
-}
-
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -566,42 +644,23 @@ static void stm32_usart_disable_ms(struct uart_port *port)
 /* Transmit stop */
 static void stm32_usart_stop_tx(struct uart_port *port)
 {
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
 	stm32_usart_tx_interrupt_disable(port);
 
-	if (rs485conf->flags & SER_RS485_ENABLED) {
-		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl & ~TIOCM_RTS);
-		} else {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl | TIOCM_RTS);
-		}
-	}
+	stm32_usart_rs485_rts_disable(port);
 }
 
 /* There are probably characters waiting to be transmitted. */
 static void stm32_usart_start_tx(struct uart_port *port)
 {
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit) && !port->x_char)
+	if (uart_circ_empty(xmit) && !port->x_char) {
+		stm32_usart_rs485_rts_disable(port);
 		return;
-
-	if (rs485conf->flags & SER_RS485_ENABLED) {
-		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl | TIOCM_RTS);
-		} else {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl & ~TIOCM_RTS);
-		}
 	}
 
+	stm32_usart_rs485_rts_enable(port);
+
 	stm32_usart_transmit_chars(port);
 }
 
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index 07ac291328cd..ad6335155de2 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -267,6 +267,7 @@ struct stm32_port {
 	bool hw_flow_control;
 	bool swap;		 /* swap RX & TX pins */
 	bool fifoen;
+	bool txdone;
 	int rxftcfg;		/* RX FIFO threshold CFG      */
 	int txftcfg;		/* TX FIFO threshold CFG      */
 	bool wakeup_src;
diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index c0031a3ab42f..3ac5fcf98d0d 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -167,8 +167,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 			clear_bit(AFS_SERVER_FL_HAS_FS64, &server->flags);
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		server->rtt = rtt_us;
 		alist->preferred = index;
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 60bec5a108fa..1ff527bbe54c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2060,10 +2060,29 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	struct btrfs_data_container *inodes = ctx;
+	const size_t c = 3 * sizeof(u64);
+
+	if (inodes->bytes_left >= c) {
+		inodes->bytes_left -= c;
+		inodes->val[inodes->elem_cnt] = inum;
+		inodes->val[inodes->elem_cnt + 1] = offset;
+		inodes->val[inodes->elem_cnt + 2] = root;
+		inodes->elem_cnt += 3;
+	} else {
+		inodes->bytes_missing += c - inodes->bytes_left;
+		inodes->bytes_left = 0;
+		inodes->elem_missed += 3;
+	}
+
+	return 0;
+}
+
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
-				bool ignore_offset)
+				void *ctx, bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -2081,7 +2100,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx, ignore_offset);
+					build_ino_list, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index ba454032dbe2..2759de7d324c 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -35,8 +35,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				bool ignore_offset);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
+				struct btrfs_path *path, void *ctx,
 				bool ignore_offset);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d9ff0697132b..391a4af9c5e5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3911,26 +3911,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
-static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
-{
-	struct btrfs_data_container *inodes = ctx;
-	const size_t c = 3 * sizeof(u64);
-
-	if (inodes->bytes_left >= c) {
-		inodes->bytes_left -= c;
-		inodes->val[inodes->elem_cnt] = inum;
-		inodes->val[inodes->elem_cnt + 1] = offset;
-		inodes->val[inodes->elem_cnt + 2] = root;
-		inodes->elem_cnt += 3;
-	} else {
-		inodes->bytes_missing += c - inodes->bytes_left;
-		inodes->bytes_left = 0;
-		inodes->elem_missed += 3;
-	}
-
-	return 0;
-}
-
 static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 					void __user *arg, int version)
 {
@@ -3966,21 +3946,20 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes, ignore_offset);
+					  inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -3992,7 +3971,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e01065696e9c..485abe7faeab 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2903,14 +2903,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, dstgroup);
-		if (ret) {
-			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {
@@ -3280,7 +3273,8 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	return btrfs_fs_closing(fs_info) ||
-		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state) ||
+		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
@@ -3310,11 +3304,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = PTR_ERR(trans);
 			break;
 		}
-		if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-			err = -EINTR;
-		} else {
-			err = qgroup_rescan_leaf(trans, path);
-		}
+
+		err = qgroup_rescan_leaf(trans, path);
+
 		if (err > 0)
 			btrfs_commit_transaction(trans);
 		else
@@ -3328,7 +3320,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	} else if (err < 0) {
+	} else if (err < 0 || stopped) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index a552399e211d..0c293ff6697b 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -222,7 +222,7 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 
 	/* if it cannot be handled with fast symlink scheme */
 	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= PAGE_SIZE) {
+	    inode->i_size >= PAGE_SIZE || inode->i_size < 0) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8ae64df90e3..c2fdde6fdda3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5322,7 +5322,29 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS       128
+
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
@@ -5332,6 +5354,8 @@ struct io_poll_table {
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -5440,6 +5464,23 @@ static int io_poll_check_events(struct io_kiocb *req)
 			return 0;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->result = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->result = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the
+			 * flag in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };
@@ -5464,11 +5505,15 @@ static int io_poll_check_events(struct io_kiocb *req)
 			return 0;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->result = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
+					IO_POLL_REF_MASK);
 
 	return 1;
 }
@@ -5640,7 +5685,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll_table *ipt, __poll_t mask)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
@@ -5686,11 +5730,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	}
 
 	/*
-	 * Release ownership. If someone tried to queue a tw while it was
-	 * locked, kick it off for them.
+	 * Try to release ownership. If we see a change of state, e.g.
+	 * poll was waken up, queue up a tw, it'll deal with it.
 	 */
-	v = atomic_dec_return(&req->poll_refs);
-	if (unlikely(v & IO_POLL_REF_MASK))
+	if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 		__io_poll_execute(req, 0);
 	return 0;
 }
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 1a3d183027b9..8fedc7104320 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -111,6 +111,13 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
+
+	if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
+		nilfs_error(dat->i_sb,
+			    "state inconsistency probably due to duplicate use of vblocknr = %llu",
+			    (unsigned long long)req->pr_entry_nr);
+		return;
+	}
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index d9a65c6a8816..545578fb814b 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -445,7 +445,7 @@ static inline bool mmc_ready_for_data(u32 status)
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index ba52f3a3478e..4efd267e2937 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -378,7 +378,6 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..65058faea4db 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -26,6 +26,8 @@ struct sctp_sched_ops {
 	int (*init)(struct sctp_stream *stream);
 	/* Init a stream */
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
+	/* free a stream */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 0dbdb98fdf2d..c1f3ca244a69 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2182,14 +2182,15 @@ long __do_semtimedop(int semid, struct sembuf *sops,
 		 * scenarios where we were awakened externally, during the
 		 * window between wake_q_add() and wake_up_q().
 		 */
+		rcu_read_lock();
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
 			/* see SEM_BARRIER_2 for purpose/pairing */
 			smp_acquire__after_ctrl_dep();
+			rcu_read_unlock();
 			goto out;
 		}
 
-		rcu_read_lock();
 		locknum = sem_lock(sma, sops, nsops);
 
 		if (!ipc_valid_object(&sma->sem_perm))
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index de4d741d99a3..6c2d39a3d558 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -71,7 +71,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 				GFP_ATOMIC | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 60cb300fa0d0..44f982b73640 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9077,7 +9077,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
 				subprog->jited_len, unregister,
-				prog->aux->ksym.name);
+				subprog->aux->ksym.name);
 		}
 	}
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 23c08bf3db58..34ce5953dbb0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -379,13 +379,14 @@ int proc_dostring(struct ctl_table *table, int write,
 			ppos);
 }
 
-static size_t proc_skip_spaces(char **buf)
+static void proc_skip_spaces(char **buf, size_t *size)
 {
-	size_t ret;
-	char *tmp = skip_spaces(*buf);
-	ret = tmp - *buf;
-	*buf = tmp;
-	return ret;
+	while (*size) {
+		if (!isspace(**buf))
+			break;
+		(*size)--;
+		(*buf)++;
+	}
 }
 
 static void proc_skip_char(char **buf, size_t *size, const char v)
@@ -454,13 +455,12 @@ static int proc_get_long(char **buf, size_t *size,
 			  unsigned long *val, bool *neg,
 			  const char *perm_tr, unsigned perm_tr_len, char *tr)
 {
-	int len;
 	char *p, tmp[TMPBUFLEN];
+	ssize_t len = *size;
 
-	if (!*size)
+	if (len <= 0)
 		return -EINVAL;
 
-	len = *size;
 	if (len > TMPBUFLEN - 1)
 		len = TMPBUFLEN - 1;
 
@@ -633,7 +633,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		bool neg;
 
 		if (write) {
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 
 			if (!left)
 				break;
@@ -660,7 +660,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	if (!write && !first && left && !err)
 		proc_put_char(&buffer, &left, '\n');
 	if (write && !err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write && first)
 		return err ? : -EINVAL;
 	*lenp -= left;
@@ -702,7 +702,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	if (left > PAGE_SIZE - 1)
 		left = PAGE_SIZE - 1;
 
-	left -= proc_skip_spaces(&p);
+	proc_skip_spaces(&p, &left);
 	if (!left) {
 		err = -EINVAL;
 		goto out_free;
@@ -722,7 +722,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	}
 
 	if (!err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 
 out_free:
 	if (err)
@@ -1259,7 +1259,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 		if (write) {
 			bool neg;
 
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 			if (!left)
 				break;
 
@@ -1287,7 +1287,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 	if (!write && !first && left && !err)
 		proc_put_char(&buffer, &left, '\n');
 	if (write && !err)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write && first)
 		return err ? : -EINVAL;
 	*lenp -= left;
diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
index e34e8182ee4b..d4f713723323 100644
--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -118,6 +118,7 @@ int dyn_event_release(const char *raw_command, struct dyn_event_operations *type
 		if (ret)
 			break;
 	}
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 out:
 	argv_free(argv);
@@ -214,6 +215,7 @@ int dyn_events_release_all(struct dyn_event_operations *type)
 			break;
 	}
 out:
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 
 	return ret;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c84c94334a60..1aadc9a6487b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2874,7 +2874,10 @@ static int probe_remove_event_call(struct trace_event_call *call)
 		 * TRACE_REG_UNREGISTER.
 		 */
 		if (file->flags & EVENT_FILE_FL_ENABLED)
-			return -EBUSY;
+			goto busy;
+
+		if (file->flags & EVENT_FILE_FL_WAS_ENABLED)
+			tr->clear_trace = true;
 		/*
 		 * The do_for_each_event_file_safe() is
 		 * a double loop. After finding the call for this
@@ -2887,6 +2890,12 @@ static int probe_remove_event_call(struct trace_event_call *call)
 	__trace_remove_event_call(call);
 
 	return 0;
+ busy:
+	/* No need to clear the trace now */
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		tr->clear_trace = false;
+	}
+	return -EBUSY;
 }
 
 /* Remove an event_call */
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index d5c7b9a37ed5..31e3e0bbd129 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4677,6 +4677,9 @@ static void event_hist_trigger(struct event_trigger_data *data,
 	void *key = NULL;
 	unsigned int i;
 
+	if (unlikely(!rbe))
+		return;
+
 	memset(compound_key, 0, hist_data->key_size);
 
 	for_each_hist_key_field(i, hist_data) {
diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 6ef1164c0440..90c4f70dc9fd 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -730,7 +730,7 @@ void osnoise_trace_irq_entry(int id)
 void osnoise_trace_irq_exit(int id, const char *desc)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;
@@ -861,7 +861,7 @@ static void trace_softirq_entry_callback(void *data, unsigned int vec_nr)
 static void trace_softirq_exit_callback(void *data, unsigned int vec_nr)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;
@@ -969,7 +969,7 @@ thread_entry(struct osnoise_variables *osn_var, struct task_struct *t)
 static void
 thread_exit(struct osnoise_variables *osn_var, struct task_struct *t)
 {
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1699b2124558..f71db0cc3bf1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -352,8 +352,10 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && (PARISC || XTENSA))
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
@@ -1872,8 +1874,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
diff --git a/mm/compaction.c b/mm/compaction.c
index 48a2111ce437..e8fcf0e0c1ca 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -779,7 +779,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN to isolate
  * @end_pfn:	The one-past-the-last PFN to isolate, within same pageblock
- * @isolate_mode: Isolation mode to be used.
+ * @mode:	Isolation mode to be used.
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn). The range is expected to be within same pageblock.
@@ -792,7 +792,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
  */
 static int
 isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
-			unsigned long end_pfn, isolate_mode_t isolate_mode)
+			unsigned long end_pfn, isolate_mode_t mode)
 {
 	pg_data_t *pgdat = cc->zone->zone_pgdat;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -800,6 +800,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	unsigned long flags = 0;
 	struct lruvec *locked = NULL;
 	struct page *page = NULL, *valid_page = NULL;
+	struct address_space *mapping;
 	unsigned long start_pfn = low_pfn;
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
@@ -984,40 +985,76 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					locked = NULL;
 				}
 
-				if (!isolate_movable_page(page, isolate_mode))
+				if (!isolate_movable_page(page, mode))
 					goto isolate_success;
 			}
 
 			goto isolate_fail;
 		}
 
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
-		if (!page_mapping(page) &&
-		    page_count(page) > page_mapcount(page))
-			goto isolate_fail;
+		mapping = page_mapping(page);
+		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+			goto isolate_fail_put;
 
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
 		 */
-		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
-			goto isolate_fail;
+		if (!(cc->gfp_mask & __GFP_FS) && mapping)
+			goto isolate_fail_put;
+
+		/* Only take pages on LRU: a check now makes later tests safe */
+		if (!PageLRU(page))
+			goto isolate_fail_put;
+
+		/* Compaction might skip unevictable pages but CMA takes them */
+		if (!(mode & ISOLATE_UNEVICTABLE) && PageUnevictable(page))
+			goto isolate_fail_put;
 
 		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
+		 * To minimise LRU disruption, the caller can indicate with
+		 * ISOLATE_ASYNC_MIGRATE that it only wants to isolate pages
+		 * it will be able to migrate without blocking - clean pages
+		 * for the most part.  PageWriteback would require blocking.
 		 */
-		if (unlikely(!get_page_unless_zero(page)))
-			goto isolate_fail;
-
-		if (!__isolate_lru_page_prepare(page, isolate_mode))
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageWriteback(page))
 			goto isolate_fail_put;
 
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageDirty(page)) {
+			bool migrate_dirty;
+
+			/*
+			 * Only pages without mappings or that have a
+			 * ->migratepage callback are possible to migrate
+			 * without blocking. However, we can be racing with
+			 * truncation so it's necessary to lock the page
+			 * to stabilise the mapping as truncation holds
+			 * the page lock until after the page is removed
+			 * from the page cache.
+			 */
+			if (!trylock_page(page))
+				goto isolate_fail_put;
+
+			mapping = page_mapping(page);
+			migrate_dirty = !mapping || mapping->a_ops->migratepage;
+			unlock_page(page);
+			if (!migrate_dirty)
+				goto isolate_fail_put;
+		}
+
 		/* Try isolate the page */
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1b63d6155416..201acea81804 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1865,69 +1865,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	return nr_reclaimed;
 }
 
-/*
- * Attempt to remove the specified page from its LRU.  Only take this page
- * if it is of the appropriate PageActive status.  Pages which are being
- * freed elsewhere are also ignored.
- *
- * page:	page to consider
- * mode:	one of the LRU isolation modes defined above
- *
- * returns true on success, false on failure.
- */
-bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
-{
-	/* Only take pages on the LRU. */
-	if (!PageLRU(page))
-		return false;
-
-	/* Compaction should not handle unevictable pages but CMA can do so */
-	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return false;
-
-	/*
-	 * To minimise LRU disruption, the caller can indicate that it only
-	 * wants to isolate pages it will be able to operate on without
-	 * blocking - clean pages for the most part.
-	 *
-	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
-	 * that it is possible to migrate without blocking
-	 */
-	if (mode & ISOLATE_ASYNC_MIGRATE) {
-		/* All the caller can do on PageWriteback is block */
-		if (PageWriteback(page))
-			return false;
-
-		if (PageDirty(page)) {
-			struct address_space *mapping;
-			bool migrate_dirty;
-
-			/*
-			 * Only pages without mappings or that have a
-			 * ->migratepage callback are possible to migrate
-			 * without blocking. However, we can be racing with
-			 * truncation so it's necessary to lock the page
-			 * to stabilise the mapping as truncation holds
-			 * the page lock until after the page is removed
-			 * from the page cache.
-			 */
-			if (!trylock_page(page))
-				return false;
-
-			mapping = page_mapping(page);
-			migrate_dirty = !mapping || mapping->a_ops->migratepage;
-			unlock_page(page);
-			if (!migrate_dirty)
-				return false;
-		}
-	}
-
-	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return false;
-
-	return true;
-}
-
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
@@ -1979,11 +1916,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
 	LIST_HEAD(pages_skipped);
-	isolate_mode_t mode = (sc->may_unmap ? 0 : ISOLATE_UNMAPPED);
 
 	total_scan = 0;
 	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
+		struct list_head *move_to = src;
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1993,9 +1930,9 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		total_scan += nr_pages;
 
 		if (page_zonenum(page) > sc->reclaim_idx) {
-			list_move(&page->lru, &pages_skipped);
 			nr_skipped[page_zonenum(page)] += nr_pages;
-			continue;
+			move_to = &pages_skipped;
+			goto move;
 		}
 
 		/*
@@ -2003,37 +1940,34 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		 * return with no isolated pages if the LRU mostly contains
 		 * ineligible pages.  This causes the VM to not reclaim any
 		 * pages, triggering a premature OOM.
-		 *
-		 * Account all tail pages of THP.  This would not cause
-		 * premature OOM since __isolate_lru_page() returns -EBUSY
-		 * only when the page is being freed somewhere else.
+		 * Account all tail pages of THP.
 		 */
 		scan += nr_pages;
-		if (!__isolate_lru_page_prepare(page, mode)) {
-			/* It is being freed elsewhere */
-			list_move(&page->lru, src);
-			continue;
-		}
+
+		if (!PageLRU(page))
+			goto move;
+		if (!sc->may_unmap && page_mapped(page))
+			goto move;
+
 		/*
 		 * Be careful not to clear PageLRU until after we're
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page))) {
-			list_move(&page->lru, src);
-			continue;
-		}
+		if (unlikely(!get_page_unless_zero(page)))
+			goto move;
 
 		if (!TestClearPageLRU(page)) {
 			/* Another thread is already isolating this page */
 			put_page(page);
-			list_move(&page->lru, src);
-			continue;
+			goto move;
 		}
 
 		nr_taken += nr_pages;
 		nr_zone_taken[page_zonenum(page)] += nr_pages;
-		list_move(&page->lru, dst);
+		move_to = dst;
+move:
+		list_move(&page->lru, move_to);
 	}
 
 	/*
@@ -2057,7 +1991,8 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 	}
 	*nr_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				    total_scan, skipped, nr_taken, mode, lru);
+				    total_scan, skipped, nr_taken,
+				    sc->may_unmap ? 0 : ISOLATE_UNMAPPED, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 31f2026514f3..e1c2c9242ce2 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -864,8 +864,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	struct file *file;
 
 	p = kzalloc(sizeof(struct p9_trans_fd), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		sock_release(csocket);
 		return -ENOMEM;
+	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
 	file = sock_alloc_file(csocket, 0, NULL);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 13f81c246f5f..07892c4b6d0c 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -309,17 +309,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 55de6fa83dea..af64ae689b13 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -886,13 +886,15 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	if (fi->nh) {
+		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+			return 1;
+		return 0;
+	}
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index 26d2f8ba7029..758ef63669e7 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -457,6 +457,9 @@ static u32 ieee80211_get_rate_duration(struct ieee80211_hw *hw,
 			 (status->encoding == RX_ENC_HE && streams > 8)))
 		return 0;
 
+	if (idx >= MCS_GROUP_RATES)
+		return 0;
+
 	duration = airtime_mcs_groups[group].duration[idx];
 	duration <<= airtime_mcs_groups[group].shift;
 	*overhead = 36 + (streams << 2);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 968dac3fcf58..ceca0d6c41b5 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2246,8 +2246,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3480,8 +3479,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..ee6514af830f 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -52,6 +52,19 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 	}
 }
 
+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_sched_ops *sched;
+
+	if (!SCTP_SO(stream, sid)->ext)
+		return;
+
+	sched = sctp_sched_ops_from_stream(stream);
+	sched->free_sid(stream, sid);
+	kfree(SCTP_SO(stream, sid)->ext);
+	SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -70,16 +83,14 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(SCTP_SO(new, i)->ext);
+			sctp_stream_free_ext(new, i);
 			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
 			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
-	for (i = outcnt; i < stream->outcnt; i++) {
-		kfree(SCTP_SO(stream, i)->ext);
-		SCTP_SO(stream, i)->ext = NULL;
-	}
+	for (i = outcnt; i < stream->outcnt; i++)
+		sctp_stream_free_ext(stream, i);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
@@ -174,9 +185,9 @@ void sctp_stream_free(struct sctp_stream *stream)
 	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
 	int i;
 
-	sched->free(stream);
+	sched->unsched_all(stream);
 	for (i = 0; i < stream->outcnt; i++)
-		kfree(SCTP_SO(stream, i)->ext);
+		sctp_stream_free_ext(stream, i);
 	genradix_free(&stream->out);
 	genradix_free(&stream->in);
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index a2e1d34f52c5..33c2630c2496 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -46,6 +46,10 @@ static int sctp_sched_fcfs_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_fcfs_free(struct sctp_stream *stream)
 {
 }
@@ -96,6 +100,7 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.get = sctp_sched_fcfs_get,
 	.init = sctp_sched_fcfs_init,
 	.init_sid = sctp_sched_fcfs_init_sid,
+	.free_sid = sctp_sched_fcfs_free_sid,
 	.free = sctp_sched_fcfs_free,
 	.enqueue = sctp_sched_fcfs_enqueue,
 	.dequeue = sctp_sched_fcfs_dequeue,
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..4fc9f2923ed1 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -204,6 +204,24 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
+	int i;
+
+	if (!prio)
+		return;
+
+	SCTP_SO(stream, sid)->ext->prio_head = NULL;
+	for (i = 0; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext &&
+		    SCTP_SO(stream, i)->ext->prio_head == prio)
+			return;
+	}
+
+	kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
 	struct sctp_stream_priorities *prio, *n;
@@ -323,6 +341,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index ff425aed62c7..cc444fe0d67c 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -90,6 +90,10 @@ static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_rr_free(struct sctp_stream *stream)
 {
 	sctp_sched_rr_unsched_all(stream);
@@ -177,6 +181,7 @@ static struct sctp_sched_ops sctp_sched_rr = {
 	.get = sctp_sched_rr_get,
 	.init = sctp_sched_rr_init,
 	.init_sid = sctp_sched_rr_init_sid,
+	.free_sid = sctp_sched_rr_free_sid,
 	.free = sctp_sched_rr_free,
 	.enqueue = sctp_sched_rr_enqueue,
 	.dequeue = sctp_sched_rr_dequeue,
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index b5074957e881..4243d2ab8adf 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1982,6 +1982,9 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Ok, everything's fine, try to synch own keys according to peers' */
 	tipc_crypto_key_synch(rx, *skb);
 
+	/* Re-fetch skb cb as skb might be changed in tipc_msg_validate */
+	skb_cb = TIPC_SKB_CB(*skb);
+
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2477d28c2dab..ef31e401d791 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -330,7 +330,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
-				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+				if (tmp_old[1] >= 5 && tmp[1] >= 5 &&
+				    !memcmp(tmp_old + 2, tmp + 2, 5)) {
 					/* same vendor ie, copy from
 					 * subelement
 					 */
@@ -2476,10 +2477,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	struct cfg80211_non_tx_bss non_tx_data;
+	struct cfg80211_non_tx_bss non_tx_data = {};
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, gfp);
+
+	/* don't do any further MBSSID handling for S1G */
+	if (ieee80211_is_s1g_beacon(mgmt->frame_control))
+		return res;
+
 	if (!res || !wiphy->support_mbssid ||
 	    !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
diff --git a/scripts/faddr2line b/scripts/faddr2line
index 57099687e5e1..9e730b805e87 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -73,7 +73,8 @@ command -v ${ADDR2LINE} >/dev/null 2>&1 || die "${ADDR2LINE} isn't installed"
 find_dir_prefix() {
 	local objfile=$1
 
-	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | ${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
+	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' |
+		${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
 	[[ -z $start_kernel_addr ]] && return
 
 	local file_line=$(${ADDR2LINE} -e $objfile $start_kernel_addr)
@@ -177,7 +178,7 @@ __faddr2line() {
 				found=2
 				break
 			fi
-		done < <(${READELF} --symbols --wide $objfile | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
+		done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
 
 		if [[ $found = 0 ]]; then
 			warn "can't find symbol: sym_name: $sym_name sym_sec: $sym_sec sym_addr: $sym_addr sym_elf_size: $sym_elf_size"
@@ -258,7 +259,7 @@ __faddr2line() {
 
 		DONE=1
 
-	done < <(${READELF} --symbols --wide $objfile | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
+	done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
 }
 
 [[ $# -lt 2 ]] && usage
diff --git a/sound/firewire/dice/dice-stream.c b/sound/firewire/dice/dice-stream.c
index f99e00083141..4c677c8546c7 100644
--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -59,7 +59,7 @@ int snd_dice_stream_get_rate_mode(struct snd_dice *dice, unsigned int rate,
 
 static int select_clock(struct snd_dice *dice, unsigned int rate)
 {
-	__be32 reg;
+	__be32 reg, new;
 	u32 data;
 	int i;
 	int err;
@@ -83,15 +83,17 @@ static int select_clock(struct snd_dice *dice, unsigned int rate)
 	if (completion_done(&dice->clock_accepted))
 		reinit_completion(&dice->clock_accepted);
 
-	reg = cpu_to_be32(data);
+	new = cpu_to_be32(data);
 	err = snd_dice_transaction_write_global(dice, GLOBAL_CLOCK_SELECT,
-						&reg, sizeof(reg));
+						&new, sizeof(new));
 	if (err < 0)
 		return err;
 
 	if (wait_for_completion_timeout(&dice->clock_accepted,
-			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0)
-		return -ETIMEDOUT;
+			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0) {
+		if (reg != new)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index e73360e9de8f..b8a169d3b830 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -433,7 +433,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	if (mc->platform_max && val > mc->platform_max)
 		return -EINVAL;
-	if (val > max - min)
+	if (val > max)
 		return -EINVAL;
 	if (val < 0)
 		return -EINVAL;
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 8bc117bcc7bc..c42ba9358d8c 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -59,6 +59,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	__u32 len = sizeof(info);
 	struct epoll_event *e;
 	struct ring *r;
+	__u64 mmap_sz;
 	void *tmp;
 	int err;
 
@@ -97,8 +98,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	r->mask = info.max_entries - 1;
 
 	/* Map writable consumer page */
-	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
-		   map_fd, 0);
+	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED, map_fd, 0);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		pr_warn("ringbuf: failed to mmap consumer page for map fd=%d: %d\n",
@@ -111,8 +111,12 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	 * data size to allow simple reading of samples that wrap around the
 	 * end of a ring buffer. See kernel implementation for details.
 	 * */
-	tmp = mmap(NULL, rb->page_size + 2 * info.max_entries, PROT_READ,
-		   MAP_SHARED, map_fd, rb->page_size);
+	mmap_sz = rb->page_size + 2 * (__u64)info.max_entries;
+	if (mmap_sz != (__u64)(size_t)mmap_sz) {
+		pr_warn("ringbuf: ring buffer size (%u) is too big\n", info.max_entries);
+		return libbpf_err(-E2BIG);
+	}
+	tmp = mmap(NULL, (size_t)mmap_sz, PROT_READ, MAP_SHARED, map_fd, rb->page_size);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		ringbuf_unmap_ring(rb, r);
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b5a69ad191b0..0c066ba579d4 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1145,6 +1145,36 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning: route add with nhid and delete
+	# using device
+	run_cmd "$IP li set dev veth1 up"
+	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
+	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
+	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
+	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	[ $out1 -eq $out2 ]
+	rc=$?
+	log_test $rc 0 "Delete nexthop route warning"
+	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 2 "Delete multipath route with only nh id based entry"
+
+	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
+	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
+	log_test $? 2 "Delete route when specifying only nexthop device"
+
+	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
+	log_test $? 2 "Delete route when specifying only gateway"
+
+	run_cmd "$IP ro del 172.16.102.0/24"
+	log_test $? 0 "Delete route when not specifying nexthop attributes"
 }
 
 ipv4_grp_fcnal()
diff --git a/tools/vm/slabinfo-gnuplot.sh b/tools/vm/slabinfo-gnuplot.sh
index 26e193ffd2a2..873a892147e5 100644
--- a/tools/vm/slabinfo-gnuplot.sh
+++ b/tools/vm/slabinfo-gnuplot.sh
@@ -150,7 +150,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-loss"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by loss' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4+$2*$3" "$4}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
@@ -159,7 +159,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-size"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by size' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4" "$4-$2*$3}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
