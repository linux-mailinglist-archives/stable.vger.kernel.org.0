Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B270E34CA27
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhC2IfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233076AbhC2Id7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA95619AD;
        Mon, 29 Mar 2021 08:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006838;
        bh=K9wWdvXh/4Okq/SOq4O42dNovCJlYcYVahHwO/atcRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KaE3kTC1JoE3KHuegmNJ6EfiILlY5P9PTi1uNpZfsX9xxCsFoPtDqSejrh7OCOJN
         dIZyw9DIm6cVxI21SltJDmciD83tpgBAalxRGwDXOwjmdAm2QHBSXxD/8yKadwyrZ3
         /MN4R0+eltg1HgJenZ4cBYlLFXATms8OsZMfFPys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 117/254] net/mlx5e: Revert parameters on errors when changing PTP state without reset
Date:   Mon, 29 Mar 2021 09:57:13 +0200
Message-Id: <20210329075637.065660153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 74640f09735f935437bd8df9fe61a66f03eabb34 ]

Port timestamping for PTP can be enabled/disabled while the channels are
closed. In that case mlx5e_safe_switch_channels is skipped, and the
preactivate hook is called directly. However, if that hook returns an
error, the channel parameters must be reverted back to their old values.
This commit adds missing handling on this case.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8612c388db7d..fdf5afc8b058 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1993,8 +1993,13 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	 */
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params = priv->channels.params;
 		priv->channels.params = new_channels.params;
 		err = mlx5e_num_channels_changed(priv);
+		if (err)
+			priv->channels.params = old_params;
 		goto out;
 	}
 
-- 
2.30.1



