Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F011513FF
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 02:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgBDBht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 20:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 980C321775;
        Tue,  4 Feb 2020 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580780268;
        bh=1JJBUW9acr4K537A51HZRbIevnTRMWqCsi85NEFmwPk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AqptJuqvT7QsZtrPu7KpuK4O9POzerIW9NfLgzlXGGcb+A61W70gC+DeAdxH79i+g
         W2LTbk+hajUOTiQ2486on5ZfVFskvtAgBnFnA0cAwxR+sVj/Cb3k6jRd2gW+nnparr
         +LUDQc2xZ5/m7LKMJP2Cn2xLqWGMaQxvVn7BNkfg=
Date:   Mon, 03 Feb 2020 17:37:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        robin.murphy@arm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wens@csie.org
Subject:  [patch 67/67] ARM: dma-api: fix max_pfn off-by-one error
 in __dma_supported()
Message-ID: <20200204013748.ezp0xXg5F%akpm@linux-foundation.org>
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>
Subject: ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()

max_pfn, as set in arch/arm/mm/init.c:

    static void __init find_limits(unsigned long *min,
				   unsigned long *max_low,
				   unsigned long *max_high)
    {
	    *max_low = PFN_DOWN(memblock_get_current_limit());
	    *min = PFN_UP(memblock_start_of_DRAM());
	    *max_high = PFN_DOWN(memblock_end_of_DRAM());
    }

with memblock_end_of_DRAM() pointing to the next byte after DRAM.  As
such, max_pfn points to the PFN after the end of DRAM.

Thus when using max_pfn to check DMA masks, we should subtract one when
checking DMA ranges against it.

Commit 8bf1268f48ad ("ARM: dma-api: fix off-by-one error in
__dma_supported()") fixed the same issue, but missed this spot.

This issue was found while working on the sun4i-csi v4l2 driver on the
Allwinner R40 SoC.  On Allwinner SoCs, DRAM is offset at 0x40000000, and
we are starting to use of_dma_configure() with the "dma-ranges" property
in the device tree to have the DMA API handle the offset.

In this particular instance, dma-ranges was set to the same range as the
actual available (2 GiB) DRAM.  The following error appeared when the
driver attempted to allocate a buffer:

    sun4i-csi 1c09000.csi: Coherent DMA mask 0x7fffffff (pfn 0x40000-0xc0000)
    covers a smaller range of system memory than the DMA zone pfn 0x0-0xc0001
    sun4i-csi 1c09000.csi: dma_alloc_coherent of size 307200 failed

Fixing the off-by-one error makes things work.

Link: http://lkml.kernel.org/r/20191224030239.5656-1-wens@kernel.org
Fixes: 11a5aa32562e ("ARM: dma-mapping: check DMA mask against available memory")
Fixes: 9f28cde0bc64 ("ARM: another fix for the DMA mapping checks")
Fixes: ab746573c405 ("ARM: dma-mapping: allow larger DMA mask than supported")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/dma-mapping.c~arm-dma-api-fix-max_pfn-off-by-one-error-in-__dma_supported
+++ a/arch/arm/mm/dma-mapping.c
@@ -221,7 +221,7 @@ EXPORT_SYMBOL(arm_coherent_dma_ops);
 
 static int __dma_supported(struct device *dev, u64 mask, bool warn)
 {
-	unsigned long max_dma_pfn = min(max_pfn, arm_dma_pfn_limit);
+	unsigned long max_dma_pfn = min(max_pfn - 1, arm_dma_pfn_limit);
 
 	/*
 	 * Translate the device's DMA mask to a PFN limit.  This
_
