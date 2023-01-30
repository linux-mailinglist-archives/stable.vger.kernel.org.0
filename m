Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F81768102F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjA3OBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbjA3OBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7313238E82
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0661D61049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622A8C433D2;
        Mon, 30 Jan 2023 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087223;
        bh=ClwabCaJRBJ5oOrcHjDDD6ggp9Vy0snJSewr0mS3DLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjXObooT9zOHACQ53Rwg7RDD0vW+yrHG3QoE0Y5XaM/3tgZN6BUa0sZ+phO/o1lFp
         ia1hOiwmQjhbh4UobwuldMGgxXCgpICFYrjgJ1U53OSnJAxQnzTsvEu3rkT7vqh0jn
         +pwfe1BG8/abAd9783RgFqrzPutPRpTSOYcethLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Dickman <maord@nvidia.com>,
        Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/313] net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT
Date:   Mon, 30 Jan 2023 14:49:03 +0100
Message-Id: <20230130134341.684372122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 4ddf77f9bc76092d268bd3af447d60d9cc62b652 ]

According to HW spec parent_element_id field should be reserved (0x0) when calling
MODIFY_SCHEDULING_ELEMENT command.

This patch remove the wrong initialization of reserved field, parent_element_id, on
mlx5_qos_update_node.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/qos.c    | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/qos.h    | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c b/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
index 6dac76fa58a3..09d441ecb9f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
@@ -637,7 +637,7 @@ mlx5e_htb_update_children(struct mlx5e_htb *htb, struct mlx5e_qos_node *node,
 		if (child->bw_share == old_bw_share)
 			continue;
 
-		err_one = mlx5_qos_update_node(htb->mdev, child->hw_id, child->bw_share,
+		err_one = mlx5_qos_update_node(htb->mdev, child->bw_share,
 					       child->max_average_bw, child->hw_id);
 		if (!err && err_one) {
 			err = err_one;
@@ -671,7 +671,7 @@ mlx5e_htb_node_modify(struct mlx5e_htb *htb, u16 classid, u64 rate, u64 ceil,
 	mlx5e_htb_convert_rate(htb, rate, node->parent, &bw_share);
 	mlx5e_htb_convert_ceil(htb, ceil, &max_average_bw);
 
-	err = mlx5_qos_update_node(htb->mdev, node->parent->hw_id, bw_share,
+	err = mlx5_qos_update_node(htb->mdev, bw_share,
 				   max_average_bw, node->hw_id);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Firmware error when modifying a node.");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
index 0777be24a307..8bce730b5c5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
@@ -62,13 +62,12 @@ int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id)
 	return mlx5_qos_create_inner_node(mdev, MLX5_QOS_DEFAULT_DWRR_UID, 0, 0, id);
 }
 
-int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id,
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev,
 			 u32 bw_share, u32 max_avg_bw, u32 id)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
 	u32 bitmask = 0;
 
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
 	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
 	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_avg_bw);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
index 125e4e47e6f7..624ce822b7f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
@@ -23,7 +23,7 @@ int mlx5_qos_create_leaf_node(struct mlx5_core_dev *mdev, u32 parent_id,
 int mlx5_qos_create_inner_node(struct mlx5_core_dev *mdev, u32 parent_id,
 			       u32 bw_share, u32 max_avg_bw, u32 *id);
 int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id);
-int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id, u32 bw_share,
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 bw_share,
 			 u32 max_avg_bw, u32 id);
 int mlx5_qos_destroy_node(struct mlx5_core_dev *mdev, u32 id);
 
-- 
2.39.0



