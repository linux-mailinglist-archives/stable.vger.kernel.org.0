Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C667A1FE875
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgFRCsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbgFRBJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A9521D81;
        Thu, 18 Jun 2020 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442589;
        bh=fWXoNeWIuJf9vCcApP5j1kVjbuJieCGDmtWUW1sTry0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQZIHfhgNHqD29q1y1l35m19Z/VSs0CRsNXn88sTlAHQjQKhGVfvXyoGmGs6tzsLI
         dQsCbss0kOehSdsayCO3UsmWpEqn0fl+B9Vqv4nfsHv9I4QaciqRxEsdolD7IDS8n8
         Xejoc7z2+gX+t9Vy36WF8huc0BZ/GmACZzZGntsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 079/388] IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command
Date:   Wed, 17 Jun 2020 21:02:56 -0400
Message-Id: <20200618010805.600873-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d0742823ab49..ed10e2f32aab 100644
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

