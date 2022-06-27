Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB54355C17C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbiF0Lxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbiF0Lwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F28DF71;
        Mon, 27 Jun 2022 04:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2857B80D32;
        Mon, 27 Jun 2022 11:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07931C3411D;
        Mon, 27 Jun 2022 11:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330402;
        bh=ClnVnHUDsNRaiXpt18gIWfNbgXLwUhIhOHGgV7pmpQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phJumXaJY/S3GfusdAQ8CGS4FtkhjACLm9kDlIIssDushiCiNnpCuN9MY1r3Is9xh
         +3Fk10nP5x1NnFSGREQou3IAQavfeRY7s5JmGxjyZ1YyHZWdyhpDXQ3rE6UC3xfP4g
         gzHO32b7w2e5Pr2hH8Se4Wgg446Rtd76/SBLG2KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.18 179/181] dma-direct: use the correct size for dma_set_encrypted()
Date:   Mon, 27 Jun 2022 13:22:32 +0200
Message-Id: <20220627111949.872507151@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 3be4562584bba603f33863a00c1c32eecf772ee6 upstream.

The third parameter of dma_set_encrypted() is a size in bytes rather than
the number of pages.

Fixes: 4d0564785bb0 ("dma-direct: factor out dma_set_{de,en}crypted helpers")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/direct.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -357,7 +357,7 @@ void dma_direct_free(struct device *dev,
 	} else {
 		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
 			arch_dma_clear_uncached(cpu_addr, size);
-		if (dma_set_encrypted(dev, cpu_addr, 1 << page_order))
+		if (dma_set_encrypted(dev, cpu_addr, size))
 			return;
 	}
 
@@ -392,7 +392,6 @@ void dma_direct_free_pages(struct device
 		struct page *page, dma_addr_t dma_addr,
 		enum dma_data_direction dir)
 {
-	unsigned int page_order = get_order(size);
 	void *vaddr = page_address(page);
 
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
@@ -400,7 +399,7 @@ void dma_direct_free_pages(struct device
 	    dma_free_from_pool(dev, vaddr, size))
 		return;
 
-	if (dma_set_encrypted(dev, vaddr, 1 << page_order))
+	if (dma_set_encrypted(dev, vaddr, size))
 		return;
 	__dma_direct_free_pages(dev, page, size);
 }


