Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034D029B8D7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802040AbgJ0Pp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801054AbgJ0PiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56067204EF;
        Tue, 27 Oct 2020 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813079;
        bh=1ZBQqB9hexAqQUh9Lu1vSxs6w7eRviRmEhklF1XVEJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhMV/dbGIjyHPGxynDZaS8W/bBLmzoEHCX/TZLa8xCLv14hn68Dl+TEYDxtmAyVi/
         p8U9/zmIq/3Qmhjjc5dOPKL5Y38JFiDRMxrKGy5VISzt48Dynl9AY0nMVQCNgc3OLv
         HXhXrdVbqHJDAUpHRc+O2ROyaGrS9C8EK4fPJ9q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 430/757] RDMA: Change XRCD destroy return value
Date:   Tue, 27 Oct 2020 14:51:20 +0100
Message-Id: <20201027135510.734879167@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit d0c45c8556e57342d44c9548763609ffcc4e3866 ]

Update XRCD destroy flow to allow command failure.

Fixes: 28ad5f65c314 ("RDMA: Move XRCD to be under ib_core responsibility")
Link: https://lore.kernel.org/r/20200907120921.476363-8-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c      | 8 ++++++--
 drivers/infiniband/hw/mlx4/main.c    | 3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/qp.c      | 4 ++--
 include/rdma/ib_verbs.h              | 2 +-
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c8b650f240d5f..b411be9321bdf 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2333,13 +2333,17 @@ EXPORT_SYMBOL(ib_alloc_xrcd_user);
  */
 int ib_dealloc_xrcd_user(struct ib_xrcd *xrcd, struct ib_udata *udata)
 {
+	int ret;
+
 	if (atomic_read(&xrcd->usecnt))
 		return -EBUSY;
 
 	WARN_ON(!xa_empty(&xrcd->tgt_qps));
-	xrcd->device->ops.dealloc_xrcd(xrcd, udata);
+	ret = xrcd->device->ops.dealloc_xrcd(xrcd, udata);
+	if (ret)
+		return ret;
 	kfree(xrcd);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd_user);
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bd4f975e7f9ac..d22bf9a4b53e2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1256,11 +1256,12 @@ static int mlx4_ib_alloc_xrcd(struct ib_xrcd *ibxrcd, struct ib_udata *udata)
 	return err;
 }
 
-static void mlx4_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
+static int mlx4_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
 {
 	ib_destroy_cq(to_mxrcd(xrcd)->cq);
 	ib_dealloc_pd(to_mxrcd(xrcd)->pd);
 	mlx4_xrcd_free(to_mdev(xrcd->device)->dev, to_mxrcd(xrcd)->xrcdn);
+	return 0;
 }
 
 static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0d4b88389beb8..2f06677adaa2a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1193,7 +1193,7 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index);
 int mlx5_ib_alloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata);
-void mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata);
+int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata);
 int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset);
 int mlx5_query_ext_port_caps(struct mlx5_ib_dev *dev, u8 port);
 int mlx5_query_mad_ifc_smp_attr_node_info(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5758dbe640451..cda7608b6f2d9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4716,12 +4716,12 @@ int mlx5_ib_alloc_xrcd(struct ib_xrcd *ibxrcd, struct ib_udata *udata)
 	return mlx5_cmd_xrcd_alloc(dev->mdev, &xrcd->xrcdn, 0);
 }
 
-void mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
+int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(xrcd->device);
 	u32 xrcdn = to_mxrcd(xrcd)->xrcdn;
 
-	mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, 0);
+	return mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, 0);
 }
 
 static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f64c1d02b9350..8cccbdef5de2a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2468,7 +2468,7 @@ struct ib_device_ops {
 	int (*attach_mcast)(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 	int (*detach_mcast)(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 	int (*alloc_xrcd)(struct ib_xrcd *xrcd, struct ib_udata *udata);
-	void (*dealloc_xrcd)(struct ib_xrcd *xrcd, struct ib_udata *udata);
+	int (*dealloc_xrcd)(struct ib_xrcd *xrcd, struct ib_udata *udata);
 	struct ib_flow *(*create_flow)(struct ib_qp *qp,
 				       struct ib_flow_attr *flow_attr,
 				       int domain, struct ib_udata *udata);
-- 
2.25.1



