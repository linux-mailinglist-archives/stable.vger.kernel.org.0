Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E2134C65B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhC2IGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhC2IF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8270C61477;
        Mon, 29 Mar 2021 08:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005158;
        bh=YJQQg/Bld71goeJBCOYTFZmWBV1ppuLj94AHL3+kFXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxLwa5nsBj59pzHNh4zLV/oo1Z7azpxE3oMJS7/6u/GPPqCZvNLgod0z2FfG4sXB+
         LIBYefKpGllT+oS9E5WrlqN+HxNg2B8Aw1FTafzdUerCcUFI3Fq2+9iOwf6K+sgJTd
         8+CXgcBME61GR16/lAGAsTfEPkMKNdOe6rhc98zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/59] net/mlx5e: Fix error path for ethtool set-priv-flag
Date:   Mon, 29 Mar 2021 09:58:26 +0200
Message-Id: <20210329075610.397144324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
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
index c3f1e2d76a46..377f91885bda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1747,6 +1747,7 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
 
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
@@ -1756,7 +1757,10 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
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



