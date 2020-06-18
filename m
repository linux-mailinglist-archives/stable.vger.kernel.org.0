Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64521FE543
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgFRCYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbgFRBRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DE621D82;
        Thu, 18 Jun 2020 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443056;
        bh=VBuOm0mYioZ/oPmB+op4PwP9fnF2/CigkbE2kWwy4gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdO1dWQRVi9ZrDikbfh4MIwc5sqVRtVgsu9uXjTxBsfobH69pyfYja5y+XSi7gINJ
         dUvmSwtnEJgDQJWYceCFWfCTnkdrbJ00W5eP03LhBF1DGprPQ7UsG7hfEt1w46gthh
         0yb26HAme7mI8EPS5GVZCwIsucaij1oAsvWLH+aI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 048/266] RDMA/mlx5: Add init2init as a modify command
Date:   Wed, 17 Jun 2020 21:12:53 -0400
Message-Id: <20200618011631.604574-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

[ Upstream commit 819f7427bafd494ef7ca4942ec6322db20722d7b ]

Missing INIT2INIT entry in the list of modify commands caused DEVX
applications to be unable to modify_qp for this transition state. Add the
MLX5_CMD_OP_INIT2INIT_QP opcode to the list of allowed DEVX opcodes.

Fixes: e662e14d801b ("IB/mlx5: Add DEVX support for modify and query commands")
Link: https://lore.kernel.org/r/20200513095550.211345-1-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d609f4659afb..bba7ab078430 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -814,6 +814,7 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_SET_L2_TABLE_ENTRY:
 	case MLX5_CMD_OP_RST2INIT_QP:
 	case MLX5_CMD_OP_INIT2RTR_QP:
+	case MLX5_CMD_OP_INIT2INIT_QP:
 	case MLX5_CMD_OP_RTR2RTS_QP:
 	case MLX5_CMD_OP_RTS2RTS_QP:
 	case MLX5_CMD_OP_SQERR2RTS_QP:
-- 
2.25.1

