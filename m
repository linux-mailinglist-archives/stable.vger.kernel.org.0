Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CB83B61E4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhF1OkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhF1Oha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1572861CB7;
        Mon, 28 Jun 2021 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890656;
        bh=eSNXiOALnpZQpoZj5unRCpYcLA5WFiQtvNQMFODtjtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTid6dZcDKox2fpFBugKOS4O+3cFNUkYJKd1vo37LT6TfZ2L3RpIF7Pc3qxR1E+Em
         HX2JDmeANyt5h4XuqbnrphLXPJrkpkoesaBG3CGpfvABx23D/vGy5xydHXZOv+56tU
         LHR5Fm8VnlUeP7P1HabdQ8lna6Bvaw+KpZ+y4gFVWrTpuGgI2VBlHAMBwvhWFCuSI1
         kXjPBChHTFTY1GkJcDuRfZO/+4STtvyI3sOBvcmGMqCJ62Mq/1/4XmxntCICx7aEc4
         kq0lMWxcE5MmzNm9cjs+cZIcU7FW6ahiVmsiWNB/5rEuVWPXGrPCKp1jDYFHVA8Ysd
         RlivpHi6PwxpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>, Jan Kara <jack@suse.cz>,
        Jue Wang <juew@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 51/71] mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
Date:   Mon, 28 Jun 2021 10:29:44 -0400
Message-Id: <20210628143004.32596-52-sashal@kernel.org>
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

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 732ed55823fc3ad998d43b86bf771887bcc5ec67 ]

Stressing huge tmpfs often crashed on unmap_page()'s VM_BUG_ON_PAGE
(!unmap_success): with dump_page() showing mapcount:1, but then its raw
struct page output showing _mapcount ffffffff i.e.  mapcount 0.

And even if that particular VM_BUG_ON_PAGE(!unmap_success) is removed,
it is immediately followed by a VM_BUG_ON_PAGE(compound_mapcount(head)),
and further down an IS_ENABLED(CONFIG_DEBUG_VM) total_mapcount BUG():
all indicative of some mapcount difficulty in development here perhaps.
But the !CONFIG_DEBUG_VM path handles the failures correctly and
silently.

I believe the problem is that once a racing unmap has cleared pte or
pmd, try_to_unmap_one() may skip taking the page table lock, and emerge
from try_to_unmap() before the racing task has reached decrementing
mapcount.

Instead of abandoning the unsafe VM_BUG_ON_PAGE(), and the ones that
follow, use PVMW_SYNC in try_to_unmap_one() in this case: adding
TTU_SYNC to the options, and passing that from unmap_page().

When CONFIG_DEBUG_VM, or for non-debug too? Consensus is to do the same
for both: the slight overhead added should rarely matter, except perhaps
if splitting sparsely-populated multiply-mapped shmem.  Once confident
that bugs are fixed, TTU_SYNC here can be removed, and the race
tolerated.

Link: https://lkml.kernel.org/r/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com
Fixes: fec89c109f3a ("thp: rewrite freeze_page()/unfreeze_page() with generic rmap walkers")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: upstream TTU_SYNC 0x10 takes the value which
5.11 commit 013339df116c ("mm/rmap: always do TTU_IGNORE_ACCESS") freed.
It is very tempting to backport that commit (as 5.10 already did) and
make no change here; but on reflection, good as that commit is, I'm
reluctant to include any possible side-effect of it in this series.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |  3 ++-
 mm/huge_memory.c     |  2 +-
 mm/page_vma_mapped.c | 11 +++++++++++
 mm/rmap.c            | 17 ++++++++++++++++-
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index d7d6d4eb1794..91ccae946716 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -98,7 +98,8 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
-	TTU_SPLIT_FREEZE	= 0x100,		/* freeze pte under splitting thp */
+	TTU_SPLIT_FREEZE	= 0x100, /* freeze pte under splitting thp */
+	TTU_SYNC		= 0x200, /* avoid racy checks with PVMW_SYNC */
 };
 
 #ifdef CONFIG_MMU
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 47d95048f31e..9cb4e1e7e282 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2461,7 +2461,7 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
-		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
+		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD | TTU_SYNC;
 	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index eff4b4520c8d..5a2a371a2c98 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -207,6 +207,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = NULL;
 		}
 	} else if (!pmd_present(pmde)) {
+		/*
+		 * If PVMW_SYNC, take and drop THP pmd lock so that we
+		 * cannot return prematurely, while zap_huge_pmd() has
+		 * cleared *pmd but not decremented compound_mapcount().
+		 */
+		if ((pvmw->flags & PVMW_SYNC) &&
+		    PageTransCompound(pvmw->page)) {
+			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+
+			spin_unlock(ptl);
+		}
 		return false;
 	}
 	if (!map_pte(pvmw))
diff --git a/mm/rmap.c b/mm/rmap.c
index cbde11c06a76..c61a6384d950 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1353,6 +1353,15 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	if (flags & TTU_SYNC)
+		pvmw.flags = PVMW_SYNC;
+
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
@@ -1731,7 +1740,13 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	else
 		rmap_walk(page, &rwc);
 
-	return !page_mapcount(page) ? true : false;
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	return !page_mapcount(page);
 }
 
 /**
-- 
2.30.2

