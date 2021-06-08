Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45BA3A02A6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhFHTHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237788AbhFHTFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ABFF6140C;
        Tue,  8 Jun 2021 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177986;
        bh=QaLUAtuxmVFO9vJ0BgRvVSPB5wiO7/9HXh2m2uaxkZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6UcdroIJq2Bj1k/xT/26jYkhSTdUBjYXC8M0cazaYok9C+EYwv4ASXgQgN/+4NZV
         omRh+4iejcBKMFFN06ZAeyiUw+XFnyPi2oJ/a40D6qQvpa5AIp2J25KcZVzw5r0T0W
         8u9W6c1pkqsaaRjj7TKm0BQWzRJPWthNR7e5a5wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 034/161] net/mlx5e: Fix incompatible casting
Date:   Tue,  8 Jun 2021 20:26:04 +0200
Message-Id: <20210608175946.611181253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit d8ec92005f806dfa7524e9171eca707c0bb1267e ]

Device supports setting of a single fec mode at a time, enforce this
by bitmap_weight == 1. Input from fec command is in u32, avoid cast to
unsigned long and use bitmap_from_arr32 to populate bitmap safely.

Fixes: 4bd9d5070b92 ("net/mlx5e: Enforce setting of a single FEC mode")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 53802e18af90..04b49cb3adb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1632,12 +1632,13 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	unsigned long fec_bitmap;
 	u16 fec_policy = 0;
 	int mode;
 	int err;
 
-	if (bitmap_weight((unsigned long *)&fecparam->fec,
-			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
+	bitmap_from_arr32(&fec_bitmap, &fecparam->fec, sizeof(fecparam->fec) * BITS_PER_BYTE);
+	if (bitmap_weight(&fec_bitmap, ETHTOOL_FEC_LLRS_BIT + 1) > 1)
 		return -EOPNOTSUPP;
 
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
-- 
2.30.2



