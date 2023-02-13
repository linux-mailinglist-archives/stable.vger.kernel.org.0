Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64C4694978
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjBMO7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjBMO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A181CAF0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CFA00CE1BA1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7715C433EF;
        Mon, 13 Feb 2023 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300321;
        bh=XFM9O43lhkuwDZmHm0WAUxwEfJkPpf8IaJ9eIHLERLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6vtKguKGhDHGfuOipn5jkNjHS+X9nDAQK8BTXUZQrm5XNwTCbdU9rDYCQ8LemWWN
         qRq2zgRa7TQPx2juR6UhYyNAf83wEQeXNxte6Ud+ZZeGaKHxIJMLNDpYEmXnNmzuPo
         WVAdJqJIygj5SpBYQCL7oVP7O83lU1r+yG9prYo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/67] net/mlx5e: IPoIB, Show unknown speed instead of error
Date:   Mon, 13 Feb 2023 15:49:15 +0100
Message-Id: <20230213144733.995380856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 8aa5f171d51c1cb69e5e3106df4dd1a446102823 ]

ethtool is returning an error for unknown speeds for the IPoIB interface:

$ ethtool ib0
netlink error: failed to retrieve link settings
netlink error: Invalid argument
netlink error: failed to retrieve link settings
netlink error: Invalid argument
Settings for ib0:
Link detected: no

After this change, ethtool will return success and show "unknown speed":

$ ethtool ib0
Settings for ib0:
Supported ports: [  ]
Supported link modes:   Not reported
Supported pause frame use: No
Supports auto-negotiation: No
Supported FEC modes: Not reported
Advertised link modes:  Not reported
Advertised pause frame use: No
Advertised auto-negotiation: No
Advertised FEC modes: Not reported
Speed: Unknown!
Duplex: Full
Auto-negotiation: off
Port: Other
PHYAD: 0
Transceiver: internal
Link detected: no

Fixes: eb234ee9d541 ("net/mlx5e: IPoIB, Add support for get_link_ksettings in ethtool")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 0c8594c7df21d..908e5ee1a30fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -172,16 +172,16 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	}
 }
 
-static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
+static u32 mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 {
 	int rate, width;
 
 	rate = mlx5_ptys_rate_enum_to_int(ib_proto_oper);
 	if (rate < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 	width = mlx5_ptys_width_enum_to_int(ib_link_width_oper);
 	if (width < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 
 	return rate * width;
 }
@@ -204,16 +204,13 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
 
 	speed = mlx5i_get_speed_settings(ib_link_width_oper, ib_proto_oper);
-	if (speed < 0)
-		return -EINVAL;
+	link_ksettings->base.speed = speed;
+	link_ksettings->base.duplex = speed == SPEED_UNKNOWN ? DUPLEX_UNKNOWN : DUPLEX_FULL;
 
-	link_ksettings->base.duplex = DUPLEX_FULL;
 	link_ksettings->base.port = PORT_OTHER;
 
 	link_ksettings->base.autoneg = AUTONEG_DISABLE;
 
-	link_ksettings->base.speed = speed;
-
 	return 0;
 }
 
-- 
2.39.0



