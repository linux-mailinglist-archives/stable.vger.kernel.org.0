Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D62C0660
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgKWMaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730174AbgKWMaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEFCF20781;
        Mon, 23 Nov 2020 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134620;
        bh=clg1+zrT/LuJy0gXr7l9ya3nSm9jjmNISWBbNCRAF7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNP9opU7FCvPbyT+kZ4N8AJ/Xux15t6KrDziLcYBTP1fcVuuxeLNq7NCgHAHWJgVb
         4EmD0ldYQlNb9bgJoddry/wSjYBuYSLIoDTQLb7BXsvyC1MW8pbJQuBKTf0pL6QQWb
         EhX0f6xWG+pRANla28cGm8bua+phzH0eBToHUjgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.19 23/91] net/mlx5: Disable QoS when min_rates on all VFs are zero
Date:   Mon, 23 Nov 2020 13:21:43 +0100
Message-Id: <20201123121810.440243791@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

[ Upstream commit 470b74758260e4abc2508cf1614573c00a00465c ]

Currently when QoS is enabled for VF and any min_rate is configured,
the driver sets bw_share value to at least 1 and doesn’t allow to set
it to 0 to make minimal rate unlimited. It means there is always a
minimal rate configured for every VF, even if user tries to remove it.

In order to make QoS disable possible, check whether all vports have
configured min_rate = 0. If this is true, set their bw_share to 0 to
disable min_rate limitations.

Fixes: c9497c98901c ("net/mlx5: Add support for setting VF min rate")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1999,12 +1999,15 @@ static u32 calculate_vports_min_rate_div
 		max_guarantee = evport->info.min_rate;
 	}
 
-	return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+	if (max_guarantee)
+		return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+	return 0;
 }
 
-static int normalize_vports_min_rate(struct mlx5_eswitch *esw, u32 divider)
+static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 {
 	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
+	u32 divider = calculate_vports_min_rate_divider(esw);
 	struct mlx5_vport *evport;
 	u32 vport_max_rate;
 	u32 vport_min_rate;
@@ -2018,9 +2021,9 @@ static int normalize_vports_min_rate(str
 			continue;
 		vport_min_rate = evport->info.min_rate;
 		vport_max_rate = evport->info.max_rate;
-		bw_share = MLX5_MIN_BW_SHARE;
+		bw_share = 0;
 
-		if (vport_min_rate)
+		if (divider)
 			bw_share = MLX5_RATE_TO_BW_SHARE(vport_min_rate,
 							 divider,
 							 fw_max_bw_share);
@@ -2045,7 +2048,6 @@ int mlx5_eswitch_set_vport_rate(struct m
 	struct mlx5_vport *evport;
 	u32 fw_max_bw_share;
 	u32 previous_min_rate;
-	u32 divider;
 	bool min_rate_supported;
 	bool max_rate_supported;
 	int err = 0;
@@ -2071,8 +2073,7 @@ int mlx5_eswitch_set_vport_rate(struct m
 
 	previous_min_rate = evport->info.min_rate;
 	evport->info.min_rate = min_rate;
-	divider = calculate_vports_min_rate_divider(esw);
-	err = normalize_vports_min_rate(esw, divider);
+	err = normalize_vports_min_rate(esw);
 	if (err) {
 		evport->info.min_rate = previous_min_rate;
 		goto unlock;


