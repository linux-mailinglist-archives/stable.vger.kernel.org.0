Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1A6644A2A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbiLFRQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiLFRQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:45 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED7831EEE
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:44 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id ay8-20020a05600c1e0800b003d0808d2826so1256639wmb.1
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jwp3hiQo/qSyZCRMlpm+iyfd6uYdBW/nzgmtYo3rpnc=;
        b=kfvUr8sjS9lmxE7RPKrrgwT6FKL4WWlwsjocQSpZ71HoHGitBsax38nhyDne1sZpEd
         xU8VTrgsTc+Mph7I0+g0WWtHpd55N4zXoZdf+lztCyybqNvI/5sJ5hK1shU4oFcw5yND
         mWKPIRZ0fZhaCDfptA3zl4qchTTIipj4JDsziTvhtmlN4WSXPb2coWm7QvtVdZ4O0BF4
         58W/QdfkZv5+WxAl1kePT/mtktoLfmoiczhfv+BSTvTBYX0tEfsNRWMCvHxoHHm9A1im
         GxuYo0G910K1k1tn6M5ZnJYgmOITQcphSrYD+SApyFM/VlWQcs9WjwMl2ejj0VOpuDgK
         Bamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jwp3hiQo/qSyZCRMlpm+iyfd6uYdBW/nzgmtYo3rpnc=;
        b=guon0ak8Bh89KBqb72l/wC287mRSJr1dU3cRoaRNnwu1STWT05AjbDp8bjzK8gzHc2
         I5d62LRF2WGvWrzq5Snvlb8lD9FlMui8HpxM34C8TDF+F+lVlYFMXdngheEZXbZAooji
         0dEqwbaytfkJ6wYipaMfsUOjFTDDue3AuDbYQa9NB4vvFCAcvdkVLEJ5+LMI2aCPIUPz
         SWhtXE8ASwT44TFYaXoC1pZBft3AG3eu6GVjSXHNM6hmkGEp8jQxAFuiNr/TUvQBjitP
         3Qq59ulZ3u526H9JZDvwNJItJOloPCCNBd9hfrOTexyABnw9u9pZhNoFdNvucLGYi8pI
         lRTA==
X-Gm-Message-State: ANoB5pmVmg/ZWER4FE/EYc0M0ZhPeZkXgNzNxu4Zi6CgBKhOBjBT27Aj
        cNu0jESdciPfpxfljXbAxArYY1WijdU8lNEo
X-Google-Smtp-Source: AA0mqf6Ds7DOOImpibmJpc6/Whul/MhQR7x6cUopCOiDHo/8hni4OaJT19oA7Z8OzOIP5s/BeIqsnQ==
X-Received: by 2002:a05:600c:3d0c:b0:3cf:f66c:9246 with SMTP id bh12-20020a05600c3d0c00b003cff66c9246mr50960971wmb.27.1670347003462;
        Tue, 06 Dec 2022 09:16:43 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id d5-20020adffd85000000b0022e57e66824sm19850102wrr.99.2022.12.06.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:42 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 6.0 2/3] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  6 Dec 2022 18:16:12 +0100
Message-Id: <20221206171614.1183048-11-jannh@google.com>
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
[backported, no changes necessary]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/tlb.h | 4 ++++
 mm/khugepaged.c           | 2 ++
 mm/mmu_gather.c           | 4 +---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 492dce43236e..cab7cfebf40b 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -222,12 +222,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
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
index 28d8459d7aae..1155d356d3ac 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1093,6 +1093,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte,
@@ -1391,6 +1392,7 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
+	tlb_remove_table_sync_one();
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index a71924bd38c0..ba7d26a291dd 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -152,7 +152,7 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -176,8 +176,6 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

