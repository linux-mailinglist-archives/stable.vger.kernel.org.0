Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B234616A0
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfGGTlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57892 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727656AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006kK-CH; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005fs-0Y; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        "Jack Morgenstein" <jackm@dev.mellanox.co.il>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.418429045@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 117/129] net/mlx4_core: Fix locking in SRIOV mode
 when switching between events and polling
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit c07d27927f2f2e96fcd27bb9fb330c9ea65612d0 upstream.

In procedures mlx4_cmd_use_events() and mlx4_cmd_use_polling(), we need to
guarantee that there are no FW commands in progress on the comm channel
(for VFs) or wrapped FW commands (on the PF) when SRIOV is active.

We do this by also taking the slave_cmd_mutex when SRIOV is active.

This is especially important when switching from event to polling, since we
free the command-context array during the switch.  If there are FW commands
in progress (e.g., waiting for a completion event), the completion event
handler will access freed memory.

Since the decision to use comm_wait or comm_poll is taken before grabbing
the event_sem/poll_sem in mlx4_comm_cmd_wait/poll, we must take the
slave_cmd_mutex as well (to guarantee that the decision to use events or
polling and the call to the appropriate cmd function are atomic).

Fixes: a7e1f04905e5 ("net/mlx4_core: Fix deadlock when switching between polling and event fw commands")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2196,6 +2196,8 @@ int mlx4_cmd_use_events(struct mlx4_dev
 	if (!priv->cmd.context)
 		return -ENOMEM;
 
+	if (mlx4_is_mfunc(dev))
+		mutex_lock(&priv->cmd.slave_cmd_mutex);
 	down_write(&priv->cmd.switch_sem);
 	for (i = 0; i < priv->cmd.max_cmds; ++i) {
 		priv->cmd.context[i].token = i;
@@ -2217,6 +2219,8 @@ int mlx4_cmd_use_events(struct mlx4_dev
 	down(&priv->cmd.poll_sem);
 	priv->cmd.use_events = 1;
 	up_write(&priv->cmd.switch_sem);
+	if (mlx4_is_mfunc(dev))
+		mutex_unlock(&priv->cmd.slave_cmd_mutex);
 
 	return err;
 }
@@ -2229,6 +2233,8 @@ void mlx4_cmd_use_polling(struct mlx4_de
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i;
 
+	if (mlx4_is_mfunc(dev))
+		mutex_lock(&priv->cmd.slave_cmd_mutex);
 	down_write(&priv->cmd.switch_sem);
 	priv->cmd.use_events = 0;
 
@@ -2239,6 +2245,8 @@ void mlx4_cmd_use_polling(struct mlx4_de
 
 	up(&priv->cmd.poll_sem);
 	up_write(&priv->cmd.switch_sem);
+	if (mlx4_is_mfunc(dev))
+		mutex_unlock(&priv->cmd.slave_cmd_mutex);
 }
 
 struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev)

