Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408821EAF2D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgFAR4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgFAR4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D26C02073B;
        Mon,  1 Jun 2020 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034189;
        bh=acaU8/9TOoEnS9sV75MGOhjEpryxaPnGd/izJ/7EF3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WL7KZfHnPHUlUUXqeRYBRY1I4+bhhQxrdVpMA8tWOKTW5gEz2Uuxoqi6+DKEuj+/1
         998zWraf9e3OOEJRb8gLkX/xBfExMJSXTXJWGqaXn0giLE16HfS1UDFSaBm5JwXs73
         k6W9a94X85XrHTzs/04BVlPow28cvPxRgQ0AX6UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.4 04/48] net/mlx5: Add command entry handling completion
Date:   Mon,  1 Jun 2020 19:53:14 +0200
Message-Id: <20200601173953.233215090@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   15 +++++++++++++++
 include/linux/mlx5/driver.h                   |    1 +
 2 files changed, 16 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -670,6 +670,7 @@ static void cmd_work_handler(struct work
 	int alloc_ret;
 	int cmd_mode;
 
+	complete(&ent->handling);
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
@@ -769,6 +770,12 @@ static int wait_func(struct mlx5_core_de
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int err;
 
+	if (!wait_for_completion_timeout(&ent->handling, timeout) &&
+	    cancel_work_sync(&ent->work)) {
+		ent->ret = -ECANCELED;
+		goto out_err;
+	}
+
 	if (cmd->mode == CMD_MODE_POLLING) {
 		wait_for_completion(&ent->done);
 	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
@@ -776,12 +783,17 @@ static int wait_func(struct mlx5_core_de
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx);
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
@@ -826,6 +838,7 @@ static int mlx5_cmd_invoke(struct mlx5_c
 
 	ent->token = token;
 
+	init_completion(&ent->handling);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -841,6 +854,8 @@ static int mlx5_cmd_invoke(struct mlx5_c
 
 	if (callback)
 		goto out;
+	if (err == -ECANCELED)
+		goto out_free;
 
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT)
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -569,6 +569,7 @@ struct mlx5_cmd_work_ent {
 	struct delayed_work	cb_timeout_work;
 	void		       *context;
 	int			idx;
+	struct completion	handling;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;


