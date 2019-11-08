Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A6DF4A03
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390476AbfKHMGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389152AbfKHLlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB6E222C5;
        Fri,  8 Nov 2019 11:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213265;
        bh=bRuj8CaW3i77z39sNUpYq4u9Rthmjs806R22l2nD95s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrUzYEelY//iXQMaPT5AXHu+sDqE3QWLixjFq1oCW7PFgL4f9/GdmE9BM471Z6d0s
         on7GKTmKDLARxc5EAMsRYQ1CDdTzL5bM6ZcuGfkeq6rM5904/xBSdMJEty4F/vvnSH
         OF7jp8PTPa+oKPb5AVpC6qUgOtqVfbEUT4TMCFiI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 129/205] RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()
Date:   Fri,  8 Nov 2019 06:36:36 -0500
Message-Id: <20191108113752.12502-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f1a315420e79fe5c077fa119db9439ffabd2cda2 ]

The error code isn't set on this path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a442b29e76119..72cfd8c56527e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5117,6 +5117,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		create_singlethread_workqueue("hns_roce_irq_workqueue");
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
+		ret = -ENOMEM;
 		goto err_request_irq_fail;
 	}
 
-- 
2.20.1

