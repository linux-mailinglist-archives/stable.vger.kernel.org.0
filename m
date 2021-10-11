Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EC3429033
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhJKOF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240635AbhJKODy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D7E60F21;
        Mon, 11 Oct 2021 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960736;
        bh=5wBNvFoK9qNHxrYVpshS3oK74lEfKOk8ApkMScfI4i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRpllRzjvNlwcx/zeXZftV6k0zjvKKVo4mWH99KBW1I7hyMjyhIf8f2tr2qsz5jYw
         x4eIVQyObUSW+DAoeG8ksY51v/vkXNrmRSDLD6nRhFxuC7IeY/Bj3nQUXRfkHZHr7q
         R+YDyg1OvaOyrdSk95ylAHFD2nhM3oTeTzMx6Qrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 060/151] net/mlx5: E-Switch, Fix double allocation of acl flow counter
Date:   Mon, 11 Oct 2021 15:45:32 +0200
Message-Id: <20211011134519.784642203@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 0399a396d166..60a73990017c 100644
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
index f75b86abaf1c..b1a5199260f6 100644
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



