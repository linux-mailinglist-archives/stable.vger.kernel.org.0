Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40AF49A93B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322342AbiAYDVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347413AbiAXUTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB46EC07596F;
        Mon, 24 Jan 2022 11:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BDFA6148B;
        Mon, 24 Jan 2022 19:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D62FC340E5;
        Mon, 24 Jan 2022 19:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053125;
        bh=PivZKGnOzd2O9y7F4oVeB7DXqDj2PYX04tcxn/ZNV40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5BboJwV54oG3Q9rROPBqkr5HR0SKE/8Q6zDC6S4T5PddCca6MnKz96ucpwD1NVYq
         sIj+vOKS/P9DIX4RYsHMxMet9jU0ks6aC/mumr6+oORSMCeb2H79FZzqCO59iE1nQh
         gejM0+8KCYm0jwKSvcKgZoZdIteZQJLSNyyecy44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 285/320] Revert "net/mlx5: Add retry mechanism to the command entry index allocation"
Date:   Mon, 24 Jan 2022 19:44:29 +0100
Message-Id: <20220124184003.661305647@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -887,25 +887,6 @@ static bool opcode_allowed(struct mlx5_c
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
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -923,7 +904,7 @@ static void cmd_work_handler(struct work
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index_retry(cmd);
+		alloc_ret = cmd_alloc_index(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err(dev, "failed to allocate command entry\n");
 			if (ent->callback) {


