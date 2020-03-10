Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2B17F92A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgCJMy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgCJMy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED5C24692;
        Tue, 10 Mar 2020 12:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844866;
        bh=uZ3e2sAC+DUv2HA27y3ZUYEuia0YujYutSP2G86WGiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlZOnrx+YAu/YjnoQdNteur4KLvjoUI+FTH9M0WPOqzznHrH94PapXtgfGbLDIjTq
         yHnUriVIB80XMLeNHwAxBANBHHWFDtXsQ8Agg6XcmDs91afokZ71Fe+CQNr4gA2IOv
         tJ4GNWaPiM+xP6WbeHa/xiB7I7yCw1NpkPdSYLqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 146/168] RDMA/rw: Fix error flow during RDMA context initialization
Date:   Tue, 10 Mar 2020 13:39:52 +0100
Message-Id: <20200310123650.306129285@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

commit 6affca140cbea01f497c4f4e16f1e2be7f74bd04 upstream.

In case the SGL was mapped for P2P DMA operation, we must unmap it using
pci_p2pdma_unmap_sg during the error unwind of rdma_rw_ctx_init()

Fixes: 7f73eac3a713 ("PCI/P2PDMA: Introduce pci_p2pdma_unmap_sg()")
Link: https://lore.kernel.org/r/20200220100819.41860-1-maxg@mellanox.com
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/rw.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -268,6 +268,23 @@ static int rdma_rw_init_single_wr(struct
 	return 1;
 }
 
+static void rdma_rw_unmap_sg(struct ib_device *dev, struct scatterlist *sg,
+			     u32 sg_cnt, enum dma_data_direction dir)
+{
+	if (is_pci_p2pdma_page(sg_page(sg)))
+		pci_p2pdma_unmap_sg(dev->dma_device, sg, sg_cnt, dir);
+	else
+		ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+}
+
+static int rdma_rw_map_sg(struct ib_device *dev, struct scatterlist *sg,
+			  u32 sg_cnt, enum dma_data_direction dir)
+{
+	if (is_pci_p2pdma_page(sg_page(sg)))
+		return pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
+	return ib_dma_map_sg(dev, sg, sg_cnt, dir);
+}
+
 /**
  * rdma_rw_ctx_init - initialize a RDMA READ/WRITE context
  * @ctx:	context to initialize
@@ -290,11 +307,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx
 	struct ib_device *dev = qp->pd->device;
 	int ret;
 
-	if (is_pci_p2pdma_page(sg_page(sg)))
-		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
-	else
-		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
-
+	ret = rdma_rw_map_sg(dev, sg, sg_cnt, dir);
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
@@ -333,7 +346,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx
 	return ret;
 
 out_unmap_sg:
-	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	rdma_rw_unmap_sg(dev, sg, sg_cnt, dir);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_rw_ctx_init);
@@ -583,11 +596,7 @@ void rdma_rw_ctx_destroy(struct rdma_rw_
 		break;
 	}
 
-	if (is_pci_p2pdma_page(sg_page(sg)))
-		pci_p2pdma_unmap_sg(qp->pd->device->dma_device, sg,
-				    sg_cnt, dir);
-	else
-		ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	rdma_rw_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 


