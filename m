Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2B3A02AD
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhFHTHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237836AbhFHTFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3641D60FF0;
        Tue,  8 Jun 2021 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177997;
        bh=4xZtuIkxkFj39vFb9hA5HLfSFea0VlgJ2Mq9LqhotcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWR1K000qTHf7OPLT+KQbDgyKtpnkrAwxGnE9B70KOhhztqmNvLa0ArzsJyJnk+ap
         eKmQwek+GPs+gFfKUgGJxs/PEWTE4Yual4QO39JbYDwlLWA4orNSC+sBZn7aUNGI9k
         mogwOM02p9BFbpwqo9wbbbTlEpFMEwsJJt36nopI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 038/161] net/mlx5: DR, Create multi-destination flow table with level less than 64
Date:   Tue,  8 Jun 2021 20:26:08 +0200
Message-Id: <20210608175946.752059342@linuxfoundation.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 216214c64a8c1cb9078c2c0aec7bb4a2f8e75397 ]

Flow table that contains flow pointing to multiple flow tables or multiple
TIRs must have a level lower than 64. In our case it applies to muli-
destination flow table.
Fix the level of the created table to comply with HW Spec definitions, and
still make sure that its level lower than SW-owned tables, so that it
would be possible to point from the multi-destination FW table to SW
tables.

Fixes: 34583beea4b7 ("net/mlx5: DR, Create multi-destination table for SW-steering use")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c | 3 ++-
 include/linux/mlx5/mlx5_ifc.h                            | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 1fbcd012bb85..7ccfd40586ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -112,7 +112,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	int ret;
 
 	ft_attr.table_type = MLX5_FLOW_TABLE_TYPE_FDB;
-	ft_attr.level = dmn->info.caps.max_ft_level - 2;
+	ft_attr.level = min_t(int, dmn->info.caps.max_ft_level - 2,
+			      MLX5_FT_MAX_MULTIPATH_LEVEL);
 	ft_attr.reformat_en = reformat_req;
 	ft_attr.decap_en = reformat_req;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9c68b2da14c6..e5a4c68093fc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1260,6 +1260,8 @@ enum mlx5_fc_bulk_alloc_bitmask {
 
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum))
 
+#define MLX5_FT_MAX_MULTIPATH_LEVEL 63
+
 enum {
 	MLX5_STEERING_FORMAT_CONNECTX_5   = 0,
 	MLX5_STEERING_FORMAT_CONNECTX_6DX = 1,
-- 
2.30.2



