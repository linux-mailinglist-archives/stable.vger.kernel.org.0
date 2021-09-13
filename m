Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7E640958F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347852AbhIMOml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347254AbhIMOk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0B47630EA;
        Mon, 13 Sep 2021 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541366;
        bh=sch4oCML0TRqmxt/bRyToxXlabMK2Dc/Jbh0VLScjzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TODrpH4Wk+EhyShXgGYSGs+u883znR83Ow+vKz5/PbPqKSXlQpx/S89scqAobvETx
         rbQWjSyDphRfTD0YA8ygvCK0iO5UCPrPsID1A2x07k5UMKqCqG7LgFpCfKch0QI6FJ
         nsGIgqZbAdzER22McrFhQPayO5FASQPG/Yc60aGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 268/334] net/mlx5: Lag, fix multipath lag activation
Date:   Mon, 13 Sep 2021 15:15:22 +0200
Message-Id: <20210913131122.481574140@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

[ Upstream commit 2f8b6161cca5fb34b0065e2eac8bb2b61b7bfe87 ]

When handling FIB_EVENT_ENTRY_REPLACE event for a new multipath route,
lag activation can be missed if a stale (struct lag_mp)->mfi pointer
exists, which was associated with an older multipath route that had been
removed.

Normally, when a route is removed, it triggers mlx5_lag_fib_event(),
which handles FIB_EVENT_ENTRY_DEL and clears mfi pointer. But, if
mlx5_lag_check_prereq() condition isn't met, for example when eswitch is
in legacy mode, the fib event is skipped and mfi pointer becomes stale.

Fix by resetting mfi pointer to NULL in mlx5_deactivate_lag().

Fixes: 8a66e4585979 ("net/mlx5: Change ownership model for lag")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 5c043c5cc403..40ef60f562b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -277,6 +277,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	int err;
 
 	ldev->flags &= ~MLX5_LAG_MODE_FLAGS;
+	mlx5_lag_mp_reset(ldev);
 
 	MLX5_SET(destroy_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_LAG);
 	err = mlx5_cmd_exec_in(dev0, destroy_lag, in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index c4bf8b679541..516bfc2bd797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -302,6 +302,14 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+void mlx5_lag_mp_reset(struct mlx5_lag *ldev)
+{
+	/* Clear mfi, as it might become stale when a route delete event
+	 * has been missed, see mlx5_lag_fib_route_event().
+	 */
+	ldev->lag_mp.mfi = NULL;
+}
+
 int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 {
 	struct lag_mp *mp = &ldev->lag_mp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
index 258ac7b2964e..729c839397a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
@@ -21,11 +21,13 @@ struct lag_mp {
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+void mlx5_lag_mp_reset(struct mlx5_lag *ldev);
 int mlx5_lag_mp_init(struct mlx5_lag *ldev);
 void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 
+static inline void mlx5_lag_mp_reset(struct mlx5_lag *ldev) {};
 static inline int mlx5_lag_mp_init(struct mlx5_lag *ldev) { return 0; }
 static inline void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev) {}
 
-- 
2.30.2



