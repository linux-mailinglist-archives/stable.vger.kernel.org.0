Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63243C248C
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhGINXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhGINXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0714A613BC;
        Fri,  9 Jul 2021 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836863;
        bh=RCu2xiVilPxlqzoPhe88uI4EXpZCTl29yHXl7WGWKVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ1iu9ed+aKRw33PG/SB04AIMX5le364iLnHLvbEchPeRNzWKtEFT0C9STvCQIJ1t
         2kwU8lfoS8o0eNbHbaV13AvFeBxakkFBGzC/hfqnjmQSBs86Zhc7IDi8VRNN3Ja7fj
         Jv28Dx2deAuuddfubHp9l/R0CY3on+2S3I1ikrZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/34] mm/thp: make is_huge_zero_pmd() safe and quicker
Date:   Fri,  9 Jul 2021 15:20:21 +0200
Message-Id: <20210709131647.961682868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 3b77e8c8cde581dadab9a0f1543a347e24315f11 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 8 +++++++-
 mm/huge_memory.c        | 5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e375f2249f52..becf9b1eae5a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -224,6 +224,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 extern vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
+extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_page(struct page *page)
 {
@@ -232,7 +233,7 @@ static inline bool is_huge_zero_page(struct page *page)
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_page(pmd_page(pmd));
+	return READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd) && pmd_present(pmd);
 }
 
 static inline bool is_huge_zero_pud(pud_t pud)
@@ -342,6 +343,11 @@ static inline bool is_huge_zero_page(struct page *page)
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
index ce6ca09840bd..82ed62775c00 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -62,6 +62,7 @@ static struct shrinker deferred_split_shrinker;
 
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -93,6 +94,7 @@ static struct page *get_huge_zero_page(void)
 		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
+	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
 
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
@@ -142,6 +144,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
+		WRITE_ONCE(huge_zero_pfn, ~0UL);
 		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
@@ -2152,7 +2155,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
-- 
2.30.2



