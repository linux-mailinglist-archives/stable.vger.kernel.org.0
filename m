Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061B8328E95
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbhCATdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241705AbhCAT2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92586504F;
        Mon,  1 Mar 2021 17:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619122;
        bh=YI0eMn0QVMHl6mOr6ihrj7Dc/tcvgD1OP8w3fYaMhmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ool+dInsCbIltivQALA5SkcsQKpE7/TmiA+3Nk+hctPZ1AwoyiLSK8rHY45XkE6/t
         fXvAuw9TiVd9xlrqI+8VuwlNM6K4lpVfVSgrT2p/dT9rurSImU7HQQePY7CY1XWhYv
         Mn9mzDSLxYCsPx68JFZQXVlbAv/X4zZehfrO7xE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/663] IB/cm: Avoid a loop when device has 255 ports
Date:   Mon,  1 Mar 2021 17:09:48 +0100
Message-Id: <20210301161158.675209163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 131be26750379592f0dd6244b2a90bbb504a10bb ]

When RDMA device has 255 ports, loop iterator i overflows.  Due to which
cm_add_one() port iterator loops infinitely.  Use core provided port
iterator to avoid the infinite loop.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20210127150010.1876121-9-leon@kernel.org
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5afd142fe8c78..8e578f73a074c 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4332,7 +4332,7 @@ static int cm_add_one(struct ib_device *ib_device)
 	unsigned long flags;
 	int ret;
 	int count = 0;
-	u8 i;
+	unsigned int i;
 
 	cm_dev = kzalloc(struct_size(cm_dev, port, ib_device->phys_port_cnt),
 			 GFP_KERNEL);
@@ -4344,7 +4344,7 @@ static int cm_add_one(struct ib_device *ib_device)
 	cm_dev->going_down = 0;
 
 	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
-	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
+	rdma_for_each_port (ib_device, i) {
 		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
@@ -4430,7 +4430,7 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 		.clr_port_cap_mask = IB_PORT_CM_SUP
 	};
 	unsigned long flags;
-	int i;
+	unsigned int i;
 
 	write_lock_irqsave(&cm.device_lock, flags);
 	list_del(&cm_dev->list);
@@ -4440,7 +4440,7 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 	cm_dev->going_down = 1;
 	spin_unlock_irq(&cm.lock);
 
-	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
+	rdma_for_each_port (ib_device, i) {
 		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
-- 
2.27.0



