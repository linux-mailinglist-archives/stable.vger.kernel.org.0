Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28651D0F39
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgEMJqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgEMJqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F8020740;
        Wed, 13 May 2020 09:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363168;
        bh=jpdaPpHao6OeULRHplp+4KkK02unGY3r6eZUySCwHaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoWofrOCEaxW0E7UULadyUuknM/4CGjZ2nQjMObusz0is/FXaY8Q0VGG/oe0eK3kj
         u3EUgCmBjI3mtrE9QXrOC7U0WvD+PEjoUiGxO0k+CxyTudgV79fYsE4WI1dwQlC8sr
         7+fiSXfy9q7GviOhSifCzEa4OSGVuYTqrohcW1m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 14/48] net/mlx5: Fix forced completion access non initialized command entry
Date:   Wed, 13 May 2020 11:44:40 +0200
Message-Id: <20200513094354.999572106@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit f3cb3cebe26ed4c8036adbd9448b372129d3c371 ]

mlx5_cmd_flush() will trigger forced completions to all valid command
entries. Triggered by an asynch event such as fast teardown it can
happen at any stage of the command, including command initialization.
It will trigger forced completion and that can lead to completion on an
uninitialized command entry.

Setting MLX5_CMD_ENT_STATE_PENDING_COMP only after command entry is
initialized will ensure force completion is treated only if command
entry is initialized.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -862,7 +862,6 @@ static void cmd_work_handler(struct work
 	}
 
 	cmd->ent_arr[ent->idx] = ent;
-	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 	lay = get_inst(cmd, ent->idx);
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
@@ -884,6 +883,7 @@ static void cmd_work_handler(struct work
 
 	if (ent->callback)
 		schedule_delayed_work(&ent->cb_timeout_work, cb_timeout);
+	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||


