Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599364D8423
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbiCNMXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbiCNMVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C5064E8;
        Mon, 14 Mar 2022 05:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF21160B04;
        Mon, 14 Mar 2022 12:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE0C340EC;
        Mon, 14 Mar 2022 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260265;
        bh=Wm30RoSPxeFyjUcBzydrxR0EyEVay69I6mOgakrCl6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDiY0VkOyhaJwNboFq6Yj4KSXgUwcw2cRAsAJqHzn/kj+zCQ5EQV8iOofPQh8m0rl
         cBbe1tc64QrsSaACXXwaPJvBNhRhI+eHdY4NBpfB331MlFPr8QV+3D3gXSsdw6malH
         HBpx9uNSSGo9vFLHfFNJp2SdeMrHRzVMtuWe3Xxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 100/121] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
Date:   Mon, 14 Mar 2022 12:54:43 +0100
Message-Id: <20220314112746.906154739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit aa6f8dcbab473f3a3c7454b74caa46d36cdc5d13 upstream.

Unfortunately, we ended up merging an old version of the patch "fix info
leak with DMA_FROM_DEVICE" instead of merging the latest one. Christoph
(the swiotlb maintainer), he asked me to create an incremental fix
(after I have pointed this out the mix up, and asked him for guidance).
So here we go.

The main differences between what we got and what was agreed are:
* swiotlb_sync_single_for_device is also required to do an extra bounce
* We decided not to introduce DMA_ATTR_OVERWRITE until we have exploiters
* The implantation of DMA_ATTR_OVERWRITE is flawed: DMA_ATTR_OVERWRITE
  must take precedence over DMA_ATTR_SKIP_CPU_SYNC

Thus this patch removes DMA_ATTR_OVERWRITE, and makes
swiotlb_sync_single_for_device() bounce unconditionally (that is, also
when dir == DMA_TO_DEVICE) in order do avoid synchronising back stale
data from the swiotlb buffer.

Let me note, that if the size used with dma_sync_* API is less than the
size used with dma_[un]map_*, under certain circumstances we may still
end up with swiotlb not being transparent. In that sense, this is no
perfect fix either.

To get this bullet proof, we would have to bounce the entire
mapping/bounce buffer. For that we would have to figure out the starting
address, and the size of the mapping in
swiotlb_sync_single_for_device(). While this does seem possible, there
seems to be no firm consensus on how things are supposed to work.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/core-api/dma-attributes.rst |    8 --------
 include/linux/dma-mapping.h               |    8 --------
 kernel/dma/swiotlb.c                      |   23 +++++++++++++++--------
 3 files changed, 15 insertions(+), 24 deletions(-)

--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,11 +130,3 @@ accesses to DMA buffers in both privileg
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_OVERWRITE
-------------------
-
-This is a hint to the DMA-mapping subsystem that the device is expected to
-overwrite the entire mapped size, thus the caller does not require any of the
-previous buffer contents to be preserved. This allows bounce-buffering
-implementations to optimise DMA_FROM_DEVICE transfers.
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -62,14 +62,6 @@
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
 /*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
-/*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
  * given device and there may be a translation between the CPU physical address
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -581,10 +581,14 @@ phys_addr_t swiotlb_tbl_map_single(struc
 	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		mem->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(mem->start, index) + offset;
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
@@ -651,10 +655,13 @@ void swiotlb_tbl_unmap_single(struct dev
 void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
-	else
-		BUG_ON(dir != DMA_FROM_DEVICE);
+	/*
+	 * Unconditional bounce is necessary to avoid corruption on
+	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
+	 * the whole lengt of the bounce buffer.
+	 */
+	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
+	BUG_ON(!valid_dma_direction(dir));
 }
 
 void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,


