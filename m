Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4A943A340
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhJYT5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235670AbhJYTzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD271610C9;
        Mon, 25 Oct 2021 19:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191144;
        bh=AjaCJqZ/oZKHrjhyqAAZLjw3Z5KbfRrsxbGwaIIcKAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hef61CRbxFoWUM4QA0s1dVtgJ5IL/4kqCnLvpnCwd44/W6iAAXMVp2jpZreTGc3Xs
         9gh3QpgF9+gRdMZ7jQO0tyvxj0EmnGWnm8uthVzDFKM7dulNLMiKuQamhqhbBfS2nG
         OBRtDExPV7QhE5GhNFiwsXgQZdKLckHDYxkFRjtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 156/169] net/mlx5: Lag, move lag destruction to a workqueue
Date:   Mon, 25 Oct 2021 21:15:37 +0200
Message-Id: <20211025191037.185616445@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 63d4a9afbcee4167ffb0d126b23b8884b15e5837 ]

If a netdev is removed from the lag the lag should be destroyed.
With downstream patches this might trigger a reconfiguration of
representors on a different eswitch and such we don't have the proper
locking to so from this path. Move the destruction to be done by the
workqueue.

As the destruction won't affect the netdev side it okay to do so.
The RDMA side will be reconfigured and it already coded to handle such
reconfiguration.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 40ef60f562b4..814440aae1ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -372,12 +372,13 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	bool do_bond, roce_lag;
 	int err;
 
-	if (!mlx5_lag_is_ready(ldev))
-		return;
-
-	tracker = ldev->tracker;
+	if (!mlx5_lag_is_ready(ldev)) {
+		do_bond = false;
+	} else {
+		tracker = ldev->tracker;
 
-	do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
+		do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
+	}
 
 	if (do_bond && !__mlx5_lag_is_active(ldev)) {
 		roce_lag = !mlx5_sriov_is_enabled(dev0) &&
@@ -691,11 +692,11 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
-	if (__mlx5_lag_is_active(ldev))
-		mlx5_disable_lag(ldev);
-
 	mlx5_ldev_remove_netdev(ldev, netdev);
 	ldev->flags &= ~MLX5_LAG_FLAG_READY;
+
+	if (__mlx5_lag_is_active(ldev))
+		mlx5_queue_bond_work(ldev, 0);
 }
 
 /* Must be called with intf_mutex held */
-- 
2.33.0



