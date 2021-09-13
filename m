Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D1640958A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343641AbhIMOmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347785AbhIMOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 412E6630ED;
        Mon, 13 Sep 2021 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541373;
        bh=ZGb9RYZACGSnH/PLr/YRLdSupo8QymnCu/qV1lT9CmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=So9lZ7YSmiL1Rlksy61YKCXOpg8iuXKKc2v6W5ntLqiVTp57YSrA+5dEFvPVM0rQb
         4vNpALxppRxq8T+kuOL4jZZiML7FenTq5Fn1ZXYKy9V5Buf1JHxtQEJwebQGSMELGy
         n1IDLeE+OPygxd9ydLnxzahA8DU1NL8FLxZxsh7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 271/334] net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group
Date:   Mon, 13 Sep 2021 15:15:25 +0200
Message-Id: <20210913131122.580842635@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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



