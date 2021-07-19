Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537093CD992
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbhGSOat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244223AbhGSO32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F136120A;
        Mon, 19 Jul 2021 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707338;
        bh=MkA7JpnR5IKWj3YGXYf0kS7gG1tFG56PH0QWaBT1mxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys1o2IYOH6QuXjTTZTt8q8bsfQcn9k8thOx4KeT+klV0AqZMDQHxNl7PaZ3hORBBf
         iqbC5qJVTHeDNzocbXMVWPKXs2H4S1Annf1oY7xgkBdJ+LxmZDzT/msu48toLzkrwE
         lkRm3lmGvpMQImgvAuU5p6fK8rOlJ8A5xwHhyNhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Rik van Riel <riel@surriel.com>,
        Song Liu <songliubraving@fb.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Zi Yan <ziy@nvidia.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 120/245] mm/huge_memory.c: dont discard hugepage if other processes are mapping it
Date:   Mon, 19 Jul 2021 16:51:02 +0200
Message-Id: <20210719144944.297468476@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit babbbdd08af98a59089334eb3effbed5a7a0cf7f ]

If other processes are mapping any other subpages of the hugepage, i.e.
in pte-mapped thp case, page_mapcount() will return 1 incorrectly.  Then
we would discard the page while other processes are still mapping it.  Fix
it by using total_mapcount() which can tell whether other processes are
still mapping it.

Link: https://lkml.kernel.org/r/20210511134857.1581273-6-linmiaohe@huawei.com
Fixes: b8d3c4c3009d ("mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called")
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 177ca028b986..91f33bb43f17 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1369,7 +1369,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 * If other processes are mapping this page, we couldn't discard
 	 * the page unless they all do MADV_FREE so let's skip the page.
 	 */
-	if (page_mapcount(page) != 1)
+	if (total_mapcount(page) != 1)
 		goto out;
 
 	if (!trylock_page(page))
-- 
2.30.2



