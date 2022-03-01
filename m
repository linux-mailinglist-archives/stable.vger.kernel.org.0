Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27624C95E2
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiCAUSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiCAURw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F23E89317;
        Tue,  1 Mar 2022 12:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24BC2B81D17;
        Tue,  1 Mar 2022 20:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C46C340EE;
        Tue,  1 Mar 2022 20:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165804;
        bh=s5v3aJ4Hatm+c5hU9aGN5lqd1epV2EFt5fKUeQ2bViM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8L55RLwv2lVHQjW50iDaUDGKNnGVjVupe88rjQv8xIDAmfu0iRIzm6En2DIUFgXw
         BLqybHT9CpxMwdgzRu9me9QYZtwsZ+U9Y4YjjGy3kuDk3DTHEJJO4xNbqyc74LDjGY
         3dZuCB1re1zfB4TpS8NdzHi8uwx8hrSV+5tSVdOztKqFFoy01Z3iFm4NZivUsk1d5a
         oeybn2pe/1Cr05FIRnCIkuDs0FHDBzxSvfTDJ+ZpyIV/TKGPxhNvdJpu9n4PyUBWga
         Yw+llytXCa/9LRd4EbHxTkIiXM9MCrH5ASeaxE950hYJTbRe5jMabo4d/xm89jWslp
         fXepy/OWHbFZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        m.szyprowski@samsung.com, linux-doc@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 02/23] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Tue,  1 Mar 2022 15:16:01 -0500
Message-Id: <20220301201629.18547-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/core-api/dma-attributes.rst | 8 ++++++++
 include/linux/dma-mapping.h               | 8 ++++++++
 kernel/dma/swiotlb.c                      | 3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1887d92e8e926..17706dc91ec9f 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,3 +130,11 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
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
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index dca2b1355bb13..6150d11a607e1 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,6 +61,14 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * This is a hint to the DMA-mapping subsystem that the device is expected
+ * to overwrite the entire mapped size, thus the caller does not require any
+ * of the previous buffer contents to be preserved. This allows
+ * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
+ */
+#define DMA_ATTR_OVERWRITE		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 87c40517e8227..aca0690550e2f 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -579,7 +579,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		mem->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(mem->start, index) + offset;
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
-- 
2.34.1

