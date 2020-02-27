Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB8171D28
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389866AbgB0OSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgB0OSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABB512468F;
        Thu, 27 Feb 2020 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813101;
        bh=FMY56qzvCJharns2+c9TUhuElzCBrCqVJxbMDnAG4Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcISWmWBEshhxiyl6El/h+gyWtyUvdOzYEYSxU+WiH5MjWxnPVOViQ6BdxqfrCSEq
         6olGBN/TxG+mYbX0OS7J/xuE3degwEG7aakpkK217RE60I3DemMH9Sn3jJKDFJAZL7
         t5NgQJ+Efgsyw9wweme/msoBVeLo+5EHWDdibTzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.5 136/150] dma-direct: relax addressability checks in dma_direct_supported
Date:   Thu, 27 Feb 2020 14:37:53 +0100
Message-Id: <20200227132252.430410586@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 91ef26f914171cf753330f13724fd9142b5b1640 upstream.

dma_direct_supported tries to find the minimum addressable bitmask
based on the end pfn and optional magic that architectures can use
to communicate the size of the magic ZONE_DMA that can be used
for bounce buffering.  But between the DMA offsets that can change
per device (or sometimes even region), the fact the ZONE_DMA isn't
even guaranteed to be the lowest addresses and failure of having
proper interfaces to the MM code this fails at least for one
arm subarchitecture.

As all the legacy DMA implementations have supported 32-bit DMA
masks, and 32-bit masks are guranteed to always work by the API
contract (using bounce buffers if needed), we can short cut the
complicated check and always return true without breaking existing
assumptions.  Hopefully we can properly clean up the interaction
with the arch defined zones and the bootmem allocator eventually.

Fixes: ad3c7b18c5b3 ("arm: use swiotlb for bounce buffering on LPAE configs")
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/dma/direct.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -472,28 +472,26 @@ int dma_direct_mmap(struct device *dev,
 }
 #endif /* CONFIG_MMU */
 
-/*
- * Because 32-bit DMA masks are so common we expect every architecture to be
- * able to satisfy them - either by not supporting more physical memory, or by
- * providing a ZONE_DMA32.  If neither is the case, the architecture needs to
- * use an IOMMU instead of the direct mapping.
- */
 int dma_direct_supported(struct device *dev, u64 mask)
 {
-	u64 min_mask;
+	u64 min_mask = (max_pfn - 1) << PAGE_SHIFT;
 
-	if (IS_ENABLED(CONFIG_ZONE_DMA))
-		min_mask = DMA_BIT_MASK(zone_dma_bits);
-	else
-		min_mask = DMA_BIT_MASK(32);
-
-	min_mask = min_t(u64, min_mask, (max_pfn - 1) << PAGE_SHIFT);
+	/*
+	 * Because 32-bit DMA masks are so common we expect every architecture
+	 * to be able to satisfy them - either by not supporting more physical
+	 * memory, or by providing a ZONE_DMA32.  If neither is the case, the
+	 * architecture needs to use an IOMMU instead of the direct mapping.
+	 */
+	if (mask >= DMA_BIT_MASK(32))
+		return 1;
 
 	/*
 	 * This check needs to be against the actual bit mask value, so
 	 * use __phys_to_dma() here so that the SME encryption mask isn't
 	 * part of the check.
 	 */
+	if (IS_ENABLED(CONFIG_ZONE_DMA))
+		min_mask = min_t(u64, min_mask, DMA_BIT_MASK(zone_dma_bits));
 	return mask >= __phys_to_dma(dev, min_mask);
 }
 


