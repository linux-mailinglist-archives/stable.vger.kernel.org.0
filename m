Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6F157A21
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgBJNUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgBJMhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3638620661;
        Mon, 10 Feb 2020 12:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338258;
        bh=8ZdGH4cViKER73J86CwWEW5+ohT/R9M7TtH64Uwyo78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UOLpxVHYYq4jiEjtsZsQPkM6AnhdRnoXxJPnW72kPavIJyxIL57NmPlCxlrMS/5o
         M8H4LUtHjxFfZfeI1UMwQVF4ksdModgcmexy5Gxkywu6tNR721kghYrQSr8QTTfqVE
         RdM8U4/x/BPtA7+ae8vP7+6TV6aZSExjEONy12hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 126/309] ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()
Date:   Mon, 10 Feb 2020 04:31:22 -0800
Message-Id: <20200210122418.528957067@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit f3cc4e1d44a813a0685f2e558b78ace3db559722 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -221,7 +221,7 @@ EXPORT_SYMBOL(arm_coherent_dma_ops);
 
 static int __dma_supported(struct device *dev, u64 mask, bool warn)
 {
-	unsigned long max_dma_pfn = min(max_pfn, arm_dma_pfn_limit);
+	unsigned long max_dma_pfn = min(max_pfn - 1, arm_dma_pfn_limit);
 
 	/*
 	 * Translate the device's DMA mask to a PFN limit.  This


