Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535613C249D
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhGINYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232489AbhGINYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D3B61377;
        Fri,  9 Jul 2021 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836881;
        bh=+vQ/RKk4o3iF05QhFC6jiy/Kv1kuBq/BiViPBBgALEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBfIFROU/3H3SG+5RXs4DXAVBYL1cMMAhrrapnlwkmP4w5SN1rHcRS+7zCbT+6Lx4
         dYn4QdG0WJQHI1HiJJSUY7azsmcz/sRjULxmuKhrR2Is7dnc0mR263XQFEeEi+pZ+H
         iFct3k8aN75mk66MNwjPOO7OXys5bQL94WdoeZgE=
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
Subject: [PATCH 4.19 13/34] mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
Date:   Fri,  9 Jul 2021 15:20:29 +0200
Message-Id: <20210709131651.890635683@linuxfoundation.org>
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

[ Upstream commit 3306d3119ceacc43ea8b141a73e21fea68eec30c ]

page_vma_mapped_walk() cleanup: re-evaluate pmde after taking lock, then
use it in subsequent tests, instead of repeatedly dereferencing pointer.

Link: https://lkml.kernel.org/r/53fbc9d-891e-46b2-cb4b-468c3b19238e@google.com
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
 mm/page_vma_mapped.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 036ce20bb154..7e1db77b096a 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -187,18 +187,19 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	pmde = READ_ONCE(*pvmw->pmd);
 	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-		if (likely(pmd_trans_huge(*pvmw->pmd))) {
+		pmde = *pvmw->pmd;
+		if (likely(pmd_trans_huge(pmde))) {
 			if (pvmw->flags & PVMW_MIGRATION)
 				return not_found(pvmw);
-			if (pmd_page(*pvmw->pmd) != page)
+			if (pmd_page(pmde) != page)
 				return not_found(pvmw);
 			return true;
-		} else if (!pmd_present(*pvmw->pmd)) {
+		} else if (!pmd_present(pmde)) {
 			if (thp_migration_supported()) {
 				if (!(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
-				if (is_migration_entry(pmd_to_swp_entry(*pvmw->pmd))) {
-					swp_entry_t entry = pmd_to_swp_entry(*pvmw->pmd);
+				if (is_migration_entry(pmd_to_swp_entry(pmde))) {
+					swp_entry_t entry = pmd_to_swp_entry(pmde);
 
 					if (migration_entry_to_page(entry) != page)
 						return not_found(pvmw);
-- 
2.30.2



