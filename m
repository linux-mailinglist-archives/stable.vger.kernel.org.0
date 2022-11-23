Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48E6356C1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbiKWJbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiKWJbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2462FC12
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59CC661A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C799EC433C1;
        Wed, 23 Nov 2022 09:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195802;
        bh=PyvGfMNO4eGVZEKytnxM1XElbL0QDh3Vv3c9PMIsKIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grit8xvfaXM4qoUM3vK+Df6VZA8iiYcaKmxm0xwtV63FAPM72d2TViaLEMHB8iz99
         iAa1oGRMFE7h0tkZlC3kWnl8Q/foBY2Km8wQS0XGOFqvMfVQTHoG7M6ii1ObHdZSk5
         hVUKP1nqHspXqUUYpjTnvA212209UP/9EcH9PN24=
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
Subject: [PATCH 5.15 037/181] hugetlbfs: dont delete error page from pagecache
Date:   Wed, 23 Nov 2022 09:50:00 +0100
Message-Id: <20221123084603.965798988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index d74a49b188c2..be8deec29ebe 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -361,6 +361,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -984,13 +990,6 @@ static int hugetlbfs_migrate_page(struct address_space *mapping,
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	remove_huge_page(page);
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dbb63ec3b5fa..e7bd42f23667 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5350,6 +5350,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
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
index 85b1a77e3a99..2ad0f4580091 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1040,6 +1040,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1047,6 +1048,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		res = MF_FAILED;
@@ -1064,7 +1067,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
-- 
2.35.1



