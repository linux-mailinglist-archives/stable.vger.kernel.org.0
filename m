Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14FC6EC6AF
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 09:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjDXHDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 03:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjDXHCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 03:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0E61707
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 00:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E1961E4C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E1BC433EF;
        Mon, 24 Apr 2023 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682319759;
        bh=/4jEDpRiCyq+5CzBHzt65pPBz3UuQMYvZ3tSaRSPYQA=;
        h=Subject:To:Cc:From:Date:From;
        b=pzIBTUfnTxwAE9uwgrhsh8dFGjebT6olGZaYwqCBR0m65EyVVqe863sbaKFoek/IK
         nufI168INpJ6zf0kw7PVsIGlze/rAkG5JDMuPiJ40GCmwC0Xid8+EXMyDmZWkVfMVQ
         LWzJGZIUdo8yQQxMnzOazcBiYrrErdKVEChhT+Bo=
Subject: FAILED: patch "[PATCH] mm/mempolicy: fix use-after-free of VMA iterator" failed to apply to 6.1-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Apr 2023 09:02:36 +0200
Message-ID: <2023042436-smile-upwind-5931@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
git cherry-pick -x f4e9e0e69468583c2c6d9d5c7bfc975e292bf188
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042436-smile-upwind-5931@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

f4e9e0e69468 ("mm/mempolicy: fix use-after-free of VMA iterator")
9760ebffbf55 ("mm: switch vma_merge(), split_vma(), and __split_vma to vma iterator")
47d9644de92c ("nommu: convert nommu to using the vma iterator")
a27a11f92fe2 ("mm/mremap: use vmi version of vma_merge()")
076f16bf7698 ("mmap: use vmi version of vma_merge()")
0c0c5bffd0a2 ("mmap: pass through vmi iterator to __split_vma()")
178e22ac2078 ("madvise: use vmi iterator for __split_vma() and vma_merge()")
f10c2abcdac4 ("mempolicy: convert to vma iterator")
37598f5a9d8b ("mlock: convert mlock to vma iterator")
2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
11a9b90274f6 ("userfaultfd: use vma iterator")
f2ebfe43ba6c ("mm: add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()")
183654ce26a5 ("mmap: change do_mas_munmap and do_mas_aligned_munmap() to use vma iterator")
0378c0a0e9e4 ("mm/mmap: remove preallocation from do_mas_align_munmap()")
92fed82047d7 ("mm/mmap: convert brk to use vma iterator")
baabcfc93d3b ("mm/mmap: fix typo in comment")
c5d5546ea065 ("maple_tree: remove the parameter entry of mas_preallocate")
5ab0fc155dc0 ("Sync mm-stable with mm-hotfixes-stable to pick up dependent patches")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4e9e0e69468583c2c6d9d5c7bfc975e292bf188 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 10 Apr 2023 11:22:05 -0400
Subject: [PATCH] mm/mempolicy: fix use-after-free of VMA iterator

set_mempolicy_home_node() iterates over a list of VMAs and calls
mbind_range() on each VMA, which also iterates over the singular list of
the VMA passed in and potentially splits the VMA.  Since the VMA iterator
is not passed through, set_mempolicy_home_node() may now point to a stale
node in the VMA tree.  This can result in a UAF as reported by syzbot.

Avoid the stale maple tree node by passing the VMA iterator through to the
underlying call to split_vma().

mbind_range() is also overly complicated, since there are two calling
functions and one already handles iterating over the VMAs.  Simplify
mbind_range() to only handle merging and splitting of the VMAs.

Align the new loop in do_mbind() and existing loop in
set_mempolicy_home_node() to use the reduced mbind_range() function.  This
allows for a single location of the range calculation and avoids
constantly looking up the previous VMA (since this is a loop over the
VMAs).

Link: https://lore.kernel.org/linux-mm/000000000000c93feb05f87e24ad@google.com/
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/20230410152205.2294819-1-Liam.Howlett@oracle.com
Tested-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a256a241fd1d..2068b594dc88 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -790,61 +790,50 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 	return err;
 }
 
-/* Step 2: apply policy to a range and do splits. */
-static int mbind_range(struct mm_struct *mm, unsigned long start,
-		       unsigned long end, struct mempolicy *new_pol)
+/* Split or merge the VMA (if required) and apply the new policy */
+static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct vm_area_struct **prev, unsigned long start,
+		unsigned long end, struct mempolicy *new_pol)
 {
-	VMA_ITERATOR(vmi, mm, start);
-	struct vm_area_struct *prev;
-	struct vm_area_struct *vma;
-	int err = 0;
+	struct vm_area_struct *merged;
+	unsigned long vmstart, vmend;
 	pgoff_t pgoff;
+	int err;
 
-	prev = vma_prev(&vmi);
-	vma = vma_find(&vmi, end);
-	if (WARN_ON(!vma))
+	vmend = min(end, vma->vm_end);
+	if (start > vma->vm_start) {
+		*prev = vma;
+		vmstart = start;
+	} else {
+		vmstart = vma->vm_start;
+	}
+
+	if (mpol_equal(vma_policy(vma), new_pol))
 		return 0;
 
-	if (start > vma->vm_start)
-		prev = vma;
-
-	do {
-		unsigned long vmstart = max(start, vma->vm_start);
-		unsigned long vmend = min(end, vma->vm_end);
-
-		if (mpol_equal(vma_policy(vma), new_pol))
-			goto next;
-
-		pgoff = vma->vm_pgoff +
-			((vmstart - vma->vm_start) >> PAGE_SHIFT);
-		prev = vma_merge(&vmi, mm, prev, vmstart, vmend, vma->vm_flags,
-				 vma->anon_vma, vma->vm_file, pgoff,
-				 new_pol, vma->vm_userfaultfd_ctx,
-				 anon_vma_name(vma));
-		if (prev) {
-			vma = prev;
-			goto replace;
-		}
-		if (vma->vm_start != vmstart) {
-			err = split_vma(&vmi, vma, vmstart, 1);
-			if (err)
-				goto out;
-		}
-		if (vma->vm_end != vmend) {
-			err = split_vma(&vmi, vma, vmend, 0);
-			if (err)
-				goto out;
-		}
-replace:
-		err = vma_replace_policy(vma, new_pol);
+	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
+	merged = vma_merge(vmi, vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
+			 vma->anon_vma, vma->vm_file, pgoff, new_pol,
+			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	if (merged) {
+		*prev = merged;
+		return vma_replace_policy(merged, new_pol);
+	}
+
+	if (vma->vm_start != vmstart) {
+		err = split_vma(vmi, vma, vmstart, 1);
 		if (err)
-			goto out;
-next:
-		prev = vma;
-	} for_each_vma_range(vmi, vma, end);
+			return err;
+	}
 
-out:
-	return err;
+	if (vma->vm_end != vmend) {
+		err = split_vma(vmi, vma, vmend, 0);
+		if (err)
+			return err;
+	}
+
+	*prev = vma;
+	return vma_replace_policy(vma, new_pol);
 }
 
 /* Set the process memory policy */
@@ -1259,6 +1248,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 		     nodemask_t *nmask, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
@@ -1328,7 +1319,13 @@ static long do_mbind(unsigned long start, unsigned long len,
 		goto up_out;
 	}
 
-	err = mbind_range(mm, start, end, new);
+	vma_iter_init(&vmi, mm, start);
+	prev = vma_prev(&vmi);
+	for_each_vma_range(vmi, vma, end) {
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
+		if (err)
+			break;
+	}
 
 	if (!err) {
 		int nr_failed = 0;
@@ -1489,10 +1486,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		unsigned long, home_node, unsigned long, flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *prev;
 	struct mempolicy *new, *old;
-	unsigned long vmstart;
-	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
 	VMA_ITERATOR(vmi, mm, start);
@@ -1521,6 +1516,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
+	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
@@ -1541,9 +1537,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		}
 
 		new->home_node = home_node;
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
-		err = mbind_range(mm, vmstart, vmend, new);
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
 		if (err)
 			break;

