Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B735C1D8364
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732772AbgERSEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732316AbgERSEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1022207D3;
        Mon, 18 May 2020 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825060;
        bh=GhLdtHMBcvlMn7X3EK7g3WCOLHNCezwRMq8pXYaFogg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcloXx2IufP1YycrYEUNTgQ1yI+P0+q7ZK3kQu3Mzl67/Qw/mr0RJkSx5gyYT9Nrd
         F6iO9Xz+EqOAEH447zbqLU6L83dKaaRqyuCVLZzTFEd6rCI5e7OLTdU3WPQcsEagtC
         uymiiNUYt4H30JCrKz9DBDG5ThyHSAhYjnNY7N1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 112/194] IB/mlx4: Test return value of calls to ib_get_cached_pkey
Date:   Mon, 18 May 2020 19:36:42 +0200
Message-Id: <20200518173541.087790530@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 6693ca95bd4330a0ad7326967e1f9bcedd6b0800 ]

In the mlx4_ib_post_send() flow, some functions call ib_get_cached_pkey()
without checking its return value. If ib_get_cached_pkey() returns an
error code, these functions should return failure.

Fixes: 1ffeb2eb8be9 ("IB/mlx4: SR-IOV IB context objects and proxy/tunnel SQP support")
Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Fixes: e622f2f4ad21 ("IB: split struct ib_send_wr")
Link: https://lore.kernel.org/r/20200426075921.130074-1-leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 26425dd2d960f..a2b1f6af5ba3f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2891,6 +2891,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	int send_size;
 	int header_size;
 	int spc;
+	int err;
 	int i;
 
 	if (wr->wr.opcode != IB_WR_SEND)
@@ -2925,7 +2926,9 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 
 	sqp->ud_header.lrh.virtual_lane    = 0;
 	sqp->ud_header.bth.solicited_event = !!(wr->wr.send_flags & IB_SEND_SOLICITED);
-	ib_get_cached_pkey(ib_dev, sqp->qp.port, 0, &pkey);
+	err = ib_get_cached_pkey(ib_dev, sqp->qp.port, 0, &pkey);
+	if (err)
+		return err;
 	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
 	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER)
 		sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->remote_qpn);
@@ -3212,9 +3215,14 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, const struct ib_ud_wr *wr,
 	}
 	sqp->ud_header.bth.solicited_event = !!(wr->wr.send_flags & IB_SEND_SOLICITED);
 	if (!sqp->qp.ibqp.qp_num)
-		ib_get_cached_pkey(ib_dev, sqp->qp.port, sqp->pkey_index, &pkey);
+		err = ib_get_cached_pkey(ib_dev, sqp->qp.port, sqp->pkey_index,
+					 &pkey);
 	else
-		ib_get_cached_pkey(ib_dev, sqp->qp.port, wr->pkey_index, &pkey);
+		err = ib_get_cached_pkey(ib_dev, sqp->qp.port, wr->pkey_index,
+					 &pkey);
+	if (err)
+		return err;
+
 	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
 	sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->remote_qpn);
 	sqp->ud_header.bth.psn = cpu_to_be32((sqp->send_psn++) & ((1 << 24) - 1));
-- 
2.20.1



