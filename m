Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B6F3B604E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhF1OXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhF1OWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F43961C9B;
        Mon, 28 Jun 2021 14:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889985;
        bh=/5uUQ4MN1I+SGvaJR6l/Uk/IS44o29wOm+SzzHc73SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVpunEbeoWHSUv8r/AIhhMvjU7BJ6OgN8O/cbgKLCrgrUL4JltoAAo9Bw+aPkI/dM
         lVQPs1syqEuiYAgjh7ut1bJFt4yHyhT1Wwp8e0VvQInNrW5i/S/h6jFSd0vqe7RWKx
         /OGbhxVFep2zKTFUgMlnM2S5RfOshWEltEvOCrC9JFPQNBjVCYuXD24YmMoBU79NrA
         b7qMpOyWyB/1p2FswR0kQtM3Evg1hQB1UQqw4qfcC8tCeRkXdAoZL5jVakSXhJYQbD
         hkGb9hNDPp2kDKE+aauF6eXJWVnyq0xZ+rei/QrCIBrWH6iI6isI+JAil/R5dOtQcx
         ITPUaBcbEMgag==
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
Subject: [PATCH 5.12 084/110] mm/thp: make is_huge_zero_pmd() safe and quicker
Date:   Mon, 28 Jun 2021 10:18:02 -0400
Message-Id: <20210628141828.31757-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index ba973efcd369..6686a0baa91d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -289,6 +289,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
+extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_page(struct page *page)
 {
@@ -297,7 +298,7 @@ static inline bool is_huge_zero_page(struct page *page)
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_page(pmd_page(pmd));
+	return READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd) && pmd_present(pmd);
 }
 
 static inline bool is_huge_zero_pud(pud_t pud)
@@ -443,6 +444,11 @@ static inline bool is_huge_zero_page(struct page *page)
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
index cd37a0829881..e1ad01e68aa3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -61,6 +61,7 @@ static struct shrinker deferred_split_shrinker;
 
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -97,6 +98,7 @@ retry:
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
@@ -2073,7 +2076,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
-- 
2.30.2

