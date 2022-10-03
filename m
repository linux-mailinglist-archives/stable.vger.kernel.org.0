Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2235F35B4
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJCSjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJCSi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 14:38:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8A037417;
        Mon,  3 Oct 2022 11:38:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so16057161pjs.4;
        Mon, 03 Oct 2022 11:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=sjZWL20TkiJwGgcx4jgs+B1HCML+Om4Y6HZKNPskHdE=;
        b=lTEgmLtJAaaW319lD8NxUavIHchOMvenkBspNtdql7goygrt2OecNNIYMulDlbyH+n
         O8MJHSFArb/mLJtsSbCjOimV1phRuLIfAVqD9c8kpQpyeuyCquuTvpEQ/iaO382f4gMO
         +n1KlFVL6Wp+aWiH2zfWefBww6orTwt0ovP+wQC3QkI/GlRdDMrXUGmEmfm5V3DhYt5h
         sGQ9UnLeVt6kzDOfmzmjtmHWAydh1gyY4irm2EOTuXMP1gfU4prKvzQfGF3aq0moytVI
         ZrNU8xIf4KpFDCZzXGg/qNqLHTaAO9fOakwAEX7qXsTBxt3fFPJJmc0d1RdL594A7K/v
         Yr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=sjZWL20TkiJwGgcx4jgs+B1HCML+Om4Y6HZKNPskHdE=;
        b=PZ4XHO7T+ZG75ZbbUiP64m+g8JkGX6//bUZp8TsYpUFRgr/FWHYuTeX4ozWz4oVpoI
         c+AOBbbPXInEhP3WYCZXTl/HcDI25gABrk/L66MyKTyXxNByDak8DsxDC/qiDQWfpnSr
         VB/6OrcJvFPwa+S0CdnTxwywtZZQaC1fJoZ3ObT/Ezj1PrbMEYWLhOfFn/qbmigUi4ge
         E8gH2pvPQNPeTuRd2J6b6wIqtOQT9KeC69ChUOHklvDaB1rX38JZBilnjslgT1B4jvsm
         BvyqQ9qmLb/pBdxs0XzyXLjGNQTECBgWlCp/NA9YxiEgy6Ho9Ap8UY28M0KJ97lIFTmS
         zd3Q==
X-Gm-Message-State: ACrzQf2uLBAf2pXyHG7jhwb5oBhno4bk5UQzbbZWxirftGSd32rFwUn7
        PjfA7dnJAP7iqMNDIfD7BKY=
X-Google-Smtp-Source: AMsMyM6XKESrS1Zbta0w4U1JcfsK/Avqwpn/WkIEy+bF5c/2xIccCxrr4og6pBowKYFs5kLfd1CFAA==
X-Received: by 2002:a17:90b:4c46:b0:202:b9c5:2f24 with SMTP id np6-20020a17090b4c4600b00202b9c52f24mr12892071pjb.180.1664822337344;
        Mon, 03 Oct 2022 11:38:57 -0700 (PDT)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net. [67.174.241.145])
        by smtp.gmail.com with ESMTPSA id p187-20020a625bc4000000b00537b8deef41sm7692082pfb.136.2022.10.03.11.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 11:38:56 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        david@redhat.com, hughd@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mpe@ellerman.id.au, npiggin@gmail.com, peterx@redhat.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [5.15-stable PATCH] mm: gup: fix the fast GUP race against THP collapse
Date:   Mon,  3 Oct 2022 11:38:53 -0700
Message-Id: <20221003183853.1446126-1-shy828301@gmail.com>
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
index 05068d3d2557..1a23cd0b4fba 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,8 +2266,28 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
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
@@ -2312,7 +2332,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			goto pte_unmap;
 		}
 
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		    unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_compound_head(head, 1, flags);
 			goto pte_unmap;
 		}
@@ -2357,8 +2378,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
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
@@ -2667,7 +2689,7 @@ static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned lo
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
 					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
+		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8a8b3aa92937..dd069afd9cb9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1146,10 +1146,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 
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

