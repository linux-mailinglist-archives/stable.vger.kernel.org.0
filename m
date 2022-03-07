Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5084CF878
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiCGJzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238726AbiCGJyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:54:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A515178043;
        Mon,  7 Mar 2022 01:45:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AEB361052;
        Mon,  7 Mar 2022 09:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64210C340F3;
        Mon,  7 Mar 2022 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646320;
        bh=L9DEQvury+XcVkvoyTXNeEmq0xdtPhU4GEYWU4ZrIl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Msc0qdrxV1MBzLkNi7voeVTjVRwTRmU5ykA9SxIGuC72RMoE3IRnV9M6io73HutEb
         hd+2LEJI5Z8dptMW3yMVUXpV92rdwpD0+1LpGdKUEX9+Jtg23uE4HqcBmiTIQd3g3C
         d9by8SKMOAB9fBk1VO+jbFb3ZadqeA7UsngFVokw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/262] iommu/amd: Simplify pagetable freeing
Date:   Mon,  7 Mar 2022 10:19:08 +0100
Message-Id: <20220307091708.503365189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 6b3106e9ba2de7320a71291cedcefdcf1195ad58 ]

For reasons unclear, pagetable freeing is an effectively recursive
method implemented via an elaborate system of templated functions that
turns out to account for 25% of the object file size. Implementing it
using regular straightforward recursion makes the code simpler, and
seems like a good thing to do before we work on it further. As part of
that, also fix the types to avoid all the needless casting back and
forth which just gets in the way.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/d3d00c9f3fa0df4756b867072c201e6e82f9ce39.1639753638.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 82 ++++++++++++++--------------------
 1 file changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 182c93a43efd..4165e1372b6e 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -84,49 +84,45 @@ static void free_page_list(struct page *freelist)
 	}
 }
 
-static struct page *free_pt_page(unsigned long pt, struct page *freelist)
+static struct page *free_pt_page(u64 *pt, struct page *freelist)
 {
-	struct page *p = virt_to_page((void *)pt);
+	struct page *p = virt_to_page(pt);
 
 	p->freelist = freelist;
 
 	return p;
 }
 
-#define DEFINE_FREE_PT_FN(LVL, FN)						\
-static struct page *free_pt_##LVL (unsigned long __pt, struct page *freelist)	\
-{										\
-	unsigned long p;							\
-	u64 *pt;								\
-	int i;									\
-										\
-	pt = (u64 *)__pt;							\
-										\
-	for (i = 0; i < 512; ++i) {						\
-		/* PTE present? */						\
-		if (!IOMMU_PTE_PRESENT(pt[i]))					\
-			continue;						\
-										\
-		/* Large PTE? */						\
-		if (PM_PTE_LEVEL(pt[i]) == 0 ||					\
-		    PM_PTE_LEVEL(pt[i]) == 7)					\
-			continue;						\
-										\
-		p = (unsigned long)IOMMU_PTE_PAGE(pt[i]);			\
-		freelist = FN(p, freelist);					\
-	}									\
-										\
-	return free_pt_page((unsigned long)pt, freelist);			\
-}
+static struct page *free_pt_lvl(u64 *pt, struct page *freelist, int lvl)
+{
+	u64 *p;
+	int i;
+
+	for (i = 0; i < 512; ++i) {
+		/* PTE present? */
+		if (!IOMMU_PTE_PRESENT(pt[i]))
+			continue;
 
-DEFINE_FREE_PT_FN(l2, free_pt_page)
-DEFINE_FREE_PT_FN(l3, free_pt_l2)
-DEFINE_FREE_PT_FN(l4, free_pt_l3)
-DEFINE_FREE_PT_FN(l5, free_pt_l4)
-DEFINE_FREE_PT_FN(l6, free_pt_l5)
+		/* Large PTE? */
+		if (PM_PTE_LEVEL(pt[i]) == 0 ||
+		    PM_PTE_LEVEL(pt[i]) == 7)
+			continue;
 
-static struct page *free_sub_pt(unsigned long root, int mode,
-				struct page *freelist)
+		/*
+		 * Free the next level. No need to look at l1 tables here since
+		 * they can only contain leaf PTEs; just free them directly.
+		 */
+		p = IOMMU_PTE_PAGE(pt[i]);
+		if (lvl > 2)
+			freelist = free_pt_lvl(p, freelist, lvl - 1);
+		else
+			freelist = free_pt_page(p, freelist);
+	}
+
+	return free_pt_page(pt, freelist);
+}
+
+static struct page *free_sub_pt(u64 *root, int mode, struct page *freelist)
 {
 	switch (mode) {
 	case PAGE_MODE_NONE:
@@ -136,19 +132,11 @@ static struct page *free_sub_pt(unsigned long root, int mode,
 		freelist = free_pt_page(root, freelist);
 		break;
 	case PAGE_MODE_2_LEVEL:
-		freelist = free_pt_l2(root, freelist);
-		break;
 	case PAGE_MODE_3_LEVEL:
-		freelist = free_pt_l3(root, freelist);
-		break;
 	case PAGE_MODE_4_LEVEL:
-		freelist = free_pt_l4(root, freelist);
-		break;
 	case PAGE_MODE_5_LEVEL:
-		freelist = free_pt_l5(root, freelist);
-		break;
 	case PAGE_MODE_6_LEVEL:
-		freelist = free_pt_l6(root, freelist);
+		free_pt_lvl(root, freelist, mode);
 		break;
 	default:
 		BUG();
@@ -364,7 +352,7 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
 
 static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
 {
-	unsigned long pt;
+	u64 *pt;
 	int mode;
 
 	while (cmpxchg64(pte, pteval, 0) != pteval) {
@@ -375,7 +363,7 @@ static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
 	if (!IOMMU_PTE_PRESENT(pteval))
 		return freelist;
 
-	pt   = (unsigned long)IOMMU_PTE_PAGE(pteval);
+	pt   = IOMMU_PTE_PAGE(pteval);
 	mode = IOMMU_PTE_MODE(pteval);
 
 	return free_sub_pt(pt, mode, freelist);
@@ -512,7 +500,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
 	struct protection_domain *dom;
 	struct page *freelist = NULL;
-	unsigned long root;
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
@@ -529,8 +516,7 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
-	root = (unsigned long)pgtable->root;
-	freelist = free_sub_pt(root, pgtable->mode, freelist);
+	freelist = free_sub_pt(pgtable->root, pgtable->mode, freelist);
 
 	free_page_list(freelist);
 }
-- 
2.34.1



