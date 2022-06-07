Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB95540BE7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiFGSdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352513AbiFGSbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAB5146414;
        Tue,  7 Jun 2022 10:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0BF2B8237D;
        Tue,  7 Jun 2022 17:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C7C36B05;
        Tue,  7 Jun 2022 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624582;
        bh=l0FwX6vnSfPHMFtFGMF5ei/ho1GrpvkhyQLI9eGiIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXDH4p7160mnUKQS3DYHLhqCgK5la9KnRvtHw1kU5N0LV33Dc+zdcE//WuyyKHhX2
         x4gu8ZgDmoJq4grwouZHR6+io6h5dybejsO3vQVMH5YI0OYXf1yuSyj9cjZh/wGWJc
         Cz3jnvntKSCjA/MFIJbheNx7bG3IR9gMRziQHkZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 378/667] dma-direct: dont call dma_set_decrypted for remapped allocations
Date:   Tue,  7 Jun 2022 19:00:43 +0200
Message-Id: <20220607164946.086122133@linuxfoundation.org>
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

[ Upstream commit 5570449b6876f215d49ac4db9ccce6ff7aa1e20a ]

Remapped allocations handle the encrypted bit through the pgprot passed
to vmap, so there is no call dma_set_decrypted.  Note that this case is
currently entirely theoretical as no valid kernel configuration supports
remapped allocations and memory encryption currently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index b9513fd68239..473964620773 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -241,8 +241,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 				__builtin_return_address(0));
 		if (!ret)
 			goto out_free_pages;
-		if (dma_set_decrypted(dev, ret, size))
-			goto out_free_pages;
 		memset(ret, 0, size);
 		goto done;
 	}
@@ -316,12 +314,13 @@ void dma_direct_free(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
 		return;
 
-	dma_set_encrypted(dev, cpu_addr, 1 << page_order);
-
-	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr))
+	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
-	else if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
-		arch_dma_clear_uncached(cpu_addr, size);
+	} else {
+		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
+			arch_dma_clear_uncached(cpu_addr, size);
+		dma_set_encrypted(dev, cpu_addr, 1 << page_order);
+	}
 
 	__dma_direct_free_pages(dev, dma_direct_to_page(dev, dma_addr), size);
 }
-- 
2.35.1



