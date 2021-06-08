Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD333A0184
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbhFHSxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235595AbhFHSvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AFDD613D5;
        Tue,  8 Jun 2021 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177595;
        bh=kjZ3YxOZJcyI0h9SmN2ZkFI3plBsGpkHyYBEM5cqhwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=citQaWiWqNp6UQx81f4e+ji+xhus6FDLjeLn5XhXF7YB4zpKZ5XJ3rRqCOHo3a3+x
         Ol2GaOrnmzWUSmx53tMPVF1gEIRINVq+mrGPxJ2sh2ksjW3zhX0CbkDfenY7NNOgNf
         N8cXdis9HBBOPl88YhrWRVpLOypoQw/URsr4uAjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/137] net/mlx5e: Fix incompatible casting
Date:   Tue,  8 Jun 2021 20:26:09 +0200
Message-Id: <20210608175943.403998130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
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
index 986f0d86e94d..bc7c1962f9e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1618,12 +1618,13 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
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



