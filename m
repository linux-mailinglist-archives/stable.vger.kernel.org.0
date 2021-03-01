Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADAC328B05
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhCAS1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239726AbhCASUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDA464F31;
        Mon,  1 Mar 2021 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620398;
        bh=jDaYfxJXqUarLEOWHPucA2FtOxFv6RBPytXGRBjyKvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmSMDVowe8RBjRUzyBDZalrPOgvzNckSZktSIoFiMUaXwbBoY+Z7CIXnWxxsmoc9h
         y7KAWeqi15d0isb5uPoFc1TY+HgMf0jU39qMtia8tAH0ojkUNJKQ7O2tQBnIgByoqd
         sWIuRXMkhiEYYv4imvMlgSpi4bmP2tITaEezxIug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 108/775] net/mlx5: Fix health error state handling
Date:   Mon,  1 Mar 2021 17:04:36 +0100
Message-Id: <20210301161207.002779590@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 51d138c2610a236c1ed0059d034ee4c74f452b86 ]

Currently, when we discover a fatal error, we are queueing a work that
will wait for a lock in order to enter the device to error state.
Meanwhile, FW commands are still being processed, and gets timeouts.
This can block the driver for few minutes before the work will manage
to get the lock and enter to error state.

Setting the device to error state before queueing health work, in order
to avoid FW commands being processed while the work is waiting for the
lock.

Fixes: c1d4d2e92ad6 ("net/mlx5: Avoid calling sleeping function by the health poll thread")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 54523bed16cd3..0c32c485eb588 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -190,6 +190,16 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static void enter_error_state(struct mlx5_core_dev *dev, bool force)
+{
+	if (mlx5_health_check_fatal_sensors(dev) || force) { /* protected state setting */
+		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+		mlx5_cmd_flush(dev);
+	}
+
+	mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_SYS_ERROR, (void *)1);
+}
+
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 {
 	bool err_detected = false;
@@ -208,12 +218,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 		goto unlock;
 	}
 
-	if (mlx5_health_check_fatal_sensors(dev) || force) { /* protected state setting */
-		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
-		mlx5_cmd_flush(dev);
-	}
-
-	mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_SYS_ERROR, (void *)1);
+	enter_error_state(dev, force);
 unlock:
 	mutex_unlock(&dev->intf_state_mutex);
 }
@@ -613,7 +618,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	priv = container_of(health, struct mlx5_priv, health);
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 
-	mlx5_enter_error_state(dev, false);
+	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		if (mlx5_health_try_recover(dev))
 			mlx5_core_err(dev, "health recovery failed\n");
@@ -707,8 +712,9 @@ static void poll_health(struct timer_list *t)
 		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
 		dev->priv.health.fatal_error = fatal_error;
 		print_health_info(dev);
+		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		mlx5_trigger_health_work(dev);
-		goto out;
+		return;
 	}
 
 	count = ioread32be(health->health_counter);
-- 
2.27.0



