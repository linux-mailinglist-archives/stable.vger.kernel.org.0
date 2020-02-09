Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADF156AC5
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgBINw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:52:26 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46675 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:52:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7178921AD2;
        Sun,  9 Feb 2020 08:52:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7XCl1y
        4tMYJA/OcbhB1d4dU8hurAXhcJZX0f9QGj8JY=; b=TRr3pPGdvZW7aDhAEXbcKp
        1jvQ+ykBwH0A179YSBbh71w++wc8pbjEYrGfJlj1nDDSdNyfy3iKdg1EqKPryMgm
        SrOw+unX7OeG61DePm2AzY9rWKop2DgaGXz6JLRiYjf7ATG0njx7cdgT4AzXVz7f
        T+t+cGf6dbgt2wpgje1LOjUk9200f77GW+Pzz4FsebXVTWNc6MSvdd6T329slBGT
        v++OA3cDThcN4TsYCy31V2nOqcsUc4fs1xA2lKQrM/b3VYZF4GlaeMJGrTGLGA7N
        tJgLwMUmkD9XAkviZkECE8PLedwwZ2x+Z8C2XngrgLarsP66kvosPi47okXq87jA
        ==
X-ME-Sender: <xms:mQ5AXo0rgmzOMb2vtkocZ8bk7ZLnCzJO_x2dXmLEtZo9XNh470S3wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeefkedrleekrdefjedrud
    efheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mQ5AXkzU5SVFvFWC87i5EYScOlNJk6gJ7lF1ZbpHrOCInDmNCgRmWA>
    <xmx:mQ5AXkVdpjo9yVBr2ficoHE2kwBVlUSqLqKtXX77kH5LuxlOUGqAJA>
    <xmx:mQ5AXhqqrJvnbcmIegSGyYKe9FVSGInk27bbDTcIyJsYn7WXI2B7mw>
    <xmx:mQ5AXtGcdVICHrCf1h2ZfGNst2qSyti0VKsQtzX7ZukZJeOBJt07tA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21F853060940;
        Sun,  9 Feb 2020 08:52:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/mmu_gather: invalidate TLB correctly on batch allocation" failed to apply to 4.19-stable tree
To:     peterz@infradead.org, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 14:01:56 +0100
Message-ID: <1581253316166147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ed1325967ab5f7a4549a2641c6ebe115f76e228 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 3 Feb 2020 17:36:49 -0800
Subject: [PATCH] mm/mmu_gather: invalidate TLB correctly on batch allocation
 failure and flush

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
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/Kconfig b/arch/Kconfig
index 48b5e103bdb0..208aad121630 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -396,9 +396,6 @@ config HAVE_ARCH_JUMP_LABEL_RELATIVE
 config HAVE_RCU_TABLE_FREE
 	bool
 
-config HAVE_RCU_TABLE_NO_INVALIDATE
-	bool
-
 config HAVE_MMU_GATHER_PAGE_SIZE
 	bool
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 54b7f2af7cb1..c22ed1fe275d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -223,7 +223,6 @@ config PPC
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE
-	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index b2c0be93929d..7f3a8b902325 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
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
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e8c3ea01c12f..7b9b3a954a76 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -65,7 +65,6 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
-	select HAVE_RCU_TABLE_NO_INVALIDATE if HAVE_RCU_TABLE_FREE
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
index a2f3fa61ee36..8cb8f3833239 100644
--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
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
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 2b10036fefd0..9e22ac369d1d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
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
+#endif
+
+#else
+
+#ifdef tlb_needs_table_invalidate
+#error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
 #endif
 
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+
+
 #ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
 /*
  * If we can't allocate a page to make a big batch of page pointers
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7d70e5c78f97..7c1b8f67af7b 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -102,14 +102,14 @@ bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_
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

