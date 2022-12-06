Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346B3644A1E
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiLFRQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbiLFRQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:36 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E25BDEA5
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:35 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so9332404wmb.5
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HBEQtTH4WI9RRzB5it1MzyhHvKP7347Hd62UXNEj30=;
        b=j8rXpLntmodAPOn28PQ6sgmacwbJxbVPsvMZH8N+shFRXfMtKlkvPnSTIxiIt519FR
         sWgfSYt0XMLtywMhZktRR4MRfwChzEXKhUTyO3SSNHhAQsZV0P1M/qeReiVYltSL6TuM
         /J7cWraNV+4HKmrW1r1o4ar0R4GZyb5rdxp9T1ZA2YLVSbTf9eCahHlgdm/J7bSpos3l
         934EUPI/e9uAxO61WKxxdXv1m/UbWWuDdaf4yjTv8lwEI3/ccqtkrFsgPD2Tg7r/3ahj
         kLxxiAV2MthLgCqR98N6eDsYZ6mS+dlsbl6yaNHpsl7wB/x8XvQfVvRhqHjk7GOJSZiH
         DhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HBEQtTH4WI9RRzB5it1MzyhHvKP7347Hd62UXNEj30=;
        b=qf8Pwq29YmUZrs+tbagEZJGJLee7wg9yiKXxbErC2k2E1bKfezknlV+0GUvm0hzSsx
         xrRb8v5kSSSex3ep2KsFOUFsGsGYXAYEpDkvx65lW5+xdUIDb7+yB/QzYKH4iheF7u78
         c77z2EfYptvrbb66RcdITss0sAWOfy95jytlaWgyPnN8/8Gix9JjG6MOF9xULQIPg4uo
         7Z/uAVeTn5UF5lEOruPXYSq8ESU2cWj+5bcWvKfL5U4ak9J4xu6w7o+i6L3NBnlvqdXf
         hLGdAs+mziX30aoP1KDTeI9V5ur2wgAzLOPZYGcxy0C9A6jsoWPwRCW/AFz2W/sW8hYs
         nNbw==
X-Gm-Message-State: ANoB5pkIB484rY73cQ+hesm2yPvQuwbNDVX5Gup/uX/v0MXvJqyHfKSf
        ZH9aPNyCn/jNSokHDAz3rTpzO/1dSXfc/A5f
X-Google-Smtp-Source: AA0mqf6GivKOXht39oGbWoYi729+QSACpnCQ5USmtiI/RiHXcSbtQip+vSI4/77a2QYdLC+Ifa5bOA==
X-Received: by 2002:a05:600c:3586:b0:3cf:a3b0:df6a with SMTP id p6-20020a05600c358600b003cfa3b0df6amr66518716wmq.126.1670346995042;
        Tue, 06 Dec 2022 09:16:35 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id n22-20020a7bc5d6000000b003c6c5a5a651sm21625301wmk.28.2022.12.06.09.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:34 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.10,5.15 1/3] mm/khugepaged: take the right locks for page table retraction
Date:   Tue,  6 Dec 2022 18:16:06 +0100
Message-Id: <20221206171614.1183048-5-jannh@google.com>
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

commit 8d3c106e19e8d251da31ff4cc7462e4565d65084 upstream.

pagetable walks on address ranges mapped by VMAs can be done under the
mmap lock, the lock of an anon_vma attached to the VMA, or the lock of the
VMA's address_space.  Only one of these needs to be held, and it does not
need to be held in exclusive mode.

Under those circumstances, the rules for concurrent access to page table
entries are:

 - Terminal page table entries (entries that don't point to another page
   table) can be arbitrarily changed under the page table lock, with the
   exception that they always need to be consistent for
   hardware page table walks and lockless_pages_from_mm().
   This includes that they can be changed into non-terminal entries.
 - Non-terminal page table entries (which point to another page table)
   can not be modified; readers are allowed to READ_ONCE() an entry, verify
   that it is non-terminal, and then assume that its value will stay as-is.

Retracting a page table involves modifying a non-terminal entry, so
page-table-level locks are insufficient to protect against concurrent page
table traversal; it requires taking all the higher-level locks under which
it is possible to start a page walk in the relevant range in exclusive
mode.

The collapse_huge_page() path for anonymous THP already follows this rule,
but the shmem/file THP path was getting it wrong, making it possible for
concurrent rmap-based operations to cause corruption.

Link: https://lkml.kernel.org/r/20221129154730.2274278-1-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-1-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-1-jannh@google.com
Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[manual backport: this code was refactored from two copies into a common
helper between 5.15 and 6.0]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dd069afd9cb9..fc02de08e912 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1456,6 +1456,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
+	/*
+	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
+	 * that got written to. Without this, we'd have to also lock the
+	 * anon_vma if one exists.
+	 */
+	if (vma->anon_vma)
+		return;
+
 	hpage = find_lock_page(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (!hpage)
@@ -1468,6 +1476,19 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		goto drop_hpage;
 
+	/*
+	 * We need to lock the mapping so that from here on, only GUP-fast and
+	 * hardware page walks can access the parts of the page tables that
+	 * we're operating on.
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+
+	/*
+	 * This spinlock should be unnecessary: Nobody else should be accessing
+	 * the page tables under spinlock protection here, only
+	 * lockless_pages_from_mm() and the hardware page walker can access page
+	 * tables while all the high-level locks are held in write mode.
+	 */
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 
 	/* step 1: check all mapped PTEs are to the right huge page */
@@ -1514,12 +1535,12 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
-	ptl = pmd_lock(vma->vm_mm, pmd);
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	pte_free(mm, pmd_pgtable(_pmd));
 
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
@@ -1527,6 +1548,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1575,7 +1597,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;
@@ -1597,10 +1620,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (mmap_write_trylock(mm)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
-				spin_unlock(ptl);
 				mm_dec_nr_ptes(mm);
 				pte_free(mm, pmd_pgtable(_pmd));
 			}

base-commit: e4a7232c917cd1b56d5b4fa9d7a23e3eabfecba0
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

