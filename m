Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6699644A1F
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiLFRQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiLFRQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:39 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91B2F24
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:37 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m19so11685079wms.5
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubdJCuH5kFmnXLiRXBD1CLTzDkiF2pzms1SkFrWFmC4=;
        b=Sw0E4Qa1A2uyX+0QpmaCzix1jLcv9Oe2mZtlI7MvV0OhEdKhzd4Y9RzIGlfuuuNsda
         J6hiOKSClX30z61ntL1vGmri/tYRojvTVthg6nsgUPn1nnoUjpLYqeERJf4vzlQC4KV8
         GzsjOoYYozGpJVZ+Sh2KkEgG+8xprR4/CwT/y7cwUhA7DIjaVCGJwseKO8UuPX0cgTiW
         AQRmplV1B868iViA8XU+nBKIRfcNDE58lyQuXVYTbyBejeHC0eaZqBFZrsKk97xd0n0d
         oUQMC6dNb+BfW0AZitfGzcuf3HVMpvJUBll36mA+AGblmxI2vkCXNjkqPacOBWIRysS3
         kBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubdJCuH5kFmnXLiRXBD1CLTzDkiF2pzms1SkFrWFmC4=;
        b=eEQZUsPZAed/oQnJdfskgDMJyYpaMImVSIuvZEpAvDZztIrLxdlhVlfSOTeKS3ju7F
         dq4TSlWM0Ak20+/608Jsue0r0PFP9QvhMFXxZKpCDRaDHIW25vKI7H+7HjEaTJAK/IxB
         2LYqFKKvj8NckA1l2fqybKXwJBNNynwCMTHvsBUilmRs104uvZK/T3n5EdU71ObT03xI
         XodylGFBXtr6uN9V/bobMdSI1x407bNb8fY0ZVY1xHHNkdXHQYfbCi6llMbaRP7GIrUk
         Jg58EpEbrypEjZWukqQC4uWJmiRMQMTjjP8WYYSlz1lFw2DcJ3V7GJQ3IdQM7gBBwQXq
         H9Uw==
X-Gm-Message-State: ANoB5pmfzxwKqOEEmM3SR47uGydwY2R4BufnmtxtscKk9JHsDZeP0/ZQ
        0Yca5n23zCOAKTqTjLoiRTpWB/v2L+X2PR7K
X-Google-Smtp-Source: AA0mqf6+LabElStuak0FhJ7uuwNuqHHptd9ZKT7FXNctSWt01qOBNU+M1lxqyZephUcypGn5BTQ0Dw==
X-Received: by 2002:a1c:740d:0:b0:3d1:ed5f:b8f2 with SMTP id p13-20020a1c740d000000b003d1ed5fb8f2mr2519261wmc.24.1670346996465;
        Tue, 06 Dec 2022 09:16:36 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c3b8900b003d1e1f421bfsm6597902wms.10.2022.12.06.09.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:35 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 4.19 1/2] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  6 Dec 2022 18:16:07 +0100
Message-Id: <20221206171614.1183048-6-jannh@google.com>
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
index 5dd14ef2e1de..561660966435 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1045,6 +1045,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1294,6 +1295,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
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
2.39.0.rc0.267.gcb52ba06e7-goog

