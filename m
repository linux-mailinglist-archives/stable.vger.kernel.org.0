Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A68466E67
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGLM2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbfGLM2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD0D208E4;
        Fri, 12 Jul 2019 12:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934496;
        bh=tmEmSKGMfhw83BlgPKUkMGYugBLo6ioLpkf1J4gqIBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIjq6SBDW0+w8/1ljBFTbmtoHH7sd1RypUpUR4NTJELBQLyBLtsVKOnzlh7/dkKwQ
         5gGfaFD1THVw2ntxTimtpiBlNDPqbwxdTT47BWHJFB1BMyGnjcAA8mDrDtuLL/Ptav
         kuj9Z7oIH/11KMNbwyvdA7chLJzzxFdHCYuLKCBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 072/138] IB/hfi1: Create inline to get extended headers
Date:   Fri, 12 Jul 2019 14:18:56 +0200
Message-Id: <20190712121631.442816850@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9755f72496664eec70bc804104118b5797b6bf63 ]

This paves the way for another patch that reacts to a
flush sdma completion for RC.

Fixes: 81cd3891f021 ("IB/hfi1: Add support for 16B Management Packets")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/hfi.h | 31 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/rc.c  | 21 +--------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 048b5d73ba39..d85b16a3aaaf 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -539,6 +539,37 @@ static inline void hfi1_16B_set_qpn(struct opa_16b_mgmt *mgmt,
 	mgmt->src_qpn = cpu_to_be32(src_qp & OPA_16B_MGMT_QPN_MASK);
 }
 
+/**
+ * hfi1_get_rc_ohdr - get extended header
+ * @opah - the opaheader
+ */
+static inline struct ib_other_headers *
+hfi1_get_rc_ohdr(struct hfi1_opa_header *opah)
+{
+	struct ib_other_headers *ohdr;
+	struct ib_header *hdr = NULL;
+	struct hfi1_16b_header *hdr_16b = NULL;
+
+	/* Find out where the BTH is */
+	if (opah->hdr_type == HFI1_PKT_TYPE_9B) {
+		hdr = &opah->ibh;
+		if (ib_get_lnh(hdr) == HFI1_LRH_BTH)
+			ohdr = &hdr->u.oth;
+		else
+			ohdr = &hdr->u.l.oth;
+	} else {
+		u8 l4;
+
+		hdr_16b = &opah->opah;
+		l4  = hfi1_16B_get_l4(hdr_16b);
+		if (l4 == OPA_16B_L4_IB_LOCAL)
+			ohdr = &hdr_16b->u.oth;
+		else
+			ohdr = &hdr_16b->u.l.oth;
+	}
+	return ohdr;
+}
+
 struct rvt_sge_state;
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 5991211d72bd..82f101878e33 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1711,8 +1711,6 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 	struct ib_other_headers *ohdr;
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct rvt_swqe *wqe;
-	struct ib_header *hdr = NULL;
-	struct hfi1_16b_header *hdr_16b = NULL;
 	u32 opcode, head, tail;
 	u32 psn;
 	struct tid_rdma_request *req;
@@ -1721,24 +1719,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 	if (!(ib_rvt_state_ops[qp->state] & RVT_SEND_OR_FLUSH_OR_RECV_OK))
 		return;
 
-	/* Find out where the BTH is */
-	if (priv->hdr_type == HFI1_PKT_TYPE_9B) {
-		hdr = &opah->ibh;
-		if (ib_get_lnh(hdr) == HFI1_LRH_BTH)
-			ohdr = &hdr->u.oth;
-		else
-			ohdr = &hdr->u.l.oth;
-	} else {
-		u8 l4;
-
-		hdr_16b = &opah->opah;
-		l4  = hfi1_16B_get_l4(hdr_16b);
-		if (l4 == OPA_16B_L4_IB_LOCAL)
-			ohdr = &hdr_16b->u.oth;
-		else
-			ohdr = &hdr_16b->u.l.oth;
-	}
-
+	ohdr = hfi1_get_rc_ohdr(opah);
 	opcode = ib_bth_get_opcode(ohdr);
 	if ((opcode >= OP(RDMA_READ_RESPONSE_FIRST) &&
 	     opcode <= OP(ATOMIC_ACKNOWLEDGE)) ||
-- 
2.20.1



