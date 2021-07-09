Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDD3C2462
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhGINWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhGINWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB37F613B6;
        Fri,  9 Jul 2021 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836781;
        bh=fCuk1x+i7LahFMyasqUG00yZ+DxnXDDtrPUV9Tfopi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzg3SNy1dniRmoBZT2SZp7Y3sBqxScoIiQGiobwSF10SP0UDmv8mnsBBDIOc8g0jb
         e31Z+2YIHgw8Gqq2sT2A6KYJSDOFzneiVak9IZ8HSPyfiN5+lTSPIVkWsn7sJ47PPz
         Rg/0AEDCKknoVVYhQOVIiyr4dVzNtVW4PpAx8Iss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/25] mm: page_vma_mapped_walk(): get vma_address_end() earlier
Date:   Fri,  9 Jul 2021 15:18:47 +0200
Message-Id: <20210709131637.656323384@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit a765c417d876cc635f628365ec9aa6f09470069a ]

page_vma_mapped_walk() cleanup: get THP's vma_address_end() at the
start, rather than later at next_pte.

It's a little unnecessary overhead on the first call, but makes for a
simpler loop in the following commit.

Link: https://lkml.kernel.org/r/4542b34d-862f-7cb4-bb22-e0df6ce830a2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
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
 mm/page_vma_mapped.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index f6c750539a6b..96d4c4738590 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -166,6 +166,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		return true;
 	}
 
+	/*
+	 * Seek to next pte only makes sense for THP.
+	 * But more important than that optimization, is to filter out
+	 * any PageKsm page: whose page->index misleads vma_address()
+	 * and vma_address_end() to disaster.
+	 */
+	end = PageTransCompound(page) ?
+		vma_address_end(page, pvmw->vma) :
+		pvmw->address + PAGE_SIZE;
 	if (pvmw->pte)
 		goto next_pte;
 restart:
@@ -233,10 +242,6 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		if (check_pte(pvmw))
 			return true;
 next_pte:
-		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(page))
-			return not_found(pvmw);
-		end = vma_address_end(page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
 			if (pvmw->address >= end)
-- 
2.30.2



