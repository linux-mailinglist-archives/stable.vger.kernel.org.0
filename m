Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C763BBBD7
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhGELCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231414AbhGELCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47AA9613D8;
        Mon,  5 Jul 2021 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482804;
        bh=GxrhXgiOg3GtN7ti5HlNoslvmgKncZjm4vPmP58vplE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo2qI3ydAWMSMPEdZmb0gZh16vt1a4Qnt7MCdZgoOmq6RD+uKQsP6sN3rVGBKPOVB
         2wo6rScPAj95yoTRKsXuQKRkOvroedRMK9NOpoCUImd0P7hA95TBqQzjParTc6vp8+
         Xs1vf4tRIcG39Em6QPl/xYdcl/e1k3gjuAeslGdBnp/K8SWdYuDsgWSphh2sPqznpv
         /0GK5Asjbg8Giyurfe5cbB+nXCyHj7fHLvXrQy2QCcIntf0fPoHE98n011XOtDaImN
         NCfzmUgdgxDsRLcF7xBVMX3HGpT0YivmRMZE1ICGFbneOduhhNuIBsYdOaKMlprd3o
         v9RihwInuXwmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 5/7] RDMA/mlx5: Block FDB rules when not in switchdev mode
Date:   Mon,  5 Jul 2021 06:59:55 -0400
Message-Id: <20210705105957.1513284-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

commit edc0b0bccc9c80d9a44d3002dcca94984b25e7cf upstream.

Allow creating FDB steering rules only when in switchdev mode.

The only software model where a userspace application can manipulate
FDB entries is when it manages the eswitch. This is only possible in
switchdev mode where we expose a single RDMA device with representors
for all the vports that are connected to the eswitch.

Fixes: 52438be44112 ("RDMA/mlx5: Allow inserting a steering rule to the FDB")
Link: https://lore.kernel.org/r/e928ae7c58d07f104716a2a8d730963d1bd01204.1623052923.git.leonro@nvidia.com
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[sudip: use old mlx5_eswitch_mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 13d50b178166..b3391ecedda7 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2136,6 +2136,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev->priv.eswitch) !=
+			      MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);
-- 
2.30.2

