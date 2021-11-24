Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D50945C557
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353105AbhKXN4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348178AbhKXNyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1543861A35;
        Wed, 24 Nov 2021 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759159;
        bh=oROnaueja++UycHbeW1ywl9dONLAyKB/R0vwQn2ZAxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByZ+ID50lGCOOKt26mxXXhTr3uq7MgF5ZSXFfrSFHfrtl/s5a885VyxJPhelLx0no
         6EeUYaLvGEGay5W+xhO0UBPqjRhgfUmoJKJ0PXlv19L3FrYY2BGRZLF+sYxnH55nOc
         nWrn4UvSpjhGVaIyyFTJijRIkb1ZfVA/yOJEfYno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/279] net/mlx5: Lag, update tracker when state change event received
Date:   Wed, 24 Nov 2021 12:57:17 +0100
Message-Id: <20211124115723.954324156@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit ae396d85c01c7bdc9eeceecde1f493d03f793465 ]

Currently, In NETDEV_CHANGELOWERSTATE/NETDEV_CHANGEUPPERSTATE events
handling, tracking is not fully completed if the LAG device is not ready
at the time the events occur. But, we must keep track of the upper and
lower states after receiving the events because RoCE needs this info in
mlx5_lag_get_roce_netdev() - in order to return the corresponding port
that its running on. Returning the wrong (not most recent) port will lead
to gids table being incorrect.

For example: If during the attachment of a slave to the bond, the other
non-attached port performs pci_reload, then the LAG device is not ready,
but that should not result in dismissing attached slave tracker update
automatically (which is performed in mlx5_handle_changelowerstate()), Since
these events might not come later, which can lead to both bond ports
having tx_enabled=0 - which is not a valid state of LAG bond.

Fixes: 9b412cc35f00 ("net/mlx5e: Add LAG warning if bond slave is not lag master")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index d2105c1635c34..c19d9327095b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -565,6 +565,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	bool is_bonded, is_in_lag, mode_supported;
 	int bond_status = 0;
 	int num_slaves = 0;
+	int changed = 0;
 	int idx;
 
 	if (!netif_is_lag_master(upper))
@@ -601,27 +602,27 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	 */
 	is_in_lag = num_slaves == MLX5_MAX_PORTS && bond_status == 0x3;
 
-	if (!mlx5_lag_is_ready(ldev) && is_in_lag) {
-		NL_SET_ERR_MSG_MOD(info->info.extack,
-				   "Can't activate LAG offload, PF is configured with more than 64 VFs");
-		return 0;
-	}
-
 	/* Lag mode must be activebackup or hash. */
 	mode_supported = tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP ||
 			 tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH;
 
-	if (is_in_lag && !mode_supported)
-		NL_SET_ERR_MSG_MOD(info->info.extack,
-				   "Can't activate LAG offload, TX type isn't supported");
-
 	is_bonded = is_in_lag && mode_supported;
 	if (tracker->is_bonded != is_bonded) {
 		tracker->is_bonded = is_bonded;
-		return 1;
+		changed = 1;
 	}
 
-	return 0;
+	if (!is_in_lag)
+		return changed;
+
+	if (!mlx5_lag_is_ready(ldev))
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, PF is configured with more than 64 VFs");
+	else if (!mode_supported)
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, TX type isn't supported");
+
+	return changed;
 }
 
 static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
@@ -664,9 +665,6 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 
 	ldev    = container_of(this, struct mlx5_lag, nb);
 
-	if (!mlx5_lag_is_ready(ldev) && event == NETDEV_CHANGELOWERSTATE)
-		return NOTIFY_DONE;
-
 	tracker = ldev->tracker;
 
 	switch (event) {
-- 
2.33.0



