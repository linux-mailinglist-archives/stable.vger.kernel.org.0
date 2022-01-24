Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9549A9F8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323890AbiAYD3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3409762AbiAYA1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F736C0680B0;
        Mon, 24 Jan 2022 12:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4E76136F;
        Mon, 24 Jan 2022 20:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA691C36AE3;
        Mon, 24 Jan 2022 20:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054880;
        bh=sJTHRCOFGEKhCCSbR10rJRMVIOEL5CyPtm+xZ+Ap18c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PehiphV64z/Tea7jZN2NiOpJoDMLUiuf4ViTcdK4UEIT1JDvTTjt6JgQC5btZfyHl
         qGL7O9jPw6wqV6BlD2DnaC3Dbi0KwlZZJXICgawKv55l7/WL1e6QuL8qK4JTp8eq1O
         QooGDOkQ0movuZB0Goa4wPR86O3Vjz2S1D5Y0N3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 501/563] Revert "net/mlx5: Add retry mechanism to the command entry index allocation"
Date:   Mon, 24 Jan 2022 19:44:26 +0100
Message-Id: <20220124184041.786100923@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev)
 {
 	return pci_channel_offline(dev->pdev) ||
@@ -930,7 +911,7 @@ static void cmd_work_handler(struct work
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index_retry(cmd);
+		alloc_ret = cmd_alloc_index(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {


