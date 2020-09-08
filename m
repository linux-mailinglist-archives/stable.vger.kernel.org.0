Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1A261676
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgIHRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731798AbgIHQTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192562467D;
        Tue,  8 Sep 2020 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579572;
        bh=I9cTnqeq4XYOZc0aAGOQB9vqGDtmD6IQFows4I3ObH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4I3ab262T17yEVUu/iL9tme8yJFCWWJorEcV8BWTrBbSrntglo5RpRprbIw5rX4F
         FJ1q6w2jODyQraRML3tlIVZC9GbwZVxx0PoYgIKkZSw9oys41hx8j0aw7BXcVMCD+t
         mdQOreLB+pFcRQJs/XC7rSI7PY0bJ7qJBHlfpnnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Joerg Roedel <jroedel@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 133/186] x86/mm/32: Bring back vmalloc faulting on x86_32
Date:   Tue,  8 Sep 2020 17:24:35 +0200
Message-Id: <20200908152248.092817366@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4819e15f740ec884a50bdc431d7f1e7638b6f7d9 ]

One can not simply remove vmalloc faulting on x86-32. Upstream

	commit: 7f0a002b5a21 ("x86/mm: remove vmalloc faulting")

removed it on x86 alltogether because previously the
arch_sync_kernel_mappings() interface was introduced. This interface
added synchronization of vmalloc/ioremap page-table updates to all
page-tables in the system at creation time and was thought to make
vmalloc faulting obsolete.

But that assumption was incredibly naive.

It turned out that there is a race window between the time the vmalloc
or ioremap code establishes a mapping and the time it synchronizes
this change to other page-tables in the system.

During this race window another CPU or thread can establish a vmalloc
mapping which uses the same intermediate page-table entries (e.g. PMD
or PUD) and does no synchronization in the end, because it found all
necessary mappings already present in the kernel reference page-table.

But when these intermediate page-table entries are not yet
synchronized, the other CPU or thread will continue with a vmalloc
address that is not yet mapped in the page-table it currently uses,
causing an unhandled page fault and oops like below:

	BUG: unable to handle page fault for address: fe80c000
	#PF: supervisor write access in kernel mode
	#PF: error_code(0x0002) - not-present page
	*pde = 33183067 *pte = a8648163
	Oops: 0002 [#1] SMP
	CPU: 1 PID: 13514 Comm: cve-2017-17053 Tainted: G
	...
	Call Trace:
	 ldt_dup_context+0x66/0x80
	 dup_mm+0x2b3/0x480
	 copy_process+0x133b/0x15c0
	 _do_fork+0x94/0x3e0
	 __ia32_sys_clone+0x67/0x80
	 __do_fast_syscall_32+0x3f/0x70
	 do_fast_syscall_32+0x29/0x60
	 do_SYSENTER_32+0x15/0x20
	 entry_SYSENTER_32+0x9f/0xf2
	EIP: 0xb7eef549

So the arch_sync_kernel_mappings() interface is racy, but removing it
would mean to re-introduce the vmalloc_sync_all() interface, which is
even more awful. Keep arch_sync_kernel_mappings() in place and catch
the race condition in the page-fault handler instead.

Do a partial revert of above commit to get vmalloc faulting on x86-32
back in place.

Fixes: 7f0a002b5a21 ("x86/mm: remove vmalloc faulting")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200902155904.17544-1-joro@8bytes.org
[sl: revert 7f0a002b5a21 instead to restore vmalloc faulting for x86-64]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/switch_to.h |  23 ++++++
 arch/x86/kernel/setup_percpu.c   |   6 +-
 arch/x86/mm/fault.c              | 134 +++++++++++++++++++++++++++++++
 arch/x86/mm/pti.c                |   8 +-
 arch/x86/mm/tlb.c                |  37 +++++++++
 5 files changed, 204 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 9f69cc497f4b6..0e059b73437b4 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -12,6 +12,27 @@ struct task_struct *__switch_to_asm(struct task_struct *prev,
 __visible struct task_struct *__switch_to(struct task_struct *prev,
 					  struct task_struct *next);
 
+/* This runs runs on the previous thread's stack. */
+static inline void prepare_switch_to(struct task_struct *next)
+{
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * If we switch to a stack that has a top-level paging entry
+	 * that is not present in the current mm, the resulting #PF will
+	 * will be promoted to a double-fault and we'll panic.  Probe
+	 * the new stack now so that vmalloc_fault can fix up the page
+	 * tables if needed.  This can only happen if we use a stack
+	 * in vmap space.
+	 *
+	 * We assume that the stack is aligned so that it never spans
+	 * more than one top-level paging entry.
+	 *
+	 * To minimize cache pollution, just follow the stack pointer.
+	 */
+	READ_ONCE(*(unsigned char *)next->thread.sp);
+#endif
+}
+
 asmlinkage void ret_from_fork(void);
 
 /*
@@ -46,6 +67,8 @@ struct fork_frame {
 
 #define switch_to(prev, next, last)					\
 do {									\
+	prepare_switch_to(next);					\
+									\
 	((last) = __switch_to_asm((prev), (next)));			\
 } while (0)
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index fd945ce78554e..e6d7894ad1279 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -287,9 +287,9 @@ void __init setup_per_cpu_areas(void)
 	/*
 	 * Sync back kernel address range again.  We already did this in
 	 * setup_arch(), but percpu data also needs to be available in
-	 * the smpboot asm and arch_sync_kernel_mappings() doesn't sync to
-	 * swapper_pg_dir on 32-bit. The per-cpu mappings need to be available
-	 * there too.
+	 * the smpboot asm.  We can't reliably pick up percpu mappings
+	 * using vmalloc_fault(), because exception dispatch needs
+	 * percpu data.
 	 *
 	 * FIXME: Can the later sync in setup_cpu_entry_areas() replace
 	 * this call?
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 1ead568c01012..370c314b8f44d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -215,6 +215,44 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 	}
 }
 
+/*
+ * 32-bit:
+ *
+ *   Handle a fault on the vmalloc or module mapping area
+ */
+static noinline int vmalloc_fault(unsigned long address)
+{
+	unsigned long pgd_paddr;
+	pmd_t *pmd_k;
+	pte_t *pte_k;
+
+	/* Make sure we are in vmalloc area: */
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
+	/*
+	 * Synchronize this task's top level page-table
+	 * with the 'reference' page table.
+	 *
+	 * Do _not_ use "current" here. We might be inside
+	 * an interrupt in the middle of a task switch..
+	 */
+	pgd_paddr = read_cr3_pa();
+	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
+	if (!pmd_k)
+		return -1;
+
+	if (pmd_large(*pmd_k))
+		return 0;
+
+	pte_k = pte_offset_kernel(pmd_k, address);
+	if (!pte_present(*pte_k))
+		return -1;
+
+	return 0;
+}
+NOKPROBE_SYMBOL(vmalloc_fault);
+
 /*
  * Did it hit the DOS screen memory VA from vm86 mode?
  */
@@ -279,6 +317,79 @@ static void dump_pagetable(unsigned long address)
 
 #else /* CONFIG_X86_64: */
 
+/*
+ * 64-bit:
+ *
+ *   Handle a fault on the vmalloc area
+ */
+static noinline int vmalloc_fault(unsigned long address)
+{
+	pgd_t *pgd, *pgd_k;
+	p4d_t *p4d, *p4d_k;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/* Make sure we are in vmalloc area: */
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
+	/*
+	 * Copy kernel mappings over when needed. This can also
+	 * happen within a race in page table update. In the later
+	 * case just flush:
+	 */
+	pgd = (pgd_t *)__va(read_cr3_pa()) + pgd_index(address);
+	pgd_k = pgd_offset_k(address);
+	if (pgd_none(*pgd_k))
+		return -1;
+
+	if (pgtable_l5_enabled()) {
+		if (pgd_none(*pgd)) {
+			set_pgd(pgd, *pgd_k);
+			arch_flush_lazy_mmu_mode();
+		} else {
+			BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_k));
+		}
+	}
+
+	/* With 4-level paging, copying happens on the p4d level. */
+	p4d = p4d_offset(pgd, address);
+	p4d_k = p4d_offset(pgd_k, address);
+	if (p4d_none(*p4d_k))
+		return -1;
+
+	if (p4d_none(*p4d) && !pgtable_l5_enabled()) {
+		set_p4d(p4d, *p4d_k);
+		arch_flush_lazy_mmu_mode();
+	} else {
+		BUG_ON(p4d_pfn(*p4d) != p4d_pfn(*p4d_k));
+	}
+
+	BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS < 4);
+
+	pud = pud_offset(p4d, address);
+	if (pud_none(*pud))
+		return -1;
+
+	if (pud_large(*pud))
+		return 0;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd))
+		return -1;
+
+	if (pmd_large(*pmd))
+		return 0;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (!pte_present(*pte))
+		return -1;
+
+	return 0;
+}
+NOKPROBE_SYMBOL(vmalloc_fault);
+
 #ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
 KERN_ERR 
@@ -1111,6 +1222,29 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	 */
 	WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
+	/*
+	 * We can fault-in kernel-space virtual memory on-demand. The
+	 * 'reference' page table is init_mm.pgd.
+	 *
+	 * NOTE! We MUST NOT take any locks for this case. We may
+	 * be in an interrupt or a critical region, and should
+	 * only copy the information from the master page table,
+	 * nothing more.
+	 *
+	 * Before doing this on-demand faulting, ensure that the
+	 * fault is not any of the following:
+	 * 1. A fault on a PTE with a reserved bit set.
+	 * 2. A fault caused by a user-mode access.  (Do not demand-
+	 *    fault kernel memory due to user-mode accesses).
+	 * 3. A fault caused by a page-level protection violation.
+	 *    (A demand fault would be on a non-present page which
+	 *     would have X86_PF_PROT==0).
+	 */
+	if (!(hw_error_code & (X86_PF_RSVD | X86_PF_USER | X86_PF_PROT))) {
+		if (vmalloc_fault(address) >= 0)
+			return;
+	}
+
 	/* Was the fault spurious, caused by lazy TLB invalidation? */
 	if (spurious_kernel_fault(hw_error_code, address))
 		return;
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index a8a924b3c3358..0b0d1cdce2e73 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -447,7 +447,13 @@ static void __init pti_clone_user_shared(void)
 		 * the sp1 and sp2 slots.
 		 *
 		 * This is done for all possible CPUs during boot to ensure
-		 * that it's propagated to all mms.
+		 * that it's propagated to all mms.  If we were to add one of
+		 * these mappings during CPU hotplug, we would need to take
+		 * some measure to make sure that every mm that subsequently
+		 * ran on that CPU would have the relevant PGD entry in its
+		 * pagetables.  The usual vmalloc_fault() mechanism would not
+		 * work for page faults taken in entry_SYSCALL_64 before RSP
+		 * is set up.
 		 */
 
 		unsigned long va = (unsigned long)&per_cpu(cpu_tss_rw, cpu);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1a3569b43aa5b..cf81902e6992f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -317,6 +317,34 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	local_irq_restore(flags);
 }
 
+static void sync_current_stack_to_mm(struct mm_struct *mm)
+{
+	unsigned long sp = current_stack_pointer;
+	pgd_t *pgd = pgd_offset(mm, sp);
+
+	if (pgtable_l5_enabled()) {
+		if (unlikely(pgd_none(*pgd))) {
+			pgd_t *pgd_ref = pgd_offset_k(sp);
+
+			set_pgd(pgd, *pgd_ref);
+		}
+	} else {
+		/*
+		 * "pgd" is faked.  The top level entries are "p4d"s, so sync
+		 * the p4d.  This compiles to approximately the same code as
+		 * the 5-level case.
+		 */
+		p4d_t *p4d = p4d_offset(pgd, sp);
+
+		if (unlikely(p4d_none(*p4d))) {
+			pgd_t *pgd_ref = pgd_offset_k(sp);
+			p4d_t *p4d_ref = p4d_offset(pgd_ref, sp);
+
+			set_p4d(p4d, *p4d_ref);
+		}
+	}
+}
+
 static inline unsigned long mm_mangle_tif_spec_ib(struct task_struct *next)
 {
 	unsigned long next_tif = task_thread_info(next)->flags;
@@ -525,6 +553,15 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		 */
 		cond_ibpb(tsk);
 
+		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+			/*
+			 * If our current stack is in vmalloc space and isn't
+			 * mapped in the new pgd, we'll double-fault.  Forcibly
+			 * map it.
+			 */
+			sync_current_stack_to_mm(next);
+		}
+
 		/*
 		 * Stop remote flushes for the previous mm.
 		 * Skip kernel threads; we never send init_mm TLB flushing IPIs,
-- 
2.25.1



