Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4266E3B6168
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhF1Ofz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234483AbhF1Ocr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439A161CDD;
        Mon, 28 Jun 2021 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890464;
        bh=s8lNDiuZotoSOodDqr/zgI3yS8B0ljGuHDkI3eMccW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5Jv5a0mqCfXsQg+ge5oKYCebeDmrq+F4buwaNMMtFfyjRSWGbEXR30y56X+UhtLa
         kttYP3CvkaRN0dN0iR/2y4yKQ3OuGadDaTJnv21aUR6YtIihjNTvP7LwaGd8kq4jXW
         PqDgAgzJQM0Mw0iTHHAjFqbkm8JONTyBvWP/R6mUWUQYnzaWgmJwTOfnN/pVKNR5tr
         3iIbJ8aPTEpl9ACtVU/fCwbRSyRq9GFwhExHEdwE+nl5ctLsOiATnCCZIj1Ik6noX9
         96PiY9GfP2bWwhm/T60hO/zhxxccW640M4vKTcpNKNWuKg7lmmyYvt7ik486ggCEIn
         5OybY8ZcQP9ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 091/101] mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
Date:   Mon, 28 Jun 2021 10:25:57 -0400
Message-Id: <20210628142607.32218-92-sashal@kernel.org>
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

commit a7a69d8ba88d8dcee7ef00e91d413a4bd003a814 upstream.

Aha! Shouldn't that quick scan over pte_none()s make sure that it holds
ptlock in the PVMW_SYNC case? That too might have been responsible for
BUGs or WARNs in split_huge_page_to_list() or its unmap_page(), though
I've never seen any.

Link: https://lkml.kernel.org/r/1bdf384c-8137-a149-2a1e-475a4791c3c@google.com
Link: https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Wang Yugui <wangyugui@e16-tech.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ad76a3d871d..610ebbee787c 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -275,6 +275,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 				goto restart;
 			}
 			pvmw->pte++;
+			if ((pvmw->flags & PVMW_SYNC) && !pvmw->ptl) {
+				pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
+				spin_lock(pvmw->ptl);
+			}
 		} while (pte_none(*pvmw->pte));
 
 		if (!pvmw->ptl) {
-- 
2.30.2

