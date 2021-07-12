Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D583C503F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344361AbhGLHbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344401AbhGLH3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4107061453;
        Mon, 12 Jul 2021 07:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074698;
        bh=sotzp4vjjswgvpon5TPoI2fGgunuSzPX7j+uzbSC46g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU+opw+WvwbxqZj3J2hAL/w+JX5yRmkzMDTevZc1A5fsLfKKmz2bWqslK/VU4IKZf
         y2YzzhQrR9KgJ0aWHqoylqx39xCcENHOgiug+2QuDsgrqN5uHE4TJDpq7sChRp7C0H
         GSiApkk6TVoU63rfWXFavmJX4Ec9Uc2xLZYnYyOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Yang Shi <shy828301@gmail.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Song Liu <songliubraving@fb.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 665/700] mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
Date:   Mon, 12 Jul 2021 08:12:28 +0200
Message-Id: <20210712061046.648021828@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit b2bd53f18bb7f7cfc91b3bb527d7809376700a8e ]

Patch series "Cleanup and fixup for huge_memory:, v3.

This series contains cleanups to remove dedicated macro and remove
unnecessary tlb_remove_page_size() for huge zero pmd.  Also this adds
missing read-only THP checking for transparent_hugepage_enabled() and
avoids discarding hugepage if other processes are mapping it.  More
details can be found in the respective changelogs.

Thi patch (of 5):

Rewrite the pgoff checking logic to remove macro HPAGE_CACHE_INDEX_MASK
which is only used here to simplify the code.

Link: https://lkml.kernel.org/r/20210511134857.1581273-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210511134857.1581273-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 6686a0baa91d..2a7c58ea5ca9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -155,15 +155,13 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma);
 
-#define HPAGE_CACHE_INDEX_MASK (HPAGE_PMD_NR - 1)
-
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 		unsigned long haddr)
 {
 	/* Don't have to check pgoff for anonymous vma */
 	if (!vma_is_anonymous(vma)) {
-		if (((vma->vm_start >> PAGE_SHIFT) & HPAGE_CACHE_INDEX_MASK) !=
-			(vma->vm_pgoff & HPAGE_CACHE_INDEX_MASK))
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
 			return false;
 	}
 
-- 
2.30.2



