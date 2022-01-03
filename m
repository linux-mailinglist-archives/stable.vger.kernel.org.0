Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A064848336D
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiACOgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiACOeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066ADC061799;
        Mon,  3 Jan 2022 06:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9917161123;
        Mon,  3 Jan 2022 14:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C56C36AEE;
        Mon,  3 Jan 2022 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220350;
        bh=cbHIVWmirr3lCPhEpIVqUYNyOAs3vDKr+QyNpYT2Dg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7LiYqk2ZfhDwZ6iu4kF61XG2c2QkvNVFitLej2KzLQqrWJNBtzFXgXin+gUP8Kwz
         X9QO5c+8uzDoqy4c+t210lZxnlkufS2IlNIsTHcZ5AuF2LCTy8pFRSnJ79OrWHG96c
         h9HLiWgDJcbMzRh9lly6J8Jj7BNhrccdM9p9mqX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/73] net/mlx5e: Fix wrong features assignment in case of error
Date:   Mon,  3 Jan 2022 15:24:03 +0100
Message-Id: <20220103142058.270814614@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 992d8a4e38f0527f24e273ce3a9cd6dea1a6a436 ]

In case of an error in mlx5e_set_features(), 'netdev->features' must be
updated with the correct state of the device to indicate which features
were updated successfully.
To do that we maintain a copy of 'netdev->features' and update it after
successful feature changes, so we can assign it to back to
'netdev->features' if needed.

However, since not all netdev features are handled by the driver (e.g.
GRO/TSO/etc), some features may not be updated correctly in case of an
error updating another feature.

For example, while requesting to disable TSO (feature which is not
handled by the driver) and enable HW-GRO, if an error occurs during
HW-GRO enable, 'oper_features' will be assigned with 'netdev->features'
and HW-GRO turned off. TSO will remain enabled in such case, which is a
bug.

To solve that, instead of using 'netdev->features' as the baseline of
'oper_features' and changing it on set feature success, use 'features'
instead and update it in case of errors.

Fixes: 75b81ce719b7 ("net/mlx5e: Don't override netdev features field unless in error flow")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 685fe77de5ce4..baa0d7d48fc0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3450,12 +3450,11 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 
 static int mlx5e_handle_feature(struct net_device *netdev,
 				netdev_features_t *features,
-				netdev_features_t wanted_features,
 				netdev_features_t feature,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ netdev->features;
-	bool enable = !!(wanted_features & feature);
+	netdev_features_t changes = *features ^ netdev->features;
+	bool enable = !!(*features & feature);
 	int err;
 
 	if (!(changes & feature))
@@ -3463,22 +3462,22 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 
 	err = feature_handler(netdev, enable);
 	if (err) {
+		MLX5E_SET_FEATURE(features, feature, !enable);
 		netdev_err(netdev, "%s feature %pNF failed, err %d\n",
 			   enable ? "Enable" : "Disable", &feature, err);
 		return err;
 	}
 
-	MLX5E_SET_FEATURE(features, feature, enable);
 	return 0;
 }
 
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t oper_features = netdev->features;
+	netdev_features_t oper_features = features;
 	int err = 0;
 
 #define MLX5E_HANDLE_FEATURE(feature, handler) \
-	mlx5e_handle_feature(netdev, &oper_features, features, feature, handler)
+	mlx5e_handle_feature(netdev, &oper_features, feature, handler)
 
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
-- 
2.34.1



