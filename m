Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE4099AC3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390402AbfHVRIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390392AbfHVRIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:35 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6674D23400;
        Thu, 22 Aug 2019 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493714;
        bh=SUeVgyj9KGoSJ+/rEsQbWqM3p6Wy0GHD60j0+1FUhQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCNd0KQAwbOld+hekrh5ANnXQlgH2YWV7ENHX08m/xdJHMprZ5BIFVWWflseC8GXT
         0VfmWb2ypAfdpbMiDktfOyLohcfdBwSHpS7fccsaKWLE/YwU3qzu4KXxZPNj95z1ur
         waMMrhA4RBxL+fBO+Hxx57IsQ1LPKKHJYzDiyYK4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/135] IB/mlx5: Replace kfree with kvfree
Date:   Thu, 22 Aug 2019 13:06:34 -0400
Message-Id: <20190822170811.13303-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit b7f406bb883ba7ac3222298f6b44cebc4cfe2dde ]

Memory allocated by kvzalloc should not be freed by kfree(), use kvfree()
instead.

Fixes: 813e90b1aeaa ("IB/mlx5: Add advise_mr() support")
Link: https://lore.kernel.org/r/20190717082101.14196-1-hslester96@gmail.com
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 91507a2e92900..f6e5351ba4d50 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1765,7 +1765,7 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *work)
 
 	num_pending_prefetch_dec(to_mdev(w->pd->device), w->sg_list,
 				 w->num_sge, 0);
-	kfree(w);
+	kvfree(w);
 }
 
 int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
@@ -1807,7 +1807,7 @@ int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 	if (valid_req)
 		queue_work(system_unbound_wq, &work->work);
 	else
-		kfree(work);
+		kvfree(work);
 
 	srcu_read_unlock(&dev->mr_srcu, srcu_key);
 
-- 
2.20.1

