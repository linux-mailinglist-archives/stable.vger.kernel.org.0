Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70E2627A92
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiKNKeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiKNKeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:34:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41FD17413
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E67660C96
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70426C433D6;
        Mon, 14 Nov 2022 10:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668422041;
        bh=Rx8qdDCC0gavQeuLV4JihejWrsxKdQmJbPxpASumKYI=;
        h=Subject:To:Cc:From:Date:From;
        b=U6uSFR9yXODjibPuzQAUDFS4ZOkQnc31Ae9MrAl28SWUG15dmPcC4aKVjFImBVPA2
         SKbNC5qGMHktyyNyH+O3xMKhb4c66DqXAn9XGy9G4ivl9ZY2saQBF7IpAxk6GRs3wK
         Q8lWGji6wBIq/tzjUPdgdmjO2dejPUIqHfGY/oSk=
Subject: FAILED: patch "[PATCH] hugetlbfs: don't delete error page from pagecache" failed to apply to 5.10-stable tree
To:     jthoughton@google.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, naoya.horiguchi@nec.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:33:53 +0100
Message-ID: <166842203313010@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8625147cafaa ("hugetlbfs: don't delete error page from pagecache")
7e1813d48dd3 ("hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache")
1508062ecd55 ("hugetlbfs: Convert remove_inode_hugepages() to use filemap_get_folios()")
d9ef44de5d73 ("hugetlb: Convert huge_add_to_page_cache() to use a folio")
dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
ea6d0630100b ("mm/hwpoison: do not lock page again when me_huge_page() successfully recovers")
171936ddaf97 ("mm/memory-failure: use a mutex to avoid memory_failure() races")
e32905e57358 ("userfaultfd: hugetlbfs: fix new flag usage in error path")
15b836536321 ("mm/hugetlb: remove unused variable pseudo_vma in remove_inode_hugepages()")
d4241a049ac0 ("mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case")
d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
585fc0d2871c ("mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page")
a8b2c2ce89d4 ("mm,hwpoison: take free pages off the buddy freelists")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8625147cafaa9ba74713d682f5185eb62cb2aedb Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 18 Oct 2022 20:01:25 +0000
Subject: [PATCH] hugetlbfs: don't delete error page from pagecache

This change is very similar to the change that was made for shmem [1], and
it solves the same problem but for HugeTLBFS instead.

Currently, when poison is found in a HugeTLB page, the page is removed
from the page cache.  That means that attempting to map or read that
hugepage in the future will result in a new hugepage being allocated
instead of notifying the user that the page was poisoned.  As [1] states,
this is effectively memory corruption.

The fix is to leave the page in the page cache.  If the user attempts to
use a poisoned HugeTLB page with a syscall, the syscall will fail with
EIO, the same error code that shmem uses.  For attempts to map the page,
the thread will get a BUS_MCEERR_AR SIGBUS.

[1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

Link: https://lkml.kernel.org/r/20221018200125.848471-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index dd54f67e47fd..df7772335dc0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		} else {
 			unlock_page(page);
 
+			if (PageHWPoison(page)) {
+				put_page(page);
+				retval = -EIO;
+				break;
+			}
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
@@ -1111,13 +1117,6 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	hugetlb_delete_from_page_cache(page);
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 546df97c31e4..e48f8ef45b17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6111,6 +6111,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * We allow to overwrite a pte marker: consider when both MISSING|WP
 	 * registered, we firstly wr-protect a none pte which has no page cache
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 145bb561ddb3..bead6bccc7f2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1080,6 +1080,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1087,6 +1088,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1104,7 +1107,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;

