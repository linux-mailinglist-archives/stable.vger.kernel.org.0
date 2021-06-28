Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF53B6137
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhF1Odf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhF1Obi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C81461CD5;
        Mon, 28 Jun 2021 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890437;
        bh=gh6L8DR+IosEwQ8v4xgHvcwZP9gJlBNr0wOegcP4H5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZ0c9uYL58zXaepjiory9hJK8SUiNbZemgMkmpIaNLSpY4Pze7fS+Su+/0PYgi5er
         yXBzuBFVngiC6uR+wlcQwo3++qKCu/CkY0rf16niefKDUHKSlgeKnwXd1pfItyD/Wl
         pHz/XDLsaG1480hZWoExGd/xmHcUV4ZPj95bzBSQ9Be+mIdBVsObjPcERJzql0y1jD
         b89+9C3UosKLQV70rTq1tJs2SZNx96dOpmjzb+JWbb7vvbgy/RH/8BsMv1MGXNjJFV
         V+UxiSFCwSDmnHGARQh6h/yc669dXaD/aXfYzux4WQiOIaZQNq1MTHUalf4kLyxpB5
         2Ss6f++7JJnzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
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
        Wang Yugui <wangyugui@e16-tech.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 076/101] mm/thp: make is_huge_zero_pmd() safe and quicker
Date:   Mon, 28 Jun 2021 10:25:42 -0400
Message-Id: <20210628142607.32218-77-sashal@kernel.org>
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

commit 3b77e8c8cde581dadab9a0f1543a347e24315f11 upstream.

Most callers of is_huge_zero_pmd() supply a pmd already verified
present; but a few (notably zap_huge_pmd()) do not - it might be a pmd
migration entry, in which the pfn is encoded differently from a present
pmd: which might pass the is_huge_zero_pmd() test (though not on x86,
since L1TF forced us to protect against that); or perhaps even crash in
pmd_page() applied to a swap-like entry.

Make it safe by adding pmd_present() check into is_huge_zero_pmd()
itself; and make it quicker by saving huge_zero_pfn, so that
is_huge_zero_pmd() will not need to do that pmd_page() lookup each time.

__split_huge_pmd_locked() checked pmd_trans_huge() before: that worked,
but is unnecessary now that is_huge_zero_pmd() checks present.

Link: https://lkml.kernel.org/r/21ea9ca-a1f5-8b90-5e88-95fb1c49bbfa@google.com
Fixes: e71769ae5260 ("mm: enable thp migration for shmem thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h | 8 +++++++-
 mm/huge_memory.c        | 5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 0365aa97f8e7..ff55be011739 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -297,6 +297,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 extern vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
+extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_page(struct page *page)
 {
@@ -305,7 +306,7 @@ static inline bool is_huge_zero_page(struct page *page)
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_page(pmd_page(pmd));
+	return READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd) && pmd_present(pmd);
 }
 
 static inline bool is_huge_zero_pud(pud_t pud)
@@ -451,6 +452,11 @@ static inline bool is_huge_zero_page(struct page *page)
 	return false;
 }
 
+static inline bool is_huge_zero_pmd(pmd_t pmd)
+{
+	return false;
+}
+
 static inline bool is_huge_zero_pud(pud_t pud)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index be0ad6f7981e..7d8159be4736 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -61,6 +61,7 @@ static struct shrinker deferred_split_shrinker;
 
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -97,6 +98,7 @@ static struct page *get_huge_zero_page(void)
 		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
+	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
 
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
@@ -146,6 +148,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
+		WRITE_ONCE(huge_zero_pfn, ~0UL);
 		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
@@ -2058,7 +2061,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
-- 
2.30.2

