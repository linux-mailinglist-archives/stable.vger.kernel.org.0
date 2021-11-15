Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326FE450C37
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbhKORft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237480AbhKORcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D89632A8;
        Mon, 15 Nov 2021 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996834;
        bh=pMCSECvJmYp7OjOX2yS00hoQUxaDJR21oxnGiGGWS+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4ktJyU2oA9eH+ahID3pSlL2Ir/Nv98Q3GxeFja6LP+mcDkqXD1JtY7o09exYACCc
         s5Pd2keLbNfSO5OkyZBnZ2h0IayxmB+vfFd6tSaApPlNlYW3cjp5HYp2nGTKhQ3KpC
         GaMHLfVs0/aW8jrvdguXacWCfnpEa5IGbJexx6/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 277/355] RDMA/mlx4: Return missed an error if device doesnt support steering
Date:   Mon, 15 Nov 2021 18:03:21 +0100
Message-Id: <20211115165322.693323502@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 17ce928e41bde..bca5358f3ef29 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1149,8 +1149,10 @@ static int create_qp_common(struct ib_pd *pd, struct ib_qp_init_attr *init_attr,
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



