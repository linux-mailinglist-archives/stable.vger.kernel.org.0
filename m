Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A5F1CAF40
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgEHMpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbgEHMpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEC6208D6;
        Fri,  8 May 2020 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941907;
        bh=PUr3uH0AHu0wFvYj/i0MrGyFlABNh9/CbaR9bu+KCUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVQ4odx7M5n4dX52g+bIU82P9H6N4/zYGvoPk9E9Ra4yU9wrQw583JfRWP6xoean6
         pYa29/pFbc+/2Q3AWPU6OOxEwqHalbyk/t8HH9Xg6SAxQVGBNhmFR0da2maCMluM5Y
         Tr97UhycFQNdMuj4ND9k0W7db+lvtCdAv4pJ4qVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 219/312] net/mlx4_en: Fix potential deadlock in port statistics flow
Date:   Fri,  8 May 2020 14:33:30 +0200
Message-Id: <20200508123139.863584088@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit d2582a03939ed0a80ffcd3ea5345505bc8067c54 upstream.

mlx4_en_DUMP_ETH_STATS took the *counter mutex* and then
called the FW command, with WRAPPED attribute. As a result, the fw command
is wrapped on the Hypervisor when it calls mlx4_en_DUMP_ETH_STATS.
The FW command wrapper flow on the hypervisor takes the *slave_cmd_mutex*
during processing.

At the same time, a VF could be in the process of coming up, and could
call mlx4_QUERY_FUNC_CAP.  On the hypervisor, the command flow takes the
*slave_cmd_mutex*, then executes mlx4_QUERY_FUNC_CAP_wrapper.
mlx4_QUERY_FUNC_CAP wrapper calls mlx4_get_default_counter_index(),
which takes the *counter mutex*. DEADLOCK.

The fix is that the DUMP_ETH_STATS fw command should be called with
the NATIVE attribute, so that on the hypervisor, this command does not
enter the wrapper flow.

Since the Hypervisor no longer goes through the wrapper code, we also
simply return 0 in mlx4_DUMP_ETH_STATS_wrapper (i.e.the function succeeds,
but the returned data will be all zeroes).
No need to test if it is the Hypervisor going through the wrapper.

Fixes: f9baff509f8a ("mlx4_core: Add "native" argument to mlx4_cmd ...")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_port.c |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    2 --
 drivers/net/ethernet/mellanox/mlx4/port.c    |   13 +------------
 3 files changed, 3 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_port.c
@@ -164,7 +164,7 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_e
 		return PTR_ERR(mailbox);
 	err = mlx4_cmd_box(mdev->dev, 0, mailbox->dma, in_mod, 0,
 			   MLX4_CMD_DUMP_ETH_STATS, MLX4_CMD_TIME_CLASS_B,
-			   MLX4_CMD_WRAPPED);
+			   MLX4_CMD_NATIVE);
 	if (err)
 		goto out;
 
@@ -325,7 +325,7 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_e
 		err = mlx4_cmd_box(mdev->dev, 0, mailbox->dma,
 				   in_mod | MLX4_DUMP_ETH_STATS_FLOW_CONTROL,
 				   0, MLX4_CMD_DUMP_ETH_STATS,
-				   MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
+				   MLX4_CMD_TIME_CLASS_B, MLX4_CMD_NATIVE);
 		if (err)
 			goto out;
 	}
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1313,8 +1313,6 @@ int mlx4_SET_VLAN_FLTR_wrapper(struct ml
 			       struct mlx4_cmd_info *cmd);
 int mlx4_common_set_vlan_fltr(struct mlx4_dev *dev, int function,
 				     int port, void *buf);
-int mlx4_common_dump_eth_stats(struct mlx4_dev *dev, int slave, u32 in_mod,
-				struct mlx4_cmd_mailbox *outbox);
 int mlx4_DUMP_ETH_STATS_wrapper(struct mlx4_dev *dev, int slave,
 				   struct mlx4_vhcr *vhcr,
 				   struct mlx4_cmd_mailbox *inbox,
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -1155,24 +1155,13 @@ int mlx4_SET_VLAN_FLTR_wrapper(struct ml
 	return err;
 }
 
-int mlx4_common_dump_eth_stats(struct mlx4_dev *dev, int slave,
-			       u32 in_mod, struct mlx4_cmd_mailbox *outbox)
-{
-	return mlx4_cmd_box(dev, 0, outbox->dma, in_mod, 0,
-			    MLX4_CMD_DUMP_ETH_STATS, MLX4_CMD_TIME_CLASS_B,
-			    MLX4_CMD_NATIVE);
-}
-
 int mlx4_DUMP_ETH_STATS_wrapper(struct mlx4_dev *dev, int slave,
 				struct mlx4_vhcr *vhcr,
 				struct mlx4_cmd_mailbox *inbox,
 				struct mlx4_cmd_mailbox *outbox,
 				struct mlx4_cmd_info *cmd)
 {
-	if (slave != dev->caps.function)
-		return 0;
-	return mlx4_common_dump_eth_stats(dev, slave,
-					  vhcr->in_modifier, outbox);
+	return 0;
 }
 
 int mlx4_get_slave_from_roce_gid(struct mlx4_dev *dev, int port, u8 *gid,


