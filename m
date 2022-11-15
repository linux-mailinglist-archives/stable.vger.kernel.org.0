Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344CD6291EE
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 07:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiKOGjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 01:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKOGjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 01:39:22 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996B81EED8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 22:39:20 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:39:12 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668494358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4bwcuInMSwaP7o8fEA//C2+i3jZ402YdjFFcCHaUB9o=;
        b=IGpXsO/rovx78/eqXesTDyAVqmFNrJvBiBq6vtIYxo07hq/8kMLyzGsyGYpmEDtBSuDHff
        X9fHHHYKUg6GO8UKxdya2YlPLuhHtin0n/+RhBcyK9tjF5Ty3cO7hs94yx8yO0r0d6P81V
        Szi9XKakUHLjJVckmchcnTNdKl1U3tQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+j44CA55u05LmfKQ==?= 
        <naoya.horiguchi@nec.com>, Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <20221115063912.GA3928893@u2004>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
 <Y3LrtTmLdBU7atso@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3LrtTmLdBU7atso@monkey>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 05:30:29PM -0800, Mike Kravetz wrote:
> On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> > On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > > 
> > > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > > 
> > > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > > but that's revisited recently.
> > > > > 
> > > > > And have you tested that these all apply properly (and in which order?)
> > > > 
> > > > Yes, I've checked that these cleanly apply (without any change) on
> > > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > > then a76054).
> > > > 
> > > > > and work correctly?
> > > > 
> > > > Yes, I ran related testcases in my test suite, and their status changed
> > > > FAIL to PASS with these patches.
> > > 
> > > Hi Naoya,
> > > 
> > > Just curious if you have plans to do backports for earlier releases?
> > 
> > I didn't have a clear plan.  I just thought that we should backport to
> > earlier kernels if someone want and the patches are applicable easily
> > enough and well-tested.
> > 
> > > 
> > > If not, I can start that effort.  We have seen data loss/corruption because of
> > > this on a 4.14 based release.   So, I would go at least that far back.
> > 
> > Thank you for raising hand, that's really helpful.
> > 
> > Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from

# I meant 8625147cafaa, sorry if the wrong commit ID confused you.

I tested with 8625147cafaa too, and it made hugetlb-related testcases
passed.

> > pagecbache") should be considered to backport together, because it's
> > the similar issue and reported (a while ago) to fail to backport.
> 
> Since dd0f230a0a80 was marked for backports, Greg's automation flags it as
> FAILED due to conflicts in earlier releases.  I am not sure if James has
> a plan to do backports for dd0f230a0a80.  Again, this is also something I
> would help with due to real customer issues.

OK, so I do want 8625147cafaa to be merged to stable.
Another reason why I addressed 8625147cafaa here is that this patch depends
on the code handling "extra_pins" (given by dd0f230a0a80) and it's simpler
to handle together.

We need to slightly modify 8625147cafaa to apply to 5.15.y.  So in summary,
my updated suggestion for 5.15.y is like below:

- [1/4] cherry-pick dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
- [2/4] cherry-pick 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
- [3/4] cherry-pick a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
- [4/4] apply the following patch (as a modified version of 8625147cafaa)

Thanks,
Naoya Horiguchi
---
From bdd88699d8ba6907e0815608482f8c0e2170982d Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 15 Nov 2022 15:20:51 +0900
Subject: [PATCH] hugetlbfs: don't delete error page from pagecache

commit 8625147cafaa9ba74713d682f5185eb62cb2aedb upstream.

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

Although there's a conflict in hugetlbfs_error_remove_page() when
backporting to stable tree, the resolution is almost trivial (just
removing conflicting lines in the function).

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
2.37.3.518.g79f2338b37

