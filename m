Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D780D129D03
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 04:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLXDCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 22:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfLXDCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 22:02:51 -0500
Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B24206B7;
        Tue, 24 Dec 2019 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577156571;
        bh=4dZHptUocDTk3SMP2Sv3sZ8BavU3pNtaSpQenIapHsM=;
        h=From:To:Cc:Subject:Date:From;
        b=KIw6j9qg7Ahaw+bH3ikbPbfqAcxtMxiS2GED2BhbCiix+4T5HZu6btbxvQT/mZA7K
         aJSd0SXB1C804B6pCGWWIrPoCNlYbzOZneiNYO5b9p29TD9RRVUkMDmA6MKRQTcer6
         AtEV6BvJQUzoyo3P5v/Fr7Ru0qThqqQ4CL8ZdQQg=
Received: by wens.tw (Postfix, from userid 1000)
        id E77AF5FC87; Tue, 24 Dec 2019 11:02:47 +0800 (CST)
From:   Chen-Yu Tsai <wens@kernel.org>
To:     Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH RESEND v2] ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()
Date:   Tue, 24 Dec 2019 11:02:39 +0800
Message-Id: <20191224030239.5656-1-wens@kernel.org>
X-Mailer: git-send-email 2.24.1
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

It's been close to two weeks since I sent this. I wasn't sure if I
reached the right maintainers, so I'm resending this to more people.

Changes since v1:

  - correct max_pfn offset in the correct place.

---
 arch/arm/mm/dma-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e822af0d9219..9414d72f664b 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -221,7 +221,7 @@ EXPORT_SYMBOL(arm_coherent_dma_ops);
 
 static int __dma_supported(struct device *dev, u64 mask, bool warn)
 {
-	unsigned long max_dma_pfn = min(max_pfn, arm_dma_pfn_limit);
+	unsigned long max_dma_pfn = min(max_pfn - 1, arm_dma_pfn_limit);
 
 	/*
 	 * Translate the device's DMA mask to a PFN limit.  This
-- 
2.24.1

