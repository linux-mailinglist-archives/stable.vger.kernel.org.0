Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D463AEFE6
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhFUQnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232775AbhFUQlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B36B61439;
        Mon, 21 Jun 2021 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293046;
        bh=0NMaKIKGw+mFpmbvt8pntH3Z677ASsHYhlVB7cobfTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NYFmAyp5y+k6chqjFJ91B1GHtATkveYO/8bT8QiunfFb5/ilWwgugRZDG2FlgC5s
         gteG5ceJXwKU75YBOjeyfeqzlKa7J0oC0tP/34oO8tdAP7Kl0zY3WG3rwdJvvpxv6X
         5/uqpoIlt0MKNa03v3EpWjYrfbE2YwpSQMte459Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Amir Tzin <amirtz@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 078/178] net/mlx5: Reset mkey index on creation
Date:   Mon, 21 Jun 2021 18:14:52 +0200
Message-Id: <20210621154925.259222619@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 0232fc2ddcf4ffe01069fd1aa07922652120f44a ]

Reset only the index part of the mkey and keep the variant part. On
devlink reload, driver recreates mkeys, so the mkey index may change.
Trying to preserve the variant part of the mkey, driver mistakenly
merged the mkey index with current value. In case of a devlink reload,
current value of index part is dirty, so the index may be corrupted.

Fixes: 54c62e13ad76 ("{IB,net}/mlx5: Setup mkey variant before mr create command invocation")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 50af84e76fb6..174f71ed5280 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -54,7 +54,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
-	mkey->key |= mlx5_idx_to_mkey(mkey_index);
+	mkey->key = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	init_waitqueue_head(&mkey->wait);
 
-- 
2.30.2



