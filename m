Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2711D34C906
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhC2I0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhC2IYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 701A66195B;
        Mon, 29 Mar 2021 08:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006255;
        bh=xyP2UB9BdRoWwoaWobPKiomwwDNHLHWEVcDBrD8BMwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vtjj2U74Xn+FOLsjUYX+Pr9wz/+bkWfZPgiEsreQfYzEFzBYNFHko/nWhHjiE4+7
         uuqNp5aaqTHxvofaRtfCSR1w2aeL84KtfPtOCgtf3AN/mFxizdxvNjyGsLm9hIP5oD
         y85/tMTZlGs6IxDqYq+Q8h7sjGKdL9hLzVrIiWQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/221] net/mlx5e: Fix error path for ethtool set-priv-flag
Date:   Mon, 29 Mar 2021 09:58:24 +0200
Message-Id: <20210329075634.924069516@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 4eacfe72e3e037e3fc019113df32c39a705148c2 ]

Expose error value when failing to comply to command:
$ ethtool --set-priv-flags eth2 rx_cqe_compress [on/off]

Fixes: be7e87f92b58 ("net/mlx5e: Fail safe cqe compressing/moderation mode setting")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index b8622440243b..bcd05457647e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1873,6 +1873,7 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
 
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
@@ -1882,7 +1883,10 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	if (err)
+		return err;
+
 	priv->channels.params.rx_cqe_compress_def = enable;
 
 	return 0;
-- 
2.30.1



