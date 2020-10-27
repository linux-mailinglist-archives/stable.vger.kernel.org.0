Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA029B21B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761080AbgJ0Ohy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761079AbgJ0Ohy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B1621D7B;
        Tue, 27 Oct 2020 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809473;
        bh=Bxe45CP/geLEHgOI0YBVSgpaBrjGzm0SJAl+YrQK1tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOOaMGAkxXoUiFsZpewRJ2wX+IuO1FImRTyZsc8XbfYMuBNVGFnfLtL3wE3Mp/ECB
         mavGuV18bBuahFBEGVODpti0mPuSFGzcMcxJIiP0eCw4qtnbvgCEUaHk6lh0r9Q6M1
         gn/1BSj4jFJHK7dRnP8lwE0+bHkU+792SHOpBtC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/408] RDMA/mlx5: Fix potential race between destroy and CQE poll
Date:   Tue, 27 Oct 2020 14:52:26 +0100
Message-Id: <20201027135504.745327553@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index ff664355de550..73d5b8dc74d86 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -167,7 +167,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 {
 	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
-	struct mlx5_ib_srq *srq;
+	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
 	u16 wqe_ctr;
 	u8  roce_packet_type;
@@ -179,7 +179,8 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 
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



