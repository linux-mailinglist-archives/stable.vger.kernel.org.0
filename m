Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46B5205CA8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbgFWUEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbgFWUEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5CC2080C;
        Tue, 23 Jun 2020 20:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942640;
        bh=Bs0COtO5gmH1Bc35AawVjNfAUDBxD++YQHvvR3z5HDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDm8sOv5BQELzPDJGVp/Q2C4Q8XWRRkJdU1VWdLX1eiiwkMkX62w9YwdJ2ArbLca3
         ugVWdiJygjRyqHVnNMaVnmeCm6OCyVhBRGyoMpm8crim5eyuOdVIvnuR2uIM7SYv2x
         onYWSqIjDg19E5LSJdia48gTg11FAsVvklQXQ9Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 078/477] IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command
Date:   Tue, 23 Jun 2020 21:51:15 +0200
Message-Id: <20200623195411.299829736@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit d246a3061528be6d852156d25c02ea69d6db7e65 ]

The commit citied in the Fixes line wasn't complete and solved
only part of the problems. Update the mlx5_ib to properly support
MLX5_CMD_OP_INIT2INIT_QP command in the DEVX, that is required when
modify the QP tx_port_affinity.

Fixes: 819f7427bafd ("RDMA/mlx5: Add init2init as a modify command")
Link: https://lore.kernel.org/r/20200527135703.482501-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d0742823ab497..ed10e2f32aab0 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -494,6 +494,10 @@ static u64 devx_get_obj_id(const void *in)
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
 					MLX5_GET(rst2init_qp_in, in, qpn));
 		break;
+	case MLX5_CMD_OP_INIT2INIT_QP:
+		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
+					MLX5_GET(init2init_qp_in, in, qpn));
+		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
 					MLX5_GET(init2rtr_qp_in, in, qpn));
-- 
2.25.1



