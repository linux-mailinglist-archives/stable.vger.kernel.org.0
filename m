Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753DE48325A
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiACO1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56980 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiACO0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720A561117;
        Mon,  3 Jan 2022 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3645C36AED;
        Mon,  3 Jan 2022 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219983;
        bh=LN+Jf5eSgcC4gmjL3EFFWijqbDreop8bspznNPb1p8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co0h37WKlEpAPcLTPdNiYHTDykSV5TzDrfd69VOdALM1Gu0nwPMDZOZ1QL1AtwB9t
         uiSU/6E6uvKkpW2cOjnWHNfCVH8fAHh9i2D9R6+h0rgZds3J+t2VyEyizVxKxOJhCH
         xjojGZjQTPdUHEudm+Fb+GKyd5UQ2oitjoaTqdFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/37] net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
Date:   Mon,  3 Jan 2022 15:23:49 +0100
Message-Id: <20220103142052.226942537@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6b8b42585886c59a008015083282aae434349094 ]

The mlx5_get_uars_page() function  returns error pointers.
Using IS_ERR() to check the return value to fix this.

Fixes: 4ec9e7b02697 ("net/mlx5: DR, Expose steering domain functionality")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 56bf900eb753f..dbdb6a9592f09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include <linux/mlx5/eswitch.h>
+#include <linux/err.h>
 #include "dr_types.h"
 
 static int dr_domain_init_cache(struct mlx5dr_domain *dmn)
@@ -64,9 +65,9 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	}
 
 	dmn->uar = mlx5_get_uars_page(dmn->mdev);
-	if (!dmn->uar) {
+	if (IS_ERR(dmn->uar)) {
 		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(dmn->uar);
 		goto clean_pd;
 	}
 
-- 
2.34.1



