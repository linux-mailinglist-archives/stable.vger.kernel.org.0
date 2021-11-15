Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80199450E60
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhKOSOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238451AbhKOSHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D78A633A1;
        Mon, 15 Nov 2021 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998292;
        bh=55lL8uulT8XdG1MaepOPi9KIpP4N9v2b8WKmFvB41KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsaZZc3kqmmieqHbqxSXwx46DDRKOkMqpCdQSQtZ9+3GdTTsbkjcxvze0hcVs68Fp
         +24mjANWoQ0NvKR1ywicbclN18RuQzLonXYKtq53tYaBFm4SO4SSyzeSMPJwWmGY9B
         6rCsnU00YJuG7TFJPb5nwf1fDRrBTgZY5vo3qG2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/575] RDMA/mlx4: Return missed an error if device doesnt support steering
Date:   Mon, 15 Nov 2021 18:02:35 +0100
Message-Id: <20211115165358.652287621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 6bc0818f4b2c6..c6a815a705fef 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1099,8 +1099,10 @@ static int create_qp_common(struct ib_pd *pd, struct ib_qp_init_attr *init_attr,
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



