Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CAF210344
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 07:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgGAFWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 01:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgGAFWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 01:22:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F3C061755
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 22:22:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b16so10455164pfi.13
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 22:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6y8xaEb9LV894Ycksw6hTuNBMRoBhwg8g7vq7evkHOI=;
        b=DvRcDYTC+utSLrz1zG50Sw2J6E/hqfYA5l953a1xdVoLqzdF97mvnJ08LgfjWteg0b
         gxRxrZHfTc8VwDLezY+xwpmD38HWjnIgXcx9wthBG6libmHo3Nh71Sxfj6iELO8/5jBa
         QDlN4aXgB7NZlBucOa4/HYDqSvAY/C5duh4zsgUrBAEjwuLg9EENyJ12ccXh15WIm7W9
         LN54iAo9fsisK7qmrYWk/DjwoYt6fHmKHjkAFyk8zWiVdcR5V4Ip7uf/R8Q2Lu1jHIL3
         Wses30i6O8lOM0F2eCTIkm0kVaX6PZuoOEnr/mXPVHwfDrhTSnViQ9qXcp5DRyK22pB0
         BlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6y8xaEb9LV894Ycksw6hTuNBMRoBhwg8g7vq7evkHOI=;
        b=FZ/v8vh7Mt54Al41HDBZg4R1kpLvcxYZ6J8fwmTZCNt63f8axKqkVuqjWVE7mlM3cc
         L4O8NNBlNhq+4INnSrJ+LKCjTx66goPwSX7aS06L5TLl0Q5BeDrpP6yA+/jCq+d1sHud
         snitTfyXiGunVW1dagFXDE9MT8IzDCDP+/4uuV6lX+lJX6bJh4qCNC9vdQsnGIig0WJI
         5sMp0GT3dLheNhsUjv/aWi/EadAHzdvSTaG4jdwNrKweCN3f5y4cw9262XN5VzdxjIER
         KcEeIkK7idDWoBGkROvZFnzNK8Dc9GwjeUvs6/GGXey+bLhwakWqpdKqN11I6m8L96bw
         3RHg==
X-Gm-Message-State: AOAM5323HDG0pOl5UDt8a7vykfSAF34jH064fnD3WI4GWYAgxjinc32R
        P0ucGNhlhxDwk7S8WhzGbkpycb5sKiM=
X-Google-Smtp-Source: ABdhPJxOH8F/609SPn8UR8vF/lH4dcC50iab7INb56JNeZk7w+e1yAkB2EZw1QLxDKictLTeEsyZVA==
X-Received: by 2002:a63:b255:: with SMTP id t21mr9352045pgo.78.1593580948782;
        Tue, 30 Jun 2020 22:22:28 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([203.223.190.240])
        by smtp.gmail.com with ESMTPSA id y80sm4375201pfb.165.2020.06.30.22.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 22:22:28 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH 2/2] mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
Date:   Wed,  1 Jul 2020 10:51:47 +0530
Message-Id: <20200701052147.1698510-2-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701052147.1698510-1-santosh@fossix.org>
References: <20200701052147.1698510-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 0ed1325967ab5f7a4549a2641c6ebe115f76e228 upstream

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
are now removing HAVE_RCU_TABLE_INVALIDATE.  The default value for
tlb_needs_table_invalidate is to always force an invalidate and sparc can
avoid the table invalidate.  Hence we define tlb_needs_table_invalidate to
false for sparc architecture.

Link: http://lkml.kernel.org/r/20200116064531.483522-3-aneesh.kumar@linux.ibm.com
Fixes: a46cc7a90fd8 ("powerpc/mm/radix: Improve TLB/PWC flushes")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>  # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 arch/Kconfig                    |  3 ---
 arch/powerpc/include/asm/tlb.h  | 11 +++++++++++
 arch/sparc/include/asm/tlb_64.h |  9 +++++++++
 include/asm-generic/tlb.h       | 15 +++++++++++++++
 mm/memory.c                     | 16 ++++++++--------
 5 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a336548487e69..3abbdb0cea447 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -363,9 +363,6 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_RCU_TABLE_FREE
 	bool
 
-config HAVE_RCU_TABLE_INVALIDATE
-	bool
-
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index f0e571b2dc7c8..63418275f402e 100644
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
diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
index a2f3fa61ee36a..8cb8f3833239a 100644
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
index b3353e21f3b3e..92dcfd01e0ee4 100644
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
index bbf0cc4066c84..7656714c9b7c4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -325,14 +325,14 @@ bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_
  */
 static inline void tlb_table_invalidate(struct mmu_gather *tlb)
 {
-#ifdef CONFIG_HAVE_RCU_TABLE_INVALIDATE
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
2.26.2

