Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC18641668
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLCLW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLCLWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:22:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7C12D0E
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 280CD60BA3
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39608C433C1;
        Sat,  3 Dec 2022 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066569;
        bh=hoFgQOSf1oVMa/A6lX+ITr09Zh3jYIDOpfGTfwJxkiQ=;
        h=Subject:To:Cc:From:Date:From;
        b=uo6MzmAxe2a6BW6ReO6nXxEPk9TpoSsvyl1G0AgYyshyHU+tnWrpmS/FRtY+exPcx
         rvt6wRIO5V0UtT2vej9APIzrAZSrmGJW9yePilk6bNdtgODCn4rejcN/R5lkUopkVl
         QsRcbteytSSpzvR02WSfHvtiKXi34v6Erv9bLfaI=
Subject: FAILED: patch "[PATCH] mm/khugepaged: invoke MMU notifiers in shmem/file collapse" failed to apply to 4.19-stable tree
To:     jannh@google.com, akpm@linux-foundation.org, david@redhat.com,
        jhubbard@nvidia.com, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:22:34 +0100
Message-ID: <16700665542650@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f268f6cf875f ("mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths")
2ba99c5e0881 ("mm/khugepaged: fix GUP-fast interaction by sending IPI")
8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
780a4b6fb865 ("mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()")
b26e27015ec9 ("mm: thp: convert to use common struct mm_slot")
685405020b9f ("mm/khugepaged: stop using vma linked list")
7d2c4385c341 ("mm/khugepaged: rename prefix of shared collapse functions")
7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
507228044236 ("mm/khugepaged: record SCAN_PMD_MAPPED when scan_pmd() finds hugepage")
a7f4e6e4c47c ("mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()")
50ad2f24b3b4 ("mm/khugepaged: propagate enum scan_result codes back to callers")
9710a78ab2ae ("mm/khugepaged: dedup and simplify hugepage alloc and charging")
34d6b470ab9c ("mm/khugepaged: add struct collapse_control")
c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
1064026bab9f ("mm: khugepaged: reorg some khugepaged helpers")
7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
f707fa493784 ("mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f268f6cf875f3220afc77bdd0bf1bb136eb54db9 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Nov 2022 22:37:14 +0100
Subject: [PATCH] mm/khugepaged: invoke MMU notifiers in shmem/file collapse
 paths

Any codepath that zaps page table entries must invoke MMU notifiers to
ensure that secondary MMUs (like KVM) don't keep accessing pages which
aren't mapped anymore.  Secondary MMUs don't hold their own references to
pages that are mirrored over, so failing to notify them can lead to page
use-after-free.

I'm marking this as addressing an issue introduced in commit f3f0e1d2150b
("khugepaged: add support of collapse for tmpfs/shmem pages"), but most of
the security impact of this only came in commit 27e1f8273113 ("khugepaged:
enable collapse pmd for pte-mapped THP"), which actually omitted flushes
for the removal of present PTEs, not just for the removal of empty page
tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-3-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 294cb75d9c22..3703a56571c1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1399,6 +1399,7 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 				  unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd;
+	struct mmu_notifier_range range;
 
 	mmap_assert_write_locked(mm);
 	if (vma->vm_file)
@@ -1410,8 +1411,12 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 	if (vma->anon_vma)
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, addr,
+				addr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
 	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));

