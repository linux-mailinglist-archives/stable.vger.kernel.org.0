Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B134F3161
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356117AbiDEKW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiDEJae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28829E41C0;
        Tue,  5 Apr 2022 02:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 913D6615E3;
        Tue,  5 Apr 2022 09:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EC3C385A3;
        Tue,  5 Apr 2022 09:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150243;
        bh=2QZcy4ugKnChUB5AG5XphNhvFP3xwzzyQEERB//4VRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3/TLXsWHd350aB0f+ccGgNavYcEUgENiXGIMmju3NYbjD1+ezjbYByL8IwZG04Zt
         Hqv6qQBc7M33rnhc2hY3GpnuVRj+knaHwVnn9PIUz8M8cFfiPr8D2wb1ru6HEbssSv
         csZUFtuYFfJSpKwyrqUo6FLdRLmkoZ3JzdSxBR1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0967/1017] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Tue,  5 Apr 2022 09:31:20 +0200
Message-Id: <20220405070422.909709892@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.

Halil Pasic points out [1] that the full revert of that commit (revert
in bddac7c1e02b), and that a partial revert that only reverts the
problematic case, but still keeps some of the cleanups is probably
better.  ￼

And that partial revert [2] had already been verified by Oleksandr
Natalenko to also fix the issue, I had just missed that in the long
discussion.

So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
revert the part that caused problems.

Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/core-api/dma-attributes.rst |    8 --------
 include/linux/dma-mapping.h               |    8 --------
 kernel/dma/swiotlb.c                      |   12 ++++++++----
 3 files changed, 8 insertions(+), 20 deletions(-)

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
 


