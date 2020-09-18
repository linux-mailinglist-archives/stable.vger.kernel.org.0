Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8530E26F355
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgIRDF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgIRCES (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED2423787;
        Fri, 18 Sep 2020 02:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394657;
        bh=O5UZ/5EyTSvCwoT/JNeDHA7crSRj5y5CGSOTMxMfXvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2+kTU0dWIN1+ZgN13cOEZffQDMaLFpbG1y+pQ2KAFJJTN5EecCMctWTbasIUB3yn
         a4vKAz2hKGQYZF+WdymEPcg+uTUJjOUf1mgc90RY3hRiuk+KZR3hVlFbMbm+uS+tkK
         K1A/9J8OssdoIyy2iQ5eiHJKSP6aKt++f1i5Eumk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, Jan Kara <jack@suse.cz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 153/330] powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()
Date:   Thu, 17 Sep 2020 21:58:13 -0400
Message-Id: <20200918020110.2063155-153-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit c4b78169e3667413184c9a20e11b5832288a109f ]

The last jump to free_exit in mm_iommu_do_alloc() happens after page
pointers in struct mm_iommu_table_group_mem_t were already converted to
physical addresses. Thus calling put_page() on these physical addresses
will likely crash.

This moves the loop which calculates the pageshift and converts page
struct pointers to physical addresses later after the point when
we cannot fail; thus eliminating the need to convert pointers back.

Fixes: eb9d7a62c386 ("powerpc/mm_iommu: Fix potential deadlock")
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191223060351.26359-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/iommu_api.c | 39 +++++++++++++++-------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 56cc845205779..ef164851738b8 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -121,24 +121,6 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 		goto free_exit;
 	}
 
-	pageshift = PAGE_SHIFT;
-	for (i = 0; i < entries; ++i) {
-		struct page *page = mem->hpages[i];
-
-		/*
-		 * Allow to use larger than 64k IOMMU pages. Only do that
-		 * if we are backed by hugetlb.
-		 */
-		if ((mem->pageshift > PAGE_SHIFT) && PageHuge(page))
-			pageshift = page_shift(compound_head(page));
-		mem->pageshift = min(mem->pageshift, pageshift);
-		/*
-		 * We don't need struct page reference any more, switch
-		 * to physical address.
-		 */
-		mem->hpas[i] = page_to_pfn(page) << PAGE_SHIFT;
-	}
-
 good_exit:
 	atomic64_set(&mem->mapped, 1);
 	mem->used = 1;
@@ -158,6 +140,27 @@ good_exit:
 		}
 	}
 
+	if (mem->dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
+		/*
+		 * Allow to use larger than 64k IOMMU pages. Only do that
+		 * if we are backed by hugetlb. Skip device memory as it is not
+		 * backed with page structs.
+		 */
+		pageshift = PAGE_SHIFT;
+		for (i = 0; i < entries; ++i) {
+			struct page *page = mem->hpages[i];
+
+			if ((mem->pageshift > PAGE_SHIFT) && PageHuge(page))
+				pageshift = page_shift(compound_head(page));
+			mem->pageshift = min(mem->pageshift, pageshift);
+			/*
+			 * We don't need struct page reference any more, switch
+			 * to physical address.
+			 */
+			mem->hpas[i] = page_to_pfn(page) << PAGE_SHIFT;
+		}
+	}
+
 	list_add_rcu(&mem->next, &mm->context.iommu_group_mem_list);
 
 	mutex_unlock(&mem_list_mutex);
-- 
2.25.1

