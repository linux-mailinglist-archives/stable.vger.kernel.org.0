Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA12644A2C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiLFRRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiLFRQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4A37224
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:47 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bs21so24463994wrb.4
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x1CqxI0HpeVDXX6FMU4Ckb2JIgDkd9iGn0EoJqKXun8=;
        b=iXqPSEmN2IgROTosYbQ3NEsjoRhsRUeac7h0KKjZ1DmwXeJ5CsC+I/YpGnVyRb1Cry
         05bOa7atji+MHqS3FZ15Bk1ZMrNDztUU94PlxlhqtSNSZRTRVaR/BQG/SLmmohzA0asn
         EOrQVI1P+2BeuOlgYmpznep0jN9uDTVh+2qwJS8UlBqneFGec3WZFpp2GAlE3rG1XPCm
         n+zubtr3pZ65ldb0MLic0+WSw7tHPyFvA/+Y3amuic9Yl23jYMleW9Styw+rg2Audn+u
         cQSwQufvMUyDGWxS4DZ0HKTKqwvGR+TgX/qO4KOPhXV6O1rU73X6rNljVMqTZ5ClM8bd
         aofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1CqxI0HpeVDXX6FMU4Ckb2JIgDkd9iGn0EoJqKXun8=;
        b=ebspoW/bHmbfENoce9uGgoK7sQ0vx5JTNjN1bB/HesZklRbDS+7h/I9ekiIacHQEuc
         w1KiOSXMzAKhZoTQCYx8LDiI+wA6UkmR33fQ6dQ7LFmwvnT59Smlwe4Yki2G+TALUUvD
         cPuo/iJ55x3BQyv0dwdbLZBrUPn1K1ymtyqm7dj84WvBmjlfg4huQrEA19W3cwhUdFnJ
         3LvvZZp7nLgWbqH6v027rsh7cf3FEo9imR3Yc4EcO9LVPQN6pFibYfkeh+1YjQNWfrak
         7fPvoltMMZbcolrZR+knwEKHYehwj3gOhH8cer/waNQezepwaLfiXaLZSLu2QFKFXx4W
         wcaQ==
X-Gm-Message-State: ANoB5pkCY1J9R5zZCEsJSDSojw+YryC+Br5wiN7xjTBVEJqzfNfsixaM
        DOu36n1txe0ZkJaGjhR5cChjAvOEQoFK4wqG
X-Google-Smtp-Source: AA0mqf6luj4+x+XHLboxjSLoH0RqNzAtNDpy5HJG6n8GRtB0lUjYedzBdFZh2R0r/kP6F1uj5fqLTA==
X-Received: by 2002:a5d:6749:0:b0:242:6666:9111 with SMTP id l9-20020a5d6749000000b0024266669111mr5461292wrw.530.1670347006175;
        Tue, 06 Dec 2022 09:16:46 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003b4fe03c881sm28051607wmq.48.2022.12.06.09.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:45 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 6.0 1/3] mm/khugepaged: take the right locks for page table retraction
Date:   Tue,  6 Dec 2022 18:16:14 +0100
Message-Id: <20221206171614.1183048-13-jannh@google.com>
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
[backport fixed up manually: collapse_pte_mapped_thp returns different
type]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 56 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 70b7ac66411c..28d8459d7aae 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1360,16 +1360,37 @@ static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
 	spin_unlock(&khugepaged_mm_lock);
 }
 
+/*
+ * A note about locking:
+ * Trying to take the page table spinlocks would be useless here because those
+ * are only used to synchronize:
+ *
+ *  - modifying terminal entries (ones that point to a data page, not to another
+ *    page table)
+ *  - installing *new* non-terminal entries
+ *
+ * Instead, we need roughly the same kind of protection as free_pgtables() or
+ * mm_take_all_locks() (but only for a single VMA):
+ * The mmap lock together with this VMA's rmap locks covers all paths towards
+ * the page table entries we're messing with here, except for hardware page
+ * table walks and lockless_pages_from_mm().
+ */
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t *pmdp)
 {
-	spinlock_t *ptl;
 	pmd_t pmd;
 
 	mmap_assert_write_locked(mm);
-	ptl = pmd_lock(vma->vm_mm, pmdp);
+	if (vma->vm_file)
+		lockdep_assert_held_write(&vma->vm_file->f_mapping->i_mmap_rwsem);
+	/*
+	 * All anon_vmas attached to the VMA have the same root and are
+	 * therefore locked by the same lock.
+	 */
+	if (vma->anon_vma)
+		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
+
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
-	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
@@ -1410,6 +1431,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false, false))
 		return;
 
+	/*
+	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
+	 * that got written to. Without this, we'd have to also lock the
+	 * anon_vma if one exists.
+	 */
+	if (vma->anon_vma)
+		return;
+
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return;
@@ -1426,6 +1455,20 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		goto drop_hpage;
 
+	/*
+	 * We need to lock the mapping so that from here on, only GUP-fast and
+	 * hardware page walks can access the parts of the page tables that
+	 * we're operating on.
+	 * See collapse_and_free_pmd().
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
@@ -1476,6 +1519,9 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 	/* step 4: collapse pmd */
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
+
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
@@ -1483,6 +1529,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1531,7 +1578,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;

base-commit: 31e4bdd2c25b50bca6d96995abb01a54ba5bd00e
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

