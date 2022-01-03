Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BB64832A9
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiACOaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiACO23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE6C06139A;
        Mon,  3 Jan 2022 06:28:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9DCE61123;
        Mon,  3 Jan 2022 14:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB85C36AEE;
        Mon,  3 Jan 2022 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220108;
        bh=JTTUVMZBrmRNrOFx/pyP0vd6l07ERuv+Iaf514Nff0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQYkbypo8PxeQ9y4V8UXQnOTFsslicAbQTNNtUTSkncmmtFsja9No4wwgcn0iPj8E
         AGDM5zu7QpccAU35opiweYaaOhPTcUaDowfETDiNF6fCewjdkrCEtvL4zMTzXSaU21
         czq8U4YYP6LhyFoG8O+BXw90At4hlM53sRjno5lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/48] net/mlx5e: Fix ICOSQ recovery flow for XSK
Date:   Mon,  3 Jan 2022 15:23:50 +0100
Message-Id: <20220103142053.919560843@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 19c4aba2d4e23997061fb11aed8a3e41334bfa14 ]

There are two ICOSQs per channel: one is needed for RX, and the other
for async operations (XSK TX, kTLS offload). Currently, the recovery
flow for both is the same, and async ICOSQ is mistakenly treated like
the regular ICOSQ.

This patch prevents running the regular ICOSQ recovery on async ICOSQ.
The purpose of async ICOSQ is to handle XSK wakeup requests and post
kTLS offload RX parameters, it has nothing to do with RQ and XSKRQ UMRs,
so the regular recovery sequence is not applicable here.

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 --
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 ++++++++++++++-----
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 9da34f82d4668..73060b30fece3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -916,9 +916,6 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
 
 struct mlx5e_sq_param;
-int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq);
-void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6ec4b96497ffb..3f5a2bb9b3c0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1051,9 +1051,20 @@ static void mlx5e_icosq_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_icosq_cqe_err(sq);
 }
 
+static void mlx5e_async_icosq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_icosq *sq = container_of(recover_work, struct mlx5e_icosq,
+					      recover_work);
+
+	/* Not implemented yet. */
+
+	netdev_warn(sq->channel->netdev, "async_icosq recovery is not implemented\n");
+}
+
 static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 			     struct mlx5e_sq_param *param,
-			     struct mlx5e_icosq *sq)
+			     struct mlx5e_icosq *sq,
+			     work_func_t recover_work_func)
 {
 	void *sqc_wq               = MLX5_ADDR_OF(sqc, param->sqc, wq);
 	struct mlx5_core_dev *mdev = c->mdev;
@@ -1073,7 +1084,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	if (err)
 		goto err_sq_wq_destroy;
 
-	INIT_WORK(&sq->recover_work, mlx5e_icosq_err_cqe_work);
+	INIT_WORK(&sq->recover_work, recover_work_func);
 
 	return 0;
 
@@ -1423,13 +1434,14 @@ static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_tx_err_cqe(sq);
 }
 
-int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq)
+static int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+			    struct mlx5e_sq_param *param, struct mlx5e_icosq *sq,
+			    work_func_t recover_work_func)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
 
-	err = mlx5e_alloc_icosq(c, param, sq);
+	err = mlx5e_alloc_icosq(c, param, sq, recover_work_func);
 	if (err)
 		return err;
 
@@ -1459,7 +1471,7 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 	synchronize_net(); /* Sync with NAPI. */
 }
 
-void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
@@ -1862,11 +1874,13 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	spin_lock_init(&c->async_icosq_lock);
 
-	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq);
+	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq,
+			       mlx5e_async_icosq_err_cqe_work);
 	if (err)
 		goto err_disable_napi;
 
-	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq,
+			       mlx5e_icosq_err_cqe_work);
 	if (err)
 		goto err_close_async_icosq;
 
-- 
2.34.1



