Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531B310BD49
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfK0U7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731384AbfK0U7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C1520678;
        Wed, 27 Nov 2019 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888350;
        bh=5Rj1jG5AzJgIvv4KhlSc3ZZrRvnb6Sthh2t/XsVj9iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Czjg0EqRet18GzZ0KzmixOp+nySKUrCq9+i8RwnxZ+lde2cxMpaFNML27EmKaxwQL
         Qf80OLCZVI1N88+q27SvcE+yHTlUkb4B9LCOMtEVTtqU2wDBeaD/tblt2zV62p9I2n
         wsgXgJqAzWvTNHo2PNvN/Gccs6Au2uOdRWDmCxck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/306] RDMA/bnxt_re: Avoid NULL check after accessing the pointer
Date:   Wed, 27 Nov 2019 21:28:27 +0100
Message-Id: <20191127203118.939326854@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



