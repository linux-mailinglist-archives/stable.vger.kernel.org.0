Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20E628040
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiKNNE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237753AbiKNNEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B05229C97
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8E961184
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7894C433D6;
        Mon, 14 Nov 2022 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431063;
        bh=MAPO6JWQOs6yNNhuUK1WKtBEcmxb7w7cb3dOQhtphbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oD6ZhYTdcmvhNC18EdGGfu3BYpN0dIZ/1aXqTvOcmUOnBfZE4lZgzHlX3uzEgXslu
         Ca8fLPILYMATrT1bY2ukHXk76BPdteNWK8ekOiNou6FK/xPzxrmCVzi3oOzeyafvCn
         vB53ezhU1fitNrsupbI7C3uWGNb22bxkeatKof0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Schmidt <alexschm@de.ibm.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 087/190] net/mlx5: Allow async trigger completion execution on single CPU systems
Date:   Mon, 14 Nov 2022 13:45:11 +0100
Message-Id: <20221114124502.481742341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

[ Upstream commit 2808b37b59288ad8f1897e3546c2296df3384b65 ]

For a single CPU system, the kernel thread executing mlx5_cmd_flush()
never releases the CPU but calls down_trylock(&cmd→sem) in a busy loop.
On a single processor system, this leads to a deadlock as the kernel
thread which executes mlx5_cmd_invoke() never gets scheduled. Fix this,
by adding the cond_resched() call to the loop, allow the command
completion kernel thread to execute.

Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got index free")
Signed-off-by: Alexander Schmidt <alexschm@de.ibm.com>
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 46ba4c2faad2..2e0d59ca62b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1770,12 +1770,17 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int i;
 
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		while (down_trylock(&cmd->sem))
+	for (i = 0; i < cmd->max_reg_cmds; i++) {
+		while (down_trylock(&cmd->sem)) {
 			mlx5_cmd_trigger_completions(dev);
+			cond_resched();
+		}
+	}
 
-	while (down_trylock(&cmd->pages_sem))
+	while (down_trylock(&cmd->pages_sem)) {
 		mlx5_cmd_trigger_completions(dev);
+		cond_resched();
+	}
 
 	/* Unlock cmdif */
 	up(&cmd->pages_sem);
-- 
2.35.1



