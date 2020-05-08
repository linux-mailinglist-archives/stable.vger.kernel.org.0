Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093F31CAB10
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgEHMjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgEHMj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DD120731;
        Fri,  8 May 2020 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941568;
        bh=Ma4PKiBBIHWZ9Wop04IcE8ZOfnFHrAuW2aab4kSchMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecnPkqOr/62XXzaMGiLmnkHKacxZqHzb9rxDY6WFF8ak7P/JcUIAUmHnd+tlFTe5t
         WpoHG4Lzo0aubLAoldCVuGHXRNpukgxqkWdVbYBJg16Q51isohbHvz3eYhALocZJUo
         CLoqBwXXgOneM2aMDNenmemMKfO+FrxaRHTYMwj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohamad Haj Yahia <mohamad@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 084/312] net/mlx5: Add timeout handle to commands with callback
Date:   Fri,  8 May 2020 14:31:15 +0200
Message-Id: <20200508123130.457457744@linuxfoundation.org>
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

commit 65ee67084589c1783a74b4a4a5db38d7264ec8b5 upstream.

The current implementation does not handle timeout in case of command
with callback request, and this can lead to deadlock if the command
doesn't get fw response.
Add delayed callback timeout work before posting the command to fw.
In case of real fw command completion we will cancel the delayed work.
In case of fw command timeout the callback timeout handler will be
called and it will simulate fw completion with timeout error.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Mohamad Haj Yahia <mohamad@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   38 +++++++++++++++++++++-----
 include/linux/mlx5/driver.h                   |    1 
 2 files changed, 32 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -634,11 +634,36 @@ static void free_msg(struct mlx5_core_de
 static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
 			      struct mlx5_cmd_msg *msg);
 
+static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
+{
+	struct mlx5_inbox_hdr *hdr = (struct mlx5_inbox_hdr *)(in->first.data);
+
+	return be16_to_cpu(hdr->opcode);
+}
+
+static void cb_timeout_handler(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct mlx5_cmd_work_ent *ent = container_of(dwork,
+						     struct mlx5_cmd_work_ent,
+						     cb_timeout_work);
+	struct mlx5_core_dev *dev = container_of(ent->cmd, struct mlx5_core_dev,
+						 cmd);
+
+	ent->ret = -ETIMEDOUT;
+	mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
+		       mlx5_command_str(msg_to_opcode(ent->in)),
+		       msg_to_opcode(ent->in));
+	mlx5_cmd_comp_handler(dev, 1UL << ent->idx);
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
 	struct mlx5_cmd *cmd = ent->cmd;
 	struct mlx5_core_dev *dev = container_of(cmd, struct mlx5_core_dev, cmd);
+	unsigned long cb_timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
 	struct mlx5_cmd_layout *lay;
 	struct semaphore *sem;
 	unsigned long flags;
@@ -691,6 +716,9 @@ static void cmd_work_handler(struct work
 	ent->ts1 = ktime_get_ns();
 	cmd_mode = cmd->mode;
 
+	if (ent->callback)
+		schedule_delayed_work(&ent->cb_timeout_work, cb_timeout);
+
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -735,13 +763,6 @@ static const char *deliv_status_to_str(u
 	}
 }
 
-static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
-{
-	struct mlx5_inbox_hdr *hdr = (struct mlx5_inbox_hdr *)(in->first.data);
-
-	return be16_to_cpu(hdr->opcode);
-}
-
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 {
 	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
@@ -808,6 +829,7 @@ static int mlx5_cmd_invoke(struct mlx5_c
 	if (!callback)
 		init_completion(&ent->done);
 
+	INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
 	INIT_WORK(&ent->work, cmd_work_handler);
 	if (page_queue) {
 		cmd_work_handler(&ent->work);
@@ -1287,6 +1309,8 @@ void mlx5_cmd_comp_handler(struct mlx5_c
 			struct semaphore *sem;
 
 			ent = cmd->ent_arr[i];
+			if (ent->callback)
+				cancel_delayed_work(&ent->cb_timeout_work);
 			if (ent->page_queue)
 				sem = &cmd->pages_sem;
 			else
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -566,6 +566,7 @@ struct mlx5_cmd_work_ent {
 	void		       *uout;
 	int			uout_size;
 	mlx5_cmd_cbk_t		callback;
+	struct delayed_work	cb_timeout_work;
 	void		       *context;
 	int			idx;
 	struct completion	done;


