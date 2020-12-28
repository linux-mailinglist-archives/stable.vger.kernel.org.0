Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2793B2E4033
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392290AbgL1Ota (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438014AbgL1OVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B59020791;
        Mon, 28 Dec 2020 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165280;
        bh=9GU6fTLjmjctQzkB7KMKqm/qpsXtYFCx5Qm1h3TF3bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyGF65f/M9O0DVj2hCOWYqB5blDurIsmKlZqT8+Rqr3NX9J+46K+1AHgodRiZb4DT
         pHMNO2jklCeMuBZ5y2ly2ThJjk7xisiZVwd0ivw+UttT2bpAxeQXpsKA33dfXsg+t7
         frKj6MqJxbVtDEiK/ujPX60ZGIsPv241OlDl+gtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/717] mm/gup: reorganize internal_get_user_pages_fast()
Date:   Mon, 28 Dec 2020 13:47:24 +0100
Message-Id: <20201228125042.340670870@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit c28b1fc70390df32e29991eedd52bd86e7aba080 ]

Patch series "Add a seqcount between gup_fast and copy_page_range()", v4.

As discussed and suggested by Linus use a seqcount to close the small race
between gup_fast and copy_page_range().

Ahmed confirms that raw_write_seqcount_begin() is the correct API to use
in this case and it doesn't trigger any lockdeps.

I was able to test it using two threads, one forking and the other using
ibv_reg_mr() to trigger GUP fast.  Modifying copy_page_range() to sleep
made the window large enough to reliably hit to test the logic.

This patch (of 2):

The next patch in this series makes the lockless flow a little more
complex, so move the entire block into a new function and remove a level
of indention.  Tidy a bit of cruft:

 - addr is always the same as start, so use start

 - Use the modern check_add_overflow() for computing end = start + len

 - nr_pinned/pages << PAGE_SHIFT needs the LHS to be unsigned long to
   avoid shift overflow, make the variables unsigned long to avoid coding
   casts in both places. nr_pinned was missing its cast

 - The handling of ret and nr_pinned can be streamlined a bit

No functional change.

Link: https://lkml.kernel.org/r/0-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Link: https://lkml.kernel.org/r/1-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 99 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 54 insertions(+), 45 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 98eb8e6d2609c..c7e24301860ab 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2677,13 +2677,43 @@ static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
 	return ret;
 }
 
-static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
+static unsigned long lockless_pages_from_mm(unsigned long start,
+					    unsigned long end,
+					    unsigned int gup_flags,
+					    struct page **pages)
+{
+	unsigned long flags;
+	int nr_pinned = 0;
+
+	if (!IS_ENABLED(CONFIG_HAVE_FAST_GUP) ||
+	    !gup_fast_permitted(start, end))
+		return 0;
+
+	/*
+	 * Disable interrupts. The nested form is used, in order to allow full,
+	 * general purpose use of this routine.
+	 *
+	 * With interrupts disabled, we block page table pages from being freed
+	 * from under us. See struct mmu_table_batch comments in
+	 * include/asm-generic/tlb.h for more details.
+	 *
+	 * We do not adopt an rcu_read_lock() here as we also want to block IPIs
+	 * that come from THPs splitting.
+	 */
+	local_irq_save(flags);
+	gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+	local_irq_restore(flags);
+	return nr_pinned;
+}
+
+static int internal_get_user_pages_fast(unsigned long start,
+					unsigned long nr_pages,
 					unsigned int gup_flags,
 					struct page **pages)
 {
-	unsigned long addr, len, end;
-	unsigned long flags;
-	int nr_pinned = 0, ret = 0;
+	unsigned long len, end;
+	unsigned long nr_pinned;
+	int ret;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
@@ -2697,54 +2727,33 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	addr = start;
-	len = (unsigned long) nr_pages << PAGE_SHIFT;
-	end = start + len;
-
-	if (end <= start)
+	len = nr_pages << PAGE_SHIFT;
+	if (check_add_overflow(start, len, &end))
 		return 0;
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
-	/*
-	 * Disable interrupts. The nested form is used, in order to allow
-	 * full, general purpose use of this routine.
-	 *
-	 * With interrupts disabled, we block page table pages from being
-	 * freed from under us. See struct mmu_table_batch comments in
-	 * include/asm-generic/tlb.h for more details.
-	 *
-	 * We do not adopt an rcu_read_lock(.) here as we also want to
-	 * block IPIs that come from THPs splitting.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) && gup_fast_permitted(start, end)) {
-		unsigned long fast_flags = gup_flags;
-
-		local_irq_save(flags);
-		gup_pgd_range(addr, end, fast_flags, pages, &nr_pinned);
-		local_irq_restore(flags);
-		ret = nr_pinned;
-	}
-
-	if (nr_pinned < nr_pages && !(gup_flags & FOLL_FAST_ONLY)) {
-		/* Try to get the remaining pages with get_user_pages */
-		start += nr_pinned << PAGE_SHIFT;
-		pages += nr_pinned;
+	nr_pinned = lockless_pages_from_mm(start, end, gup_flags, pages);
+	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
+		return nr_pinned;
 
-		ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned,
-					      gup_flags, pages);
-
-		/* Have to be a bit careful with return values */
-		if (nr_pinned > 0) {
-			if (ret < 0)
-				ret = nr_pinned;
-			else
-				ret += nr_pinned;
-		}
+	/* Slow path: try to get the remaining pages with get_user_pages */
+	start += nr_pinned << PAGE_SHIFT;
+	pages += nr_pinned;
+	ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned, gup_flags,
+				      pages);
+	if (ret < 0) {
+		/*
+		 * The caller has to unpin the pages we already pinned so
+		 * returning -errno is not an option
+		 */
+		if (nr_pinned)
+			return nr_pinned;
+		return ret;
 	}
-
-	return ret;
+	return ret + nr_pinned;
 }
+
 /**
  * get_user_pages_fast_only() - pin user pages in memory
  * @start:      starting user address
-- 
2.27.0



