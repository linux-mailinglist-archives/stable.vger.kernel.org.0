Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62BC13E07D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAPQnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgAPQnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A7842081E;
        Thu, 16 Jan 2020 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193026;
        bh=YzeLpS/wxtguOD7vecYSmimwbUC6VaOPLGJ3e/GYWpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/2NuKCILW3BijzWvfQ3k72OArT/BeGE8CXRWo9DjCm3DBSex5eaqw9tucePCHlKT
         j+0g2eyowZW+Y4ZNifI5wIoDBRIKEsAHfPn1AxEulkTm5EiwKm/TACxKaQrXAegGOk
         YUFGAJvY7EaTplySM14PXcjz1HcZZtcUMVCMHei4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 009/205] RDMA/counter: Prevent QP counter manual binding in auto mode
Date:   Thu, 16 Jan 2020 11:39:44 -0500
Message-Id: <20200116164300.6705-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit 663912a6378a34fd4f43b8d873f0c6c6322d9d0e ]

If auto mode is configured, manual counter allocation and QP bind is not
allowed.

Fixes: 1bd8e0a9d0fd ("RDMA/counter: Allow manual mode configuration support")
Link: https://lore.kernel.org/r/20190916071154.20383-3-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 023478107f0e..46dd50ff7c85 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -466,10 +466,15 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 			  u32 qp_num, u32 counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;
 
+	port_counter = &dev->port_data[port].port_counter;
+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;
@@ -506,6 +511,7 @@ int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 				u32 qp_num, u32 *counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;
@@ -513,9 +519,13 @@ int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 	if (!rdma_is_port_valid(dev, port))
 		return -EINVAL;
 
-	if (!dev->port_data[port].port_counter.hstats)
+	port_counter = &dev->port_data[port].port_counter;
+	if (!port_counter->hstats)
 		return -EOPNOTSUPP;
 
+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;
-- 
2.20.1

