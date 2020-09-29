Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE4027C906
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgI2MGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730248AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4338623ABA;
        Tue, 29 Sep 2020 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379403;
        bh=O5UZ/5EyTSvCwoT/JNeDHA7crSRj5y5CGSOTMxMfXvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czYsKAIAAgNDAw2zFxYk42X+ZK1l4QO+so72rpd+9U/0jrUatLhDjj3c5h81VC+4+
         Kkt23+mOO573+7Sj0XWnYZ+JnwC1G8BDjVYFp7mCH6DPiOcoQWMqoaluSSOQ4z1f4b
         acSNesykfgjz780Xlw5CoawrBq2jI1LQ1eq+ZJDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/388] powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()
Date:   Tue, 29 Sep 2020 12:57:58 +0200
Message-Id: <20200929110017.589229119@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



