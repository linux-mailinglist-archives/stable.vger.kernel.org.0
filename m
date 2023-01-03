Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6881165C4DE
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjACRPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbjACRO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:14:29 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335A611153
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:14:09 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so23960685wms.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ITgQzMynVIkKiwlnE3jok4WksO57xaG3uyluozaCD+Q=;
        b=ilgmHvU0t2b18nT0FIALMSbaKGo47U9xmgSAlFcQIevk+Ekm4zpvhSWfw2bKTo53LH
         iuDr87EXgE8Da9ftLlQQGqhm3TZ7g3f7Rijn/oiFsTmaLpvB3NVYCWCwO7rx8mFQ4xO9
         W/Md/2f/JNi9WMyeW/h+7/66XU7IVVjdNd7FUg5GKODkXJ5eoh5LVfmgo4zG2nq096qp
         zp8flxPpNYmR8q/jB+78ida6kshxvtWZZfBxuJygmeksMoPgG008hZ9YLFfXj+pTfLm0
         6DyU6frJ8dRmrmcq/n6mVbRIfA6c2XYUt1Sli77Lb1skcOHjC9Rnv1qcgzpuhLHq5OnF
         QgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITgQzMynVIkKiwlnE3jok4WksO57xaG3uyluozaCD+Q=;
        b=GySOgL3AX8d4R07ZBlEmz+0q9QnB7Bdvfg2hon5LzuOvxtz3apRYxwioUsNjI1wudc
         qvZ7h8Hq6ECmraWi9wsU2W429DU5CDMQ8enaoPpG8SM9j3jFEwoFM7LST7d5CwVRYZF8
         d4ivITbNwAaFVNfWzdAdmgfdmd586hNrEXfzOdtehalMM4VfZnCoBNuX1/+KLE5sM4mN
         JepVKEsBB5RCaAbvuyjOxcTIGwaTRf1dTOEFNTx6jGNaJskGxGb64esjKbgCzE4AMlsH
         UrTlkeLaFTqQ6UPMsu4XkUJU0BzjhAo+jqi8crSNYXh3v6kEnI6LMyIQHcoDDXaAy2LJ
         cVLw==
X-Gm-Message-State: AFqh2kqBc5LqOzXQCk2vuWtwRZnrzlP5Uw+9yXobCo/BtrwqJc+xHObB
        2pyRWxKIxi+0b2Dcwi9Ya43ORaYqPt93Yc1X
X-Google-Smtp-Source: AMrXdXus6vhUbdOmZiwq6VMQxmYAohC1dSRn+23e8AFhoeLWWzI87BF4d8fN2BzdNpTPxuKO3eJQcw==
X-Received: by 2002:a05:600c:3d8c:b0:3d0:7ee4:a69b with SMTP id bi12-20020a05600c3d8c00b003d07ee4a69bmr3856490wmb.2.1672766047637;
        Tue, 03 Jan 2023 09:14:07 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:1ad8:6267:8f:ab55])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c35c900b003d6b71c0c92sm64903975wmq.45.2023.01.03.09.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:14:06 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v3 stable 4.19 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  3 Jan 2023 18:13:56 +0100
Message-Id: <20230103171357.286343-1-jannh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
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
ugly hack needed in <=4.19 for s390 and arm]
Signed-off-by: Jann Horn <jannh@google.com>
---
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
index 5dd14ef2e1de..0a4cace1cfc4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,19 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+/* gross hack for <=4.19 stable */
+#if defined(CONFIG_S390) || defined(CONFIG_ARM)
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
2.39.0.314.g84b9a713c41-goog

