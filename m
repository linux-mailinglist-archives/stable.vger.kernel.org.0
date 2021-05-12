Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F039C37C553
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhELPjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234528AbhELPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFBBD6194A;
        Wed, 12 May 2021 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832615;
        bh=g8v2ohjAqoDVPLQOw2syeDJ0Nzts78tm8hm/jN+xeMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBmXzfw2WjKkmtl+LYgG6uAnQWR7t0zXrQl9xmyvd+Mhn0rt65cvTEieHXPTK2o7F
         cjoHCMWefzePXlH6mXjGYseeVOY4JEyMsVPeagumw3oTxtGA61rXjKOYhSaIjv95LV
         A/urG6g/BT+nrEwgkulChZIddDCk5sMZVcgH5o4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/530] RDMA/mlx5: Fix mlx5 rates to IB rates map
Date:   Wed, 12 May 2021 16:47:42 +0200
Message-Id: <20210512144831.350724048@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 6fe6e568639859db960c8fcef19a2ece1c2d7eae ]

Correct the map between mlx5 rates and corresponding ib rates, as they
don't always have a fixed offset between them.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20210304124517.1100608-4-leon@kernel.org
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 75caeec378bd..6d2715f65d78 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3079,6 +3079,19 @@ enum {
 	MLX5_PATH_FLAG_COUNTER	= 1 << 2,
 };
 
+static int mlx5_to_ib_rate_map(u8 rate)
+{
+	static const int rates[] = { IB_RATE_PORT_CURRENT, IB_RATE_56_GBPS,
+				     IB_RATE_25_GBPS,	   IB_RATE_100_GBPS,
+				     IB_RATE_200_GBPS,	   IB_RATE_50_GBPS,
+				     IB_RATE_400_GBPS };
+
+	if (rate < ARRAY_SIZE(rates))
+		return rates[rate];
+
+	return rate - MLX5_STAT_RATE_OFFSET;
+}
+
 static int ib_to_mlx5_rate_map(u8 rate)
 {
 	switch (rate) {
@@ -4420,7 +4433,7 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 	rdma_ah_set_path_bits(ah_attr, MLX5_GET(ads, path, mlid));
 
 	static_rate = MLX5_GET(ads, path, stat_rate);
-	rdma_ah_set_static_rate(ah_attr, static_rate ? static_rate - 5 : 0);
+	rdma_ah_set_static_rate(ah_attr, mlx5_to_ib_rate_map(static_rate));
 	if (MLX5_GET(ads, path, grh) ||
 	    ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		rdma_ah_set_grh(ah_attr, NULL, MLX5_GET(ads, path, flow_label),
-- 
2.30.2



