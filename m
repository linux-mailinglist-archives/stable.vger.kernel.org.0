Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECECD329064
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbhCAUH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236047AbhCATyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F69F65374;
        Mon,  1 Mar 2021 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621305;
        bh=zWJhlexKRPzvsEIywDB49H/mnDMVnxL9dReZqlwLcS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyghEEkgIUABfAGl190G9FEKvYmvqNkIjPgZHRY11Tb+8/ESPPEBX4RB9LK+2Y2rJ
         sNHDJ+0a9pXrtuELVt1Um7Ve/TfNZKpf+KXRFZSJp4OpmPc39bgu9odYTOytPw+1cZ
         7/dkDToVAxHmVd+N9arBTa1HEtclx5JFds3aS618=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 437/775] RDMA/hns: Avoid filling sgid index when modifying QP to RTR
Date:   Mon,  1 Mar 2021 17:10:05 +0100
Message-Id: <20210301161223.158260040@linuxfoundation.org>
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

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 773f841ab1aeb0134e3872eb3545592732db8218 ]

ULP usually set IB(V)_QP_AV when trying to modify QP to RTR if they want
to record sgid index into QPC. For UD QPs, it is useless because it will
be included in WQE. For RC QPs, it will be filled in
hns_roce_set_path(). So sgid index shouldn't be filled by default. Then
hns_get_gid_index() is moved to hns_roce_hw_v1.c because it is only called
in it.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1612517974-31867-2-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 16 ++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 11 -----------
 drivers/infiniband/hw/hns/hns_roce_main.c  | 16 ----------------
 3 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index f68585ff8e8a5..c2539a8d91116 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -43,6 +43,22 @@
 #include "hns_roce_hem.h"
 #include "hns_roce_hw_v1.h"
 
+/**
+ * hns_get_gid_index - Get gid index.
+ * @hr_dev: pointer to structure hns_roce_dev.
+ * @port:  port, value range: 0 ~ MAX
+ * @gid_index:  gid_index, value range: 0 ~ MAX
+ * Description:
+ *    N ports shared gids, allocation method as follow:
+ *		GID[0][0], GID[1][0],.....GID[N - 1][0],
+ *		GID[0][0], GID[1][0],.....GID[N - 1][0],
+ *		And so on
+ */
+u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u8 port, int gid_index)
+{
+	return gid_index * hr_dev->caps.num_ports + port;
+}
+
 static void set_data_seg(struct hns_roce_wqe_data_seg *dseg, struct ib_sge *sg)
 {
 	dseg->lkey = cpu_to_le32(sg->lkey);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a909993552e7f..b8f6d5f706ddc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4254,7 +4254,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 				 struct hns_roce_v2_qp_context *context,
 				 struct hns_roce_v2_qp_context *qpc_mask)
 {
-	const struct ib_global_route *grh = rdma_ah_read_grh(&attr->ah_attr);
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
 	struct ib_device *ibdev = &hr_dev->ib_dev;
@@ -4262,7 +4261,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	dma_addr_t irrl_ba;
 	enum ib_mtu mtu;
 	u8 lp_pktn_ini;
-	u8 port_num;
 	u64 *mtts;
 	u8 *dmac;
 	u8 *smac;
@@ -4343,15 +4341,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 			       V2_QPC_BYTE_56_DQPN_M, V2_QPC_BYTE_56_DQPN_S, 0);
 	}
 
-	/* Configure GID index */
-	port_num = rdma_ah_get_port_num(&attr->ah_attr);
-	roce_set_field(context->byte_20_smac_sgid_idx,
-		       V2_QPC_BYTE_20_SGID_IDX_M, V2_QPC_BYTE_20_SGID_IDX_S,
-		       hns_get_gid_index(hr_dev, port_num - 1,
-					 grh->sgid_index));
-	roce_set_field(qpc_mask->byte_20_smac_sgid_idx,
-		       V2_QPC_BYTE_20_SGID_IDX_M, V2_QPC_BYTE_20_SGID_IDX_S, 0);
-
 	memcpy(&(context->dmac), dmac, sizeof(u32));
 	roce_set_field(context->byte_52_udpspn_dmac, V2_QPC_BYTE_52_DMAC_M,
 		       V2_QPC_BYTE_52_DMAC_S, *((u16 *)(&dmac[4])));
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 60822e666f351..baadb12b13752 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -42,22 +42,6 @@
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
 
-/**
- * hns_get_gid_index - Get gid index.
- * @hr_dev: pointer to structure hns_roce_dev.
- * @port:  port, value range: 0 ~ MAX
- * @gid_index:  gid_index, value range: 0 ~ MAX
- * Description:
- *    N ports shared gids, allocation method as follow:
- *		GID[0][0], GID[1][0],.....GID[N - 1][0],
- *		GID[0][0], GID[1][0],.....GID[N - 1][0],
- *		And so on
- */
-u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u8 port, int gid_index)
-{
-	return gid_index * hr_dev->caps.num_ports + port;
-}
-
 static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u8 port, u8 *addr)
 {
 	u8 phy_port;
-- 
2.27.0



