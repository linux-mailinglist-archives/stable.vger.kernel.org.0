Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB7EEFEE
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfKDWYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:24:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfKDVwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:33 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB4AE217F4;
        Mon,  4 Nov 2019 21:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904353;
        bh=a4hWbx/OJTFq6/zncSC4Cw+aLZpikdZTGHzDZjdvTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV0XzJGWV5tl+UVi6+VzksyEN2/fedzVvHrGIcQ3lK7bkcdYk+u/0HMlJIHBGHAK1
         nGISLiMJ6Sa3XhbpHP384G1Jxt1Mb7lJXopECReD9mXA2QaSqoU0Iz67Q/uj48vF59
         ivAyWgVpQLACo3VW9emw6zI4R9az/X2IhDj4Yf2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nir Dotan <nird@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/95] mlxsw: spectrum: Set LAG port collector only when active
Date:   Mon,  4 Nov 2019 22:44:16 +0100
Message-Id: <20191104212046.988526116@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nir Dotan <nird@mellanox.com>

[ Upstream commit 48ebab31d424fbdb8ede8914923bec671a933246 ]

The LAG port collecting (receive) function was mistakenly set when the
port was registered as a LAG member, while it should be set only when
the port collection state is set to true. Set LAG port to collecting
when it is set to distributing, as described in the IEEE link
aggregation standard coupled control mux machine state diagram.

Signed-off-by: Nir Dotan <nird@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 62 ++++++++++++++-----
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5c74787f903b7..a909aa315a92a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4077,9 +4077,6 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	err = mlxsw_sp_lag_col_port_add(mlxsw_sp_port, lag_id, port_index);
 	if (err)
 		goto err_col_port_add;
-	err = mlxsw_sp_lag_col_port_enable(mlxsw_sp_port, lag_id);
-	if (err)
-		goto err_col_port_enable;
 
 	mlxsw_core_lag_mapping_set(mlxsw_sp->core, lag_id, port_index,
 				   mlxsw_sp_port->local_port);
@@ -4094,8 +4091,6 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	return 0;
 
-err_col_port_enable:
-	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
@@ -4114,7 +4109,6 @@ static void mlxsw_sp_port_lag_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 	lag = mlxsw_sp_lag_get(mlxsw_sp, lag_id);
 	WARN_ON(lag->ref_count == 0);
 
-	mlxsw_sp_lag_col_port_disable(mlxsw_sp_port, lag_id);
 	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 
 	/* Any VLANs configured on the port are no longer valid */
@@ -4159,21 +4153,56 @@ static int mlxsw_sp_lag_dist_port_remove(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sldr), sldr_pl);
 }
 
-static int mlxsw_sp_port_lag_tx_en_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				       bool lag_tx_enabled)
+static int
+mlxsw_sp_port_lag_col_dist_enable(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	if (lag_tx_enabled)
-		return mlxsw_sp_lag_dist_port_add(mlxsw_sp_port,
-						  mlxsw_sp_port->lag_id);
-	else
-		return mlxsw_sp_lag_dist_port_remove(mlxsw_sp_port,
-						     mlxsw_sp_port->lag_id);
+	int err;
+
+	err = mlxsw_sp_lag_col_port_enable(mlxsw_sp_port,
+					   mlxsw_sp_port->lag_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_lag_dist_port_add(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	if (err)
+		goto err_dist_port_add;
+
+	return 0;
+
+err_dist_port_add:
+	mlxsw_sp_lag_col_port_disable(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	return err;
+}
+
+static int
+mlxsw_sp_port_lag_col_dist_disable(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	int err;
+
+	err = mlxsw_sp_lag_dist_port_remove(mlxsw_sp_port,
+					    mlxsw_sp_port->lag_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_lag_col_port_disable(mlxsw_sp_port,
+					    mlxsw_sp_port->lag_id);
+	if (err)
+		goto err_col_port_disable;
+
+	return 0;
+
+err_col_port_disable:
+	mlxsw_sp_lag_dist_port_add(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	return err;
 }
 
 static int mlxsw_sp_port_lag_changed(struct mlxsw_sp_port *mlxsw_sp_port,
 				     struct netdev_lag_lower_state_info *info)
 {
-	return mlxsw_sp_port_lag_tx_en_set(mlxsw_sp_port, info->tx_enabled);
+	if (info->tx_enabled)
+		return mlxsw_sp_port_lag_col_dist_enable(mlxsw_sp_port);
+	else
+		return mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 }
 
 static int mlxsw_sp_port_stp_set(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -4309,8 +4338,7 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 				err = mlxsw_sp_port_lag_join(mlxsw_sp_port,
 							     upper_dev);
 			} else {
-				mlxsw_sp_port_lag_tx_en_set(mlxsw_sp_port,
-							    false);
+				mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 				mlxsw_sp_port_lag_leave(mlxsw_sp_port,
 							upper_dev);
 			}
-- 
2.20.1



