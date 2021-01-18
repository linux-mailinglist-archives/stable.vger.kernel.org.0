Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E47A2F9F91
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403915AbhARM1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390877AbhARLqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3004B22E00;
        Mon, 18 Jan 2021 11:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970335;
        bh=fvB57iQnjJIvUrvLqVzqPQYyzUtToAI32yr4n9HXUno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by0v1cFEhicWLBqzC0f6iH5unb4niGTQoKrNzrCe3G4ZU10B4fp1dCVXIg5BvIUjt
         rNd0Ty1VToBez0bA8T5q1iDqU9VIC5SmJ3ZxUak91xhuOVWUDnmgnOh4AmMgZBTKPl
         2JVcVz4Yh28y5ZjeAptkRO38Iyvp07SI2EzkgQ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/152] net/mlx5: Fix passing zero to PTR_ERR
Date:   Mon, 18 Jan 2021 12:34:41 +0100
Message-Id: <20210118113357.816585407@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0c4accc41cb56e527c8c049f5495af9f3d6bef7e ]

Fix smatch warnings:

drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c:105 esw_acl_egress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c:177 esw_acl_egress_ofld_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c:184 esw_acl_ingress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c:262 esw_acl_ingress_ofld_setup() warn: passing zero to 'PTR_ERR'

esw_acl_table_create() never returns NULL, so
NULL test should be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index d46f8b225ebe3..2b85d4777303a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -101,7 +101,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
 						 table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
 		vport->egress.acl = NULL;
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index c3faae67e4d6e..4c74e2690d57b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -173,7 +173,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 		table_size++;
 	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
 		vport->egress.acl = NULL;
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b68976b378b81..d64fad2823e73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -180,7 +180,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
 							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 							  table_size);
-		if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+		if (IS_ERR(vport->ingress.acl)) {
 			err = PTR_ERR(vport->ingress.acl);
 			vport->ingress.acl = NULL;
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 4e55d7225a265..548c005ea6335 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -258,7 +258,7 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
 	vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
 						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 						  num_ftes);
-	if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+	if (IS_ERR(vport->ingress.acl)) {
 		err = PTR_ERR(vport->ingress.acl);
 		vport->ingress.acl = NULL;
 		return err;
-- 
2.27.0



