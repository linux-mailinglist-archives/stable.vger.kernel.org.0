Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED863B3A81
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhFYBl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232995AbhFYBl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF3F61220;
        Fri, 25 Jun 2021 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585148;
        bh=g388FPOFF40U7bgNaSbXUv8OoPGn9DECSaYWswFcrcY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hNszIN1dMuGS+4StiUKiQS0blt8w3TjOJH47TqyMEfFndoMrqieH5Usv1Qexj3HZh
         ZWkh2HVkUH7K3LHPqHdVBqtFotaev7YUxOn0iJMZ4urDxldFtLC7eFv0+Kh6N4YJp6
         cqkugeSZLHt1EqEI4opjtXBlwnule3xXZh25g6ZQ=
Date:   Thu, 24 Jun 2021 18:39:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        will@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 03/24] mm: page_vma_mapped_walk(): use pmde for
 *pvmw->pmd
Message-ID: <20210625013907.PBDZuqY27%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd

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
---

 mm/page_vma_mapped.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd
+++ a/mm/page_vma_mapped.c
@@ -191,18 +191,19 @@ restart:
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
_
