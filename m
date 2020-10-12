Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A852B28B823
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389929AbgJLNtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731912AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B7F222C8;
        Mon, 12 Oct 2020 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510489;
        bh=QeBgHF9A7YrtFh6Cm0jBGVSXwT4Fhymy+ntAJ/D5UUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvEtuyvEiEtUf4b1xfRDhOnGNhw52RLFzVnObwnpvXJILLCFzdhD76O064WO9SX0G
         vXx2hauIbr0ONZn6w8v6V8GvPUAanTHZVH7+KTADNUkk4ppTyrNn8Wfv1bhlYI6Zg+
         XkFdOJm0xLrGfd3R+Pk4jcdDUiLNlC8pMxcYLyes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 091/124] net/mlx5e: Fix VLAN cleanup flow
Date:   Mon, 12 Oct 2020 15:31:35 +0200
Message-Id: <20201012133151.257881651@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 8c7353b6f716436ad0bfda2b5c5524ab2dde5894 ]

Prior to this patch unloading an interface in promiscuous mode with RX
VLAN filtering feature turned off - resulted in a warning. This is due
to a wrong condition in the VLAN rules cleanup flow, which left the
any-vid rules in the VLAN steering table. These rules prevented
destroying the flow group and the flow table.

The any-vid rules are removed in 2 flows, but none of them remove it in
case both promiscuous is set and VLAN filtering is off. Fix the issue by
changing the condition of the VLAN table cleanup flow to clean also in
case of promiscuous mode.

mlx5_core 0000:00:08.0: mlx5_destroy_flow_group:2123:(pid 28729): Flow group 20 wasn't destroyed, refcount > 1
mlx5_core 0000:00:08.0: mlx5_destroy_flow_group:2123:(pid 28729): Flow group 19 wasn't destroyed, refcount > 1
mlx5_core 0000:00:08.0: mlx5_destroy_flow_table:2112:(pid 28729): Flow table 262149 wasn't destroyed, refcount > 1
...
...
------------[ cut here ]------------
FW pages counter is 11560 after reclaiming all pages
WARNING: CPU: 1 PID: 28729 at
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:660
mlx5_reclaim_startup_pages+0x178/0x230 [mlx5_core]
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
  mlx5_function_teardown+0x2f/0x90 [mlx5_core]
  mlx5_unload_one+0x71/0x110 [mlx5_core]
  remove_one+0x44/0x80 [mlx5_core]
  pci_device_remove+0x3e/0xc0
  device_release_driver_internal+0xfb/0x1c0
  device_release_driver+0x12/0x20
  pci_stop_bus_device+0x68/0x90
  pci_stop_and_remove_bus_device+0x12/0x20
  hv_eject_device_work+0x6f/0x170 [pci_hyperv]
  ? __schedule+0x349/0x790
  process_one_work+0x206/0x400
  worker_thread+0x34/0x3f0
  ? process_one_work+0x400/0x400
  kthread+0x126/0x140
  ? kthread_park+0x90/0x90
  ret_from_fork+0x22/0x30
   ---[ end trace 6283bde8d26170dc ]---

Fixes: 9df30601c843 ("net/mlx5e: Restore vlan filter after seamless reset")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 73d3dc07331f1..c5be0cdfaf0fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -415,8 +415,12 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs.vlan.cvlan_filter_disabled &&
-	    !(priv->netdev->flags & IFF_PROMISC))
+	WARN_ON_ONCE(!(test_bit(MLX5E_STATE_DESTROYING, &priv->state)));
+
+	/* must be called after DESTROY bit is set and
+	 * set_rx_mode is called and flushed
+	 */
+	if (priv->fs.vlan.cvlan_filter_disabled)
 		mlx5e_del_any_vid_rules(priv);
 }
 
-- 
2.25.1



