Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB1A6432C3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiLET3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiLET2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B402A262
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A261BB81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A5CC433D6;
        Mon,  5 Dec 2022 19:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268331;
        bh=KgIiskFW0UiEFjqvLDBgpyaj4+EWB/vc5SgcpRVUhjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYj3u6doe3I0nyX+WEH4i53FJp99tOzlBJ3xlrkJ4hlTdmbUCbUefERPUdLUHZ6dv
         Ih5BkmLmwCSjApUp0uTVysGElkXADyDOd/+1Gm4EudIZ0iu941PPgcsODqwCpMaNra
         hPbTbOCS0lQriUV3TL2UUYDq9GXrqnChvOxx3jPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/124] net/mlx5: E-switch, Destroy legacy fdb table when needed
Date:   Mon,  5 Dec 2022 20:09:01 +0100
Message-Id: <20221205190809.444204366@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

[ Upstream commit 2318b8bb94a3a21363cd0d49cad5934bd1e2d60e ]

The cited commit removes eswitch mode none. But when disabling
sriov in legacy mode or changing from switchdev to legacy mode
without sriov enabled, the legacy fdb table is not destroyed.

It is not the right behavior. Destroy legacy fdb table in above
two caes.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 4d8b8f6143cc..59cffa49e4b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1363,6 +1363,9 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 		esw_offloads_del_send_to_vport_meta_rules(esw);
 		devl_rate_nodes_destroy(devlink);
 	}
+	/* Destroy legacy fdb when disabling sriov in legacy mode. */
+	if (esw->mode == MLX5_ESWITCH_LEGACY)
+		mlx5_eswitch_disable_locked(esw);
 
 	esw->esw_funcs.num_vfs = 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 061ac8799354..11cb7d28e1f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3270,6 +3270,13 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 	int err;
 
 	esw->mode = MLX5_ESWITCH_LEGACY;
+
+	/* If changing from switchdev to legacy mode without sriov enabled,
+	 * no need to create legacy fdb.
+	 */
+	if (!mlx5_sriov_is_enabled(esw->dev))
+		return 0;
+
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-- 
2.35.1



