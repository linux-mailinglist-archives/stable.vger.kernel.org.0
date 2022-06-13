Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE95496CA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiFMM6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350467AbiFMMzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE11AE0D5;
        Mon, 13 Jun 2022 04:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F642B80E93;
        Mon, 13 Jun 2022 11:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD841C3411E;
        Mon, 13 Jun 2022 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118970;
        bh=Prk2zBgoi6w0/KeP+0XEbwFJnQCWyB0S9t8UKxEmbXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP6JG32q3O3r9UEi2ZoFsQLrDVbLbjI1G5wPrFOpD4yPDPh7BDVA6nWL9l75q//fz
         3B9/kmu8DJMxDs6iUPej94AvcnXcVG4uft/hT/V1DaRoAIutf+sSA2vv+YhJpDg7b6
         ClkDpHDEJ77pyHXZmx+WFsiVCNhstPVXQ5QcIM9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/247] net/mlx5e: TC NIC mode, fix tc chains miss table
Date:   Mon, 13 Jun 2022 12:09:56 +0200
Message-Id: <20220613094925.808489736@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 66cb64e292d21588bdb831f08a7ec0ff04d6380d ]

The cited commit changed promisc table to be created on demand with the
highest priority in the NIC table replacing the vlan table, this caused
tc NIC tables miss flow to skip the prmoisc table because it use vlan
table as miss table.

OVS offload in NIC mode use promisc by default so any unicast packet
which will be handled by tc NIC tables miss flow will skip the promisc
rule and will be dropped.

Fix this by adding new empty table in new tc level with low priority and
point the nic tc chain miss to it, the new table is managed so it will
point to vlan table if promisc is disabled and to promisc table if enabled.

Fixes: 1c46d7409f30 ("net/mlx5e: Optimize promiscuous mode")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 38 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index a88a1a48229f..d634c034a419 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -12,6 +12,7 @@ struct mlx5e_post_act;
 enum {
 	MLX5E_TC_FT_LEVEL = 0,
 	MLX5E_TC_TTC_FT_LEVEL,
+	MLX5E_TC_MISS_LEVEL,
 };
 
 struct mlx5e_tc_table {
@@ -20,6 +21,7 @@ struct mlx5e_tc_table {
 	 */
 	struct mutex			t_lock;
 	struct mlx5_flow_table		*t;
+	struct mlx5_flow_table		*miss_t;
 	struct mlx5_fs_chains           *chains;
 	struct mlx5e_post_act		*post_act;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 60a4ac0ca76d..3aa8d0b83d10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4993,6 +4993,33 @@ static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
 	return tc_tbl_size;
 }
 
+static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_table **ft = &priv->fs.tc.miss_t;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	int err = 0;
+
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_TC_MISS_LEVEL;
+	ft_attr.prio = 0;
+	ns = mlx5_get_flow_namespace(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL);
+
+	*ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(*ft)) {
+		err = PTR_ERR(*ft);
+		netdev_err(priv->netdev, "failed to create tc nic miss table err=%d\n", err);
+	}
+
+	return err;
+}
+
+static void mlx5e_tc_nic_destroy_miss_table(struct mlx5e_priv *priv)
+{
+	mlx5_destroy_flow_table(priv->fs.tc.miss_t);
+}
+
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
@@ -5025,19 +5052,23 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	}
 	tc->mapping = chains_mapping;
 
+	err = mlx5e_tc_nic_create_miss_table(priv);
+	if (err)
+		goto err_chains;
+
 	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level))
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
+	attr.default_ft = priv->fs.tc.miss_t;
 	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
 		err = PTR_ERR(tc->chains);
-		goto err_chains;
+		goto err_miss;
 	}
 
 	tc->post_act = mlx5e_tc_post_act_init(priv, tc->chains, MLX5_FLOW_NAMESPACE_KERNEL);
@@ -5060,6 +5091,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mlx5_tc_ct_clean(tc->ct);
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mlx5_chains_destroy(tc->chains);
+err_miss:
+	mlx5e_tc_nic_destroy_miss_table(priv);
 err_chains:
 	mapping_destroy(chains_mapping);
 err_mapping:
@@ -5100,6 +5133,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mapping_destroy(tc->mapping);
 	mlx5_chains_destroy(tc->chains);
+	mlx5e_tc_nic_destroy_miss_table(priv);
 }
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a197dd7ca73b..379130ed300c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -113,7 +113,7 @@
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
 
 #define KERNEL_NIC_TC_NUM_PRIOS  1
-#define KERNEL_NIC_TC_NUM_LEVELS 2
+#define KERNEL_NIC_TC_NUM_LEVELS 3
 
 #define ANCHOR_NUM_LEVELS 1
 #define ANCHOR_NUM_PRIOS 1
-- 
2.35.1



