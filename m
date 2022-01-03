Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5384832A8
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiACOaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiACO2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699D4C061399;
        Mon,  3 Jan 2022 06:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25577B80EF2;
        Mon,  3 Jan 2022 14:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EF5C36AED;
        Mon,  3 Jan 2022 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220101;
        bh=XKKH8JoHfQVTF5KbB/pe/zsyDC/ro29/0FUbnE2oJ6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w55N5olYDBneTpEnGRgbY1Bti98RK7esJk8kEdCpOoB03fUZ4EQPvRCr+W8nnqIe4
         GC2sR3nrZASEgu0DrsM/QnV5ysGKbPaR/5EyJOFlK/C/2Mnz/F5LqkWCGlCOyPiQzT
         BE8eCAyStdbIfybZeuoR8SUYzeKWvs8yAELgcIt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/48] net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
Date:   Mon,  3 Jan 2022 15:23:48 +0100
Message-Id: <20220103142053.852945814@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
index 00d861361428f..16a7c7ec5e138 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include <linux/mlx5/eswitch.h>
+#include <linux/err.h>
 #include "dr_types.h"
 
 #define DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, dmn_type)	\
@@ -69,9 +70,9 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
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



