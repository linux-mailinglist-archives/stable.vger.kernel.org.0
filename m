Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED364A5ED
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLLRcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiLLRcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:32:47 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4556CDD0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:45 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id ay40so6127153wmb.2
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=S1PJ8+JDItZHFZ8yeGT+it4tq83ZN0ZD5+cvsta28E0=;
        b=jce7G+wxqgQjEiTpl15tJS2qRRWBzGS7ionwq+pPkHXeRjIalFrc10aL/rkC3eHDrx
         AvsVPgyO91UVrGF0++dVsYVHbvwod72hUH9AGa7lA/tLCdugTm1HhCGH66WqqIjB/V8S
         DHhABg539Di4OSn85zcoawYT61ywBRQD1y+GrEpZdxHgPnh0GMdETe9+WBh8d3yye85W
         vtpzULNs1B6VL73M8e5DDXItFxq+Rysz0O1duuF9QsoDVX7JLoKVKF+IoqQOeC/F/4YO
         RF2Jm4V48oEEzdlZ1IxQsWCw19kK6riC+qrwQUEi+kv0FFIgJkP+fQrY/Jzgg1bUl92W
         a8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1PJ8+JDItZHFZ8yeGT+it4tq83ZN0ZD5+cvsta28E0=;
        b=YCimkNJO4OlNfXOBa8uDhGiuu+KnwBbqtYE5d3kGBWM4OW62UkSy+Q/B7hJKHRt7B6
         yqq6JiUKCdjVtTPme0Ksjuto0jdqYLfFRcEaYr2cFW716ckJRWACahKTJHTlHph34NzS
         k/9XCIMM0YvbubEY0ehV5tAppXCen4kDQsUKTMTuHo4CuoJHOkBlZMSMQUxc3EW2HNmF
         5h6jxWj7UO9NMNSRQPFlX1o9FbLjNCkF8Ykd+xtCcOvts6IET5lWbM6U0AzLIwhcL8bQ
         0MmBxm1ZXGIzkAsQ2Xok3ifjDMi+jqIP4gCEavhbucufGMvwlMuWg7luC43CC1b9C7H6
         IiQw==
X-Gm-Message-State: ANoB5pk+W3daPh7F2QYhhfMs6oI18ZDzmyg6Oz+u5bQUG0LD1lfKCiQ7
        px0RGxk46u+hnz7mnGu0CmklzSJNMczQIGc1
X-Google-Smtp-Source: AA0mqf5gjgbRx+uozh610+2CNJ2DKI/uTLf0IJl8XIWi8+Lu/6uxkPN2NXFAc1QT/DEndFVzrcpMJg==
X-Received: by 2002:a7b:cc8e:0:b0:3d1:f779:a187 with SMTP id p14-20020a7bcc8e000000b003d1f779a187mr688408wma.1.1670866363787;
        Mon, 12 Dec 2022 09:32:43 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d108:797c:2f44:5af6])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c2ca500b003c6bbe910fdsm12412476wmc.9.2022.12.12.09.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:32:43 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 stable 4.19 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Mon, 12 Dec 2022 18:32:35 +0100
Message-Id: <20221212173238.963128-1-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
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
ptes were refactored into a common helper between 5.15 and 6.0;
TLB flushing was refactored between 5.4 and 5.10;
TLB flushing was refactored between 4.19 and 5.4;
pmd collapse for PTE-mapped THP was only added in 5.4;
ugly hack needed in <=4.19 for s390]
Signed-off-by: Jann Horn <jannh@google.com>
---
added an incredibly ugly hack to work around the s390 issue reported in
https://lore.kernel.org/all/Y5aaQqNH71IMVks0@sashalap/

 include/asm-generic/tlb.h |  6 ++++++
 mm/khugepaged.c           | 15 +++++++++++++++
 mm/memory.c               |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index db72ad39853b..737f5cb0dc84 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -61,6 +61,12 @@ struct mmu_table_batch {
 extern void tlb_table_flush(struct mmu_gather *tlb);
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+void tlb_remove_table_sync_one(void);
+
+#else
+
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5dd14ef2e1de..0f217bb9b534 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,19 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+/* gross hack for <=4.19 stable */
+#ifdef CONFIG_S390
+static void tlb_remove_table_smp_sync(void *arg)
+{
+        /* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_sync_one(void)
+{
+        smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+#endif
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
@@ -1045,6 +1058,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1294,6 +1308,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				mm_dec_nr_ptes(mm);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
 			}
 			up_write(&mm->mmap_sem);
diff --git a/mm/memory.c b/mm/memory.c
index 800834cff4e6..b80ce6b3c8f4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -362,6 +362,11 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
+void tlb_remove_table_sync_one(void)
+{
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+
 static void tlb_remove_table_one(void *table)
 {
 	/*

base-commit: c1ccef20f08e192228a2056808113b453d18c094
-- 
2.39.0.rc1.256.g54fd8350bd-goog

