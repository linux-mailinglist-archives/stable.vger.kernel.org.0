Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84641106232
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfKVGCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfKVGCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38892068E;
        Fri, 22 Nov 2019 06:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402528;
        bh=NeGNlvD4uAxrKBCUgf82c57Y6tijqlSLF42AuaAvVwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekRR5QPFBbmkft+TrpqXTMXHwKPaw3OC615OXAMX/JEWVgkyekmD3W0QBJNXXQgnS
         wo43XQKDRnvC0mrCKcV/X5cJjEw7o74ZH5MEzx3spqAAYZCEB2iuk535Iesh+k826g
         7iQz3t7O4qlQJQL2C9UF03lJzLBe8GI0RKbGmIVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 36/91] IB/qib: Fix an error code in qib_sdma_verbs_send()
Date:   Fri, 22 Nov 2019 01:00:34 -0500
Message-Id: <20191122060129.4239-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5050ae5fa3d54c8e83e1e447cc7e3591110a7f57 ]

We accidentally return success on this error path.

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 891873b38a1e6..5f3f197678b78 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -600,8 +600,10 @@ int qib_sdma_verbs_send(struct qib_pportdata *ppd,
 		dw = (len + 3) >> 2;
 		addr = dma_map_single(&ppd->dd->pcidev->dev, sge->vaddr,
 				      dw << 2, DMA_TO_DEVICE);
-		if (dma_mapping_error(&ppd->dd->pcidev->dev, addr))
+		if (dma_mapping_error(&ppd->dd->pcidev->dev, addr)) {
+			ret = -ENOMEM;
 			goto unmap;
+		}
 		sdmadesc[0] = 0;
 		make_sdma_desc(ppd, sdmadesc, (u64) addr, dw, dwoffset);
 		/* SDmaUseLargeBuf has to be set in every descriptor */
-- 
2.20.1

