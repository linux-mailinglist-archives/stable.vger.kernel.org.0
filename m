Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EAE5BAA62
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiIPKZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiIPKYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6FC71BE5;
        Fri, 16 Sep 2022 03:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A6CC62A32;
        Fri, 16 Sep 2022 10:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45227C433C1;
        Fri, 16 Sep 2022 10:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323244;
        bh=D8OLYocK3VvezB1I385mYwbHg2YAI00QvEOBRPpGGBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viPO3Z1yc+vhicVMwesqjrMuTkLVZpFn0cR7uCRJuqIPCHIAAhPT/P80LXRr5wjxA
         Q8w3/6NgHcpZFDtHeNrNQvLCKWvfDX5Z8fUqhZdB7CqlDauh3d2KiGC8om+zsBlxgr
         8gZ4aZXNUWwIjwrYosVJDdGtIp70KjV3udZ7nppQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 06/38] RDMA/mlx5: Fix UMR cleanup on error flow of driver init
Date:   Fri, 16 Sep 2022 12:08:40 +0200
Message-Id: <20220916100448.711329829@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 9b7d4be967f16f79a2283b2338709fcc750313ee ]

The cited commit removed from the cleanup flow of umr the checks
if the resources were created. This could lead to null-ptr-deref
in case that we had failure in mlx5_ib_stage_ib_reg_init stage.

Fix it by adding new state to the umr that can say if the resources
were created or not and check it in the umr cleanup flow before
destroying the resources.

Fixes: 04876c12c19e ("RDMA/mlx5: Move init and cleanup of UMR to umr.c")
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Link: https://lore.kernel.org/r/4cfa61386cf202e9ce330e8d228ce3b25a36326e.1661763459.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
 drivers/infiniband/hw/mlx5/umr.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7460e0dfe6db4..c2cca032a6ed4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -718,6 +718,7 @@ struct mlx5_ib_umr_context {
 };
 
 enum {
+	MLX5_UMR_STATE_UNINIT,
 	MLX5_UMR_STATE_ACTIVE,
 	MLX5_UMR_STATE_RECOVER,
 	MLX5_UMR_STATE_ERR,
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index e00b94d1b1ea1..d5105b5c9979b 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -177,6 +177,7 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
 	mutex_init(&dev->umrc.lock);
+	dev->umrc.state = MLX5_UMR_STATE_ACTIVE;
 
 	return 0;
 
@@ -191,6 +192,8 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 
 void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 {
+	if (dev->umrc.state == MLX5_UMR_STATE_UNINIT)
+		return;
 	ib_destroy_qp(dev->umrc.qp);
 	ib_free_cq(dev->umrc.cq);
 	ib_dealloc_pd(dev->umrc.pd);
-- 
2.35.1



