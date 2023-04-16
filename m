Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757166E3ABF
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjDPRmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjDPRmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522753AA6;
        Sun, 16 Apr 2023 10:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB2B361C50;
        Sun, 16 Apr 2023 17:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBD5C433EF;
        Sun, 16 Apr 2023 17:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666921;
        bh=nbcx+rBf27WKgaKNqhmziYjicI21uzQ3DvXeLQafkrg=;
        h=Date:To:From:Subject:From;
        b=F5MCFXPFEUIB4vYJBIl/DSYqnaVcd73PdfaH2QbPVVrrT9Kvds9zvBYI8dxc+CUnW
         NzIySw4siXu4YH5k6LZpMcz6mYfhzzQwCZ8pshdRjXaj2wB+XeuOVQeOUu9eAeuwD6
         AywKTfxc30qJKR3HinZUmo62QbuK8bRNhF2lpjfE=
Date:   Sun, 16 Apr 2023 10:42:00 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-use-after-free-of-vma-iterator.patch removed from -mm tree
Message-Id: <20230416174201.1DBD5C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix use-after-free of VMA iterator
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-use-after-free-of-vma-iterator.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mempolicy: fix use-after-free of VMA iterator
Date: Mon, 10 Apr 2023 11:22:05 -0400

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
---

 mm/mempolicy.c |  102 ++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 54 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-use-after-free-of-vma-iterator
+++ a/mm/mempolicy.c
@@ -790,61 +790,50 @@ static int vma_replace_policy(struct vm_
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
+	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
+	merged = vma_merge(vmi, vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
+			 vma->anon_vma, vma->vm_file, pgoff, new_pol,
+			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	if (merged) {
+		*prev = merged;
+		return vma_replace_policy(merged, new_pol);
+	}
 
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
@@ -1259,6 +1248,8 @@ static long do_mbind(unsigned long start
 		     nodemask_t *nmask, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
@@ -1328,7 +1319,13 @@ static long do_mbind(unsigned long start
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
@@ -1489,10 +1486,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
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
@@ -1521,6 +1516,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
+	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
@@ -1541,9 +1537,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		}
 
 		new->home_node = home_node;
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
-		err = mbind_range(mm, vmstart, vmend, new);
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
 		if (err)
 			break;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-make-maple-state-reusable-after-mas_empty_area_rev.patch
maple_tree-fix-mas_empty_area-search.patch
mm-mmap-regression-fix-for-unmapped_area_topdown.patch

