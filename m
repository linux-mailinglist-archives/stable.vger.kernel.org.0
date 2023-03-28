Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E656CC3E5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjC1O6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjC1O6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEB6E184
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0831A6182A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE06C433D2;
        Tue, 28 Mar 2023 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015483;
        bh=OLpg/fofh7xVcZZzTKj8UkknWGqOgGMautab5OLQqoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGIwMMFtrNOVPUMU4ZvLjbEeMkdXvf3PSdGoP6ocohguuReUidbLIOavNaW4hzSHo
         8mAs8q3l5+D7JKmZt4Q+uSQ6BGPzfTrqh4TFj3USg9wxQYldyzA4bUkxDo0zk6RPgW
         GxAMWsU7XuVTGr0ohkh+89640PKqJ1znUxM7kYh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gavin Li <gavinl@nvidia.com>,
        Gavi Teitz <gavi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/224] net/mlx5e: Block entering switchdev mode with ns inconsistency
Date:   Tue, 28 Mar 2023 16:41:01 +0200
Message-Id: <20230328142620.055155380@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit 662404b24a4c4d839839ed25e3097571f5938b9b ]

Upon entering switchdev mode, VF/SF representors are spawned in the
devlink instance's net namespace, whereas the PF net device transforms
into the uplink representor, remaining in the net namespace the PF net
device was in. Therefore, if a PF net device's namespace is different from
its parent devlink net namespace, entering switchdev mode can create an
illegal situation where all representors sharing the same core device
are NOT in the same net namespace.

To avoid this issue, block entering switchdev mode for devices whose child
netdev net namespace has diverged from the parent devlink's.

Fixes: 7768d1971de6 ("net/mlx5: E-Switch, Add control for encapsulation")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 34790a82a0976..64e5b9f29206e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3488,6 +3488,18 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
+static bool esw_offloads_devlink_ns_eq_netdev_ns(struct devlink *devlink)
+{
+	struct net *devl_net, *netdev_net;
+	struct mlx5_eswitch *esw;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	netdev_net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
+	devl_net = devlink_net(devlink);
+
+	return net_eq(devl_net, netdev_net);
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3502,6 +3514,13 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV &&
+	    !esw_offloads_devlink_ns_eq_netdev_ns(devlink)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't change E-Switch mode to switchdev when netdev net namespace has diverged from the devlink's.");
+		return -EPERM;
+	}
+
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
-- 
2.39.2



