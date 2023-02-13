Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8169497F
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjBMO7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjBMO7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927AD1D917
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0315961166
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E342C433D2;
        Mon, 13 Feb 2023 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300331;
        bh=PdM+V68yQHdWToKcief3q038+CVjfW4U1Odeqg3IjSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsDwP+sxnRyBgD565/NUIb0BGXd/IWO1KrTaacWEvksOZLqMsgiEp3eC2/S3A9WZg
         8KqoY5q7+C9aw1878wOFeX4OtgQrWFUiB2bv39R3uQT2GfkIXMwtbgNjfdujFIyfX9
         E/JaJNGyQpyflHR/Wlv1B0qBeGBbPHgiMgSmBZTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/67] net/mlx5: Bridge, fix ageing of peer FDB entries
Date:   Mon, 13 Feb 2023 15:49:14 +0100
Message-Id: <20230213144733.943538696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit da0c52426cd23f8728eff72c2b2d2a3eb6b451f5 ]

SWITCHDEV_FDB_ADD_TO_BRIDGE event handler that updates FDB entry 'lastuse'
field is only executed for eswitch that owns the entry. However, if peer
entry processed packets at least once it will have hardware counter 'used'
value greater than entry 'lastuse' from that point on, which will cause FDB
entry not being aged out.

Process the event on all eswitch instances.

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 4 ----
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c    | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 8e7177d4539e3..291bd59639044 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -432,10 +432,6 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
-		/* only handle the event on native eswtich of representor */
-		if (!mlx5_esw_bridge_is_local(dev, rep, esw))
-			break;
-
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 317d76b97c42a..aec0f67cef005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1270,7 +1270,7 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 	struct mlx5_esw_bridge *bridge;
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port || port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER)
+	if (!port)
 		return;
 
 	bridge = port->bridge;
-- 
2.39.0



