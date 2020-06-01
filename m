Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EAA1EA9E1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgFASDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730028AbgFASDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56D152065C;
        Mon,  1 Jun 2020 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034581;
        bh=3Nr68T8HW4la5LkBwxoYAyudBWf4456xLBuCw3MAjhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp7Epl5g/TqBae70GIemK8qlL34O9Tyvl/dkmwK76GjgKCcMBx+v1igmT8woxsAxG
         wpxgJKGv2K89pvSHpfvOABM6/kyYToo3B2zyTWul+GGz8alnUYwlLKNNUc8ACfhh1L
         5zZ3+0c6k6KhIadqskxXxY20hGj5lD86AycnDCeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 18/95] mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails
Date:   Mon,  1 Jun 2020 19:53:18 +0200
Message-Id: <20200601174023.776647419@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

commit 4340f42f207eacb81e7a6b6bb1e3b6afad9a2e26 upstream.

In case of reload fail, the mlxsw_sp->ports contains a pointer to a
freed memory (either by reload_down() or reload_up() error path).
Fix this by initializing the pointer to NULL and checking it before
dereferencing in split/unsplit/type_set callpaths.

Fixes: 24cc68ad6c46 ("mlxsw: core: Add support for reload")
Reported-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |   14 ++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |    8 ++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3126,6 +3126,7 @@ static void mlxsw_sp_ports_remove(struct
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	kfree(mlxsw_sp->port_to_module);
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 }
 
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
@@ -3174,6 +3175,7 @@ err_port_module_info_get:
 	kfree(mlxsw_sp->port_to_module);
 err_port_to_module_alloc:
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 	return err;
 }
 
@@ -3228,6 +3230,14 @@ static void mlxsw_sp_port_unsplit_create
 	}
 }
 
+static struct mlxsw_sp_port *
+mlxsw_sp_port_get_by_local_port(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+{
+	if (mlxsw_sp->ports && mlxsw_sp->ports[local_port])
+		return mlxsw_sp->ports[local_port];
+	return NULL;
+}
+
 static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 			       unsigned int count,
 			       struct netlink_ext_ack *extack)
@@ -3238,7 +3248,7 @@ static int mlxsw_sp_port_split(struct ml
 	int i;
 	int err;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
@@ -3305,7 +3315,7 @@ static int mlxsw_sp_port_unsplit(struct
 	unsigned int count;
 	int i;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1289,6 +1289,7 @@ static void mlxsw_sx_ports_remove(struct
 		if (mlxsw_sx_port_created(mlxsw_sx, i))
 			mlxsw_sx_port_remove(mlxsw_sx, i);
 	kfree(mlxsw_sx->ports);
+	mlxsw_sx->ports = NULL;
 }
 
 static int mlxsw_sx_ports_create(struct mlxsw_sx *mlxsw_sx)
@@ -1323,6 +1324,7 @@ err_port_module_info_get:
 		if (mlxsw_sx_port_created(mlxsw_sx, i))
 			mlxsw_sx_port_remove(mlxsw_sx, i);
 	kfree(mlxsw_sx->ports);
+	mlxsw_sx->ports = NULL;
 	return err;
 }
 
@@ -1406,6 +1408,12 @@ static int mlxsw_sx_port_type_set(struct
 	u8 module, width;
 	int err;
 
+	if (!mlxsw_sx->ports || !mlxsw_sx->ports[local_port]) {
+		dev_err(mlxsw_sx->bus_info->dev, "Port number \"%d\" does not exist\n",
+			local_port);
+		return -EINVAL;
+	}
+
 	if (new_type == DEVLINK_PORT_TYPE_AUTO)
 		return -EOPNOTSUPP;
 


