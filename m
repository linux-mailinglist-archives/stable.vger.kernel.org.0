Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD913F7FF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbgAPQ4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732440AbgAPQ4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E3021D56;
        Thu, 16 Jan 2020 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193782;
        bh=JemEe1H5CcvrWV3tN3BWUWsjUXNDtweXcova/OIDpkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogIUSPwhBmnW5LZ5RMjBprsYkpD8sbj4RHtpsasB7VjiJoXutshe1U9jN9ZciD6kt
         TrkbQMNJd9H+2omfOGpZv0xLD1vFdBAvW31W2UvRbsCeqmNSC6ATkkAseBiDn+NngJ
         GBQKKnExP49GEsTyuEtb/b6HprV2F+u5w7rUaSMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitko Haralanov <mitko.haralanov@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 060/671] IB/hfi1: Correctly process FECN and BECN in packets
Date:   Thu, 16 Jan 2020 11:44:51 -0500
Message-Id: <20200116165502.8838-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

[ Upstream commit fe4dd4239277486ca3a468e7bbeafd7ef3a5634e ]

A CA is supposed to ignore FECN bits in multicast, ACK, and CNP
packets. This patch corrects the behavior of the HFI1 driver in this
regard by ignoring FECNs in those packet types.

While fixing the above behavior, fix the extraction of the FECN and BECN
bits from the packet headers for both 9B and 16B packets.

Furthermore, this patch corrects the driver's response to a FECN in RDMA
READ RESPONSE packets. Instead of sending an "empty" ACK, the driver now
sends a CNP packet. While editing that code path, add the missing trace
for CNP packets.

Fixes: 88733e3b8450 ("IB/hfi1: Add 16B UD support")
Fixes: f59fb9e05109 ("IB/hfi1: Fix handling of FECN marked multicast packet")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/driver.c | 70 ++++++++++++++++++++---------
 drivers/infiniband/hw/hfi1/hfi.h    | 35 ++++++++++-----
 drivers/infiniband/hw/hfi1/rc.c     | 30 +++++--------
 drivers/infiniband/hw/hfi1/uc.c     |  2 +-
 drivers/infiniband/hw/hfi1/ud.c     | 33 ++++++++------
 5 files changed, 104 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index a41f85558312..d5277c23cba6 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -430,40 +430,60 @@ static const hfi1_handle_cnp hfi1_handle_cnp_tbl[2] = {
 	[HFI1_PKT_TYPE_16B] = &return_cnp_16B
 };
 
-void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
-			       bool do_cnp)
+/**
+ * hfi1_process_ecn_slowpath - Process FECN or BECN bits
+ * @qp: The packet's destination QP
+ * @pkt: The packet itself.
+ * @prescan: Is the caller the RXQ prescan
+ *
+ * Process the packet's FECN or BECN bits. By now, the packet
+ * has already been evaluated whether processing of those bit should
+ * be done.
+ * The significance of the @prescan argument is that if the caller
+ * is the RXQ prescan, a CNP will be send out instead of waiting for the
+ * normal packet processing to send an ACK with BECN set (or a CNP).
+ */
+bool hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
+			       bool prescan)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct ib_other_headers *ohdr = pkt->ohdr;
 	struct ib_grh *grh = pkt->grh;
-	u32 rqpn = 0, bth1;
+	u32 rqpn = 0;
 	u16 pkey;
 	u32 rlid, slid, dlid = 0;
-	u8 hdr_type, sc, svc_type;
-	bool is_mcast = false;
+	u8 hdr_type, sc, svc_type, opcode;
+	bool is_mcast = false, ignore_fecn = false, do_cnp = false,
+		fecn, becn;
 
 	/* can be called from prescan */
 	if (pkt->etype == RHF_RCV_TYPE_BYPASS) {
-		is_mcast = hfi1_is_16B_mcast(dlid);
 		pkey = hfi1_16B_get_pkey(pkt->hdr);
 		sc = hfi1_16B_get_sc(pkt->hdr);
 		dlid = hfi1_16B_get_dlid(pkt->hdr);
 		slid = hfi1_16B_get_slid(pkt->hdr);
+		is_mcast = hfi1_is_16B_mcast(dlid);
+		opcode = ib_bth_get_opcode(ohdr);
 		hdr_type = HFI1_PKT_TYPE_16B;
+		fecn = hfi1_16B_get_fecn(pkt->hdr);
+		becn = hfi1_16B_get_becn(pkt->hdr);
 	} else {
-		is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
-			   (dlid != be16_to_cpu(IB_LID_PERMISSIVE));
 		pkey = ib_bth_get_pkey(ohdr);
 		sc = hfi1_9B_get_sc5(pkt->hdr, pkt->rhf);
-		dlid = ib_get_dlid(pkt->hdr);
+		dlid = qp->ibqp.qp_type != IB_QPT_UD ? ib_get_dlid(pkt->hdr) :
+			ppd->lid;
 		slid = ib_get_slid(pkt->hdr);
+		is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+			   (dlid != be16_to_cpu(IB_LID_PERMISSIVE));
+		opcode = ib_bth_get_opcode(ohdr);
 		hdr_type = HFI1_PKT_TYPE_9B;
+		fecn = ib_bth_get_fecn(ohdr);
+		becn = ib_bth_get_becn(ohdr);
 	}
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_UD:
-		dlid = ppd->lid;
 		rlid = slid;
 		rqpn = ib_get_sqpn(pkt->ohdr);
 		svc_type = IB_CC_SVCTYPE_UD;
@@ -485,22 +505,31 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 		svc_type = IB_CC_SVCTYPE_RC;
 		break;
 	default:
-		return;
+		return false;
 	}
 
-	bth1 = be32_to_cpu(ohdr->bth[1]);
+	ignore_fecn = is_mcast || (opcode == IB_OPCODE_CNP) ||
+		(opcode == IB_OPCODE_RC_ACKNOWLEDGE);
+	/*
+	 * ACKNOWLEDGE packets do not get a CNP but this will be
+	 * guarded by ignore_fecn above.
+	 */
+	do_cnp = prescan ||
+		(opcode >= IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST &&
+		 opcode <= IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE);
+
 	/* Call appropriate CNP handler */
-	if (do_cnp && (bth1 & IB_FECN_SMASK))
+	if (!ignore_fecn && do_cnp && fecn)
 		hfi1_handle_cnp_tbl[hdr_type](ibp, qp, rqpn, pkey,
 					      dlid, rlid, sc, grh);
 
-	if (!is_mcast && (bth1 & IB_BECN_SMASK)) {
-		u32 lqpn = bth1 & RVT_QPN_MASK;
+	if (becn) {
+		u32 lqpn = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		u8 sl = ibp->sc_to_sl[sc];
 
 		process_becn(ppd, sl, rlid, lqpn, rqpn, svc_type);
 	}
-
+	return !ignore_fecn && fecn;
 }
 
 struct ps_mdata {
@@ -599,7 +628,6 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		struct rvt_dev_info *rdi = &rcd->dd->verbs_dev.rdi;
 		u64 rhf = rhf_to_cpu(rhf_addr);
 		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
-		int is_ecn = 0;
 		u8 lnh;
 
 		if (ps_done(&mdata, rhf, rcd))
@@ -625,12 +653,10 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 			goto next; /* just in case */
 		}
 
-		bth1 = be32_to_cpu(packet->ohdr->bth[1]);
-		is_ecn = !!(bth1 & (IB_FECN_SMASK | IB_BECN_SMASK));
-
-		if (!is_ecn)
+		if (!hfi1_may_ecn(packet))
 			goto next;
 
+		bth1 = be32_to_cpu(packet->ohdr->bth[1]);
 		qpn = bth1 & RVT_QPN_MASK;
 		rcu_read_lock();
 		qp = rvt_lookup_qpn(rdi, &ibp->rvp, qpn);
@@ -640,7 +666,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 			goto next;
 		}
 
-		process_ecn(qp, packet, true);
+		hfi1_process_ecn_slowpath(qp, packet, true);
 		rcu_read_unlock();
 
 		/* turn off BECN, FECN */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2ea42c04cfd2..232fc4b59a98 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1797,13 +1797,20 @@ static inline struct hfi1_ibport *rcd_to_iport(struct hfi1_ctxtdata *rcd)
 	return &rcd->ppd->ibport_data;
 }
 
-void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
-			       bool do_cnp);
-static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
-			       bool do_cnp)
+/**
+ * hfi1_may_ecn - Check whether FECN or BECN processing should be done
+ * @pkt: the packet to be evaluated
+ *
+ * Check whether the FECN or BECN bits in the packet's header are
+ * enabled, depending on packet type.
+ *
+ * This function only checks for FECN and BECN bits. Additional checks
+ * are done in the slowpath (hfi1_process_ecn_slowpath()) in order to
+ * ensure correct handling.
+ */
+static inline bool hfi1_may_ecn(struct hfi1_packet *pkt)
 {
-	bool becn;
-	bool fecn;
+	bool fecn, becn;
 
 	if (pkt->etype == RHF_RCV_TYPE_BYPASS) {
 		fecn = hfi1_16B_get_fecn(pkt->hdr);
@@ -1812,10 +1819,18 @@ static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
 		fecn = ib_bth_get_fecn(pkt->ohdr);
 		becn = ib_bth_get_becn(pkt->ohdr);
 	}
-	if (unlikely(fecn || becn)) {
-		hfi1_process_ecn_slowpath(qp, pkt, do_cnp);
-		return fecn;
-	}
+	return fecn || becn;
+}
+
+bool hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
+			       bool prescan);
+static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt)
+{
+	bool do_work;
+
+	do_work = hfi1_may_ecn(pkt);
+	if (unlikely(do_work))
+		return hfi1_process_ecn_slowpath(qp, pkt, false);
 	return false;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 770c78c65730..980168a56707 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2049,8 +2049,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	struct ib_reth *reth;
 	unsigned long flags;
 	int ret;
-	bool is_fecn = false;
-	bool copy_last = false;
+	bool copy_last = false, fecn;
 	u32 rkey;
 	u8 extra_bytes = pad + packet->extra_byte + (SIZE_OF_CRC << 2);
 
@@ -2059,7 +2058,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	if (hfi1_ruc_check_hdr(ibp, packet))
 		return;
 
-	is_fecn = process_ecn(qp, packet, false);
+	fecn = process_ecn(qp, packet);
 
 	/*
 	 * Process responses (ACKs) before anything else.  Note that the
@@ -2070,8 +2069,6 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	if (opcode >= OP(RDMA_READ_RESPONSE_FIRST) &&
 	    opcode <= OP(ATOMIC_ACKNOWLEDGE)) {
 		rc_rcv_resp(packet);
-		if (is_fecn)
-			goto send_ack;
 		return;
 	}
 
@@ -2347,11 +2344,11 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 
 		/* Schedule the send engine. */
 		qp->s_flags |= RVT_S_RESP_PENDING;
+		if (fecn)
+			qp->s_flags |= RVT_S_ECN;
 		hfi1_schedule_send(qp);
 
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		if (is_fecn)
-			goto send_ack;
 		return;
 	}
 
@@ -2413,11 +2410,11 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 
 		/* Schedule the send engine. */
 		qp->s_flags |= RVT_S_RESP_PENDING;
+		if (fecn)
+			qp->s_flags |= RVT_S_ECN;
 		hfi1_schedule_send(qp);
 
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		if (is_fecn)
-			goto send_ack;
 		return;
 	}
 
@@ -2430,16 +2427,9 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	qp->r_ack_psn = psn;
 	qp->r_nak_state = 0;
 	/* Send an ACK if requested or required. */
-	if (psn & IB_BTH_REQ_ACK) {
-		if (packet->numpkt == 0) {
-			rc_cancel_ack(qp);
-			goto send_ack;
-		}
-		if (qp->r_adefered >= HFI1_PSN_CREDIT) {
-			rc_cancel_ack(qp);
-			goto send_ack;
-		}
-		if (unlikely(is_fecn)) {
+	if (psn & IB_BTH_REQ_ACK || fecn) {
+		if (packet->numpkt == 0 || fecn ||
+		    qp->r_adefered >= HFI1_PSN_CREDIT) {
 			rc_cancel_ack(qp);
 			goto send_ack;
 		}
@@ -2480,7 +2470,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 send_ack:
-	hfi1_send_rc_ack(packet, is_fecn);
+	hfi1_send_rc_ack(packet, fecn);
 }
 
 void hfi1_rc_hdrerr(
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index e254dcec6f64..4121d1a93b1b 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -321,7 +321,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	if (hfi1_ruc_check_hdr(ibp, packet))
 		return;
 
-	process_ecn(qp, packet, true);
+	process_ecn(qp, packet);
 
 	psn = ib_bth_get_psn(ohdr);
 	/* Compare the PSN verses the expected PSN. */
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 54eb69564264..ef5b3ffd3888 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -51,6 +51,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "verbs_txreq.h"
+#include "trace_ibhdrs.h"
 #include "qp.h"
 
 /* We support only two types - 9B and 16B for now */
@@ -656,18 +657,19 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 	u32 bth0, plen, vl, hwords = 7;
 	u16 len;
 	u8 l4;
-	struct hfi1_16b_header hdr;
+	struct hfi1_opa_header hdr;
 	struct ib_other_headers *ohdr;
 	struct pio_buf *pbuf;
 	struct send_context *ctxt = qp_to_send_context(qp, sc5);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u32 nwords;
 
+	hdr.hdr_type = HFI1_PKT_TYPE_16B;
 	/* Populate length */
 	nwords = ((hfi1_get_16b_padding(hwords << 2, 0) +
 		   SIZE_OF_LT) >> 2) + SIZE_OF_CRC;
 	if (old_grh) {
-		struct ib_grh *grh = &hdr.u.l.grh;
+		struct ib_grh *grh = &hdr.opah.u.l.grh;
 
 		grh->version_tclass_flow = old_grh->version_tclass_flow;
 		grh->paylen = cpu_to_be16(
@@ -675,11 +677,11 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 		grh->hop_limit = 0xff;
 		grh->sgid = old_grh->dgid;
 		grh->dgid = old_grh->sgid;
-		ohdr = &hdr.u.l.oth;
+		ohdr = &hdr.opah.u.l.oth;
 		l4 = OPA_16B_L4_IB_GLOBAL;
 		hwords += sizeof(struct ib_grh) / sizeof(u32);
 	} else {
-		ohdr = &hdr.u.oth;
+		ohdr = &hdr.opah.u.oth;
 		l4 = OPA_16B_L4_IB_LOCAL;
 	}
 
@@ -693,7 +695,7 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 
 	/* Convert dwords to flits */
 	len = (hwords + nwords) >> 1;
-	hfi1_make_16b_hdr(&hdr, slid, dlid, len, pkey, 1, 0, l4, sc5);
+	hfi1_make_16b_hdr(&hdr.opah, slid, dlid, len, pkey, 1, 0, l4, sc5);
 
 	plen = 2 /* PBC */ + hwords + nwords;
 	pbc_flags |= PBC_PACKET_BYPASS | PBC_INSERT_BYPASS_ICRC;
@@ -701,9 +703,11 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf)
+		if (pbuf) {
+			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
+		}
 	}
 }
 
@@ -715,14 +719,15 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	u32 bth0, plen, vl, hwords = 5;
 	u16 lrh0;
 	u8 sl = ibp->sc_to_sl[sc5];
-	struct ib_header hdr;
+	struct hfi1_opa_header hdr;
 	struct ib_other_headers *ohdr;
 	struct pio_buf *pbuf;
 	struct send_context *ctxt = qp_to_send_context(qp, sc5);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
+	hdr.hdr_type = HFI1_PKT_TYPE_9B;
 	if (old_grh) {
-		struct ib_grh *grh = &hdr.u.l.grh;
+		struct ib_grh *grh = &hdr.ibh.u.l.grh;
 
 		grh->version_tclass_flow = old_grh->version_tclass_flow;
 		grh->paylen = cpu_to_be16(
@@ -730,11 +735,11 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 		grh->hop_limit = 0xff;
 		grh->sgid = old_grh->dgid;
 		grh->dgid = old_grh->sgid;
-		ohdr = &hdr.u.l.oth;
+		ohdr = &hdr.ibh.u.l.oth;
 		lrh0 = HFI1_LRH_GRH;
 		hwords += sizeof(struct ib_grh) / sizeof(u32);
 	} else {
-		ohdr = &hdr.u.oth;
+		ohdr = &hdr.ibh.u.oth;
 		lrh0 = HFI1_LRH_BTH;
 	}
 
@@ -746,16 +751,18 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	ohdr->bth[1] = cpu_to_be32(remote_qpn | (1 << IB_BECN_SHIFT));
 	ohdr->bth[2] = 0; /* PSN 0 */
 
-	hfi1_make_ib_hdr(&hdr, lrh0, hwords + SIZE_OF_CRC, dlid, slid);
+	hfi1_make_ib_hdr(&hdr.ibh, lrh0, hwords + SIZE_OF_CRC, dlid, slid);
 	plen = 2 /* PBC */ + hwords;
 	pbc_flags |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 	vl = sc_to_vlt(ppd->dd, sc5);
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf)
+		if (pbuf) {
+			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
+		}
 	}
 }
 
@@ -912,7 +919,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		src_qp = hfi1_16B_get_src_qpn(packet->mgmt);
 	}
 
-	process_ecn(qp, packet, (opcode != IB_OPCODE_CNP));
+	process_ecn(qp, packet);
 	/*
 	 * Get the number of bytes the message was padded by
 	 * and drop incomplete packets.
-- 
2.20.1

