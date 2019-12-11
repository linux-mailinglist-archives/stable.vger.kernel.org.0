Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD111A92D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfLKKnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:43:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbfLKKnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 05:43:00 -0500
Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 681BD206A5;
        Wed, 11 Dec 2019 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576060979;
        bh=NwJI8msRaERbqP+3FROGHItAhebPYHeQra0pErfd+Qg=;
        h=From:To:Cc:Subject:Date:From;
        b=YJ3TyVj4V42lqastwnlH3q7SPKVkxsHtkR/zNjNbXIgUeX/zx4hjAkPvV0xZiRTqj
         TKFGpfbZJT+J+2a5UnSsMLXsqKbj2JqewlFqPK8Pv8zCDZ+1JTJCsgDrEYUYRmIHCy
         1mU3k8vai7etAb4HZK3bwXiyuEQ9/9/Km6hnYzIM=
Received: by wens.tw (Postfix, from userid 1000)
        id C74DB5FCD1; Wed, 11 Dec 2019 18:42:56 +0800 (CST)
From:   Chen-Yu Tsai <wens@kernel.org>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Chen-Yu Tsai <wens@csie.org>, Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()
Date:   Wed, 11 Dec 2019 18:41:52 +0800
Message-Id: <20191211104152.26496-1-wens@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

max_pfn, as set in arch/arm/mm/init.c:

    static void __init find_limits(unsigned long *min,
				   unsigned long *max_low,
				   unsigned long *max_high)
    {
	    *max_low = PFN_DOWN(memblock_get_current_limit());
	    *min = PFN_UP(memblock_start_of_DRAM());
	    *max_high = PFN_DOWN(memblock_end_of_DRAM());
    }

with memblock_end_of_DRAM() pointing to the next byte after DRAM. As
such, max_pfn points to the PFN after the end of DRAM.

Thus when using max_pfn to check DMA masks, we should subtract one
when checking DMA ranges against it.

Commit 8bf1268f48ad ("ARM: dma-api: fix off-by-one error in
__dma_supported()") fixed the same issue, but missed this spot.

This issue was found while working on the sun4i-csi v4l2 driver on the
Allwinner R40 SoC. On Allwinner SoCs, DRAM is offset at 0x40000000,
and we are starting to use of_dma_configure() with the "dma-ranges"
property in the device tree to have the DMA API handle the offset.

In this particular instance, dma-ranges was set to the same range as
the actual available (2 GiB) DRAM. The following error appeared when
the driver attempted to allocate a buffer:

    sun4i-csi 1c09000.csi: Coherent DMA mask 0x7fffffff (pfn 0x40000-0xc0000)
    covers a smaller range of system memory than the DMA zone pfn 0x0-0xc0001
    sun4i-csi 1c09000.csi: dma_alloc_coherent of size 307200 failed

Fixing the off-by-one error makes things work.

Fixes: 11a5aa32562e ("ARM: dma-mapping: check DMA mask against available memory")
Fixes: 9f28cde0bc64 ("ARM: another fix for the DMA mapping checks")
Fixes: ab746573c405 ("ARM: dma-mapping: allow larger DMA mask than supported")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/mm/dma-mapping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e822af0d9219..f4daafdbac56 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -227,12 +227,12 @@ static int __dma_supported(struct device *dev, u64 mask, bool warn)
 	 * Translate the device's DMA mask to a PFN limit.  This
 	 * PFN number includes the page which we can DMA to.
 	 */
-	if (dma_to_pfn(dev, mask) < max_dma_pfn) {
+	if (dma_to_pfn(dev, mask) < max_dma_pfn - 1) {
 		if (warn)
 			dev_warn(dev, "Coherent DMA mask %#llx (pfn %#lx-%#lx) covers a smaller range of system memory than the DMA zone pfn 0x0-%#lx\n",
 				 mask,
 				 dma_to_pfn(dev, 0), dma_to_pfn(dev, mask) + 1,
-				 max_dma_pfn + 1);
+				 max_dma_pfn);
 		return 0;
 	}
 
-- 
2.24.0

