Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0B838EEBA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhEXPzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234305AbhEXPwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C5E61421;
        Mon, 24 May 2021 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870736;
        bh=9jSqaYi/xw4W9JJyRsUvikrclDD0lQfIWeSxnrvTXtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf4Dnehtol2pp/Bz57EkWIkSlq8mUG5R3Fa4faetsDa4BoqXQeEaNyM6G2ybuZs7U
         1/x1JFVbkchFtzpo0iBtp0oGF0IMyfOjvEfzhzPhZWHCneO4UzPDL2JVQOp80oDxRt
         +2AO1wERgmXZKTj3UvtiQmTEV96Od7PFyWnw3KyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/104] RDMA/mlx5: Recover from fatal event in dual port mode
Date:   Mon, 24 May 2021 17:25:06 +0200
Message-Id: <20210524152333.206881525@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 97f30d324ce6645a4de4ffb71e4ae9b8ca36ff04 ]

When there is fatal event on the slave port, the device is marked as not
active. We need to mark it as active again when the slave is recovered to
regain full functionality.

Fixes: d69a24e03659 ("IB/mlx5: Move IB event processing onto a workqueue")
Link: https://lore.kernel.org/r/8906754455bb23019ef223c725d2c0d38acfb80b.1620711734.git.leonro@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index beec0d7c0d6e..b19506707e45 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4762,6 +4762,7 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
 
 		if (bound) {
 			rdma_roce_rescan_device(&dev->ib_dev);
+			mpi->ibdev->ib_active = true;
 			break;
 		}
 	}
-- 
2.30.2



