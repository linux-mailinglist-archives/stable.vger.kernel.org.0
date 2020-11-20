Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969D72BA892
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgKTLJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgKTLHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F922236F;
        Fri, 20 Nov 2020 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870426;
        bh=103XGpKqqJJXYGF3APmS4OrNO5mb4kz9Bq2Pk1kvUis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAKPFK/Gf2fzEm1RMdO1vd3HRHIggI7h9zad5aEaLabuUR0xAsY01zHqbZR3E/JJm
         p1SzRgUdVhjmfe/qPc7Uo0I23KcIsoqjs77xs/RrBX689/RR26wFu1GPVjst0fiC+V
         f2bH01+GDSB467WYTb+DfW6GFBpvejdYh90yI/no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Timo Rothenpieler <timo@rothenpieler.org>
Subject: [PATCH 5.4 08/17] net/mlx5: poll cmd EQ in case of command timeout
Date:   Fri, 20 Nov 2020 12:03:35 +0100
Message-Id: <20201120104541.477702135@linuxfoundation.org>
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

From: Eran Ben Elisha <eranbe@mellanox.com>

commit 1d5558b1f0de81f54ddee05f3793acc5260d107f upstream.

Once driver detects a command interface command timeout, it warns the
user and returns timeout error to the caller. In such case, the entry of
the command is not evacuated (because only real event interrupt is allowed
to clear command interface entry). If the HW event interrupt
of this entry will never arrive, this entry will be left unused forever.
Command interface entries are limited and eventually we can end up without
the ability to post a new command.

In addition, if driver will not consume the EQE of the lost interrupt and
rearm the EQ, no new interrupts will arrive for other commands.

Add a resiliency mechanism for manually polling the command EQ in case of
a command timeout. In case resiliency mechanism will find non-handled EQE,
it will consume it, and the command interface will be fully functional
again. Once the resiliency flow finished, wait another 5 seconds for the
command interface to complete for this command entry.

Define mlx5_cmd_eq_recover() to manage the cmd EQ polling resiliency flow.
Add an async EQ spinlock to avoid races between resiliency flows and real
interrupts that might run simultaneously.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c    |   53 +++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     |   40 ++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h |    2 
 3 files changed, 86 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -853,11 +853,21 @@ static void cb_timeout_handler(struct wo
 	struct mlx5_core_dev *dev = container_of(ent->cmd, struct mlx5_core_dev,
 						 cmd);
 
+	mlx5_cmd_eq_recover(dev);
+
+	/* Maybe got handled by eq recover ? */
+	if (!test_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state)) {
+		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, recovered after timeout\n", ent->idx,
+			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		goto out; /* phew, already handled */
+	}
+
 	ent->ret = -ETIMEDOUT;
-	mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
-		       mlx5_command_str(msg_to_opcode(ent->in)),
-		       msg_to_opcode(ent->in));
+	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
+		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
 	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+
+out:
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
@@ -987,6 +997,35 @@ static const char *deliv_status_to_str(u
 	}
 }
 
+enum {
+	MLX5_CMD_TIMEOUT_RECOVER_MSEC   = 5 * 1000,
+};
+
+static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
+					  struct mlx5_cmd_work_ent *ent)
+{
+	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_RECOVER_MSEC);
+
+	mlx5_cmd_eq_recover(dev);
+
+	/* Re-wait on the ent->done after executing the recovery flow. If the
+	 * recovery flow (or any other recovery flow running simultaneously)
+	 * has recovered an EQE, it should cause the entry to be completed by
+	 * the command interface.
+	 */
+	if (wait_for_completion_timeout(&ent->done, timeout)) {
+		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) recovered after timeout\n", ent->idx,
+			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		return;
+	}
+
+	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) No done completion\n", ent->idx,
+		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+
+	ent->ret = -ETIMEDOUT;
+	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+}
+
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 {
 	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
@@ -998,12 +1037,10 @@ static int wait_func(struct mlx5_core_de
 		ent->ret = -ECANCELED;
 		goto out_err;
 	}
-	if (cmd->mode == CMD_MODE_POLLING || ent->polling) {
+	if (cmd->mode == CMD_MODE_POLLING || ent->polling)
 		wait_for_completion(&ent->done);
-	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
-		ent->ret = -ETIMEDOUT;
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
-	}
+	else if (!wait_for_completion_timeout(&ent->done, timeout))
+		wait_func_handle_exec_timeout(dev, ent);
 
 out_err:
 	err = ent->ret;
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -190,6 +190,29 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx
 	return count_eqe;
 }
 
+static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, unsigned long *flags)
+	__acquires(&eq->lock)
+{
+	if (in_irq())
+		spin_lock(&eq->lock);
+	else
+		spin_lock_irqsave(&eq->lock, *flags);
+}
+
+static void mlx5_eq_async_int_unlock(struct mlx5_eq_async *eq, unsigned long *flags)
+	__releases(&eq->lock)
+{
+	if (in_irq())
+		spin_unlock(&eq->lock);
+	else
+		spin_unlock_irqrestore(&eq->lock, *flags);
+}
+
+enum async_eq_nb_action {
+	ASYNC_EQ_IRQ_HANDLER = 0,
+	ASYNC_EQ_RECOVER = 1,
+};
+
 static int mlx5_eq_async_int(struct notifier_block *nb,
 			     unsigned long action, void *data)
 {
@@ -199,11 +222,14 @@ static int mlx5_eq_async_int(struct noti
 	struct mlx5_eq_table *eqt;
 	struct mlx5_core_dev *dev;
 	struct mlx5_eqe *eqe;
+	unsigned long flags;
 	int num_eqes = 0;
 
 	dev = eq->dev;
 	eqt = dev->priv.eq_table;
 
+	mlx5_eq_async_int_lock(eq_async, &flags);
+
 	eqe = next_eqe_sw(eq);
 	if (!eqe)
 		goto out;
@@ -224,8 +250,19 @@ static int mlx5_eq_async_int(struct noti
 
 out:
 	eq_update_ci(eq, 1);
+	mlx5_eq_async_int_unlock(eq_async, &flags);
 
-	return 0;
+	return unlikely(action == ASYNC_EQ_RECOVER) ? num_eqes : 0;
+}
+
+void mlx5_cmd_eq_recover(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_async *eq = &dev->priv.eq_table->cmd_eq;
+	int eqes;
+
+	eqes = mlx5_eq_async_int(&eq->irq_nb, ASYNC_EQ_RECOVER, NULL);
+	if (eqes)
+		mlx5_core_warn(dev, "Recovered %d EQEs on cmd_eq\n", eqes);
 }
 
 static void init_eq_buf(struct mlx5_eq *eq)
@@ -570,6 +607,7 @@ setup_async_eq(struct mlx5_core_dev *dev
 	int err;
 
 	eq->irq_nb.notifier_call = mlx5_eq_async_int;
+	spin_lock_init(&eq->lock);
 
 	err = create_async_eq(dev, &eq->core, param);
 	if (err) {
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -38,6 +38,7 @@ struct mlx5_eq {
 struct mlx5_eq_async {
 	struct mlx5_eq          core;
 	struct notifier_block   irq_nb;
+	spinlock_t              lock; /* To avoid irq EQ handle races with resiliency flows */
 };
 
 struct mlx5_eq_comp {
@@ -82,6 +83,7 @@ void mlx5_cq_tasklet_cb(unsigned long da
 struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
 
 u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq);
+void mlx5_cmd_eq_recover(struct mlx5_core_dev *dev);
 void mlx5_eq_synchronize_async_irq(struct mlx5_core_dev *dev);
 void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev);
 


