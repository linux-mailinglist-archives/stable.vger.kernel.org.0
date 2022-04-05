Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2A34F2C00
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356323AbiDEKXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbiDEJbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F308122B17;
        Tue,  5 Apr 2022 02:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 768EAB81BBF;
        Tue,  5 Apr 2022 09:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC0BC385A4;
        Tue,  5 Apr 2022 09:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150301;
        bh=8gNnGNqZDkDM/iK6omCmJF+fapZmMzeKQZA5UQ7FqeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7s5gmB8e+Iver5aGKC/PjnaMAiVywtBxnm3HUkHT2hFe/F9Sz3MfgzVbMNQY8xlM
         drv4Ii8ZgTAHMZ3g9JjkS+sK+Ai0gwX8HjZioVUzThU3kCarZ/CGMi/vtp13GCbTP/
         OkRZ5Rp9hZAKZfV06pHwJ2n1bmyjdJncL3Yt8ly0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olha Cherevyk <olha.cherevyk@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Kalle Valo <kvalo@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Maxime Bizon <mbizon@freebox.fr>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 5.15 001/913] Revert "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Tue,  5 Apr 2022 09:17:43 +0200
Message-Id: <20220405070339.852513253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit bddac7c1e02ba47f0570e494c9289acea3062cc1 upstream.

This reverts commit aa6f8dcbab473f3a3c7454b74caa46d36cdc5d13.

It turns out this breaks at least the ath9k wireless driver, and
possibly others.

What the ath9k driver does on packet receive is to set up the DMA
transfer with:

  int ath_rx_init(..)
  ..
                bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
                                                 common->rx_bufsize,
                                                 DMA_FROM_DEVICE);

and then the receive logic (through ath_rx_tasklet()) will fetch
incoming packets

  static bool ath_edma_get_buffers(..)
  ..
        dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
                                common->rx_bufsize, DMA_FROM_DEVICE);

        ret = ath9k_hw_process_rxdesc_edma(ah, rs, skb->data);
        if (ret == -EINPROGRESS) {
                /*let device gain the buffer again*/
                dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
                                common->rx_bufsize, DMA_FROM_DEVICE);
                return false;
        }

and it's worth noting how that first DMA sync:

    dma_sync_single_for_cpu(..DMA_FROM_DEVICE);

is there to make sure the CPU can read the DMA buffer (possibly by
copying it from the bounce buffer area, or by doing some cache flush).
The iommu correctly turns that into a "copy from bounce bufer" so that
the driver can look at the state of the packets.

In the meantime, the device may continue to write to the DMA buffer, but
we at least have a snapshot of the state due to that first DMA sync.

But that _second_ DMA sync:

    dma_sync_single_for_device(..DMA_FROM_DEVICE);

is telling the DMA mapping that the CPU wasn't interested in the area
because the packet wasn't there.  In the case of a DMA bounce buffer,
that is a no-op.

Note how it's not a sync for the CPU (the "for_device()" part), and it's
not a sync for data written by the CPU (the "DMA_FROM_DEVICE" part).

Or rather, it _should_ be a no-op.  That's what commit aa6f8dcbab47
broke: it made the code bounce the buffer unconditionally, and changed
the DMA_FROM_DEVICE to just unconditionally and illogically be
DMA_TO_DEVICE.

[ Side note: purely within the confines of the swiotlb driver it wasn't
  entirely illogical: The reason it did that odd DMA_FROM_DEVICE ->
  DMA_TO_DEVICE conversion thing is because inside the swiotlb driver,
  it uses just a swiotlb_bounce() helper that doesn't care about the
  whole distinction of who the sync is for - only which direction to
  bounce.

  So it took the "sync for device" to mean that the CPU must have been
  the one writing, and thought it meant DMA_TO_DEVICE. ]

Also note how the commentary in that commit was wrong, probably due to
that whole confusion, claiming that the commit makes the swiotlb code

                                  "bounce unconditionally (that is, also
    when dir == DMA_TO_DEVICE) in order do avoid synchronising back stale
    data from the swiotlb buffer"

which is nonsensical for two reasons:

 - that "also when dir == DMA_TO_DEVICE" is nonsensical, as that was
   exactly when it always did - and should do - the bounce.

 - since this is a sync for the device (not for the CPU), we're clearly
   fundamentally not coping back stale data from the bounce buffers at
   all, because we'd be copying *to* the bounce buffers.

So that commit was just very confused.  It confused the direction of the
synchronization (to the device, not the cpu) with the direction of the
DMA (from the device).

Reported-and-bisected-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Toke Høiland-Jørgensen <toke@toke.dk>
Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/core-api/dma-attributes.rst |    8 ++++++++
 include/linux/dma-mapping.h               |    8 ++++++++
 kernel/dma/swiotlb.c                      |   23 ++++++++---------------
 3 files changed, 24 insertions(+), 15 deletions(-)

--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,3 +130,11 @@ accesses to DMA buffers in both privileg
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_OVERWRITE
+------------------
+
+This is a hint to the DMA-mapping subsystem that the device is expected to
+overwrite the entire mapped size, thus the caller does not require any of the
+previous buffer contents to be preserved. This allows bounce-buffering
+implementations to optimise DMA_FROM_DEVICE transfers.
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -62,6 +62,14 @@
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
 /*
+ * This is a hint to the DMA-mapping subsystem that the device is expected
+ * to overwrite the entire mapped size, thus the caller does not require any
+ * of the previous buffer contents to be preserved. This allows
+ * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
+ */
+#define DMA_ATTR_OVERWRITE		(1UL << 10)
+
+/*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
  * given device and there may be a translation between the CPU physical address
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -578,14 +578,10 @@ phys_addr_t swiotlb_tbl_map_single(struc
 	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		mem->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(mem->start, index) + offset;
-	/*
-	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
-	 * to the tlb buffer, if we knew for sure the device will
-	 * overwirte the entire current content. But we don't. Thus
-	 * unconditional bounce may prevent leaking swiotlb content (i.e.
-	 * kernel memory) to user-space.
-	 */
-	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
+		swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
@@ -652,13 +648,10 @@ void swiotlb_tbl_unmap_single(struct dev
 void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	/*
-	 * Unconditional bounce is necessary to avoid corruption on
-	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
-	 * the whole lengt of the bounce buffer.
-	 */
-	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
-	BUG_ON(!valid_dma_direction(dir));
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
+		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
+	else
+		BUG_ON(dir != DMA_FROM_DEVICE);
 }
 
 void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,


