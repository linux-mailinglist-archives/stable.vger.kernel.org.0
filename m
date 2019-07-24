Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A431C73D67
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403918AbfGXTut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391237AbfGXTuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:50:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27E6C21873;
        Wed, 24 Jul 2019 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997845;
        bh=h46tTBy1jDObjGMx8TOvjf/Yq0nJPoA42gT/VMcxr+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaYYX3IUv5Y/L7guG99t1aqHZrslxf5NSGMyyz7QujBaVTd+loL/XWnAP5FEdHvyi
         UMdeP2epCukoUXLbR4flLfGVM2ibOQdzp8mOIV7gsaIwo4MXyW92JIDdUxOzSyi07E
         Xiq33mTL1hVRu12LZ5LI0DNj42eGwB3cIDbCNM+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 161/371] net/mlx5: Get vport ACL namespace by vport index
Date:   Wed, 24 Jul 2019 21:18:33 +0200
Message-Id: <20190724191737.286066789@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f53297d67800feb5fafd94abd926c889aefee690 ]

The ingress and egress ACL root namespaces are created per vport and
stored into arrays. However, the vport number is not the same as the
index. Passing the array index, instead of vport number, to get the
correct ingress and egress acl namespace.

Fixes: 9b93ab981e3b ("net/mlx5: Separate ingress/egress namespaces for each vport")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8a67fd197b79..16ed6ebd31ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -950,7 +950,7 @@ static int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_EGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch egress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
@@ -1068,7 +1068,7 @@ static int esw_vport_enable_ingress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
-- 
2.20.1



