Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC918C456
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 00:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfHMWhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 18:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfHMWhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 18:37:17 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFE32067D;
        Tue, 13 Aug 2019 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565735835;
        bh=G1Pd/+3/fas/PhnNOpeCS1QuWapD33zioirf3VHP3fI=;
        h=Date:From:To:Subject:From;
        b=w7hY4cotsU0XCHNlAAuiYR+/zDyf4Fa/Cotks2quKDmuH9L7e4VHGJocvkAmHZ2WI
         XPqfaEbwlAuOvYC5mzphQ/JVK0w+mXMtWBtiwmmwJfPS1XDDJQjpzOfBnPfFQmi2RZ
         mGXtdpXiDz0mDVKNyc6v41OTsDno8SjD/7v8ZkW4=
Date:   Tue, 13 Aug 2019 15:37:15 -0700
From:   akpm@linux-foundation.org
To:     vbabka@suse.cz, stable@vger.kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, yang.shi@linux.alibaba.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/18] mm: mempolicy: make the behavior consistent
 when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified
Message-ID: <20190813223715.-mPzu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified

When both MPOL_MF_MOVE* and MPOL_MF_STRICT was specified, mbind() should
try best to migrate misplaced pages, if some of the pages could not be
migrated, then return -EIO.

There are three different sub-cases:
1. vma is not migratable
2. vma is migratable, but there are unmovable pages
3. vma is migratable, pages are movable, but migrate_pages() fails

If #1 happens, kernel would just abort immediately, then return -EIO,
after a7f40cfe3b7ada ("mm: mempolicy: make mbind() return -EIO when
MPOL_MF_STRICT is specified").

If #3 happens, kernel would set policy and migrate pages with best-effort,
but won't rollback the migrated pages and reset the policy back.

Before that commit, they behaves in the same way.  It'd better to keep
their behavior consistent.  But, rolling back the migrated pages and
resetting the policy back sounds not feasible, so just make #1 behave as
same as #3.

Userspace will know that not everything was successfully migrated (via
-EIO), and can take whatever steps it deems necessary - attempt rollback,
determine which exact page(s) are violating the policy, etc.

Make queue_pages_range() return 1 to indicate there are unmovable pages or
vma is not migratable.

The #2 is not handled correctly in the current kernel, the following patch
will fix it.

[yang.shi@linux.alibaba.com: fix review comments from Vlastimil]
  Link: http://lkml.kernel.org/r/1563556862-54056-2-git-send-email-yang.shi@linux.alibaba.com
Link: http://lkml.kernel.org/r/1561162809-59140-2-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   68 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 20 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified
+++ a/mm/mempolicy.c
@@ -429,11 +429,14 @@ static inline bool queue_pages_required(
 }
 
 /*
- * queue_pages_pmd() has three possible return values:
- * 1 - pages are placed on the right node or queued successfully.
- * 0 - THP was split.
- * -EIO - is migration entry or MPOL_MF_STRICT was specified and an existing
- *        page was already on a node that does not follow the policy.
+ * queue_pages_pmd() has four possible return values:
+ * 0 - pages are placed on the right node or queued successfully.
+ * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
+ *     specified.
+ * 2 - THP was split.
+ * -EIO - is migration entry or only MPOL_MF_STRICT was specified and an
+ *        existing page was already on a node that does not follow the
+ *        policy.
  */
 static int queue_pages_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
@@ -451,19 +454,17 @@ static int queue_pages_pmd(pmd_t *pmd, s
 	if (is_huge_zero_page(page)) {
 		spin_unlock(ptl);
 		__split_huge_pmd(walk->vma, pmd, addr, false, NULL);
+		ret = 2;
 		goto out;
 	}
-	if (!queue_pages_required(page, qp)) {
-		ret = 1;
+	if (!queue_pages_required(page, qp))
 		goto unlock;
-	}
 
-	ret = 1;
 	flags = qp->flags;
 	/* go to thp migration */
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma)) {
-			ret = -EIO;
+			ret = 1;
 			goto unlock;
 		}
 
@@ -479,6 +480,13 @@ out:
 /*
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
+ *
+ * queue_pages_pte_range() has three possible return values:
+ * 0 - pages are placed on the right node or queued successfully.
+ * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
+ *     specified.
+ * -EIO - only MPOL_MF_STRICT was specified and an existing page was already
+ *        on a node that does not follow the policy.
  */
 static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
@@ -488,17 +496,17 @@ static int queue_pages_pte_range(pmd_t *
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
 	int ret;
+	bool has_unmovable = false;
 	pte_t *pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
 		ret = queue_pages_pmd(pmd, ptl, addr, end, walk);
-		if (ret > 0)
-			return 0;
-		else if (ret < 0)
+		if (ret != 2)
 			return ret;
 	}
+	/* THP was split, fall through to pte walk */
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
@@ -519,14 +527,21 @@ static int queue_pages_pte_range(pmd_t *
 		if (!queue_pages_required(page, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-			if (!vma_migratable(vma))
+			/* MPOL_MF_STRICT must be specified if we get here */
+			if (!vma_migratable(vma)) {
+				has_unmovable = true;
 				break;
+			}
 			migrate_page_add(page, qp->pagelist, flags);
 		} else
 			break;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+
+	if (has_unmovable)
+		return 1;
+
 	return addr != end ? -EIO : 0;
 }
 
@@ -639,7 +654,13 @@ static int queue_pages_test_walk(unsigne
  *
  * If pages found in a given range are on a set of nodes (determined by
  * @nodes and @flags,) it's isolated and queued to the pagelist which is
- * passed via @private.)
+ * passed via @private.
+ *
+ * queue_pages_range() has three possible return values:
+ * 1 - there is unmovable page, but MPOL_MF_MOVE* & MPOL_MF_STRICT were
+ *     specified.
+ * 0 - queue pages successfully or no misplaced page.
+ * -EIO - there is misplaced page and only MPOL_MF_STRICT was specified.
  */
 static int
 queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
@@ -1182,6 +1203,7 @@ static long do_mbind(unsigned long start
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
+	int ret;
 	LIST_HEAD(pagelist);
 
 	if (flags & ~(unsigned long)MPOL_MF_VALID)
@@ -1243,10 +1265,15 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
-	err = queue_pages_range(mm, start, end, nmask,
+	ret = queue_pages_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
-	if (!err)
-		err = mbind_range(mm, start, end, new);
+
+	if (ret < 0) {
+		err = -EIO;
+		goto up_out;
+	}
+
+	err = mbind_range(mm, start, end, new);
 
 	if (!err) {
 		int nr_failed = 0;
@@ -1259,13 +1286,14 @@ static long do_mbind(unsigned long start
 				putback_movable_pages(&pagelist);
 		}
 
-		if (nr_failed && (flags & MPOL_MF_STRICT))
+		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
 			err = -EIO;
 	} else
 		putback_movable_pages(&pagelist);
 
+up_out:
 	up_write(&mm->mmap_sem);
- mpol_out:
+mpol_out:
 	mpol_put(new);
 	return err;
 }
_
