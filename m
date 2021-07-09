Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51F3C24A9
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhGINY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232577AbhGINYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4EF613BC;
        Fri,  9 Jul 2021 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836889;
        bh=t8grLhG3YTVlkblOGGEEdKFZlpu5vsA8CSBgolTcLLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXsTyW0oIUOn59QK02/OEvfZhaoeDVeeb7v3QU9IyF0R2CYVDFdI5eJO12ELJHts0
         WL2eUCWR0UmgxiPmMj2+58Osrgy9jpO573Gt4gM9nEmN0/wDzsCYfH9HvD0fhlv3aq
         Ec/+HSpfNPeF8w7sAxC8OoL3ed9bw9ws1CimcOOo=
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
Subject: [PATCH 4.19 17/34] mm: page_vma_mapped_walk(): use goto instead of while (1)
Date:   Fri,  9 Jul 2021 15:20:33 +0200
Message-Id: <20210709131653.994604112@linuxfoundation.org>
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

[ Upstream commit 474466301dfd8b39a10c01db740645f3f7ae9a28 ]

page_vma_mapped_walk() cleanup: add a label this_pte, matching next_pte,
and use "goto this_pte", in place of the "while (1)" loop at the end.

Link: https://lkml.kernel.org/r/a52b234a-851-3616-2525-f42736e8934@google.com
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
 mm/page_vma_mapped.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 819945678264..470f19c917ad 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -139,6 +139,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 {
 	struct mm_struct *mm = pvmw->vma->vm_mm;
 	struct page *page = pvmw->page;
+	unsigned long end;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -229,10 +230,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
-	}
-	while (1) {
-		unsigned long end;
-
+this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
@@ -261,6 +259,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
 			spin_lock(pvmw->ptl);
 		}
+		goto this_pte;
 	}
 }
 
-- 
2.30.2



