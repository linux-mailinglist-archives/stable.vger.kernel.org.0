Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1621EACE9
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbgFASMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731254AbgFASMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450C02065C;
        Mon,  1 Jun 2020 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035154;
        bh=n7ggVRg8Ev4nEuVBzNVX2QT3/uwX3CFNNKuRVWnICb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kra9kvgEOnWtZ1PuydDekr9D3s83NFi9Eo0wJ/tWqaogQAdNm1OX6CU4LJRwTFQDd
         OliOpQaOacPj+jmOL2cGxc83XoRbpFESebjwRRIDzlOoiHWqKZ7/S2c/VpAY5Zm9af
         KJc1Alr8e7ef7AF6u6UZ1i2bc8QTWR323tWvlMHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 032/177] net/mlx5: Fix a race when moving command interface to events mode
Date:   Mon,  1 Jun 2020 19:52:50 +0200
Message-Id: <20200601174051.566087378@linuxfoundation.org>
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

[ Upstream commit d43b7007dbd1195a5b6b83213e49b1516aaf6f5e ]

After driver creates (via FW command) an EQ for commands, the driver will
be informed on new commands completion by EQE. However, due to a race in
driver's internal command mode metadata update, some new commands will
still be miss-handled by driver as if we are in polling mode. Such commands
can get two non forced completion, leading to already freed command entry
access.

CREATE_EQ command, that maps EQ to the command queue must be posted to the
command queue while it is empty and no other command should be posted.

Add SW mechanism that once the CREATE_EQ command is about to be executed,
all other commands will return error without being sent to the FW. Allow
sending other commands only after successfully changing the driver's
internal command mode metadata.
We can safely return error to all other commands while creating the command
EQ, as all other commands might be sent from the user/application during
driver load. Application can rerun them later after driver's load was
finished.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   35 +++++++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |    3 ++
 include/linux/mlx5/driver.h                   |    6 ++++
 3 files changed, 40 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -848,6 +848,14 @@ static void free_msg(struct mlx5_core_de
 static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
 			      struct mlx5_cmd_msg *msg);
 
+static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
+{
+	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
+		return true;
+
+	return cmd->allowed_opcode == opcode;
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -914,7 +922,8 @@ static void cmd_work_handler(struct work
 
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
 		u32 drv_synd;
 
@@ -1405,6 +1414,22 @@ static void create_debugfs_files(struct
 	mlx5_cmdif_debugfs_init(dev);
 }
 
+void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+	int i;
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		down(&cmd->sem);
+	down(&cmd->pages_sem);
+
+	cmd->allowed_opcode = opcode;
+
+	up(&cmd->pages_sem);
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		up(&cmd->sem);
+}
+
 static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
@@ -1681,12 +1706,13 @@ static int cmd_exec(struct mlx5_core_dev
 	int err;
 	u8 status = 0;
 	u32 drv_synd;
+	u16 opcode;
 	u8 token;
 
+	opcode = MLX5_GET(mbox_in, in, opcode);
 	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
-		u16 opcode = MLX5_GET(mbox_in, in, opcode);
-
+	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    !opcode_allowed(&dev->cmd, opcode)) {
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
 		MLX5_SET(mbox_out, out, syndrome, drv_synd);
@@ -1988,6 +2014,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *
 	mlx5_core_dbg(dev, "descriptor at dma 0x%llx\n", (unsigned long long)(cmd->dma));
 
 	cmd->mode = CMD_MODE_POLLING;
+	cmd->allowed_opcode = CMD_ALLOWED_OPCODE_ALL;
 
 	create_msg_cache(dev);
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -611,11 +611,13 @@ static int create_async_eqs(struct mlx5_
 		.nent = MLX5_NUM_CMD_EQE,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
+	mlx5_cmd_allowed_opcode(dev, MLX5_CMD_OP_CREATE_EQ);
 	err = setup_async_eq(dev, &table->cmd_eq, &param, "cmd");
 	if (err)
 		goto err1;
 
 	mlx5_cmd_use_events(dev);
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
@@ -645,6 +647,7 @@ err2:
 	mlx5_cmd_use_polling(dev);
 	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 err1:
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 	return err;
 }
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -301,6 +301,7 @@ struct mlx5_cmd {
 	struct semaphore sem;
 	struct semaphore pages_sem;
 	int	mode;
+	u16     allowed_opcode;
 	struct mlx5_cmd_work_ent *ent_arr[MLX5_MAX_COMMANDS];
 	struct dma_pool *pool;
 	struct mlx5_cmd_debug dbg;
@@ -893,10 +894,15 @@ mlx5_frag_buf_get_idx_last_contig_stride
 	return min_t(u32, last_frag_stride_idx - fbc->strides_offset, fbc->sz_m1);
 }
 
+enum {
+	CMD_ALLOWED_OPCODE_ALL,
+};
+
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
+void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
 
 struct mlx5_async_ctx {
 	struct mlx5_core_dev *dev;


