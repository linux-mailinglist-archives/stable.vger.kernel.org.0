Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564BC685C55
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjBAApU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjBAApM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CFB51C6C;
        Tue, 31 Jan 2023 16:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED8AB81FCA;
        Wed,  1 Feb 2023 00:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14042C433EF;
        Wed,  1 Feb 2023 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212304;
        bh=Ge440yvx8mZjEWkMt9FTMGo5nRv1nmUf8kEwmDscsmo=;
        h=Date:To:From:Subject:From;
        b=ycD9gFE7WAyy7MaWrVW0zeDQq2HraP/nzqq2cEjKrOpyWwBjaIo5QSIBwSlGpBbFg
         Tr7/zPg6IQd6PZEoraLGJTgd7gpXDhIckWDeeJQdr1WJjcowaq4M0iPOy6ys3r7lqe
         URguN6fhlZ79tFWm3uCcCeG0M5zTewYMKX0UbEqE=
Date:   Tue, 31 Jan 2023 16:45:03 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matenajakub@gmail.com, fvogt@suse.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch removed from -mm tree
Message-Id: <20230201004504.14042C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm, mremap: fix mremap() expanding for vma's with vm_ops->close()
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix indenting whitespace, reflow comment]
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

 mm/mremap.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close
+++ a/mm/mremap.c
@@ -1027,16 +1027,29 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			}
 
 			/*
-			 * Function vma_merge() is called on the extension we are adding to
-			 * the already existing vma, vma_merge() will merge this extension with
-			 * the already existing vma (expand operation itself) and possibly also
-			 * with the next vma if it becomes adjacent to the expanded vma and
-			 * otherwise compatible.
+			 * Function vma_merge() is called on the extension we
+			 * are adding to the already existing vma, vma_merge()
+			 * will merge this extension with the already existing
+			 * vma (expand operation itself) and possibly also with
+			 * the next vma if it becomes adjacent to the expanded
+			 * vma and  otherwise compatible.
+			 *
+			 * However, vma_merge() can currently fail due to
+			 * is_mergeable_vma() check for vm_ops->close (see the
+			 * comment there). Yet this should not prevent vma
+			 * expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done
+			 * when a vma would be actually removed due to a merge.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
+			if (!vma->vm_ops || !vma->vm_ops->close) {
+				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
+				   vma->vm_pgoff, NULL)) {
+				vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
_

Patches currently in -mm which might be from vbabka@suse.cz are

revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

