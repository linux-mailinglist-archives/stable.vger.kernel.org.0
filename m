Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A017D163189
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgBRUBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgBRUB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B351424672;
        Tue, 18 Feb 2020 20:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056086;
        bh=jdgZpNdjBCoaVi1w16uWteitn7yXv88bqs3xbtmdmL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+qserRSk2YiE6KIbSJng7wjz+ntHDf5nGEjsioiMTHWCf+vhxYugsixj467NjwL/
         1vclIYWq/X09nu2lLboofKky7XzEO1D2j+3nqe8+teNq7iCheDPiGGDX+EJsaWrY5Y
         dhPuHhkBRO+i9Hl0Zu6AM5sEYWQUEfEcRJxJmMzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Tomt <andre@tomt.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.5 29/80] xprtrdma: Fix DMA scatter-gather list mapping imbalance
Date:   Tue, 18 Feb 2020 20:54:50 +0100
Message-Id: <20200218190435.228070609@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit ca1c671302825182629d3c1a60363cee6f5455bb upstream.

The @nents value that was passed to ib_dma_map_sg() has to be passed
to the matching ib_dma_unmap_sg() call. If ib_dma_map_sg() choses to
concatenate sg entries, it will return a different nents value than
it was passed.

The bug was exposed by recent changes to the AMD IOMMU driver, which
enabled sg entry concatenation.

Looking all the way back to commit 4143f34e01e9 ("xprtrdma: Port to
new memory registration API") and reviewing other kernel ULPs, it's
not clear that the frwr_map() logic was ever correct for this case.

Reported-by: Andre Tomt <andre@tomt.net>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/frwr_ops.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -298,8 +298,8 @@ struct rpcrdma_mr_seg *frwr_map(struct r
 {
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct ib_reg_wr *reg_wr;
+	int i, n, dma_nents;
 	struct ib_mr *ibmr;
-	int i, n;
 	u8 key;
 
 	if (nsegs > ia->ri_max_frwr_depth)
@@ -323,15 +323,16 @@ struct rpcrdma_mr_seg *frwr_map(struct r
 			break;
 	}
 	mr->mr_dir = rpcrdma_data_dir(writing);
+	mr->mr_nents = i;
 
-	mr->mr_nents =
-		ib_dma_map_sg(ia->ri_id->device, mr->mr_sg, i, mr->mr_dir);
-	if (!mr->mr_nents)
+	dma_nents = ib_dma_map_sg(ia->ri_id->device, mr->mr_sg, mr->mr_nents,
+				  mr->mr_dir);
+	if (!dma_nents)
 		goto out_dmamap_err;
 
 	ibmr = mr->frwr.fr_mr;
-	n = ib_map_mr_sg(ibmr, mr->mr_sg, mr->mr_nents, NULL, PAGE_SIZE);
-	if (unlikely(n != mr->mr_nents))
+	n = ib_map_mr_sg(ibmr, mr->mr_sg, dma_nents, NULL, PAGE_SIZE);
+	if (n != dma_nents)
 		goto out_mapmr_err;
 
 	ibmr->iova &= 0x00000000ffffffff;


