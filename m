Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB252F14B
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352029AbiETRKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350298AbiETRKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:10:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32E7F179093;
        Fri, 20 May 2022 10:10:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B42081477;
        Fri, 20 May 2022 10:10:30 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B5D0B3F718;
        Fri, 20 May 2022 10:10:29 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     hch@lst.de
Cc:     m.szyprowski@samsung.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        rientjes@google.com, stable@vger.kernel.org
Subject: [PATCH] dma-direct: Don't over-decrypt memory
Date:   Fri, 20 May 2022 18:10:13 +0100
Message-Id: <796ddc256b8a3054cb0b2f43363613463fcf0d61.1653066613.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.35.3.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original x86 sev_alloc() only called set_memory_decrypted() on
memory returned by alloc_pages_node(), so the page order calculation
fell out of that logic. However, the common dma-direct code has several
potential allocators, not all of which are guaranteed to round up the
underlying allocation to a power-of-two size, so carrying over that
calculation for the encryption/decryption size was a mistake. Fix it by
rounding to a *number* of pages, rather than an order.

Until recently there was an even worse interaction with DMA_DIRECT_REMAP
where we could have ended up decrypting part of the next adjacent
vmalloc area, only averted by no architecture actually supporting both
configs at once. Don't ask how I found that one out...

CC: stable@vger.kernel.org
Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 kernel/dma/direct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 9743c6ccce1a..09d78aa40466 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -79,7 +79,7 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 {
 	if (!force_dma_unencrypted(dev))
 		return 0;
-	return set_memory_decrypted((unsigned long)vaddr, 1 << get_order(size));
+	return set_memory_decrypted((unsigned long)vaddr, PFN_UP(size));
 }
 
 static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
@@ -88,7 +88,7 @@ static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 
 	if (!force_dma_unencrypted(dev))
 		return 0;
-	ret = set_memory_encrypted((unsigned long)vaddr, 1 << get_order(size));
+	ret = set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
 	return ret;
-- 
2.35.3.dirty

