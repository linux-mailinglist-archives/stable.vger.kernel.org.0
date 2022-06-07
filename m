Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0170E540BB5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbiFGSbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350843AbiFGS2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670B172C05;
        Tue,  7 Jun 2022 10:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25DC8B8234A;
        Tue,  7 Jun 2022 17:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AA8C34115;
        Tue,  7 Jun 2022 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624503;
        bh=pmnwGLGte3qP88JParZVFtU9tGvsrvRb24tKPoVDvlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo/Sv23vvCIztVzgnoqwCUCia5geB6h3emYonPeSgu3+T1v6ZGXjLU+p9JXJmZTQK
         9bgFikC7n0KYj9icxQ8zZ9gNb4Pww0nrnQtoRms8QdiqzAP24p8RdTyvc5Cnjc6ayN
         gAcGjME+BDAgCDqOFxXTS2j+0EMcJCMLOuCs9W84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/667] dma-direct: factor out a helper for DMA_ATTR_NO_KERNEL_MAPPING allocations
Date:   Tue,  7 Jun 2022 18:59:35 +0200
Message-Id: <20220607164944.071964936@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit d541ae55d538265861ef729a64d2d816d34ef1e2 ]

Split the code for DMA_ATTR_NO_KERNEL_MAPPING allocations into a separate
helper to make dma_direct_alloc a little more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 4c6c5e0635e3..ddaac01f2cba 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -149,6 +149,24 @@ static void *dma_direct_alloc_from_pool(struct device *dev, size_t size,
 	return ret;
 }
 
+static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp)
+{
+	struct page *page;
+
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO);
+	if (!page)
+		return NULL;
+
+	/* remove any dirty cache lines on the kernel alias */
+	if (!PageHighMem(page))
+		arch_dma_prep_coherent(page, size);
+
+	/* return the page pointer as the opaque cookie */
+	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
+	return page;
+}
+
 void *dma_direct_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
@@ -161,17 +179,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		gfp |= __GFP_NOWARN;
 
 	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
-	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev)) {
-		page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO);
-		if (!page)
-			return NULL;
-		/* remove any dirty cache lines on the kernel alias */
-		if (!PageHighMem(page))
-			arch_dma_prep_coherent(page, size);
-		*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
-		/* return the page pointer as the opaque cookie */
-		return page;
-	}
+	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
+		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
 	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-- 
2.35.1



