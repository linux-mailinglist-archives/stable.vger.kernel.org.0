Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C31D3C24B0
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhGINYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232678AbhGINYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31FEB6128A;
        Fri,  9 Jul 2021 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836900;
        bh=VPYg+gYG9B48gBonf0ESjQvQD7h0rzxdvKK521vd63A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGGGIRy/BNx0PWPl9rrZSHXBq/+T36+c9LyocLNb6VVjoUbnIWzWc7MiuV7rNUdz6
         HBeCzA6pwne+BVrObXssqmuf+EzPC1acVNjdODnamyNKmgdoMaQLOOHw+yfEO6KTCe
         g/vvDEjySVBicVgZwqCPdfz7SO91W+h8cE9JVzKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Xu <peterx@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/34] mm: page_vma_mapped_walk(): settle PageHuge on entry
Date:   Fri,  9 Jul 2021 15:20:28 +0200
Message-Id: <20210709131651.384469016@linuxfoundation.org>
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

[ Upstream commit 6d0fd5987657cb0c9756ce684e3a74c0f6351728 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index d146f6d31a62..036ce20bb154 100644
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
 		pvmw->pte = huge_pte_offset(mm, pvmw->address,
 					    PAGE_SIZE << compound_order(page));
@@ -164,6 +165,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return not_found(pvmw);
 		return true;
 	}
+
+	if (pvmw->pte)
+		goto next_pte;
 restart:
 	pgd = pgd_offset(mm, pvmw->address);
 	if (!pgd_present(*pgd))
@@ -229,7 +233,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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



