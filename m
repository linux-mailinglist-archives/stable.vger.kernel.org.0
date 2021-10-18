Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB48431702
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhJRLOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229862AbhJRLOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:14:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A255161350;
        Mon, 18 Oct 2021 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555516;
        bh=KD0/M4/OiAQhf69haN45crXnoUr/MTDMlf9DKetwp1I=;
        h=Subject:To:Cc:From:Date:From;
        b=o+R+HW8vGpzI8cA3Qexd3yzlrugYfX29InCkYGRe3Xyl/j6t6LlqplvhfAf6dPDmx
         40fvhTCcHIPurHqH6PVL+koLbxSY+gjHnXirCyYobGyUH6TohkhQsdV0385cl21TZx
         9nFlj7LOmK90ksClwN9fWqWAg+7m9I0esqZYPs60=
Subject: FAILED: patch "[PATCH] net/mlx5e: Fix division by 0 in mlx5e_select_queue for" failed to apply to 5.14-stable tree
To:     maximmi@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:11:53 +0200
Message-ID: <163455551321963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 84c8a87402cf073ba7948dd62d4815a3f4a224c8 Mon Sep 17 00:00:00 2001
From: Maxim Mikityanskiy <maximmi@nvidia.com>
Date: Mon, 11 Oct 2021 18:39:35 +0300
Subject: [PATCH] net/mlx5e: Fix division by 0 in mlx5e_select_queue for
 representors

Commit 846d6da1fcdb ("net/mlx5e: Fix division by 0 in
mlx5e_select_queue") makes mlx5e_build_nic_params assign a non-zero
initial value to priv->num_tc_x_num_ch, so that mlx5e_select_queue
doesn't fail with division by 0 if called before the first activation of
channels. However, the initialization flow of representors doesn't call
mlx5e_build_nic_params, so this bug can still happen with representors.

This commit fixes the bug by adding the missing assignment to
mlx5e_build_rep_params.

Fixes: 846d6da1fcdb ("net/mlx5e: Fix division by 0 in mlx5e_select_queue")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0439203fc7d9..0684ac6699b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -618,6 +618,11 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
 
+	/* Set an initial non-zero value, so that mlx5e_select_queue won't
+	 * divide by zero if called before first activating channels.
+	 */
+	priv->num_tc_x_num_ch = params->num_channels * params->mqprio.num_tc;
+
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 }
 

