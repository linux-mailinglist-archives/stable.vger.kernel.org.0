Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3899A03
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbfHVRJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390742AbfHVRJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:23 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C26233FC;
        Thu, 22 Aug 2019 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493763;
        bh=3n4m7aF82NQQ1fzSPxJnHjp9PaDInQWklKCaCaI7JXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CXR1WVPlTIjyf0BZKlaLpgKAVrnfmTOVb7/r1u+kW8+nZYoMqcDioiZ6AdeNheA/
         7Wjbr8dx8kZZBcribVVf3FBVUBoeFxfj6D2/SLye5jwUWjImkJEDu2PEAtdy3DEyzD
         R0v9xXiz+VOmxgdwKfg13j+HBNHvv9683sE+boms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohamad Heib <mohamadh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 128/135] net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off
Date:   Thu, 22 Aug 2019 13:08:04 -0400
Message-Id: <20190822170811.13303-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohamad Heib <mohamadh@mellanox.com>

[ Upstream commit 5faf5b70c51dd9c9905bf8209e33cbd867486607 ]

Setting speed to 56GBASE is allowed only with auto-negotiation enabled.

This patch prevent setting speed to 56GBASE when auto-negotiation disabled.

Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethernet functionality")
Signed-off-by: Mohamad Heib <mohamadh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 22d5101769651..06f9bd6a45e33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1060,6 +1060,14 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	link_modes = autoneg == AUTONEG_ENABLE ? ethtool2ptys_adver_func(adver) :
 		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
 
+	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
+	    autoneg != AUTONEG_ENABLE) {
+		netdev_err(priv->netdev, "%s: 56G link speed requires autoneg enabled\n",
+			   __func__);
+		err = -EINVAL;
+		goto out;
+	}
+
 	link_modes = link_modes & eproto.cap;
 	if (!link_modes) {
 		netdev_err(priv->netdev, "%s: Not supported link mode(s) requested",
-- 
2.20.1

