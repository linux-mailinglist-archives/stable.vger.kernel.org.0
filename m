Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E468828B84B
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390173AbgJLNvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731829AbgJLNsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10EA2074F;
        Mon, 12 Oct 2020 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510420;
        bh=Y7zIKQ9+uwjsy6YzMob7+w13D/hTN3gvmic7c7rJ9ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lh36qCRvrLZu6vt58lMQ1vd0x3dvX0fMeUi0szoAE7hp3qKX05kj7yXgCTXH79dCP
         2CvRaAmi5i2YWhtUkJCZId7txOy9Tkuzv9OjfzE60y9exsWOQ5RU3tDvw20SG6ZGMQ
         hgrBRvgLzxdx8qFPpHAMWZo4aGQxdhSZ365A6VWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 092/124] net/mlx5e: Fix VLAN create flow
Date:   Mon, 12 Oct 2020 15:31:36 +0200
Message-Id: <20201012133151.306157823@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit d4a16052bccdd695982f89d815ca075825115821 ]

When interface is attached while in promiscuous mode and with VLAN
filtering turned off, both configurations are not respected and VLAN
filtering is performed.
There are 2 flows which add the any-vid rules during interface attach:
VLAN creation table and set rx mode. Each is relaying on the other to
add any-vid rules, eventually non of them does.

Fix this by adding any-vid rules on VLAN creation regardless of
promiscuous mode.

Fixes: 9df30601c843 ("net/mlx5e: Restore vlan filter after seamless reset")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index c5be0cdfaf0fa..713dc210f710c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -217,6 +217,9 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 		break;
 	}
 
+	if (WARN_ONCE(*rule_p, "VLAN rule already exists type %d", rule_type))
+		return 0;
+
 	*rule_p = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 
 	if (IS_ERR(*rule_p)) {
@@ -397,8 +400,7 @@ static void mlx5e_add_vlan_rules(struct mlx5e_priv *priv)
 	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
 		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs.vlan.cvlan_filter_disabled &&
-	    !(priv->netdev->flags & IFF_PROMISC))
+	if (priv->fs.vlan.cvlan_filter_disabled)
 		mlx5e_add_any_vid_rules(priv);
 }
 
-- 
2.25.1



