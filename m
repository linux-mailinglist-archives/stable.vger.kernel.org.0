Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3022229B4AB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789862AbgJ0PDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789852AbgJ0PDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F222071A;
        Tue, 27 Oct 2020 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810995;
        bh=1mpyp45N6F5kRx70Nov6eK+6CCCCm3FCVlgALSJrbgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hn5x0xlLONk1nAcYPlRB5zQZcZFl5x3sqOGhWrCerSLpJxZBR9uMXbZ7rn3Ic3/3T
         Hye7eDkkEo1bO7qG+RFrTEQ0JMSmAzIztbMbd/uxEX32H55yleBC3yfzh996xo5rpK
         OLOnFWTsb2zR8HD6ZLj/tGpjXcsy+hAAy5DFErco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 336/633] RDMA/mlx5: Fix potential race between destroy and CQE poll
Date:   Tue, 27 Oct 2020 14:51:19 +0100
Message-Id: <20201027135538.446538443@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 4b916ed9f9e85f705213ca8d69771d3c1cd6ee5a ]

The SRQ can be destroyed right before mlx5_cmd_get_srq is called.
In such case the latter will return NULL instead of expected SRQ.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20200830084010.102381-5-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 0c18cb6a2f148..3ca379513d0e6 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -168,7 +168,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 {
 	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
-	struct mlx5_ib_srq *srq;
+	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
 	u16 wqe_ctr;
 	u8  roce_packet_type;
@@ -180,7 +180,8 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 
 		if (qp->ibqp.xrcd) {
 			msrq = mlx5_cmd_get_srq(dev, be32_to_cpu(cqe->srqn));
-			srq = to_mibsrq(msrq);
+			if (msrq)
+				srq = to_mibsrq(msrq);
 		} else {
 			srq = to_msrq(qp->ibqp.srq);
 		}
-- 
2.25.1



