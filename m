Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056823C49CE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbhGLGqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237194AbhGLGqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A51610E6;
        Mon, 12 Jul 2021 06:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072104;
        bh=nAjsGB3+A0Mnx7P+unvOZVIFvjnyHdfIqbT4NaQKvLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuoXcymUUBYdOBu8yDbVhrKFoadXgsoPrBzuvWA/u/6qR5u0jmJiutI0Y1eK50YAy
         +ZO9kO8YWxROxi+szssY6ssTflNfgRO4g6AnRhWnI7DBm1pdxw3poeO03I1KYKrrFL
         qIURcO1FksjkJuAnuAqVwypwYGP7hAh5PHuFtnuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/593] RDMA/mlx5: Dont add slave port to unaffiliated list
Date:   Mon, 12 Jul 2021 08:08:36 +0200
Message-Id: <20210712060925.516667863@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index b19506707e45..60aceb3b47a5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3440,8 +3440,6 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	port->mp.mpi = NULL;
 
-	list_add_tail(&mpi->list, &mlx5_ib_unaffiliated_port_list);
-
 	spin_unlock(&port->mp.mpi_lock);
 
 	err = mlx5_nic_vport_unaffiliate_multiport(mpi->mdev);
@@ -3595,6 +3593,8 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
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



