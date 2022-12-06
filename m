Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C417644A1C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiLFRQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiLFRQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:32 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813AB24978
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:31 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so9332175wmb.5
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6TKRQpLBbl1MGS/8eSZQiqQDxHNKyQAv3DLFbOPR0iI=;
        b=tRzFpWsOXcSvIeeUsuNQVhH4TPPSrIPUUMR+nR1lxECdtsLXWXaBLO5SgI98f1Lw9X
         OjrqStjNALRUVO4RSaNbIAaiHQEH4xfu8qYaXM/XZVJisQfa5S0PakJZEJ9ncDOy5Z5I
         61n8wFHOUYphUXptoubh3FaXsIcOzVqXKsgg8V9BYrZcxS8VaguIxlFPXDsTPm9bUJp3
         5cFmeScd1hf8Ln9uaY81bAzabZFP2i3+vaJWL8Mz9YZJHR2iqRyD3F8+HkpBEcJty6qP
         iTgWIZKwdX8usydNwmJ5mSuc56OBFYCL+Q34vGgquR0+e3vLDmWcLyYLOqjdd1TkaEox
         E6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TKRQpLBbl1MGS/8eSZQiqQDxHNKyQAv3DLFbOPR0iI=;
        b=OoLAPr6Kl+5Pv+xjfomabVA6x9bTwnc9BBEmT9cwvpBwBafJSFE+NpORhRevYB9kzk
         EmZOLkNR1CjIeqhSSNs9XNEIQfV0o/wfrdOCVU/MDtPFeNzGc9dmtqgq9+X0hfG/nr6b
         vuhRrrex9tFfWkgM4q60B/Q2HtkN/jpewcVnuQLdxriGJcRDJC2aSPpsAiF4y0Sjti+l
         cNu8GPgWJvdGh/lOn9OX/bcdEmehvkVAcNIfQ+UkBA5T+QIqpBDhb+mGANZpxNYvBgLc
         y9GxAM7Ajj4LaKj3NtftcHnmle/64YhLHJhMM0gOQr1s6Tz+sPfWROZ33iB+1pqWGmyP
         3bCA==
X-Gm-Message-State: ANoB5pk8KrwK6basJy0yWrx868yPjKJ9uOy5Lsy2wsaa7kJKJ8onoXz6
        mR0ZmS+6rKLS8eOSdDVV6iKdnvZdUBVdgyBr
X-Google-Smtp-Source: AA0mqf6wPAq/GvNsXFKWyEIsNIE1jCwwperXf6xDUDusSfkAcHB4wvy/j0/hClxUtx/ywc+I9UxruQ==
X-Received: by 2002:a05:600c:3543:b0:3cf:a6e8:b59b with SMTP id i3-20020a05600c354300b003cfa6e8b59bmr67154895wmq.128.1670346990049;
        Tue, 06 Dec 2022 09:16:30 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600c4e0d00b003d01b84e9b2sm9635403wmq.27.2022.12.06.09.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:29 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.10,5.15 2/3] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  6 Dec 2022 18:16:04 +0100
Message-Id: <20221206171614.1183048-3-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
In-Reply-To: <20221206171614.1183048-1-jannh@google.com>
References: <20221206171614.1183048-1-jannh@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2ba99c5e08812494bc57f319fb562f527d9bacd8 upstream.

Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
ensure that the page table was not removed by khugepaged in between.

However, lockless_pages_from_mm() still requires that the page table is
not concurrently freed.  Fix it by sending IPIs (if the architecture uses
semi-RCU-style page table freeing) before freeing/reusing page tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[manual backport: two of the three places in khugepaged that can free
ptes were refactored into a common helper between 5.15 and 6.0]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/tlb.h | 4 ++++
 mm/khugepaged.c           | 3 +++
 mm/mmu_gather.c           | 4 +---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 71942a1c642d..c99710b3027a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -207,12 +207,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fc02de08e912..1735123e462a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1156,6 +1156,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte,
@@ -1537,6 +1538,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	/* step 4: collapse pmd */
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	mm_dec_nr_ptes(mm);
+	tlb_remove_table_sync_one();
 	pte_free(mm, pmd_pgtable(_pmd));
 
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
@@ -1623,6 +1625,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				mm_dec_nr_ptes(mm);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
 			}
 			mmap_write_unlock(mm);
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 1b9837419bf9..8be26c7ddb47 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -139,7 +139,7 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -163,8 +163,6 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

