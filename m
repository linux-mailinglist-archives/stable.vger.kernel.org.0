Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C850B577EB
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfF0Aet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbfF0Aes (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:48 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F329420659;
        Thu, 27 Jun 2019 00:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595687;
        bh=Adm0JGqDudvxPVIz58HrH0Bl/ZhjfWVLIrlTHZxS4Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgsgP5l9LRqRC90YPHtpGcQmmsmq7AyyIAUULLHeIg5NzFIOLYeoSUBnpr2WrWOPE
         mcTCzovGKaZ2H7uLSMvkb6NyCjcVwr7qMsWUgs9S+btGSYlUMyjnJnMg+aJQ0eii/u
         dbcWiXqALE7UnU245CoY2QiFXnN20LQ+JhKKsUvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 79/95] IB/hfi1: Use aborts to trigger RC throttling
Date:   Wed, 26 Jun 2019 20:30:04 -0400
Message-Id: <20190627003021.19867-79-sashal@kernel.org>
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

[ Upstream commit 4bb02e9572af1383038d83ad196d7166c515f2ee ]

SDMA and pio flushes will cause a lot of packets to be transmitted
after a link has gone down, using a lot of CPU to retransmit
packets.

Fix for RC QPs by recognizing the flush status and:
- Forcing a timer start
- Putting the QP into a "send one" mode

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/rc.c    | 30 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/verbs.c | 10 ++++++----
 drivers/infiniband/hw/hfi1/verbs.h |  1 +
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 82f101878e33..24cbac277bf0 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1703,6 +1703,36 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 	}
 }
 
+/**
+ * hfi1_rc_verbs_aborted - handle abort status
+ * @qp: the QP
+ * @opah: the opa header
+ *
+ * This code modifies both ACK bit in BTH[2]
+ * and the s_flags to go into send one mode.
+ *
+ * This serves to throttle the send engine to only
+ * send a single packet in the likely case the
+ * a link has gone down.
+ */
+void hfi1_rc_verbs_aborted(struct rvt_qp *qp, struct hfi1_opa_header *opah)
+{
+	struct ib_other_headers *ohdr = hfi1_get_rc_ohdr(opah);
+	u8 opcode = ib_bth_get_opcode(ohdr);
+	u32 psn;
+
+	/* ignore responses */
+	if ((opcode >= OP(RDMA_READ_RESPONSE_FIRST) &&
+	     opcode <= OP(ATOMIC_ACKNOWLEDGE)) ||
+	    opcode == TID_OP(READ_RESP) ||
+	    opcode == TID_OP(WRITE_RESP))
+		return;
+
+	psn = ib_bth_get_psn(ohdr) | IB_BTH_REQ_ACK;
+	ohdr->bth[2] = cpu_to_be32(psn);
+	qp->s_flags |= RVT_S_SEND_ONE;
+}
+
 /*
  * This should be called with the QP s_lock held and interrupts disabled.
  */
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 55a56b3d7f83..8d64972c6226 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -638,6 +638,8 @@ static void verbs_sdma_complete(
 		struct hfi1_opa_header *hdr;
 
 		hdr = &tx->phdr.hdr;
+		if (unlikely(status == SDMA_TXREQ_S_ABORTED))
+			hfi1_rc_verbs_aborted(qp, hdr);
 		hfi1_rc_send_complete(qp, hdr);
 	}
 	spin_unlock(&qp->s_lock);
@@ -1095,15 +1097,15 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			       &ps->s_txreq->phdr.hdr, ib_is_sc5(sc5));
 
 pio_bail:
+	spin_lock_irqsave(&qp->s_lock, flags);
 	if (qp->s_wqe) {
-		spin_lock_irqsave(&qp->s_lock, flags);
 		rvt_send_complete(qp, qp->s_wqe, wc_status);
-		spin_unlock_irqrestore(&qp->s_lock, flags);
 	} else if (qp->ibqp.qp_type == IB_QPT_RC) {
-		spin_lock_irqsave(&qp->s_lock, flags);
+		if (unlikely(wc_status == IB_WC_GENERAL_ERR))
+			hfi1_rc_verbs_aborted(qp, &ps->s_txreq->phdr.hdr);
 		hfi1_rc_send_complete(qp, &ps->s_txreq->phdr.hdr);
-		spin_unlock_irqrestore(&qp->s_lock, flags);
 	}
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 
 	ret = 0;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 62ace0b2d17a..1714c0f6475d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -415,6 +415,7 @@ void hfi1_rc_hdrerr(
 
 u8 ah_to_sc(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr);
 
+void hfi1_rc_verbs_aborted(struct rvt_qp *qp, struct hfi1_opa_header *opah);
 void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah);
 
 void hfi1_ud_rcv(struct hfi1_packet *packet);
-- 
2.20.1

