Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06B6948E9
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjBMOyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjBMOyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4577F5274
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBD936112D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0299C433D2;
        Mon, 13 Feb 2023 14:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300057;
        bh=3ab7IZgkQ2vWWUUfpEhgi0X8U8e4Rqj3KOjarsKZoBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgniuLY7cbCcFdrWoukSrWt6sukqQXkAPUU0MQJP8c38VTyph63vEAlb9MC69DIiI
         gi2my6Om47c0ST4yCteiT+0W8yqoxi//bGety8SwM3VnGq0JbJCyI2z006NYUwZNu6
         V4HqDyawW+5TD70YZl8qz218cZ32A1k1S0XHP1Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Tzin <amirtz@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/114] net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode
Date:   Mon, 13 Feb 2023 15:48:02 +0100
Message-Id: <20230213144744.598146504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Tzin <amirtz@nvidia.com>

[ Upstream commit 8974aa9638df557f4642acef707af15648a03555 ]

Moving to switchdev mode with rx-vlan-filter on and then setting it off
causes the kernel to crash since fs->vlan is freed during nic profile
cleanup flow.

RX VLAN filtering is not supported in switchdev mode so unset it when
changing to switchdev and restore its value when switching back to
legacy.

trace:
[] RIP: 0010:mlx5e_disable_cvlan_filter+0x43/0x70
[] set_feature_cvlan_filter+0x37/0x40 [mlx5_core]
[] mlx5e_handle_feature+0x3a/0x60 [mlx5_core]
[] mlx5e_set_features+0x6d/0x160 [mlx5_core]
[] __netdev_update_features+0x288/0xa70
[] ethnl_set_features+0x309/0x380
[] ? __nla_parse+0x21/0x30
[] genl_family_rcv_msg_doit.isra.17+0x110/0x150
[] genl_rcv_msg+0x112/0x260
[] ? features_reply_size+0xe0/0xe0
[] ? genl_family_rcv_msg_doit.isra.17+0x150/0x150
[] netlink_rcv_skb+0x4e/0x100
[] genl_rcv+0x24/0x40
[] netlink_unicast+0x1ab/0x290
[] netlink_sendmsg+0x257/0x4f0
[] sock_sendmsg+0x5c/0x70

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1892ccb889b3f..7cd36f4ac3efc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -443,7 +443,7 @@ void mlx5e_enable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 
 void mlx5e_disable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 {
-	if (fs->vlan->cvlan_filter_disabled)
+	if (!fs->vlan || fs->vlan->cvlan_filter_disabled)
 		return;
 
 	fs->vlan->cvlan_filter_disabled = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e0d910b085d4..142ed2d98cd5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4005,6 +4005,10 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	if (netdev->features & NETIF_F_GRO_HW)
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
 
+	features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		netdev_warn(netdev, "Disabling HW_VLAN CTAG FILTERING, not supported in switchdev mode\n");
+
 	return features;
 }
 
-- 
2.39.0



