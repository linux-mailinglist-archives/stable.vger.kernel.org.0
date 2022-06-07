Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F81540BFB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351993AbiFGSdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352528AbiFGSbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186FD17C691;
        Tue,  7 Jun 2022 10:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E0BB82349;
        Tue,  7 Jun 2022 17:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA53EC36B03;
        Tue,  7 Jun 2022 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624585;
        bh=wipdWey83GtLJHDSYSTNBJuKOdf6I7EDkLauVU7uwAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQEC01avAaad+0rdeX2RQyTH/uckDtWLmIEJdV+oY/05seIS7xaoQpZCftHAdMhHU
         ek3m/YbPprKvEmFhZwP0Kg9uUGMMz8HZHmwjgNas6KBKZ0Xk19Cd7JsUTnVIacB8RH
         Ue5Wccxo2xB9+q5ezA3TzjobpkINqb8mZNGEChvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/667] dma-direct: always leak memory that cant be re-encrypted
Date:   Tue,  7 Jun 2022 19:00:44 +0200
Message-Id: <20220607164946.115445191@linuxfoundation.org>
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

[ Upstream commit a90cf30437489343b8386ae87b4827b6d6c3ed50 ]

We must never let unencrypted memory go back into the general page pool.
So if we fail to set it back to encrypted when freeing DMA memory, leak
the memory instead and warn the user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 473964620773..8e24455dd236 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -84,9 +84,14 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 
 static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 {
+	int ret;
+
 	if (!force_dma_unencrypted(dev))
 		return 0;
-	return set_memory_encrypted((unsigned long)vaddr, 1 << get_order(size));
+	ret = set_memory_encrypted((unsigned long)vaddr, 1 << get_order(size));
+	if (ret)
+		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
+	return ret;
 }
 
 static void __dma_direct_free_pages(struct device *dev, struct page *page,
@@ -273,7 +278,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	return ret;
 
 out_encrypt_pages:
-	/* If memory cannot be re-encrypted, it must be leaked */
 	if (dma_set_encrypted(dev, page_address(page), size))
 		return NULL;
 out_free_pages:
@@ -319,7 +323,8 @@ void dma_direct_free(struct device *dev, size_t size,
 	} else {
 		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
 			arch_dma_clear_uncached(cpu_addr, size);
-		dma_set_encrypted(dev, cpu_addr, 1 << page_order);
+		if (dma_set_encrypted(dev, cpu_addr, 1 << page_order))
+			return;
 	}
 
 	__dma_direct_free_pages(dev, dma_direct_to_page(dev, dma_addr), size);
@@ -363,7 +368,8 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, vaddr, size))
 		return;
 
-	dma_set_encrypted(dev, vaddr, 1 << page_order);
+	if (dma_set_encrypted(dev, vaddr, 1 << page_order))
+		return;
 	__dma_direct_free_pages(dev, page, size);
 }
 
-- 
2.35.1



