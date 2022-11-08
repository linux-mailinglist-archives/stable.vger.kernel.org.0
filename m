Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA10622087
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKHX6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKHX6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9685EFBF;
        Tue,  8 Nov 2022 15:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91328B81CC7;
        Tue,  8 Nov 2022 23:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39963C433D7;
        Tue,  8 Nov 2022 23:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951889;
        bh=E2c2qEBkxnNBZoXaWHL2wa63+cMdHINKCDH1Rv1fK4Q=;
        h=Date:To:From:Subject:From;
        b=dLeKeXqUWjJPWW7z8OMHkXVmeFV/vLlg0+yPpRkrequGZM5BKmf9/9r3CnF4VmbSI
         P3N4mgP4gEkk2AlPMtARqyL9fz/Wo+2+S9pe/n5JIo+DhxQzM396yVex9XgQsrY8mK
         LUXIxL91KMIx60Fm/rxkYt6QRZwzbN9BB31QELjc=
Date:   Tue, 08 Nov 2022 15:58:08 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, axelrasmussen@google.com,
        jthoughton@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-dont-delete-error-page-from-pagecache.patch removed from -mm tree
Message-Id: <20221108235809.39963C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: don't delete error page from pagecache
has been removed from the -mm tree.  Its filename was
     hugetlbfs-dont-delete-error-page-from-pagecache.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: hugetlbfs: don't delete error page from pagecache
Date: Tue, 18 Oct 2022 20:01:25 +0000

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
---

 fs/hugetlbfs/inode.c |   13 ++++++-------
 mm/hugetlb.c         |    4 ++++
 mm/memory-failure.c  |    5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/fs/hugetlbfs/inode.c
@@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struc
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
@@ -1111,13 +1117,6 @@ static int hugetlbfs_migrate_folio(struc
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
 
--- a/mm/hugetlb.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/mm/hugetlb.c
@@ -6111,6 +6111,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * We allow to overwrite a pte marker: consider when both MISSING|WP
 	 * registered, we firstly wr-protect a none pte which has no page cache
--- a/mm/memory-failure.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/mm/memory-failure.c
@@ -1080,6 +1080,7 @@ static int me_huge_page(struct page_stat
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1087,6 +1088,8 @@ static int me_huge_page(struct page_stat
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1104,7 +1107,7 @@ static int me_huge_page(struct page_stat
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
_

Patches currently in -mm which might be from jthoughton@google.com are


