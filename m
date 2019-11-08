Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB83F556E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390501AbfKHTCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733166AbfKHTCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F62621D7E;
        Fri,  8 Nov 2019 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239743;
        bh=hkUr9mVII/pWMUyNQSBGENs7BmcYT7x/GDuTB7r/VGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnJArXjwpJuax39BwJ5n80pTWEqhB2xVOJXiJQw/yxq6xilonohd0jlM9STK9Dss6
         KKqXb1mGdja9TZZ+RQzRzrV+Q72Tcup4JZP97F9WBchYCee9L81/CI+UTIdLTVaLIh
         Lej6NwNiexti387+Gmu9I2cPjODDLIRUSxd2Zxuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 47/79] net/mlx4_core: Dynamically set guaranteed amount of counters per VF
Date:   Fri,  8 Nov 2019 19:50:27 +0100
Message-Id: <20191108174812.729362991@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit e19868efea0c103f23b4b7e986fd0a703822111f ]

Prior to this patch, the amount of counters guaranteed per VF in the
resource tracker was MLX4_VF_COUNTERS_PER_PORT * MLX4_MAX_PORTS. It was
set regardless if the VF was single or dual port.
This caused several VFs to have no guaranteed counters although the
system could satisfy their request.

The fix is to dynamically guarantee counters, based on each VF
specification.

Fixes: 9de92c60beaa ("net/mlx4_core: Adjust counter grant policy in the resource tracker")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |   42 +++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -471,12 +471,31 @@ void mlx4_init_quotas(struct mlx4_dev *d
 		priv->mfunc.master.res_tracker.res_alloc[RES_MPT].quota[pf];
 }
 
-static int get_max_gauranteed_vfs_counter(struct mlx4_dev *dev)
+static int
+mlx4_calc_res_counter_guaranteed(struct mlx4_dev *dev,
+				 struct resource_allocator *res_alloc,
+				 int vf)
 {
-	/* reduce the sink counter */
-	return (dev->caps.max_counters - 1 -
-		(MLX4_PF_COUNTERS_PER_PORT * MLX4_MAX_PORTS))
-		/ MLX4_MAX_PORTS;
+	struct mlx4_active_ports actv_ports;
+	int ports, counters_guaranteed;
+
+	/* For master, only allocate according to the number of phys ports */
+	if (vf == mlx4_master_func_num(dev))
+		return MLX4_PF_COUNTERS_PER_PORT * dev->caps.num_ports;
+
+	/* calculate real number of ports for the VF */
+	actv_ports = mlx4_get_active_ports(dev, vf);
+	ports = bitmap_weight(actv_ports.ports, dev->caps.num_ports);
+	counters_guaranteed = ports * MLX4_VF_COUNTERS_PER_PORT;
+
+	/* If we do not have enough counters for this VF, do not
+	 * allocate any for it. '-1' to reduce the sink counter.
+	 */
+	if ((res_alloc->res_reserved + counters_guaranteed) >
+	    (dev->caps.max_counters - 1))
+		return 0;
+
+	return counters_guaranteed;
 }
 
 int mlx4_init_resource_tracker(struct mlx4_dev *dev)
@@ -484,7 +503,6 @@ int mlx4_init_resource_tracker(struct ml
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i, j;
 	int t;
-	int max_vfs_guarantee_counter = get_max_gauranteed_vfs_counter(dev);
 
 	priv->mfunc.master.res_tracker.slave_list =
 		kcalloc(dev->num_slaves, sizeof(struct slave_list),
@@ -603,16 +621,8 @@ int mlx4_init_resource_tracker(struct ml
 				break;
 			case RES_COUNTER:
 				res_alloc->quota[t] = dev->caps.max_counters;
-				if (t == mlx4_master_func_num(dev))
-					res_alloc->guaranteed[t] =
-						MLX4_PF_COUNTERS_PER_PORT *
-						MLX4_MAX_PORTS;
-				else if (t <= max_vfs_guarantee_counter)
-					res_alloc->guaranteed[t] =
-						MLX4_VF_COUNTERS_PER_PORT *
-						MLX4_MAX_PORTS;
-				else
-					res_alloc->guaranteed[t] = 0;
+				res_alloc->guaranteed[t] =
+					mlx4_calc_res_counter_guaranteed(dev, res_alloc, t);
 				break;
 			default:
 				break;


