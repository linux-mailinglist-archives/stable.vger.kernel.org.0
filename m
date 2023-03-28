Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6125F6CC2E8
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjC1Otm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjC1Ot1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE0AE19C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90462CE1DAB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A828C433EF;
        Tue, 28 Mar 2023 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014928;
        bh=52sTTnBBVvZk6CrQQStaDGojKif3biqZ83KX+0jZBJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxHnMVHvXEJi5a2HLgv1dHlEKhOr6AAkoujydPtsJeUDDE5V4oa8PmFNKKnFuDinL
         SDkb9gQgPveBuZHfL7OqPrtGOmMw7SBv+IDWQv2MwyBBuMyH046yCbAM7RSTFh1H5e
         1+lQlisCklzOYIqgTh9tOxJDGEgxVXjSAMT8YA8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gavin Li <gavinl@nvidia.com>,
        Gavi Teitz <gavi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 073/240] net/mlx5e: Block entering switchdev mode with ns inconsistency
Date:   Tue, 28 Mar 2023 16:40:36 +0200
Message-Id: <20230328142622.800485158@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 3992bf6337ca0..0facc709f0e74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3518,6 +3518,18 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
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
@@ -3532,6 +3544,13 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
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



