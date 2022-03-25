Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC64E7609
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359767AbiCYPKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359812AbiCYPJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68643DAFE4;
        Fri, 25 Mar 2022 08:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0783B828FA;
        Fri, 25 Mar 2022 15:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE3FC340E9;
        Fri, 25 Mar 2022 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220853;
        bh=OQ8q4XiPlYgF94hRe6T81CNR0zdaJSSgEHaVdyK4gVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffCfbZbcSa1x9XT9IRXBZZIi9fbr3FmLR3aBX2iN7LcSJoMej0AZx6b7sagU3s0+K
         jQGz0oWSxVV0CkwGhLldeoCmZV/QKZQmrBLneCwFvcWBMvUidhrJTCyzNtgDpDwSwC
         mRiTS+79i3gTJ/aDQwlJNNhzhxTA+ET9bjlWG7yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 11/29] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
Date:   Fri, 25 Mar 2022 16:04:51 +0100
Message-Id: <20220325150418.912138406@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
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
 Documentation/DMA-attributes.txt |   10 ----------
 include/linux/dma-mapping.h      |    8 --------
 kernel/dma/swiotlb.c             |   25 ++++++++++++++++---------
 3 files changed, 16 insertions(+), 27 deletions(-)

--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,13 +156,3 @@ accesses to DMA buffers in both privileg
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_PRIVILEGED
--------------------
-
-Some advanced peripherals such as remote processors and GPUs perform
-accesses to DMA buffers in both privileged "supervisor" and unprivileged
-"user" modes.  This attribute is used to indicate to the DMA-mapping
-subsystem that the buffer is fully accessible at the elevated privilege
-level (and ideally inaccessible or at least read-only at the
-lesser-privileged levels).
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -71,14 +71,6 @@
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
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
  * reference a dma_addr_t directly because there may be translation between
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -571,10 +571,14 @@ found:
 	 */
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 
 	return tlb_addr;
 }
@@ -649,11 +653,14 @@ void swiotlb_tbl_sync_single(struct devi
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
-		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(orig_addr, tlb_addr,
-				       size, DMA_TO_DEVICE);
-		else
-			BUG_ON(dir != DMA_FROM_DEVICE);
+		/*
+		 * Unconditional bounce is necessary to avoid corruption on
+		 * sync_*_for_cpu or dma_ummap_* when the device didn't
+		 * overwrite the whole lengt of the bounce buffer.
+		 */
+		swiotlb_bounce(orig_addr, tlb_addr,
+			       size, DMA_TO_DEVICE);
+		BUG_ON(!valid_dma_direction(dir));
 		break;
 	default:
 		BUG();


