Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6945C553
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbhKXN4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348279AbhKXNyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44C061A0D;
        Wed, 24 Nov 2021 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759149;
        bh=++brxHt4CC12P5zWIi6VnMzoRJTADwvMrGMzy4WZQ0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naFQyq3LN5fxnTmKaZ7d7v+HnxoC1W5/9u1wjJa05oI+GG+UJS5n8K+nSIyZiTYU9
         X1KVvBUEoiSseSON2z03z4MPbq/4Rzul1WJlLwPjyVzopJAboF/H76RGNnw6yktbJt
         k7/FY9VNOAwjaTMV+9oNvhTxnzvRtPXpVnZXqdq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/279] net/mlx5: E-Switch, rebuild lag only when needed
Date:   Wed, 24 Nov 2021 12:57:15 +0100
Message-Id: <20211124115723.891138004@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 2eb0cb31bc4ce2ede5460cf3ef433b40cf5f040d ]

A user can enable VFs without changing E-Switch mode, this can happen
when a user moves straight to switchdev mode and only once in switchdev
VFs are enabled via the sysfs interface.

The cited commit assumed this isn't possible and exposed a single
API function where the E-switch calls into the lag code, breaks the lag
and prevents any other lag operations to take place until the
E-switch update has ended.

Breaking the hardware lag when it isn't needed can make it such that
hardware lag can't be enabled again.

In the sysfs call path check if the current E-Switch mode is NONE,
in the context of the function it can only mean the E-Switch is moving
out of NONE mode and the hardware lag should be disabled and enabled
once the mode change has ended. If the mode isn't NONE it means
VFs are about to be enabled and such operation doesn't require
toggling the hardware lag.

Fixes: cac1eb2cf2e3 ("net/mlx5: Lag, properly lock eswitch if needed")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 5872cc8bf9532..51a8cecc4a7ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1305,12 +1305,17 @@ abort:
  */
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
+	bool toggle_lag;
 	int ret;
 
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	mlx5_lag_disable_change(esw->dev);
+	toggle_lag = esw->mode == MLX5_ESWITCH_NONE;
+
+	if (toggle_lag)
+		mlx5_lag_disable_change(esw->dev);
+
 	down_write(&esw->mode_lock);
 	if (esw->mode == MLX5_ESWITCH_NONE) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
@@ -1324,7 +1329,10 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
 	up_write(&esw->mode_lock);
-	mlx5_lag_enable_change(esw->dev);
+
+	if (toggle_lag)
+		mlx5_lag_enable_change(esw->dev);
+
 	return ret;
 }
 
-- 
2.33.0



