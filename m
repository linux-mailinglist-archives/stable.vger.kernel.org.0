Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E391FE2E6
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgFRCEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbgFRBW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649C120CC7;
        Thu, 18 Jun 2020 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443377;
        bh=f3IrhpYIO11PWkZc3xRDXXaFzg5TqWFtpqCE+5k93P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEeELnDE+GjaJdVAHGAz+LKvR7h+GnwmYzm1KYJbPWvOFUpUSmNQv/myAg8gIgV9e
         qAl8vg6G7T/gF4PDRk10qAtCsgwT8e+LRvEP1ZoUOvtTseL08nDBQcAAvR0yyGigyx
         mADR3+TjZp17VhlsnHSrHlDa0VBCeXwuxEUHrLcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 029/172] RDMA/mlx5: Add init2init as a modify command
Date:   Wed, 17 Jun 2020 21:19:55 -0400
Message-Id: <20200618012218.607130-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
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
index 02f36ab72ad4..4c90a007e09d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -328,6 +328,7 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_SET_L2_TABLE_ENTRY:
 	case MLX5_CMD_OP_RST2INIT_QP:
 	case MLX5_CMD_OP_INIT2RTR_QP:
+	case MLX5_CMD_OP_INIT2INIT_QP:
 	case MLX5_CMD_OP_RTR2RTS_QP:
 	case MLX5_CMD_OP_RTS2RTS_QP:
 	case MLX5_CMD_OP_SQERR2RTS_QP:
-- 
2.25.1

