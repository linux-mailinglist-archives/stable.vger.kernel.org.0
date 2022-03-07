Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74E94CFA12
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiCGKM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242620AbiCGKLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81D48BE3E;
        Mon,  7 Mar 2022 01:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 066C1B810BF;
        Mon,  7 Mar 2022 09:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F378C340E9;
        Mon,  7 Mar 2022 09:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646890;
        bh=IiS7yHaWm4QOG2+YIP3ZKm2D0uUzYZnty3HNZZCfhAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+yAeEpPOLRehGUF3+N04MuuiTt8dWtbq/d+1DDaKcKtqGiRl30AQCK8oAG0g8Eho
         Y5DMsXCiakn8ThEBsovwQdpmOJ2fxQeIcqX+jKv3GGmBcOJTCIyHcUMwgPzDIqfn7J
         q42nCo5aXaJlWFuj373twAYOemIgUTOVe0Zs6n4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 125/186] iommu/amd: Use put_pages_list
Date:   Mon,  7 Mar 2022 10:19:23 +0100
Message-Id: <20220307091657.575653803@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ce00eece6909c266da123fd147172d745a4f14a0 ]

page->freelist is for the use of slab.  We already have the ability
to free a list of pages in the core mm, but it requires the use of a
list_head and for the pages to be chained together through page->lru.
Switch the AMD IOMMU code over to using free_pages_list().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[rm: split from original patch, cosmetic tweaks]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/73af128f651aaa1f38f69e586c66765a88ad2de0.1639753638.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 50 ++++++++++++----------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 4165e1372b6e..b1bf4125b0f7 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -74,26 +74,14 @@ static u64 *first_pte_l7(u64 *pte, unsigned long *page_size,
  *
  ****************************************************************************/
 
-static void free_page_list(struct page *freelist)
-{
-	while (freelist != NULL) {
-		unsigned long p = (unsigned long)page_address(freelist);
-
-		freelist = freelist->freelist;
-		free_page(p);
-	}
-}
-
-static struct page *free_pt_page(u64 *pt, struct page *freelist)
+static void free_pt_page(u64 *pt, struct list_head *freelist)
 {
 	struct page *p = virt_to_page(pt);
 
-	p->freelist = freelist;
-
-	return p;
+	list_add_tail(&p->lru, freelist);
 }
 
-static struct page *free_pt_lvl(u64 *pt, struct page *freelist, int lvl)
+static void free_pt_lvl(u64 *pt, struct list_head *freelist, int lvl)
 {
 	u64 *p;
 	int i;
@@ -114,22 +102,22 @@ static struct page *free_pt_lvl(u64 *pt, struct page *freelist, int lvl)
 		 */
 		p = IOMMU_PTE_PAGE(pt[i]);
 		if (lvl > 2)
-			freelist = free_pt_lvl(p, freelist, lvl - 1);
+			free_pt_lvl(p, freelist, lvl - 1);
 		else
-			freelist = free_pt_page(p, freelist);
+			free_pt_page(p, freelist);
 	}
 
-	return free_pt_page(pt, freelist);
+	free_pt_page(pt, freelist);
 }
 
-static struct page *free_sub_pt(u64 *root, int mode, struct page *freelist)
+static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
 {
 	switch (mode) {
 	case PAGE_MODE_NONE:
 	case PAGE_MODE_7_LEVEL:
 		break;
 	case PAGE_MODE_1_LEVEL:
-		freelist = free_pt_page(root, freelist);
+		free_pt_page(root, freelist);
 		break;
 	case PAGE_MODE_2_LEVEL:
 	case PAGE_MODE_3_LEVEL:
@@ -141,8 +129,6 @@ static struct page *free_sub_pt(u64 *root, int mode, struct page *freelist)
 	default:
 		BUG();
 	}
-
-	return freelist;
 }
 
 void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
@@ -350,7 +336,7 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
 	return pte;
 }
 
-static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
+static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
 {
 	u64 *pt;
 	int mode;
@@ -361,12 +347,12 @@ static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
 	}
 
 	if (!IOMMU_PTE_PRESENT(pteval))
-		return freelist;
+		return;
 
 	pt   = IOMMU_PTE_PAGE(pteval);
 	mode = IOMMU_PTE_MODE(pteval);
 
-	return free_sub_pt(pt, mode, freelist);
+	free_sub_pt(pt, mode, freelist);
 }
 
 /*
@@ -380,7 +366,7 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 			  phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
-	struct page *freelist = NULL;
+	LIST_HEAD(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
 	int ret, i, count;
@@ -400,9 +386,9 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 		goto out;
 
 	for (i = 0; i < count; ++i)
-		freelist = free_clear_pte(&pte[i], pte[i], freelist);
+		free_clear_pte(&pte[i], pte[i], &freelist);
 
-	if (freelist != NULL)
+	if (!list_empty(&freelist))
 		updated = true;
 
 	if (count > 1) {
@@ -437,7 +423,7 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 	/* Everything flushed out, free pages now */
-	free_page_list(freelist);
+	put_pages_list(&freelist);
 
 	return ret;
 }
@@ -499,7 +485,7 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
 	struct protection_domain *dom;
-	struct page *freelist = NULL;
+	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
@@ -516,9 +502,9 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
-	freelist = free_sub_pt(pgtable->root, pgtable->mode, freelist);
+	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
 
-	free_page_list(freelist);
+	put_pages_list(&freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
-- 
2.34.1



