Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9716ADABC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCGJoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCGJos (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:44:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B92F3B842
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DD766126D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3336FC4339C;
        Tue,  7 Mar 2023 09:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182279;
        bh=VRMd3q6a/O9tSqIrByW0O/hgLxYDqRMi6Y9tM9uJavc=;
        h=Subject:To:Cc:From:Date:From;
        b=EBwjxjVKFSWOOyQvSvdKCC3ATiQmKb7SrqxgeiPLSuoUBIpmQ5FZ2bMB5gAfxcAiX
         HsyMuvfZKvWG3eA/EqBzcM23JxrXwx+VNTzoifw0QbaRy9kvHk/xxdPFctvEF2UsUn
         UsgysOWCb1e3e6C4W9TCugoaWKXuD1eNjycpFuQE=
Subject: FAILED: patch "[PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only" failed to apply to 5.15-stable tree
To:     pcc@google.com, Kuan-Ying.Lee@mediatek.com, andreyknvl@gmail.com,
        catalin.marinas@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:44:28 +0100
Message-ID: <16781822685041@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x e74a68468062d7ebd8ce17069e12ccc64cc6a58c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781822685041@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

e74a68468062 ("arm64: Reset KASAN tag in copy_highpage with HW tags only")
d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
e059853d14ca ("arm64: mte: Fix/clarify the PG_mte_tagged semantics")
a8e5e5146ad0 ("arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored")
20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
70c248aca9e7 ("mm: kasan: Skip unpoisoning of user pages")
da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
b1d0ec3a9a25 ("mm/shmem: convert shmem_getpage_gfp to use a folio")
72827e5c2bcb ("mm/shmem: convert shmem_alloc_and_acct_page to use a folio")
069d849cde3a ("mm/shmem: turn shmem_should_replace_page into shmem_should_replace_folio")
b7dd44a12cf2 ("mm/shmem: convert shmem_add_to_page_cache to take a folio")
dfe98499ef28 ("shmem: convert shmem_alloc_hugepage() to use vma_alloc_folio()")
e9d0ca922816 ("kasan, page_alloc: rework kasan_unpoison_pages call site")
7e3cbba65de2 ("kasan, page_alloc: move kernel_init_free_pages in post_alloc_hook")
89b271163328 ("kasan, page_alloc: move SetPageSkipKASanPoison in post_alloc_hook")
9294b1281d0a ("kasan, page_alloc: combine tag_clear_highpage calls in post_alloc_hook")
b42090ae6f3a ("kasan, page_alloc: merge kasan_alloc_pages into post_alloc_hook")
b8491b9052fe ("kasan, page_alloc: refactor init checks in post_alloc_hook")
1c0e5b24f117 ("kasan: only apply __GFP_ZEROTAGS when memory is zeroed")
7c13c163e036 ("kasan, page_alloc: merge kasan_free_pages into free_pages_prepare")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e74a68468062d7ebd8ce17069e12ccc64cc6a58c Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Tue, 14 Feb 2023 21:09:11 -0800
Subject: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

During page migration, the copy_highpage function is used to copy the
page data to the target page. If the source page is a userspace page
with MTE tags, the KASAN tag of the target page must have the match-all
tag in order to avoid tag check faults during subsequent accesses to the
page by the kernel. However, the target page may have been allocated in
a number of ways, some of which will use the KASAN allocator and will
therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
update the target page's KASAN tag to match the source page.

We ended up unintentionally fixing this issue as a result of a bad
merge conflict resolution between commit e059853d14ca ("arm64: mte:
Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
preserved a tag reset for PG_mte_tagged pages which was considered to be
unnecessary at the time. Because SW tags KASAN uses separate tag storage,
update the code to only reset the tags when HW tags KASAN is enabled.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd85706505830f52e0c
Reported-by: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
Cc: <stable@vger.kernel.org> # 6.1
Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20230215050911.1433132-1-pcc@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 8dd5a8fe64b4..4aadcfb01754 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -22,7 +22,8 @@ void copy_highpage(struct page *to, struct page *from)
 	copy_page(kto, kfrom);
 
 	if (system_supports_mte() && page_mte_tagged(from)) {
-		page_kasan_tag_reset(to);
+		if (kasan_hw_tags_enabled())
+			page_kasan_tag_reset(to);
 		/* It's a new page, shouldn't have been tagged yet */
 		WARN_ON_ONCE(!try_page_mte_tagging(to));
 		mte_copy_page_tags(kto, kfrom);

