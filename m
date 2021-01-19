Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736282FAF26
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 04:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbhASDdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 22:33:13 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:7433 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728599AbhASDdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 22:33:09 -0500
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2021 22:33:09 EST
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 18 Jan 2021 19:16:27 -0800
Received: from sc-dbc2135.eng.vmware.com (sc-dbc2135.eng.vmware.com [10.182.28.35])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id CF177202C3;
        Mon, 18 Jan 2021 19:16:29 -0800 (PST)
From:   Bryan Tan <bryantan@vmware.com>
To:     <linux-rdma@vger.kernel.org>
CC:     <pv-drivers@vmware.com>, <stable@vger.kernel.org>,
        Bryan Tan <bryantan@vmware.com>
Subject: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Fix network_hdr_type reported in WC
Date:   Mon, 18 Jan 2021 19:16:29 -0800
Message-ID: <1611026189-17943-1-git-send-email-bryantan@vmware.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: bryantan@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PVRDMA device defines network_hdr_type according to an old
definition of the rdma_network_type enum that has since changed,
resulting in the wrong rdma_network_type being reported. Fix this by
explicitly defining the enum used by the PVRDMA device and adding a
function to convert the pvrdma_network_type to rdma_network_type enum.

Cc: stable@vger.kernel.org # 5.10+
Fixes: 1c15b4f2a42f ("RDMA/core: Modify enum ib_gid_type and enum rdma_network_type")
Reviewed-by: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Bryan Tan <bryantan@vmware.com>
---

Changelog:
 - v0->v1: Moved new enum to uapi header and added Cc as per Jason.
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 14 ++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  2 +-
 include/uapi/rdma/vmw_pvrdma-abi.h           |  7 +++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index c142f5e7f25f..de57f2fed743 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -509,6 +509,20 @@ static inline int ib_send_flags_to_pvrdma(int flags)
 	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
 }
 
+static inline int pvrdma_network_type_to_ib(enum pvrdma_network_type type)
+{
+	switch (type) {
+	case PVRDMA_NETWORK_ROCE_V1:
+		return RDMA_NETWORK_ROCE_V1;
+	case PVRDMA_NETWORK_IPV4:
+		return RDMA_NETWORK_IPV4;
+	case PVRDMA_NETWORK_IPV6:
+		return RDMA_NETWORK_IPV6;
+	default:
+		return RDMA_NETWORK_IPV6;
+	}
+}
+
 void pvrdma_qp_cap_to_ib(struct ib_qp_cap *dst,
 			 const struct pvrdma_qp_cap *src);
 void ib_qp_cap_to_pvrdma(struct pvrdma_qp_cap *dst,
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index a119ac3e103c..6aa40bd2fd52 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -367,7 +367,7 @@ static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
 	wc->dlid_path_bits = cqe->dlid_path_bits;
 	wc->port_num = cqe->port_num;
 	wc->vendor_err = cqe->vendor_err;
-	wc->network_hdr_type = cqe->network_hdr_type;
+	wc->network_hdr_type = pvrdma_network_type_to_ib(cqe->network_hdr_type);
 
 	/* Update shared ring state */
 	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);
diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
index f8b638c73371..901a4fd72c09 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -133,6 +133,13 @@ enum pvrdma_wc_flags {
 	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
 };
 
+enum pvrdma_network_type {
+	PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_ROCE_V1 = PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_IPV4,
+	PVRDMA_NETWORK_IPV6
+};
+
 struct pvrdma_alloc_ucontext_resp {
 	__u32 qp_tab_size;
 	__u32 reserved;
-- 
2.14.1

