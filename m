Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F022D3B605B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhF1OYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233453AbhF1OWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA6FC61C9A;
        Mon, 28 Jun 2021 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890000;
        bh=/T0NgUNLlHQxXeJfsdo6sY1LVxTJRT816Y7bt8dNuII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJmTCtXlhDw3r6Zd+uKbbUiEvElVCCkTe4Zahp0DF9+tMx9Rv/ydSF8z18TwsYjpN
         nwisnB6W9efWJC0KBq9NMOTQCSFGYJDyWf/BaUwmrYRrXlhBQxDVZzpxS13ApcQMnC
         1mzro+URvZiGJY6ul1EUm6zXiNbPk8eM/wJjzHiHAm+0N6D9Ut9IrILK0qLX3XlUUF
         Q1k5FDmYzX7bbPhtWBp0Nm4h96qLCs+ZzLTtisoUzegil9CWF171sWRIGBFihaaA9P
         3Or/cQMWXJspOzmTE8G1MGa14sIkdPo3IZgYctjR7pyXsihnYKcv1TNlBsOLJR3BXh
         vtyCXE1O5MWxg==
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
Subject: [PATCH 5.12 091/110] mm: page_vma_mapped_walk(): settle PageHuge on entry
Date:   Mon, 28 Jun 2021 10:18:09 -0400
Message-Id: <20210628141828.31757-92-sashal@kernel.org>
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

commit 6d0fd5987657cb0c9756ce684e3a74c0f6351728 upstream.

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
index ba24ac8e2377..9085d09c5bc3 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -153,10 +153,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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
@@ -168,6 +169,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return not_found(pvmw);
 		return true;
 	}
+
+	if (pvmw->pte)
+		goto next_pte;
 restart:
 	pgd = pgd_offset(mm, pvmw->address);
 	if (!pgd_present(*pgd))
@@ -233,7 +237,7 @@ restart:
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

