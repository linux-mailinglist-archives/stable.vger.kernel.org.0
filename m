Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACAA2E4159
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439495AbgL1PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439503AbgL1OLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D78E207B2;
        Mon, 28 Dec 2020 14:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164637;
        bh=Ux3cNNEr5tLT19O/WXRK/23FBZOF07NfWvJnsvCfRdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy0fJ5uCOZt4xCqSiaxstCXfVTFY9qj21IhV04jTgU8DH/qnXcTb//i2v4Bysyu8p
         QXu3E/cqOt8bgl0SGpmqKbZxUw1UEpGaw+JThPJBEXqlpaZjOEoMQ44IAzUClE8AAd
         1zNEvuUdYZqrh0m/F1dw5dAo8Peh6a0T6Be89/pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/717] RDMA/hns: Only record vlan info for HIP08
Date:   Mon, 28 Dec 2020 13:43:32 +0100
Message-Id: <20201228125031.226315883@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 7406c0036f851ee1cd93cb08349f24b051b4cbf8 ]

Information about vlan is stored in GMV(GID/MAC/VLAN) table for HIP09, so
there is no need to copy it to address vector.

Link: https://lore.kernel.org/r/1605526408-6936-2-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c     | 51 ++++++++++-----------
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 13 ++++--
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 75b06db60f7c2..3be80d42e03a9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -31,13 +31,13 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pci.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
 #include "hns_roce_device.h"
 
-#define HNS_ROCE_PORT_NUM_SHIFT		24
-#define HNS_ROCE_VLAN_SL_BIT_MASK	7
-#define HNS_ROCE_VLAN_SL_SHIFT		13
+#define VLAN_SL_MASK 7
+#define VLAN_SL_SHIFT 13
 
 static inline u16 get_ah_udp_sport(const struct rdma_ah_attr *ah_attr)
 {
@@ -58,37 +58,16 @@ static inline u16 get_ah_udp_sport(const struct rdma_ah_attr *ah_attr)
 int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 		       struct ib_udata *udata)
 {
-	struct hns_roce_dev *hr_dev = to_hr_dev(ibah->device);
-	const struct ib_gid_attr *gid_attr;
-	struct device *dev = hr_dev->dev;
-	struct hns_roce_ah *ah = to_hr_ah(ibah);
 	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
-	u16 vlan_id = 0xffff;
-	bool vlan_en = false;
-	int ret;
-
-	gid_attr = ah_attr->grh.sgid_attr;
-	ret = rdma_read_gid_l2_fields(gid_attr, &vlan_id, NULL);
-	if (ret)
-		return ret;
+	struct hns_roce_dev *hr_dev = to_hr_dev(ibah->device);
+	struct hns_roce_ah *ah = to_hr_ah(ibah);
+	int ret = 0;
 
-	/* Get mac address */
 	memcpy(ah->av.mac, ah_attr->roce.dmac, ETH_ALEN);
 
-	if (vlan_id < VLAN_N_VID) {
-		vlan_en = true;
-		vlan_id |= (rdma_ah_get_sl(ah_attr) &
-			     HNS_ROCE_VLAN_SL_BIT_MASK) <<
-			     HNS_ROCE_VLAN_SL_SHIFT;
-	}
-
 	ah->av.port = rdma_ah_get_port_num(ah_attr);
 	ah->av.gid_index = grh->sgid_index;
-	ah->av.vlan_id = vlan_id;
-	ah->av.vlan_en = vlan_en;
-	dev_dbg(dev, "gid_index = 0x%x,vlan_id = 0x%x\n", ah->av.gid_index,
-		ah->av.vlan_id);
 
 	if (rdma_ah_get_static_rate(ah_attr))
 		ah->av.stat_rate = IB_RATE_10_GBPS;
@@ -98,7 +77,23 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	ah->av.flowlabel = grh->flow_label;
 	ah->av.udp_sport = get_ah_udp_sport(ah_attr);
 
-	return 0;
+	/* HIP08 needs to record vlan info in Address Vector */
+	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08) {
+		ah->av.vlan_en = 0;
+
+		ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr,
+					      &ah->av.vlan_id, NULL);
+		if (ret)
+			return ret;
+
+		if (ah->av.vlan_id < VLAN_N_VID) {
+			ah->av.vlan_en = 1;
+			ah->av.vlan_id |= (rdma_ah_get_sl(ah_attr) & VLAN_SL_MASK) <<
+					  VLAN_SL_SHIFT;
+		}
+	}
+
+	return ret;
 }
 
 int hns_roce_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 6d2acff69f982..b025841e08154 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -547,7 +547,7 @@ struct hns_roce_av {
 	u8 dgid[HNS_ROCE_GID_SIZE];
 	u8 mac[ETH_ALEN];
 	u16 vlan_id;
-	bool vlan_en;
+	u8 vlan_en;
 };
 
 struct hns_roce_ah {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0468028ffe390..d127e0e4c3cda 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -495,8 +495,6 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	roce_set_field(ud_sq_wqe->byte_32, V2_UD_SEND_WQE_BYTE_32_DQPN_M,
 		       V2_UD_SEND_WQE_BYTE_32_DQPN_S, ud_wr(wr)->remote_qpn);
 
-	roce_set_field(ud_sq_wqe->byte_36, V2_UD_SEND_WQE_BYTE_36_VLAN_M,
-		       V2_UD_SEND_WQE_BYTE_36_VLAN_S, ah->av.vlan_id);
 	roce_set_field(ud_sq_wqe->byte_36, V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_M,
 		       V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_S, ah->av.hop_limit);
 	roce_set_field(ud_sq_wqe->byte_36, V2_UD_SEND_WQE_BYTE_36_TCLASS_M,
@@ -508,11 +506,18 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	roce_set_field(ud_sq_wqe->byte_40, V2_UD_SEND_WQE_BYTE_40_PORTN_M,
 		       V2_UD_SEND_WQE_BYTE_40_PORTN_S, qp->port);
 
-	roce_set_bit(ud_sq_wqe->byte_40, V2_UD_SEND_WQE_BYTE_40_UD_VLAN_EN_S,
-		     ah->av.vlan_en ? 1 : 0);
 	roce_set_field(ud_sq_wqe->byte_48, V2_UD_SEND_WQE_BYTE_48_SGID_INDX_M,
 		       V2_UD_SEND_WQE_BYTE_48_SGID_INDX_S, ah->av.gid_index);
 
+	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08) {
+		roce_set_bit(ud_sq_wqe->byte_40,
+			     V2_UD_SEND_WQE_BYTE_40_UD_VLAN_EN_S,
+			     ah->av.vlan_en);
+		roce_set_field(ud_sq_wqe->byte_36,
+			       V2_UD_SEND_WQE_BYTE_36_VLAN_M,
+			       V2_UD_SEND_WQE_BYTE_36_VLAN_S, ah->av.vlan_id);
+	}
+
 	memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0], GID_LEN_V2);
 
 	set_extend_sge(qp, wr, &curr_idx, valid_num_sge);
-- 
2.27.0



