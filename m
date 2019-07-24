Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACEE73E4B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389870AbfGXTmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389972AbfGXTmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E1E922ADA;
        Wed, 24 Jul 2019 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997329;
        bh=QiKC/VivQIoxmg3yBRcIcOlipW1TBEmJWn+GEtmyBV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AXGLQNyopUMLcu29kDY59dq8DMMN3few12QNkpJwj/sxFshbLCsAklL+RJtEqcC4
         eHz2BLlNFdZIFUglKwU6EOxs1FakbyM3edMDyhM57L9U/GPbf+Cg2jJn+6e5Y58ClD
         GXIGXCbpGYQoQDYcSGnYoIMBOxlUfWYomIOodIaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>
Subject: [PATCH 5.2 400/413] intel_th: msu: Fix single mode with disabled IOMMU
Date:   Wed, 24 Jul 2019 21:21:31 +0200
Message-Id: <20190724191803.455107597@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 918b8646497b5dba6ae82d4a7325f01b258972b9 upstream.

Commit 4e0eaf239fb3 ("intel_th: msu: Fix single mode with IOMMU") switched
the single mode code to use dma mapping pages obtained from the page
allocator, but with IOMMU disabled, that may lead to using SWIOTLB bounce
buffers and without additional sync'ing, produces empty trace buffers.

Fix this by using a DMA32 GFP flag to the page allocation in single mode,
as the device supports full 32-bit DMA addressing.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 4e0eaf239fb3 ("intel_th: msu: Fix single mode with IOMMU")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -667,7 +667,7 @@ static int msc_buffer_contig_alloc(struc
 		goto err_out;
 
 	ret = -ENOMEM;
-	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO | GFP_DMA32, order);
 	if (!page)
 		goto err_free_sgt;
 


