Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCBE3B6273
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbhF1Orp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhF1OmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF3F861CDF;
        Mon, 28 Jun 2021 14:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890815;
        bh=ugoJC3wP4h9abBjTmplBKBMow6jxyx9uXeDiuZFMKYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+ng3s+vy5wYB+nnYA+VwVWpX8ThthQ8+ktC+xKNvXQcofxpNm8eDDv53/KmTNmX2
         yCHBnrYOUP9w2f3WNfCdM5U3ps6F9z14/68I+oTW7XRm3VTtKix0kac0gBG7aUQM1S
         D0hjKmsgAxm4Lvt79/9A3uMmD4P+NEhDdYT/xKxeWEmmJvP41Tr6Aeqq+LLEzdIydC
         vw23/BE/m3lB05dOCeea4WT6hpGQ7KxTWsD8xOudKusEoqXPKNLKaUX6fkLF6GOTY4
         i2pH5XOLvKr02NYg5FB6wtV8H/r9sovcuGehqThkMcnbma8hn+ToX2ctgw0IgrjgpC
         81V/OzJ2CH8xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/109] net/mlx5e: Remove dependency in IPsec initialization flows
Date:   Mon, 28 Jun 2021 10:31:47 -0400
Message-Id: <20210628143305.32978-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

[ Upstream commit 8ad893e516a77209a1818a2072d2027d87db809f ]

Currently, IPsec feature is disabled because mlx5e_build_nic_netdev
is required to be called after mlx5e_ipsec_init. This requirement is
invalid as mlx5e_build_nic_netdev and mlx5e_ipsec_init initialize
independent resources.

Remove ipsec pointer check in mlx5e_build_nic_netdev so that the
two functions can be called at any order.

Fixes: 547eede070eb ("net/mlx5e: IPSec, Innova IPSec offload infrastructure")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index cf58c9637904..c467f5e981f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -515,9 +515,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
-	if (!priv->ipsec)
-		return;
-
 	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-- 
2.30.2

