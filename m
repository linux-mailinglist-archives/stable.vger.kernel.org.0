Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC944A95FF
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357415AbiBDJV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357425AbiBDJV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8F3C061769;
        Fri,  4 Feb 2022 01:21:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D12AB836EE;
        Fri,  4 Feb 2022 09:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF58C004E1;
        Fri,  4 Feb 2022 09:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966484;
        bh=mXHryGW09fA1yrZtSbOXLAiQQeihs2gSPyR7qHrk/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFQDoHAXbqg5nA/XCAP1ntNS4tefvvXx1YvGSDPXCI7FAuI6AfqHY8FxwDQ5ao9tp
         U4zTUVOn6g2dV9UnEc3A9FAxTAoEay39iZp/wcvp0IQ6mTemFaRENt7U0PKl+GgzMi
         7k6r++oVI04Bpcp09/0ENNNjDqTZ9TE8fUMepa2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 14/25] net/mlx5e: Fix handling of wrong devices during bond netevent
Date:   Fri,  4 Feb 2022 10:20:21 +0100
Message-Id: <20220204091914.749913501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

commit ec41332e02bd0acf1f24206867bb6a02f5877a62 upstream.

Current implementation of bond netevent handler only check if
the handled netdev is VF representor and it missing a check if
the VF representor is on the same phys device of the bond handling
the netevent.

Fix by adding the missing check and optimizing the check if
the netdev is VF representor so it will not access uninitialized
private data and crashes.

BUG: kernel NULL pointer dereference, address: 000000000000036c
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
Workqueue: eth3bond0 bond_mii_monitor [bonding]
RIP: 0010:mlx5e_is_uplink_rep+0xc/0x50 [mlx5_core]
RSP: 0018:ffff88812d69fd60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881cf800000 RCX: 0000000000000000
RDX: ffff88812d69fe10 RSI: 000000000000001b RDI: ffff8881cf800880
RBP: ffff8881cf800000 R08: 00000445cabccf2b R09: 0000000000000008
R10: 0000000000000004 R11: 0000000000000008 R12: ffff88812d69fe10
R13: 00000000fffffffe R14: ffff88820c0f9000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88846fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000036c CR3: 0000000103d80006 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mlx5e_eswitch_uplink_rep+0x31/0x40 [mlx5_core]
 mlx5e_rep_is_lag_netdev+0x94/0xc0 [mlx5_core]
 mlx5e_rep_esw_bond_netevent+0xeb/0x3d0 [mlx5_core]
 raw_notifier_call_chain+0x41/0x60
 call_netdevice_notifiers_info+0x34/0x80
 netdev_lower_state_changed+0x4e/0xa0
 bond_mii_monitor+0x56b/0x640 [bonding]
 process_one_work+0x1b9/0x390
 worker_thread+0x4d/0x3d0
 ? rescuer_thread+0x350/0x350
 kthread+0x124/0x150
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c |   32 +++++++-----------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -183,18 +183,7 @@ void mlx5e_rep_bond_unslave(struct mlx5_
 
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
-	struct mlx5e_rep_priv *rpriv;
-	struct mlx5e_priv *priv;
-
-	/* A given netdev is not a representor or not a slave of LAG configuration */
-	if (!mlx5e_eswitch_rep(netdev) || !netif_is_lag_port(netdev))
-		return false;
-
-	priv = netdev_priv(netdev);
-	rpriv = priv->ppriv;
-
-	/* Egress acl forward to vport is supported only non-uplink representor */
-	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
+	return netif_is_lag_port(netdev) && mlx5e_eswitch_vf_rep(netdev);
 }
 
 static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *ptr)
@@ -210,9 +199,6 @@ static void mlx5e_rep_changelowerstate_e
 	u16 fwd_vport_num;
 	int err;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	info = ptr;
 	lag_info = info->lower_state_info;
 	/* This is not an event of a representor becoming active slave */
@@ -266,9 +252,6 @@ static void mlx5e_rep_changeupper_event(
 	struct net_device *lag_dev;
 	struct mlx5e_priv *priv;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 	lag_dev = info->upper_dev;
@@ -293,6 +276,19 @@ static int mlx5e_rep_esw_bond_netevent(s
 				       unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_rep_bond *bond;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5e_rep_is_lag_netdev(netdev))
+		return NOTIFY_DONE;
+
+	bond = container_of(nb, struct mlx5e_rep_bond, nb);
+	priv = netdev_priv(netdev);
+	rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch, REP_ETH);
+	/* Verify VF representor is on the same device of the bond handling the netevent. */
+	if (rpriv->uplink_priv.bond != bond)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_CHANGELOWERSTATE:


