Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56105412502
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346515AbhITSlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381640AbhITSjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24F7D63326;
        Mon, 20 Sep 2021 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159020;
        bh=hjQw1FsWVyVIKSRoQkKjd5yOzPMsspegKkmUG41isls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzjdNEEToXcPB/NhuqOi152aAmdX0ItPO4MPvx8YElR9CikuD+pUG4/UfOuVXSWba
         +VYBu5sH8M9HZp6gpJbDdbVqsxe6iUJbw0zpraZlcyrx75l1eEFoevPU7a3Nqwqp/E
         KCYxIsz4d9893FBT1rWpiyNG31WSA0JqX4/g4CC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 040/168] net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert
Date:   Mon, 20 Sep 2021 18:42:58 +0200
Message-Id: <20210920163922.968661000@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit 7c3a0a018e672a9723a79b128227272562300055 upstream.

Remove the assert from the callback priv lookup function since it does
not require RTNL lock and is already protected by flow_indr_block_lock.

This will avoid warnings from being emitted to dmesg if the driver
registers its callback after an ingress qdisc was created for a
netdevice.

The warnings started after the following patch was merged:
commit 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation")

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        |    3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c |    3 ---
 drivers/net/ethernet/netronome/nfp/flower/offload.c |    3 ---
 3 files changed, 9 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1870,9 +1870,6 @@ bnxt_tc_indr_block_cb_lookup(struct bnxt
 {
 	struct bnxt_flower_indr_block_cb_priv *cb_priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv, &bp->tc_indr_block_list, list)
 		if (cb_priv->tunnel_netdev == netdev)
 			return cb_priv;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -300,9 +300,6 @@ mlx5e_rep_indr_block_priv_lookup(struct
 {
 	struct mlx5e_rep_indr_block_priv *cb_priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv,
 			    &rpriv->uplink_priv.tc_indr_block_priv_list,
 			    list)
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1766,9 +1766,6 @@ nfp_flower_indr_block_cb_priv_lookup(str
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv, &priv->indr_block_cb_priv, list)
 		if (cb_priv->netdev == netdev)
 			return cb_priv;


