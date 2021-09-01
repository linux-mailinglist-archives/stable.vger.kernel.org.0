Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FEE3FDC06
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343845AbhIAMqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345490AbhIAMoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BCD161101;
        Wed,  1 Sep 2021 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499919;
        bh=wuv4NmPovmBUw1ySGVGnSdzCNgfiKlNHr5zpos2VBSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wykwyfMbO4Ap3XobPJkZC26KhsMpdt8ZKxb9uo9bzI6ZNvMq87GwyiaqsUzj557FI
         a3l/LqXGt1l5uAV6Cwb9N9NOOwFkQpQEuz2OWFQFRdbJNC6WUxtmfq23W0shBu66RQ
         HDU4yk25Jhv0DG3zWiy5/xEFMp1rVvr85R/eBuUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/113] RDMA/mlx5: Fix crash when unbind multiport slave
Date:   Wed,  1 Sep 2021 14:27:50 +0200
Message-Id: <20210901122303.160087956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit da78fe5fb35737058de52364484ffed74e7d329b ]

Fix the below crash when deleting a slave from the unaffiliated list
twice. First time when the slave is bound to the master and the second
when the slave is unloaded.

Fix it by checking if slave is unaffiliated (doesn't have ib device)
before removing from the list.

  RIP: 0010:mlx5r_mp_remove+0x4e/0xa0 [mlx5_ib]
  Call Trace:
   auxiliary_bus_remove+0x18/0x30
   __device_release_driver+0x177/x220
   device_release_driver+0x24/0x30
   bus_remove_device+0xd8/0x140
   device_del+0x18a/0x3e0
   mlx5_rescan_drivers_locked+0xa9/0x210 [mlx5_core]
   mlx5_unregister_device+0x34/0x60 [mlx5_core]
   mlx5_uninit_one+0x32/0x100 [mlx5_core]
   remove_one+0x6e/0xe0 [mlx5_core]
   pci_device_remove+0x36/0xa0
   __device_release_driver+0x177/0x220
   device_driver_detach+0x3c/0xa0
   unbind_store+0x113/0x130
   kernfs_fop_write_iter+0x110/0x1a0
   new_sync_write+0x116/0x1a0
   vfs_write+0x1ba/0x260
   ksys_write+0x5f/0xe0
   do_syscall_64+0x3d/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 93f8244431ad ("RDMA/mlx5: Convert mlx5_ib to use auxiliary bus")
Link: https://lore.kernel.org/r/17ec98989b0ba88f7adfbad68eb20bce8d567b44.1628587493.git.leonro@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index cca7296b12d0..9bb562c7cd24 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4444,7 +4444,8 @@ static void mlx5r_mp_remove(struct auxiliary_device *adev)
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	if (mpi->ibdev)
 		mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
-	list_del(&mpi->list);
+	else
+		list_del(&mpi->list);
 	mutex_unlock(&mlx5_ib_multiport_mutex);
 	kfree(mpi);
 }
-- 
2.30.2



