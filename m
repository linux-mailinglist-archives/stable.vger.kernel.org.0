Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B803B6272
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhF1Oro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhF1OmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8DC613CB;
        Mon, 28 Jun 2021 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890816;
        bh=Nwg7DbIKZCwUgWINjEGLs4XoRt4oVYmFHZsO75CeeIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGMz7D1ZX73wjTen2d3XSY+0GIkvtqQqsK+VqbnWDH7K1ACWb+mAz41uTjFIrKxrO
         An0SElNSQaGqur/ngOG/yjZQcsmfcWaAUeXb9dzkrbO5Rw7NkbysPKYt1lzvN/KhHb
         N3FmuehqvFMn0TTtcNSOTQuZ6AIH/vOKRBBbr4spGAqJUXVUq1kCdhNUpe46SljeYZ
         c94aXLRiVdPliNuy0u+J4AmxqG4Mayi5V9Z/CzooQxJzNTaHg/rCmWC9ugId5sI+M8
         f/Tzs64l/CtYdU71cgFOny9MfaHCM7kK7dctyD+qtflkTNzv8jmyMhJQktjGRbjPVs
         BnFYUOb9sRauQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/109] net/mlx5e: Block offload of outer header csum for UDP tunnels
Date:   Mon, 28 Jun 2021 10:31:48 -0400
Message-Id: <20210628143305.32978-33-sashal@kernel.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 6d6727dddc7f93fcc155cb8d0c49c29ae0e71122 ]

The device is able to offload either the outer header csum or inner
header csum. The driver utilizes the inner csum offload. Hence, block
setting of tx-udp_tnl-csum-segmentation and set it to off[fixed].

Fixes: b49663c8fb49 ("net/mlx5e: Add support for UDP tunnel segmentation with outer checksum offload")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 51edc507b7b5..9003702892cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4679,11 +4679,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
 	}
 
 	if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre)) {
-- 
2.30.2

