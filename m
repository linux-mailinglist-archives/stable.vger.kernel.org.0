Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100D72BA893
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKTLJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgKTLHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A8AD22255;
        Fri, 20 Nov 2020 11:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870423;
        bh=+iol+aFN0CO2vXPJkY0KGM4F07UaVZTAWUbH7PkV49c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Hq9Al/w+WcWjf1ksHPrMDE7O+hj9jtGCQErwDJE5fD4NYwp5P+flYaKZzBep06+m
         Ots9I6MPqaI8qYM2wh5Zw5aCU9MCxYGcJ+lt5jmepkkOXO8F7pWgn5jcxSAKKMFIe0
         ivUxfx0cdxZ4VsoYJNNYx8yitbu7XNTuNFfq8bMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Timo Rothenpieler <timo@rothenpieler.org>
Subject: [PATCH 5.4 07/17] net/mlx5: Use async EQ setup cleanup helpers for multiple EQs
Date:   Fri, 20 Nov 2020 12:03:34 +0100
Message-Id: <20201120104541.438317105@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

commit 3ed879965cc4ea13fe0908468b653c4ff2cb1309 upstream.

Use helper routines to setup and teardown multiple EQs and reuse the
code in setup, cleanup and error unwinding flows.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  114 +++++++++++----------------
 1 file changed, 49 insertions(+), 65 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -563,6 +563,39 @@ static void gather_async_events_mask(str
 		gather_user_async_events(dev, mask);
 }
 
+static int
+setup_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq_async *eq,
+	       struct mlx5_eq_param *param, const char *name)
+{
+	int err;
+
+	eq->irq_nb.notifier_call = mlx5_eq_async_int;
+
+	err = create_async_eq(dev, &eq->core, param);
+	if (err) {
+		mlx5_core_warn(dev, "failed to create %s EQ %d\n", name, err);
+		return err;
+	}
+	err = mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
+	if (err) {
+		mlx5_core_warn(dev, "failed to enable %s EQ %d\n", name, err);
+		destroy_async_eq(dev, &eq->core);
+	}
+	return err;
+}
+
+static void cleanup_async_eq(struct mlx5_core_dev *dev,
+			     struct mlx5_eq_async *eq, const char *name)
+{
+	int err;
+
+	mlx5_eq_disable(dev, &eq->core, &eq->irq_nb);
+	err = destroy_async_eq(dev, &eq->core);
+	if (err)
+		mlx5_core_err(dev, "failed to destroy %s eq, err(%d)\n",
+			      name, err);
+}
+
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -572,77 +605,45 @@ static int create_async_eqs(struct mlx5_
 	MLX5_NB_INIT(&table->cq_err_nb, cq_err_event_notifier, CQ_ERROR);
 	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
 
-	table->cmd_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
 		.nent = MLX5_NUM_CMD_EQE,
+		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
-
-	param.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD;
-	err = create_async_eq(dev, &table->cmd_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
-		goto err0;
-	}
-	err = mlx5_eq_enable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable cmd EQ %d\n", err);
+	err = setup_async_eq(dev, &table->cmd_eq, &param, "cmd");
+	if (err)
 		goto err1;
-	}
+
 	mlx5_cmd_use_events(dev);
 
-	table->async_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
 		.nent = MLX5_NUM_ASYNC_EQE,
 	};
 
 	gather_async_events_mask(dev, param.mask);
-	err = create_async_eq(dev, &table->async_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
+	err = setup_async_eq(dev, &table->async_eq, &param, "async");
+	if (err)
 		goto err2;
-	}
-	err = mlx5_eq_enable(dev, &table->async_eq.core,
-			     &table->async_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable async EQ %d\n", err);
-		goto err3;
-	}
 
-	table->pages_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
 		.nent = /* TODO: sriov max_vf + */ 1,
+		.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST,
 	};
 
-	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST;
-	err = create_async_eq(dev, &table->pages_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create pages EQ %d\n", err);
-		goto err4;
-	}
-	err = mlx5_eq_enable(dev, &table->pages_eq.core,
-			     &table->pages_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable pages EQ %d\n", err);
-		goto err5;
-	}
+	err = setup_async_eq(dev, &table->pages_eq, &param, "pages");
+	if (err)
+		goto err3;
 
-	return err;
+	return 0;
 
-err5:
-	destroy_async_eq(dev, &table->pages_eq.core);
-err4:
-	mlx5_eq_disable(dev, &table->async_eq.core, &table->async_eq.irq_nb);
 err3:
-	destroy_async_eq(dev, &table->async_eq.core);
+	cleanup_async_eq(dev, &table->async_eq, "async");
 err2:
 	mlx5_cmd_use_polling(dev);
-	mlx5_eq_disable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
+	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 err1:
-	destroy_async_eq(dev, &table->cmd_eq.core);
-err0:
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 	return err;
 }
@@ -650,28 +651,11 @@ err0:
 static void destroy_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	int err;
-
-	mlx5_eq_disable(dev, &table->pages_eq.core, &table->pages_eq.irq_nb);
-	err = destroy_async_eq(dev, &table->pages_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy pages eq, err(%d)\n",
-			      err);
-
-	mlx5_eq_disable(dev, &table->async_eq.core, &table->async_eq.irq_nb);
-	err = destroy_async_eq(dev, &table->async_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy async eq, err(%d)\n",
-			      err);
 
+	cleanup_async_eq(dev, &table->pages_eq, "pages");
+	cleanup_async_eq(dev, &table->async_eq, "async");
 	mlx5_cmd_use_polling(dev);
-
-	mlx5_eq_disable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
-	err = destroy_async_eq(dev, &table->cmd_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy command eq, err(%d)\n",
-			      err);
-
+	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 }
 


