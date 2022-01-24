Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A306499DC4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586205AbiAXWZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583236AbiAXWR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D417C061390;
        Mon, 24 Jan 2022 12:48:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A345DB810A8;
        Mon, 24 Jan 2022 20:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C402BC340E5;
        Mon, 24 Jan 2022 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057313;
        bh=O9UZ6orK0i01+YGguOA8n40pLZzoN4UWhLL+LLIUQ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTuT5t5/mJnULA8fWv0TZvHU+UtIkzWEP22/z8OpqO3z5H+zyKtWq1wYY3+kYzkUu
         NJs8Qw25hhoaNE+0s2DVxqO8JwuFBmPeNKAQJTyXyCvuc99JeNojoUiqowv8/ULe5F
         K1djdxVCjsLl+MC8SF31xYGu2gmsfQbNn/QZXHJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 754/846] Revert "net/mlx5: Add retry mechanism to the command entry index allocation"
Date:   Mon, 24 Jan 2022 19:44:31 +0100
Message-Id: <20220124184126.984714868@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

commit 4f6626b0e140867fd6d5a2e9d4ceaef97f10f46a upstream.

This reverts commit 410bd754cd73c4a2ac3856d9a03d7b08f9c906bf.

The reverted commit had added a retry mechanism to the command entry
index allocation. The previous patch ensures that there is a free
command entry index once the command work handler holds the command
semaphore. Thus the retry mechanism is not needed.

Fixes: 410bd754cd73 ("net/mlx5: Add retry mechanism to the command entry index allocation")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -899,25 +899,6 @@ static bool opcode_allowed(struct mlx5_c
 	return cmd->allowed_opcode == opcode;
 }
 
-static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
-{
-	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
-	int idx;
-
-retry:
-	idx = cmd_alloc_index(cmd);
-	if (idx < 0 && time_before(jiffies, alloc_end)) {
-		/* Index allocation can fail on heavy load of commands. This is a temporary
-		 * situation as the current command already holds the semaphore, meaning that
-		 * another command completion is being handled and it is expected to release
-		 * the entry index soon.
-		 */
-		cpu_relax();
-		goto retry;
-	}
-	return idx;
-}
-
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev)
 {
 	return pci_channel_offline(dev->pdev) ||
@@ -942,7 +923,7 @@ static void cmd_work_handler(struct work
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index_retry(cmd);
+		alloc_ret = cmd_alloc_index(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {


