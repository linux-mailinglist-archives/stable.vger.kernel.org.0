Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF9428F83
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhJKN7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238050AbhJKN6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C99CE61105;
        Mon, 11 Oct 2021 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960479;
        bh=5j3Deu0c6EsoGoCN0WWehsfjrLouSlTkZlGLA1NTIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RP2DN7nk2tsJWyj2OxOcH07pZQba9fu3PL++QITOwpaWPFxtTnlLvCISoXEdDlPjn
         89q0lbWZqxQlDEwMKcoGPQFXA4b6q4TopvKFrLdQgVSNBTkkkRu9W1bLCuiNuWZ63F
         OtrByDjlT0oesTankKSR99hraWz2QSmQx2zGxCJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/83] net/mlx5: E-Switch, Fix double allocation of acl flow counter
Date:   Mon, 11 Oct 2021 15:45:59 +0200
Message-Id: <20211011134509.741545505@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit a586775f83bd729ad60b56352dbe067f4bb0beee ]

Flow counter is allocated in eswitch legacy acl setting functions
without checking if already allocated by previous setting. Add a check
to avoid such double allocation.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Fixes: ea651a86d468 ("net/mlx5: E-Switch, Refactor eswitch egress acl codes")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c         | 12 ++++++++----
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c        |  4 +++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 3e19b1721303..b00c7d47833f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -79,12 +79,16 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	int dest_num = 0;
 	int err = 0;
 
-	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
+	if (vport->egress.legacy.drop_counter) {
+		drop_counter = vport->egress.legacy.drop_counter;
+	} else if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
 		drop_counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(drop_counter))
+		if (IS_ERR(drop_counter)) {
 			esw_warn(esw->dev,
 				 "vport[%d] configure egress drop rule counter err(%ld)\n",
 				 vport->vport, PTR_ERR(drop_counter));
+			drop_counter = NULL;
+		}
 		vport->egress.legacy.drop_counter = drop_counter;
 	}
 
@@ -123,7 +127,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	/* Attach egress drop flow counter */
-	if (!IS_ERR_OR_NULL(drop_counter)) {
+	if (drop_counter) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 		drop_ctr_dst.counter_id = mlx5_fc_id(drop_counter);
@@ -162,7 +166,7 @@ void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw,
 	esw_acl_egress_table_destroy(vport);
 
 clean_drop_counter:
-	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_counter)) {
+	if (vport->egress.legacy.drop_counter) {
 		mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
 		vport->egress.legacy.drop_counter = NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index d64fad2823e7..45570d0a58d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -160,7 +160,9 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 
 	esw_acl_ingress_lgcy_rules_destroy(vport);
 
-	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
+	if (vport->ingress.legacy.drop_counter) {
+		counter = vport->ingress.legacy.drop_counter;
+	} else if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
 		counter = mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(counter)) {
 			esw_warn(esw->dev,
-- 
2.33.0



