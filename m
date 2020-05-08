Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9042D1CAB0F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEHMj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgEHMj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD5121835;
        Fri,  8 May 2020 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941566;
        bh=kmNmrZ1d3mohTWvPW42p/d2bF0lo3g+Sq23zNkUFmSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prINQpetDZVL+YEmbGCDr5ITlTmpdwmIEaUO1bLOoGHG8i/cr4wJvcOZ0Fd+QpBja
         56lLQSvVpjM/3fhSOoeHfGfnkUWZwPMo93C6S4MZJjubAr/W6tf7rm3QliCXyC4TpG
         vTsJoTARDYBSAujcf1NHAmj+yFsLDXHkh81rvufU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohamad Haj Yahia <mohamad@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 083/312] net/mlx5: Fix potential deadlock in command mode change
Date:   Fri,  8 May 2020 14:31:14 +0200
Message-Id: <20200508123130.387555764@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohamad Haj Yahia <mohamad@mellanox.com>

commit 9cba4ebcf374c3772f6eb61f2d065294b2451b49 upstream.

Call command completion handler in case of timeout when working in
interrupts mode.
Avoid flushing the commands workqueue after acquiring the semaphores to
prevent a potential deadlock.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Mohamad Haj Yahia <mohamad@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   79 ++++++++++----------------
 1 file changed, 33 insertions(+), 46 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -750,13 +750,13 @@ static int wait_func(struct mlx5_core_de
 
 	if (cmd->mode == CMD_MODE_POLLING) {
 		wait_for_completion(&ent->done);
-		err = ent->ret;
-	} else {
-		if (!wait_for_completion_timeout(&ent->done, timeout))
-			err = -ETIMEDOUT;
-		else
-			err = 0;
+	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
+		ent->ret = -ETIMEDOUT;
+		mlx5_cmd_comp_handler(dev, 1UL << ent->idx);
 	}
+
+	err = ent->ret;
+
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
 			       mlx5_command_str(msg_to_opcode(ent->in)),
@@ -817,28 +817,26 @@ static int mlx5_cmd_invoke(struct mlx5_c
 		goto out_free;
 	}
 
-	if (!callback) {
-		err = wait_func(dev, ent);
-		if (err == -ETIMEDOUT)
-			goto out;
-
-		ds = ent->ts2 - ent->ts1;
-		op = be16_to_cpu(((struct mlx5_inbox_hdr *)in->first.data)->opcode);
-		if (op < ARRAY_SIZE(cmd->stats)) {
-			stats = &cmd->stats[op];
-			spin_lock_irq(&stats->lock);
-			stats->sum += ds;
-			++stats->n;
-			spin_unlock_irq(&stats->lock);
-		}
-		mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_TIME,
-				   "fw exec time for %s is %lld nsec\n",
-				   mlx5_command_str(op), ds);
-		*status = ent->status;
-		free_cmd(ent);
-	}
+	if (callback)
+		goto out;
 
-	return err;
+	err = wait_func(dev, ent);
+	if (err == -ETIMEDOUT)
+		goto out_free;
+
+	ds = ent->ts2 - ent->ts1;
+	op = be16_to_cpu(((struct mlx5_inbox_hdr *)in->first.data)->opcode);
+	if (op < ARRAY_SIZE(cmd->stats)) {
+		stats = &cmd->stats[op];
+		spin_lock_irq(&stats->lock);
+		stats->sum += ds;
+		++stats->n;
+		spin_unlock_irq(&stats->lock);
+	}
+	mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_TIME,
+			   "fw exec time for %s is %lld nsec\n",
+			   mlx5_command_str(op), ds);
+	*status = ent->status;
 
 out_free:
 	free_cmd(ent);
@@ -1230,41 +1228,30 @@ err_dbg:
 	return err;
 }
 
-void mlx5_cmd_use_events(struct mlx5_core_dev *dev)
+static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int i;
 
 	for (i = 0; i < cmd->max_reg_cmds; i++)
 		down(&cmd->sem);
-
 	down(&cmd->pages_sem);
 
-	flush_workqueue(cmd->wq);
-
-	cmd->mode = CMD_MODE_EVENTS;
+	cmd->mode = mode;
 
 	up(&cmd->pages_sem);
 	for (i = 0; i < cmd->max_reg_cmds; i++)
 		up(&cmd->sem);
 }
 
-void mlx5_cmd_use_polling(struct mlx5_core_dev *dev)
+void mlx5_cmd_use_events(struct mlx5_core_dev *dev)
 {
-	struct mlx5_cmd *cmd = &dev->cmd;
-	int i;
-
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		down(&cmd->sem);
-
-	down(&cmd->pages_sem);
-
-	flush_workqueue(cmd->wq);
-	cmd->mode = CMD_MODE_POLLING;
+	mlx5_cmd_change_mod(dev, CMD_MODE_EVENTS);
+}
 
-	up(&cmd->pages_sem);
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		up(&cmd->sem);
+void mlx5_cmd_use_polling(struct mlx5_core_dev *dev)
+{
+	mlx5_cmd_change_mod(dev, CMD_MODE_POLLING);
 }
 
 static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)


