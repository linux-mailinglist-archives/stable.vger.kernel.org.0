Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34DD66489B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbjAJSMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbjAJSMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE35B58
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B5576182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BABC433EF;
        Tue, 10 Jan 2023 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374256;
        bh=8CShB19b2PabsZfY8Y3L9yjEV2/BVxGz8vcvw6b9z2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1uZUWwIZ6aQgd2ujmFXYASc7xNKzqh8R1KIyEuZ8Iapnj/fhqe4Ksc2RrKdZtFX8
         YVRXGPaIYJebC4bI108VMgGXZLAXj/gzb6U5hgn9oga8eMl/qzlfkF71t57DPdHEkU
         x/5vLIh8OrQti2gzFAB0pAk9VrVE1H2QzwUDqCQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 073/148] RDMA/mlx5: Fix validation of max_rd_atomic caps for DC
Date:   Tue, 10 Jan 2023 19:02:57 +0100
Message-Id: <20230110180019.528774199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 8de8482fe5732fbef4f5af82bc0c0362c804cd1f ]

Currently, when modifying DC, we validate max_rd_atomic user attribute
against the RC cap, validate against DC. RC and DC QP types have different
device limitations.

This can cause userspace created DC QPs to malfunction.

Fixes: c32a4f296e1d ("IB/mlx5: Add support for DC Initiator QP")
Link: https://lore.kernel.org/r/0c5aee72cea188c3bb770f4207cce7abc9b6fc74.1672231736.git.leonro@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 49 +++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 40d9410ec303..cf953d23d18d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4502,6 +4502,40 @@ static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
 	return false;
 }
 
+static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
+			      int attr_mask, enum ib_qp_type qp_type)
+{
+	int log_max_ra_res;
+	int log_max_ra_req;
+
+	if (qp_type == MLX5_IB_QPT_DCI) {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_dc);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_dc);
+	} else {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_qp);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_qp);
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
+	    attr->max_rd_atomic > log_max_ra_res) {
+		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
+			    attr->max_rd_atomic);
+		return false;
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
+	    attr->max_dest_rd_atomic > log_max_ra_req) {
+		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
+			    attr->max_dest_rd_atomic);
+		return false;
+	}
+	return true;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -4589,21 +4623,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out;
 	}
 
-	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
-	    attr->max_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_res_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
-			    attr->max_rd_atomic);
-		goto out;
-	}
-
-	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
-	    attr->max_dest_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_req_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
-			    attr->max_dest_rd_atomic);
+	if (!validate_rd_atomic(dev, attr, attr_mask, qp_type))
 		goto out;
-	}
 
 	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
 		err = 0;
-- 
2.35.1



