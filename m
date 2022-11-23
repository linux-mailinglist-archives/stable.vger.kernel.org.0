Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A542063579C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238262AbiKWJpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbiKWJpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0B02ED54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDFB361A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCC3C433B5;
        Wed, 23 Nov 2022 09:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196568;
        bh=aEHlPriNCZLk2QpW7QxhTkt/qCzuoHvk0MD559t2cis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX7XDi2ArDlxhsIkP4t7ozl35hr6GbmYE3rFussO3+rQNfE2bZQOuusPZRKCkpewX
         hpUc5AxctXjcvTLciqULPEKyIabElOKGEWHZXDhiYreWrWLcL1cOKGUMeqkGb7Howq
         Jzkh/XAlck+IvUJh44zqmxJBnUezMCOvd39/wrTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Yang Shi <shy828301@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 066/314] hugetlbfs: dont delete error page from pagecache
Date:   Wed, 23 Nov 2022 09:48:31 +0100
Message-Id: <20221123084628.475689821@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Houghton <jthoughton@google.com>

[ Upstream commit 8625147cafaa9ba74713d682f5185eb62cb2aedb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 13 ++++++-------
 mm/hugetlb.c         |  4 ++++
 mm/memory-failure.c  |  5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b6406e7ab64b..fbcfa6bfee80 100644
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
@@ -990,13 +996,6 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
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
index 5e414c90f82f..dbb558e71e9e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6021,6 +6021,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * Recheck the i_size after holding PT lock to make sure not
 	 * to leave any page mapped (as page_mapped()) beyond the end
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e7ac570dda75..4d302f6b02fc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1079,6 +1079,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1086,6 +1087,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1103,7 +1106,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
-- 
2.35.1



