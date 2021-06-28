Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C803B615C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhF1Ofm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhF1Ocm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F60261C78;
        Mon, 28 Jun 2021 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890449;
        bh=jDbXFuW69Sa1uTpxD6hJuAyy7dBV/d/YMeNzOzjjpG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bo5XVDGQpPQAxQeqA3pNBkqOj8G53W+Tl5Ux6tPtytHA87ENtz/JA//+dNGVn54Eh
         y1B7yWc2r5w1I85sFyg/dbyueXQLD16H4pBYLhkhgGWebk6WsQUu8uDaiKS77hQwjA
         uXjuYaTVmZRfnCsm1WdRuqQePr5dhM9teWAm2/xGgkujmL/1A7v1vuw30YeR1BZQzB
         WZ0GCIVZd3556IHc8yuxIrNHdgS1dNLu0Qwc54hawsLAy6fE3cSAK4kDj0cyIvW6bl
         od5J9vinObT54yxVeBaxwebk3SZBzrAU1XNdj/zc0ruxCIIr5QSFELcv8g3/hcYa/a
         ksgkXyrsLXB9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 082/101] mm: page_vma_mapped_walk(): use page for pvmw->page
Date:   Mon, 28 Jun 2021 10:25:48 -0400
Message-Id: <20210628142607.32218-83-sashal@kernel.org>
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

commit f003c03bd29e6f46fef1b9a8e8d636ac732286d5 upstream.

Patch series "mm: page_vma_mapped_walk() cleanup and THP fixes".

I've marked all of these for stable: many are merely cleanups, but I
think they are much better before the main fix than after.

This patch (of 11):

page_vma_mapped_walk() cleanup: sometimes the local copy of pvwm->page
was used, sometimes pvmw->page itself: use the local copy "page"
throughout.

Link: https://lkml.kernel.org/r/589b358c-febc-c88e-d4c2-7834b37fa7bf@google.com
Link: https://lkml.kernel.org/r/88e67645-f467-c279-bf5e-af4b5c6b13eb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a540af346f88..3cd41168e802 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -155,7 +155,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pte)
 		goto next_pte;
 
-	if (unlikely(PageHuge(pvmw->page))) {
+	if (unlikely(PageHuge(page))) {
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address, page_size(page));
 		if (!pvmw->pte)
@@ -216,8 +216,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 * cannot return prematurely, while zap_huge_pmd() has
 		 * cleared *pmd but not decremented compound_mapcount().
 		 */
-		if ((pvmw->flags & PVMW_SYNC) &&
-		    PageTransCompound(pvmw->page)) {
+		if ((pvmw->flags & PVMW_SYNC) && PageTransCompound(page)) {
 			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
 
 			spin_unlock(ptl);
@@ -233,9 +232,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
+		if (!PageTransHuge(page) || PageHuge(page))
 			return not_found(pvmw);
-		end = vma_address_end(pvmw->page, pvmw->vma);
+		end = vma_address_end(page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
 			if (pvmw->address >= end)
-- 
2.30.2

