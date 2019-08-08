Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6A9869C7
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbfHHTKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405334AbfHHTKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF4762184E;
        Thu,  8 Aug 2019 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291447;
        bh=qbNSV5LpJ6X8wxF5fQvOQNQbGWvO5R4qcdZoAG+IbbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoxtGh/TZXFcNVUzV9gDhiqdMtVMCo1W5qM0M9eeEW6w0xQU+GTZxOBiSYJpSL9KL
         pm8XkLRk9vN7pgtnX4p1gY06ghCdYQ6tZeipa+e09Lv38kyR5AMr+g+dUHxPITYUOO
         4dr94fri9YReEUZ/WbkTtyyx5vhM+HDwl2I9fp6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.14 18/33] net/mlx5: Use reversed order when unregister devices
Date:   Thu,  8 Aug 2019 21:05:25 +0200
Message-Id: <20190808190454.512233020@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit 08aa5e7da6bce1a1963f63cf32c2e7ad434ad578 ]

When lag is active, which is controlled by the bonded mlx5e netdev, mlx5
interface unregestering must happen in the reverse order where rdma is
unregistered (unloaded) first, to guarantee all references to the lag
context in hardware is removed, then remove mlx5e netdev interface which
will cleanup the lag context from hardware.

Without this fix during destroy of LAG interface, we observed following
errors:
 * mlx5_cmd_check:752:(pid 12556): DESTROY_LAG(0x843) op_mod(0x0) failed,
   status bad parameter(0x3), syndrome (0xe4ac33)
 * mlx5_cmd_check:752:(pid 12556): DESTROY_LAG(0x843) op_mod(0x0) failed,
   status bad parameter(0x3), syndrome (0xa5aee8).

Fixes: a31208b1e11d ("net/mlx5_core: New init and exit flow for mlx5_core")
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -307,7 +307,7 @@ void mlx5_unregister_device(struct mlx5_
 	struct mlx5_interface *intf;
 
 	mutex_lock(&mlx5_intf_mutex);
-	list_for_each_entry(intf, &intf_list, list)
+	list_for_each_entry_reverse(intf, &intf_list, list)
 		mlx5_remove_device(intf, priv);
 	list_del(&priv->dev_list);
 	mutex_unlock(&mlx5_intf_mutex);


