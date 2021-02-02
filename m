Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2641730CBAC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhBBTcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhBBN5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF2A664FED;
        Tue,  2 Feb 2021 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273552;
        bh=mSuHFssorb0V8K+xCWhq1W5lbtxNfBng/VF5CwzUrw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxzIXssV4A6qWgzAzvZiId7+K4tkrmG0wL6wG0BmeDKl3mEKKftQV/lxNxZ/38BCV
         wAVpUNkUJugympoQJskTtP23WJ5F+gpxfLs+gbm6tHfx/gVdStw6/ihCKvthfQ4rJf
         QyHOKFOeGmjysze4jONu0FHsXk0JorJRpDxDz5AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/142] net/mlx5e: Reduce tc unsupported key print level
Date:   Tue,  2 Feb 2021 14:38:00 +0100
Message-Id: <20210202133002.537403013@linuxfoundation.org>
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

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 48470a90a42a64dd2f70743a149894a292b356e0 ]

"Unsupported key used:" appears in kernel log when flows with
unsupported key are used, arp fields for example.

OpenVSwitch was changed to match on arp fields by default that
caused this warning to appear in kernel log for every arp rule, which
can be a lot.

Fix by lowering print level from warning to debug.

Fixes: e3a2b7ed018e ("net/mlx5e: Support offload cls_flower with drop action")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 98cd5d8b0cd8b..3be34b1128731 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2272,8 +2272,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
 	      BIT(FLOW_DISSECTOR_KEY_MPLS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
-		netdev_warn(priv->netdev, "Unsupported key used: 0x%x\n",
-			    dissector->used_keys);
+		netdev_dbg(priv->netdev, "Unsupported key used: 0x%x\n",
+			   dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.27.0



