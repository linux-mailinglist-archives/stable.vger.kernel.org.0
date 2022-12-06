Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12E2644A23
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiLFRQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiLFRQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:41 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B543122F
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:40 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so8489553wms.4
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOUdhr1dh+grWuaf+aq2Tkgty88QTtu3Eg9j92eTQ5k=;
        b=rDjsimYqhMHEihgNVX/TP3s8Zp63a06Xl7GDnZEI1n932GwV9vDdcuVeXLdkit8srs
         dXtW91WvVRsKzt5d4ENdck78h87z4I4l0G9Axd0CXBhZriwivrTpuz/0EUJiHasQUYt2
         Vq7l5lEiNbjnoTc+5fBym0k+KfPkAkptQcUOU5b+HIZ7dl26MyGWhXSVxf4LAQJtW4E/
         ktDUdZWfsVYONHmxamOISsEC1yHDmN6Q+9yQcIpLgE1RtdM9f/OLnteVTmaZxvvjI7Je
         4QlYtil6aSNzqkGDjTYKUrQj3FgWXUeo7RPUZl2bxDSx0cQQh5CzAfW46HTaRzh3uKZo
         OphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOUdhr1dh+grWuaf+aq2Tkgty88QTtu3Eg9j92eTQ5k=;
        b=8NzEZEQDoglgTu0kxdG6CrYUeRmaDLyoOat2mUOvjokgDHDHKeAdYwBW5b1KyfcLqo
         X1xaoLRFncUDa4a1yFAQKPM9lRX5jYfdZmLjrmyrCISavwmtxstZ5alMNVYIOnlnz1nG
         YZTb16AEog8rNQ0JERF5J43hlt1adzouXts7wxw4zPskh9M9/D6KkCFdWNpvY9WiANRm
         mlx4Wmz5WEeGs7/28fgxKhkYFUysqNwuPt8e0gYm2ONyQCrQ9g+m3i/cAeS6uSHdCUfI
         iOiD333FkNtzVTYhdOwip/ujbVRmB9+vzDlW8/2PAXaSgNPtWOPM8NNcNzgRmgrmzYUN
         N6yg==
X-Gm-Message-State: ANoB5plwqWLU/iyycN0vR4pAZA/3+pr3MwebM9pw7ulvizuy//ey9lRH
        Kd3ylMxd+jNQCS8cJewI4rz+C3/SpNGSPplv
X-Google-Smtp-Source: AA0mqf778nU4ZvY6By27sEcc1M1cnOhD1WlaXxlk6m1XK5QXMtaM7F7cAmGKGFTbVr4OpzhTa6IjzA==
X-Received: by 2002:a05:600c:35c7:b0:3cf:7dc1:f432 with SMTP id r7-20020a05600c35c700b003cf7dc1f432mr65630304wmq.148.1670346999225;
        Tue, 06 Dec 2022 09:16:39 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003b435c41103sm32984394wmo.0.2022.12.06.09.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:38 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.4 2/3] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date:   Tue,  6 Dec 2022 18:16:09 +0100
Message-Id: <20221206171614.1183048-8-jannh@google.com>
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
TLB flushing was refactored between 5.4 and 5.10]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/tlb.h | 4 ++++
 mm/khugepaged.c           | 3 +++
 mm/mmu_gather.c           | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 268674c1d568..b06240b67199 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -190,12 +190,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 55631cd73939..a8f2605cbd0d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1060,6 +1060,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1407,6 +1408,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	/* step 4: collapse pmd */
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	mm_dec_nr_ptes(mm);
+	tlb_remove_table_sync_one();
 	pte_free(mm, pmd_pgtable(_pmd));
 
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
@@ -1494,6 +1496,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				mm_dec_nr_ptes(mm);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
 			}
 			up_write(&mm->mmap_sem);
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7c1b8f67af7b..341aa036b03c 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -117,6 +117,11 @@ static void tlb_remove_table_smp_sync(void *arg)
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
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

