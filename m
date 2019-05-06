Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8ED14DF6
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfEFO4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfEFOow (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:44:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EFD2053B;
        Mon,  6 May 2019 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153891;
        bh=Gf/gTgeIoE4zABm9pswI2HzfvG1pzYaXciTyOVoaJ0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0d6L+0RIfi8iJEzx874/Z4aQxKt6ZXAIQAID6deLoxAQGa7e/lIJwEuYir5Bf+pdB
         2E1RUN/lYo+bN/is30vdyjT+pyBJ1dN6IQU/Q7cZyw3DrTT8dqzpu2w33WmzZY6WU6
         n7E8TjF4gzuZl4/8wFh7VRxTwwXBotwIca/fQ6GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omri Kahalon <omrik@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/75] net/mlx5: E-Switch, Fix esw manager vport indication for more vport commands
Date:   Mon,  6 May 2019 16:32:42 +0200
Message-Id: <20190506143056.299952048@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eca4a928585ac08147e5cc8e2111ecbc6279ee31 ]

Traditionally, the PF (Physical Function) which resides on vport 0 was
the E-switch manager. Since the ECPF (Embedded CPU Physical Function),
which resides on vport 0xfffe, was introduced as the E-Switch manager,
the assumption that the E-switch manager is on vport 0 is incorrect.

Since the eswitch code already uses the actual vport value, all we
need is to always set other_vport=1.

Signed-off-by: Omri Kahalon <omrik@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d2914116af8e..090d54275a7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -79,8 +79,7 @@ static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
 		 opcode, MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 	MLX5_SET(modify_nic_vport_context_in, in, field_select.change_event, 1);
 	MLX5_SET(modify_nic_vport_context_in, in, vport_number, vport);
-	if (vport)
-		MLX5_SET(modify_nic_vport_context_in, in, other_vport, 1);
+	MLX5_SET(modify_nic_vport_context_in, in, other_vport, 1);
 	nic_vport_ctx = MLX5_ADDR_OF(modify_nic_vport_context_in,
 				     in, nic_vport_context);
 
@@ -108,8 +107,7 @@ static int modify_esw_vport_context_cmd(struct mlx5_core_dev *dev, u16 vport,
 	MLX5_SET(modify_esw_vport_context_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_ESW_VPORT_CONTEXT);
 	MLX5_SET(modify_esw_vport_context_in, in, vport_number, vport);
-	if (vport)
-		MLX5_SET(modify_esw_vport_context_in, in, other_vport, 1);
+	MLX5_SET(modify_esw_vport_context_in, in, other_vport, 1);
 	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
 
-- 
2.20.1



