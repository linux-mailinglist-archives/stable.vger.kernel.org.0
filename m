Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6930C062
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhBBN4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232819AbhBBNyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A434764FD2;
        Tue,  2 Feb 2021 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273477;
        bh=tAf/gmNteQOAw2tG1ve7gD0+WpCk6tZkVGywhPNnGa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8vpqVo9vsQfpdPl9GwaSV73HYU8TOWYxU+aUJ8OjXAjDuES5z8wZbUQsShuJY0Bg
         OLRi5wLa30O7nM9CEi+GL8fO0WDY8Mh5GwLpa7M5z8a6VGSU44drZcWRV+CNq+vEa5
         iVLBsIWWpV+npveGxfEeDA/+J6z1SPIoKqj9jrv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/142] net/mlx5e: Revert parameters on errors when changing trust state without reset
Date:   Tue,  2 Feb 2021 14:38:05 +0100
Message-Id: <20210202133002.736580288@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 912c9b5fcca1ab65b806c19dd3b3cb12d73c6fe2 ]

Trust state may be changed without recreating the channels. It happens
when the channels are closed, and when channel parameters (min inline
mode) stay the same after changing the trust state. Changing the trust
state is a hardware command that may fail. The current code didn't
restore the channel parameters to their old values if an error happened
and the channels were closed. This commit adds handling for this case.

Fixes: 6e0504c69811 ("net/mlx5e: Change inline mode correctly when changing trust state")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index d20243d6a0326..f23c67575073a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1151,6 +1151,7 @@ static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 {
 	struct mlx5e_channels new_channels = {};
 	bool reset_channels = true;
+	bool opened;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -1159,22 +1160,24 @@ static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_channels.params,
 						   trust_state);
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (!opened)
 		reset_channels = false;
-	}
 
 	/* Skip if tx_min_inline is the same */
 	if (new_channels.params.tx_min_inline_mode ==
 	    priv->channels.params.tx_min_inline_mode)
 		reset_channels = false;
 
-	if (reset_channels)
+	if (reset_channels) {
 		err = mlx5e_safe_switch_channels(priv, &new_channels,
 						 mlx5e_update_trust_state_hw,
 						 &trust_state);
-	else
+	} else {
 		err = mlx5e_update_trust_state_hw(priv, &trust_state);
+		if (!err && !opened)
+			priv->channels.params = new_channels.params;
+	}
 
 	mutex_unlock(&priv->state_lock);
 
-- 
2.27.0



