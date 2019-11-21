Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780CF105D02
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKUXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfKUXG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:06:26 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4EE20692;
        Thu, 21 Nov 2019 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574377585;
        bh=n6PXclHuYfF0zt6jushAEpMa7wPI68W1kQqWHQzrmRY=;
        h=Date:From:To:Subject:From;
        b=u9aPZnUTS43c2DqyBkDJ6TKDHNLErjgWfWrqWpW63RhQUwItGVDy3Vo8k7R18iEGP
         a4WYV+jcqTacqofuQ3tLPE2rnGxnNIc2Kf7AqlYFBBgBQ3rkoX5KvJ5VYnOzOU5qUC
         Q5DegmIZpD3mh+i6qdNp/qHmIhz89ISJo5d4T5Ts=
Date:   Thu, 21 Nov 2019 15:06:25 -0800
From:   akpm@linux-foundation.org
To:     lixinhai.lxh@gmail.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz, yang.shi@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-mempolicy-fix-the-wrong-return-value-and-potential-pages?=
 =?US-ASCII?Q?-leak-of-mbind.patch?= removed from -mm tree
Message-ID: <20191121230625.IAmG2aLUe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: fix the wrong return value and potential pages leak of mbind
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-the-wrong-return-value-and-potential-pages-leak-of-mbind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: mempolicy: fix the wrong return value and potential pages leak of mbind

Commit d883544515aa ("mm: mempolicy: make the behavior consistent when
MPOL_MF_MOVE* and MPOL_MF_STRICT were specified") fixed the return value
of mbind() for a couple of corner cases.  But, it altered the errno for
some other cases, for example, mbind() should return -EFAULT when part or
all of the memory range specified by nodemask and maxnode points outside
your accessible address space, or there was an unmapped hole in the
specified memory range specified by addr and len.

Fix this by preserving the errno returned by queue_pages_range().  And,
the pagelist may be not empty even though queue_pages_range() returns
error, put the pages back to LRU since mbind_range() is not called to
really apply the policy so those pages should not be migrated, this is
also the old behavior before the problematic commit.

Link: http://lkml.kernel.org/r/1572454731-3925-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: d883544515aa ("mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[4.19 and 5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-the-wrong-return-value-and-potential-pages-leak-of-mbind
+++ a/mm/mempolicy.c
@@ -672,7 +672,9 @@ static const struct mm_walk_ops queue_pa
  * 1 - there is unmovable page, but MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
  * 0 - queue pages successfully or no misplaced page.
- * -EIO - there is misplaced page and only MPOL_MF_STRICT was specified.
+ * errno - i.e. misplaced pages with MPOL_MF_STRICT specified (-EIO) or
+ *         memory range specified by nodemask and maxnode points outside
+ *         your accessible address space (-EFAULT)
  */
 static int
 queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
@@ -1286,7 +1288,7 @@ static long do_mbind(unsigned long start
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	if (ret < 0) {
-		err = -EIO;
+		err = ret;
 		goto up_out;
 	}
 
@@ -1305,10 +1307,12 @@ static long do_mbind(unsigned long start
 
 		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
 			err = -EIO;
-	} else
-		putback_movable_pages(&pagelist);
-
+	} else {
 up_out:
+		if (!list_empty(&pagelist))
+			putback_movable_pages(&pagelist);
+	}
+
 	up_write(&mm->mmap_sem);
 mpol_out:
 	mpol_put(new);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-rmap-use-vm_bug_on_page-in-__page_check_anon_rmap.patch
mm-vmscan-remove-unused-scan_control-parameter-from-pageout.patch
mm-migrate-handle-freed-page-at-the-first-place.patch
mm-shmem-use-proper-gfp-flags-for-shmem_writepage.patch

