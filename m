Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A69148060
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbgAXLK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbgAXLK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:10:26 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE8220708;
        Fri, 24 Jan 2020 11:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864226;
        bh=NxKSitTLrFjxskMIQYHG79kRZzyxU4AyPUZPCgK1PQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWPuvBFr+i3TFdLoF6H+afi4L6EkCq7WYCMf4z+ha8jBl1o8VBYtcqnpDGHkv81cy
         3zeuXmKldWKp+unLa0xn/JKDsvOWLzHcjzqOluoSDOtLzDE26mJ5CnTUdyJs11bilt
         qN8C/1++lh1HRCqOeSNjFfwVi39tkJML0VJl/FCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/639] RDMA/mlx5: Fix memory leak in case we fail to add an IB device
Date:   Fri, 24 Jan 2020 10:26:04 +0100
Message-Id: <20200124093111.376671852@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

[ Upstream commit fc9e4477f924e84d7798f7a1d41401d699de1219 ]

Make sure the IB device is freed on failure.

Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 35a0e04c38f28..b841589c27c9c 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -69,8 +69,10 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->mdev = dev;
 	ibdev->num_ports = max(MLX5_CAP_GEN(dev, num_ports),
 			       MLX5_CAP_GEN(dev, num_vhca_ports));
-	if (!__mlx5_ib_add(ibdev, &rep_profile))
+	if (!__mlx5_ib_add(ibdev, &rep_profile)) {
+		ib_dealloc_device(&ibdev->ib_dev);
 		return -EINVAL;
+	}
 
 	rep->rep_if[REP_IB].priv = ibdev;
 
-- 
2.20.1



