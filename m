Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C076DDCA6
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDKNsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjDKNr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566E735B3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2804561FA4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D71C433EF;
        Tue, 11 Apr 2023 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220861;
        bh=q3Q3ypdYc664YorNtodkU4TWKws+eUMdK1R3ptNec5s=;
        h=Subject:To:Cc:From:Date:From;
        b=yvYKKQYTfTtgJrP+HOEJpDtRFduMnWd1dXc+GdIxjVADmp2VdYCcD5U1QP0xYFY4v
         wdwXRjV3zH/Ma7zULlalyujgnb4NNjqLWIPr9OfVxj45eyhMjrdsE5C2X/7cx0OGRL
         r6bh7aS2qP9kggXAdXOGgRLg82J8ALK7Wl3PeJy4=
Subject: FAILED: patch "[PATCH] mm: enable maple tree RCU mode by default" failed to apply to 6.1-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, surenb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:47:39 +0200
Message-ID: <2023041138-delay-translate-7f35@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 3dd4432549415f3c65dd52d5c687629efbf4ece1
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041138-delay-translate-7f35@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

3dd443254941 ("mm: enable maple tree RCU mode by default")
3b9dbd5e91b1 ("kernel/fork: convert forking to using the vmi iterator")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3dd4432549415f3c65dd52d5c687629efbf4ece1 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:07 -0800
Subject: [PATCH] mm: enable maple tree RCU mode by default

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

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 0722859c3647..a57e6ae78e65 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -774,7 +774,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
diff --git a/kernel/fork.c b/kernel/fork.c
index c0257cbee093..0c92f224c68c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(vmi.mas.tree);
 	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
@@ -700,6 +701,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	vma_iter_free(&vmi);
+	if (!retval)
+		mt_set_in_rcu(vmi.mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
diff --git a/mm/mmap.c b/mm/mmap.c
index ad499f7b767f..ff68a67a2a7c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2277,7 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
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

