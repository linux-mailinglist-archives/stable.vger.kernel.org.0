Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F10469E1A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349677AbhLFPgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387690AbhLFPbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F165EB81116;
        Mon,  6 Dec 2021 15:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42551C34900;
        Mon,  6 Dec 2021 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804492;
        bh=NAoL8dwyJZZJdJXGbDEH+cSa1bKhp+s2OcEwtcIjrc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl7N0q9oyq++KeGCAxsy1HZkLBVPdSphpRCSqpqdP0THME10KVuzI0CpTajfbwWTO
         uDa+UPBgpyht/V2daeRhvqLE3DR2NNEP1sv0IpyvBQiyNmRmbT7WKRNMOr8ZXbc60+
         YXB958ttMasCni5QgTxgPZbXbSlkW61TFbNvFuI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/207] net/mlx5: E-Switch, fix single FDB creation on BlueField
Date:   Mon,  6 Dec 2021 15:56:59 +0100
Message-Id: <20211206145615.973066656@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 43a0696f11567278b9412f947e43dd7906c831a8 ]

Always use MLX5_FLOW_TABLE_OTHER_VPORT flag when creating egress ACL
table for single FDB. Not doing so on BlueField will make firmware fail
the command. On BlueField the E-Switch manager is the ECPF (vport 0xFFFE)
which is filled in the flow table creation command but as the
other_vport field wasn't set the firmware complains about a bad parameter.

This is different from a regular HCA where the E-Switch manager vport is
the PF (vport 0x0). Passing MLX5_FLOW_TABLE_OTHER_VPORT will make the
firmware happy both on BlueField and on regular HCAs without special
condition for each.

This fixes the bellow firmware syndrome:
mlx5_cmd_check:819:(pid 571): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x754a4)

Fixes: db202995f503 ("net/mlx5: E-Switch, add logic to enable shared FDB")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0c79e11339362..f3f23fdc20229 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2471,6 +2471,7 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	struct mlx5_eswitch *esw = master->priv.eswitch;
 	struct mlx5_flow_table_attr ft_attr = {
 		.max_fte = 1, .prio = 0, .level = 0,
+		.flags = MLX5_FLOW_TABLE_OTHER_VPORT,
 	};
 	struct mlx5_flow_namespace *egress_ns;
 	struct mlx5_flow_table *acl;
-- 
2.33.0



