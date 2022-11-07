Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9661FCE0
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiKGSJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiKGSJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:09:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E81C264AD
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 10:06:09 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f126-20020a255184000000b006cb2aebd124so11825383ybb.11
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 10:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j60fk1GX1r+NlL9MlNZCmp8WSDoORaTrNw5+KLoJy/4=;
        b=Mf6r8tPrYM3LamVKchqSLk/dmvuFcNjB5NxU9/TNA/LJR4+Uh6XqGidKCN9FLz9j6m
         5gN67h9p+bLYpCjhvc8IX2CAcX4UVPj8TTNmTLQlD8LZNhhCBfuUhNVOyi4YFV9Cslm6
         AhdPCARfNOufm6rPh+qX4CH2KdXaRwv31osB1U4pHViwGvPXTpaxGAj8nSPx7FSGxRB4
         +bKsZS3bxkBP2fqFSyYSg3BcOjx2bkaxsJ2wtpBxsnFPpuiZfD1FUTU7e48qA9xSUo21
         QvC3cJW2wJT2ZTT75eLJOPbDmwnzWYEohD/r29NC7k+wM2btkY3eRlPA4CapntnDrd5R
         pr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j60fk1GX1r+NlL9MlNZCmp8WSDoORaTrNw5+KLoJy/4=;
        b=xEaLNUNuURYCEL2pnNh7mskpxoLBVxFjz8d/vQZHjbgnLGUgbzFX60q9cRAqlwP0M+
         EtYtm9Td8wq9G5Qy/YG194DXFhiGKELKri2TdNXzpZtyM6PKHgpLXwz7FUNoPAlfGyXu
         ABHfbDl9KW/wru54n1TKHxT3YYY9m2ZXg2tGtJoGSRZrmW2QfkU3mEF/CLxWjDG7GGNO
         oXipsyrnB2xast1vQWduT9uQWsBtEBT6r6Z1+4oMmVjCZu450vuQbcI5MvHOmUVMxDlD
         92q7ofkSMrq9s3kK+eG1TvXzV+g28GzeSsnfArBqqn1SGW3fRZv3lUHi+KQp8XtnVx/2
         S/8w==
X-Gm-Message-State: ACrzQf11gjajwnDC8MpP+M7Rq1hjFwJvhYJ6MFuDn9gWYZZNjUnxDkuh
        FHcIn3ydhP0pqNQJHUaNj2kVAPblKZQQUr3D
X-Google-Smtp-Source: AMsMyM7RHwAxsAmUPng5raelGOKXR8aFY878B1n1s2rNW5vI6CWnaeE3l0ZswkUAr2+iO/m1XeFXM+P1fxqlCA2J
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a81:e0f:0:b0:349:a047:655e with SMTP id
 15-20020a810e0f000000b00349a047655emr50840803ywo.373.1667844368522; Mon, 07
 Nov 2022 10:06:08 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:05:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107180548.2095056-1-jthoughton@google.com>
Subject: [PATCH v2] hugetlbfs: don't delete error page from pagecache
From:   James Houghton <jthoughton@google.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Yang Shi <shy828301@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This change is very similar to the change that was made for shmem [1],
and it solves the same problem but for HugeTLBFS instead.

Currently, when poison is found in a HugeTLB page, the page is removed
from the page cache. That means that attempting to map or read that
hugepage in the future will result in a new hugepage being allocated
instead of notifying the user that the page was poisoned. As [1] states,
this is effectively memory corruption.

The fix is to leave the page in the page cache. If the user attempts to
use a poisoned HugeTLB page with a syscall, the syscall will fail with
EIO, the same error code that shmem uses. For attempts to map the page,
the thread will get a BUS_MCEERR_AR SIGBUS.

[1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

Fixes: 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Cc: <stable@vger.kernel.org>
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
---
 fs/hugetlbfs/inode.c | 13 ++++++-------
 mm/hugetlb.c         |  4 ++++
 mm/memory-failure.c  |  5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

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
-- 
2.38.1.431.g37b22c650d-goog

