Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6943C246B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhGINWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhGINWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA60613BC;
        Fri,  9 Jul 2021 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836792;
        bh=ux4zR06faPp9Ys1w7i/4mnkDIWMEOEcacmpVeC9J9TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmcHxBGqEeY8yPB8ic62FDnDp1DS6RFq3unevyR9366bcJK/R0B+SSEDGU4/MC2vV
         SxsszjkIboEZeMNR8qCF8wWiBjbcMGcfbEKcF4gmg/Fj630ibhF0oeR+JDFu4Yy5/H
         Oeyn1eI3Nuzfu+xvyngDaVTuSaRcZbqs9X0gHJY4=
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
Subject: [PATCH 4.14 12/25] mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
Date:   Fri,  9 Jul 2021 15:18:43 +0200
Message-Id: <20210709131635.058161631@linuxfoundation.org>
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

[ Upstream commit e2e1d4076c77b3671cf8ce702535ae7dee3acf89 ]

page_vma_mapped_walk() cleanup: rearrange the !pmd_present() block to
follow the same "return not_found, return not_found, return true"
pattern as the block above it (note: returning not_found there is never
premature, since existence or prior existence of huge pmd guarantees
good alignment).

Link: https://lkml.kernel.org/r/378c8650-1488-2edf-9647-32a53cf2e21@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
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
 mm/page_vma_mapped.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 8a6af4007c7e..92d7f574b8ab 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -193,24 +193,22 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			if (pmd_page(pmde) != page)
 				return not_found(pvmw);
 			return true;
-		} else if (!pmd_present(pmde)) {
-			if (thp_migration_supported()) {
-				if (!(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
-				if (is_migration_entry(pmd_to_swp_entry(pmde))) {
-					swp_entry_t entry = pmd_to_swp_entry(pmde);
+		}
+		if (!pmd_present(pmde)) {
+			swp_entry_t entry;
 
-					if (migration_entry_to_page(entry) != page)
-						return not_found(pvmw);
-					return true;
-				}
-			}
-			return not_found(pvmw);
-		} else {
-			/* THP pmd was split under us: handle on pte level */
-			spin_unlock(pvmw->ptl);
-			pvmw->ptl = NULL;
+			if (!thp_migration_supported() ||
+			    !(pvmw->flags & PVMW_MIGRATION))
+				return not_found(pvmw);
+			entry = pmd_to_swp_entry(pmde);
+			if (!is_migration_entry(entry) ||
+			    migration_entry_to_page(entry) != page)
+				return not_found(pvmw);
+			return true;
 		}
+		/* THP pmd was split under us: handle on pte level */
+		spin_unlock(pvmw->ptl);
+		pvmw->ptl = NULL;
 	} else if (!pmd_present(pmde)) {
 		/*
 		 * If PVMW_SYNC, take and drop THP pmd lock so that we
-- 
2.30.2



