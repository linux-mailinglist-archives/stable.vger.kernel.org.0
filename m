Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFEBFF38C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfKPPl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfKPPl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:56 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF9020740;
        Sat, 16 Nov 2019 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918915;
        bh=5Rj1jG5AzJgIvv4KhlSc3ZZrRvnb6Sthh2t/XsVj9iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AohsvXIIBUS/tAuy7LCnQk6sL3NRTht3UKmgkX9Q7TDlvXx78jTlR8sFSrDJsEgLi
         8egeh5iaXqjKbQ3ozGNK/kTtbLfpyQnpGlOSGoFnuhr7Nub2bUsJl0vD7XQ3nIwV/9
         OjIVHO9GyZdgqpQ7PRsevsWFsHcM2k/aMQOMcv2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 038/237] RDMA/bnxt_re: Avoid NULL check after accessing the pointer
Date:   Sat, 16 Nov 2019 10:37:53 -0500
Message-Id: <20191116154113.7417-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit eae4ad1b0c9a77ef0cbac212d58d46976eaacfc1 ]

This is reported by smatch check.  rcfw->creq_bar_reg_iomem is accessed in
bnxt_qplib_rcfw_stop_irq and this variable check afterwards doesn't make
sense.  Also, rcfw->creq_bar_reg_iomem will never be NULL.  So Removing
this check.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6e04b1035689 ("RDMA/bnxt_re: Fix broken RoCE driver due to recent L2 driver changes")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 6637df77d2365..8b3b5fdc19bbb 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -614,13 +614,8 @@ void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
 
 	bnxt_qplib_rcfw_stop_irq(rcfw, true);
 
-	if (rcfw->cmdq_bar_reg_iomem)
-		iounmap(rcfw->cmdq_bar_reg_iomem);
-	rcfw->cmdq_bar_reg_iomem = NULL;
-
-	if (rcfw->creq_bar_reg_iomem)
-		iounmap(rcfw->creq_bar_reg_iomem);
-	rcfw->creq_bar_reg_iomem = NULL;
+	iounmap(rcfw->cmdq_bar_reg_iomem);
+	iounmap(rcfw->creq_bar_reg_iomem);
 
 	indx = find_first_bit(rcfw->cmdq_bitmap, rcfw->bmap_size);
 	if (indx != rcfw->bmap_size)
@@ -629,6 +624,8 @@ void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
 	kfree(rcfw->cmdq_bitmap);
 	rcfw->bmap_size = 0;
 
+	rcfw->cmdq_bar_reg_iomem = NULL;
+	rcfw->creq_bar_reg_iomem = NULL;
 	rcfw->aeq_handler = NULL;
 	rcfw->vector = 0;
 }
@@ -714,6 +711,8 @@ int bnxt_qplib_enable_rcfw_channel(struct pci_dev *pdev,
 		dev_err(&rcfw->pdev->dev,
 			"QPLIB: CREQ BAR region %d mapping failed",
 			rcfw->creq_bar_reg);
+		iounmap(rcfw->cmdq_bar_reg_iomem);
+		rcfw->cmdq_bar_reg_iomem = NULL;
 		return -ENOMEM;
 	}
 	rcfw->creq_qp_event_processed = 0;
-- 
2.20.1

