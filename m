Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20D22F7A2D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbhAOMqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388083AbhAOMh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26EA224F9;
        Fri, 15 Jan 2021 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714235;
        bh=mwH0ttWiRB5uZ0DmLD68k3h0Oj9/rTfXgfEQvevRd7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kauU64nuEBJUTr7/6CNOO1yf543fHgKZP+exztM1JsYq5TvXDDOFAJVThe4HSo+RR
         cxj/mBKJ7qJdkq4kyreu9MXJU4fhYz88uTPzBLkW7m9VMQFCIgSAin4jUMfutXyV5c
         OYbergok0i4xKnoDZ+ZaQNmD0gCrezLdXv9aU8KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 045/103] net/mlx5e: ethtool, Fix restriction of autoneg with 56G
Date:   Fri, 15 Jan 2021 13:27:38 +0100
Message-Id: <20210115122008.241856119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit b1c0aca3d3ddeebeec57ada9c2df9ed647939249 ]

Prior to this patch, configuring speed to 50G with autoneg off over
devices supporting 50G per lane failed.
Support for 50G per lane introduced a new set of link-modes, on which
driver always performed a speed validation as if only legacy link-modes
were configured. Fix driver speed validation to force setting autoneg
over 56G only if in legacy link-mode.

Fixes: 3d7cadae51f1 ("net/mlx5e: ethtool, Fix analysis of speed setting")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1007,6 +1007,22 @@ static int mlx5e_get_link_ksettings(stru
 	return mlx5e_ethtool_get_link_ksettings(priv, link_ksettings);
 }
 
+static int mlx5e_speed_validate(struct net_device *netdev, bool ext,
+				const unsigned long link_modes, u8 autoneg)
+{
+	/* Extended link-mode has no speed limitations. */
+	if (ext)
+		return 0;
+
+	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
+	    autoneg != AUTONEG_ENABLE) {
+		netdev_err(netdev, "%s: 56G link speed requires autoneg enabled\n",
+			   __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static u32 mlx5e_ethtool2ptys_adver_link(const unsigned long *link_modes)
 {
 	u32 i, ptys_modes = 0;
@@ -1100,13 +1116,9 @@ int mlx5e_ethtool_set_link_ksettings(str
 	link_modes = autoneg == AUTONEG_ENABLE ? ethtool2ptys_adver_func(adver) :
 		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
 
-	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
-	    autoneg != AUTONEG_ENABLE) {
-		netdev_err(priv->netdev, "%s: 56G link speed requires autoneg enabled\n",
-			   __func__);
-		err = -EINVAL;
+	err = mlx5e_speed_validate(priv->netdev, ext, link_modes, autoneg);
+	if (err)
 		goto out;
-	}
 
 	link_modes = link_modes & eproto.cap;
 	if (!link_modes) {


