Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397103A64BA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhFNL2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235332AbhFNL0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C39A613B2;
        Mon, 14 Jun 2021 10:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668086;
        bh=dKj/h68lRjd2qOK8trPtIhOpFIHLWd5kT1CS6j/nmrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJi4VWpl80n88H//vNwhQT+zMfM/7ZVaVf30xuiEZDtSyaucyr9BY5oXKTc8VKJWM
         SZVE+aCXeJbUh9CKLy/FfA+GdnE6LX/UNhGluau+vvSoi9zZ4CNx0a+z7TmLbrjVZt
         C3hDJ/Oe+aJ8NpX1L50jcrOyoYnz8iRLSIoAjj8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.12 141/173] RDMA: Verify port when creating flow rule
Date:   Mon, 14 Jun 2021 12:27:53 +0200
Message-Id: <20210614102702.855321350@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

commit 2adcb4c5a52a2623cd2b43efa7041e74d19f3a5e upstream.

Validate port value provided by the user and with that remove no longer
needed validation by the driver.  The missing check in the mlx5_ib driver
could cause to the below oops.

Call trace:
  _create_flow_rule+0x2d4/0xf28 [mlx5_ib]
  mlx5_ib_create_flow+0x2d0/0x5b0 [mlx5_ib]
  ib_uverbs_ex_create_flow+0x4cc/0x624 [ib_uverbs]
  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xd4/0x150 [ib_uverbs]
  ib_uverbs_cmd_verbs.isra.7+0xb28/0xc50 [ib_uverbs]
  ib_uverbs_ioctl+0x158/0x1d0 [ib_uverbs]
  do_vfs_ioctl+0xd0/0xaf0
  ksys_ioctl+0x84/0xb4
  __arm64_sys_ioctl+0x28/0xc4
  el0_svc_common.constprop.3+0xa4/0x254
  el0_svc_handler+0x84/0xa0
  el0_svc+0x10/0x26c
 Code: b9401260 f9615681 51000400 8b001c20 (f9403c1a)

Fixes: 436f2ad05a0b ("IB/core: Export ib_create/destroy_flow through uverbs")
Link: https://lore.kernel.org/r/faad30dc5219a01727f47db3dc2f029d07c82c00.1623309971.git.leonro@nvidia.com
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    5 +++++
 drivers/infiniband/hw/mlx4/main.c    |    3 ---
 drivers/infiniband/hw/mlx5/fs.c      |    5 ++---
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3247,6 +3247,11 @@ static int ib_uverbs_ex_create_flow(stru
 		goto err_free_attr;
 	}
 
+	if (!rdma_is_port_valid(uobj->context->device, cmd.flow_attr.port)) {
+		err = -EINVAL;
+		goto err_uobj;
+	}
+
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
 	if (!qp) {
 		err = -EINVAL;
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1696,9 +1696,6 @@ static struct ib_flow *mlx4_ib_create_fl
 	struct mlx4_dev *dev = (to_mdev(qp->device))->dev;
 	int is_bonded = mlx4_is_bonded(dev);
 
-	if (!rdma_is_port_valid(qp->device, flow_attr->port))
-		return ERR_PTR(-EINVAL);
-
 	if (flow_attr->flags & ~IB_FLOW_ATTR_FLAGS_DONT_TRAP)
 		return ERR_PTR(-EOPNOTSUPP);
 
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1194,9 +1194,8 @@ static struct ib_flow *mlx5_ib_create_fl
 		goto free_ucmd;
 	}
 
-	if (flow_attr->port > dev->num_ports ||
-	    (flow_attr->flags &
-	     ~(IB_FLOW_ATTR_FLAGS_DONT_TRAP | IB_FLOW_ATTR_FLAGS_EGRESS))) {
+	if (flow_attr->flags &
+	    ~(IB_FLOW_ATTR_FLAGS_DONT_TRAP | IB_FLOW_ATTR_FLAGS_EGRESS)) {
 		err = -EINVAL;
 		goto free_ucmd;
 	}


