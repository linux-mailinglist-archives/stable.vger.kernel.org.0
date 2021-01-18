Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3198D2F9F90
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391518AbhARM1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390878AbhARLqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89AF82223E;
        Mon, 18 Jan 2021 11:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970338;
        bh=WLUBkwutdD4Jmnv+nSkNYZFBjie6rEJunQHsQPBrnDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A1v62YUMqVRMC+IklFDtNIkuZFC9Vidn2RrVFaVbRYGSbTszBfOFJdB9dziAAEaz
         3BObuBV1g9XWGK+xKrV/XqRYMNqNovvZuLkRghxzPAYfHXqv5HMCJvju/AAIjRt91L
         UHNRZ2tKntKKcln5dpSFMwPBJ5QaD5iC86vMxIv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/152] net/mlx5: E-Switch, fix changing vf VLANID
Date:   Mon, 18 Jan 2021 12:34:42 +0100
Message-Id: <20210118113357.865053250@linuxfoundation.org>
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

From: Alaa Hleihel <alaa@nvidia.com>

[ Upstream commit 25c904b59aaf4816337acd415514b0c47715f604 ]

Adding vf VLANID for the first time, or after having cleared previously
defined VLANID works fine, however, attempting to change an existing vf
VLANID clears the rules on the firmware, but does not add new rules for
the new vf VLANID.

Fix this by changing the logic in function esw_acl_egress_lgcy_setup()
so that it will always configure egress rules.

Fixes: ea651a86d468 ("net/mlx5: E-Switch, Refactor eswitch egress acl codes")
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 2b85d4777303a..3e19b1721303f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -95,22 +95,21 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 		return 0;
 	}
 
-	if (!IS_ERR_OR_NULL(vport->egress.acl))
-		return 0;
-
-	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
-						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						 table_size);
-	if (IS_ERR(vport->egress.acl)) {
-		err = PTR_ERR(vport->egress.acl);
-		vport->egress.acl = NULL;
-		goto out;
+	if (!vport->egress.acl) {
+		vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+							 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
+							 table_size);
+		if (IS_ERR(vport->egress.acl)) {
+			err = PTR_ERR(vport->egress.acl);
+			vport->egress.acl = NULL;
+			goto out;
+		}
+
+		err = esw_acl_egress_lgcy_groups_create(esw, vport);
+		if (err)
+			goto out;
 	}
 
-	err = esw_acl_egress_lgcy_groups_create(esw, vport);
-	if (err)
-		goto out;
-
 	esw_debug(esw->dev,
 		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
-- 
2.27.0



