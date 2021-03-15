Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED82333BC52
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhCOOYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238483AbhCOOXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:23:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1BC64F40;
        Mon, 15 Mar 2021 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818198;
        bh=ZWO8bpuiQCpUywG7wjB5krr6QXLKHQRgBv2Zoiscf3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T88GO/cyLT/RTFm05MvBRmjM+wX0p5ykZk+3tVfECtdOuYuBEXu0nNReJIysTNBk0
         c5cIFw7M8TUMIxksThGEkezDpLRoLEaBUg3g9mVD+Bm21ww25ehjSz+e8L6dU7fuaU
         VpK4SbCWufoXodgWI0hvbloLmF4vrze20a2HPN4I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 5.10 290/290] RDMA/umem: Use ib_dma_max_seg_size instead of dma_get_max_seg_size
Date:   Mon, 15 Mar 2021 15:22:40 +0100
Message-Id: <20210315135551.845274252@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christoph Hellwig <hch@lst.de>

commit b116c702791a9834e6485f67ca6267d9fdf59b87 upstream.

RDMA ULPs must not call DMA mapping APIs directly but instead use the
ib_dma_* wrappers.

Fixes: 0c16d9635e3a ("RDMA/umem: Move to allocate SG table from pages")
Link: https://lore.kernel.org/r/20201106181941.1878556-3-hch@lst.de
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/umem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -220,10 +220,10 @@ struct ib_umem *ib_umem_get(struct ib_de
 
 		cur_base += ret * PAGE_SIZE;
 		npages -= ret;
-		sg = __sg_alloc_table_from_pages(
-			&umem->sg_head, page_list, ret, 0, ret << PAGE_SHIFT,
-			dma_get_max_seg_size(device->dma_device), sg, npages,
-			GFP_KERNEL);
+		sg = __sg_alloc_table_from_pages(&umem->sg_head, page_list, ret,
+				0, ret << PAGE_SHIFT,
+				ib_dma_max_seg_size(device), sg, npages,
+				GFP_KERNEL);
 		umem->sg_nents = umem->sg_head.nents;
 		if (IS_ERR(sg)) {
 			unpin_user_pages_dirty_lock(page_list, ret, 0);


