Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D118601E47
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiJRAIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiJRAII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC42870B0;
        Mon, 17 Oct 2022 17:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B60B9B81B62;
        Tue, 18 Oct 2022 00:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6918C43470;
        Tue, 18 Oct 2022 00:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051676;
        bh=IkUKTLzmiWeykYfzYr94/tt4piAiaTK/4HefW8JHtoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnAFyau+EDmYE5dWlJVsa+z8s8/HIyVBjt2RbdYp4L4IyIm5a5jL6/FwUrxARR/vP
         xRBJhuoocoptlNNBH+G7c5jHGD5XWxKZfimnDo6xYX95c8nEVoPtiCseKjUjT2ElZ3
         Zv8sz23A1nccnr5GDATjnVkdXVmur6Mu1c6Fhisc/6h0W8xWxrb8SsRKIt4J9o3Q8E
         l4uBl4DQkWGXl6b9DzSEWdLIrxGT+psBWZ3bUU1lM5LvOK0dhkDpAcX5fP5VhodEyf
         IFoPoMK/L+XOEBTIJSPMc87tPbl4odYf4p9kRYfPvo6+QIBfTanBzx7N9O2dTdh22o
         mtneSqardWLYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, hch@infradead.org,
        m.szyprowski@samsung.com, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 12/32] swiotlb: don't panic!
Date:   Mon, 17 Oct 2022 20:07:09 -0400
Message-Id: <20221018000729.2730519-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 639205ed206f98fcfa826933946f0844615784ea ]

The panics in swiotlb are relics of a bygone era, some of them
inadvertently inherited from a memblock refactor, and all of them
unnecessary since they are in places that may also fail gracefully
anyway.

Convert the panics in swiotlb_init_remap() into non-fatal warnings
more consistent with the other bail-out paths there and in
swiotlb_init_late() (but don't bother trying to roll anything back,
since if anything does actually fail that early, the aim is merely to
keep going as far as possible to get more diagnostic information out
of the inevitably-dying kernel). It's not for SWIOTLB to decide that the
system is terminally compromised just because there *might* turn out to
be one or more 32-bit devices that might want to make streaming DMA
mappings, especially since we already handle the no-buffer case later
if it turns out someone did want it.

Similarly though, downgrade that panic in swiotlb_tbl_map_single(),
since even if we do get to that point it's an overly extreme reaction.
It makes little difference to the DMA API caller whether a mapping fails
because the buffer is full or because there is no buffer, and once again
it's not for SWIOTLB to presume that any particular DMA mapping is so
fundamental to the operation of the system that it must be terminal if
it could never succeed. Even if the caller handles failure by futilely
retrying forever, a single stuck thread is considerably less impactful
to the user than a needless panic.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0ef6b12f961d..11579a3be2b5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -346,22 +346,27 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		memblock_free(tlb, PAGE_ALIGN(bytes));
 
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs < IO_TLB_MIN_SLABS)
-			panic("%s: Failed to remap %zu bytes\n",
-			      __func__, bytes);
-		goto retry;
+		if (nslabs >= IO_TLB_MIN_SLABS)
+			goto retry;
+
+		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
+		return;
 	}
 
 	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
 	mem->slots = memblock_alloc(alloc_size, PAGE_SIZE);
-	if (!mem->slots)
-		panic("%s: Failed to allocate %zu bytes align=0x%lx\n",
-		      __func__, alloc_size, PAGE_SIZE);
+	if (!mem->slots) {
+		pr_warn("%s: Failed to allocate %zu bytes align=0x%lx\n",
+			__func__, alloc_size, PAGE_SIZE);
+		return;
+	}
 
 	mem->areas = memblock_alloc(array_size(sizeof(struct io_tlb_area),
 		default_nareas), SMP_CACHE_BYTES);
-	if (!mem->areas)
-		panic("%s: Failed to allocate mem->areas.\n", __func__);
+	if (!mem->areas) {
+		pr_warn("%s: Failed to allocate mem->areas.\n", __func__);
+		return;
+	}
 
 	swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, flags, false,
 				default_nareas);
@@ -731,8 +736,11 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	int index;
 	phys_addr_t tlb_addr;
 
-	if (!mem || !mem->nslabs)
-		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
+	if (!mem || !mem->nslabs) {
+		dev_warn_ratelimited(dev,
+			"Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
+		return (phys_addr_t)DMA_MAPPING_ERROR;
+	}
 
 	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
 		pr_warn_once("Memory encryption is active and system is using DMA bounce buffers\n");
-- 
2.35.1

