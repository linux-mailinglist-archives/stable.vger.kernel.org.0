Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2913835C065
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbhDLJNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240264AbhDLJKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66B7561367;
        Mon, 12 Apr 2021 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218301;
        bh=nV6cDdDfbq8HajpWX5guinvcqfILy0DZoAitaaRFBjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBopafI8pVsf+z7sp3J3V7GpxZv6NeRUAq1TknimIkQRsM8TNRThVToNG6DTSUNr8
         OaXUaxjcTjvHE8hKLBEWy6x3WyZacHfB43g4cV1QrF67j+sVo62A6DNqghZ3EpkZq3
         sWhqy3mYEIm3Z9Ymbdl0C6hJvEn1XazFAr5XBH2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/210] net/mlx5: Dont request more than supported EQs
Date:   Mon, 12 Apr 2021 10:40:51 +0200
Message-Id: <20210412084020.857453432@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

[ Upstream commit a7b76002ae78cd230ee652ccdfedf21aa94fcecc ]

Calculating the number of compeltion EQs based on the number of
available IRQ vectors doesn't work now that all async EQs share one IRQ.
Thus the max number of EQs can be exceeded on systems with more than
approximately 256 CPUs. Take this into account when calculating the
number of available completion EQs.

Fixes: 81bfa206032a ("net/mlx5: Use a single IRQ for all async EQs")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index fc0afa03d407..b5f48efebd71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -928,13 +928,24 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 	mutex_unlock(&table->lock);
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#define MLX5_MAX_ASYNC_EQS 4
+#else
+#define MLX5_MAX_ASYNC_EQS 3
+#endif
+
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
+		      MLX5_CAP_GEN(dev, max_num_eqs) :
+		      1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int err;
 
 	eq_table->num_comp_eqs =
-		mlx5_irq_get_num_comp(eq_table->irq_table);
+		min_t(int,
+		      mlx5_irq_get_num_comp(eq_table->irq_table),
+		      num_eqs - MLX5_MAX_ASYNC_EQS);
 
 	err = create_async_eqs(dev);
 	if (err) {
-- 
2.30.2



