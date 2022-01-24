Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA24997E4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352034AbiAXVRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36628 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448735AbiAXVNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BFB60C60;
        Mon, 24 Jan 2022 21:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7E9C340E5;
        Mon, 24 Jan 2022 21:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058822;
        bh=LiungtrnGfVSW2X2GPi7o4c/ZYIPirnCDi7gCObCpHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPUDwhPLNIQr4vdGONMRyJFTGm0IYF2Jghdcj+ovrJTF6ZRS2V/cXF2Dzn5/2XW8B
         qj1TuQvNZl6DwmWJ4taqM53e06C7zu+pEoj13/FF5iwt1O1a/vpiB0yysGl9MUtzsd
         UBN3NrvlJ+WC4gogGm2CXyA4bkOwzlc+Ra6v2aqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0414/1039] net/mlx5: Set command entry semaphore up once got index free
Date:   Mon, 24 Jan 2022 19:36:43 +0100
Message-Id: <20220124184139.230822450@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 8e715cd613a1e872b9d918e912d90b399785761a ]

Avoid a race where command work handler may fail to allocate command
entry index, by holding the command semaphore down till command entry
index is being freed.

Fixes: 410bd754cd73 ("net/mlx5: Add retry mechanism to the command entry index allocation")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a46284ca51720..f588503157d04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -148,8 +148,12 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 	if (!refcount_dec_and_test(&ent->refcnt))
 		return;
 
-	if (ent->idx >= 0)
-		cmd_free_index(ent->cmd, ent->idx);
+	if (ent->idx >= 0) {
+		struct mlx5_cmd *cmd = ent->cmd;
+
+		cmd_free_index(cmd, ent->idx);
+		up(ent->page_queue ? &cmd->pages_sem : &cmd->sem);
+	}
 
 	cmd_free_ent(ent);
 }
@@ -1602,8 +1606,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 	vector = vec & 0xffffffff;
 	for (i = 0; i < (1 << cmd->log_sz); i++) {
 		if (test_bit(i, &vector)) {
-			struct semaphore *sem;
-
 			ent = cmd->ent_arr[i];
 
 			/* if we already completed the command, ignore it */
@@ -1626,10 +1628,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 				cmd_ent_put(ent);
 
-			if (ent->page_queue)
-				sem = &cmd->pages_sem;
-			else
-				sem = &cmd->sem;
 			ent->ts2 = ktime_get_ns();
 			memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
 			dump_command(dev, ent, 0);
@@ -1683,7 +1681,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				 */
 				complete(&ent->done);
 			}
-			up(sem);
 		}
 	}
 }
-- 
2.34.1



