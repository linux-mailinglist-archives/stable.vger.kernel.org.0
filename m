Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E5A501344
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiDNNmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344616AbiDNNcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3505422298;
        Thu, 14 Apr 2022 06:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9389B82968;
        Thu, 14 Apr 2022 13:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5918CC385A1;
        Thu, 14 Apr 2022 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943026;
        bh=8VTM/8LtiqtxsN3ARTPPRHzFGHe/UPFXjEUsjh4d05Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0EBgb4VunPrGrXeQO3mwC+GZCfI7LO9KVUT6zxmP9+JtOaIGdgeMb+zUKPn7c6Xw
         Tr21v+2w5zZSbJLUAm4j3eUL8KA1d7XyU5Dq9uEbup4R+lWbfHECQWKdFzToUHEaWL
         9kKKkrRdUCX/hmhWOMBq3s/wbJd7xGc6Z3rF2uqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 001/475] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Thu, 14 Apr 2022 15:06:26 +0200
Message-Id: <20220414110855.188476928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Halil Pasic <pasic@linux.ibm.com>

commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e upstream.

The problem I'm addressing was discovered by the LTP test covering
cve-2018-1000204.

A short description of what happens follows:
1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
   interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
   and a corresponding dxferp. The peculiar thing about this is that TUR
   is not reading from the device.
2) In sg_start_req() the invocation of blk_rq_map_user() effectively
   bounces the user-space buffer. As if the device was to transfer into
   it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
   sg_build_indirect()") we make sure this first bounce buffer is
   allocated with GFP_ZERO.
3) For the rest of the story we keep ignoring that we have a TUR, so the
   device won't touch the buffer we prepare as if the we had a
   DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
   and the  buffer allocated by SG is mapped by the function
   virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
   scatter-gather and not scsi generics). This mapping involves bouncing
   via the swiotlb (we need swiotlb to do virtio in protected guest like
   s390 Secure Execution, or AMD SEV).
4) When the SCSI TUR is done, we first copy back the content of the second
   (that is swiotlb) bounce buffer (which most likely contains some
   previous IO data), to the first bounce buffer, which contains all
   zeros.  Then we copy back the content of the first bounce buffer to
   the user-space buffer.
5) The test case detects that the buffer, which it zero-initialized,
  ain't all zeros and fails.

One can argue that this is an swiotlb problem, because without swiotlb
we leak all zeros, and the swiotlb should be transparent in a sense that
it does not affect the outcome (if all other participants are well
behaved).

Copying the content of the original buffer into the swiotlb buffer is
the only way I can think of to make swiotlb transparent in such
scenarios. So let's do just that if in doubt, but allow the driver
to tell us that the whole mapped buffer is going to be overwritten,
in which case we can preserve the old behavior and avoid the performance
impact of the extra bounce.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/DMA-attributes.txt |   10 ++++++++++
 include/linux/dma-mapping.h      |    8 ++++++++
 kernel/dma/swiotlb.c             |    3 ++-
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,3 +156,13 @@ accesses to DMA buffers in both privileg
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_PRIVILEGED
+-------------------
+
+Some advanced peripherals such as remote processors and GPUs perform
+accesses to DMA buffers in both privileged "supervisor" and unprivileged
+"user" modes.  This attribute is used to indicate to the DMA-mapping
+subsystem that the buffer is fully accessible at the elevated privilege
+level (and ideally inaccessible or at least read-only at the
+lesser-privileged levels).
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -71,6 +71,14 @@
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
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
  * reference a dma_addr_t directly because there may be translation between
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -572,7 +572,8 @@ found:
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 
 	return tlb_addr;


