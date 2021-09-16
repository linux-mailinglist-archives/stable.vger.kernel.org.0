Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2E540E24E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbhIPQgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244118AbhIPQes (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA6461881;
        Thu, 16 Sep 2021 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809254;
        bh=cHUHS7ylQBndbebOAwQBZXt+puIUFvKgbQ0B7P73eJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/VQMXiIemw+aGNLN/ONJzePpLr7Aq8Bjo4xERk+b27nftvZnJ+zpU5B9drS/2KCi
         SMlPyObTFLdOuo7iibHmHOhFejOi0qXSiwvUVrILCy71/8U1ltCrZA4Ec1J0INoJ4B
         rP53ClXKcoDoEu2rCsekvigZoFFs+Epq9DRNR4nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 088/380] RDMA/mlx5: Delete not-available udata check
Date:   Thu, 16 Sep 2021 17:57:25 +0200
Message-Id: <20210916155807.038426146@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 5f6bb7e32283b8e3339b7adc00638234ac199cc4 ]

XRC_TGT QPs are created through kernel verbs and don't have udata at all.

Fixes: 6eefa839c4dd ("RDMA/mlx5: Protect from kernel crash if XRC_TGT doesn't have udata")
Fixes: e383085c2425 ("RDMA/mlx5: Set ECE options during QP create")
Link: https://lore.kernel.org/r/b68228597e730675020aa5162745390a2d39d3a2.1628014762.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5851486c0d93..2471f48ea5f3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1896,7 +1896,6 @@ static int get_atomic_mode(struct mlx5_ib_dev *dev,
 static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			     struct mlx5_create_qp_params *params)
 {
-	struct mlx5_ib_create_qp *ucmd = params->ucmd;
 	struct ib_qp_init_attr *attr = params->attr;
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
@@ -1916,8 +1915,6 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!in)
 		return -ENOMEM;
 
-	if (MLX5_CAP_GEN(mdev, ece_support) && ucmd)
-		MLX5_SET(create_qp_in, in, ece, ucmd->ece_options);
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_XRC);
-- 
2.30.2



