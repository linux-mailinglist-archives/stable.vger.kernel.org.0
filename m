Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC193FAFB5
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 04:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhH3CXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 22:23:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15267 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhH3CXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 22:23:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GyYxY6fzrz8CDT;
        Mon, 30 Aug 2021 10:22:25 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 10:22:45 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 30 Aug 2021 10:22:44 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <wangkefeng.wang@huawei.com>, <chenhuang5@huawei.com>,
        <cy.fan@huawei.com>, <liushixin2@huawei.com>,
        <jingxiangfeng@huawei.com>, <liuyongqiang13@huawei.com>,
        <tongtiangen@huawei.com>, <zouyue3@huawei.com>,
        <sunnanyong@huawei.com>, <liupeng256@huawei.com>,
        <zhiwentao@huawei.com>, <patchwork@huawei.com>
CC:     Hugh Dickins <hughd@google.com>,
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
        Oscar Salvador <osalvador@suse.de>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Chen Wandun <chenwandun@huawei.com>
Subject: [PATCH 3/4] mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
Date:   Mon, 30 Aug 2021 10:30:31 +0800
Message-ID: <20210830023032.374861-4-chenwandun@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20210830023032.374861-1-chenwandun@huawei.com>
References: <20210830023032.374861-1-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

mainline inclusion
from mainline-v5.13-rc7
commit 99fa8a48203d62b3743d866fc48ef6abaee682be
category: bugfix
bugzilla: 110269
DTS: #87
CVE: NA

-------------------------------------------------

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
Conflicts:
	mm/huge_memory.c
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 mm/huge_memory.c     | 27 ++++++++++++++++++---------
 mm/pgtable-generic.c |  5 ++---
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d68b2c3aebc7..89419fffefab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2199,7 +2199,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	count_vm_event(THP_SPLIT_PMD);
 
 	if (!vma_is_anonymous(vma)) {
-		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+		old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		/*
 		 * We are going to unmap this huge page. So
 		 * just go ahead and zap it
@@ -2208,16 +2208,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			zap_deposited_table(mm, pmd);
 		if (vma_is_dax(vma))
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
 		add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		return;
-	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	}
+
+	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 5e9957e19870..36770fcdc358 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -125,9 +125,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_present(*pmdp));
-	/* Below assumes pmd_present() is true */
-	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	VM_BUG_ON(pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
+			   !pmd_devmap(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
-- 
2.18.0.huawei.25

