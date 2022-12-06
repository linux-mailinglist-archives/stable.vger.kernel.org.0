Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52689644A28
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiLFRQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiLFRQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:43 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9872A2188D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h7so18446981wrs.6
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OaAmQXAs83LzKVULcjbslFjV8rvHhPGLsF3bKfA4/l8=;
        b=bM3JHH4/K4ndiTGLY1wrQzDVuCfhj3NVNjgdDeXnhv051U9+GZiSjgAdsTKXKjKSI2
         AIRQSSrxort1ei2GIklKgaGrw16jUiRc2qYUO6XdoTDgzqS0NeeFUAMekvB6ekwA0k/y
         h3FD1BcmslYW7DKyfCrLlHNbz5VJCicXX4ERa/WgnqIr4jAANIMzcTPKEjr3EgSYEcbt
         S7e5ObinM/D9hmZlkiVlLbpCA13GW+3VzAcn99EZZXqfKg77rADUv8Hu3m5yEEinD2aW
         6bnlgiGALTS8nKY4nn4ufD8N7G9cAehkBzWYaRpa9aLamoW2BXx+1TJDuiA2+WZ/4bpt
         BhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OaAmQXAs83LzKVULcjbslFjV8rvHhPGLsF3bKfA4/l8=;
        b=hYxnUDMUWutCvCbsz2UAZ7gu5mv3zYPMnvoieLY5WO1RSlRYGeQKiZNbyVMS0S9g7G
         J7+nQkV8hcj98EulqW4zML9oM/j8rWDhmwQ48llAPdLzGM9Up5/dzHKTOHc/EF4gqf//
         68tKnmEEUIakL2/bL5lQ3KgN7phz+yvJe+GEp2Fs+2VbDN064cqeEbegdb7E+ASLzj6P
         USR7kJqRV56bd63Ldb+ytUIOJv2wQtneVRxHkcd+hRrVpRllAcUkl4JIc2MLSyl1YIw6
         w3wDkNHXITURM7RIpOtt48bDkkUCLS1EwijNu5JEsVVGLtEgEvgRRX1VWnpfqrma3Hx8
         uArw==
X-Gm-Message-State: ANoB5plq6TIQaGqhc1zaUbnwbZmcjicpPL7HD5J/QBCR+L2mJs4LCjSU
        G3CtkJstYjygNtiLgL5t+DBdPbfukhB6VnY3
X-Google-Smtp-Source: AA0mqf4v+A8ev6spjcK8ZsBXEXZ3pRkM7NSMw6JAeoC9g39cTHmg7o2Dgcc0LV2mDOFfDYMrbHnZ2g==
X-Received: by 2002:adf:de08:0:b0:242:1d2c:9d78 with SMTP id b8-20020adfde08000000b002421d2c9d78mr23340116wrm.490.1670347002129;
        Tue, 06 Dec 2022 09:16:42 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id fc13-20020a05600c524d00b003d04e4ed873sm29390894wmb.22.2022.12.06.09.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:41 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.4 1/3] mm/khugepaged: take the right locks for page table retraction
Date:   Tue,  6 Dec 2022 18:16:11 +0100
Message-Id: <20221206171614.1183048-10-jannh@google.com>
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
index 3c2326568193..55631cd73939 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1326,6 +1326,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1338,6 +1346,19 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1384,12 +1405,12 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1397,6 +1418,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1446,7 +1468,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;
@@ -1468,10 +1491,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
-				spin_unlock(ptl);
 				mm_dec_nr_ptes(mm);
 				pte_free(mm, pmd_pgtable(_pmd));
 			}

base-commit: 4d2a309b5c28a2edc0900542d22fec3a5a22243b
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

