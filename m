Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17A644A1A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiLFRQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiLFRQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:26 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69124DEA5
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:25 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h7so18445647wrs.6
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5y5pHsTfKWlf6G9xhN6zIJC+yiHVz8mgRid+lBAfjKI=;
        b=cSBwdOzjkGnRh5BdlBn4eECWGdsafj0JSyCwgySbNNTiYAA7WvDTxqSfKNrb6FeQuk
         8fEdgI97uKlziLEWdN32I83u39j+SgVYPH/QHcuspRX2KkD9q9wfqfZ6fLqVYagVG5Lc
         MBxy9Rapg+Gnxw6+9h3NMylMkv0/wujORFyPwyPsI1pFgDHaAC+JwxmB4kiNOSdcCITU
         YFCcSiDDaZgwa9h7zoyJlT2RdOL6VOX2BOWOml47fFgo/xiONE2Mn+bztcz6fXoTqqy3
         KCess+OuTbSqMukP6CeexUqDQ/5WqQuOGHF0tcRNI3IbIDkojwW7iEjaYam6rFttiWz1
         QSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5y5pHsTfKWlf6G9xhN6zIJC+yiHVz8mgRid+lBAfjKI=;
        b=egFfYAJBUtitPc433gHChoz52kKc/FUNShw+rxCbsAtGNadVYI1R7XoK3MJ/7LR1Ju
         3PsInqrYxwkHFkoHYq9jzK+FBsFg5mLF398MGs9SMG5n20BGOTJESaWjj+ECvw0FQcsJ
         38hFHpZIqSsabLAT/8cqs+SZptXNSzP8x9xOeP/pceUCqX02fMNeb5ga1+jx9pqI2qsA
         gNU1rSv7RogamZxeys1ho/qmXAreoS7Xa6B10+7hvxBAV9/BzVSM1pWsGsTzLLUTYOJi
         G8BkwQX3SVInuELHGtVLuPwNBp31pkOmJz4m8nU8nB6GzJZ2kRCbsOWVLnUIx6qvlAAr
         +CHQ==
X-Gm-Message-State: ANoB5pmlUTKIWos1s2fAKpW/Tmx0J2xFS66Sg4CVqr0wGCPwHlrLMVx1
        MtjDja8JKFYuf3+XO9Tm2Qnle8u8zxcJdfR+
X-Google-Smtp-Source: AA0mqf43yyiyCx+eRgcDtKaL/MGiZCM90oVb4NCLMpkwNbV2ruxbQtxgvOz9Fz4Ilwk3iiQbbBJKVg==
X-Received: by 2002:a05:6000:1e0c:b0:242:3fa4:820d with SMTP id bj12-20020a0560001e0c00b002423fa4820dmr12591498wrb.564.1670346983906;
        Tue, 06 Dec 2022 09:16:23 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id z10-20020adfec8a000000b00236576c8eddsm17309207wrn.12.2022.12.06.09.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:23 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  6 Dec 2022 18:16:02 +0100
Message-Id: <20221206171614.1183048-1-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
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
ptes were refactored into a common helper between 5.15 and 6.0;
TLB flushing was refactored between 5.4 and 5.10;
TLB flushing was refactored between 4.19 and 5.4;
pmd collapse for PTE-mapped THP was only added in 5.4]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/tlb.h | 6 ++++++
 mm/khugepaged.c           | 2 ++
 mm/memory.c               | 5 +++++
 3 files changed, 13 insertions(+)

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
index f426d42d629d..f67c02010add 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1046,6 +1046,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1295,6 +1296,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
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
2.39.0.rc0.267.gcb52ba06e7-goog

