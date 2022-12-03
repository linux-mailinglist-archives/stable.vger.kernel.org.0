Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9E64166D
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLCLXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLCLXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:23:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB6810FC1
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0729560B85
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6AAC433C1;
        Sat,  3 Dec 2022 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066581;
        bh=8LaeEcp59GtaCF9XMyssQaS1xSFM22ZX/wnwd811vjY=;
        h=Subject:To:Cc:From:Date:From;
        b=A3ZxUvqqEmSNCNvmftEWLAF7ka3DCd+PMUTKtVohsd1OodqV8M+qs7ntKM488agNR
         dcS+74QEHlJ28mUoFTxG/Im66hHng7yZDE+Oq1B4HK9ajsChfE5Fu+BNBamt5DN1cq
         Q3r+fNYlZ+WmKBzIj9AyD2iub7ErEaT9zadvzvjU=
Subject: FAILED: patch "[PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED" failed to apply to 6.0-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com, david@redhat.com,
        harperchen1110@gmail.com, nadav.amit@gmail.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, riel@surriel.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:22:57 +0100
Message-ID: <167006657717429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

04ada095dcfc ("hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing")
21b85b09527c ("madvise: use zap_page_range_single for madvise dontneed")
ecfbd733878d ("hugetlb: take hugetlb vma_lock when clearing vma_lock->vma pointer")
131a79b474e9 ("hugetlb: fix vma lock handling during split vma and range unmapping")
40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
378397ccb8e5 ("hugetlb: create hugetlb_unmap_file_folio to unmap single file folio")
8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
12710fd69634 ("hugetlb: rename vma_shareable() and refactor code")
c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
7e1813d48dd3 ("hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache")
3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
763ecb035029 ("mm: remove the vma linked list")
8220543df148 ("nommu: remove uses of VMA linked list")
11f9a21ab655 ("mm/mmap: reorganize munmap to use maple states")
e99668a56430 ("mm/mmap: move mmap_region() below do_munmap()")
7964cf8caa4d ("mm: remove vmacache")
4dd1b84140c1 ("mm/mmap: use advanced maple tree API for mmap_region()")
abdba2dda0c4 ("mm: use maple tree operations for find_vma_intersection()")
2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04ada095dcfc4ae359418053c0be94453bdf1e84 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 14 Nov 2022 15:55:06 -0800
Subject: [PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and
the vm_lock is not deleted.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221114235507.294320-3-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cbfb489d381c..974ccca609d2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1868,6 +1868,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f1385c3b6c96..e36ca75311a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5206,17 +5206,22 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index 9bc5edc35725..8c8420934d60 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1711,7 +1711,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};

