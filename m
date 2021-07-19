Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679743CDD2D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbhGSO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237492AbhGSOzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C77F461289;
        Mon, 19 Jul 2021 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708803;
        bh=YmzPmwEShVO25GiSLAbnzROIBybUrODjscdfomNiyL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qd+oXhkTtQdvaytMds9K3VUorxG+0ltzRYGpHWkD8fELPn1GnsCZSFfxGc0mbckI2
         GgSxk2IgsVGgABqkiLCtVTUEOcyJ0mqOSgZ34AntSeBK55oT2XAnl9znrpQQ+rleT+
         uLkeilG2aVb2eNj3dIuQddusWY86vpC9quGW6Jok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/421] RDMA/mlx5: Dont add slave port to unaffiliated list
Date:   Mon, 19 Jul 2021 16:49:07 +0200
Message-Id: <20210719144951.223271329@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7ce6095e3bff8e20ce018b050960b527e298f7df ]

The mlx5_ib_bind_slave_port() doesn't remove multiport device from the
unaffiliated list, but mlx5_ib_unbind_slave_port() did it. This unbalanced
flow caused to the situation where mlx5_ib_unaffiliated_port_list was
changed during iteration.

Fixes: 32f69e4be269 ("{net, IB}/mlx5: Manage port association for multiport RoCE")
Link: https://lore.kernel.org/r/2726e6603b1e6ecfe76aa5a12a063af72173bcf7.1622477058.git.leonro@nvidia.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 13513466df01..eaf9de421f8d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5374,8 +5374,6 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	port->mp.mpi = NULL;
 
-	list_add_tail(&mpi->list, &mlx5_ib_unaffiliated_port_list);
-
 	spin_unlock(&port->mp.mpi_lock);
 
 	err = mlx5_nic_vport_unaffiliate_multiport(mpi->mdev);
@@ -5525,6 +5523,8 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
 			} else {
 				mlx5_ib_dbg(dev, "unbinding port_num: %d\n", i + 1);
 				mlx5_ib_unbind_slave_port(dev, dev->port[i].mp.mpi);
+				list_add_tail(&dev->port[i].mp.mpi->list,
+					      &mlx5_ib_unaffiliated_port_list);
 			}
 		}
 	}
-- 
2.30.2



