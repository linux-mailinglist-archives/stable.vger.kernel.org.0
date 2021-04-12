Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8435B883
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhDLCXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235857AbhDLCXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5241E6120A;
        Mon, 12 Apr 2021 02:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194166;
        bh=/pOSav/Qx87F8G3b5+Nn0aPfGMaWVKm9E6tJdpO2CWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=M0w9spxQ+TKaC2DeoBivJkPTGTwoYrp8qI1tQbvyPSumcI7I/Sz31zrCrmn1eWdcG
         za3UsqdGTvIMhcMlh4sTXeC0N4WGgYdeIjWIqr1jFLNNNGDHDR6kKiQJBEStR2aLLD
         9y832clr7P1XC+7wEpWWsnB0g40/Wunw69VaI+St4zpofvv0L+S2FTr2uJrYj6d+nH
         eQy2rcWIkm6aZGmOZmT58rRPw5NuRjdvV4X2FspoutP0kF1SqInQJ1+VY0aIyvWcyi
         BUh0mPJ3yiJTLV7rQOMuuEFwuIFl9ENU8HrKaJfUr1dsEujRlfYNLPtoh8DIk1yYQD
         9qD4Nh9xF0bVg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, elic@nvidia.com
Cc:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: FAILED: Patch "net/mlx5: Fix HW spec violation configuring uplink" failed to apply to 5.4-stable tree
Date:   Sun, 11 Apr 2021 22:22:45 -0400
Message-Id: <20210412022245.283209-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 1a73704c82ed4ee95532ac04645d02075bd1ce3d Mon Sep 17 00:00:00 2001
From: Eli Cohen <elic@nvidia.com>
Date: Wed, 24 Mar 2021 09:46:09 +0200
Subject: [PATCH] net/mlx5: Fix HW spec violation configuring uplink

Make sure to modify uplink port to follow only if the uplink_follow
capability is set as required by the HW spec. Failure to do so causes
traffic to the uplink representor net device to cease after switching to
switchdev mode.

Fixes: 7d0314b11cdd ("net/mlx5e: Modify uplink state on interface up/down")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a132fff7a980..8d39bfee84a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1107,8 +1107,9 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
-	mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
-				      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
+	if (MLX5_CAP_GEN(mdev, uplink_follow))
+		mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
+					      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
-- 
2.30.2




