Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B82396294
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEaO6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhEaOzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7FB961CBC;
        Mon, 31 May 2021 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469601;
        bh=aCnRtdLTHE7mvfjNQ/ufORA4asijPcucrG2cyfn+lPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GC+ThZN+7PE071qsEp5ReoBr++zj4B7Ec7ZxYqYkld+4PS5icInk0BNphDETyqpY7
         U71RmLO+LoPSF8TqWe7pSl+oA25/Gw0rnw0uLTEZRScNwchz+Db0haz9Tyt+3fZZ5Y
         03oKErEd39IlJS5ifkSNeWjuCLxilrppaOV6lxwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 261/296] net/mlx5: SF, Fix show state inactive when its inactivated
Date:   Mon, 31 May 2021 15:15:16 +0200
Message-Id: <20210531130712.527844382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 82041634d96e87b41c600a673f10150d9f21f742 ]

When a SF is inactivated and when it is in a TEARDOWN_REQUEST
state, driver still returns its state as active. This is incorrect.
Fix it by treating TEARDOWN_REQEUST as inactive state. When a SF
is still attached to the driver, on user request to reactivate EINVAL
error is returned. Inform user about it with better code EBUSY and
informative error message.

Fixes: 6a3273217469 ("net/mlx5: SF, Port function state change support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c   | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index c2ba41bb7a70..96c4509e5838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -128,10 +128,10 @@ static enum devlink_port_fn_state mlx5_sf_to_devlink_state(u8 hw_state)
 	switch (hw_state) {
 	case MLX5_VHCA_STATE_ACTIVE:
 	case MLX5_VHCA_STATE_IN_USE:
-	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
 		return DEVLINK_PORT_FN_STATE_ACTIVE;
 	case MLX5_VHCA_STATE_INVALID:
 	case MLX5_VHCA_STATE_ALLOCATED:
+	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
 	default:
 		return DEVLINK_PORT_FN_STATE_INACTIVE;
 	}
@@ -184,14 +184,17 @@ sf_err:
 	return err;
 }
 
-static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
+static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf,
+			    struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (mlx5_sf_is_active(sf))
 		return 0;
-	if (sf->hw_state != MLX5_VHCA_STATE_ALLOCATED)
-		return -EINVAL;
+	if (sf->hw_state != MLX5_VHCA_STATE_ALLOCATED) {
+		NL_SET_ERR_MSG_MOD(extack, "SF is inactivated but it is still attached");
+		return -EBUSY;
+	}
 
 	err = mlx5_cmd_sf_enable_hca(dev, sf->hw_fn_id);
 	if (err)
@@ -218,7 +221,8 @@ static int mlx5_sf_deactivate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
 
 static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 			     struct mlx5_sf *sf,
-			     enum devlink_port_fn_state state)
+			     enum devlink_port_fn_state state,
+			     struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -226,7 +230,7 @@ static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *ta
 	if (state == mlx5_sf_to_devlink_state(sf->hw_state))
 		goto out;
 	if (state == DEVLINK_PORT_FN_STATE_ACTIVE)
-		err = mlx5_sf_activate(dev, sf);
+		err = mlx5_sf_activate(dev, sf, extack);
 	else if (state == DEVLINK_PORT_FN_STATE_INACTIVE)
 		err = mlx5_sf_deactivate(dev, sf);
 	else
@@ -257,7 +261,7 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_po
 		goto out;
 	}
 
-	err = mlx5_sf_state_set(dev, table, sf, state);
+	err = mlx5_sf_state_set(dev, table, sf, state, extack);
 out:
 	mlx5_sf_table_put(table);
 	return err;
-- 
2.30.2



