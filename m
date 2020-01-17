Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73D5140196
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 02:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgAQBxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 20:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgAQBxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 20:53:50 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40D92077C;
        Fri, 17 Jan 2020 01:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579226028;
        bh=MPOApSaaTa8H4Lx0ULPJCD62rHiUqCCO/UISJu8iMS8=;
        h=Date:From:To:Subject:From;
        b=1GIFgmh/OWKI5hsS33ZuqGqCSdiLyjtZu3fhLPvgdBJg2hokvmp8wgHK9xebp8+lV
         gsNNTHTwSQig1GcTs2M3BH2M3sdfAR/FhWJUTiLNV+17u6PQxoDL/7SQ1FWJaChcHs
         w80y0sV6Q1jGcLIEewDRkSSegf4isXdUjAtQrPW4=
Date:   Thu, 16 Jan 2020 17:53:48 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mpe@ellerman.id.au, aneesh.kumar@linux.ibm.com,
        peterz@infradead.org
Subject:  +
 =?us-ascii?Q?mm-mmu=5Fgather-invalidate-tlb-correctly-on-batch-allocation?=
 =?us-ascii?Q?-failure-and-flush.patch?= added to -mm tree
Message-ID: <20200117015348.GVbtH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
has been added to the -mm tree.  Its filename is
     mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush

Architectures for which we have hardware walkers of Linux page table
should flush TLB on mmu gather batch allocation failures and batch flush. 
Some architectures like POWER supports multiple translation modes (hash
and radix) and in the case of POWER only radix translation mode needs the
above TLBI.  This is because for hash translation mode kernel wants to
avoid this extra flush since there are no hardware walkers of linux page
table.  With radix translation, the hardware also walks linux page table
and with that, kernel needs to make sure to TLB invalidate page walk cache
before page table pages are freed.

More details in commit d86564a2f085 ("mm/tlb, x86/mm: Support invalidating
TLB caches for RCU_TABLE_FREE")

The changes to sparc are to make sure we keep the old behavior since we
are now removing HAVE_RCU_TABLE_NO_INVALIDATE.  The default value for
tlb_needs_table_invalidate is to always force an invalidate and sparc can
avoid the table invalidate.  Hence we define tlb_needs_table_invalidate to
false for sparc architecture.

Link: http://lkml.kernel.org/r/20200116064531.483522-3-aneesh.kumar@linux.ibm.com
Fixes: a46cc7a90fd8 ("powerpc/mm/radix: Improve TLB/PWC flushes")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                    |    3 ---
 arch/powerpc/Kconfig            |    1 -
 arch/powerpc/include/asm/tlb.h  |   11 +++++++++++
 arch/sparc/Kconfig              |    1 -
 arch/sparc/include/asm/tlb_64.h |    9 +++++++++
 include/asm-generic/tlb.h       |   22 +++++++++++++++-------
 mm/mmu_gather.c                 |   16 ++++++++--------
 7 files changed, 43 insertions(+), 20 deletions(-)

--- a/arch/Kconfig~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/arch/Kconfig
@@ -396,9 +396,6 @@ config HAVE_ARCH_JUMP_LABEL_RELATIVE
 config HAVE_RCU_TABLE_FREE
 	bool
 
-config HAVE_RCU_TABLE_NO_INVALIDATE
-	bool
-
 config HAVE_MMU_GATHER_PAGE_SIZE
 	bool
 
--- a/arch/powerpc/include/asm/tlb.h~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/arch/powerpc/include/asm/tlb.h
@@ -26,6 +26,17 @@
 
 #define tlb_flush tlb_flush
 extern void tlb_flush(struct mmu_gather *tlb);
+/*
+ * book3s:
+ * Hash does not use the linux page-tables, so we can avoid
+ * the TLB invalidate for page-table freeing, Radix otoh does use the
+ * page-tables and needs the TLBI.
+ *
+ * nohash:
+ * We still do TLB invalidate in the __pte_free_tlb routine before we
+ * add the page table pages to mmu gather table batch.
+ */
+#define tlb_needs_table_invalidate()	radix_enabled()
 
 /* Get the generic bits... */
 #include <asm-generic/tlb.h>
--- a/arch/powerpc/Kconfig~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/arch/powerpc/Kconfig
@@ -223,7 +223,6 @@ config PPC
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE
-	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
--- a/arch/sparc/include/asm/tlb_64.h~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/arch/sparc/include/asm/tlb_64.h
@@ -28,6 +28,15 @@ void flush_tlb_pending(void);
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
 #define tlb_flush(tlb)	flush_tlb_pending()
 
+/*
+ * SPARC64's hardware TLB fill does not use the Linux page-tables
+ * and therefore we don't need a TLBI when freeing page-table pages.
+ */
+
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#define tlb_needs_table_invalidate()	(false)
+#endif
+
 #include <asm-generic/tlb.h>
 
 #endif /* _SPARC64_TLB_H */
--- a/arch/sparc/Kconfig~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/arch/sparc/Kconfig
@@ -65,7 +65,6 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
-	select HAVE_RCU_TABLE_NO_INVALIDATE if HAVE_RCU_TABLE_FREE
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
--- a/include/asm-generic/tlb.h~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/include/asm-generic/tlb.h
@@ -137,13 +137,6 @@
  *  When used, an architecture is expected to provide __tlb_remove_table()
  *  which does the actual freeing of these pages.
  *
- *  HAVE_RCU_TABLE_NO_INVALIDATE
- *
- *  This makes HAVE_RCU_TABLE_FREE avoid calling tlb_flush_mmu_tlbonly() before
- *  freeing the page-table pages. This can be avoided if you use
- *  HAVE_RCU_TABLE_FREE and your architecture does _NOT_ use the Linux
- *  page-tables natively.
- *
  *  MMU_GATHER_NO_RANGE
  *
  *  Use this if your architecture lacks an efficient flush_tlb_range().
@@ -189,8 +182,23 @@ struct mmu_table_batch {
 
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+/*
+ * This allows an architecture that does not use the linux page-tables for
+ * hardware to skip the TLBI when freeing page tables.
+ */
+#ifndef tlb_needs_table_invalidate
+#define tlb_needs_table_invalidate() (true)
 #endif
 
+#else
+
+#ifdef tlb_needs_table_invalidate
+#error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
+#endif
+
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+
+
 #ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
 /*
  * If we can't allocate a page to make a big batch of page pointers
--- a/mm/mmu_gather.c~mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush
+++ a/mm/mmu_gather.c
@@ -102,14 +102,14 @@ bool __tlb_remove_page_size(struct mmu_g
  */
 static inline void tlb_table_invalidate(struct mmu_gather *tlb)
 {
-#ifndef CONFIG_HAVE_RCU_TABLE_NO_INVALIDATE
-	/*
-	 * Invalidate page-table caches used by hardware walkers. Then we still
-	 * need to RCU-sched wait while freeing the pages because software
-	 * walkers can still be in-flight.
-	 */
-	tlb_flush_mmu_tlbonly(tlb);
-#endif
+	if (tlb_needs_table_invalidate()) {
+		/*
+		 * Invalidate page-table caches used by hardware walkers. Then
+		 * we still need to RCU-sched wait while freeing the pages
+		 * because software walkers can still be in-flight.
+		 */
+		tlb_flush_mmu_tlbonly(tlb);
+	}
 }
 
 static void tlb_remove_table_smp_sync(void *arg)
_

Patches currently in -mm which might be from peterz@infradead.org are

mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush.patch
asm-generic-tlb-avoid-potential-double-flush.patch
asm-gemeric-tlb-remove-stray-function-declarations.patch
asm-generic-tlb-add-missing-config-symbol.patch
asm-generic-tlb-rename-have_rcu_table_free.patch
asm-generic-tlb-rename-have_mmu_gather_page_size.patch
asm-generic-tlb-rename-have_mmu_gather_no_gather.patch
asm-generic-tlb-provide-mmu_gather_table_free.patch

