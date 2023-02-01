Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDAB685C52
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjBAAo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBAAo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:44:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465F64F872;
        Tue, 31 Jan 2023 16:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F8C6174D;
        Wed,  1 Feb 2023 00:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9C3C433EF;
        Wed,  1 Feb 2023 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212294;
        bh=A0qtsdbL7FdT36rW6zPwE6xTx8j186CRVQ656AIKW+4=;
        h=Date:To:From:Subject:From;
        b=lhSCElndDZImqq7hiBsTKZ+jxpQyCXz2GP/QOJCDBwcduNj4famh7r/5xcKuLDohW
         Lx6WO6tlyNw7pqev4Ch/btfhr1S8ylWM72JkCBnj6G/DCvNSfmLxOFZVaccMCfH5Xq
         aXFvGI0aq/7qcJzFFY7dDHyK8QTJWdZXGjg5RhzM=
Date:   Tue, 31 Jan 2023 16:44:53 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stable@vger.kernel.org, shy828301@gmail.com,
        kirill.shutemov@intel.linux.com, david@redhat.com,
        jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-anon_vma-race.patch removed from -mm tree
Message-Id: <20230201004454.3C9C3C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix ->anon_vma race
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-anon_vma-race.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: fix ->anon_vma race
Date: Wed, 11 Jan 2023 14:33:51 +0100

If an ->anon_vma is attached to the VMA, collapse_and_free_pmd() requires
it to be locked.

Page table traversal is allowed under any one of the mmap lock, the
anon_vma lock (if the VMA is associated with an anon_vma), and the
mapping lock (if the VMA is associated with a mapping); and so to be
able to remove page tables, we must hold all three of them. 
retract_page_tables() bails out if an ->anon_vma is attached, but does
this check before holding the mmap lock (as the comment above the check
explains).

If we racily merged an existing ->anon_vma (shared with a child
process) from a neighboring VMA, subsequent rmap traversals on pages
belonging to the child will be able to see the page tables that we are
concurrently removing while assuming that nothing else can access them.

Repeat the ->anon_vma check once we hold the mmap lock to ensure that
there really is no concurrent page table access.

Hitting this bug causes a lockdep warning in collapse_and_free_pmd(),
in the line "lockdep_assert_held_write(&vma->anon_vma->root->rwsem)". 
It can also lead to use-after-free access.

Link: https://lore.kernel.org/linux-mm/CAG48ez3434wZBKFFbdx4M9j6eUwSUVPd4dxhzW_k_POneSDF+A@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230111133351.807024-1-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-anon_vma-race
+++ a/mm/khugepaged.c
@@ -1642,7 +1642,7 @@ static int retract_page_tables(struct ad
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma) {
+		if (READ_ONCE(vma->anon_vma)) {
 			result = SCAN_PAGE_ANON;
 			goto next;
 		}
@@ -1671,6 +1671,18 @@ static int retract_page_tables(struct ad
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
 			/*
+			 * Re-check whether we have an ->anon_vma, because
+			 * collapse_and_free_pmd() requires that either no
+			 * ->anon_vma exists or the anon_vma is locked.
+			 * We already checked ->anon_vma above, but that check
+			 * is racy because ->anon_vma can be populated under the
+			 * mmap lock in read mode.
+			 */
+			if (vma->anon_vma) {
+				result = SCAN_PAGE_ANON;
+				goto unlock_next;
+			}
+			/*
 			 * When a vma is registered with uffd-wp, we can't
 			 * recycle the pmd pgtable because there can be pte
 			 * markers installed.  Skip it only, so the rest mm/vma
_

Patches currently in -mm which might be from jannh@google.com are


