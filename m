Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE03B61EB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhF1OkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhF1Oi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:38:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B55F961CB2;
        Mon, 28 Jun 2021 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890668;
        bh=eGZlP7WhIAtLq9AagtfTUSGfkWWGIVKLricYhgXh6TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSm7BrlzMm3dEcJranrLdfIO36XdeJNWPzV58XWj5WONzqJ77NoeVRj/DcMqg11R/
         uGFonq1C1Noh5J1uEEXFwswQUL0MNUHgiyGrfVYtx/lKXuKDeDhLv4nHWpumixO5va
         yFhmS+oRh9mH5nO74GADvhtOVsxgB3eRH2cPGB0ntIMf5Sk1rZ2BEL8vvi3suQyfWB
         asO7IxD5jTHT3g+VcSOm1xnEx2CCILqTV/lIAfSPrY/Vn2G5oaWLkBtbg+YNHnSKNc
         PTcvJ8DvF2hbeOPCL2gmHa401m5D6OhpzBCBWp2z1Sl44J+TbewgKa7P0l5n/e6BdO
         TJ/XQBdDtYByQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Xu <peterx@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 57/71] mm: page_vma_mapped_walk(): settle PageHuge on entry
Date:   Mon, 28 Jun 2021 10:29:50 -0400
Message-Id: <20210628143004.32596-58-sashal@kernel.org>
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

page_vma_mapped_walk() cleanup: get the hugetlbfs PageHuge case out of
the way at the start, so no need to worry about it later.

Link: https://lkml.kernel.org/r/e31a483c-6d73-a6bb-26c5-43c3b880a2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2e448636b752..ebf021d4e68b 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -148,10 +148,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
 
-	if (pvmw->pte)
-		goto next_pte;
-
 	if (unlikely(PageHuge(page))) {
+		/* The only possible mapping was handled on last iteration */
+		if (pvmw->pte)
+			return not_found(pvmw);
+
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address, page_size(page));
 		if (!pvmw->pte)
@@ -163,6 +164,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return not_found(pvmw);
 		return true;
 	}
+
+	if (pvmw->pte)
+		goto next_pte;
 restart:
 	pgd = pgd_offset(mm, pvmw->address);
 	if (!pgd_present(*pgd))
@@ -228,7 +232,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(page) || PageHuge(page))
+		if (!PageTransHuge(page))
 			return not_found(pvmw);
 		end = vma_address_end(page, pvmw->vma);
 		do {
-- 
2.30.2

