Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD435B881
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhDLCW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235857AbhDLCW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEEAA6120B;
        Mon, 12 Apr 2021 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194162;
        bh=RwUqT5+Hp5HuRfJAuxZwxYDMdqylSnZ4mj2ol7LfHks=;
        h=From:To:Cc:Subject:Date:From;
        b=nUK6tVUcYp3egAd2AxZnqft20HKijfLeDMOLzVLJuROlMdB9/QpGklBSVz5gloiel
         dLsJWH/b9dxa6Hbost/gToNoTIAO00/SnGlWphnTZThAVFN5Z9IogfKeVY96axsYig
         cDcFV6KCGkseDBq2FPWvMHDgGnKIgg39/ItJ/VnQpJhFm4QRrbN7UBvLaFRMQUiQOW
         VkoTjgeBGTIKbH6owxzrHCMS/9mIMvY5Z4HvlNhqmJ5XFpbcV3aP9w5iS3EwiSEzq4
         y/hhPPpPmlOqzVg1GiExz+ktMAPGuw+3Op7mecnVjGMN1biersn3SDauMY893YUAvy
         qriXQVQLlteMw==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, elic@nvidia.com
Cc:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: FAILED: Patch "net/mlx5: Fix HW spec violation configuring uplink" failed to apply to 5.10-stable tree
Date:   Sun, 11 Apr 2021 22:22:40 -0400
Message-Id: <20210412022240.283075-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.10-stable tree.
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




