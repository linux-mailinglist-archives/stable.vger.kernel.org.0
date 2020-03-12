Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4956A183160
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCLN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42133 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id h8so3082368pgs.9
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AOYTyCBfTy8MK3UPn6mW4+x0YQLfUKNtszBzIavYGWA=;
        b=lS0GhE933CCmOmeFpvr/ip2iV/KpmaPPFcD8rxSamy00DeBg+mdvBlS5+H6c/ex7XX
         K3aiuBWHV6Qf5EQ9/Wp5+tSiiijGe8mBqxaG+wwHvKKE0tYpbNvKj88JqqwoPZ7QMrbX
         yzovdeL1Cys01eyNxdLuAAKzcy4cg4CX62XCipRkekbz8faqicPn75ZUG+oGB/9FMtKb
         PKKg1mfCCJo6km0DekMDWyM1FS0MQskkbPf14Y9esO72VTkxP5E1tU92Nx2k/7iMsFbt
         c6k1s0fJKfgTypfQVeHCFLI22dp2zi5rT3BM3NdaOWJH9pvtVpqkm4Tj/aQreaCqPVAk
         HggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AOYTyCBfTy8MK3UPn6mW4+x0YQLfUKNtszBzIavYGWA=;
        b=cE92hCOAo+ME9VjeAzwRRjvtud70yU0i9CaGmZhX9yB0UAVeU84j0IaXdnvBA9Qlm1
         VOdozob8VUsX1wwVbmuEjK4VKqT//tIBqUuBEO7dgoBHkr+3mAJ5405xo7f15/s+optb
         zryoR2maGmQEprI8Mk1R6dzfLBzv3Qi0Z0/cv6Zq/4oUij3APAKZ6lWP/1abmiVLQhe9
         GeqsGjpIx53AOx+x6DwLFlA1E4wyGvkVNkA/7u5xpXkvvdqty4mDzCKQ+1/ZUGmfPrAR
         mcIJVkNh8NQZVgyNWbYQ5CdRwesdZJJFk5ewFC5xNMW5/0qQRU4nnBEh/3fTXpxzaz5j
         DD6g==
X-Gm-Message-State: ANhLgQ0jzziUFpycDv2GIeaR7vAgnLdJzg8JPW6dN+VH0N99QuHgtj+q
        osMjFTpUg3bj4RDN2mIbzL2+NZol+ns=
X-Google-Smtp-Source: ADFU+vv2KWyb3e7X6LuFGDW5/DQGC9VabvRVdjphSKuYITMI1VSWGCqToqd7D5TYG1iQ9Ytrzj18/g==
X-Received: by 2002:a63:3111:: with SMTP id x17mr7979463pgx.422.1584019703713;
        Thu, 12 Mar 2020 06:28:23 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:22 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 5/6] mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
Date:   Thu, 12 Mar 2020 18:57:39 +0530
Message-Id: <20200312132740.225241-6-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
References: <20200312132740.225241-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 0ed1325967ab5f7a4549a2641c6ebe115f76e228 upstream.

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
Cc: <stable@vger.kernel.org>  # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: backported to 4.19 stable]
---
 arch/Kconfig                    |  3 ---
 arch/powerpc/Kconfig            |  1 -
 arch/powerpc/include/asm/tlb.h  | 11 +++++++++++
 arch/sparc/Kconfig              |  1 -
 arch/sparc/include/asm/tlb_64.h |  9 +++++++++
 include/asm-generic/tlb.h       | 15 +++++++++++++++
 mm/memory.c                     | 16 ++++++++--------
 7 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 061a12b8140e..3abbdb0cea44 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -363,9 +363,6 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_RCU_TABLE_FREE
 	bool
 
-config HAVE_RCU_TABLE_NO_INVALIDATE
-	bool
-
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1a00ce4b0040..e5bc0cfea2b1 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -216,7 +216,6 @@ config PPC
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE
-	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC64 && CPU_LITTLE_ENDIAN
 	select HAVE_SYSCALL_TRACEPOINTS
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index f0e571b2dc7c..63418275f402 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
@@ -30,6 +30,17 @@
 #define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
 
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
index d90d632868aa..e6f2a38d2e61 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -64,7 +64,6 @@ config SPARC64
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
index f2b9dc9cbaf8..19934cdd143e 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -61,8 +61,23 @@ struct mmu_table_batch {
 extern void tlb_table_flush(struct mmu_gather *tlb);
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
 /*
  * If we can't allocate a page to make a big batch of page pointers
  * to work on, then just handle a few from the on-stack structure.
diff --git a/mm/memory.c b/mm/memory.c
index ba5689610c04..7daa7ae1b046 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -327,14 +327,14 @@ bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_
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
-- 
2.24.1

