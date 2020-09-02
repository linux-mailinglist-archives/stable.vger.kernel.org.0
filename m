Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B235125B07C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgIBP7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:59:12 -0400
Received: from 8bytes.org ([81.169.241.247]:40548 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726966AbgIBP7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 11:59:10 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 955AB507;
        Wed,  2 Sep 2020 17:59:06 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/mm/32: Bring back vmalloc faulting on x86_32
Date:   Wed,  2 Sep 2020 17:59:04 +0200
Message-Id: <20200902155904.17544-1-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

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
	0-next-20200811 #1
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
	4/01/2014
	EIP: memcpy+0xf/0x20
	Code: 68 d0 7d ee d6 e8 11 1c c7 ff 0f 31 31 c3 59 58 cc cc cc cc cc cc 55 89 e5 57 89 c7 56 89 d6 53 89 cb a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 90 55 89 e5
	EAX: fe80c000 EBX: 00010000 ECX: 00004000 EDX: fbfbd000
	ESI: fbfbd000 EDI: fe80c000 EBP: f11f1e2c ESP: f11f1e20
	DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010216
	CR0: 80050033 CR2: fe80c000 CR3: 314c0000 CR4: 003506d0
	DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
	DR6: ffff4ff0 DR7: 00000400
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

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 7f0a002b5a21 ("x86/mm: remove vmalloc faulting")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/mm/fault.c | 78 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 35f1498e9832..6e3e8a124903 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -190,6 +190,53 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	return pmd_k;
 }
 
+/*
+ *   Handle a fault on the vmalloc or module mapping area
+ *
+ *   This is needed because there is a race condition between the time
+ *   when the vmalloc mapping code updates the PMD to the point in time
+ *   where it synchronizes this update with the other page-tables in the
+ *   system.
+ *
+ *   In this race window another thread/CPU can map an area on the same
+ *   PMD, finds it already present and does not synchronize it with the
+ *   rest of the system yet. As a result v[mz]alloc might return areas
+ *   which are not mapped in every page-table in the system, causing an
+ *   unhandled page-fault when they are accessed.
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
 void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 {
 	unsigned long addr;
@@ -1110,6 +1157,37 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	 */
 	WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
+#ifdef CONFIG_X86_32
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
+	 *
+	 * This is only needed to close a race condition on x86-32 in
+	 * the vmalloc mapping/unmapping code. See the comment above
+	 * vmalloc_fault() for details. On x86-64 the race does not
+	 * exist as the vmalloc mappings don't need to be synchronized
+	 * there.
+	 */
+	if (!(hw_error_code & (X86_PF_RSVD | X86_PF_USER | X86_PF_PROT))) {
+		if (vmalloc_fault(address) >= 0)
+			return;
+	}
+#endif
+
 	/* Was the fault spurious, caused by lazy TLB invalidation? */
 	if (spurious_kernel_fault(hw_error_code, address))
 		return;
-- 
2.28.0

