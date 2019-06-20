Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E8A4D6E8
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfFTSNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbfFTSNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24FB42082C;
        Thu, 20 Jun 2019 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054423;
        bh=vIr80HR29qWxLL0xyYKr6SjhLuGEpzDl6iHkKi4/qWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJq5j9/bGZMFN5XRJclFX0PhErtV0ykFbtbbjv1WbKJYQplBblMGWV0l7lgjyOJhU
         OQGM1Mf230guYtez7ZIIBgDuQOuMjGBGNewR0LjHHi27jGI/Dd0KbQxQWX05lDETuQ
         P4PgGS/cTooMeVrFtiZBtEaNvAYfeg24VfEDPcC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Alex Veber <alexve@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 24/98] mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead
Date:   Thu, 20 Jun 2019 19:56:51 +0200
Message-Id: <20190620174350.275686168@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver tries to periodically refresh neighbours that are used to
reach nexthops. This is done by periodically calling neigh_event_send().

However, if the neighbour becomes dead, there is nothing we can do to
return it to a connected state and the above function call is basically
a NOP.

This results in the nexthop never being written to the device's
adjacency table and therefore never used to forward packets.

Fix this by dropping our reference from the dead neighbour and
associating the nexthop with a new neigbhour which we will try to
refresh.

Fixes: a7ff87acd995 ("mlxsw: spectrum_router: Implement next-hop routing")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |   73 +++++++++++++++++-
 1 file changed, 70 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2363,7 +2363,7 @@ static void mlxsw_sp_router_probe_unreso
 static void
 mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_neigh_entry *neigh_entry,
-			      bool removing);
+			      bool removing, bool dead);
 
 static enum mlxsw_reg_rauht_op mlxsw_sp_rauht_op(bool adding)
 {
@@ -2494,7 +2494,8 @@ static void mlxsw_sp_router_neigh_event_
 
 	memcpy(neigh_entry->ha, ha, ETH_ALEN);
 	mlxsw_sp_neigh_entry_update(mlxsw_sp, neigh_entry, entry_connected);
-	mlxsw_sp_nexthop_neigh_update(mlxsw_sp, neigh_entry, !entry_connected);
+	mlxsw_sp_nexthop_neigh_update(mlxsw_sp, neigh_entry, !entry_connected,
+				      dead);
 
 	if (!neigh_entry->connected && list_empty(&neigh_entry->nexthop_list))
 		mlxsw_sp_neigh_entry_destroy(mlxsw_sp, neigh_entry);
@@ -3458,13 +3459,79 @@ static void __mlxsw_sp_nexthop_neigh_upd
 	nh->update = 1;
 }
 
+static int
+mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_neigh_entry *neigh_entry)
+{
+	struct neighbour *n, *old_n = neigh_entry->key.n;
+	struct mlxsw_sp_nexthop *nh;
+	bool entry_connected;
+	u8 nud_state, dead;
+	int err;
+
+	nh = list_first_entry(&neigh_entry->nexthop_list,
+			      struct mlxsw_sp_nexthop, neigh_list_node);
+
+	n = neigh_lookup(nh->nh_grp->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	if (!n) {
+		n = neigh_create(nh->nh_grp->neigh_tbl, &nh->gw_addr,
+				 nh->rif->dev);
+		if (IS_ERR(n))
+			return PTR_ERR(n);
+		neigh_event_send(n, NULL);
+	}
+
+	mlxsw_sp_neigh_entry_remove(mlxsw_sp, neigh_entry);
+	neigh_entry->key.n = n;
+	err = mlxsw_sp_neigh_entry_insert(mlxsw_sp, neigh_entry);
+	if (err)
+		goto err_neigh_entry_insert;
+
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	dead = n->dead;
+	read_unlock_bh(&n->lock);
+	entry_connected = nud_state & NUD_VALID && !dead;
+
+	list_for_each_entry(nh, &neigh_entry->nexthop_list,
+			    neigh_list_node) {
+		neigh_release(old_n);
+		neigh_clone(n);
+		__mlxsw_sp_nexthop_neigh_update(nh, !entry_connected);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+	}
+
+	neigh_release(n);
+
+	return 0;
+
+err_neigh_entry_insert:
+	neigh_entry->key.n = old_n;
+	mlxsw_sp_neigh_entry_insert(mlxsw_sp, neigh_entry);
+	neigh_release(n);
+	return err;
+}
+
 static void
 mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_neigh_entry *neigh_entry,
-			      bool removing)
+			      bool removing, bool dead)
 {
 	struct mlxsw_sp_nexthop *nh;
 
+	if (list_empty(&neigh_entry->nexthop_list))
+		return;
+
+	if (dead) {
+		int err;
+
+		err = mlxsw_sp_nexthop_dead_neigh_replace(mlxsw_sp,
+							  neigh_entry);
+		if (err)
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to replace dead neigh\n");
+		return;
+	}
+
 	list_for_each_entry(nh, &neigh_entry->nexthop_list,
 			    neigh_list_node) {
 		__mlxsw_sp_nexthop_neigh_update(nh, removing);


