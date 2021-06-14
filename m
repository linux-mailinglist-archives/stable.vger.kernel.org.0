Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27BD3A624A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhFNK6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234210AbhFNK4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E7761424;
        Mon, 14 Jun 2021 10:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667269;
        bh=yQxys6AFAqEuGjbV0OeqfCLtaLZmstlnTDI3hMtYk4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGiKjzN+dzZvdWiOM7kgLpg8KXe98y6UQofDSVjTEL7El6n4hyjz73JVsmKGdo5GE
         25COZpD8ENrLMzb3AwFZDnryBsjGPOxI6vURkDCeanFD0AWjOWqbRBEhb/TrQdz2sH
         qBJmPE1H27D+YpTIR1LDMUy0MMcmSlLX+DniGAAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 66/84] RDMA/mlx4: Do not map the core_clock page to user space unless enabled
Date:   Mon, 14 Jun 2021 12:27:44 +0200
Message-Id: <20210614102648.616465350@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

commit 404e5a12691fe797486475fe28cc0b80cb8bef2c upstream.

Currently when mlx4 maps the hca_core_clock page to the user space there
are read-modifiable registers, one of which is semaphore, on this page as
well as the clock counter. If user reads the wrong offset, it can modify
the semaphore and hang the device.

Do not map the hca_core_clock page to the user space unless the device has
been put in a backwards compatibility mode to support this feature.

After this patch, mlx4 core_clock won't be mapped to user space on the
majority of existing devices and the uverbs device time feature in
ibv_query_rt_values_ex() will be disabled.

Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
Link: https://lore.kernel.org/r/9632304e0d6790af84b3b706d8c18732bc0d5e27.1622726305.git.leonro@nvidia.com
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/main.c         |    5 +----
 drivers/net/ethernet/mellanox/mlx4/fw.c   |    3 +++
 drivers/net/ethernet/mellanox/mlx4/fw.h   |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c |    6 ++++++
 include/linux/mlx4/device.h               |    1 +
 5 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -577,12 +577,9 @@ static int mlx4_ib_query_device(struct i
 	props->cq_caps.max_cq_moderation_count = MLX4_MAX_CQ_COUNT;
 	props->cq_caps.max_cq_moderation_period = MLX4_MAX_CQ_PERIOD;
 
-	if (!mlx4_is_slave(dev->dev))
-		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-
 	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
 		resp.response_length += sizeof(resp.hca_core_clock_offset);
-		if (!err && !mlx4_is_slave(dev->dev)) {
+		if (!mlx4_get_internal_clock_params(dev->dev, &clock_params)) {
 			resp.comp_mask |= MLX4_IB_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET;
 			resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
 		}
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -823,6 +823,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 #define QUERY_DEV_CAP_MAD_DEMUX_OFFSET		0xb0
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_BASE_OFFSET	0xa8
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_RANGE_OFFSET	0xac
+#define QUERY_DEV_CAP_MAP_CLOCK_TO_USER 0xc1
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_NUM_OFFSET	0xcc
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MAX_OFFSET	0xd0
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MIN_OFFSET	0xd2
@@ -841,6 +842,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 
 	if (mlx4_is_mfunc(dev))
 		disable_unsupported_roce_caps(outbox);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAP_CLOCK_TO_USER);
+	dev_cap->map_clock_to_user = field & 0x80;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_QP_OFFSET);
 	dev_cap->reserved_qps = 1 << (field & 0xf);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_OFFSET);
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -131,6 +131,7 @@ struct mlx4_dev_cap {
 	u32 health_buffer_addrs;
 	struct mlx4_port_cap port_cap[MLX4_MAX_PORTS + 1];
 	bool wol_port[MLX4_MAX_PORTS + 1];
+	bool map_clock_to_user;
 };
 
 struct mlx4_func_cap {
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -498,6 +498,7 @@ static int mlx4_dev_cap(struct mlx4_dev
 		}
 	}
 
+	dev->caps.map_clock_to_user  = dev_cap->map_clock_to_user;
 	dev->caps.uar_page_size	     = PAGE_SIZE;
 	dev->caps.num_uars	     = dev_cap->uar_size / PAGE_SIZE;
 	dev->caps.local_ca_ack_delay = dev_cap->local_ca_ack_delay;
@@ -1948,6 +1949,11 @@ int mlx4_get_internal_clock_params(struc
 	if (mlx4_is_slave(dev))
 		return -EOPNOTSUPP;
 
+	if (!dev->caps.map_clock_to_user) {
+		mlx4_dbg(dev, "Map clock to user is not supported.\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!params)
 		return -EINVAL;
 
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -632,6 +632,7 @@ struct mlx4_caps {
 	bool			wol_port[MLX4_MAX_PORTS + 1];
 	struct mlx4_rate_limit_caps rl_caps;
 	u32			health_buffer_addrs;
+	bool			map_clock_to_user;
 };
 
 struct mlx4_buf_list {


