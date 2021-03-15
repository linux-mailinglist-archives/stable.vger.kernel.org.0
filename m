Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BBE33B8F9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhCOOFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231902AbhCON6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7AC764F10;
        Mon, 15 Mar 2021 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816710;
        bh=/qmkf0PeBjIAF/IbdefhRGvkHUCPeSlu4laHEVa8GL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkOYGfMseqWPzv17M8UVDCAwnBpwKfJYxxcvLS5plfJXbcnliBNN0PNv40652QPZH
         nWfVvMrLyx9+6bcafRYk9fnzwcQf0zLTFtkRjEfSCIhWBvbiOJJmIVuOHMIhOPXYAI
         xoy+ltBWipDJh4dykskziSGOmeFz5f+CiThZa55w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kevin(Yudong) Yang" <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 020/120] net/mlx4_en: update moderation when config reset
Date:   Mon, 15 Mar 2021 14:56:11 +0100
Message-Id: <20210315135720.668139346@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kevin(Yudong) Yang <yyd@google.com>

commit 00ff801bb8ce6711e919af4530b6ffa14a22390a upstream.

This patch fixes a bug that the moderation config will not be
applied when calling mlx4_en_reset_config. For example, when
turning on rx timestamping, mlx4_en_reset_config() will be called,
causing the NIC to forget previous moderation config.

This fix is in phase with a previous fix:
commit 79c54b6bbf06 ("net/mlx4_en: Fix TX moderation info loss
after set_ringparam is called")

Tested: Before this patch, on a host with NIC using mlx4, run
netserver and stream TCP to the host at full utilization.
$ sar -I SUM 1
                 INTR    intr/s
14:03:56          sum  48758.00

After rx hwtstamp is enabled:
$ sar -I SUM 1
14:10:38          sum 317771.00
We see the moderation is not working properly and issued 7x more
interrupts.

After the patch, and turned on rx hwtstamp, the rate of interrupts
is as expected:
$ sar -I SUM 1
14:52:11          sum  49332.00

Fixes: 79c54b6bbf06 ("net/mlx4_en: Fix TX moderation info loss after set_ringparam is called")
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
CC: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |    2 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -47,7 +47,7 @@
 #define EN_ETHTOOL_SHORT_MASK cpu_to_be16(0xffff)
 #define EN_ETHTOOL_WORD_MASK  cpu_to_be32(0xffffffff)
 
-static int mlx4_en_moderation_update(struct mlx4_en_priv *priv)
+int mlx4_en_moderation_update(struct mlx4_en_priv *priv)
 {
 	int i, t;
 	int err = 0;
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3667,6 +3667,8 @@ int mlx4_en_reset_config(struct net_devi
 			en_err(priv, "Failed starting port\n");
 	}
 
+	if (!err)
+		err = mlx4_en_moderation_update(priv);
 out:
 	mutex_unlock(&mdev->state_lock);
 	kfree(tmp);
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -798,6 +798,7 @@ void mlx4_en_ptp_overflow_check(struct m
 #define DEV_FEATURE_CHANGED(dev, new_features, feature) \
 	((dev->features & feature) ^ (new_features & feature))
 
+int mlx4_en_moderation_update(struct mlx4_en_priv *priv);
 int mlx4_en_reset_config(struct net_device *dev,
 			 struct hwtstamp_config ts_config,
 			 netdev_features_t new_features);


