Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825636DEF0A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjDLIrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjDLIq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B419746
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E60B63090
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B00C4339B;
        Wed, 12 Apr 2023 08:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289176;
        bh=1HKHTnioBqhIecFAvO85C+FIo2QjsHhQJpAl8NQzCmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZIukoKLQitQ+rXtzzxcmULp4gaIhX7IDQS+jJoUeutOblsk7R6BEXNIgWa1EhyuO
         mVp9oTuTC3MOrvMFv6mznjwvq6KTqFFH700XulQFvxMXSAMO4ttksznZ5s4WEwydJ/
         daMO6HStqI7NcWSNAHlbQBNn4K6R09q/g4KZqYoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: [PATCH 6.1 164/164] mm: enable maple tree RCU mode by default.
Date:   Wed, 12 Apr 2023 10:34:46 +0200
Message-Id: <20230412082843.570250345@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 3dd4432549415f3c65dd52d5c687629efbf4ece1 upstream.

Use the maple tree in RCU mode for VMA tracking.

The maple tree tracks the stack and is able to update the pivot
(lower/upper boundary) in-place to allow the page fault handler to write
to the tree while holding just the mmap read lock.  This is safe as the
writes to the stack have a guard VMA which ensures there will always be
a NULL in the direction of the growth and thus will only update a pivot.

It is possible, but not recommended, to have VMAs that grow up/down
without guard VMAs.  syzbot has constructed a testcase which sets up a
VMA to grow and consume the empty space.  Overwriting the entire NULL
entry causes the tree to be altered in a way that is not safe for
concurrent readers; the readers may see a node being rewritten or one
that does not match the maple state they are using.

Enabling RCU mode allows the concurrent readers to see a stable node and
will return the expected result.

Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Cc: stable@vger.kernel.org
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_types.h |    3 ++-
 kernel/fork.c            |    3 +++
 mm/mmap.c                |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -725,7 +725,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(str
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(mas.tree);
 	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
 		struct file *file;
 
@@ -703,6 +704,8 @@ static __latent_entropy int dup_mmap(str
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	mas_destroy(&mas);
+	if (!retval)
+		mt_set_in_rcu(mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2308,7 +2308,7 @@ do_mas_align_munmap(struct ma_state *mas
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
+	mt_init_flags(&mt_detach, mas->tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	if (mas_preallocate(mas, vma, GFP_KERNEL))
@@ -3095,6 +3095,7 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
+	mt_clear_in_rcu(&mm->mm_mt);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);


