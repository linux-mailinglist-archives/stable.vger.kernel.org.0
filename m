Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3ADF56DD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389772AbfKHTMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390051AbfKHTJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F66B2087E;
        Fri,  8 Nov 2019 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240168;
        bh=lVfUzs0XaUfMA1SqTd9PMM/LNeM6DjQ5596yGRW+XvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIOz8m66vZlBtDJmpCP3YkmKPWQ5evsYhfInVvIq4uh+ogGH3oB25yuSsoavcy3T9
         hWcoq9MpMFTNV+xCuaHzE0QXkw8tkYFvZjmYPuj50oYnh6tHB1VZ5lp2g6Rw6L8sxw
         uTk9spj9Nb7OEmNv+oxTVaZ46JcmxLFOPOU+9qig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 110/140] net/mlx5e: Determine source port properly for vlan push action
Date:   Fri,  8 Nov 2019 19:50:38 +0100
Message-Id: <20191108174911.801053479@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit d5dbcc4e87bc8444bd2f1ca4b8f787e1e5677ec2 ]

Termination tables are used for vlan push actions on uplink ports.
To support RoCE dual port the source port value was placed in a register.
Fix the code to use an API method returning the source port according to
the FW capabilities.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   22 +++++++---
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -177,22 +177,32 @@ mlx5_eswitch_termtbl_actions_move(struct
 	memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
 }
 
+static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
+						const struct mlx5_flow_spec *spec)
+{
+	u32 port_mask, port_value;
+
+	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
+		return spec->flow_context.flow_source == MLX5_VPORT_UPLINK;
+
+	port_mask = MLX5_GET(fte_match_param, spec->match_criteria,
+			     misc_parameters.source_port);
+	port_value = MLX5_GET(fte_match_param, spec->match_value,
+			      misc_parameters.source_port);
+	return (port_mask & port_value & 0xffff) == MLX5_VPORT_UPLINK;
+}
+
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
-	u32 port_mask = MLX5_GET(fte_match_param, spec->match_criteria,
-				 misc_parameters.source_port);
-	u32 port_value = MLX5_GET(fte_match_param, spec->match_value,
-				  misc_parameters.source_port);
-
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table))
 		return false;
 
 	/* push vlan on RX */
 	return (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) &&
-		((port_mask & port_value) == MLX5_VPORT_UPLINK);
+		mlx5_eswitch_offload_is_uplink_port(esw, spec);
 }
 
 struct mlx5_flow_handle *


