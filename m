Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE212C7FB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbfL2RtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731633AbfL2RtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27A3D206DB;
        Sun, 29 Dec 2019 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641763;
        bh=uNZl7f5UhB+UsZoV84lUGTHZX/E8YRgp6q45n84cjgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yr1qrbm8M9kjwnRdJpOZqMm0yiF1b7aXH1BhO06RrY4UFwuGRq1Cvsv00xg7GGAH0
         ocn7eTx7edvl7GVoHHknESdb7CZYYjkdJNzPm+ssVjODqyrYRjRuSgzqVOm3PWhQYK
         szhkcYBdmHt4F0BiTmwhIarEfJYhcFdHjZ8RmSp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/434] RDMA/core: Set DMA parameters correctly
Date:   Sun, 29 Dec 2019 18:24:15 +0100
Message-Id: <20191229172715.246516066@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c9121262d57b8a3be4f08073546436ba0128ca6a ]

The dma_set_max_seg_size() call in setup_dma_device() does not have any
effect since device->dev.dma_parms is NULL. Fix this by initializing
device->dev.dma_parms first.

Link: https://lore.kernel.org/r/20191025225830.257535-5-bvanassche@acm.org
Fixes: d10bcf947a3e ("RDMA/umem: Combine contiguous PAGE_SIZE regions in SGEs")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 50a92442c4f7..e6327d8f5b79 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1199,9 +1199,21 @@ static void setup_dma_device(struct ib_device *device)
 		WARN_ON_ONCE(!parent);
 		device->dma_device = parent;
 	}
-	/* Setup default max segment size for all IB devices */
-	dma_set_max_seg_size(device->dma_device, SZ_2G);
 
+	if (!device->dev.dma_parms) {
+		if (parent) {
+			/*
+			 * The caller did not provide DMA parameters, so
+			 * 'parent' probably represents a PCI device. The PCI
+			 * core sets the maximum segment size to 64
+			 * KB. Increase this parameter to 2 GB.
+			 */
+			device->dev.dma_parms = parent->dma_parms;
+			dma_set_max_seg_size(device->dma_device, SZ_2G);
+		} else {
+			WARN_ON_ONCE(true);
+		}
+	}
 }
 
 /*
-- 
2.20.1



