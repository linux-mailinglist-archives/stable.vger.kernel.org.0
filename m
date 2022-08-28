Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F805A3FC6
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiH1VD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 17:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiH1VD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 17:03:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA353120C;
        Sun, 28 Aug 2022 14:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C6B3B80B89;
        Sun, 28 Aug 2022 21:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC75C433D7;
        Sun, 28 Aug 2022 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720601;
        bh=XR+f1lVMHhgMUaOW+WCvuPO9jHdNQFbLO30svzTiwXI=;
        h=Date:To:From:Subject:From;
        b=ExuMOSWXdwMKlXuXkl1qixs/7lXpSn7G7qoupx1c3blUujZzF5NNFx3b24Jhlrxii
         K7Zncpjij+tNUb0jAlr9OiQFKTT5Vt3wuNWjnDvtsCBNxJazPC5oLj4WQHgkhhcUVE
         pQjXrwOLzo2ZgeiOSDhB67LlowGXuin/zAIPU1VU=
Date:   Sun, 28 Aug 2022 14:03:20 -0700
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        stable@vger.kernel.org, hughd@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-update-folio-if-shmem_replace_page-updates-the-page.patch removed from -mm tree
Message-Id: <20220828210321.1FC75C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: shmem: update folio if shmem_replace_page() updates the page
has been removed from the -mm tree.  Its filename was
     shmem-update-folio-if-shmem_replace_page-updates-the-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: update folio if shmem_replace_page() updates the page
Date: Sat, 30 Jul 2022 05:25:18 +0100

If we allocate a new page, we need to make sure that our folio matches
that new page.

If we do end up in this code path, we store the wrong page in the shmem
inode's page cache, and I would rather imagine that data corruption
ensues.

This will be solved by changing shmem_replace_page() to
shmem_replace_folio(), but this is the minimal fix.

Link: https://lkml.kernel.org/r/20220730042518.1264767-1-willy@infradead.org
Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~shmem-update-folio-if-shmem_replace_page-updates-the-page
+++ a/mm/shmem.c
@@ -1782,6 +1782,7 @@ static int shmem_swapin_folio(struct ino
 
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
+		folio = page_folio(page);
 		if (error)
 			goto failed;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

