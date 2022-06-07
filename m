Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF47541402
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355942AbiFGUJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359160AbiFGUJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED58EF053;
        Tue,  7 Jun 2022 11:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 010E8B81FF8;
        Tue,  7 Jun 2022 18:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6F5C385A2;
        Tue,  7 Jun 2022 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626390;
        bh=B98y2vdgP+u+2NmnWriGHOnxLlrmvAluSHKWKXdtuxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gj1uheWA4bj5KCZh1Y2NBmfjcKhtYAqNvevREUboV5sAUjwcn4dWtMW0MnJMyrQkq
         5dFtWK4TykKDRkMc0FWIHY4Lig9h5t1c+5MfNvktZHpBx8SriJSZcSQwWU5cs7AHnt
         9OF3mkYEdQ6YsdFBewcOiudLm6TrxYur95791mns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark ONeill <mao@tumblingdice.co.uk>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 361/772] dma-direct: dont fail on highmem CMA pages in dma_direct_alloc_pages
Date:   Tue,  7 Jun 2022 18:59:13 +0200
Message-Id: <20220607164959.652585754@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 92826e967535db2eb117db227b1191aaf98e4bb3 ]

When dma_direct_alloc_pages encounters a highmem page it just gives up
currently.  But what we really should do is to try memory using the
page allocator instead - without this platforms with a global highmem
CMA pool will fail all dma_alloc_pages allocations.

Fixes: efa70f2fdc84 ("dma-mapping: add a new dma_alloc_pages API")
Reported-by: Mark O'Neill <mao@tumblingdice.co.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 50f48e9e4598..0be095579010 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -115,7 +115,7 @@ static struct page *dma_direct_alloc_swiotlb(struct device *dev, size_t size)
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp)
+		gfp_t gfp, bool allow_highmem)
 {
 	int node = dev_to_node(dev);
 	struct page *page = NULL;
@@ -129,9 +129,12 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
 					   &phys_limit);
 	page = dma_alloc_contiguous(dev, size, gfp);
-	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
-		dma_free_contiguous(dev, page, size);
-		page = NULL;
+	if (page) {
+		if (!dma_coherent_ok(dev, page_to_phys(page), size) ||
+		    (!allow_highmem && PageHighMem(page))) {
+			dma_free_contiguous(dev, page, size);
+			page = NULL;
+		}
 	}
 again:
 	if (!page)
@@ -189,7 +192,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
 	if (!page)
 		return NULL;
 
@@ -262,7 +265,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
 
 	/* we always manually zero the memory once we are done */
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
 	if (!page)
 		return NULL;
 	if (PageHighMem(page)) {
@@ -370,19 +373,9 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 	if (force_dma_unencrypted(dev) && dma_direct_use_pool(dev, gfp))
 		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
 
-	page = __dma_direct_alloc_pages(dev, size, gfp);
+	page = __dma_direct_alloc_pages(dev, size, gfp, false);
 	if (!page)
 		return NULL;
-	if (PageHighMem(page)) {
-		/*
-		 * Depending on the cma= arguments and per-arch setup
-		 * dma_alloc_contiguous could return highmem pages.
-		 * Without remapping there is no way to return them here,
-		 * so log an error and fail.
-		 */
-		dev_info(dev, "Rejecting highmem page from CMA.\n");
-		goto out_free_pages;
-	}
 
 	ret = page_address(page);
 	if (dma_set_decrypted(dev, ret, size))
-- 
2.35.1



