Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A908F3B6160
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhF1Ofq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234382AbhF1Ocn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D8E61CD8;
        Mon, 28 Jun 2021 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890453;
        bh=W1olFC36KB5osmSIm23mU0isLbt3CIIo1uPLG48GB84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhuuIvV9/VTx7lAjEVWmI1P2+3rgLokxe7u7nUYRFjT2dqUfg97Z5Dl8rf/28q775
         r8/+hdYnKpt006r/HHCpBKdDkBLI8/SE0s1/kTTrQzE0UgoFHRpmVSwxIRt6H8i9Ak
         A37ZgVZxBZYSU2LEzsu+tZgXXcGT8jZjrLdRqWNY/qoj/cZADwHq/lieWCw9kAsba1
         Bnt+b7lQYmx+sMWVWIDhAlQQtVHMoaChj06YXbNAhcRuVosnOU3Uosn0Z3rcgc1nwp
         gG3fZw8IX+B+qZfKKizgO17QZufcpfZFpDtJ75liPLAUulffVx9WdAJ3Ud5vZCSQeG
         Ww8N6bWCRyS/A==
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
Subject: [PATCH 5.10 084/101] mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
Date:   Mon, 28 Jun 2021 10:25:50 -0400
Message-Id: <20210628142607.32218-85-sashal@kernel.org>
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

commit 3306d3119ceacc43ea8b141a73e21fea68eec30c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 4f04472effb7..821147eca0e1 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -190,18 +190,19 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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

