Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE303B6205
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhF1OlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhF1Oi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBCF761CBB;
        Mon, 28 Jun 2021 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890664;
        bh=3hFt1p4Ipc5Usu0ADBa83BW6ndkZm9KgKlZUaxK4YJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kxv+l8n7XVbK1S1gBW+9QD0DdH70v6rzZa2Dsp9P/cyfS7+ZiV+LZZaPr7CiWY7Qd
         4+ELk6nHMY1TyPs853gbMhpevNitSWiEX2bD5OktTplfAeLVwYmks/0BOdVZsrWr2r
         eOjmcV0saLrqzQGUTOwYGzvCr1nf8e9pyuJy21fQzMsvgOWMSvgtLdO6+3M+cv6Nza
         a6fXbSE7L1H0WuiUjQKoE8Pn4PnqH81EFnKqdQce7Hj5DOUaW9YAB7CEReIwWIDXQ2
         l2gfSV0J1CMk7RdR9KxeXZGe5DITZeZklbG2vAn85EDlnlSymxuc/EF+NDLA85SnQ1
         2QHyY5MOJCKbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>, Jan Kara <jack@suse.cz>,
        Jue Wang <juew@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 55/71] mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
Date:   Mon, 28 Jun 2021 10:29:48 -0400
Message-Id: <20210628143004.32596-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

[ Upstream commit 504e070dc08f757bccaed6d05c0f53ecbfac8a23 ]

When debugging the bug reported by Wang Yugui [1], try_to_unmap() may
fail, but the first VM_BUG_ON_PAGE() just checks page_mapcount() however
it may miss the failure when head page is unmapped but other subpage is
mapped.  Then the second DEBUG_VM BUG() that check total mapcount would
catch it.  This may incur some confusion.

As this is not a fatal issue, so consolidate the two DEBUG_VM checks
into one VM_WARN_ON_ONCE_PAGE().

[1] https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Link: https://lkml.kernel.org/r/d0f0db68-98b8-ebfb-16dc-f29df24cf012@google.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: fixed up variables in split_huge_page_to_list(),
and fixed up the conflict on ttu_flags in unmap_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9cb4e1e7e282..87a07aa61be0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2462,15 +2462,15 @@ static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD | TTU_SYNC;
-	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
-	unmap_success = try_to_unmap(page, ttu_flags);
-	VM_BUG_ON_PAGE(!unmap_success, page);
+	try_to_unmap(page, ttu_flags);
+
+	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct page *page)
@@ -2749,7 +2749,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct deferred_split *ds_queue = get_deferred_split_queue(page);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int extra_pins, ret;
 	bool mlocked;
 	unsigned long flags;
 	pgoff_t end;
@@ -2811,7 +2811,6 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	mlocked = PageMlocked(page);
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* Make sure the page is not on per-CPU pagevec as it takes pin */
 	if (mlocked)
@@ -2834,9 +2833,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	count = page_count(head);
-	mapcount = total_mapcount(head);
-	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
+	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
@@ -2857,16 +2854,9 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		} else
 			ret = 0;
 	} else {
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-			pr_alert("total_mapcount: %u, page_count(): %u\n",
-					mapcount, count);
-			if (PageTail(page))
-				dump_page(head, NULL);
-			dump_page(page, "total_mapcount(head) > 0");
-			BUG();
-		}
 		spin_unlock(&ds_queue->split_queue_lock);
-fail:		if (mapping)
+fail:
+		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
 		remap_page(head);
-- 
2.30.2

