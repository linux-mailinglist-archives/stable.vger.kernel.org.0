Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3F4A9637
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357461AbiBDJYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357658AbiBDJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56DDFB836BA;
        Fri,  4 Feb 2022 09:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA64C004E1;
        Fri,  4 Feb 2022 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966593;
        bh=KVLgj1pVHVHJjqdICEXZNOLtZ4RDheMZu0wqlDTKP2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NLDoPMbyN098GeqKn9QTS+pt2fjY/DvSD5L3SdhRgkv4ZkNxwChN+QltMBhPWqW6
         POKN/ls3IVLoW6nhPlpSntT4h0NOE0ku3viqfVZkO0QzDx9Ng2W09zrSR+p5wHQ2VN
         x4HoKQg1jYDds9gqEnytIcNuFN4SMB23m71lNXJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 12/32] net/mlx5: Bridge, take rtnl lock in init error handler
Date:   Fri,  4 Feb 2022 10:22:22 +0100
Message-Id: <20220204091915.668942966@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 04f8c12f031fcd0ffa0c72822eb665ceb2c872e7 upstream.

The mlx5_esw_bridge_cleanup() is expected to be called with rtnl lock
taken, which is true for mlx5e_rep_bridge_cleanup() function but not for
error handling code in mlx5e_rep_bridge_init(). Add missing rtnl
lock/unlock calls and extend both mlx5_esw_bridge_cleanup() and its dual
function mlx5_esw_bridge_init() with ASSERT_RTNL() to verify the invariant
from now on.

Fixes: 7cd6a54a8285 ("net/mlx5: Bridge, handle FDB events")
Fixes: 19e9bfa044f3 ("net/mlx5: Bridge, add offload infrastructure")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c |    2 ++
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c    |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -509,7 +509,9 @@ err_register_swdev_blk:
 err_register_swdev:
 	destroy_workqueue(br_offloads->wq);
 err_alloc_wq:
+	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
+	rtnl_unlock();
 }
 
 void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1385,6 +1385,8 @@ struct mlx5_esw_bridge_offloads *mlx5_es
 {
 	struct mlx5_esw_bridge_offloads *br_offloads;
 
+	ASSERT_RTNL();
+
 	br_offloads = kvzalloc(sizeof(*br_offloads), GFP_KERNEL);
 	if (!br_offloads)
 		return ERR_PTR(-ENOMEM);
@@ -1401,6 +1403,8 @@ void mlx5_esw_bridge_cleanup(struct mlx5
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = esw->br_offloads;
 
+	ASSERT_RTNL();
+
 	if (!br_offloads)
 		return;
 


