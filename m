Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538EA3A02A4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhFHTHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237796AbhFHTF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D85360551;
        Tue,  8 Jun 2021 18:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177994;
        bh=oHSV8dmxRLkERP+TiS12WRIdu//D4Ezh38mYVGnTHjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnTpWz8UfiJIHzY9Hbe/asLQ/mha94L4YCKBZZ3GgC4Z3nT5rqBc7zIFdsP10Z0X8
         d3IGZJ01Mhd2be0Ec9onvhHxjPk7MPHGOW/GH/g9cabeuWB7yatTUX1lW+tXmHU42G
         Czwi8LtlZ0A72otPhBt4fkcrI75OeVYE0TsmYbJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 037/161] net/mlx5e: Fix adding encap rules to slow path
Date:   Tue,  8 Jun 2021 20:26:07 +0200
Message-Id: <20210608175946.721307435@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 2a2c84facd4af661d71be6e81fd9d490ac7fdc53 ]

On some devices the ignore flow level cap is not supported and we
shouldn't use it. Setting the dest ft with mlx5_chains_get_tc_end_ft()
already gives the correct end ft if ignore flow level cap is supported
or not.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h    | 5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d4a2f8d1ee9f..3719452a7803 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -349,7 +349,8 @@ esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
 			 struct mlx5_fs_chains *chains,
 			 int i)
 {
-	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	if (mlx5_chains_ignore_flow_level_supported(chains))
+		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 381325b4a863..b607ed5a74bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -111,7 +111,7 @@ bool mlx5_chains_prios_supported(struct mlx5_fs_chains *chains)
 	return chains->flags & MLX5_CHAINS_AND_PRIOS_SUPPORTED;
 }
 
-static bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
+bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
 {
 	return chains->flags & MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
index 6d5be31b05dd..9f53a0823558 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -27,6 +27,7 @@ struct mlx5_chains_attr {
 
 bool
 mlx5_chains_prios_supported(struct mlx5_fs_chains *chains);
+bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains);
 bool
 mlx5_chains_backwards_supported(struct mlx5_fs_chains *chains);
 u32
@@ -72,6 +73,10 @@ mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 
 #else /* CONFIG_MLX5_CLS_ACT */
 
+static inline bool
+mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
+{ return false; }
+
 static inline struct mlx5_flow_table *
 mlx5_chains_get_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
 		      u32 level) { return ERR_PTR(-EOPNOTSUPP); }
-- 
2.30.2



