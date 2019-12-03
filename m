Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF0111F96
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfLCWmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfLCWmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06151206EC;
        Tue,  3 Dec 2019 22:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412957;
        bh=kClL4X02snhF3MqOZmW3yyTeA+dtndlqNgvN1cfOq3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yaATsXVAL2oXJ+74ZeR6bgtM6Red+Bdmcr99886NDcauDAlQNWTOFmayQv/SwFr6g
         w+aZMTcSik9bLzNvP9X/7SY14TFtT5OCPhYHUqOUQBLHB9/JgjH/x0gFgqoIx6tjig
         MIrAaU+banF5LQdNgyK+btnZrDNWU6St/Z6H/KzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 079/135] net/mlx5e: Use correct enum to determine uplink port
Date:   Tue,  3 Dec 2019 23:35:19 +0100
Message-Id: <20191203213029.939749386@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit 950d3af70ea89cf7ac51d734a634174013631192 ]

For vlan push action, if eswitch flow source capability is enabled, flow
source value compared with MLX5_VPORT_UPLINK enum, to determine uplink
port. This lead to syndrome in dmesg if try to add vlan push action.
For example:
 $ tc filter add dev vxlan0 ingress protocol ip prio 1 flower \
       enc_dst_port 4789 \
       action tunnel_key unset pipe \
       action vlan push id 20 pipe \
       action mirred egress redirect dev ens1f0_0
 $ dmesg
 ...
 [ 2456.883693] mlx5_core 0000:82:00.0: mlx5_cmd_check:756:(pid 5273): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0xa9c090)
Use the correct enum value MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK.

Fixes: bb204dcf39fe ("net/mlx5e: Determine source port properly for vlan push action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 7879e1746297c..366bda1bb1c32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -183,7 +183,8 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 	u32 port_mask, port_value;
 
 	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
-		return spec->flow_context.flow_source == MLX5_VPORT_UPLINK;
+		return spec->flow_context.flow_source ==
+					MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 
 	port_mask = MLX5_GET(fte_match_param, spec->match_criteria,
 			     misc_parameters.source_port);
-- 
2.20.1



