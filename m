Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72CB6D8C6C
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjDFBHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjDFBG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F43D6EB8;
        Wed,  5 Apr 2023 18:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE06A6429A;
        Thu,  6 Apr 2023 01:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA2FC433EF;
        Thu,  6 Apr 2023 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743213;
        bh=Q2KyZRwXI/IMn+7Eg15coAdYibwrbWW+aDllMlbF5zQ=;
        h=Date:To:From:Subject:From;
        b=NBXxCTgkW/tZzQYoxGUnKa4khFJ2JibnZUFu8zdYvztruQ/eFVqniJj1NS/c+PgTk
         vpRfn1JKNShGth7ly7GBhlLr98g87DLpQnvziTo0XnbXurDO3OYq3C0N88A+jYzBnF
         y5Q/aq8Ewe0H8p0xpygs8D2H5/ji+kWxLGBuHuLA=
Date:   Wed, 05 Apr 2023 18:06:52 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-enable-maple-tree-rcu-mode-by-default.patch removed from -mm tree
Message-Id: <20230406010653.0CA2FC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: enable maple tree RCU mode by default
has been removed from the -mm tree.  Its filename was
     mm-enable-maple-tree-rcu-mode-by-default.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: enable maple tree RCU mode by default
Date: Mon, 27 Feb 2023 09:36:07 -0800

Use the maple tree in RCU mode for VMA tracking.

The maple tree tracks the stack and is able to update the pivot
(lower/upper boundary) in-place to allow the page fault handler to write
to the tree while holding just the mmap read lock.  This is safe as the
writes to the stack have a guard VMA which ensures there will always be a
NULL in the direction of the growth and thus will only update a pivot.

It is possible, but not recommended, to have VMAs that grow up/down
without guard VMAs.  syzbot has constructed a testcase which sets up a VMA
to grow and consume the empty space.  Overwriting the entire NULL entry
causes the tree to be altered in a way that is not safe for concurrent
readers; the readers may see a node being rewritten or one that does not
match the maple state they are using.

Enabling RCU mode allows the concurrent readers to see a stable node and
will return the expected result.

[Liam.Howlett@Oracle.com: we don't need to free the nodes with RCU[
Link: https://lore.kernel.org/linux-mm/000000000000b0a65805f663ace6@google.com/
Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 ++-
 kernel/fork.c            |    3 +++
 mm/mmap.c                |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~mm-enable-maple-tree-rcu-mode-by-default
+++ a/include/linux/mm_types.h
@@ -774,7 +774,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
--- a/kernel/fork.c~mm-enable-maple-tree-rcu-mode-by-default
+++ a/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(str
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(vmi.mas.tree);
 	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
@@ -700,6 +701,8 @@ static __latent_entropy int dup_mmap(str
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	vma_iter_free(&vmi);
+	if (!retval)
+		mt_set_in_rcu(vmi.mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
--- a/mm/mmap.c~mm-enable-maple-tree-rcu-mode-by-default
+++ a/mm/mmap.c
@@ -2277,7 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
+	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	/*
@@ -3037,6 +3037,7 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
+	mt_clear_in_rcu(&mm->mm_mt);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


