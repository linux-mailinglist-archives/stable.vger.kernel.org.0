Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8352670EBC
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjARAiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjARAhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6016485B8;
        Tue, 17 Jan 2023 16:07:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EAF9614C7;
        Wed, 18 Jan 2023 00:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C012FC433EF;
        Wed, 18 Jan 2023 00:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674000473;
        bh=zEgxoZuXDfW7b0FlWsp+OR9JkLm/4LRtclBG8O/rpow=;
        h=Date:To:From:Subject:From;
        b=PKnu6qymQVMVinjsNAcrdGxnTZwcFDc47PZ4IY1CZjONuXN/zn41egu4ksNz7+skz
         fUczGZgHpfT39fMrDpyWrcFGJlpr0HAGV5zVjz8BfKGxV5EUBsk48vUEplyGml1mMZ
         vfuhVpi+u14/Sb6XpxdrCfgS9X7iAa0+ryNrdNrs=
Date:   Tue, 17 Jan 2023 16:07:53 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matenajakub@gmail.com, fvogt@suse.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch added to mm-hotfixes-unstable branch
Message-Id: <20230118000753.C012FC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, mremap: fix mremap() expanding for vma's with vm_ops->close()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mremap: fix mremap() expanding for vma's with vm_ops->close()
Date: Tue, 17 Jan 2023 11:19:39 +0100

Fabian has reported another regression in 6.1 due to ca3d76b0aa80 ("mm:
add merging after mremap resize").  The problem is that vma_merge() can
fail when vma has a vm_ops->close() method, causing is_mergeable_vma()
test to be negative.  This was happening for vma mapping a file from
fuse-overlayfs, which does have the method.  But when we are simply
expanding the vma, we never remove it due to the "merge" with the added
area, so the test should not prevent the expansion.

As a quick fix, check for such vmas and expand them using vma_adjust()
directly as was done before commit ca3d76b0aa80.  For a more robust long
term solution we should try to limit the check for vma_ops->close only to
cases that actually result in vma removal, so that no merge would be
prevented unnecessarily.

Link: https://lkml.kernel.org/r/20230117101939.9753-1-vbabka@suse.cz
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Fabian Vogt <fvogt@suse.com>
  Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
Tested-by: Fabian Vogt <fvogt@suse.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mremap.c~mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close
+++ a/mm/mremap.c
@@ -1032,11 +1032,22 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			 * the already existing vma (expand operation itself) and possibly also
 			 * with the next vma if it becomes adjacent to the expanded vma and
 			 * otherwise compatible.
+			 *
+			 * However, vma_merge() can currently fail due to is_mergeable_vma()
+			 * check for vm_ops->close (see the comment there). Yet this should not
+			 * prevent vma expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done when a vma would
+			 * be actually removed due to a merge.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
+			if (!vma->vm_ops || !vma->vm_ops->close) {
+				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
+                                   vma->vm_pgoff, NULL)) {
+				vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
_

Patches currently in -mm which might be from vbabka@suse.cz are

revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch
mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch

