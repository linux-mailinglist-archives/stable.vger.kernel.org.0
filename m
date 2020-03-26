Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC0C19465D
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgCZSQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 14:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgCZSQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA0220719;
        Thu, 26 Mar 2020 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585246580;
        bh=pPILWVK+pyudu1mzrQqYCDcuV0FktwK+ReqM8lqSvcM=;
        h=Date:From:To:Subject:From;
        b=cOhQb+7l5fnL4rXEUBkEBamRt2jvDpRPhaNAcBL8dsLcj+Cp8wEM7Eoac9dVCAd7g
         BtChQjyos5TFiS4P98oexno4az6P8veUNWTTQAl3DvPmfbFKAx8jz26Ljlx2RuaVVz
         U2WGqXGqa6dkukrtCG4i4XAeYW9M6Om+uwW7vJkw=
Date:   Thu, 26 Mar 2020 11:16:19 -0700
From:   akpm@linux-foundation.org
To:     bp@suse.de, dave.hansen@linux.intel.com, jroedel@suse.de,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, shile.zhang@linux.alibaba.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject:  [merged] x86-mm-split-vmalloc_sync_all.patch removed from
 -mm tree
Message-ID: <20200326181619.BFGn3EQSE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: x86/mm: split vmalloc_sync_all()
has been removed from the -mm tree.  Its filename was
     x86-mm-split-vmalloc_sync_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joerg Roedel <jroedel@suse.de>
Subject: x86/mm: split vmalloc_sync_all()

Commit 3f8fd02b1bf1 ("mm/vmalloc: Sync unmappings in
__purge_vmap_area_lazy()") introduced a call to vmalloc_sync_all() in the
vunmap() code-path.  While this change was necessary to maintain
correctness on x86-32-pae kernels, it also adds additional cycles for
architectures that don't need it.

Specifically on x86-64 with CONFIG_VMAP_STACK=y some people reported
severe performance regressions in micro-benchmarks because it now also
calls the x86-64 implementation of vmalloc_sync_all() on vunmap().  But
the vmalloc_sync_all() implementation on x86-64 is only needed for newly
created mappings.

To avoid the unnecessary work on x86-64 and to gain the performance back,
split up vmalloc_sync_all() into two functions:

	* vmalloc_sync_mappings(), and
	* vmalloc_sync_unmappings()

Most call-sites to vmalloc_sync_all() only care about new mappings being
synchronized.  The only exception is the new call-site added in the above
mentioned commit.

Shile Zhang directed us to a report of an 80% regression in reaim
throughput.

Link: http://lkml.kernel.org/r/20191009124418.8286-1-joro@8bytes.org
Link: https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/4D3JPPHBNOSPFK2KEPC6KGKS6J25AIDB/
Link: http://lkml.kernel.org/r/20191113095530.228959-1-shile.zhang@linux.alibaba.com
Fixes: 3f8fd02b1bf1 ("mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[GHES]
Tested-by: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c      |   26 ++++++++++++++++++++++++--
 drivers/acpi/apei/ghes.c |    2 +-
 include/linux/vmalloc.h  |    5 +++--
 kernel/notifier.c        |    2 +-
 mm/nommu.c               |   10 +++++++---
 mm/vmalloc.c             |   11 +++++++----
 6 files changed, 43 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/fault.c~x86-mm-split-vmalloc_sync_all
+++ a/arch/x86/mm/fault.c
@@ -190,7 +190,7 @@ static inline pmd_t *vmalloc_sync_one(pg
 	return pmd_k;
 }
 
-void vmalloc_sync_all(void)
+static void vmalloc_sync(void)
 {
 	unsigned long address;
 
@@ -217,6 +217,16 @@ void vmalloc_sync_all(void)
 	}
 }
 
+void vmalloc_sync_mappings(void)
+{
+	vmalloc_sync();
+}
+
+void vmalloc_sync_unmappings(void)
+{
+	vmalloc_sync();
+}
+
 /*
  * 32-bit:
  *
@@ -319,11 +329,23 @@ out:
 
 #else /* CONFIG_X86_64: */
 
-void vmalloc_sync_all(void)
+void vmalloc_sync_mappings(void)
 {
+	/*
+	 * 64-bit mappings might allocate new p4d/pud pages
+	 * that need to be propagated to all tasks' PGDs.
+	 */
 	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
 }
 
+void vmalloc_sync_unmappings(void)
+{
+	/*
+	 * Unmappings never allocate or free p4d/pud pages.
+	 * No work is required here.
+	 */
+}
+
 /*
  * 64-bit:
  *
--- a/drivers/acpi/apei/ghes.c~x86-mm-split-vmalloc_sync_all
+++ a/drivers/acpi/apei/ghes.c
@@ -171,7 +171,7 @@ int ghes_estatus_pool_init(int num_ghes)
 	 * New allocation must be visible in all pgd before it can be found by
 	 * an NMI allocating from the pool.
 	 */
-	vmalloc_sync_all();
+	vmalloc_sync_mappings();
 
 	rc = gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
 	if (rc)
--- a/include/linux/vmalloc.h~x86-mm-split-vmalloc_sync_all
+++ a/include/linux/vmalloc.h
@@ -141,8 +141,9 @@ extern int remap_vmalloc_range_partial(s
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
-void vmalloc_sync_all(void);
- 
+void vmalloc_sync_mappings(void);
+void vmalloc_sync_unmappings(void);
+
 /*
  *	Lowlevel-APIs (not for driver use!)
  */
--- a/kernel/notifier.c~x86-mm-split-vmalloc_sync_all
+++ a/kernel/notifier.c
@@ -519,7 +519,7 @@ NOKPROBE_SYMBOL(notify_die);
 
 int register_die_notifier(struct notifier_block *nb)
 {
-	vmalloc_sync_all();
+	vmalloc_sync_mappings();
 	return atomic_notifier_chain_register(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(register_die_notifier);
--- a/mm/nommu.c~x86-mm-split-vmalloc_sync_all
+++ a/mm/nommu.c
@@ -370,10 +370,14 @@ void vm_unmap_aliases(void)
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
 /*
- * Implement a stub for vmalloc_sync_all() if the architecture chose not to
- * have one.
+ * Implement a stub for vmalloc_sync_[un]mapping() if the architecture
+ * chose not to have one.
  */
-void __weak vmalloc_sync_all(void)
+void __weak vmalloc_sync_mappings(void)
+{
+}
+
+void __weak vmalloc_sync_unmappings(void)
 {
 }
 
--- a/mm/vmalloc.c~x86-mm-split-vmalloc_sync_all
+++ a/mm/vmalloc.c
@@ -1295,7 +1295,7 @@ static bool __purge_vmap_area_lazy(unsig
 	 * First make sure the mappings are removed from all page-tables
 	 * before they are freed.
 	 */
-	vmalloc_sync_all();
+	vmalloc_sync_unmappings();
 
 	/*
 	 * TODO: to calculate a flush range without looping.
@@ -3128,16 +3128,19 @@ int remap_vmalloc_range(struct vm_area_s
 EXPORT_SYMBOL(remap_vmalloc_range);
 
 /*
- * Implement a stub for vmalloc_sync_all() if the architecture chose not to
- * have one.
+ * Implement stubs for vmalloc_sync_[un]mappings () if the architecture chose
+ * not to have one.
  *
  * The purpose of this function is to make sure the vmalloc area
  * mappings are identical in all page-tables in the system.
  */
-void __weak vmalloc_sync_all(void)
+void __weak vmalloc_sync_mappings(void)
 {
 }
 
+void __weak vmalloc_sync_unmappings(void)
+{
+}
 
 static int f(pte_t *pte, unsigned long addr, void *data)
 {
_

Patches currently in -mm which might be from jroedel@suse.de are


