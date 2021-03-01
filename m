Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797D4329014
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhCAUCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhCATvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:51:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 867DB6510F;
        Mon,  1 Mar 2021 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621137;
        bh=+o6Gu9ayQ+NmJn5NmMhUbfyDlLHxn4bPsXWVXRZBnAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6Ei/laTclvxt+mhd5XascymZjAkPV6YgK8TlXNjn/o9wVt80E7yzSxKS20wv+UOG
         kBSipBqeiAxtp/UJg0eBCToz8NECwAG30GXkbDz7xhPPvCnQkDw5uEceBC6giApfGs
         1RtzRh9xGrK6GZs540xHzv521TaAoYWx1j9BqZPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 407/775] IB/mlx5: Return appropriate error code instead of ENOMEM
Date:   Mon,  1 Mar 2021 17:09:35 +0100
Message-Id: <20210301161221.698037642@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit d286ac1d05210695c312b9018b3aa7c2048e9aca ]

When mlx5_ib_stage_init_init() fails, return the error code related to
failure instead of -ENOMEM.

Fixes: 16c1975f1032 ("IB/mlx5: Create profile infrastructure to add and remove stages")
Link: https://lore.kernel.org/r/20210127150010.1876121-8-leon@kernel.org
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9b772457286f2..3562e69eacb14 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3995,8 +3995,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 
 err_mp:
 	mlx5_ib_cleanup_multiport_master(dev);
-
-	return -ENOMEM;
+	return err;
 }
 
 static int mlx5_ib_enable_driver(struct ib_device *dev)
-- 
2.27.0



