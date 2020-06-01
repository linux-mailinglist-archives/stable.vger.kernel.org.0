Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C6A1EACE8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbgFASMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbgFASMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066A32065C;
        Mon,  1 Jun 2020 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035161;
        bh=X4Vix6YPVUIyw1iz0e6YY/zIpwyzq88OBgGY05FuXuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhafV/uQ+6G+Cw1c5MJ7IFwYEKMlpVyRlGW+ebwEobqL5bopPA0q17wpoyzXPwPz2
         JzNKARa7embbdUKwW/FBpMu8n3Jx5hfwu99Tau19QX78D6liodKLpecjFCKfCEzy/n
         JeSdH7PDLkTdeXcKMIUyPnoyG1o4V3z+wZot4HPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 035/177] net/mlx5: Avoid processing commands before cmdif is ready
Date:   Mon,  1 Jun 2020 19:52:53 +0200
Message-Id: <20200601174051.851617812@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

commit f7936ddd35d8b849daf0372770c7c9dbe7910fca upstream.

When driver is reloading during recovery flow, it can't get new commands
till command interface is up again. Otherwise we may get to null pointer
trying to access non initialized command structures.

Add cmdif state to avoid processing commands while cmdif is not ready.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c  |   10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    4 ++++
 include/linux/mlx5/driver.h                    |    9 +++++++++
 3 files changed, 23 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -923,6 +923,7 @@ static void cmd_work_handler(struct work
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
 	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    cmd->state != MLX5_CMDIF_STATE_UP ||
 	    !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
 		u32 drv_synd;
@@ -1712,6 +1713,7 @@ static int cmd_exec(struct mlx5_core_dev
 	opcode = MLX5_GET(mbox_in, in, opcode);
 	if (pci_channel_offline(dev->pdev) ||
 	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    dev->cmd.state != MLX5_CMDIF_STATE_UP ||
 	    !opcode_allowed(&dev->cmd, opcode)) {
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
@@ -1977,6 +1979,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *
 		goto err_free_page;
 	}
 
+	cmd->state = MLX5_CMDIF_STATE_DOWN;
 	cmd->checksum_disabled = 1;
 	cmd->max_reg_cmds = (1 << cmd->log_sz) - 1;
 	cmd->bitmask = (1UL << cmd->max_reg_cmds) - 1;
@@ -2054,3 +2057,10 @@ void mlx5_cmd_cleanup(struct mlx5_core_d
 	dma_pool_destroy(cmd->pool);
 }
 EXPORT_SYMBOL(mlx5_cmd_cleanup);
+
+void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
+			enum mlx5_cmdif_state cmdif_state)
+{
+	dev->cmd.state = cmdif_state;
+}
+EXPORT_SYMBOL(mlx5_cmd_set_state);
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -962,6 +962,8 @@ static int mlx5_function_setup(struct ml
 		goto err_cmd_cleanup;
 	}
 
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
+
 	err = mlx5_core_enable_hca(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "enable hca failed\n");
@@ -1023,6 +1025,7 @@ reclaim_boot_pages:
 err_disable_hca:
 	mlx5_core_disable_hca(dev, 0);
 err_cmd_cleanup:
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
 
 	return err;
@@ -1040,6 +1043,7 @@ static int mlx5_function_teardown(struct
 	}
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_core_disable_hca(dev, 0);
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
 
 	return 0;
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -230,6 +230,12 @@ struct mlx5_bfreg_info {
 	u32			num_dyn_bfregs;
 };
 
+enum mlx5_cmdif_state {
+	MLX5_CMDIF_STATE_UNINITIALIZED,
+	MLX5_CMDIF_STATE_UP,
+	MLX5_CMDIF_STATE_DOWN,
+};
+
 struct mlx5_cmd_first {
 	__be32		data[4];
 };
@@ -275,6 +281,7 @@ struct mlx5_cmd_stats {
 struct mlx5_cmd {
 	struct mlx5_nb    nb;
 
+	enum mlx5_cmdif_state	state;
 	void	       *cmd_alloc_buf;
 	dma_addr_t	alloc_dma;
 	int		alloc_size;
@@ -900,6 +907,8 @@ enum {
 
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
+void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
+			enum mlx5_cmdif_state cmdif_state);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
 void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);


