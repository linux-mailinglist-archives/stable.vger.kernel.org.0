Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279E1D80BA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgERRlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbgERRln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:41:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E566620715;
        Mon, 18 May 2020 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823702;
        bh=NiLw0/Kb0xmuy06SBKrKtUCqZfQThB7sAaJN2reodso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8wHAzud1hziGAv4bzRsIPvLvj+tvWSSdkNtp8xtDwkv/uA4FX2sj3HEeFFkV7Xsh
         ADXZGYS3OO3sQzgvYFSe9Jw4W3vfRqf/Sy6guo6R5ndmnmnWyd3J08XhYtMRCa3xaL
         tNI7d0YbjRKCaXs2EfIpyobrvZMl5zZIdVZnLr3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 54/86] IB/mlx4: Test return value of calls to ib_get_cached_pkey
Date:   Mon, 18 May 2020 19:36:25 +0200
Message-Id: <20200518173501.461163403@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
index 348828271cb07..ecd461ee6dbe2 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2156,6 +2156,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	int send_size;
 	int header_size;
 	int spc;
+	int err;
 	int i;
 
 	if (wr->wr.opcode != IB_WR_SEND)
@@ -2190,7 +2191,9 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 
 	sqp->ud_header.lrh.virtual_lane    = 0;
 	sqp->ud_header.bth.solicited_event = !!(wr->wr.send_flags & IB_SEND_SOLICITED);
-	ib_get_cached_pkey(ib_dev, sqp->qp.port, 0, &pkey);
+	err = ib_get_cached_pkey(ib_dev, sqp->qp.port, 0, &pkey);
+	if (err)
+		return err;
 	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
 	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER)
 		sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->remote_qpn);
@@ -2423,9 +2426,14 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
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



