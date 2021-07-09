Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909DB3C2463
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhGINWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhGINW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C75613B6;
        Fri,  9 Jul 2021 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836785;
        bh=LzQScFlq+nvLefsxylDxfr3lrPiQxJhtYv33CzkgE24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqVoH9nAgEQHRNjCjSPY8QZIO057w6NBqZLoJ82a1OGHfxbe4Yz4ZSleHsdgp2hI0
         pb7eu/4cgZg/rW0LdQiD/u4IFYxbOe259f80dPxByGhCeDvYt5gZDAOEbQmH++Gcb4
         5g/OVM+xDYyhmhVHH6J08uGOIgDtXBBXoNew2+uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/25] mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
Date:   Fri,  9 Jul 2021 15:18:49 +0200
Message-Id: <20210709131638.887630622@linuxfoundation.org>
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

[ Upstream commit a7a69d8ba88d8dcee7ef00e91d413a4bd003a814 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 16adeef76d00..a612daef5f00 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -271,6 +271,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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



