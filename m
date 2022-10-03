Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424625F365F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 21:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJCTfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 15:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJCTfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 15:35:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86B1144B;
        Mon,  3 Oct 2022 12:34:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x1so10574618plv.5;
        Mon, 03 Oct 2022 12:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=XpdXNPBzi3+2LRRbY9xCMr4whphrF0pEZu5KjI+tgrU=;
        b=TmK2I6xcRG3UlmVmDyIhbhHW5FH3mqGaG579Akpwk7gXeKp6ffrjM2msXzZUJ9YmU/
         DBGTI56Th8R38uOlONLCpNnU/2Et/mjsLCCVu+rxG42NU0Ea9zWCyBwbzZ4VD3qcPugE
         5hlnGv4P+uWGQM4LzIgL3f67Dkk0Hg0n2h607MngD1GCzss6sV4L/GM5VPdYQRV1/2Uc
         Ei5nZfRr1ZfYBRz4kS35OHNMchhrDZk5LW+No/7z5LPGYn8nPL8DgMJMkTEhs8nWdx66
         QZjw3Fe3VFsI3piKHl/zkzifauxtTFOzCAo9nko4EtHBW6rKSuKyoH0K7acC7gnd+GuF
         KZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=XpdXNPBzi3+2LRRbY9xCMr4whphrF0pEZu5KjI+tgrU=;
        b=5XJJQtXcbR/p3ohmFEhUwHsbRcbjZMtZ9gASeVPGDI7GehcGwI/MxOREBPwWlKZRHQ
         PzPURQwce5Y1xzzNr8iMU446GymHU8NcXer7sYvtkUJO9Pk3e8FkvH5OqO2ZPrpgY4Go
         6AGSWQ3syi4tODHxJ9/GJ22HHiZTdiHMlPXbLd/+lvKjw6VEmJKstZKlhS6+BnOCYZM3
         zcsZoC+4u0giA4L9MLBhKNcJ0rdFTSFpMT5zIVHBbQdMG67dQM0Lw8aTxUvS79Bn+Wsh
         rJ4o3zgP4tpARf13SbNnd/s9Me7NZxJlC2Yj20pYymZlIxraBca3P2/oDChH04RyUYQl
         Hi5w==
X-Gm-Message-State: ACrzQf2/qr8xM0lXiIhAO2+NdY4/A/ve9qB/U5uhBPxXtCpBeL2KgrKA
        13spTcNGrxMq253ky+e5m0eqol0Z9YY=
X-Google-Smtp-Source: AMsMyM7GeLOdSHsxpl+w7D/FApIYullKrm3K37WExlSK/Ijcp7VXbtiNFVxsMaJ+nvkh1IUBukgJPg==
X-Received: by 2002:a17:902:c410:b0:17d:4d86:4d91 with SMTP id k16-20020a170902c41000b0017d4d864d91mr14512697plk.41.1664825697045;
        Mon, 03 Oct 2022 12:34:57 -0700 (PDT)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net. [67.174.241.145])
        by smtp.gmail.com with ESMTPSA id x26-20020a63171a000000b004308422060csm6809601pgl.69.2022.10.03.12.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:34:56 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        david@redhat.com, hughd@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mpe@ellerman.id.au, npiggin@gmail.com, peterx@redhat.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [5.10-stable PATCH] mm: gup: fix the fast GUP race against THP collapse
Date:   Mon,  3 Oct 2022 12:34:53 -0700
Message-Id: <20221003193453.1625076-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 70cbc3cc78a997d8247b50389d37c4e1736019da upstream

Since general RCU GUP fast was introduced in commit 2667f50e8b81 ("mm:
introduce a general RCU get_user_pages_fast()"), a TLB flush is no longer
sufficient to handle concurrent GUP-fast in all cases, it only handles
traditional IPI-based GUP-fast correctly.  On architectures that send an
IPI broadcast on TLB flush, it works as expected.  But on the
architectures that do not use IPI to broadcast TLB flush, it may have the
below race:

   CPU A                                          CPU B
THP collapse                                     fast GUP
                                              gup_pmd_range() <-- see valid pmd
                                                  gup_pte_range() <-- work on pte
pmdp_collapse_flush() <-- clear pmd and flush
__collapse_huge_page_isolate()
    check page pinned <-- before GUP bump refcount
                                                      pin the page
                                                      check PTE <-- no change
__collapse_huge_page_copy()
    copy data to huge page
    ptep_clear()
install huge pmd for the huge page
                                                      return the stale page
discard the stale page

The race can be fixed by checking whether PMD is changed or not after
taking the page pin in fast GUP, just like what it does for PTE.  If the
PMD is changed it means there may be parallel THP collapse, so GUP should
back off.

Also update the stale comment about serializing against fast GUP in
khugepaged.

Link: https://lkml.kernel.org/r/20220907180144.555485-1-shy828301@gmail.com
Fixes: 2667f50e8b81 ("mm: introduce a general RCU get_user_pages_fast()")
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/gup.c        | 34 ++++++++++++++++++++++++++++------
 mm/khugepaged.c | 10 ++++++----
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 6cb7d8ae56f6..b47c751df069 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2128,8 +2128,28 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
 }
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+/*
+ * Fast-gup relies on pte change detection to avoid concurrent pgtable
+ * operations.
+ *
+ * To pin the page, fast-gup needs to do below in order:
+ * (1) pin the page (by prefetching pte), then (2) check pte not changed.
+ *
+ * For the rest of pgtable operations where pgtable updates can be racy
+ * with fast-gup, we need to do (1) clear pte, then (2) check whether page
+ * is pinned.
+ *
+ * Above will work for all pte-level operations, including THP split.
+ *
+ * For THP collapse, it's a bit more complicated because fast-gup may be
+ * walking a pgtable page that is being freed (pte is still valid but pmd
+ * can be cleared already).  To avoid race in such condition, we need to
+ * also check pmd here to make sure pmd doesn't change (corresponds to
+ * pmdp_collapse_flush() in the THP collapse code path).
+ */
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
 	int nr_start = *nr, ret = 0;
@@ -2169,7 +2189,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 		if (!head)
 			goto pte_unmap;
 
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		    unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_compound_head(head, 1, flags);
 			goto pte_unmap;
 		}
@@ -2214,8 +2235,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
  * useful to have gup_huge_pmd even if we can't operate on ptes.
  */
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	return 0;
 }
@@ -2522,7 +2544,7 @@ static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned lo
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
 					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
+		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 969e57dde65f..cf4dceb9682b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1144,10 +1144,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
-	 * After this gup_fast can't run anymore. This also removes
-	 * any huge TLB entry from the CPU so we won't allow
-	 * huge and small TLB entries for the same virtual address
-	 * to avoid the risk of CPU bugs in that area.
+	 * This removes any huge TLB entry from the CPU so we won't allow
+	 * huge and small TLB entries for the same virtual address to
+	 * avoid the risk of CPU bugs in that area.
+	 *
+	 * Parallel fast GUP is fine since fast GUP will back off when
+	 * it detects PMD is changed.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
-- 
2.26.3

