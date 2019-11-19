Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C339A10134D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfKSFYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfKSFYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9891B208C3;
        Tue, 19 Nov 2019 05:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141054;
        bh=g9zWpfOwwfRMTN2uvV6AeiuRu4QlfCSoIi1gr5Li2Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRXLPHE4Uc+FqcDub5rxArNArTolp/9NP+nViZu6cb1X5agZVQod6M2RluQFELCNw
         x3I8rQxlM2YZ8tVLhbh6GmAvUtigjWsigixLBvJmoZVx1a+urENd9OnUqG98UiCCnd
         FAxJgUKthiwrrI3Td5ZGXnXk57q5PES1Zc6R/yOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Li Xinhai <lixinhai.lxh@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 029/422] mm: mempolicy: fix the wrong return value and potential pages leak of mbind
Date:   Tue, 19 Nov 2019 06:13:46 +0100
Message-Id: <20191119051401.941293987@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit a85dfc305a21acfc48fa28a0fa0a0cb6ad496120 upstream.

Commit d883544515aa ("mm: mempolicy: make the behavior consistent when
MPOL_MF_MOVE* and MPOL_MF_STRICT were specified") fixed the return value
of mbind() for a couple of corner cases.  But, it altered the errno for
some other cases, for example, mbind() should return -EFAULT when part
or all of the memory range specified by nodemask and maxnode points
outside your accessible address space, or there was an unmapped hole in
the specified memory range specified by addr and len.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -666,7 +666,9 @@ static int queue_pages_test_walk(unsigne
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
@@ -1273,7 +1275,7 @@ static long do_mbind(unsigned long start
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	if (ret < 0) {
-		err = -EIO;
+		err = ret;
 		goto up_out;
 	}
 
@@ -1292,10 +1294,12 @@ static long do_mbind(unsigned long start
 
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


