Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB65A48D5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiH2LQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiH2LOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:14:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F0F7268C;
        Mon, 29 Aug 2022 04:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16B761219;
        Mon, 29 Aug 2022 11:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF553C433C1;
        Mon, 29 Aug 2022 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771433;
        bh=tbTXONZcIDODaTeJjGsqkCOrLmAzAOl33LNzXwtVO4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJkQAZpWe6Dc8+sF9839iAT1UYB8XC3TbJXChkbiPRMAo6K6wvZoRvntOAzIL0sfy
         4tNzojD+oIJ+Tl2HmztPVLbF23s4MdeWIJAATfesSg8CAnaSdnjObVb9dG91UrDYMb
         Uc2x4rjDoEu1EAwaAr6VnJ0R5MtVHVUd1w6VZo8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 030/158] net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY
Date:   Mon, 29 Aug 2022 12:58:00 +0200
Message-Id: <20220829105810.050918798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit a6e675a66175869b7d87c0e1dd0ddf93e04f8098 ]

Only set MLX5_LAG_FLAG_NDEVS_READY if both netdevices are registered.
Doing so guarantees that both ldev->pf[MLX5_LAG_P0].dev and
ldev->pf[MLX5_LAG_P1].dev have valid pointers when
MLX5_LAG_FLAG_NDEVS_READY is set.

The core issue is asymmetry in setting MLX5_LAG_FLAG_NDEVS_READY and
clearing it. Setting it is done wrongly when both
ldev->pf[MLX5_LAG_P0].dev and ldev->pf[MLX5_LAG_P1].dev are set;
clearing it is done right when either of ldev->pf[i].netdev is cleared.

Consider the following scenario:
1. PF0 loads and sets ldev->pf[MLX5_LAG_P0].dev to a valid pointer
2. PF1 loads and sets both ldev->pf[MLX5_LAG_P1].dev and
   ldev->pf[MLX5_LAG_P1].netdev with valid pointers. This results in
   MLX5_LAG_FLAG_NDEVS_READY is set.
3. PF0 is unloaded before setting dev->pf[MLX5_LAG_P0].netdev.
   MLX5_LAG_FLAG_NDEVS_READY remains set.

Further execution of mlx5_do_bond() will result in null pointer
dereference when calling mlx5_lag_is_multipath()

This patch fixes the following call trace actually encountered:

[ 1293.475195] BUG: kernel NULL pointer dereference, address: 00000000000009a8
[ 1293.478756] #PF: supervisor read access in kernel mode
[ 1293.481320] #PF: error_code(0x0000) - not-present page
[ 1293.483686] PGD 0 P4D 0
[ 1293.484434] Oops: 0000 [#1] SMP PTI
[ 1293.485377] CPU: 1 PID: 23690 Comm: kworker/u16:2 Not tainted 5.18.0-rc5_for_upstream_min_debug_2022_05_05_10_13 #1
[ 1293.488039] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[ 1293.490836] Workqueue: mlx5_lag mlx5_do_bond_work [mlx5_core]
[ 1293.492448] RIP: 0010:mlx5_lag_is_multipath+0x5/0x50 [mlx5_core]
[ 1293.494044] Code: e8 70 40 ff e0 48 8b 14 24 48 83 05 5c 1a 1b 00 01 e9 19 ff ff ff 48 83 05 47 1a 1b 00 01 eb d7 0f 1f 44 00 00 0f 1f 44 00 00 <48> 8b 87 a8 09 00 00 48 85 c0 74 26 48 83 05 a7 1b 1b 00 01 41 b8
[ 1293.498673] RSP: 0018:ffff88811b2fbe40 EFLAGS: 00010202
[ 1293.500152] RAX: ffff88818a94e1c0 RBX: ffff888165eca6c0 RCX: 0000000000000000
[ 1293.501841] RDX: 0000000000000001 RSI: ffff88818a94e1c0 RDI: 0000000000000000
[ 1293.503585] RBP: 0000000000000000 R08: ffff888119886740 R09: ffff888165eca73c
[ 1293.505286] R10: 0000000000000018 R11: 0000000000000018 R12: ffff88818a94e1c0
[ 1293.506979] R13: ffff888112729800 R14: 0000000000000000 R15: ffff888112729858
[ 1293.508753] FS:  0000000000000000(0000) GS:ffff88852cc40000(0000) knlGS:0000000000000000
[ 1293.510782] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1293.512265] CR2: 00000000000009a8 CR3: 00000001032d4002 CR4: 0000000000370ea0
[ 1293.514001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1293.515806] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 8a66e4585979 ("net/mlx5: Change ownership model for lag")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5d41e19378e09..c520edb942ca5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1234,7 +1234,7 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 	mlx5_ldev_add_netdev(ldev, dev, netdev);
 
 	for (i = 0; i < ldev->ports; i++)
-		if (!ldev->pf[i].dev)
+		if (!ldev->pf[i].netdev)
 			break;
 
 	if (i >= ldev->ports)
-- 
2.35.1



