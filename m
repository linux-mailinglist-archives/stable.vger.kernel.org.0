Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5454B45BA30
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbhKXMIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241088AbhKXMHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C6B260FDA;
        Wed, 24 Nov 2021 12:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755438;
        bh=gCQQNDmKf1uqJBVZy0plk3Kg+3S50LHl0Gtyt3/MMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2fF8jsU3xeA2wgFST42ZQDegL4Gn4j7FJtp0JPHPvonLbDW1jxT/+Cykgm00t8hh
         IORWZHw83D2662O9Pplh4I6Pav/4rKjtsfVKOgFpnSZLG9FbqLdoqFm9o/I2nivwFG
         2zgzyJqhrD6ijEynsxhcelNLn1C/pP0qtzMCoJU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 097/162] RDMA/mlx4: Return missed an error if device doesnt support steering
Date:   Wed, 24 Nov 2021 12:56:40 +0100
Message-Id: <20211124115701.463311266@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit f4e56ec4452f48b8292dcf0e1c4bdac83506fb8b ]

The error flow fixed in this patch is not possible because all kernel
users of create QP interface check that device supports steering before
set IB_QP_CREATE_NETIF_QP flag.

Fixes: c1c98501121e ("IB/mlx4: Add support for steerable IB UD QPs")
Link: https://lore.kernel.org/r/91c61f6e60eb0240f8bbc321fda7a1d2986dd03c.1634023677.git.leonro@nvidia.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index ecd461ee6dbe2..a15beb161b64c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -766,8 +766,10 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			if (dev->steering_support ==
 			    MLX4_STEERING_MODE_DEVICE_MANAGED)
 				qp->flags |= MLX4_IB_QP_NETIF;
-			else
+			else {
+				err = -EINVAL;
 				goto err;
+			}
 		}
 
 		err = set_kernel_sq_size(dev, &init_attr->cap, qp_type, qp);
-- 
2.33.0



