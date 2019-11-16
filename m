Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCF3FEA1C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 02:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfKPBef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 20:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKPBef (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 20:34:35 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B6120730;
        Sat, 16 Nov 2019 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573868074;
        bh=jS6+m9jIJEN9sKpHEodLMuvGW+txn5NwxZpt2GXn63s=;
        h=Date:From:To:Subject:From;
        b=ahbeHzBwui6mg3r/mDceXGtQ/yKNglpzZ+FqjIorLQlf3SpfKN0Dd3Dv51tT0HkIr
         FFp4kSNisy3lavPQ7TqyIXBXgtafN/gXdRT7BCK9eJy4nxNHBNow7wJ6uErNjs06IS
         NeBCwtxioruQWx81ThBvzHll20SzekyC87aF2uqA=
Date:   Fri, 15 Nov 2019 17:34:33 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, yang.shi@linux.alibaba.com
Subject:  [patch 01/11] mm: mempolicy: fix the wrong return value
 and potential pages leak of mbind
Message-ID: <20191116013433.4kqit7WoG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
