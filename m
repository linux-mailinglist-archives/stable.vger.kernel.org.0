Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9B11196AE
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfLJVKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfLJVKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B208C246AE;
        Tue, 10 Dec 2019 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012224;
        bh=UYvC9jLuPEh47VxapmE3mo4NpQmSajDfTpdi2gU7HcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njKjWHYH4nLbaaevFHVD7nx2a4l4F09yCZmB1a7x3Bz0d8pErOIJgFjOaXqK8frRt
         v2LiPEIeOaWTJla2igiiThhd+kTEyAAR6Lgxz4CwTO/2QaryrvRgQjAJp2eAAXVWn7
         /aLmfiCAgOJ/0HX2V4oMTdAqzG2bBo2flB4V1x8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 174/350] RDMA/core: Set DMA parameters correctly
Date:   Tue, 10 Dec 2019 16:04:39 -0500
Message-Id: <20191210210735.9077-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 50a92442c4f7c..e6327d8f5b79a 100644
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

