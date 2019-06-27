Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82473577E8
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfF0Aeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbfF0Aeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:44 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D57F2183F;
        Thu, 27 Jun 2019 00:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595684;
        bh=7He2H5il0KlxV7ZS8vcK7Wju/7mKDKB3JcGAcJMylYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9WyjAie4qHBX3aqiuhNMHsJOxxqHQdnSnriI4VDxV03Ll4aGWXN+KJKr0zbcyFex
         EkLgouuD++QYk0WJbfntuvI3njOx/kxoANKSznS/g6EugnLbHtMknKhk8eQg+GRUdt
         28UyDN5sjPZIQByaVeY+dUdnpTuQTaanzmgskGb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 78/95] IB/hfi1: Create inline to get extended headers
Date:   Wed, 26 Jun 2019 20:30:03 -0400
Message-Id: <20190627003021.19867-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

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

