Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAB04D8268
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbiCNMDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbiCNMCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:02:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1194A496A7;
        Mon, 14 Mar 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2BB61260;
        Mon, 14 Mar 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44073C340E9;
        Mon, 14 Mar 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259214;
        bh=3YcOFHwlwsN0mub8Bm/oweTTfIMWKNyAAyTDMHIIA/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/zeZbwj+JCQDeip1QDVxIkBfYBN45xnr7gQvmCuTIK+Gh88TEk5rUpEGfeqr+Kgd
         MFreD6O4S9qaFpl7H+7Gu0njiqg3105HUtgVio8efjutqOGyr9Gke2KSmyfpHOy6RU
         9LSyTpF8jLXrpnuWY7J4Ulg8r+abPrbg8UM9UcZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/71] net/mlx5: Fix a race on command flush flow
Date:   Mon, 14 Mar 2022 12:53:21 +0100
Message-Id: <20220314112738.720484359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 063bd355595428750803d8736a9bb7c8db67d42d ]

Fix a refcount use after free warning due to a race on command entry.
Such race occurs when one of the commands releases its last refcount and
frees its index and entry while another process running command flush
flow takes refcount to this command entry. The process which handles
commands flush may see this command as needed to be flushed if the other
process released its refcount but didn't release the index yet. Fix it
by adding the needed spin lock.

It fixes the following warning trace:

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 11 PID: 540311 at lib/refcount.c:25 refcount_warn_saturate+0x80/0xe0
...
RIP: 0010:refcount_warn_saturate+0x80/0xe0
...
Call Trace:
 <TASK>
 mlx5_cmd_trigger_completions+0x293/0x340 [mlx5_core]
 mlx5_cmd_flush+0x3a/0xf0 [mlx5_core]
 enter_error_state+0x44/0x80 [mlx5_core]
 mlx5_fw_fatal_reporter_err_work+0x37/0xe0 [mlx5_core]
 process_one_work+0x1be/0x390
 worker_thread+0x4d/0x3d0
 ? rescuer_thread+0x350/0x350
 kthread+0x141/0x160
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 50b2412b7e78 ("net/mlx5: Avoid possible free of command entry while timeout comp handler")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 6af0dd847169..94426d29025e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -130,11 +130,8 @@ static int cmd_alloc_index(struct mlx5_cmd *cmd)
 
 static void cmd_free_index(struct mlx5_cmd *cmd, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	lockdep_assert_held(&cmd->alloc_lock);
 	set_bit(idx, &cmd->bitmask);
-	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
@@ -144,17 +141,21 @@ static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
 
 static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 {
+	struct mlx5_cmd *cmd = ent->cmd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
 	if (!refcount_dec_and_test(&ent->refcnt))
-		return;
+		goto out;
 
 	if (ent->idx >= 0) {
-		struct mlx5_cmd *cmd = ent->cmd;
-
 		cmd_free_index(cmd, ent->idx);
 		up(ent->page_queue ? &cmd->pages_sem : &cmd->sem);
 	}
 
 	cmd_free_ent(ent);
+out:
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static struct mlx5_cmd_layout *get_inst(struct mlx5_cmd *cmd, int idx)
-- 
2.34.1



