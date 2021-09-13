Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659E04092B7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245068AbhIMOPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245093AbhIMOMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D6661ACF;
        Mon, 13 Sep 2021 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540560;
        bh=ZGb9RYZACGSnH/PLr/YRLdSupo8QymnCu/qV1lT9CmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbLct3j9KKx/QvsBKROv6K7ou53raDGSJyApf5MQ8BZ8ZzqR/Cux5A2LuGHKsJCsu
         mVtrC0Fq32IOlHgzUD1MEIH5y7yVLY3jv/zlUhdh1MYipTt7JjRg0FAoLTNasluKXr
         HNEnbUp+F/Ku4L2LJRdxJDuWN23LSVNMkcSofZIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 244/300] net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group
Date:   Mon, 13 Sep 2021 15:15:05 +0200
Message-Id: <20210913131117.594514819@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit ca6891f9b27db7764bba0798202b0a21d0dc909c ]

When indirect forward group is created, flow is added with vhca id but
without setting vhca id valid flag which violates the PRM.

Fix by setting the missing flag, vhca id valid.

Fixes: 34ca65352ddf ("net/mlx5: E-Switch, Indirect table infrastructure")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 3da7becc1069..425c91814b34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -364,6 +364,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	e->fwd_rule = mlx5_add_flow_rules(e->ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(e->fwd_rule)) {
 		mlx5_destroy_flow_group(e->fwd_grp);
-- 
2.30.2



