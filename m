Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E616633D0
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 23:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbjAIWSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 17:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbjAIWSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 17:18:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A71B13FAD;
        Mon,  9 Jan 2023 14:18:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9712D6145F;
        Mon,  9 Jan 2023 22:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5594C433EF;
        Mon,  9 Jan 2023 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302684;
        bh=WvWj+CDKP6etywwios3PWJBhPDZndmqH4LK9SXqtj68=;
        h=Date:To:From:Subject:From;
        b=0bFTBA35NJbb6huD6fjDn9x8usFbjTR4TO7W1p1bVz+6oBVXFLv5+qCpGlGsbOXtS
         8/CyMaSJT/9uwvh/cHHW3Gz6iLpnB1K4HkNvA6Utj+P6q0ocXRSKVxMH4n5H2pWIYE
         P83gR+63+SwqvvNFExYq2tX2ysoNiXxc1Vp0Bs1c=
Date:   Mon, 09 Jan 2023 14:18:04 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-fix-split_vma-map_count-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20230109221804.D5594C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nommu: fix split_vma() map_count error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nommu-fix-split_vma-map_count-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-fix-split_vma-map_count-error.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: nommu: fix split_vma() map_count error
Date: Mon, 9 Jan 2023 20:58:20 +0000

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Link: https://lkml.kernel.org/r/20230109205809.956325-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-fix-split_vma-map_count-error
+++ a/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struc
 
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
-	mm->map_count++;
 	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_
 	BUG_ON(!vma->vm_region);
 
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
 
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, stru
 	if (vma->vm_file)
 		return -ENOMEM;
 
+	mm = vma->vm_mm;
 	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, stru
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
 
 err_mas_preallocate:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

