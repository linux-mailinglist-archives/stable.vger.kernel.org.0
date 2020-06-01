Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9202E1EAA4E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgFASGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbgFASGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7633D2068D;
        Mon,  1 Jun 2020 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034808;
        bh=ambusvve4PtBxJnzxj5h6RempnRnRW92w6VEnBVIJnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0whhk+VDYoOIEAWBZDAOMdR5oJ0AATKyBeLDUNZH2s21WeDsCZ5ArM3vc9nB/4pQ
         c0Z2FgVnyhhSH2JtZI7sZxLgdz4xyM1+kLlu0e3ic6NqySnCO8Pl70pX1CvRg1Sdpa
         L/FGdCLHp4ooD7Hawus/xOM6vJaZTIPKH528w2VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 009/142] net/mlx5: Add command entry handling completion
Date:   Mon,  1 Jun 2020 19:52:47 +0200
Message-Id: <20200601174038.975067779@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 17d00e839d3b592da9659c1977d45f85b77f986a ]

When FW response to commands is very slow and all command entries in
use are waiting for completion we can have a race where commands can get
timeout before they get out of the queue and handled. Timeout
completion on uninitialized command will cause releasing command's
buffers before accessing it for initialization and then we will get NULL
pointer exception while trying access it. It may also cause releasing
buffers of another command since we may have timeout completion before
even allocating entry index for this command.
Add entry handling completion to avoid this race.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   14 ++++++++++++++
 include/linux/mlx5/driver.h                   |    1 +
 2 files changed, 15 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -861,6 +861,7 @@ static void cmd_work_handler(struct work
 	int alloc_ret;
 	int cmd_mode;
 
+	complete(&ent->handling);
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
@@ -978,6 +979,11 @@ static int wait_func(struct mlx5_core_de
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int err;
 
+	if (!wait_for_completion_timeout(&ent->handling, timeout) &&
+	    cancel_work_sync(&ent->work)) {
+		ent->ret = -ECANCELED;
+		goto out_err;
+	}
 	if (cmd->mode == CMD_MODE_POLLING || ent->polling) {
 		wait_for_completion(&ent->done);
 	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
@@ -985,12 +991,17 @@ static int wait_func(struct mlx5_core_de
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
 	}
 
+out_err:
 	err = ent->ret;
 
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
 			       mlx5_command_str(msg_to_opcode(ent->in)),
 			       msg_to_opcode(ent->in));
+	} else if (err == -ECANCELED) {
+		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
+			       mlx5_command_str(msg_to_opcode(ent->in)),
+			       msg_to_opcode(ent->in));
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1026,6 +1037,7 @@ static int mlx5_cmd_invoke(struct mlx5_c
 	ent->token = token;
 	ent->polling = force_polling;
 
+	init_completion(&ent->handling);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -1045,6 +1057,8 @@ static int mlx5_cmd_invoke(struct mlx5_c
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT)
 		goto out;
+	if (err == -ECANCELED)
+		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
 	op = MLX5_GET(mbox_in, in->first.data, opcode);
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -756,6 +756,7 @@ struct mlx5_cmd_work_ent {
 	struct delayed_work	cb_timeout_work;
 	void		       *context;
 	int			idx;
+	struct completion	handling;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;


