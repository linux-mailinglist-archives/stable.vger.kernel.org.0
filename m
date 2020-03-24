Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D374190ECD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCXNPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbgCXNPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:15:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC292098B;
        Tue, 24 Mar 2020 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055704;
        bh=meHnnBCuyYEqHQYVhs4u70A2FamSE6CiF7YMomAbuDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r65deP4N5I/LwZywJycWDLKkgIHVRHMNFvn7KPmGZQ8IJdGd6Mp0TCU+oFWa1UYMS
         3HTTEAS8+z6I7bkomLl3LG8Si4zJ9vQbUfUgwHIEXjUqMAtHRzynJqleJUQSWp8+Jm
         VFt0zzFIjmJq2C2sYmU2C/dOEbp+eV3hqqUpbIKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Joerg Roedel <jroedel@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 51/65] x86/mm: split vmalloc_sync_all()
Date:   Tue, 24 Mar 2020 14:11:12 +0100
Message-Id: <20200324130803.309144605@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 763802b53a427ed3cbd419dbba255c414fdd9e7c upstream.

Commit 3f8fd02b1bf1 ("mm/vmalloc: Sync unmappings in
__purge_vmap_area_lazy()") introduced a call to vmalloc_sync_all() in
the vunmap() code-path.  While this change was necessary to maintain
correctness on x86-32-pae kernels, it also adds additional cycles for
architectures that don't need it.

Specifically on x86-64 with CONFIG_VMAP_STACK=y some people reported
severe performance regressions in micro-benchmarks because it now also
calls the x86-64 implementation of vmalloc_sync_all() on vunmap().  But
the vmalloc_sync_all() implementation on x86-64 is only needed for newly
created mappings.

To avoid the unnecessary work on x86-64 and to gain the performance
back, split up vmalloc_sync_all() into two functions:

	* vmalloc_sync_mappings(), and
	* vmalloc_sync_unmappings()

Most call-sites to vmalloc_sync_all() only care about new mappings being
synchronized.  The only exception is the new call-site added in the
above mentioned commit.

Shile Zhang directed us to a report of an 80% regression in reaim
throughput.

Fixes: 3f8fd02b1bf1 ("mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Borislav Petkov <bp@suse.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[GHES]
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20191009124418.8286-1-joro@8bytes.org
Link: https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/4D3JPPHBNOSPFK2KEPC6KGKS6J25AIDB/
Link: http://lkml.kernel.org/r/20191113095530.228959-1-shile.zhang@linux.alibaba.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/fault.c      |   26 ++++++++++++++++++++++++--
 drivers/acpi/apei/ghes.c |    2 +-
 include/linux/vmalloc.h  |    5 +++--
 kernel/notifier.c        |    2 +-
 mm/nommu.c               |   10 +++++++---
 mm/vmalloc.c             |   11 +++++++----
 6 files changed, 43 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -273,7 +273,7 @@ static inline pmd_t *vmalloc_sync_one(pg
 	return pmd_k;
 }
 
-void vmalloc_sync_all(void)
+static void vmalloc_sync(void)
 {
 	unsigned long address;
 
@@ -300,6 +300,16 @@ void vmalloc_sync_all(void)
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
@@ -402,11 +412,23 @@ out:
 
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
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -201,7 +201,7 @@ static int ghes_estatus_pool_expand(unsi
 	 * New allocation must be visible in all pgd before it can be found by
 	 * an NMI allocating from the pool.
 	 */
-	vmalloc_sync_all();
+	vmalloc_sync_mappings();
 
 	return gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
 }
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -107,8 +107,9 @@ extern int remap_vmalloc_range_partial(s
 
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
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -552,7 +552,7 @@ NOKPROBE_SYMBOL(notify_die);
 
 int register_die_notifier(struct notifier_block *nb)
 {
-	vmalloc_sync_all();
+	vmalloc_sync_mappings();
 	return atomic_notifier_chain_register(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(register_die_notifier);
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -446,10 +446,14 @@ void vm_unmap_aliases(void)
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
 
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1755,7 +1755,7 @@ void *__vmalloc_node_range(unsigned long
 	 * First make sure the mappings are removed from all page-tables
 	 * before they are freed.
 	 */
-	vmalloc_sync_all();
+	vmalloc_sync_unmappings();
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -2300,16 +2300,19 @@ int remap_vmalloc_range(struct vm_area_s
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
 
 static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
 {


