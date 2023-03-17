Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB686BE29D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjCQIGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjCQIF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4963B5A89;
        Fri, 17 Mar 2023 01:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFE646220C;
        Fri, 17 Mar 2023 08:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5BEC4339B;
        Fri, 17 Mar 2023 08:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040291;
        bh=uu2HVsZkSChTete/KlXLDk0fvNGuU/XVIlXTUlrHbao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xjLKa1w0vNnF/fV0oYion/fRT00T0JV/x72x9G2UQ56FHxGNQdunh5ywfaFzo4eh
         DAAUq2oF3P+i6SIzVVkl0GerNoIQdkFfiuS5MO7w5UXm1bKt4AnQqGe7SZVzZR3pzK
         An1bVq5b1Qhs9ppS9LE5HkO0dStnH/lNn21D4Zks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.2.7
Date:   Fri, 17 Mar 2023 09:04:39 +0100
Message-Id: <1679040279121114@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679040279113160@kroah.com>
References: <1679040279113160@kroah.com>
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
index 70e66e771608..43cf2c785cb1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 2
-SUBLEVEL = 6
+SUBLEVEL = 7
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
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
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 3a2bb2e8fdad..fbff1cea62ca 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -326,16 +326,16 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (m68k_ramdisk.size) {
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size)
 		memblock_reserve(m68k_ramdisk.addr, m68k_ramdisk.size);
+
+	paging_init();
+
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size) {
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
 		pr_info("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
 	}
-#endif
-
-	paging_init();
 
 #ifdef CONFIG_NATFEAT
 	nf_init();
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
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index eb6d094083fd..317659fdeacf 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -36,15 +36,17 @@
 #define PACA_IRQ_DEC		0x08 /* Or FIT */
 #define PACA_IRQ_HMI		0x10
 #define PACA_IRQ_PMI		0x20
+#define PACA_IRQ_REPLAYING	0x40
 
 /*
  * Some soft-masked interrupts must be hard masked until they are replayed
  * (e.g., because the soft-masked handler does not clear the exception).
+ * Interrupt replay itself must remain hard masked too.
  */
 #ifdef CONFIG_PPC_BOOK3S
-#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_PMI)
+#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_PMI|PACA_IRQ_REPLAYING)
 #else
-#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE)
+#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_REPLAYING)
 #endif
 
 #endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 09f1790d0ae1..0ab3511a47d7 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -295,7 +295,6 @@ extern void free_unused_pacas(void);
 
 #else /* CONFIG_PPC64 */
 
-static inline void allocate_paca_ptrs(void) { }
 static inline void allocate_paca(int cpu) { }
 static inline void free_unused_pacas(void) { }
 
diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index f63505d74932..6c6cb53d7045 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -26,6 +26,7 @@
 #include <asm/percpu.h>
 
 extern int boot_cpuid;
+extern int boot_cpu_hwid; /* PPC64 only */
 extern int spinning_secondaries;
 extern u32 *cpu_to_phys_id;
 extern bool coregroup_enabled;
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index caebe1431596..ee95937bdaf1 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -67,11 +67,9 @@ static void iommu_debugfs_add(struct iommu_table *tbl)
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
diff --git a/arch/powerpc/kernel/irq_64.c b/arch/powerpc/kernel/irq_64.c
index eb2b380e52a0..9dc0ad3c533a 100644
--- a/arch/powerpc/kernel/irq_64.c
+++ b/arch/powerpc/kernel/irq_64.c
@@ -70,22 +70,19 @@ int distribute_irqs = 1;
 
 static inline void next_interrupt(struct pt_regs *regs)
 {
-	/*
-	 * Softirq processing can enable/disable irqs, which will leave
-	 * MSR[EE] enabled and the soft mask set to IRQS_DISABLED. Fix
-	 * this up.
-	 */
-	if (!(local_paca->irq_happened & PACA_IRQ_HARD_DIS))
-		hard_irq_disable();
-	else
-		irq_soft_mask_set(IRQS_ALL_DISABLED);
+	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
+		WARN_ON(!(local_paca->irq_happened & PACA_IRQ_HARD_DIS));
+		WARN_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED);
+	}
 
 	/*
 	 * We are responding to the next interrupt, so interrupt-off
 	 * latencies should be reset here.
 	 */
+	lockdep_hardirq_exit();
 	trace_hardirqs_on();
 	trace_hardirqs_off();
+	lockdep_hardirq_enter();
 }
 
 static inline bool irq_happened_test_and_clear(u8 irq)
@@ -97,22 +94,11 @@ static inline bool irq_happened_test_and_clear(u8 irq)
 	return false;
 }
 
-void replay_soft_interrupts(void)
+static void __replay_soft_interrupts(void)
 {
 	struct pt_regs regs;
 
 	/*
-	 * Be careful here, calling these interrupt handlers can cause
-	 * softirqs to be raised, which they may run when calling irq_exit,
-	 * which will cause local_irq_enable() to be run, which can then
-	 * recurse into this function. Don't keep any state across
-	 * interrupt handler calls which may change underneath us.
-	 *
-	 * Softirqs can not be disabled over replay to stop this recursion
-	 * because interrupts taken in idle code may require RCU softirq
-	 * to run in the irq RCU tracking context. This is a hard problem
-	 * to fix without changes to the softirq or idle layer.
-	 *
 	 * We use local_paca rather than get_paca() to avoid all the
 	 * debug_smp_processor_id() business in this low level function.
 	 */
@@ -120,13 +106,20 @@ void replay_soft_interrupts(void)
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
 		WARN_ON_ONCE(mfmsr() & MSR_EE);
 		WARN_ON(!(local_paca->irq_happened & PACA_IRQ_HARD_DIS));
+		WARN_ON(local_paca->irq_happened & PACA_IRQ_REPLAYING);
 	}
 
+	/*
+	 * PACA_IRQ_REPLAYING prevents interrupt handlers from enabling
+	 * MSR[EE] to get PMIs, which can result in more IRQs becoming
+	 * pending.
+	 */
+	local_paca->irq_happened |= PACA_IRQ_REPLAYING;
+
 	ppc_save_regs(&regs);
 	regs.softe = IRQS_ENABLED;
 	regs.msr |= MSR_EE;
 
-again:
 	/*
 	 * Force the delivery of pending soft-disabled interrupts on PS3.
 	 * Any HV call will have this side effect.
@@ -175,13 +168,14 @@ void replay_soft_interrupts(void)
 		next_interrupt(&regs);
 	}
 
-	/*
-	 * Softirq processing can enable and disable interrupts, which can
-	 * result in new irqs becoming pending. Must keep looping until we
-	 * have cleared out all pending interrupts.
-	 */
-	if (local_paca->irq_happened & ~PACA_IRQ_HARD_DIS)
-		goto again;
+	local_paca->irq_happened &= ~PACA_IRQ_REPLAYING;
+}
+
+void replay_soft_interrupts(void)
+{
+	irq_enter(); /* See comment in arch_local_irq_restore */
+	__replay_soft_interrupts();
+	irq_exit();
 }
 
 #if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_PPC_KUAP)
@@ -200,13 +194,13 @@ static inline void replay_soft_interrupts_irqrestore(void)
 	if (kuap_state != AMR_KUAP_BLOCKED)
 		set_kuap(AMR_KUAP_BLOCKED);
 
-	replay_soft_interrupts();
+	__replay_soft_interrupts();
 
 	if (kuap_state != AMR_KUAP_BLOCKED)
 		set_kuap(kuap_state);
 }
 #else
-#define replay_soft_interrupts_irqrestore() replay_soft_interrupts()
+#define replay_soft_interrupts_irqrestore() __replay_soft_interrupts()
 #endif
 
 notrace void arch_local_irq_restore(unsigned long mask)
@@ -219,9 +213,13 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		return;
 	}
 
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
-		WARN_ON_ONCE(in_nmi() || in_hardirq());
+	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
+		WARN_ON_ONCE(in_nmi());
+		WARN_ON_ONCE(in_hardirq());
+		WARN_ON_ONCE(local_paca->irq_happened & PACA_IRQ_REPLAYING);
+	}
 
+again:
 	/*
 	 * After the stb, interrupts are unmasked and there are no interrupts
 	 * pending replay. The restart sequence makes this atomic with
@@ -248,6 +246,12 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
 		WARN_ON_ONCE(!(mfmsr() & MSR_EE));
 
+	/*
+	 * If we came here from the replay below, we might have a preempt
+	 * pending (due to preempt_enable_no_resched()). Have to check now.
+	 */
+	preempt_check_resched();
+
 	return;
 
 happened:
@@ -261,6 +265,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		irq_soft_mask_set(IRQS_ENABLED);
 		local_paca->irq_happened = 0;
 		__hard_irq_enable();
+		preempt_check_resched();
 		return;
 	}
 
@@ -296,12 +301,38 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	irq_soft_mask_set(IRQS_ALL_DISABLED);
 	trace_hardirqs_off();
 
+	/*
+	 * Now enter interrupt context. The interrupt handlers themselves
+	 * also call irq_enter/exit (which is okay, they can nest). But call
+	 * it here now to hold off softirqs until the below irq_exit(). If
+	 * we allowed replayed handlers to run softirqs, that enables irqs,
+	 * which must replay interrupts, which recurses in here and makes
+	 * things more complicated. The recursion is limited to 2, and it can
+	 * be made to work, but it's complicated.
+	 *
+	 * local_bh_disable can not be used here because interrupts taken in
+	 * idle are not in the right context (RCU, tick, etc) to run softirqs
+	 * so irq_enter must be called.
+	 */
+	irq_enter();
+
 	replay_soft_interrupts_irqrestore();
 
+	irq_exit();
+
+	if (unlikely(local_paca->irq_happened != PACA_IRQ_HARD_DIS)) {
+		/*
+		 * The softirq processing in irq_exit() may enable interrupts
+		 * temporarily, which can result in MSR[EE] being enabled and
+		 * more irqs becoming pending. Go around again if that happens.
+		 */
+		trace_hardirqs_on();
+		preempt_enable_no_resched();
+		goto again;
+	}
+
 	trace_hardirqs_on();
 	irq_soft_mask_set(IRQS_ENABLED);
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
-		WARN_ON(local_paca->irq_happened != PACA_IRQ_HARD_DIS);
 	local_paca->irq_happened = 0;
 	__hard_irq_enable();
 	preempt_enable();
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index c22cc234672f..effe9697905d 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1405,8 +1405,7 @@ static void show_instructions(struct pt_regs *regs)
 	for (i = 0; i < NR_INSN_TO_PRINT; i++) {
 		int instr;
 
-		if (!__kernel_text_address(pc) ||
-		    get_kernel_nofault(instr, (const void *)pc)) {
+		if (get_kernel_nofault(instr, (const void *)pc)) {
 			pr_cont("XXXXXXXX ");
 		} else {
 			if (nip == pc)
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4f1c920aa13e..f318e8e1f3fe 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -370,8 +370,8 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 	    be32_to_cpu(intserv[found_thread]));
 	boot_cpuid = found;
 
-	// Pass the boot CPU's hard CPU id back to our caller
-	*((u32 *)data) = be32_to_cpu(intserv[found_thread]);
+	if (IS_ENABLED(CONFIG_PPC64))
+		boot_cpu_hwid = be32_to_cpu(intserv[found_thread]);
 
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
@@ -755,7 +755,6 @@ static inline void save_fscr_to_task(void) {}
 
 void __init early_init_devtree(void *params)
 {
-	u32 boot_cpu_hwid;
 	phys_addr_t limit;
 
 	DBG(" -> early_init_devtree(%px)\n", params);
@@ -851,7 +850,7 @@ void __init early_init_devtree(void *params)
 	/* Retrieve CPU related informations from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
-	of_scan_flat_dt(early_init_dt_scan_cpus, &boot_cpu_hwid);
+	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
 	if (boot_cpuid < 0) {
 		printk("Failed to identify boot CPU !\n");
 		BUG();
@@ -868,11 +867,6 @@ void __init early_init_devtree(void *params)
 
 	mmu_early_init_devtree();
 
-	// NB. paca is not installed until later in early_setup()
-	allocate_paca_ptrs();
-	allocate_paca(boot_cpuid);
-	set_hard_smp_processor_id(boot_cpuid, boot_cpu_hwid);
-
 #ifdef CONFIG_PPC_POWERNV
 	/* Scan and build the list of machine check recoverable ranges */
 	of_scan_flat_dt(early_init_dt_scan_recoverable_ranges, NULL);
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 9b10e57040c6..e77734e5a127 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -87,6 +87,10 @@ EXPORT_SYMBOL(machine_id);
 int boot_cpuid = -1;
 EXPORT_SYMBOL_GPL(boot_cpuid);
 
+#ifdef CONFIG_PPC64
+int boot_cpu_hwid = -1;
+#endif
+
 /*
  * These are used in binfmt_elf.c to put aux entries on the stack
  * for each elf executable being started.
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index a0dee7354fe6..b2e0d3ce4261 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -385,17 +385,21 @@ void __init early_setup(unsigned long dt_ptr)
 	/*
 	 * Do early initialization using the flattened device
 	 * tree, such as retrieving the physical memory map or
-	 * calculating/retrieving the hash table size.
+	 * calculating/retrieving the hash table size, discover
+	 * boot_cpuid and boot_cpu_hwid.
 	 */
 	early_init_devtree(__va(dt_ptr));
 
-	/* Now we know the logical id of our boot cpu, setup the paca. */
-	if (boot_cpuid != 0) {
-		/* Poison paca_ptrs[0] again if it's not the boot cpu */
-		memset(&paca_ptrs[0], 0x88, sizeof(paca_ptrs[0]));
-	}
+	allocate_paca_ptrs();
+	allocate_paca(boot_cpuid);
+	set_hard_smp_processor_id(boot_cpuid, boot_cpu_hwid);
 	fixup_boot_paca(paca_ptrs[boot_cpuid]);
 	setup_paca(paca_ptrs[boot_cpuid]); /* install the paca into registers */
+	// smp_processor_id() now reports boot_cpuid
+
+#ifdef CONFIG_SMP
+	task_thread_info(current)->cpu = boot_cpuid; // fix task_cpu(current)
+#endif
 
 	/*
 	 * Configure exception handlers. This include setting up trampolines
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e26eb6618ae5..9d8665910350 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -356,7 +356,7 @@ void vtime_flush(struct task_struct *tsk)
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
-void __delay(unsigned long loops)
+void __no_kcsan __delay(unsigned long loops)
 {
 	unsigned long start;
 
@@ -377,7 +377,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-void udelay(unsigned long usecs)
+void __no_kcsan udelay(unsigned long usecs)
 {
 	__delay(tb_ticks_per_usec * usecs);
 }
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index a379b0ce19ff..8643b2c8b76e 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -79,6 +79,20 @@ static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
 #define SEEN_NVREG_FULL_MASK	0x0003ffff /* Non volatile registers r14-r31 */
 #define SEEN_NVREG_TEMP_MASK	0x00001e01 /* BPF_REG_5, BPF_REG_AX, TMP_REG */
 
+static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
+{
+	/*
+	 * We only need a stack frame if:
+	 * - we call other functions (kernel helpers), or
+	 * - we use non volatile registers, or
+	 * - we use tail call counter
+	 * - the bpf program uses its stack area
+	 * The latter condition is deduced from the usage of BPF_REG_FP
+	 */
+	return ctx->seen & (SEEN_FUNC | SEEN_TAILCALL | SEEN_NVREG_FULL_MASK) ||
+	       bpf_is_seen_register(ctx, bpf_to_ppc(BPF_REG_FP));
+}
+
 void bpf_jit_realloc_regs(struct codegen_context *ctx)
 {
 	unsigned int nvreg_mask;
@@ -118,7 +132,8 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 
 #define BPF_TAILCALL_PROLOGUE_SIZE	4
 
-	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
+	if (bpf_has_stack_frame(ctx))
+		EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_TAILCALL)
 		EMIT(PPC_RAW_STW(_R4, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
@@ -171,7 +186,8 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
 
 	/* Tear down our stack frame */
-	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
+	if (bpf_has_stack_frame(ctx))
+		EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_MTLR(_R0));
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 56b921998166..5931a0ff3c81 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -87,6 +87,13 @@ endif
 # Avoid generating .eh_frame sections.
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
 
+# The RISC-V attributes frequently cause compatibility issues and provide no
+# information, so just turn them off.
+KBUILD_CFLAGS += $(call cc-option,-mno-riscv-attribute)
+KBUILD_AFLAGS += $(call cc-option,-mno-riscv-attribute)
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+KBUILD_AFLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
 KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 
diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 1031038423e7..c24a349dd026 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bug.h>
@@ -107,7 +108,9 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
+			mutex_lock(&text_mutex);
 			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			mutex_unlock(&text_mutex);
 			cpu_apply_errata |= tmp;
 		}
 	}
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index fac5742d1c1e..9d71fe3d35c7 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -5,6 +5,7 @@
 
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -97,11 +98,14 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
 			/* On vm-alternatives, the mmu isn't running yet */
-			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
+			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT) {
 				memcpy((void *)__pa_symbol(alt->old_ptr),
 				       (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
-			else
+			} else {
+				mutex_lock(&text_mutex);
 				patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+				mutex_unlock(&text_mutex);
+			}
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
diff --git a/arch/riscv/kernel/compat_vdso/Makefile b/arch/riscv/kernel/compat_vdso/Makefile
index 260daf3236d3..7f34f3c7c882 100644
--- a/arch/riscv/kernel/compat_vdso/Makefile
+++ b/arch/riscv/kernel/compat_vdso/Makefile
@@ -14,6 +14,10 @@ COMPAT_LD := $(LD)
 COMPAT_CC_FLAGS := -march=rv32g -mabi=ilp32
 COMPAT_LD_FLAGS := -melf32lriscv
 
+# Disable attributes, as they're useless and break the build.
+COMPAT_CC_FLAGS += $(call cc-option,-mno-riscv-attribute)
+COMPAT_CC_FLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+
 # Files to link into the compat_vdso
 obj-compat_vdso = $(patsubst %, %.o, $(compat_vdso-syms)) note.o
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 93e45560af30..5a82d5520a1f 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -10,6 +10,7 @@
 #include <linux/ctype.h>
 #include <linux/libfdt.h>
 #include <linux/log2.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <asm/alternative.h>
@@ -339,8 +340,11 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 		}
 
 		tmp = (1U << alt->errata_id);
-		if (cpu_req_feature & tmp)
+		if (cpu_req_feature & tmp) {
+			mutex_lock(&text_mutex);
 			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			mutex_unlock(&text_mutex);
+		}
 	}
 }
 #endif
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 5bff37af4770..03a6434a8cdd 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -15,10 +15,19 @@
 void ftrace_arch_code_modify_prepare(void) __acquires(&text_mutex)
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
 }
 
 void ftrace_arch_code_modify_post_process(void) __releases(&text_mutex)
 {
+	riscv_patch_in_stop_machine = false;
 	mutex_unlock(&text_mutex);
 }
 
@@ -107,9 +116,9 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
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
index f9a5a7c90ff0..64a9c093aef9 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -101,7 +101,7 @@ void notrace walk_stackframe(struct task_struct *task,
 	while (!kstack_end(ksp)) {
 		if (__kernel_text_address(pc) && unlikely(!fn(arg, pc)))
 			break;
-		pc = (*ksp++) - 0x4;
+		pc = READ_ONCE_NOCHECK(*ksp++) - 0x4;
 	}
 }
 
diff --git a/arch/um/kernel/vmlinux.lds.S b/arch/um/kernel/vmlinux.lds.S
index 16e49bfa2b42..53d719c04ba9 100644
--- a/arch/um/kernel/vmlinux.lds.S
+++ b/arch/um/kernel/vmlinux.lds.S
@@ -1,4 +1,4 @@
-
+#define RUNTIME_DISCARD_EXIT
 KERNEL_STACK_SIZE = 4096 * (1 << CONFIG_KERNEL_STACK_ORDER);
 
 #ifdef CONFIG_LD_SCRIPT_STATIC
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..24480b4f1c57 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1760,6 +1760,9 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops);
+void kvm_x86_vendor_exit(void);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f769d6d08b43..06f2ede1544f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -880,6 +880,15 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 22d054ba5939..f03bdaf79c88 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5097,15 +5097,34 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 
 static int __init svm_init(void)
 {
+	int r;
+
 	__unused_size_checks();
 
-	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
-			__alignof__(struct vcpu_svm), THIS_MODULE);
+	r = kvm_x86_vendor_init(&svm_init_ops);
+	if (r)
+		return r;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
+		     __alignof__(struct vcpu_svm), THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	kvm_x86_vendor_exit();
+	return r;
 }
 
 static void __exit svm_exit(void)
 {
 	kvm_exit();
+	kvm_x86_vendor_exit();
 }
 
 module_init(svm_init)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 939e395cda3f..cb547a083381 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -551,6 +551,33 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void hv_reset_evmcs(void)
+{
+	struct hv_vp_assist_page *vp_ap;
+
+	if (!static_branch_unlikely(&enable_evmcs))
+		return;
+
+	/*
+	 * KVM should enable eVMCS if and only if all CPUs have a VP assist
+	 * page, and should reject CPU onlining if eVMCS is enabled the CPU
+	 * doesn't have a VP assist page allocated.
+	 */
+	vp_ap = hv_get_vp_assist_page(smp_processor_id());
+	if (WARN_ON_ONCE(!vp_ap))
+		return;
+
+	/*
+	 * Reset everything to support using non-enlightened VMCS access later
+	 * (e.g. when we reload the module with enlightened_vmcs=0)
+	 */
+	vp_ap->nested_control.features.directhypercall = 0;
+	vp_ap->current_nested_vmcs = 0;
+	vp_ap->enlighten_vmentry = 0;
+}
+
+#else /* IS_ENABLED(CONFIG_HYPERV) */
+static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2527,6 +2554,8 @@ static void vmx_hardware_disable(void)
 	if (cpu_vmxoff())
 		kvm_spurious_fault();
 
+	hv_reset_evmcs();
+
 	intel_pt_handle_vmx(0);
 }
 
@@ -8492,41 +8521,23 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+static void __vmx_exit(void)
 {
+	allow_smaller_maxphyaddr = false;
+
 #ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
 #endif
+	vmx_cleanup_l1d_flush();
+}
 
+static void vmx_exit(void)
+{
 	kvm_exit();
+	kvm_x86_vendor_exit();
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs)) {
-		int cpu;
-		struct hv_vp_assist_page *vp_ap;
-		/*
-		 * Reset everything to support using non-enlightened VMCS
-		 * access later (e.g. when we reload the module with
-		 * enlightened_vmcs=0)
-		 */
-		for_each_online_cpu(cpu) {
-			vp_ap =	hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 0;
-			vp_ap->current_nested_vmcs = 0;
-			vp_ap->enlighten_vmentry = 0;
-		}
-
-		static_branch_disable(&enable_evmcs);
-	}
-#endif
-	vmx_cleanup_l1d_flush();
-
-	allow_smaller_maxphyaddr = false;
+	__vmx_exit();
 }
 module_exit(vmx_exit);
 
@@ -8567,23 +8578,20 @@ static int __init vmx_init(void)
 	}
 #endif
 
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
-		     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	r = kvm_x86_vendor_init(&vmx_init_ops);
 	if (r)
 		return r;
 
 	/*
-	 * Must be called after kvm_init() so enable_ept is properly set
+	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
 	 * the pre module init parser. If no parameter was given, it will
 	 * contain 'auto' which will be turned into the default 'cond'
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
-		return r;
-	}
+	if (r)
+		goto err_l1d_flush;
 
 	vmx_setup_fb_clear_ctrl();
 
@@ -8607,6 +8615,21 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
+		     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
 	return 0;
+
+err_kvm_init:
+	__vmx_exit();
+err_l1d_flush:
+	kvm_x86_vendor_exit();
+	return r;
 }
 module_init(vmx_init);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c299d47e69..0ec7a0cb5da8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9292,7 +9292,16 @@ static struct notifier_block pvclock_gtod_notifier = {
 
 int kvm_arch_init(void *opaque)
 {
-	struct kvm_x86_init_ops *ops = opaque;
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+
+}
+
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
+{
 	u64 host_pat;
 	int r;
 
@@ -9382,8 +9391,9 @@ int kvm_arch_init(void *opaque)
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
 
-void kvm_arch_exit(void)
+void kvm_x86_vendor_exit(void)
 {
 #ifdef CONFIG_X86_64
 	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
@@ -9410,6 +9420,7 @@ void kvm_arch_exit(void)
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
 }
+EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
 static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
diff --git a/block/blk.h b/block/blk.h
index 4c3b3325219a..e835f21d48af 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -427,7 +427,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 
 struct request_queue *blk_alloc_queue(int node_id);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
diff --git a/block/genhd.c b/block/genhd.c
index 23cf83b3331c..9c4c9aa559ab 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -356,9 +356,10 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
+	int ret = 0;
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
@@ -366,16 +367,29 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
-	/* Someone else has bdev exclusively open? */
-	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
-		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
+	/*
+	 * If the device is opened exclusively by current thread already, it's
+	 * safe to scan partitons, otherwise, use bd_prepare_to_claim() to
+	 * synchronize with other exclusive openers and other partition
+	 * scanners.
+	 */
+	if (!(mode & FMODE_EXCL)) {
+		ret = bd_prepare_to_claim(disk->part0, disk_scan_partitions);
+		if (ret)
+			return ret;
+	}
+
+	bdev = blkdev_get_by_dev(disk_devt(disk), mode & ~FMODE_EXCL, NULL);
 	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-	blkdev_put(bdev, mode);
-	return 0;
+		ret =  PTR_ERR(bdev);
+	else
+		blkdev_put(bdev, mode & ~FMODE_EXCL);
+
+	if (!(mode & FMODE_EXCL))
+		bd_abort_claiming(disk->part0, disk_scan_partitions);
+	return ret;
 }
 
 /**
@@ -497,9 +511,14 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		if (ret)
 			goto out_unregister_bdi;
 
+		/* Make sure the first partition scan will be proceed */
+		if (get_capacity(disk) && !(disk->flags & GENHD_FL_NO_PART) &&
+		    !test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+			set_bit(GD_NEED_PART_SCAN, &disk->state);
+
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
-			disk_scan_partitions(disk, FMODE_READ, NULL);
+			disk_scan_partitions(disk, FMODE_READ);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
diff --git a/block/ioctl.c b/block/ioctl.c
index 96617512982e..9c5f637ff153 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -467,10 +467,10 @@ static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
  * user space. Note the separate arg/argp parameters that are needed
  * to deal with the compat_ptr() conversion.
  */
-static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
-			       unsigned long arg, void __user *argp)
+static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
+			       unsigned int cmd, unsigned long arg,
+			       void __user *argp)
 {
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	unsigned int max_sectors;
 
 	switch (cmd) {
@@ -528,8 +528,7 @@ static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL,
-					    file);
+		return disk_scan_partitions(bdev->bd_disk, mode);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
@@ -607,7 +606,7 @@ long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -676,7 +675,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
 
diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 357c61c12ce5..edd153dda40c 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -990,44 +990,25 @@ static void mhi_ep_abort_transfer(struct mhi_ep_cntrl *mhi_cntrl)
 static void mhi_ep_reset_worker(struct work_struct *work)
 {
 	struct mhi_ep_cntrl *mhi_cntrl = container_of(work, struct mhi_ep_cntrl, reset_work);
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	enum mhi_state cur_state;
-	int ret;
 
-	mhi_ep_abort_transfer(mhi_cntrl);
+	mhi_ep_power_down(mhi_cntrl);
+
+	mutex_lock(&mhi_cntrl->state_lock);
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
 	/* Reset MMIO to signal host that the MHI_RESET is completed in endpoint */
 	mhi_ep_mmio_reset(mhi_cntrl);
 	cur_state = mhi_cntrl->mhi_state;
-	spin_unlock_bh(&mhi_cntrl->state_lock);
 
 	/*
 	 * Only proceed further if the reset is due to SYS_ERR. The host will
 	 * issue reset during shutdown also and we don't need to do re-init in
 	 * that case.
 	 */
-	if (cur_state == MHI_STATE_SYS_ERR) {
-		mhi_ep_mmio_init(mhi_cntrl);
-
-		/* Set AMSS EE before signaling ready state */
-		mhi_ep_mmio_set_env(mhi_cntrl, MHI_EE_AMSS);
-
-		/* All set, notify the host that we are ready */
-		ret = mhi_ep_set_ready_state(mhi_cntrl);
-		if (ret)
-			return;
-
-		dev_dbg(dev, "READY state notification sent to the host\n");
+	if (cur_state == MHI_STATE_SYS_ERR)
+		mhi_ep_power_up(mhi_cntrl);
 
-		ret = mhi_ep_enable(mhi_cntrl);
-		if (ret) {
-			dev_err(dev, "Failed to enable MHI endpoint: %d\n", ret);
-			return;
-		}
-
-		enable_irq(mhi_cntrl->irq);
-	}
+	mutex_unlock(&mhi_cntrl->state_lock);
 }
 
 /*
@@ -1106,11 +1087,11 @@ EXPORT_SYMBOL_GPL(mhi_ep_power_up);
 
 void mhi_ep_power_down(struct mhi_ep_cntrl *mhi_cntrl)
 {
-	if (mhi_cntrl->enabled)
+	if (mhi_cntrl->enabled) {
 		mhi_ep_abort_transfer(mhi_cntrl);
-
-	kfree(mhi_cntrl->mhi_event);
-	disable_irq(mhi_cntrl->irq);
+		kfree(mhi_cntrl->mhi_event);
+		disable_irq(mhi_cntrl->irq);
+	}
 }
 EXPORT_SYMBOL_GPL(mhi_ep_power_down);
 
@@ -1400,8 +1381,8 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 
 	INIT_LIST_HEAD(&mhi_cntrl->st_transition_list);
 	INIT_LIST_HEAD(&mhi_cntrl->ch_db_list);
-	spin_lock_init(&mhi_cntrl->state_lock);
 	spin_lock_init(&mhi_cntrl->list_lock);
+	mutex_init(&mhi_cntrl->state_lock);
 	mutex_init(&mhi_cntrl->event_lock);
 
 	/* Set MHI version and AMSS EE before enumeration */
diff --git a/drivers/bus/mhi/ep/sm.c b/drivers/bus/mhi/ep/sm.c
index 3655c19e23c7..fd200b2ac0bb 100644
--- a/drivers/bus/mhi/ep/sm.c
+++ b/drivers/bus/mhi/ep/sm.c
@@ -63,24 +63,23 @@ int mhi_ep_set_m0_state(struct mhi_ep_cntrl *mhi_cntrl)
 	int ret;
 
 	/* If MHI is in M3, resume suspended channels */
-	spin_lock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
+
 	old_state = mhi_cntrl->mhi_state;
 	if (old_state == MHI_STATE_M3)
 		mhi_ep_resume_channels(mhi_cntrl);
 
 	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M0);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
-
 	if (ret) {
 		mhi_ep_handle_syserr(mhi_cntrl);
-		return ret;
+		goto err_unlock;
 	}
 
 	/* Signal host that the device moved to M0 */
 	ret = mhi_ep_send_state_change_event(mhi_cntrl, MHI_STATE_M0);
 	if (ret) {
 		dev_err(dev, "Failed sending M0 state change event\n");
-		return ret;
+		goto err_unlock;
 	}
 
 	if (old_state == MHI_STATE_READY) {
@@ -88,11 +87,14 @@ int mhi_ep_set_m0_state(struct mhi_ep_cntrl *mhi_cntrl)
 		ret = mhi_ep_send_ee_event(mhi_cntrl, MHI_EE_AMSS);
 		if (ret) {
 			dev_err(dev, "Failed sending AMSS EE event\n");
-			return ret;
+			goto err_unlock;
 		}
 	}
 
-	return 0;
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
+	return ret;
 }
 
 int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
@@ -100,13 +102,12 @@ int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	int ret;
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
-	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M3);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
 
+	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M3);
 	if (ret) {
 		mhi_ep_handle_syserr(mhi_cntrl);
-		return ret;
+		goto err_unlock;
 	}
 
 	mhi_ep_suspend_channels(mhi_cntrl);
@@ -115,10 +116,13 @@ int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
 	ret = mhi_ep_send_state_change_event(mhi_cntrl, MHI_STATE_M3);
 	if (ret) {
 		dev_err(dev, "Failed sending M3 state change event\n");
-		return ret;
+		goto err_unlock;
 	}
 
-	return 0;
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
+	return ret;
 }
 
 int mhi_ep_set_ready_state(struct mhi_ep_cntrl *mhi_cntrl)
@@ -127,22 +131,24 @@ int mhi_ep_set_ready_state(struct mhi_ep_cntrl *mhi_cntrl)
 	enum mhi_state mhi_state;
 	int ret, is_ready;
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
+
 	/* Ensure that the MHISTATUS is set to RESET by host */
 	mhi_state = mhi_ep_mmio_masked_read(mhi_cntrl, EP_MHISTATUS, MHISTATUS_MHISTATE_MASK);
 	is_ready = mhi_ep_mmio_masked_read(mhi_cntrl, EP_MHISTATUS, MHISTATUS_READY_MASK);
 
 	if (mhi_state != MHI_STATE_RESET || is_ready) {
 		dev_err(dev, "READY state transition failed. MHI host not in RESET state\n");
-		spin_unlock_bh(&mhi_cntrl->state_lock);
-		return -EIO;
+		ret = -EIO;
+		goto err_unlock;
 	}
 
 	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_READY);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
-
 	if (ret)
 		mhi_ep_handle_syserr(mhi_cntrl);
 
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
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
 
diff --git a/drivers/clk/renesas/Kconfig b/drivers/clk/renesas/Kconfig
index cacaf9b87d26..37632a0659d8 100644
--- a/drivers/clk/renesas/Kconfig
+++ b/drivers/clk/renesas/Kconfig
@@ -22,7 +22,7 @@ config CLK_RENESAS
 	select CLK_R8A7791 if ARCH_R8A7791 || ARCH_R8A7793
 	select CLK_R8A7792 if ARCH_R8A7792
 	select CLK_R8A7794 if ARCH_R8A7794
-	select CLK_R8A7795 if ARCH_R8A77950 || ARCH_R8A77951
+	select CLK_R8A7795 if ARCH_R8A77951
 	select CLK_R8A77960 if ARCH_R8A77960
 	select CLK_R8A77961 if ARCH_R8A77961
 	select CLK_R8A77965 if ARCH_R8A77965
diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
index 301475c74f50..7a585a777d38 100644
--- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
@@ -128,7 +128,6 @@ static struct cpg_core_clk r8a7795_core_clks[] __initdata = {
 };
 
 static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
-	DEF_MOD("fdp1-2",		 117,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fdp1-1",		 118,	R8A7795_CLK_S0D1),
 	DEF_MOD("fdp1-0",		 119,	R8A7795_CLK_S0D1),
 	DEF_MOD("tmu4",			 121,	R8A7795_CLK_S0D6),
@@ -162,7 +161,6 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("pcie1",		 318,	R8A7795_CLK_S3D1),
 	DEF_MOD("pcie0",		 319,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac30",		 326,	R8A7795_CLK_S3D1),
-	DEF_MOD("usb3-if1",		 327,	R8A7795_CLK_S3D1), /* ES1.x */
 	DEF_MOD("usb3-if0",		 328,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac31",		 329,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac0",		 330,	R8A7795_CLK_S3D1),
@@ -187,28 +185,21 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("hscif0",		 520,	R8A7795_CLK_S3D1),
 	DEF_MOD("thermal",		 522,	R8A7795_CLK_CP),
 	DEF_MOD("pwm",			 523,	R8A7795_CLK_S0D12),
-	DEF_MOD("fcpvd3",		 600,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpvd2",		 601,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvd1",		 602,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvd0",		 603,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvb1",		 606,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpvb0",		 607,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpvi2",		 609,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpvi1",		 610,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpvi0",		 611,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpf2",		 613,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpf1",		 614,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpf0",		 615,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpci1",		 616,	R8A7795_CLK_S2D1), /* ES1.x */
-	DEF_MOD("fcpci0",		 617,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpcs",		 619,	R8A7795_CLK_S0D1),
-	DEF_MOD("vspd3",		 620,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("vspd2",		 621,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspd1",		 622,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspd0",		 623,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspbc",		 624,	R8A7795_CLK_S0D1),
 	DEF_MOD("vspbd",		 626,	R8A7795_CLK_S0D1),
-	DEF_MOD("vspi2",		 629,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("vspi1",		 630,	R8A7795_CLK_S0D1),
 	DEF_MOD("vspi0",		 631,	R8A7795_CLK_S0D1),
 	DEF_MOD("ehci3",		 700,	R8A7795_CLK_S3D2),
@@ -221,7 +212,6 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("cmm2",			 709,	R8A7795_CLK_S2D1),
 	DEF_MOD("cmm1",			 710,	R8A7795_CLK_S2D1),
 	DEF_MOD("cmm0",			 711,	R8A7795_CLK_S2D1),
-	DEF_MOD("csi21",		 713,	R8A7795_CLK_CSI0), /* ES1.x */
 	DEF_MOD("csi20",		 714,	R8A7795_CLK_CSI0),
 	DEF_MOD("csi41",		 715,	R8A7795_CLK_CSI0),
 	DEF_MOD("csi40",		 716,	R8A7795_CLK_CSI0),
@@ -350,103 +340,26 @@ static const struct rcar_gen3_cpg_pll_config cpg_pll_configs[16] __initconst = {
 	{ 2,		192,	1,	192,	1,	32,	},
 };
 
-static const struct soc_device_attribute r8a7795es1[] __initconst = {
+static const struct soc_device_attribute r8a7795_denylist[] __initconst = {
 	{ .soc_id = "r8a7795", .revision = "ES1.*" },
 	{ /* sentinel */ }
 };
 
-
-	/*
-	 * Fixups for R-Car H3 ES1.x
-	 */
-
-static const unsigned int r8a7795es1_mod_nullify[] __initconst = {
-	MOD_CLK_ID(326),			/* USB-DMAC3-0 */
-	MOD_CLK_ID(329),			/* USB-DMAC3-1 */
-	MOD_CLK_ID(700),			/* EHCI/OHCI3 */
-	MOD_CLK_ID(705),			/* HS-USB-IF3 */
-
-};
-
-static const struct mssr_mod_reparent r8a7795es1_mod_reparent[] __initconst = {
-	{ MOD_CLK_ID(118), R8A7795_CLK_S2D1 },	/* FDP1-1 */
-	{ MOD_CLK_ID(119), R8A7795_CLK_S2D1 },	/* FDP1-0 */
-	{ MOD_CLK_ID(121), R8A7795_CLK_S3D2 },	/* TMU4 */
-	{ MOD_CLK_ID(217), R8A7795_CLK_S3D1 },	/* SYS-DMAC2 */
-	{ MOD_CLK_ID(218), R8A7795_CLK_S3D1 },	/* SYS-DMAC1 */
-	{ MOD_CLK_ID(219), R8A7795_CLK_S3D1 },	/* SYS-DMAC0 */
-	{ MOD_CLK_ID(408), R8A7795_CLK_S3D1 },	/* INTC-AP */
-	{ MOD_CLK_ID(501), R8A7795_CLK_S3D1 },	/* AUDMAC1 */
-	{ MOD_CLK_ID(502), R8A7795_CLK_S3D1 },	/* AUDMAC0 */
-	{ MOD_CLK_ID(523), R8A7795_CLK_S3D4 },	/* PWM */
-	{ MOD_CLK_ID(601), R8A7795_CLK_S2D1 },	/* FCPVD2 */
-	{ MOD_CLK_ID(602), R8A7795_CLK_S2D1 },	/* FCPVD1 */
-	{ MOD_CLK_ID(603), R8A7795_CLK_S2D1 },	/* FCPVD0 */
-	{ MOD_CLK_ID(606), R8A7795_CLK_S2D1 },	/* FCPVB1 */
-	{ MOD_CLK_ID(607), R8A7795_CLK_S2D1 },	/* FCPVB0 */
-	{ MOD_CLK_ID(610), R8A7795_CLK_S2D1 },	/* FCPVI1 */
-	{ MOD_CLK_ID(611), R8A7795_CLK_S2D1 },	/* FCPVI0 */
-	{ MOD_CLK_ID(614), R8A7795_CLK_S2D1 },	/* FCPF1 */
-	{ MOD_CLK_ID(615), R8A7795_CLK_S2D1 },	/* FCPF0 */
-	{ MOD_CLK_ID(619), R8A7795_CLK_S2D1 },	/* FCPCS */
-	{ MOD_CLK_ID(621), R8A7795_CLK_S2D1 },	/* VSPD2 */
-	{ MOD_CLK_ID(622), R8A7795_CLK_S2D1 },	/* VSPD1 */
-	{ MOD_CLK_ID(623), R8A7795_CLK_S2D1 },	/* VSPD0 */
-	{ MOD_CLK_ID(624), R8A7795_CLK_S2D1 },	/* VSPBC */
-	{ MOD_CLK_ID(626), R8A7795_CLK_S2D1 },	/* VSPBD */
-	{ MOD_CLK_ID(630), R8A7795_CLK_S2D1 },	/* VSPI1 */
-	{ MOD_CLK_ID(631), R8A7795_CLK_S2D1 },	/* VSPI0 */
-	{ MOD_CLK_ID(804), R8A7795_CLK_S2D1 },	/* VIN7 */
-	{ MOD_CLK_ID(805), R8A7795_CLK_S2D1 },	/* VIN6 */
-	{ MOD_CLK_ID(806), R8A7795_CLK_S2D1 },	/* VIN5 */
-	{ MOD_CLK_ID(807), R8A7795_CLK_S2D1 },	/* VIN4 */
-	{ MOD_CLK_ID(808), R8A7795_CLK_S2D1 },	/* VIN3 */
-	{ MOD_CLK_ID(809), R8A7795_CLK_S2D1 },	/* VIN2 */
-	{ MOD_CLK_ID(810), R8A7795_CLK_S2D1 },	/* VIN1 */
-	{ MOD_CLK_ID(811), R8A7795_CLK_S2D1 },	/* VIN0 */
-	{ MOD_CLK_ID(812), R8A7795_CLK_S3D2 },	/* EAVB-IF */
-	{ MOD_CLK_ID(820), R8A7795_CLK_S2D1 },	/* IMR3 */
-	{ MOD_CLK_ID(821), R8A7795_CLK_S2D1 },	/* IMR2 */
-	{ MOD_CLK_ID(822), R8A7795_CLK_S2D1 },	/* IMR1 */
-	{ MOD_CLK_ID(823), R8A7795_CLK_S2D1 },	/* IMR0 */
-	{ MOD_CLK_ID(905), R8A7795_CLK_CP },	/* GPIO7 */
-	{ MOD_CLK_ID(906), R8A7795_CLK_CP },	/* GPIO6 */
-	{ MOD_CLK_ID(907), R8A7795_CLK_CP },	/* GPIO5 */
-	{ MOD_CLK_ID(908), R8A7795_CLK_CP },	/* GPIO4 */
-	{ MOD_CLK_ID(909), R8A7795_CLK_CP },	/* GPIO3 */
-	{ MOD_CLK_ID(910), R8A7795_CLK_CP },	/* GPIO2 */
-	{ MOD_CLK_ID(911), R8A7795_CLK_CP },	/* GPIO1 */
-	{ MOD_CLK_ID(912), R8A7795_CLK_CP },	/* GPIO0 */
-	{ MOD_CLK_ID(918), R8A7795_CLK_S3D2 },	/* I2C6 */
-	{ MOD_CLK_ID(919), R8A7795_CLK_S3D2 },	/* I2C5 */
-	{ MOD_CLK_ID(927), R8A7795_CLK_S3D2 },	/* I2C4 */
-	{ MOD_CLK_ID(928), R8A7795_CLK_S3D2 },	/* I2C3 */
-};
-
-
-	/*
-	 * Fixups for R-Car H3 ES2.x
-	 */
-
-static const unsigned int r8a7795es2_mod_nullify[] __initconst = {
-	MOD_CLK_ID(117),			/* FDP1-2 */
-	MOD_CLK_ID(327),			/* USB3-IF1 */
-	MOD_CLK_ID(600),			/* FCPVD3 */
-	MOD_CLK_ID(609),			/* FCPVI2 */
-	MOD_CLK_ID(613),			/* FCPF2 */
-	MOD_CLK_ID(616),			/* FCPCI1 */
-	MOD_CLK_ID(617),			/* FCPCI0 */
-	MOD_CLK_ID(620),			/* VSPD3 */
-	MOD_CLK_ID(629),			/* VSPI2 */
-	MOD_CLK_ID(713),			/* CSI21 */
-};
-
 static int __init r8a7795_cpg_mssr_init(struct device *dev)
 {
 	const struct rcar_gen3_cpg_pll_config *cpg_pll_config;
 	u32 cpg_mode;
 	int error;
 
+	/*
+	 * We panic here to ensure removed SoCs and clk updates are always in
+	 * sync to avoid overclocking damages. The panic can only be seen with
+	 * commandline args 'earlycon keep_bootcon'. But these SoCs were for
+	 * developers only anyhow.
+	 */
+	if (soc_device_match(r8a7795_denylist))
+		panic("SoC not supported anymore!\n");
+
 	error = rcar_rst_read_mode_pins(&cpg_mode);
 	if (error)
 		return error;
@@ -457,25 +370,6 @@ static int __init r8a7795_cpg_mssr_init(struct device *dev)
 		return -EINVAL;
 	}
 
-	if (soc_device_match(r8a7795es1)) {
-		cpg_core_nullify_range(r8a7795_core_clks,
-				       ARRAY_SIZE(r8a7795_core_clks),
-				       R8A7795_CLK_S0D2, R8A7795_CLK_S0D12);
-		mssr_mod_nullify(r8a7795_mod_clks,
-				 ARRAY_SIZE(r8a7795_mod_clks),
-				 r8a7795es1_mod_nullify,
-				 ARRAY_SIZE(r8a7795es1_mod_nullify));
-		mssr_mod_reparent(r8a7795_mod_clks,
-				  ARRAY_SIZE(r8a7795_mod_clks),
-				  r8a7795es1_mod_reparent,
-				  ARRAY_SIZE(r8a7795es1_mod_reparent));
-	} else {
-		mssr_mod_nullify(r8a7795_mod_clks,
-				 ARRAY_SIZE(r8a7795_mod_clks),
-				 r8a7795es2_mod_nullify,
-				 ARRAY_SIZE(r8a7795es2_mod_nullify));
-	}
-
 	return rcar_gen3_cpg_init(cpg_pll_config, CLK_EXTALR, cpg_mode);
 }
 
diff --git a/drivers/clk/renesas/rcar-gen3-cpg.c b/drivers/clk/renesas/rcar-gen3-cpg.c
index e668f23c75e7..b3ef62fa612e 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -310,19 +310,10 @@ static unsigned int cpg_clk_extalr __initdata;
 static u32 cpg_mode __initdata;
 static u32 cpg_quirks __initdata;
 
-#define PLL_ERRATA	BIT(0)		/* Missing PLL0/2/4 post-divider */
 #define RCKCR_CKSEL	BIT(1)		/* Manual RCLK parent selection */
 
 
 static const struct soc_device_attribute cpg_quirks_match[] __initconst = {
-	{
-		.soc_id = "r8a7795", .revision = "ES1.0",
-		.data = (void *)(PLL_ERRATA | RCKCR_CKSEL),
-	},
-	{
-		.soc_id = "r8a7795", .revision = "ES1.*",
-		.data = (void *)(RCKCR_CKSEL),
-	},
 	{
 		.soc_id = "r8a7796", .revision = "ES1.0",
 		.data = (void *)(RCKCR_CKSEL),
@@ -355,9 +346,8 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 * multiplier when cpufreq changes between normal and boost
 		 * modes.
 		 */
-		mult = (cpg_quirks & PLL_ERRATA) ? 4 : 2;
 		return cpg_pll_clk_register(core->name, __clk_get_name(parent),
-					    base, mult, CPG_PLL0CR, 0);
+					    base, 2, CPG_PLL0CR, 0);
 
 	case CLK_TYPE_GEN3_PLL1:
 		mult = cpg_pll_config->pll1_mult;
@@ -370,9 +360,8 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 * multiplier when cpufreq changes between normal and boost
 		 * modes.
 		 */
-		mult = (cpg_quirks & PLL_ERRATA) ? 4 : 2;
 		return cpg_pll_clk_register(core->name, __clk_get_name(parent),
-					    base, mult, CPG_PLL2CR, 2);
+					    base, 2, CPG_PLL2CR, 2);
 
 	case CLK_TYPE_GEN3_PLL3:
 		mult = cpg_pll_config->pll3_mult;
@@ -388,8 +377,6 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 */
 		value = readl(base + CPG_PLL4CR);
 		mult = (((value >> 24) & 0x7f) + 1) * 2;
-		if (cpg_quirks & PLL_ERRATA)
-			mult *= 2;
 		break;
 
 	case CLK_TYPE_GEN3_SDH:
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 1a0cdf001b2f..523fd4523157 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -1113,19 +1113,6 @@ static int __init cpg_mssr_init(void)
 
 subsys_initcall(cpg_mssr_init);
 
-void __init cpg_core_nullify_range(struct cpg_core_clk *core_clks,
-				   unsigned int num_core_clks,
-				   unsigned int first_clk,
-				   unsigned int last_clk)
-{
-	unsigned int i;
-
-	for (i = 0; i < num_core_clks; i++)
-		if (core_clks[i].id >= first_clk &&
-		    core_clks[i].id <= last_clk)
-			core_clks[i].name = NULL;
-}
-
 void __init mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 			     unsigned int num_mod_clks,
 			     const unsigned int *clks, unsigned int n)
@@ -1139,19 +1126,5 @@ void __init mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 		}
 }
 
-void __init mssr_mod_reparent(struct mssr_mod_clk *mod_clks,
-			      unsigned int num_mod_clks,
-			      const struct mssr_mod_reparent *clks,
-			      unsigned int n)
-{
-	unsigned int i, j;
-
-	for (i = 0, j = 0; i < num_mod_clks && j < n; i++)
-		if (mod_clks[i].id == clks[j].clk) {
-			mod_clks[i].parent = clks[j].parent;
-			j++;
-		}
-}
-
 MODULE_DESCRIPTION("Renesas CPG/MSSR Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.h b/drivers/clk/renesas/renesas-cpg-mssr.h
index 1c3c057d17f5..80c5b462924a 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.h
+++ b/drivers/clk/renesas/renesas-cpg-mssr.h
@@ -187,21 +187,7 @@ void __init cpg_mssr_early_init(struct device_node *np,
     /*
      * Helpers for fixing up clock tables depending on SoC revision
      */
-
-struct mssr_mod_reparent {
-	unsigned int clk, parent;
-};
-
-
-extern void cpg_core_nullify_range(struct cpg_core_clk *core_clks,
-				   unsigned int num_core_clks,
-				   unsigned int first_clk,
-				   unsigned int last_clk);
 extern void mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 			     unsigned int num_mod_clks,
 			     const unsigned int *clks, unsigned int n);
-extern void mssr_mod_reparent(struct mssr_mod_clk *mod_clks,
-			      unsigned int num_mod_clks,
-			      const struct mssr_mod_reparent *clks,
-			      unsigned int n);
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 6853b93ac82e..df3388e8dec0 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -393,9 +393,10 @@ static int nv_read_register(struct amdgpu_device *adev, u32 se_num,
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(nv_allowed_read_registers); i++) {
 		en = &nv_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-		    reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
-				   + en->reg_offset))
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+					+ en->reg_offset))
 			continue;
 
 		*value = nv_get_register_value(adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 7cd17dda32ce..2eddd7f6cd41 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -439,8 +439,9 @@ static int soc15_read_register(struct amdgpu_device *adev, u32 se_num,
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
 
diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 7050238c4c48..3d938b52178e 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -48,19 +48,31 @@
 static const struct amd_ip_funcs soc21_common_ip_funcs;
 
 /* SOC21 */
-static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array[] =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn0[] =
 {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
 };
 
-static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn1[] =
 {
-	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array),
-	.codec_array = vcn_4_0_0_video_codecs_encode_array,
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn0 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array_vcn0),
+	.codec_array = vcn_4_0_0_video_codecs_encode_array_vcn0,
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn1 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array_vcn1),
+	.codec_array = vcn_4_0_0_video_codecs_encode_array_vcn1,
 };
 
-static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array[] =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array_vcn0[] =
 {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
@@ -69,23 +81,47 @@ static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array[
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
-static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array_vcn1[] =
 {
-	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array),
-	.codec_array = vcn_4_0_0_video_codecs_decode_array,
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode_vcn0 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array_vcn0),
+	.codec_array = vcn_4_0_0_video_codecs_decode_array_vcn0,
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode_vcn1 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array_vcn1),
+	.codec_array = vcn_4_0_0_video_codecs_decode_array_vcn1,
 };
 
 static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 				 const struct amdgpu_video_codecs **codecs)
 {
-	switch (adev->ip_versions[UVD_HWIP][0]) {
+	if (adev->vcn.num_vcn_inst == hweight8(adev->vcn.harvest_config))
+		return -EINVAL;
 
+	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
-		if (encode)
-			*codecs = &vcn_4_0_0_video_codecs_encode;
-		else
-			*codecs = &vcn_4_0_0_video_codecs_decode;
+	case IP_VERSION(4, 0, 4):
+		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
+			if (encode)
+				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
+			else
+				*codecs = &vcn_4_0_0_video_codecs_decode_vcn1;
+		} else {
+			if (encode)
+				*codecs = &vcn_4_0_0_video_codecs_encode_vcn0;
+			else
+				*codecs = &vcn_4_0_0_video_codecs_decode_vcn0;
+		}
 		return 0;
 	default:
 		return -EINVAL;
@@ -255,9 +291,10 @@ static int soc21_read_register(struct amdgpu_device *adev, u32 se_num,
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(soc21_allowed_read_registers); i++) {
 		en = &soc21_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-		    reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
-				   + en->reg_offset))
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+					+ en->reg_offset))
 			continue;
 
 		*value = soc21_get_register_value(adev,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index cd4e61bf0493..3ac599f74fea 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -280,7 +280,7 @@ phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 	if (!pdd->doorbell_index) {
 		int r = kfd_alloc_process_doorbells(pdd->dev,
 						    &pdd->doorbell_index);
-		if (r)
+		if (r < 0)
 			return 0;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index e4dbc8353ea3..9c532167ff46 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2149,13 +2149,19 @@ static bool dcn32_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
-	dc->caps.max_cab_allocation_bytes = 67108864; // 64MB = 1024 * 1024 * 64
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_drr_max_vblank_margin_us = 40;
 	dc->caps.subvp_prefetch_end_to_mall_start_us = 15;
@@ -2592,3 +2598,55 @@ struct pipe_ctx *dcn32_acquire_idle_pipe_for_head_pipe_in_layer(
 
 	return idle_pipe;
 }
+
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans)
+{
+	/*
+	 * DCN32 and DCN321 SKUs may have different sizes for MALL
+	 *  but we may not be able to access all the MALL space.
+	 *  If the num_chans is power of 2, then we can access all
+	 *  of the available MALL space.  Otherwise, we can only
+	 *  access:
+	 *
+	 *  max_cab_size_in_bytes = total_cache_size_in_bytes *
+	 *    ((2^floor(log2(num_chans)))/num_chans)
+	 *
+	 * Calculating the MALL sizes for all available SKUs, we
+	 *  have come up with the follow simplified check.
+	 * - we have max_chans which provides the max MALL size.
+	 *  Each chans supports 4MB of MALL so:
+	 *
+	 *  total_cache_size_in_bytes = max_chans * 4 MB
+	 *
+	 * - we have avail_chans which shows the number of channels
+	 *  we can use if we can't access the entire MALL space.
+	 *  It is generally half of max_chans
+	 * - so we use the following checks:
+	 *
+	 *   if (num_chans == max_chans), return max_chans
+	 *   if (num_chans < max_chans), return avail_chans
+	 *
+	 * - exception is GC_11_0_0 where we can't access max_chans,
+	 *  so we define max_avail_chans as the maximum available
+	 *  MALL space
+	 *
+	 */
+	int gc_11_0_0_max_chans = 48;
+	int gc_11_0_0_max_avail_chans = 32;
+	int gc_11_0_0_avail_chans = 16;
+	int gc_11_0_3_max_chans = 16;
+	int gc_11_0_3_avail_chans = 8;
+	int gc_11_0_2_max_chans = 8;
+	int gc_11_0_2_avail_chans = 4;
+
+	if (ASICREV_IS_GC_11_0_0(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_0_max_chans) ?
+			gc_11_0_0_max_avail_chans : gc_11_0_0_avail_chans;
+	} else if (ASICREV_IS_GC_11_0_2(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_2_max_chans) ?
+			gc_11_0_2_max_chans : gc_11_0_2_avail_chans;
+	} else { // if (ASICREV_IS_GC_11_0_3(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_3_max_chans) ?
+			gc_11_0_3_max_chans : gc_11_0_3_avail_chans;
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
index 13fbc574910b..434b743fa4cb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -134,6 +134,10 @@ void dcn32_restore_mall_state(struct dc *dc,
 		struct dc_state *context,
 		struct mall_temp_config *temp_config);
 
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
+
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index d1f36df03c2e..1709b6edb89c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1702,11 +1702,18 @@ static bool dcn321_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.max_cab_allocation_bytes = 33554432; // 32MB = 1024 * 1024 * 32
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_drr_max_vblank_margin_us = 40;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 69e205ac58b2..3b6194f0fe51 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -693,7 +693,9 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 */
 		if (pipe->plane_state && !pipe->top_pipe &&
 				pipe->stream->mall_stream_config.type == SUBVP_NONE && refresh_rate < 120 && !pipe->plane_state->address.tmz_surface &&
-				vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0) {
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0 ||
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] > 0 &&
+						dcn32_allow_subvp_with_active_margin(pipe)))) {
 			while (pipe) {
 				num_pipes++;
 				pipe = pipe->bottom_pipe;
@@ -2451,8 +2453,11 @@ void dcn32_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_pa
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_2_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_2_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_2_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;
@@ -2630,3 +2635,30 @@ void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
 }
+
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe)
+{
+	bool allow = false;
+	uint32_t refresh_rate = 0;
+
+	/* Allow subvp on displays that have active margin for 2560x1440@60hz displays
+	 * only for now. There must be no scaling as well.
+	 *
+	 * For now we only enable on 2560x1440@60hz displays to enable 4K60 + 1440p60 configs
+	 * for p-state switching.
+	 */
+	if (pipe->stream && pipe->plane_state) {
+		refresh_rate = (pipe->stream->timing.pix_clk_100hz * 100 +
+						pipe->stream->timing.v_total * pipe->stream->timing.h_total - 1)
+						/ (double)(pipe->stream->timing.v_total * pipe->stream->timing.h_total);
+		if (pipe->stream->timing.v_addressable == 1440 &&
+				pipe->stream->timing.h_addressable == 2560 &&
+				refresh_rate >= 55 && refresh_rate <= 65 &&
+				pipe->plane_state->src_rect.height == 1440 &&
+				pipe->plane_state->src_rect.width == 2560 &&
+				pipe->plane_state->dst_rect.height == 1440 &&
+				pipe->plane_state->dst_rect.width == 2560)
+			allow = true;
+	}
+	return allow;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
index 0ea406145c1d..b80cef70fa60 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -534,8 +534,11 @@ void dcn321_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_p
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_21_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_21_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_21_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;
diff --git a/drivers/gpu/drm/display/drm_hdmi_helper.c b/drivers/gpu/drm/display/drm_hdmi_helper.c
index 0264abe55278..faf5e9efa7d3 100644
--- a/drivers/gpu/drm/display/drm_hdmi_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_helper.c
@@ -44,10 +44,8 @@ int drm_hdmi_infoframe_set_hdr_metadata(struct hdmi_drm_infoframe *frame,
 
 	/* Sink EOTF is Bit map while infoframe is absolute values */
 	if (!is_eotf_supported(hdr_metadata->hdmi_metadata_type1.eotf,
-	    connector->hdr_sink_metadata.hdmi_type1.eotf)) {
-		DRM_DEBUG_KMS("EOTF Not Supported\n");
-		return -EINVAL;
-	}
+	    connector->hdr_sink_metadata.hdmi_type1.eotf))
+		DRM_DEBUG_KMS("Unknown EOTF %d\n", hdr_metadata->hdmi_metadata_type1.eotf);
 
 	err = hdmi_drm_infoframe_init(frame);
 	if (err < 0)
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index f197f59f6d99..c0dc5858a723 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1070,6 +1070,7 @@ static void drm_atomic_connector_print_state(struct drm_printer *p,
 	drm_printf(p, "connector[%u]: %s\n", connector->base.id, connector->name);
 	drm_printf(p, "\tcrtc=%s\n", state->crtc ? state->crtc->name : "(null)");
 	drm_printf(p, "\tself_refresh_aware=%d\n", state->self_refresh_aware);
+	drm_printf(p, "\tmax_requested_bpc=%d\n", state->max_requested_bpc);
 
 	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 		if (state->writeback_job && state->writeback_job->fb)
diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index d16b30a2dded..cf5d2f8885f0 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2043,7 +2043,8 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
 	/* attach connector to encoder */
 	intel_connector_attach_encoder(intel_connector, encoder);
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL, NULL);
+	encoder->devdata = intel_bios_encoder_data_lookup(dev_priv, port);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, encoder->devdata, NULL);
 
 	mutex_lock(&dev_priv->drm.mode_config.mutex);
 	intel_panel_add_vbt_lfp_fixed_mode(intel_connector);
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index a491e6c38875..ff4e6d0a5ba2 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -620,14 +620,14 @@ static void dump_pnp_id(struct drm_i915_private *i915,
 
 static int opregion_get_panel_type(struct drm_i915_private *i915,
 				   const struct intel_bios_encoder_data *devdata,
-				   const struct edid *edid)
+				   const struct edid *edid, bool use_fallback)
 {
 	return intel_opregion_get_panel_type(i915);
 }
 
 static int vbt_get_panel_type(struct drm_i915_private *i915,
 			      const struct intel_bios_encoder_data *devdata,
-			      const struct edid *edid)
+			      const struct edid *edid, bool use_fallback)
 {
 	const struct bdb_lvds_options *lvds_options;
 
@@ -652,7 +652,7 @@ static int vbt_get_panel_type(struct drm_i915_private *i915,
 
 static int pnpid_get_panel_type(struct drm_i915_private *i915,
 				const struct intel_bios_encoder_data *devdata,
-				const struct edid *edid)
+				const struct edid *edid, bool use_fallback)
 {
 	const struct bdb_lvds_lfp_data *data;
 	const struct bdb_lvds_lfp_data_ptrs *ptrs;
@@ -701,9 +701,9 @@ static int pnpid_get_panel_type(struct drm_i915_private *i915,
 
 static int fallback_get_panel_type(struct drm_i915_private *i915,
 				   const struct intel_bios_encoder_data *devdata,
-				   const struct edid *edid)
+				   const struct edid *edid, bool use_fallback)
 {
-	return 0;
+	return use_fallback ? 0 : -1;
 }
 
 enum panel_type {
@@ -715,13 +715,13 @@ enum panel_type {
 
 static int get_panel_type(struct drm_i915_private *i915,
 			  const struct intel_bios_encoder_data *devdata,
-			  const struct edid *edid)
+			  const struct edid *edid, bool use_fallback)
 {
 	struct {
 		const char *name;
 		int (*get_panel_type)(struct drm_i915_private *i915,
 				      const struct intel_bios_encoder_data *devdata,
-				      const struct edid *edid);
+				      const struct edid *edid, bool use_fallback);
 		int panel_type;
 	} panel_types[] = {
 		[PANEL_TYPE_OPREGION] = {
@@ -744,7 +744,8 @@ static int get_panel_type(struct drm_i915_private *i915,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(panel_types); i++) {
-		panel_types[i].panel_type = panel_types[i].get_panel_type(i915, devdata, edid);
+		panel_types[i].panel_type = panel_types[i].get_panel_type(i915, devdata,
+									  edid, use_fallback);
 
 		drm_WARN_ON(&i915->drm, panel_types[i].panel_type > 0xf &&
 			    panel_types[i].panel_type != 0xff);
@@ -2592,6 +2593,12 @@ intel_bios_encoder_supports_edp(const struct intel_bios_encoder_data *devdata)
 		devdata->child.device_type & DEVICE_TYPE_INTERNAL_CONNECTOR;
 }
 
+static bool
+intel_bios_encoder_supports_dsi(const struct intel_bios_encoder_data *devdata)
+{
+	return devdata->child.device_type & DEVICE_TYPE_MIPI_OUTPUT;
+}
+
 static int _intel_bios_hdmi_level_shift(const struct intel_bios_encoder_data *devdata)
 {
 	if (!devdata || devdata->i915->display.vbt.version < 158)
@@ -2642,7 +2649,7 @@ static void print_ddi_port(const struct intel_bios_encoder_data *devdata,
 {
 	struct drm_i915_private *i915 = devdata->i915;
 	const struct child_device_config *child = &devdata->child;
-	bool is_dvi, is_hdmi, is_dp, is_edp, is_crt, supports_typec_usb, supports_tbt;
+	bool is_dvi, is_hdmi, is_dp, is_edp, is_dsi, is_crt, supports_typec_usb, supports_tbt;
 	int dp_boost_level, dp_max_link_rate, hdmi_boost_level, hdmi_level_shift, max_tmds_clock;
 
 	is_dvi = intel_bios_encoder_supports_dvi(devdata);
@@ -2650,13 +2657,14 @@ static void print_ddi_port(const struct intel_bios_encoder_data *devdata,
 	is_crt = intel_bios_encoder_supports_crt(devdata);
 	is_hdmi = intel_bios_encoder_supports_hdmi(devdata);
 	is_edp = intel_bios_encoder_supports_edp(devdata);
+	is_dsi = intel_bios_encoder_supports_dsi(devdata);
 
 	supports_typec_usb = intel_bios_encoder_supports_typec_usb(devdata);
 	supports_tbt = intel_bios_encoder_supports_tbt(devdata);
 
 	drm_dbg_kms(&i915->drm,
-		    "Port %c VBT info: CRT:%d DVI:%d HDMI:%d DP:%d eDP:%d LSPCON:%d USB-Type-C:%d TBT:%d DSC:%d\n",
-		    port_name(port), is_crt, is_dvi, is_hdmi, is_dp, is_edp,
+		    "Port %c VBT info: CRT:%d DVI:%d HDMI:%d DP:%d eDP:%d DSI:%d LSPCON:%d USB-Type-C:%d TBT:%d DSC:%d\n",
+		    port_name(port), is_crt, is_dvi, is_hdmi, is_dp, is_edp, is_dsi,
 		    HAS_LSPCON(i915) && child->lspcon,
 		    supports_typec_usb, supports_tbt,
 		    devdata->dsc != NULL);
@@ -2709,6 +2717,8 @@ static void parse_ddi_port(struct intel_bios_encoder_data *devdata)
 	enum port port;
 
 	port = dvo_port_to_port(i915, child->dvo_port);
+	if (port == PORT_NONE && DISPLAY_VER(i915) >= 11)
+		port = dsi_dvo_port_to_port(i915, child->dvo_port);
 	if (port == PORT_NONE)
 		return;
 
@@ -3199,14 +3209,26 @@ void intel_bios_init(struct drm_i915_private *i915)
 	kfree(oprom_vbt);
 }
 
-void intel_bios_init_panel(struct drm_i915_private *i915,
-			   struct intel_panel *panel,
-			   const struct intel_bios_encoder_data *devdata,
-			   const struct edid *edid)
+static void intel_bios_init_panel(struct drm_i915_private *i915,
+				  struct intel_panel *panel,
+				  const struct intel_bios_encoder_data *devdata,
+				  const struct edid *edid,
+				  bool use_fallback)
 {
-	init_vbt_panel_defaults(panel);
+	/* already have it? */
+	if (panel->vbt.panel_type >= 0) {
+		drm_WARN_ON(&i915->drm, !use_fallback);
+		return;
+	}
 
-	panel->vbt.panel_type = get_panel_type(i915, devdata, edid);
+	panel->vbt.panel_type = get_panel_type(i915, devdata,
+					       edid, use_fallback);
+	if (panel->vbt.panel_type < 0) {
+		drm_WARN_ON(&i915->drm, use_fallback);
+		return;
+	}
+
+	init_vbt_panel_defaults(panel);
 
 	parse_panel_options(i915, panel);
 	parse_generic_dtd(i915, panel);
@@ -3221,6 +3243,21 @@ void intel_bios_init_panel(struct drm_i915_private *i915,
 	parse_mipi_sequence(i915, panel);
 }
 
+void intel_bios_init_panel_early(struct drm_i915_private *i915,
+				 struct intel_panel *panel,
+				 const struct intel_bios_encoder_data *devdata)
+{
+	intel_bios_init_panel(i915, panel, devdata, NULL, false);
+}
+
+void intel_bios_init_panel_late(struct drm_i915_private *i915,
+				struct intel_panel *panel,
+				const struct intel_bios_encoder_data *devdata,
+				const struct edid *edid)
+{
+	intel_bios_init_panel(i915, panel, devdata, edid, true);
+}
+
 /**
  * intel_bios_driver_remove - Free any resources allocated by intel_bios_init()
  * @i915: i915 device instance
diff --git a/drivers/gpu/drm/i915/display/intel_bios.h b/drivers/gpu/drm/i915/display/intel_bios.h
index e375405a7828..ff1fdd2e0c1c 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.h
+++ b/drivers/gpu/drm/i915/display/intel_bios.h
@@ -232,10 +232,13 @@ struct mipi_pps_data {
 } __packed;
 
 void intel_bios_init(struct drm_i915_private *dev_priv);
-void intel_bios_init_panel(struct drm_i915_private *dev_priv,
-			   struct intel_panel *panel,
-			   const struct intel_bios_encoder_data *devdata,
-			   const struct edid *edid);
+void intel_bios_init_panel_early(struct drm_i915_private *dev_priv,
+				 struct intel_panel *panel,
+				 const struct intel_bios_encoder_data *devdata);
+void intel_bios_init_panel_late(struct drm_i915_private *dev_priv,
+				struct intel_panel *panel,
+				const struct intel_bios_encoder_data *devdata,
+				const struct edid *edid);
 void intel_bios_fini_panel(struct intel_panel *panel);
 void intel_bios_driver_remove(struct drm_i915_private *dev_priv);
 bool intel_bios_is_valid_vbt(const void *buf, size_t size);
diff --git a/drivers/gpu/drm/i915/display/intel_connector.c b/drivers/gpu/drm/i915/display/intel_connector.c
index 6205ddd3ded0..562da3b741e2 100644
--- a/drivers/gpu/drm/i915/display/intel_connector.c
+++ b/drivers/gpu/drm/i915/display/intel_connector.c
@@ -54,7 +54,7 @@ int intel_connector_init(struct intel_connector *connector)
 	__drm_atomic_helper_connector_reset(&connector->base,
 					    &conn_state->base);
 
-	INIT_LIST_HEAD(&connector->panel.fixed_modes);
+	intel_panel_init_alloc(connector);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index f07395065a69..1b6989001ee2 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -291,7 +291,7 @@ struct intel_vbt_panel_data {
 	struct drm_display_mode *sdvo_lvds_vbt_mode; /* if any */
 
 	/* Feature bits */
-	unsigned int panel_type:4;
+	int panel_type;
 	unsigned int lvds_dither:1;
 	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 75070eb07d4b..1edb21f69808 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5202,6 +5202,9 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	intel_bios_init_panel_early(dev_priv, &intel_connector->panel,
+				    encoder->devdata);
+
 	intel_pps_init(intel_dp);
 
 	/* Cache DPCD and EDID for edp. */
@@ -5237,8 +5240,8 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 	}
 	intel_connector->edid = edid;
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel,
-			      encoder->devdata, IS_ERR(edid) ? NULL : edid);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel,
+				   encoder->devdata, IS_ERR(edid) ? NULL : edid);
 
 	intel_panel_add_edid_fixed_modes(intel_connector, true);
 
diff --git a/drivers/gpu/drm/i915/display/intel_lvds.c b/drivers/gpu/drm/i915/display/intel_lvds.c
index 7bf1bdfd03ec..aecec992cd0d 100644
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -964,8 +964,8 @@ void intel_lvds_init(struct drm_i915_private *dev_priv)
 	}
 	intel_connector->edid = edid;
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL,
-			      IS_ERR(edid) ? NULL : edid);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL,
+				   IS_ERR(edid) ? NULL : edid);
 
 	/* Try EDID first */
 	intel_panel_add_edid_fixed_modes(intel_connector, true);
diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 1640726bfbf6..609fcdbd7d58 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -661,6 +661,14 @@ intel_panel_mode_valid(struct intel_connector *connector,
 	return MODE_OK;
 }
 
+void intel_panel_init_alloc(struct intel_connector *connector)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	connector->panel.vbt.panel_type = -1;
+	INIT_LIST_HEAD(&panel->fixed_modes);
+}
+
 int intel_panel_init(struct intel_connector *connector)
 {
 	struct intel_panel *panel = &connector->panel;
diff --git a/drivers/gpu/drm/i915/display/intel_panel.h b/drivers/gpu/drm/i915/display/intel_panel.h
index 5c5b5b7f95b6..4b51e1c51da6 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.h
+++ b/drivers/gpu/drm/i915/display/intel_panel.h
@@ -18,6 +18,7 @@ struct intel_connector;
 struct intel_crtc_state;
 struct intel_encoder;
 
+void intel_panel_init_alloc(struct intel_connector *connector);
 int intel_panel_init(struct intel_connector *connector);
 void intel_panel_fini(struct intel_connector *connector);
 enum drm_connector_status
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 329b9d9af667..21805c15d5eb 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2886,7 +2886,7 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, u16 type)
 	if (!intel_sdvo_create_enhance_property(intel_sdvo, intel_sdvo_connector))
 		goto err;
 
-	intel_bios_init_panel(i915, &intel_connector->panel, NULL, NULL);
+	intel_bios_init_panel_late(i915, &intel_connector->panel, NULL, NULL);
 
 	/*
 	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index 84481030883a..662bdb656aa3 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1916,7 +1916,7 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
 
 	intel_dsi->panel_power_off_time = ktime_get_boottime();
 
-	intel_bios_init_panel(dev_priv, &intel_connector->panel, NULL, NULL);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL, NULL);
 
 	if (intel_connector->panel.vbt.dsi.config->dual_link)
 		intel_dsi->ports = BIT(PORT_A) | BIT(PORT_C);
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 660ba0db8900..047c5e8c87ff 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -151,8 +151,8 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_RING(ring, 1);
 
 	/* Enable local preemption for finegrain preemption */
-	OUT_PKT7(ring, CP_PREEMPT_ENABLE_GLOBAL, 1);
-	OUT_RING(ring, 0x02);
+	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
+	OUT_RING(ring, 0x1);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
@@ -806,7 +806,7 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_RBBM_AHB_CNTL2, 0x0000003F);
 
 	/* Set the highest bank bit */
-	if (adreno_is_a540(adreno_gpu))
+	if (adreno_is_a540(adreno_gpu) || adreno_is_a530(adreno_gpu))
 		regbit = 2;
 	else
 		regbit = 1;
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 7658e89844b4..f58dd564d122 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -63,7 +63,7 @@ static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 		struct msm_ringbuffer *ring = gpu->rb[i];
 
 		spin_lock_irqsave(&ring->preempt_lock, flags);
-		empty = (get_wptr(ring) == ring->memptrs->rptr);
+		empty = (get_wptr(ring) == gpu->funcs->get_rptr(gpu, ring));
 		spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 		if (!empty)
@@ -207,6 +207,7 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
+		a5xx_gpu->preempt[i]->rptr_addr = shadowptr(a5xx_gpu, gpu->rb[i]);
 	}
 
 	/* Write a 0 to signal that we aren't switching pagetables */
@@ -257,7 +258,6 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE;
 
-	ptr->rptr_addr = shadowptr(a5xx_gpu, ring);
 	ptr->counter = counters_iova;
 
 	return 0;
diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 36f062c7582f..c5c4c93b3689 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -558,7 +558,8 @@ static void adreno_unbind(struct device *dev, struct device *master,
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
-	WARN_ON_ONCE(adreno_system_suspend(dev));
+	if (pm_runtime_enabled(dev))
+		WARN_ON_ONCE(adreno_system_suspend(dev));
 	gpu->funcs->destroy(gpu);
 
 	priv->gpu_pdev = NULL;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 83f1dd2c22bd..e8a217d242ca 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -12,11 +12,15 @@
 #include "dpu_hw_catalog.h"
 #include "dpu_kms.h"
 
-#define VIG_MASK \
+#define VIG_BASE_MASK \
 	(BIT(DPU_SSPP_SRC) | BIT(DPU_SSPP_QOS) |\
-	BIT(DPU_SSPP_CSC_10BIT) | BIT(DPU_SSPP_CDP) |\
+	BIT(DPU_SSPP_CDP) |\
 	BIT(DPU_SSPP_TS_PREFILL) | BIT(DPU_SSPP_EXCL_RECT))
 
+#define VIG_MASK \
+	(VIG_BASE_MASK | \
+	BIT(DPU_SSPP_CSC_10BIT))
+
 #define VIG_MSM8998_MASK \
 	(VIG_MASK | BIT(DPU_SSPP_SCALER_QSEED3))
 
@@ -26,10 +30,7 @@
 #define VIG_SC7180_MASK \
 	(VIG_MASK | BIT(DPU_SSPP_QOS_8LVL) | BIT(DPU_SSPP_SCALER_QSEED4))
 
-#define VIG_SM8250_MASK \
-	(VIG_MASK | BIT(DPU_SSPP_QOS_8LVL) | BIT(DPU_SSPP_SCALER_QSEED3LITE))
-
-#define VIG_QCM2290_MASK (VIG_MASK | BIT(DPU_SSPP_QOS_8LVL))
+#define VIG_QCM2290_MASK (VIG_BASE_MASK | BIT(DPU_SSPP_QOS_8LVL))
 
 #define DMA_MSM8998_MASK \
 	(BIT(DPU_SSPP_SRC) | BIT(DPU_SSPP_QOS) |\
@@ -51,7 +52,7 @@
 	(DMA_MSM8998_MASK | BIT(DPU_SSPP_CURSOR))
 
 #define MIXER_MSM8998_MASK \
-	(BIT(DPU_MIXER_SOURCESPLIT) | BIT(DPU_DIM_LAYER))
+	(BIT(DPU_MIXER_SOURCESPLIT))
 
 #define MIXER_SDM845_MASK \
 	(BIT(DPU_MIXER_SOURCESPLIT) | BIT(DPU_DIM_LAYER) | BIT(DPU_MIXER_COMBINED_ALPHA))
@@ -283,10 +284,9 @@ static const struct dpu_caps msm8998_dpu_caps = {
 };
 
 static const struct dpu_caps qcm2290_dpu_caps = {
-	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
 	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
-	.ubwc_version = DPU_HW_UBWC_VER_20,
 	.has_dim_layer = true,
 	.has_idle_pc = true,
 	.max_linewidth = 2160,
@@ -322,9 +322,9 @@ static const struct dpu_caps sc7180_dpu_caps = {
 };
 
 static const struct dpu_caps sm6115_dpu_caps = {
-	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
-	.qseed_type = DPU_SSPP_SCALER_QSEED3LITE,
+	.qseed_type = DPU_SSPP_SCALER_QSEED4,
 	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_20,
 	.has_dim_layer = true,
@@ -368,7 +368,7 @@ static const struct dpu_caps sc8180x_dpu_caps = {
 static const struct dpu_caps sm8250_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
-	.qseed_type = DPU_SSPP_SCALER_QSEED3LITE,
+	.qseed_type = DPU_SSPP_SCALER_QSEED4,
 	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
@@ -632,19 +632,19 @@ static const struct dpu_ctl_cfg sdm845_ctl[] = {
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
@@ -838,9 +838,9 @@ static const struct dpu_sspp_cfg msm8998_sspp[] = {
 	SSPP_BLK("sspp_9", SSPP_DMA1, 0x26000,  DMA_MSM8998_MASK,
 		sdm845_dma_sblk_1, 5, SSPP_TYPE_DMA, DPU_CLK_CTRL_DMA1),
 	SSPP_BLK("sspp_10", SSPP_DMA2, 0x28000,  DMA_CURSOR_MSM8998_MASK,
-		sdm845_dma_sblk_2, 9, SSPP_TYPE_DMA, DPU_CLK_CTRL_CURSOR0),
+		sdm845_dma_sblk_2, 9, SSPP_TYPE_DMA, DPU_CLK_CTRL_DMA2),
 	SSPP_BLK("sspp_11", SSPP_DMA3, 0x2a000,  DMA_CURSOR_MSM8998_MASK,
-		sdm845_dma_sblk_3, 13, SSPP_TYPE_DMA, DPU_CLK_CTRL_CURSOR1),
+		sdm845_dma_sblk_3, 13, SSPP_TYPE_DMA, DPU_CLK_CTRL_DMA3),
 };
 
 static const struct dpu_sspp_cfg sdm845_sspp[] = {
@@ -880,32 +880,32 @@ static const struct dpu_sspp_cfg sc7180_sspp[] = {
 };
 
 static const struct dpu_sspp_sub_blks sm6115_vig_sblk_0 =
-				_VIG_SBLK("0", 2, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK("0", 2, DPU_SSPP_SCALER_QSEED4);
 
 static const struct dpu_sspp_cfg sm6115_sspp[] = {
-	SSPP_BLK("sspp_0", SSPP_VIG0, 0x4000, VIG_SM8250_MASK,
+	SSPP_BLK("sspp_0", SSPP_VIG0, 0x4000, VIG_SC7180_MASK,
 		sm6115_vig_sblk_0, 0, SSPP_TYPE_VIG, DPU_CLK_CTRL_VIG0),
 	SSPP_BLK("sspp_8", SSPP_DMA0, 0x24000,  DMA_SDM845_MASK,
 		sdm845_dma_sblk_0, 1, SSPP_TYPE_DMA, DPU_CLK_CTRL_DMA0),
 };
 
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_0 =
-				_VIG_SBLK("0", 5, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK("0", 5, DPU_SSPP_SCALER_QSEED4);
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_1 =
-				_VIG_SBLK("1", 6, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK("1", 6, DPU_SSPP_SCALER_QSEED4);
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_2 =
-				_VIG_SBLK("2", 7, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK("2", 7, DPU_SSPP_SCALER_QSEED4);
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_3 =
-				_VIG_SBLK("3", 8, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK("3", 8, DPU_SSPP_SCALER_QSEED4);
 
 static const struct dpu_sspp_cfg sm8250_sspp[] = {
-	SSPP_BLK("sspp_0", SSPP_VIG0, 0x4000, VIG_SM8250_MASK,
+	SSPP_BLK("sspp_0", SSPP_VIG0, 0x4000, VIG_SC7180_MASK,
 		sm8250_vig_sblk_0, 0,  SSPP_TYPE_VIG, DPU_CLK_CTRL_VIG0),
-	SSPP_BLK("sspp_1", SSPP_VIG1, 0x6000, VIG_SM8250_MASK,
+	SSPP_BLK("sspp_1", SSPP_VIG1, 0x6000, VIG_SC7180_MASK,
 		sm8250_vig_sblk_1, 4,  SSPP_TYPE_VIG, DPU_CLK_CTRL_VIG1),
-	SSPP_BLK("sspp_2", SSPP_VIG2, 0x8000, VIG_SM8250_MASK,
+	SSPP_BLK("sspp_2", SSPP_VIG2, 0x8000, VIG_SC7180_MASK,
 		sm8250_vig_sblk_2, 8, SSPP_TYPE_VIG, DPU_CLK_CTRL_VIG2),
-	SSPP_BLK("sspp_3", SSPP_VIG3, 0xa000, VIG_SM8250_MASK,
+	SSPP_BLK("sspp_3", SSPP_VIG3, 0xa000, VIG_SC7180_MASK,
 		sm8250_vig_sblk_3, 12,  SSPP_TYPE_VIG, DPU_CLK_CTRL_VIG3),
 	SSPP_BLK("sspp_8", SSPP_DMA0, 0x24000,  DMA_SDM845_MASK,
 		sdm845_dma_sblk_0, 1, SSPP_TYPE_DMA, DPU_CLK_CTRL_DMA0),
@@ -1065,7 +1065,7 @@ static const struct dpu_lm_cfg sc7280_lm[] = {
 /* QCM2290 */
 
 static const struct dpu_lm_sub_blks qcm2290_lm_sblk = {
-	.maxwidth = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.maxwidth = DEFAULT_DPU_LINE_WIDTH,
 	.maxblendstages = 4, /* excluding base layer */
 	.blendstage_base = { /* offsets relative to mixer base */
 		0x20, 0x38, 0x50, 0x68
@@ -1216,7 +1216,7 @@ static const struct dpu_pingpong_cfg sm8150_pp[] = {
 };
 
 static const struct dpu_pingpong_cfg sc7280_pp[] = {
-	PP_BLK("pingpong_0", PINGPONG_0, 0x59000, 0, sc7280_pp_sblk, -1, -1),
+	PP_BLK("pingpong_0", PINGPONG_0, 0x69000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_1", PINGPONG_1, 0x6a000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_2", PINGPONG_2, 0x6b000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_3", PINGPONG_3, 0x6c000, 0, sc7280_pp_sblk, -1, -1),
@@ -2007,8 +2007,6 @@ static const struct dpu_mdss_cfg qcm2290_dpu_cfg = {
 	.intf = qcm2290_intf,
 	.vbif_count = ARRAY_SIZE(sdm845_vbif),
 	.vbif = sdm845_vbif,
-	.reg_dma_count = 1,
-	.dma_cfg = &sdm845_regdma,
 	.perf = &qcm2290_perf_data,
 	.mdss_irqs = IRQ_SC7180_MASK,
 };
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 7ada957adbbb..58abf5fe97e2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -572,6 +572,8 @@ void dpu_rm_release(struct dpu_global_state *global_state,
 		ARRAY_SIZE(global_state->ctl_to_enc_id), enc->base.id);
 	_dpu_rm_clear_mapping(global_state->dsc_to_enc_id,
 		ARRAY_SIZE(global_state->dsc_to_enc_id), enc->base.id);
+	_dpu_rm_clear_mapping(global_state->dspp_to_enc_id,
+		ARRAY_SIZE(global_state->dspp_to_enc_id), enc->base.id);
 }
 
 int dpu_rm_reserve(
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 1c4be193fd23..8ac1cd27746a 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -626,8 +626,8 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 	int ret = 0;
 	uint32_t i, j;
 
-	post_deps = kmalloc_array(nr_syncobjs, sizeof(*post_deps),
-	                          GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	post_deps = kcalloc(nr_syncobjs, sizeof(*post_deps),
+			    GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!post_deps)
 		return ERR_PTR(-ENOMEM);
 
@@ -642,7 +642,6 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 		}
 
 		post_deps[i].point = syncobj_desc.point;
-		post_deps[i].chain = NULL;
 
 		if (syncobj_desc.flags) {
 			ret = -EINVAL;
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.h b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
index 591c852f326b..76a6ae5d5652 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
@@ -35,8 +35,9 @@ struct nv50_wndw {
 
 int nv50_wndw_new_(const struct nv50_wndw_func *, struct drm_device *,
 		   enum drm_plane_type, const char *name, int index,
-		   const u32 *format, enum nv50_disp_interlock_type,
-		   u32 interlock_data, u32 heads, struct nv50_wndw **);
+		   const u32 *format, u32 heads,
+		   enum nv50_disp_interlock_type, u32 interlock_data,
+		   struct nv50_wndw **);
 void nv50_wndw_flush_set(struct nv50_wndw *, u32 *interlock,
 			 struct nv50_wndw_atom *);
 void nv50_wndw_flush_clr(struct nv50_wndw *, u32 *interlock, bool flush,
diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
index c5a4f49ee206..01a22a13b452 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
@@ -2,6 +2,7 @@
 #ifndef __NVKM_FB_H__
 #define __NVKM_FB_H__
 #include <core/subdev.h>
+#include <core/falcon.h>
 #include <core/mm.h>
 
 /* memory type/access flags, do not match hardware values */
@@ -33,7 +34,7 @@ struct nvkm_fb {
 	const struct nvkm_fb_func *func;
 	struct nvkm_subdev subdev;
 
-	struct nvkm_blob vpr_scrubber;
+	struct nvkm_falcon_fw vpr_scrubber;
 
 	struct {
 		struct page *flush_page;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
index bac7dcc4c2c1..0955340cc421 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
@@ -143,6 +143,10 @@ nvkm_fb_mem_unlock(struct nvkm_fb *fb)
 	if (!fb->func->vpr.scrub_required)
 		return 0;
 
+	ret = nvkm_subdev_oneinit(subdev);
+	if (ret)
+		return ret;
+
 	if (!fb->func->vpr.scrub_required(fb)) {
 		nvkm_debug(subdev, "VPR not locked\n");
 		return 0;
@@ -150,7 +154,7 @@ nvkm_fb_mem_unlock(struct nvkm_fb *fb)
 
 	nvkm_debug(subdev, "VPR locked, running scrubber binary\n");
 
-	if (!fb->vpr_scrubber.size) {
+	if (!fb->vpr_scrubber.fw.img) {
 		nvkm_warn(subdev, "VPR locked, but no scrubber binary!\n");
 		return 0;
 	}
@@ -229,7 +233,7 @@ nvkm_fb_dtor(struct nvkm_subdev *subdev)
 
 	nvkm_ram_del(&fb->ram);
 
-	nvkm_blob_dtor(&fb->vpr_scrubber);
+	nvkm_falcon_fw_dtor(&fb->vpr_scrubber);
 
 	if (fb->sysmem.flush_page) {
 		dma_unmap_page(subdev->device->dev, fb->sysmem.flush_page_addr,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
index 5098f219e3e6..a7456e786463 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
@@ -37,5 +37,5 @@ ga100_fb = {
 int
 ga100_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&ga100_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&ga100_fb, device, type, inst, pfb);
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
index 5a21b0ae4595..dd476e079fe1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
@@ -25,25 +25,20 @@
 #include <engine/nvdec.h>
 
 static int
-ga102_fb_vpr_scrub(struct nvkm_fb *fb)
+ga102_fb_oneinit(struct nvkm_fb *fb)
 {
-	struct nvkm_falcon_fw fw = {};
-	int ret;
+	struct nvkm_subdev *subdev = &fb->subdev;
 
-	ret = nvkm_falcon_fw_ctor_hs_v2(&ga102_flcn_fw, "mem-unlock", &fb->subdev, "nvdec/scrubber",
-					0, &fb->subdev.device->nvdec[0]->falcon, &fw);
-	if (ret)
-		return ret;
+	nvkm_falcon_fw_ctor_hs_v2(&ga102_flcn_fw, "mem-unlock", subdev, "nvdec/scrubber",
+				  0, &subdev->device->nvdec[0]->falcon, &fb->vpr_scrubber);
 
-	ret = nvkm_falcon_fw_boot(&fw, &fb->subdev, true, NULL, NULL, 0, 0);
-	nvkm_falcon_fw_dtor(&fw);
-	return ret;
+	return gf100_fb_oneinit(fb);
 }
 
 static const struct nvkm_fb_func
 ga102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = ga102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -51,13 +46,13 @@ ga102_fb = {
 	.ram_new = ga102_ram_new,
 	.default_bigpage = 16,
 	.vpr.scrub_required = tu102_fb_vpr_scrub_required,
-	.vpr.scrub = ga102_fb_vpr_scrub,
+	.vpr.scrub = gp102_fb_vpr_scrub,
 };
 
 int
 ga102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&ga102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&ga102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/ga102/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
index 2658481d575b..14d942e8b857 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
@@ -29,18 +29,7 @@
 int
 gp102_fb_vpr_scrub(struct nvkm_fb *fb)
 {
-	struct nvkm_subdev *subdev = &fb->subdev;
-	struct nvkm_falcon_fw fw = {};
-	int ret;
-
-	ret = nvkm_falcon_fw_ctor_hs(&gm200_flcn_fw, "mem-unlock", subdev, NULL,
-				     "nvdec/scrubber", 0, &subdev->device->nvdec[0]->falcon, &fw);
-	if (ret)
-		return ret;
-
-	ret = nvkm_falcon_fw_boot(&fw, subdev, true, NULL, NULL, 0, 0x00000000);
-	nvkm_falcon_fw_dtor(&fw);
-	return ret;
+	return nvkm_falcon_fw_boot(&fb->vpr_scrubber, &fb->subdev, true, NULL, NULL, 0, 0x00000000);
 }
 
 bool
@@ -51,10 +40,21 @@ gp102_fb_vpr_scrub_required(struct nvkm_fb *fb)
 	return (nvkm_rd32(device, 0x100cd0) & 0x00000010) != 0;
 }
 
+int
+gp102_fb_oneinit(struct nvkm_fb *fb)
+{
+	struct nvkm_subdev *subdev = &fb->subdev;
+
+	nvkm_falcon_fw_ctor_hs(&gm200_flcn_fw, "mem-unlock", subdev, NULL, "nvdec/scrubber",
+			       0, &subdev->device->nvdec[0]->falcon, &fb->vpr_scrubber);
+
+	return gf100_fb_oneinit(fb);
+}
+
 static const struct nvkm_fb_func
 gp102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_remapper = gp100_fb_init_remapper,
 	.init_page = gm200_fb_init_page,
@@ -64,23 +64,10 @@ gp102_fb = {
 	.ram_new = gp100_ram_new,
 };
 
-int
-gp102_fb_new_(const struct nvkm_fb_func *func, struct nvkm_device *device,
-	      enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
-{
-	int ret = gf100_fb_new_(func, device, type, inst, pfb);
-	if (ret)
-		return ret;
-
-	nvkm_firmware_load_blob(&(*pfb)->subdev, "nvdec/scrubber", "", 0,
-				&(*pfb)->vpr_scrubber);
-	return 0;
-}
-
 int
 gp102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&gp102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&gp102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/gp102/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
index 0e3c0a8f5d71..4d8a286a7a34 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
@@ -31,7 +31,7 @@ gv100_fb_init_page(struct nvkm_fb *fb)
 static const struct nvkm_fb_func
 gv100_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -45,7 +45,7 @@ gv100_fb = {
 int
 gv100_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&gv100_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&gv100_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/gv100/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
index f517751f94ac..726c30c8bf95 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
@@ -83,8 +83,7 @@ int gm200_fb_init_page(struct nvkm_fb *);
 void gp100_fb_init_remapper(struct nvkm_fb *);
 void gp100_fb_init_unkn(struct nvkm_fb *);
 
-int gp102_fb_new_(const struct nvkm_fb_func *, struct nvkm_device *, enum nvkm_subdev_type, int,
-		  struct nvkm_fb **);
+int gp102_fb_oneinit(struct nvkm_fb *);
 bool gp102_fb_vpr_scrub_required(struct nvkm_fb *);
 int gp102_fb_vpr_scrub(struct nvkm_fb *);
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
index be82af0364ee..b8803c124c3b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
@@ -31,7 +31,7 @@ tu102_fb_vpr_scrub_required(struct nvkm_fb *fb)
 static const struct nvkm_fb_func
 tu102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -45,7 +45,7 @@ tu102_fb = {
 int
 tu102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&tu102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&tu102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/tu102/nvdec/scrubber.bin");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5c72aef3d3dd..799a3086dbb0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -261,6 +261,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int usages;
 	unsigned int offset;
 	unsigned int i;
@@ -291,8 +292,11 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	offset = report->size;
 	report->size += parser->global.report_size * parser->global.report_count;
 
+	if (parser->device->ll_driver->max_buffer_size)
+		max_buffer_size = parser->device->ll_driver->max_buffer_size;
+
 	/* Total size check: Allow for possible report index byte */
-	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+	if (report->size > (max_buffer_size - 1) << 3) {
 		hid_err(parser->device, "report is too long\n");
 		return -1;
 	}
@@ -1966,6 +1970,7 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
 	int ret = 0;
@@ -1981,10 +1986,13 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 
 	rsize = hid_compute_report_size(report);
 
-	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE - 1;
-	else if (rsize > HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE;
+	if (hid->ll_driver->max_buffer_size)
+		max_buffer_size = hid->ll_driver->max_buffer_size;
+
+	if (report_enum->numbered && rsize >= max_buffer_size)
+		rsize = max_buffer_size - 1;
+	else if (rsize > max_buffer_size)
+		rsize = max_buffer_size;
 
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
@@ -2387,7 +2395,12 @@ int hid_hw_raw_request(struct hid_device *hdev,
 		       unsigned char reportnum, __u8 *buf,
 		       size_t len, enum hid_report_type rtype, enum hid_class_request reqtype)
 {
-	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
+
+	if (hdev->ll_driver->max_buffer_size)
+		max_buffer_size = hdev->ll_driver->max_buffer_size;
+
+	if (len < 1 || len > max_buffer_size || !buf)
 		return -EINVAL;
 
 	return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
@@ -2406,7 +2419,12 @@ EXPORT_SYMBOL_GPL(hid_hw_raw_request);
  */
 int hid_hw_output_report(struct hid_device *hdev, __u8 *buf, size_t len)
 {
-	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
+
+	if (hdev->ll_driver->max_buffer_size)
+		max_buffer_size = hdev->ll_driver->max_buffer_size;
+
+	if (len < 1 || len > max_buffer_size || !buf)
 		return -EINVAL;
 
 	if (hdev->ll_driver->output_report)
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 2a918aeb0af1..59ac757c1d47 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 24f0a444d312..9c6febce2376 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -33,8 +33,8 @@
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
index 00c6fe25fcba..2bdb73b34d29 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -274,8 +274,8 @@ struct smu_cpu_power_sensor {
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
index c159f297ab92..16ca9dbf1544 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3482,7 +3482,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
 					     0, 1, 1, 1);
-	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_ANALOGUE_GAIN,
 					0, 1023, 1, 0);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 8f1fff7af6c9..8dbe780dae4e 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -126,6 +126,23 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
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
@@ -185,6 +202,7 @@ MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
 
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
+	.remove = gpio_ir_recv_remove,
 	.driver = {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 338f238f2043..003672d71a3b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -393,6 +393,24 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
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
@@ -453,21 +471,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
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
@@ -2201,6 +2204,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7530_pll_setup(priv);
+
 	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 3038386a5afd..1761df8fb7f9 100644
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
index e05ac92c0650..d73ef262991d 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -472,6 +472,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6c32f5c427b5..25d1642c10c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3146,7 +3146,7 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 
 static void bnxt_free_tpa_info(struct bnxt *bp)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -3154,8 +3154,10 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
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
@@ -3164,14 +3166,13 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 
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
@@ -3185,12 +3186,12 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 
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
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 6be02f9b0b8c..789b99963910 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1372,7 +1372,7 @@ ice_add_dscp_pfc_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
 	tlv->ouisubtype = htonl(ouisubtype);
 
 	buf[0] = dcbcfg->pfc.pfccap & 0xF;
-	buf[1] = dcbcfg->pfc.pfcena & 0xF;
+	buf[1] = dcbcfg->pfc.pfcena;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a359f1610fc1..8ca61610cec2 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -4314,6 +4314,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 		 * SFP modules only ever use page 0.
 		 */
 		if (page == 0 || !(data[0x2] & 0x4)) {
+			u32 copy_len;
+
 			/* If i2c bus is busy due to slow page change or
 			 * link management access, call can fail. This is normal.
 			 * So we retry this a few times.
@@ -4337,8 +4339,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 			}
 
 			/* Make sure we have enough room for the new block */
-			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
-				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
+			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE, ee->len - i);
+			memcpy(data + i, value, copy_len);
 		}
 	}
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 95f392ab9670..ce72d512eddf 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1448,8 +1448,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
 			headers->vlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 
 		if (match.mask->vlan_tpid)
@@ -1482,8 +1482,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
 			headers->cvlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7f0a64731c67..f6c45cf27caf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -866,6 +866,9 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 
+#define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
+#define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
+
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
 void rvu_program_channels(struct rvu *rvu);
@@ -881,6 +884,8 @@ static inline void rvu_dbg_init(struct rvu *rvu) {}
 static inline void rvu_dbg_exit(struct rvu *rvu) {}
 #endif
 
+int rvu_ndc_fix_locked_cacheline(struct rvu *rvu, int blkaddr);
+
 /* RVU Switch */
 void rvu_switch_enable(struct rvu *rvu);
 void rvu_switch_disable(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index fa280ebd3052..26cfa501f1a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -198,9 +198,6 @@ enum cpt_eng_type {
 	CPT_IE_TYPE = 3,
 };
 
-#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
-						blk_addr, NDC_AF_CONST) & 0xFF)
-
 #define rvu_dbg_NULL NULL
 #define rvu_dbg_open_NULL NULL
 
@@ -1448,6 +1445,7 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 	struct nix_hw *nix_hw;
 	struct rvu *rvu;
 	int bank, max_bank;
+	u64 ndc_af_const;
 
 	if (blk_addr == BLKADDR_NDC_NPA0) {
 		rvu = s->private;
@@ -1456,7 +1454,8 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 		rvu = nix_hw->rvu;
 	}
 
-	max_bank = NDC_MAX_BANK(rvu, blk_addr);
+	ndc_af_const = rvu_read64(rvu, blk_addr, NDC_AF_CONST);
+	max_bank = FIELD_GET(NDC_AF_BANK_MASK, ndc_af_const);
 	for (bank = 0; bank < max_bank; bank++) {
 		seq_printf(s, "BANK:%d\n", bank);
 		seq_printf(s, "\tHits:\t%lld\n",
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6b8747ebc08c..bcce42cd1c24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -790,6 +790,7 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 	struct nix_aq_res_s *result;
 	int timeout = 1000;
 	u64 reg, head;
+	int ret;
 
 	result = (struct nix_aq_res_s *)aq->res->base;
 
@@ -813,9 +814,22 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
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
index 0e0d536645ac..39f7a7cb2755 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -690,6 +690,7 @@
 #define NDC_AF_INTR_ENA_W1S		(0x00068)
 #define NDC_AF_INTR_ENA_W1C		(0x00070)
 #define NDC_AF_ACTIVE_PC		(0x00078)
+#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
 #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
 #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
 #define NDC_AF_BLK_RST			(0x002F0)
@@ -705,6 +706,8 @@
 		(0x00F00 | (a) << 5 | (b) << 4)
 #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
 #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
+#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
+		(0x10000 | (a) << 12 | (b) << 3)
 
 /* LBK */
 #define LBK_CONST			(0x10ull)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e3123723522e..332329cb1ee0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -566,7 +566,8 @@ static int mtk_mac_finish(struct phylink_config *config, unsigned int mode,
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
 	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
-		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK |
+		   MAC_MCR_RX_FIFO_CLR_DIS;
 
 	/* Only update control register when needed! */
 	if (mcr_new != mcr_cur)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2d9186d32bc0..b481d0d46bb1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -383,6 +383,7 @@
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
 #define MAC_MCR_RX_EN		BIT(13)
+#define MAC_MCR_RX_FIFO_CLR_DIS	BIT(12)
 #define MAC_MCR_BACKOFF_EN	BIT(9)
 #define MAC_MCR_BACKPR_EN	BIT(8)
 #define MAC_MCR_FORCE_RX_FC	BIT(5)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
index a9aec900d608..7d66fe75cd3b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
@@ -194,7 +194,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
 		return -EINVAL;
 	}
 
-	err = lan966x_police_del(port, port->tc.police_id);
+	err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to add policer to port");
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 861082c5dbff..ee2e442809c6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -327,14 +327,15 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Do not reorder - tso may adjust pkt cnt, vlan may override fields */
 	nfp_nfd3_tx_tso(r_vec, txbuf, txd, skb, md_bytes);
-	nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
+	else
+		nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
 	if (skb_vlan_tag_present(skb) && dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN) {
 		txd->flags |= NFD3_DESC_TX_VLAN;
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
-	if (ipsec)
-		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
index e90f8c975903..51087693072c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -10,9 +10,30 @@
 void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	int l4_proto;
 
 	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
-		txd->flags |= NFD3_DESC_TX_CSUM | NFD3_DESC_TX_IP4_CSUM |
-			      NFD3_DESC_TX_TCP_CSUM | NFD3_DESC_TX_UDP_CSUM;
+		txd->flags |= NFD3_DESC_TX_CSUM;
+
+		if (iph->version == 4)
+			txd->flags |= NFD3_DESC_TX_IP4_CSUM;
+
+		if (x->props.mode == XFRM_MODE_TRANSPORT)
+			l4_proto = xo->proto;
+		else if (x->props.mode == XFRM_MODE_TUNNEL)
+			l4_proto = xo->inner_ipproto;
+		else
+			return;
+
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			txd->flags |= NFD3_DESC_TX_UDP_CSUM;
+			return;
+		case IPPROTO_TCP:
+			txd->flags |= NFD3_DESC_TX_TCP_CSUM;
+			return;
+		}
 	}
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 70d7484c82af..1182fa48a3b5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -38,6 +38,7 @@
 #include <net/tls.h>
 #include <net/vxlan.h>
 #include <net/xdp_sock_drv.h>
+#include <net/xfrm.h>
 
 #include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nsp.h"
@@ -1897,6 +1898,9 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 			features &= ~NETIF_F_GSO_MASK;
 	}
 
+	if (xfrm_offload(skb))
+		return features;
+
 	/* VXLAN/GRE check */
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..01f7e19a2ca8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1170,6 +1170,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index ccecee2524ce..0b88635f4fbc 100644
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
 	.phy_id		= 0x0007c132,
@@ -359,6 +390,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
+	.link_change_notify = lan88xx_link_change_notify,
 
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 607aa786c8cb..cd246615b0f9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3053,8 +3053,6 @@ static int phy_probe(struct device *dev)
 	if (phydrv->flags & PHY_IS_INTERNAL)
 		phydev->is_internal = true;
 
-	mutex_lock(&phydev->lock);
-
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -3122,12 +3120,10 @@ static int phy_probe(struct device *dev)
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
 
@@ -3137,9 +3133,7 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
-	mutex_lock(&phydev->lock);
 	phydev->state = PHY_DOWN;
-	mutex_unlock(&phydev->lock);
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ac7481ce2fc1..00d9eff91dcf 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,7 +44,6 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
-	u16 intmask;
 	bool energy_enable;
 };
 
@@ -57,7 +56,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -65,14 +63,9 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		priv->intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
-		if (priv->energy_enable)
-			priv->intmask |= MII_LAN83C185_ISF_INT7;
-
-		rc = phy_write(phydev, MII_LAN83C185_IM, priv->intmask);
+		rc = phy_write(phydev, MII_LAN83C185_IM,
+			       MII_LAN83C185_ISF_INT_PHYLIB_EVENTS);
 	} else {
-		priv->intmask = 0;
-
 		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
@@ -85,7 +78,6 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
@@ -96,7 +88,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & priv->intmask))
+	if (!(irq_status & MII_LAN83C185_ISF_INT_PHYLIB_EVENTS))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db..068488890d57 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2115,33 +2115,8 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
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
index 2d53e0f88d2f..1e0f2297f9c6 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -260,6 +263,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellanox/Kconfig
index 09c7829e95c4..382793e73a60 100644
--- a/drivers/platform/mellanox/Kconfig
+++ b/drivers/platform/mellanox/Kconfig
@@ -16,17 +16,17 @@ if MELLANOX_PLATFORM
 
 config MLXREG_HOTPLUG
 	tristate "Mellanox platform hotplug driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
+	select REGMAP
 	help
 	  This driver handles hot-plug events for the power suppliers, power
 	  cables and fans on the wide range Mellanox IB and Ethernet systems.
 
 config MLXREG_IO
 	tristate "Mellanox platform register access driver support"
-	depends on REGMAP
 	depends on HWMON
+	select REGMAP
 	help
 	  This driver allows access to Mellanox programmable device register
 	  space through sysfs interface. The sets of registers for sysfs access
@@ -36,9 +36,9 @@ config MLXREG_IO
 
 config MLXREG_LC
 	tristate "Mellanox line card platform driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
+	select REGMAP
 	help
 	  This driver provides support for the Mellanox MSN4800-XX line cards,
 	  which are the part of MSN4800 Ethernet modular switch systems
@@ -80,10 +80,9 @@ config MLXBF_PMC
 
 config NVSW_SN2201
 	tristate "Nvidia SN2201 platform driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
-	depends on REGMAP_I2C
+	select REGMAP_I2C
 	help
 	  This driver provides support for the Nvidia SN2201 platform.
 	  The SN2201 is a highly integrated for one rack unit system with
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5692385e2d26..1396a839dd8a 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -956,7 +956,8 @@ config SERIAL_MULTI_INSTANTIATE
 
 config MLX_PLATFORM
 	tristate "Mellanox Technologies platform support"
-	depends on I2C && REGMAP
+	depends on I2C
+	select REGMAP
 	help
 	  This option enables system support for the Mellanox Technologies
 	  platform. The Mellanox systems provide data center networking
diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index 9cb6ae42dbdc..96fede24877f 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -11,9 +11,9 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dev_printk.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
-#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/limits.h>
 #include <linux/power_supply.h>
@@ -125,21 +125,27 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 	if (ret < 0)
 		return ret;
 
-	if (obj->package.count != 2)
-		goto err_free;
+	if (obj->package.count != 2 ||
+	    obj->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[1].type != ACPI_TYPE_BUFFER) {
+		ret = -ENOMSG;
 
-	if (obj->package.elements[0].type != ACPI_TYPE_INTEGER)
 		goto err_free;
+	}
 
 	buffer_size = obj->package.elements[0].integer.value;
 
-	if (obj->package.elements[1].type != ACPI_TYPE_BUFFER)
+	if (!buffer_size) {
+		ret = -ENODATA;
+
 		goto err_free;
+	}
 
 	if (buffer_size > obj->package.elements[1].buffer.length) {
 		dev_warn(&wdev->dev,
 			 FW_WARN "WMI buffer size (%llu) exceeds ACPI buffer size (%d)\n",
 			 buffer_size, obj->package.elements[1].buffer.length);
+		ret = -EMSGSIZE;
 
 		goto err_free;
 	}
@@ -151,7 +157,7 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 err_free:
 	kfree(obj);
 
-	return -EIO;
+	return ret;
 }
 
 static int dell_wmi_ddv_query_string(struct wmi_device *wdev, enum dell_ddv_method method,
@@ -185,7 +191,8 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *attr, char
 	if (ret < 0)
 		return ret;
 
-	return sysfs_emit(buf, "%d\n", DIV_ROUND_CLOSEST(value, 10));
+	/* Use 2731 instead of 2731.5 to avoid unnecessary rounding */
+	return sysfs_emit(buf, "%d\n", value - 2731);
 }
 
 static ssize_t eppid_show(struct device *dev, struct device_attribute *attr, char *buf)
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 12346e2297fd..8e34bbf44d1f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -181,6 +181,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	scsi_proc_hostdir_rm(shost->hostt);
 
 	/*
 	 * New SCSI devices cannot be attached anymore because of the SCSI host
@@ -340,6 +341,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4919ea54b827..2ef9d41fc6f4 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1519,6 +1519,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 
+#define MEGASAS_MAX_SUPPORTED_LD_IDS		240
+
 #define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index da1cad1ee123..4463a538102a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -358,7 +358,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 		ld = MR_TargetIdToLdGet(i, drv_map);
 
 		/* For non existing VDs, iterate to next VD*/
-		if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
+		if (ld >= MEGASAS_MAX_SUPPORTED_LD_IDS)
 			continue;
 
 		raid = MR_LdRaidGet(ld, drv_map);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..797d02a6613a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2974,8 +2974,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	}
 
 	if (sdkp->device->type == TYPE_ZBC) {
-		/* Host-managed */
+		/*
+		 * Host-managed: Per ZBC and ZAC specifications, writes in
+		 * sequential write required zones of host-managed devices must
+		 * be aligned to the device physical block size.
+		 */
 		disk_set_zoned(sdkp->disk, BLK_ZONED_HM);
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 	} else {
 		sdkp->zoned = zoned;
 		if (sdkp->zoned == 1) {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 62abebbaf2e7..d33da6e1910f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -963,14 +963,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	disk_set_max_active_zones(disk, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
-	/*
-	 * Per ZBC and ZAC specifications, writes in sequential write required
-	 * zones of host-managed devices must be aligned to the device physical
-	 * block size.
-	 */
-	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
-		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
-
 	sdkp->early_zone_info.nr_zones = nr_zones;
 	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
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
index 54004f846cf0..84a9f4dd8f95 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -350,7 +350,7 @@ int rtw_cfg80211_check_bss(struct adapter *padapter)
 	bss = cfg80211_get_bss(padapter->rtw_wdev->wiphy, notify_channel,
 			pnetwork->mac_address, pnetwork->ssid.ssid,
 			pnetwork->ssid.ssid_length,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	cfg80211_put_bss(padapter->rtw_wdev->wiphy, bss);
 
@@ -711,6 +711,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len;
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -724,26 +725,29 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 		goto exit;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		if (param->u.crypt.idx >= WEP_KEYS
-			|| param->u.crypt.idx >= BIP_MAX_KEYID) {
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
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
+		if (wep_key_len <= 0) {
 			ret = -EINVAL;
 			goto exit;
 		}
@@ -1135,8 +1139,8 @@ void rtw_cfg80211_unlink_bss(struct adapter *padapter, struct wlan_network *pnet
 
 	bss = cfg80211_get_bss(wiphy, NULL/*notify_channel*/,
 		select_network->mac_address, select_network->ssid.ssid,
-		select_network->ssid.ssid_length, 0/*WLAN_CAPABILITY_ESS*/,
-		0/*WLAN_CAPABILITY_ESS*/);
+		select_network->ssid.ssid_length, IEEE80211_BSS_TYPE_ANY,
+		IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		cfg80211_unlink_bss(wiphy, bss);
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 30374a820496..40a3157fb735 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -46,6 +46,7 @@ static int wpa_set_auth_algs(struct net_device *dev, u32 value)
 static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len, wep_total_len;
 	struct ndis_802_11_wep	 *pwep = NULL;
 	struct adapter *padapter = rtw_netdev_priv(dev);
@@ -60,19 +61,22 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
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
@@ -84,9 +88,6 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if (wep_key_idx > WEP_KEYS)
-			return -EINVAL;
-
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index bf1b1cdfade4..acc11ad56975 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -194,7 +194,6 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, _temp);
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 1);
 
-	thermal_zone_device_enable(tzd);
 	pci_info->stored_thres = temp;
 
 	return 0;
@@ -277,6 +276,10 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 		goto err_free_vectors;
 	}
 
+	ret = thermal_zone_device_enable(pci_info->tzone);
+	if (ret)
+		goto err_free_vectors;
+
 	return 0;
 
 err_free_vectors:
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 8affc88b0e0a..e775d68834ea 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -72,7 +72,7 @@ static void btrfs_log_dev_io_error(struct bio *bio, struct btrfs_device *dev)
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-	if (!(bio->bi_opf & REQ_RAHEAD))
+	else if (!(bio->bi_opf & REQ_RAHEAD))
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 	if (bio->bi_opf & REQ_PREFLUSH)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_FLUSH_ERRS);
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 708d843daa72..d628d545ffea 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1687,7 +1687,8 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 
 		btrfs_info(fs_info,
 			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
-				bg->start, div_u64(bg->used * 100, bg->length),
+				bg->start,
+				div64_u64(bg->used * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
@@ -2349,18 +2350,29 @@ static int insert_block_group_item(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_item bgi;
 	struct btrfs_root *root = btrfs_block_group_root(fs_info);
 	struct btrfs_key key;
+	u64 old_commit_used;
+	int ret;
 
 	spin_lock(&block_group->lock);
 	btrfs_set_stack_block_group_used(&bgi, block_group->used);
 	btrfs_set_stack_block_group_chunk_objectid(&bgi,
 						   block_group->global_root_id);
 	btrfs_set_stack_block_group_flags(&bgi, block_group->flags);
+	old_commit_used = block_group->commit_used;
+	block_group->commit_used = block_group->used;
 	key.objectid = block_group->start;
 	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	key.offset = block_group->length;
 	spin_unlock(&block_group->lock);
 
-	return btrfs_insert_item(trans, root, &key, &bgi, sizeof(bgi));
+	ret = btrfs_insert_item(trans, root, &key, &bgi, sizeof(bgi));
+	if (ret < 0) {
+		spin_lock(&block_group->lock);
+		block_group->commit_used = old_commit_used;
+		spin_unlock(&block_group->lock);
+	}
+
+	return ret;
 }
 
 static int insert_dev_extent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index be94030e1dfb..138afa955370 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -763,7 +763,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
+		flags = em->flags;
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+		/*
+		 * In case we split the extent map, we want to preserve the
+		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
+		 * it on the new extent maps.
+		 */
 		clear_bit(EXTENT_FLAG_LOGGING, &flags);
 		modified = !list_empty(&em->list);
 
@@ -774,7 +780,6 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 		if (em->start >= start && em_end <= end)
 			goto remove_em;
 
-		flags = em->flags;
 		gen = em->generation;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 091fd5adf818..5cd612a8f858 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -278,7 +278,7 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 		}
 	}
 	if (no < nrpages_out && strm->buf.out)
-		kunmap(rq->in[no]);
+		kunmap(rq->out[no]);
 	if (ni < nrpages_in)
 		kunmap(rq->in[ni]);
 	/* 4. push back LZMA stream context to the global list */
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 5200bb86e264..ccf7c55d477f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1032,12 +1032,12 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 
 	if (!be->decompressed_pages)
 		be->decompressed_pages =
-			kcalloc(be->nr_pages, sizeof(struct page *),
-				GFP_KERNEL | __GFP_NOFAIL);
+			kvcalloc(be->nr_pages, sizeof(struct page *),
+				 GFP_KERNEL | __GFP_NOFAIL);
 	if (!be->compressed_pages)
 		be->compressed_pages =
-			kcalloc(pclusterpages, sizeof(struct page *),
-				GFP_KERNEL | __GFP_NOFAIL);
+			kvcalloc(pclusterpages, sizeof(struct page *),
+				 GFP_KERNEL | __GFP_NOFAIL);
 
 	z_erofs_parse_out_bvecs(be);
 	err2 = z_erofs_parse_in_bvecs(be, &overlapped);
@@ -1085,7 +1085,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 	if (be->compressed_pages < be->onstack_pages ||
 	    be->compressed_pages >= be->onstack_pages + Z_EROFS_ONSTACK_PAGES)
-		kfree(be->compressed_pages);
+		kvfree(be->compressed_pages);
 	z_erofs_fill_other_copies(be, err);
 
 	for (i = 0; i < be->nr_pages; ++i) {
@@ -1104,7 +1104,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 
 	if (be->decompressed_pages != be->onstack_pages)
-		kfree(be->decompressed_pages);
+		kvfree(be->decompressed_pages);
 
 	pcl->length = 0;
 	pcl->partial = true;
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
index 2b42ececa46d..1602d74b5eeb 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -159,7 +159,6 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9d9f414f99fe..96517785a9f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4797,8 +4797,13 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 
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
index 8067ccda34e4..8c2b1ff5e695 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -434,6 +434,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index dd28453d6ea3..7cc3918e2f18 100644
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
@@ -3646,7 +3645,8 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3813,9 +3813,20 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
@@ -3873,8 +3884,10 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
@@ -4010,6 +4023,11 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
index beaec6d81074..1e4db96a04e6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -409,7 +409,8 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -421,10 +422,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 	}
 	if (io->io_bio == NULL)
 		io_submit_init_bio(io, bh);
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -561,8 +563,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 	} while ((bh = bh->b_this_page) != head);
 unlock:
 	unlock_page(page);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0c6b011a91b3..494994d9a332 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2807,6 +2807,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 
+	if (ext4_has_inline_data(inode))
+		error = ext4_find_inline_data_nolock(inode);
+
 cleanup:
 	if (error && (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count))) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
diff --git a/fs/file.c b/fs/file.c
index c942c89ca4cd..7893ea161d77 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -642,6 +642,7 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
 	if (fd >= fdt->max_fds)
 		return NULL;
 
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (file) {
 		rcu_assign_pointer(fdt->fd[fd], NULL);
diff --git a/fs/locks.c b/fs/locks.c
index 8f01bee17715..8a881cda3dd2 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1862,9 +1862,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4c3a0d84043c..bb1e85586dfd 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1100,7 +1100,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
 		nfsd_copy_write_verifier(verf, nn);
+	file_start_write(file);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
+	file_end_write(file);
 	if (host_err < 0) {
 		nfsd_reset_write_verifier(nn);
 		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a1af2c2e1c29..7faa0a5af026 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -438,7 +438,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)block) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 48563dc09e17..0a1ccc68e798 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -827,6 +827,7 @@ struct hid_driver {
  * @output_report: send output report to device
  * @idle: send idle request to device
  * @may_wakeup: return if device may act as a wakeup source during system-suspend
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -852,6 +853,8 @@ struct hid_ll_driver {
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 	bool (*may_wakeup)(struct hid_device *hdev);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
diff --git a/include/linux/mhi_ep.h b/include/linux/mhi_ep.h
index 478aece17046..f198a8ac7ee7 100644
--- a/include/linux/mhi_ep.h
+++ b/include/linux/mhi_ep.h
@@ -70,8 +70,8 @@ struct mhi_ep_db_info {
  * @cmd_ctx_cache_phys: Physical address of the host command context cache
  * @chdb: Array of channel doorbell interrupt info
  * @event_lock: Lock for protecting event rings
- * @list_lock: Lock for protecting state transition and channel doorbell lists
  * @state_lock: Lock for protecting state transitions
+ * @list_lock: Lock for protecting state transition and channel doorbell lists
  * @st_transition_list: List of state transitions
  * @ch_db_list: List of queued channel doorbells
  * @wq: Dedicated workqueue for handling rings and state changes
@@ -117,8 +117,8 @@ struct mhi_ep_cntrl {
 
 	struct mhi_ep_db_info chdb[4];
 	struct mutex event_lock;
+	struct mutex state_lock;
 	spinlock_t list_lock;
-	spinlock_t state_lock;
 
 	struct list_head st_transition_list;
 	struct list_head ch_db_list;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index bc8f484cdcf3..45c3d62e616d 100644
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
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..2e4c483075d3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,7 +108,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
-	if (!req->file->f_op->uring_cmd)
+	if (!file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
 	ret = security_uring_cmd(ioucmd);
@@ -120,6 +120,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!file->f_op->uring_cmd_iopoll)
+			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 530e200fbc47..9880faa7e676 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4476,6 +4476,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
 	struct btf *btf = env->btf;
 	u16 i;
 
+	env->resolve_mode = RESOLVE_TBD;
 	for_each_vsi_from(i, v->next_member, v->t, vsi) {
 		u32 var_type_id = vsi->type, type_id, type_size = 0;
 		const struct btf_type *var_type = btf_type_by_id(env->btf,
diff --git a/kernel/fork.c b/kernel/fork.c
index 9f7fe3541897..8dd0127ddcb8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2933,7 +2933,7 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index a6f9bdd956c3..f10f403104e7 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -273,6 +273,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	if (ret < 0)
 		goto error;
 
+	ret = -ENOMEM;
 	pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
 	if (!pages)
 		goto error;
diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index ebc202ffdd8d..bf61ea4b8132 100644
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
diff --git a/net/core/sock.c b/net/core/sock.c
index 63680f999bf6..9796a5fa6cea 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2827,7 +2827,8 @@ static void sk_enter_memory_pressure(struct sock *sk)
 static void sk_leave_memory_pressure(struct sock *sk)
 {
 	if (sk->sk_prot->leave_memory_pressure) {
-		sk->sk_prot->leave_memory_pressure(sk);
+		INDIRECT_CALL_INET_1(sk->sk_prot->leave_memory_pressure,
+				     tcp_leave_memory_pressure, sk);
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index b22b2c745c76..69e331799604 100644
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
index cf26d65ca389..ebf917511937 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -186,6 +186,9 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
@@ -244,6 +247,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index e5dc91d0e079..0735d820e413 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -68,6 +68,9 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return sk_udp_recvmsg(sk, msg, len, flags, addr_len);
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 47447f0241df..bee45dfeb187 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -477,6 +477,7 @@ int ila_xlat_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 929502e51203..52f828bb5a83 100644
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
index ead11a9c261f..19e3afb23fda 100644
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
index 733bb56950c1..d095d3c1ceca 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,11 +328,12 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -343,7 +344,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 #else
-#define ctnetlink_dump_mark(a, b) (0)
+#define ctnetlink_dump_mark(a, b, c) (0)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -548,7 +549,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct, true) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -831,8 +832,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2735,7 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, true) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 7f2bda6641bd..8e6d7eaf9dc8 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -105,11 +105,15 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
 static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_last_priv *priv_src = nft_expr_priv(src);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
 	if (!priv_dst->last)
 		return -ENOMEM;
 
+	priv_dst->last->set = priv_src->last->set;
+	priv_dst->last->jiffies = priv_src->last->jiffies;
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 123578e28917..3ba12a7471b0 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -236,12 +236,16 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
+	struct nft_quota *priv_src = nft_expr_priv(src);
+
+	priv_dst->quota = priv_src->quota;
+	priv_dst->flags = priv_src->flags;
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-	atomic64_set(priv_dst->consumed, 0);
+	*priv_dst->consumed = *priv_src->consumed;
 
 	return 0;
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 348bf561bc9f..b9264e730fd9 100644
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
index d9413d43b104..e8018b0fb767 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2644,16 +2644,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
@@ -2662,6 +2660,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
index f06622814a95..7f9807374b0f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -786,6 +786,7 @@ svc_start_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 static int
 svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
+	struct svc_rqst	*rqstp;
 	struct task_struct *task;
 	unsigned int state = serv->sv_nrthreads-1;
 
@@ -794,7 +795,10 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
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
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..a7cc4f9faac2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,8 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+
+			iter_offset.offset += copy;
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905d..b32c112984dd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -405,13 +405,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -429,13 +427,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -451,13 +447,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(aes_ccm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_CCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_CCM_128_IV_SIZE);
 		memcpy(aes_ccm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, aes_ccm_128, sizeof(*aes_ccm_128)))
 			rc = -EFAULT;
 		break;
@@ -472,13 +466,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(chacha20_poly1305->iv,
 		       cctx->iv + TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE,
 		       TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE);
 		memcpy(chacha20_poly1305->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, chacha20_poly1305,
 				sizeof(*chacha20_poly1305)))
 			rc = -EFAULT;
@@ -493,13 +485,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_gcm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_GCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_GCM_IV_SIZE);
 		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
 			rc = -EFAULT;
 		break;
@@ -513,13 +503,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_ccm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_CCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_CCM_IV_SIZE);
 		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_ccm_info, sizeof(*sm4_ccm_info)))
 			rc = -EFAULT;
 		break;
@@ -535,13 +523,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_128,
 				 sizeof(*crypto_info_aria_gcm_128)))
@@ -559,13 +545,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_256,
 				 sizeof(*crypto_info_aria_gcm_256)))
@@ -614,11 +598,9 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 	if (len < sizeof(value))
 		return -EINVAL;
 
-	lock_sock(sk);
 	value = -EINVAL;
 	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
 		value = ctx->rx_no_pad;
-	release_sock(sk);
 	if (value < 0)
 		return value;
 
@@ -635,6 +617,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 	case TLS_RX:
@@ -651,6 +635,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38dcd9b40102..992092aeebad 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2114,7 +2114,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted = max(err, 0);
+		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0c2293f1d3b..7d17601ceee7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2104,7 +2104,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
+static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other,
+		     struct scm_cookie *scm, bool fds_sent)
 {
 	struct unix_sock *ousk = unix_sk(other);
 	struct sk_buff *skb;
@@ -2115,6 +2116,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (!skb)
 		return err;
 
+	err = unix_scm_to_skb(scm, skb, !fds_sent);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
 	skb_put(skb, 1);
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
@@ -2242,7 +2248,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
-		err = queue_oob(sock, msg, other);
+		err = queue_oob(sock, msg, other, &scm, fds_sent);
 		if (err)
 			goto out_err;
 		sent++;
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index e9bf15513961..2f9d8271c6ec 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -54,6 +54,9 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
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
index 56f2ec8f0f40..3266708a8658 100755
--- a/scripts/clang-tools/run-clang-tools.py
+++ b/scripts/clang-tools/run-clang-tools.py
@@ -61,14 +61,21 @@ def run_analysis(entry):
 
 
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
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f8182417b734..10bb1d494258 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -538,6 +538,7 @@ static int perf_event__repipe_buildid_mmap2(struct perf_tool *tool,
 			dso->hit = 1;
 		}
 		dso__put(dso);
+		perf_event__repipe(tool, event, sample, machine);
 		return 0;
 	}
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9f3e4b257516..387dc9c9e7be 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -539,12 +539,7 @@ static int enable_counters(void)
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
@@ -914,7 +909,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			return err;
 	}
 
-	if (stat_config.initial_delay) {
+	if (target.initial_delay) {
 		pr_info(EVLIST_DISABLED_MSG);
 	} else {
 		err = enable_counters();
@@ -926,8 +921,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__start_workload(evsel_list);
 
-	if (stat_config.initial_delay > 0) {
-		usleep(stat_config.initial_delay * USEC_PER_MSEC);
+	if (target.initial_delay > 0) {
+		usleep(target.initial_delay * USEC_PER_MSEC);
 		err = enable_counters();
 		if (err)
 			return -1;
@@ -1248,7 +1243,7 @@ static struct option stat_options[] = {
 		     "aggregate counts per thread", AGGR_THREAD),
 	OPT_SET_UINT(0, "per-node", &stat_config.aggr_mode,
 		     "aggregate counts per numa node", AGGR_NODE),
-	OPT_INTEGER('D', "delay", &stat_config.initial_delay,
+	OPT_INTEGER('D', "delay", &target.initial_delay,
 		    "ms to wait before starting measurement after program start (-1: start with events disabled)"),
 	OPT_CALLBACK_NOOPT(0, "metric-only", &stat_config.metric_only, NULL,
 			"Only print computed metrics. No raw values", enable_metric_only),
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 534d36d26fc3..a07473703c6d 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -842,11 +842,7 @@ int create_perf_stat_counter(struct evsel *evsel,
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
index 499c3bf81333..eb8cf33c3ba5 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -166,7 +166,6 @@ struct perf_stat_config {
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
index 924ecb3f1f73..dd40d9f6f259 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
