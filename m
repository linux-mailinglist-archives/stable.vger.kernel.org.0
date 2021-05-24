Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B541438EDE0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhEXPnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhEXPlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F0BE61448;
        Mon, 24 May 2021 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870479;
        bh=f2CEMHPJSzwJ1neyGt4aMJSk9pnhTKqaeY8szgUbAD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ5A0m3/oPElSzDYhrvmSNJW9GouCYBjN5UbdwyrLJ3UsKjicVJ80Ic0bGB0GtXco
         VHRoxBNqhIC2KuSljvOZ0JjAgGZoHeonuoSBghAAsR4vNkTAIH2rrM74dqBqshl7Fv
         OR7aUfl+NkSHp/OUUzGHEW3UAc66fOhh//pt1YpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/49] RDMA/mlx5: Recover from fatal event in dual port mode
Date:   Mon, 24 May 2021 17:25:16 +0200
Message-Id: <20210524152324.559105044@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
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
index 1695605eeb52..13513466df01 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6339,6 +6339,7 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
 
 		if (bound) {
 			rdma_roce_rescan_device(&dev->ib_dev);
+			mpi->ibdev->ib_active = true;
 			break;
 		}
 	}
-- 
2.30.2



