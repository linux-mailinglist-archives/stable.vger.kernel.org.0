Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB04549DCB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiFMTep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346583AbiFMTcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D73760061
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5BF06113D
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 17:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0665AC34114;
        Mon, 13 Jun 2022 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655143129;
        bh=rjz/2JO4DICC/0tHX42OhmuF7pszdTXZQYCh/13U2Zo=;
        h=Subject:To:Cc:From:Date:From;
        b=akfHRyHOXjU1THPIEmwTtIEBD196yW4vquoRcExEGstQblFdxn13mvFpku5ZhsDnj
         BQJRbCuHAAAHxXWbhwh1krLb7mrFn8vT9aLOZwgkMZqKEp6a8V+L5zSF0dbgFXV3uK
         n6O78NC3xXndUkyrnXR4IQJHz8HipEYejYYWH8E8=
Subject: FAILED: patch "[PATCH] net/mlx5: E-Switch, pair only capable devices" failed to apply to 5.15-stable tree
To:     mbloch@nvidia.com, moshe@nvidia.com, roid@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 19:58:47 +0200
Message-ID: <16551431273107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3008e6a0049361e731b803c60fe8f3ab44e1d73f Mon Sep 17 00:00:00 2001
From: Mark Bloch <mbloch@nvidia.com>
Date: Thu, 26 May 2022 08:15:28 +0300
Subject: [PATCH] net/mlx5: E-Switch, pair only capable devices

OFFLOADS paring using devcom is possible only on devices
that support LAG. Filter based on lag capabilities.

This fixes an issue where mlx5_get_next_phys_dev() was
called without holding the interface lock.

This issue was found when commit
bc4c2f2e0179 ("net/mlx5: Lag, filter non compatible devices")
added an assert that verifies the interface lock is held.

WARNING: CPU: 9 PID: 1706 at drivers/net/ethernet/mellanox/mlx5/core/dev.c:642 mlx5_get_next_phys_dev+0xd2/0x100 [mlx5_core]
Modules linked in: mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_umad ib_ipoib ib_cm ib_uverbs ib_core overlay fuse [last unloaded: mlx5_core]
CPU: 9 PID: 1706 Comm: devlink Not tainted 5.18.0-rc7+ #11
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:mlx5_get_next_phys_dev+0xd2/0x100 [mlx5_core]
Code: 02 00 75 48 48 8b 85 80 04 00 00 5d c3 31 c0 5d c3 be ff ff ff ff 48 c7 c7 08 41 5b a0 e8 36 87 28 e3 85 c0 0f 85 6f ff ff ff <0f> 0b e9 68 ff ff ff 48 c7 c7 0c 91 cc 84 e8 cb 36 6f e1 e9 4d ff
RSP: 0018:ffff88811bf47458 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811b398000 RCX: 0000000000000001
RDX: 0000000080000000 RSI: ffffffffa05b4108 RDI: ffff88812daaaa78
RBP: ffff88812d050380 R08: 0000000000000001 R09: ffff88811d6b3437
R10: 0000000000000001 R11: 00000000fddd3581 R12: ffff88815238c000
R13: ffff88812d050380 R14: ffff8881018aa7e0 R15: ffff88811d6b3428
FS:  00007fc82e18ae80(0000) GS:ffff88842e080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9630d1b421 CR3: 0000000149802004 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mlx5_esw_offloads_devcom_event+0x99/0x3b0 [mlx5_core]
 mlx5_devcom_send_event+0x167/0x1d0 [mlx5_core]
 esw_offloads_enable+0x1153/0x1500 [mlx5_core]
 ? mlx5_esw_offloads_controller_valid+0x170/0x170 [mlx5_core]
 ? wait_for_completion_io_timeout+0x20/0x20
 ? mlx5_rescan_drivers_locked+0x318/0x810 [mlx5_core]
 mlx5_eswitch_enable_locked+0x586/0xc50 [mlx5_core]
 ? mlx5_eswitch_disable_pf_vf_vports+0x1d0/0x1d0 [mlx5_core]
 ? mlx5_esw_try_lock+0x1b/0xb0 [mlx5_core]
 ? mlx5_eswitch_enable+0x270/0x270 [mlx5_core]
 ? __debugfs_create_file+0x260/0x3e0
 mlx5_devlink_eswitch_mode_set+0x27e/0x870 [mlx5_core]
 ? mutex_lock_io_nested+0x12c0/0x12c0
 ? esw_offloads_disable+0x250/0x250 [mlx5_core]
 ? devlink_nl_cmd_trap_get_dumpit+0x470/0x470
 ? rcu_read_lock_sched_held+0x3f/0x70
 devlink_nl_cmd_eswitch_set_doit+0x217/0x620

Fixes: dd3fddb82780 ("net/mlx5: E-Switch, handle devcom events only for ports on the same device")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 0eb9d74547f8..50422b56a64d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -579,17 +579,6 @@ static void *pci_get_other_drvdata(struct device *this, struct device *other)
 	return pci_get_drvdata(to_pci_dev(other));
 }
 
-static int next_phys_dev(struct device *dev, const void *data)
-{
-	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
-
-	mdev = pci_get_other_drvdata(this->device, dev);
-	if (!mdev)
-		return 0;
-
-	return _next_phys_dev(mdev, data);
-}
-
 static int next_phys_dev_lag(struct device *dev, const void *data)
 {
 	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
@@ -623,13 +612,6 @@ static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
 	return pci_get_drvdata(to_pci_dev(next));
 }
 
-/* Must be called with intf_mutex held */
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
-{
-	lockdep_assert_held(&mlx5_intf_mutex);
-	return mlx5_get_next_dev(dev, &next_phys_dev);
-}
-
 /* Must be called with intf_mutex held */
 struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 217cac29057f..2ce3728576d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2690,9 +2690,6 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 	switch (event) {
 	case ESW_OFFLOADS_DEVCOM_PAIR:
-		if (mlx5_get_next_phys_dev(esw->dev) != peer_esw->dev)
-			break;
-
 		if (mlx5_eswitch_vport_match_metadata_enabled(esw) !=
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
@@ -2744,6 +2741,9 @@ static void esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
+	if (!mlx5_is_lag_supported(esw->dev))
+		return;
+
 	mlx5_devcom_register_component(devcom,
 				       MLX5_DEVCOM_ESW_OFFLOADS,
 				       mlx5_esw_offloads_devcom_event,
@@ -2761,6 +2761,9 @@ static void esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
+	if (!mlx5_is_lag_supported(esw->dev))
+		return;
+
 	mlx5_devcom_send_event(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
 			       ESW_OFFLOADS_DEVCOM_UNPAIR, esw);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 72f70fad4641..c81b173156d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -74,6 +74,16 @@ struct mlx5_lag {
 	struct lag_mpesw	  lag_mpesw;
 };
 
+static inline bool mlx5_is_lag_supported(struct mlx5_core_dev *dev)
+{
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) < 2 ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) > MLX5_MAX_PORTS)
+		return false;
+	return true;
+}
+
 static inline struct mlx5_lag *
 mlx5_lag_dev(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 484cb1e4fc7f..9cc7afea2758 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -209,7 +209,6 @@ int mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);

