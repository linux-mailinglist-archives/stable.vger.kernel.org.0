Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AA264A5EE
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLLRcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiLLRct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:32:49 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D746C2AF1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:47 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m14so12868697wrh.7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zzd+cgReRd/cuQfkZZ0Iv9J00C4W11v+MMtiDRkq67A=;
        b=Jsmqpq5C3Cd73HscgOpj8RSN93M4QWCeiA2xm31Gx31GaRH1ZvO2vepUrt3wQgaKql
         sYoFCrWW+613Ew9CwIro3GE8UuX0yRVCsE/QTWCQMFSmzrcXn8M3A/QYoNbev4XKcpxA
         fvXtMRUNQB7+/SK+/DpDn4i2IrdF4e+4TEfziBJSxJLpCZMSzzpAi74Eq4oyEIihlbu3
         1H+ZdCCxOAo0zHGTmSbrrcfHZfj2Rihmd+NYICNl/MbTZjMfBmNqVgBnUBKXyAfbDj49
         CK+XF0dHMdhNbVPPrmkAij7hhLrMBQaCZepj+5IpZgDTtTqKS6swGZ1yg9U89hKt9w/+
         xnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zzd+cgReRd/cuQfkZZ0Iv9J00C4W11v+MMtiDRkq67A=;
        b=3lEBDe0zzqJQEQEV9EqNYEvXSrgiHTDhckCYE/LZRXI/UlM5AgrER7iTXv3V8nECPN
         mdtIZ/c2DPIufyQeqrMY100ABP2AGUnGD2iYvSLOHcR9SqCdPOH5h6tNpRlj6WgODcqy
         MvDgLN94EBk8GeNkIHOtioirN+HAaoiknxV8Fmj+3qqP1pkv11t2ESVemhruk8Sl5se7
         dhJnHns/YBPw0F5waw5vz6dFfp3n3o9AKwcOB6mIb52JpExke7r2RXIIkWO0VxWGIFzP
         fKBodRH56hjHRKLRXCT90YIkUpsWBWI3UHhEQKd0etNixXKdNKR5SNYRjlazpO7JPWxl
         0WQA==
X-Gm-Message-State: ANoB5pnoPqgwRy39R1EOR0tAJI7yLd0Tpn55R6Gyn58osceSQU6MoP2D
        sj18kTf8vkQIE6VAtwInAP8kUM3pu4Q1JsFe
X-Google-Smtp-Source: AA0mqf7HJpYBR7mzXwQ5UoOn2OJTvTexBaqnuPF7FpKxXOf7zGH9rcffNVUpvaVrkT5s/SiO4qc3Yw==
X-Received: by 2002:a5d:5f04:0:b0:24b:b245:9f06 with SMTP id cl4-20020a5d5f04000000b0024bb2459f06mr738242wrb.1.1670866366392;
        Mon, 12 Dec 2022 09:32:46 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d108:797c:2f44:5af6])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c378f00b003c6d21a19a0sm9870274wmr.29.2022.12.12.09.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:32:45 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Mon, 12 Dec 2022 18:32:37 +0100
Message-Id: <20221212173238.963128-3-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
In-Reply-To: <20221212173238.963128-1-jannh@google.com>
References: <20221212173238.963128-1-jannh@google.com>
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
ugly hack for s390 in <=4.19]
Signed-off-by: Jann Horn <jannh@google.com>
---
added an incredibly ugly hack to work around the s390 issue reported in
https://lore.kernel.org/all/Y5aaQqNH71IMVks0@sashalap/

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
index f426d42d629d..7825f3af5c6d 100644
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
2.39.0.rc1.256.g54fd8350bd-goog

