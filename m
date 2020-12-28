Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D012E403B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441621AbgL1OTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441604AbgL1OTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59292063A;
        Mon, 28 Dec 2020 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165133;
        bh=3a+ctO0yqJxck/oNVejavCFPkt1+69fp32cMpyrDFTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ1w929EVz3gcuewbWvWdWaUV8mlhIGD4E+61w8lmLH8U6hyGgmlDwjDlEkiseUdl
         Vq2dcPNDn25q2cltTV9AuX/Xck0s1X7SR2DZgo8IWdbrD080EmJ03IDVxuKSu5/KAV
         jyV6M5/xit2Xm7xg/Z233rdfxcvWjkXNA6lp86bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/717] RDMA/hns: Do shift on traffic class when using RoCEv2
Date:   Mon, 28 Dec 2020 13:47:02 +0100
Message-Id: <20201228125041.278633547@linuxfoundation.org>
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

[ Upstream commit 603bee935f38080a3674c763c50787751e387779 ]

The high 6 bits of traffic class in GRH is DSCP (Differentiated Services
Codepoint), the driver should shift it before the hardware gets it when
using RoCEv2.

Fixes: 606bf89e98ef ("RDMA/hns: Refactor for hns_roce_v2_modify_qp function")
Fixes: fba429fcf9a5 ("RDMA/hns: Fix missing fields in address vector")
Link: https://lore.kernel.org/r/1607650657-35992-4-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c     |  2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h |  8 ++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 10 +++-------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index d65ff6aa322fa..7dd3b6097226f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -74,7 +74,7 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	ah->av.flowlabel = grh->flow_label;
 	ah->av.udp_sport = get_ah_udp_sport(ah_attr);
 	ah->av.sl = rdma_ah_get_sl(ah_attr);
-	ah->av.tclass = grh->traffic_class;
+	ah->av.tclass = get_tclass(grh);
 
 	memcpy(ah->av.dgid, grh->dgid.raw, HNS_ROCE_GID_SIZE);
 	memcpy(ah->av.mac, ah_attr->roce.dmac, ETH_ALEN);
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index b025841e08154..1ea87f92aabbe 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1132,6 +1132,14 @@ static inline u32 to_hr_hem_entries_shift(u32 count, u32 buf_shift)
 	return ilog2(to_hr_hem_entries_count(count, buf_shift));
 }
 
+#define DSCP_SHIFT 2
+
+static inline u8 get_tclass(const struct ib_global_route *grh)
+{
+	return grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP ?
+	       grh->traffic_class >> DSCP_SHIFT : grh->traffic_class;
+}
+
 int hns_roce_init_uar_table(struct hns_roce_dev *dev);
 int hns_roce_uar_alloc(struct hns_roce_dev *dev, struct hns_roce_uar *uar);
 void hns_roce_uar_free(struct hns_roce_dev *dev, struct hns_roce_uar *uar);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c287dbd2f384d..5c29c7d8c50e6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4460,15 +4460,11 @@ static int hns_roce_v2_set_path(struct ib_qp *ibqp,
 	roce_set_field(qpc_mask->byte_24_mtu_tc, V2_QPC_BYTE_24_HOP_LIMIT_M,
 		       V2_QPC_BYTE_24_HOP_LIMIT_S, 0);
 
-	if (is_udp)
-		roce_set_field(context->byte_24_mtu_tc, V2_QPC_BYTE_24_TC_M,
-			       V2_QPC_BYTE_24_TC_S, grh->traffic_class >> 2);
-	else
-		roce_set_field(context->byte_24_mtu_tc, V2_QPC_BYTE_24_TC_M,
-			       V2_QPC_BYTE_24_TC_S, grh->traffic_class);
-
+	roce_set_field(context->byte_24_mtu_tc, V2_QPC_BYTE_24_TC_M,
+		       V2_QPC_BYTE_24_TC_S, get_tclass(&attr->ah_attr.grh));
 	roce_set_field(qpc_mask->byte_24_mtu_tc, V2_QPC_BYTE_24_TC_M,
 		       V2_QPC_BYTE_24_TC_S, 0);
+
 	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_FL_M,
 		       V2_QPC_BYTE_28_FL_S, grh->flow_label);
 	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_FL_M,
-- 
2.27.0



