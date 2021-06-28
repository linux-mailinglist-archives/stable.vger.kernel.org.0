Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B429C3B615D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhF1Ofo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234387AbhF1Ocn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE0B61CDA;
        Mon, 28 Jun 2021 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890454;
        bh=rHBfLyP/itUhjYkC8InTE+BFl3QpcEGfh3Oc4i1OPj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlzpWpIGHJcSdeimaXX4SMRX8jpl4HW19HLLARDFN+jLLG1U+7v5byeQ6YXU8mU1C
         1fbtW0n5O8rrFsnJdmktmhbLbsKtFwIRMYyK6QVVpEummzASxmDo0zUG364OpeIhRZ
         fOT5w4OXOunomNpgb1dDPyAhQl0UlGZxtp7029LeIdr6CZc979eq1XW40sdpxfgKG6
         oAwOcsnAShbqvcoIsHvE2ukcqn8W8JNTjlRPHp3qV957gyotIxX3IsbxBN+Y8+XKe7
         ecrD5PIDGYDf8Y1mpRUb0EkQ4r09GuYY6Ld2NpbmstW1cQxZSApogd4NfvDVhuBITq
         wX5vnZZmUAS1Q==
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
Subject: [PATCH 5.10 085/101] mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
Date:   Mon, 28 Jun 2021 10:25:51 -0400
Message-Id: <20210628142607.32218-86-sashal@kernel.org>
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

commit e2e1d4076c77b3671cf8ce702535ae7dee3acf89 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 821147eca0e1..a9cd4e4b8d95 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -197,24 +197,22 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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

