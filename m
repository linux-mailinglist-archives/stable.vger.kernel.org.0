Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A465C4E3
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbjACRPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbjACROh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:14:37 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB3FCE3
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:14:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so23961290wms.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fOwVTNXzYtfqaXLn7fVCyZ1D0HnsF/tTiKCiH4Pvj3k=;
        b=Acci0j1i1v1Qqg/lUnLl/fCOO1ytW8L1n/OQw0uyMDePtKnrqUlTd112S9zC59O2zS
         yG7cqyE7WEy9EtBf19jWbXuJlzDc64g9mYRJUV71e19vbaYkno5G24HZF6FnNfBT4Jg2
         mMyajwEUyoZY/dbB4TxWZECPIMeX+JTxefTyu6ZUHg+hEpwnAjvk94ZIgRg5mVEXr93L
         v/ygTG8AgNkIN+VOk90tZCYZtiei8U5o7FwuWVuLHMpYgrIfGLUXNfSSJLYwqHOxa/TY
         /+eLg5JgntCApfPE9vdhjEQHuN+XNfyqzFKHyWteiGAqESniCCv2N5UdJY2IheNF9Ijn
         IyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fOwVTNXzYtfqaXLn7fVCyZ1D0HnsF/tTiKCiH4Pvj3k=;
        b=ORQ8bktbj7uWhLOyluEK1yP6eVm120t/OuqraVjfua0wzHpWrRg/xxdqG1ceQTK0fy
         vWpB9jpcoeECgiqVE0sokj+/PKlq3lNQTLGRV5yYCZnJXtsx+YbbEHXs6vrcuQjyOlFW
         9TwXapwcx7bKtX+8xSghyJO8AkFjH9tc8oDlsYQWk+pgRokaBx9ej7Mycx+nFFRKdlME
         AA1ydFj8KT9oYN6vY+2HWHqxXaStPaZkqBPDX5EAj+wGrkX4O/A0mkekiqbjmmlYh5cr
         6WBJ7EKJO/RadbhIGZHsEJ0TuP3u/DSf7SRtF5fAgKAmEYAFJcHeeCbgaQhj1fe12Oq0
         mZBA==
X-Gm-Message-State: AFqh2krzcSNYfbv9RVdhDym+ZHlL9opAvXpq3tWSq1oL7DeYgFGFMsS3
        untepAq0FecIxkuU3vLRVnYdWD4/QRKHP9wP
X-Google-Smtp-Source: AMrXdXtIk4r2yRG7Gym4CQqx6XrNV7r5Bs4QahaJP8ngKYEHZLh0ZPvWAioOckU143zOdk2naMrnxg==
X-Received: by 2002:a05:600c:1c86:b0:3d1:bad1:9b0c with SMTP id k6-20020a05600c1c8600b003d1bad19b0cmr4208062wms.1.1672766059078;
        Tue, 03 Jan 2023 09:14:19 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:1ad8:6267:8f:ab55])
        by smtp.gmail.com with ESMTPSA id ay39-20020a05600c1e2700b003cfa80443a0sm42687417wmb.35.2023.01.03.09.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:14:18 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v3 stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  3 Jan 2023 18:14:15 +0100
Message-Id: <20230103171416.286579-1-jannh@google.com>
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
ugly hack for s390 and arm in <=4.19]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/tlb.h |  6 ++++++
 mm/khugepaged.c           | 15 +++++++++++++++
 mm/memory.c               |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 5e7e4aaf36c5..43409a047480 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -60,6 +60,12 @@ struct mmu_table_batch {
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
index f426d42d629d..6f8a1b423538 100644
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
@@ -1046,6 +1059,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1295,6 +1309,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				atomic_long_dec(&mm->nr_ptes);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
 			}
 			up_write(&mm->mmap_sem);
diff --git a/mm/memory.c b/mm/memory.c
index 615cb3fe763d..0136af15ba18 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -373,6 +373,11 @@ static void tlb_remove_table_smp_sync(void *arg)
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

base-commit: 179ef7fe86775fe32bd1bfe791887d1994ddcfb0
-- 
2.39.0.314.g84b9a713c41-goog

