Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5975E628044
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiKNNEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbiKNNEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F29029CB0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A8F0CE0FE6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACEFC433D6;
        Mon, 14 Nov 2022 13:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431065;
        bh=fYu4XR467Z+sDtBx4UHlNJipjKUSNzSPTl7z0zRJFLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZbkSqCJdjUSf0PZLhU5R6sSKYaWl5J6mfqPYMgKcnzG735CH5RzJF/koiG2CuJT/
         LR+H1GwMjWwPCJ3Ykq7lWQ6EvKI5c1pSXyp0wEvYMeNzGNhneL8zbNlvhXtbN4W403
         OchkJ7erYpkayJRFusUFvm8WElzZU9F8Yp/mzuUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 088/190] net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode
Date:   Mon, 14 Nov 2022 13:45:12 +0100
Message-Id: <20221114124502.532772929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit e12de39c07a7872c1ac7250311bb60b74ff29f25 ]

No need to rollback to the other mode because probably will fail
again. Just set to legacy mode and clear fdb table created flag.
So that fdb table will not be cleared again.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++++++++------
 .../mellanox/mlx5/core/eswitch_offloads.c      | 18 +++---------------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6aa58044b949..4d8b8f6143cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1388,12 +1388,14 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
-	esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
-	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
-		esw_offloads_disable(esw);
-	else if (esw->mode == MLX5_ESWITCH_LEGACY)
-		esw_legacy_disable(esw);
-	mlx5_esw_acls_ns_cleanup(esw);
+	if (esw->fdb_table.flags & MLX5_ESW_FDB_CREATED) {
+		esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
+		if (esw->mode == MLX5_ESWITCH_OFFLOADS)
+			esw_offloads_disable(esw);
+		else if (esw->mode == MLX5_ESWITCH_LEGACY)
+			esw_legacy_disable(esw);
+		mlx5_esw_acls_ns_cleanup(esw);
+	}
 
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		devl_rate_nodes_destroy(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a9f4c652f859..3c68cac4a9c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2207,7 +2207,7 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
-	int err, err1;
+	int err;
 
 	esw->mode = MLX5_ESWITCH_OFFLOADS;
 	err = mlx5_eswitch_enable_locked(esw, esw->dev->priv.sriov.num_vfs);
@@ -2215,11 +2215,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed setting eswitch to offloads");
 		esw->mode = MLX5_ESWITCH_LEGACY;
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-		if (err1) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed setting eswitch back to legacy");
-		}
 		mlx5_rescan_drivers(esw->dev);
 	}
 	if (esw->offloads.inline_mode == MLX5_INLINE_MODE_NONE) {
@@ -3272,19 +3267,12 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 static int esw_offloads_stop(struct mlx5_eswitch *esw,
 			     struct netlink_ext_ack *extack)
 {
-	int err, err1;
+	int err;
 
 	esw->mode = MLX5_ESWITCH_LEGACY;
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-	if (err) {
+	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-		esw->mode = MLX5_ESWITCH_OFFLOADS;
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-		if (err1) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed setting eswitch back to offloads");
-		}
-	}
 
 	return err;
 }
-- 
2.35.1



