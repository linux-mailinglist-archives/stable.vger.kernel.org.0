Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2BF3B612C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhF1Oc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233698AbhF1Oat (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7364161CD3;
        Mon, 28 Jun 2021 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890435;
        bh=qRYmHYhrz8ex62izFQ+70MT/Pxv5JVf0Yjh/7LxYRKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ4jaMEA9jfFnBvsMaVlSOftGpWFihwi2zi8RuNkO/j/z6/GWwFk+a0hRHhL7KvWS
         4FvRX4Zd0OWw7Bue41Wisy6iBpPAB9/4LzKytuSqYspG54Mnxm5puFo8/xfajMf6z+
         YCxKftVW7Jv/98XzFu/1Sv1AnTXtLprT53oIBQw/bty3fbpKNY15wm9rlJovW3ciSH
         NaNE1Eibcd9l+n6u1jOy9bQoADv8OSTIRjGPo/PAFLaJ9duXQoEts4RRQqu0qQxFCC
         TUQQHNmEroijGb1+yyELs+pKl5jdlIlHuSGXg7vRN2TBcU5LS2J9IWxsXC9QYg5gtN
         50UizAtdiBQ/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>, Jue Wang <juew@google.com>,
        Peter Xu <peterx@redhat.com>, Jan Kara <jack@suse.cz>,
        Shakeel Butt <shakeelb@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 075/101] mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
Date:   Mon, 28 Jun 2021 10:25:41 -0400
Message-Id: <20210628142607.32218-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 99fa8a48203d62b3743d866fc48ef6abaee682be ]

Patch series "mm/thp: fix THP splitting unmap BUGs and related", v10.

Here is v2 batch of long-standing THP bug fixes that I had not got
around to sending before, but prompted now by Wang Yugui's report
https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Wang Yugui has tested a rollup of these fixes applied to 5.10.39, and
they have done no harm, but have *not* fixed that issue: something more
is needed and I have no idea of what.

This patch (of 7):

Stressing huge tmpfs page migration racing hole punch often crashed on
the VM_BUG_ON(!pmd_present) in pmdp_huge_clear_flush(), with DEBUG_VM=y
kernel; or shortly afterwards, on a bad dereference in
__split_huge_pmd_locked() when DEBUG_VM=n.  They forgot to allow for pmd
migration entries in the non-anonymous case.

Full disclosure: those particular experiments were on a kernel with more
relaxed mmap_lock and i_mmap_rwsem locking, and were not repeated on the
vanilla kernel: it is conceivable that stricter locking happens to avoid
those cases, or makes them less likely; but __split_huge_pmd_locked()
already allowed for pmd migration entries when handling anonymous THPs,
so this commit brings the shmem and file THP handling into line.

And while there: use old_pmd rather than _pmd, as in the following
blocks; and make it clearer to the eye that the !vma_is_anonymous()
block is self-contained, making an early return after accounting for
unmapping.

Link: https://lkml.kernel.org/r/af88612-1473-2eaa-903-8d1a448b26@google.com
Link: https://lkml.kernel.org/r/dd221a99-efb3-cd1d-6256-7e646af29314@google.com
Fixes: e71769ae5260 ("mm: enable thp migration for shmem thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jue Wang <juew@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: this commit made intervening cleanups in
pmdp_huge_clear_flush() redundant: here it's rediffed to skip them.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c     | 27 ++++++++++++++++++---------
 mm/pgtable-generic.c |  4 ++--
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9ade23ac2b2..be0ad6f7981e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2031,7 +2031,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	count_vm_event(THP_SPLIT_PMD);
 
 	if (!vma_is_anonymous(vma)) {
-		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+		old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		/*
 		 * We are going to unmap this huge page. So
 		 * just go ahead and zap it
@@ -2040,16 +2040,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			zap_deposited_table(mm, pmd);
 		if (vma_is_special_huge(vma))
 			return;
-		page = pmd_page(_pmd);
-		if (!PageDirty(page) && pmd_dirty(_pmd))
-			set_page_dirty(page);
-		if (!PageReferenced(page) && pmd_young(_pmd))
-			SetPageReferenced(page);
-		page_remove_rmap(page, true);
-		put_page(page);
+		if (unlikely(is_pmd_migration_entry(old_pmd))) {
+			swp_entry_t entry;
+
+			entry = pmd_to_swp_entry(old_pmd);
+			page = migration_entry_to_page(entry);
+		} else {
+			page = pmd_page(old_pmd);
+			if (!PageDirty(page) && pmd_dirty(old_pmd))
+				set_page_dirty(page);
+			if (!PageReferenced(page) && pmd_young(old_pmd))
+				SetPageReferenced(page);
+			page_remove_rmap(page, true);
+			put_page(page);
+		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
-	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	}
+
+	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 9578db83e312..4e640baf9794 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -135,8 +135,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
-			   !pmd_devmap(*pmdp)) || !pmd_present(*pmdp));
+	VM_BUG_ON(pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
+			   !pmd_devmap(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
-- 
2.30.2

