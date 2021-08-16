Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C283ED637
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbhHPNSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239125AbhHPNQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38302632D6;
        Mon, 16 Aug 2021 13:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119586;
        bh=a5NxpVOs8tEEVyWD+DqEBIFKvfNhI2V3ZCzYtKsfI4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjyVBeK3ibyEb/ln8z5YRZ5xdNuKPfLMZehxGJLEAa6Z9KJA+Q9A40nVvkvEJuojS
         BL6iOqmT0sGW/hDAb4lxeiNDgAXxl+cA109G+HqhRS85SwKh6iyMFxajl60amCpj/S
         TnUqz/PBMQCSacrM7cBLRhkzwuuDKm3JMxRUGmSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 083/151] net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free
Date:   Mon, 16 Aug 2021 15:01:53 +0200
Message-Id: <20210816125446.809987670@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 8ba3e4c85825c8801a2c298dcadac650a40d7137 ]

mlx5e_close_xdpsq does the cleanup: it calls mlx5e_free_xdpsq_descs to
free the outstanding descriptors, which relies on
mlx5e_page_release_dynamic and page_pool_release_page. However,
page_pool_destroy is already called by this point, because
mlx5e_close_rq runs before mlx5e_close_xdpsq.

This commit fixes the use-after-free by swapping mlx5e_close_xdpsq and
mlx5e_close_rq.

The commit cited below started calling page_pool_destroy directly from
the driver. Previously, the page pool was destroyed under a call_rcu
from xdp_rxq_info_unreg_mem_model, which would defer the deallocation
until after the XDPSQ is cleaned up.

Fixes: 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d0d9acb17253..3221a6a2f221 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1887,30 +1887,30 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_icosq;
 
+	err = mlx5e_open_rxq_rq(c, params, &cparam->rq);
+	if (err)
+		goto err_close_sqs;
+
 	if (c->xdp) {
 		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL,
 				       &c->rq_xdpsq, false);
 		if (err)
-			goto err_close_sqs;
+			goto err_close_rq;
 	}
 
-	err = mlx5e_open_rxq_rq(c, params, &cparam->rq);
-	if (err)
-		goto err_close_xdp_sq;
-
 	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL, &c->xdpsq, true);
 	if (err)
-		goto err_close_rq;
+		goto err_close_xdp_sq;
 
 	return 0;
 
-err_close_rq:
-	mlx5e_close_rq(&c->rq);
-
 err_close_xdp_sq:
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
 
+err_close_rq:
+	mlx5e_close_rq(&c->rq);
+
 err_close_sqs:
 	mlx5e_close_sqs(c);
 
@@ -1945,9 +1945,9 @@ err_close_async_icosq_cq:
 static void mlx5e_close_queues(struct mlx5e_channel *c)
 {
 	mlx5e_close_xdpsq(&c->xdpsq);
-	mlx5e_close_rq(&c->rq);
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
+	mlx5e_close_rq(&c->rq);
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
 	mlx5e_close_icosq(&c->async_icosq);
-- 
2.30.2



