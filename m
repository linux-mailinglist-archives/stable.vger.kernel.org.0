Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2976D28962
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbfEWTfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391334AbfEWT00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC712054F;
        Thu, 23 May 2019 19:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639586;
        bh=ohi96GrQJW1etsYjYNksG5b5OIcpsBj69l3XFpp8G7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5AkAkV9sjiubOeQVkwB7WECxxoBC5skOBY5R9LJnnjR06D5v0KgtQrAm01wQfPbe
         abM7St27vtnPCSI6/E04Yb4cdsIEamnDG9N8cQb/fOgfocWIECcTswYD+fGSCT4xG1
         MdIVHFhwTuipI5CGR881mzZLBCwfvvNU5uZREY1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Gavi Teitz <gavi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 020/122] net/mlx5e: Add missing ethtool driver info for representors
Date:   Thu, 23 May 2019 21:05:42 +0200
Message-Id: <20190523181707.480253543@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit cf83c8fdcd4756644595521f48748ec22f7efede ]

For all representors added firmware version info to show in
ethtool driver info.
For uplink representor, because only it is tied to the pci device
sysfs, added pci bus info.

Fixes: ff9b85de5d5d ("net/mlx5e: Add some ethtool port control entries to the uplink rep netdev")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -65,9 +65,26 @@ static void mlx5e_rep_indr_unregister_bl
 static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 				  struct ethtool_drvinfo *drvinfo)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+
 	strlcpy(drvinfo->driver, mlx5e_rep_driver_name,
 		sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%04d (%.16s)",
+		 fw_rev_maj(mdev), fw_rev_min(mdev),
+		 fw_rev_sub(mdev), mdev->board_id);
+}
+
+static void mlx5e_uplink_rep_get_drvinfo(struct net_device *dev,
+					 struct ethtool_drvinfo *drvinfo)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	mlx5e_rep_get_drvinfo(dev, drvinfo);
+	strlcpy(drvinfo->bus_info, pci_name(priv->mdev->pdev),
+		sizeof(drvinfo->bus_info));
 }
 
 static const struct counter_desc sw_rep_stats_desc[] = {
@@ -363,7 +380,7 @@ static const struct ethtool_ops mlx5e_vf
 };
 
 static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
-	.get_drvinfo	   = mlx5e_rep_get_drvinfo,
+	.get_drvinfo	   = mlx5e_uplink_rep_get_drvinfo,
 	.get_link	   = ethtool_op_get_link,
 	.get_strings       = mlx5e_rep_get_strings,
 	.get_sset_count    = mlx5e_rep_get_sset_count,


