Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845471236B7
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfLQULK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbfLQULJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2AB206D7;
        Tue, 17 Dec 2019 20:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613469;
        bh=xk4AubQYrKTt1vCB1UNrVC+nmPFXWArsw6xCJ2pjhCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+RJczFHM8lxLNaUy64irc6oO1Iep/A/jFOrkYH0MG/SErcQlVG4gD9lc7HycvZYB
         jut/UrdB9ZT2QHG8tBbJ9uztMcsCAHzzaxHHj5tgc1w1sJ1OMuVsEE4rOLyORPU/OG
         K6XyzGer1zdj///FR8vpEiDAXejTdYAeun+0kEuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 32/37] net/mlx5e: ethtool, Fix analysis of speed setting
Date:   Tue, 17 Dec 2019 21:09:53 +0100
Message-Id: <20191217200733.948036274@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 3d7cadae51f1b7f28358e36d0a1ce3f0ae2eee60 ]

When setting speed to 100G via ethtool (AN is set to off), only 25G*4 is
configured while the user, who has an advanced HW which supports
extended PTYS, expects also 50G*2 to be configured.
With this patch, when extended PTYS mode is available, configure
PTYS via extended fields.

Fixes: 4b95840a6ced ("net/mlx5e: Fix matching of speed to PRM link modes")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1027,18 +1027,11 @@ static bool ext_link_mode_requested(cons
 	return bitmap_intersects(modes, adver, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static bool ext_speed_requested(u32 speed)
-{
-#define MLX5E_MAX_PTYS_LEGACY_SPEED 100000
-	return !!(speed > MLX5E_MAX_PTYS_LEGACY_SPEED);
-}
-
-static bool ext_requested(u8 autoneg, const unsigned long *adver, u32 speed)
+static bool ext_requested(u8 autoneg, const unsigned long *adver, bool ext_supported)
 {
 	bool ext_link_mode = ext_link_mode_requested(adver);
-	bool ext_speed = ext_speed_requested(speed);
 
-	return  autoneg == AUTONEG_ENABLE ? ext_link_mode : ext_speed;
+	return  autoneg == AUTONEG_ENABLE ? ext_link_mode : ext_supported;
 }
 
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
@@ -1065,8 +1058,8 @@ int mlx5e_ethtool_set_link_ksettings(str
 	autoneg = link_ksettings->base.autoneg;
 	speed = link_ksettings->base.speed;
 
-	ext = ext_requested(autoneg, adver, speed),
 	ext_supported = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = ext_requested(autoneg, adver, ext_supported);
 	if (!ext_supported && ext)
 		return -EOPNOTSUPP;
 


