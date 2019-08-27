Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12389E0C1
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfH0IFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbfH0IFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45B102173E;
        Tue, 27 Aug 2019 08:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893139;
        bh=csSfjwxSUvEH7WsttKF+LGRqTSc7mgMPIgBk3UMBVcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkeOek4E+B8n5IVtPyCpVxq/9Vsnps0YkCyUKC9mpRJA5l/9MC/t6EsXL8ojFaNbf
         vk4dngMxEGJSKHeoYWOFljXjUpCqx4JzCEtdv7CqCKzSa5Ez3BedVb/xFyCFdvAUnU
         /PyoydVy34XLkZp2Bnv8ovEKrAA5gl8mJOjFrMmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 133/162] IB/hfi1: Drop stale TID RDMA packets that cause TIDErr
Date:   Tue, 27 Aug 2019 09:51:01 +0200
Message-Id: <20190827072743.191279632@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit d9d1f5e7bb82415591e8b62b222cbb88c4797ef3 upstream.

In a congested fabric with adaptive routing enabled, traces show that
packets could be delivered out of order. A stale TID RDMA data packet
could lead to TidErr if the TID entries have been released by duplicate
data packets generated from retries, and subsequently erroneously force
the qp into error state in the current implementation.

Since the payload has already been dropped by hardware, the packet can
be simply dropped and it is no longer necessary to put the qp into
error state.

Fixes: 9905bf06e890 ("IB/hfi1: Add functions to receive TID RDMA READ response")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20190815192058.105923.72324.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |   47 ++--------------------------------
 1 file changed, 3 insertions(+), 44 deletions(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2576,18 +2576,9 @@ void hfi1_kern_read_tid_flow_free(struct
 	hfi1_kern_clear_hw_flow(priv->rcd, qp);
 }
 
-static bool tid_rdma_tid_err(struct hfi1_ctxtdata *rcd,
-			     struct hfi1_packet *packet, u8 rcv_type,
-			     u8 opcode)
+static bool tid_rdma_tid_err(struct hfi1_packet *packet, u8 rcv_type)
 {
 	struct rvt_qp *qp = packet->qp;
-	struct hfi1_qp_priv *qpriv = qp->priv;
-	u32 ipsn;
-	struct ib_other_headers *ohdr = packet->ohdr;
-	struct rvt_ack_entry *e;
-	struct tid_rdma_request *req;
-	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
-	u32 i;
 
 	if (rcv_type >= RHF_RCV_TYPE_IB)
 		goto done;
@@ -2604,41 +2595,9 @@ static bool tid_rdma_tid_err(struct hfi1
 	if (rcv_type == RHF_RCV_TYPE_EAGER) {
 		hfi1_restart_rc(qp, qp->s_last_psn + 1, 1);
 		hfi1_schedule_send(qp);
-		goto done_unlock;
-	}
-
-	/*
-	 * For TID READ response, error out QP after freeing the tid
-	 * resources.
-	 */
-	if (opcode == TID_OP(READ_RESP)) {
-		ipsn = mask_psn(be32_to_cpu(ohdr->u.tid_rdma.r_rsp.verbs_psn));
-		if (cmp_psn(ipsn, qp->s_last_psn) > 0 &&
-		    cmp_psn(ipsn, qp->s_psn) < 0) {
-			hfi1_kern_read_tid_flow_free(qp);
-			spin_unlock(&qp->s_lock);
-			rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
-			goto done;
-		}
-		goto done_unlock;
 	}
 
-	/*
-	 * Error out the qp for TID RDMA WRITE
-	 */
-	hfi1_kern_clear_hw_flow(qpriv->rcd, qp);
-	for (i = 0; i < rvt_max_atomic(rdi); i++) {
-		e = &qp->s_ack_queue[i];
-		if (e->opcode == TID_OP(WRITE_REQ)) {
-			req = ack_to_tid_req(e);
-			hfi1_kern_exp_rcv_clear_all(req);
-		}
-	}
-	spin_unlock(&qp->s_lock);
-	rvt_rc_error(qp, IB_WC_LOC_LEN_ERR);
-	goto done;
-
-done_unlock:
+	/* Since no payload is delivered, just drop the packet */
 	spin_unlock(&qp->s_lock);
 done:
 	return true;
@@ -2927,7 +2886,7 @@ bool hfi1_handle_kdeth_eflags(struct hfi
 		if (lnh == HFI1_LRH_GRH)
 			goto r_unlock;
 
-		if (tid_rdma_tid_err(rcd, packet, rcv_type, opcode))
+		if (tid_rdma_tid_err(packet, rcv_type))
 			goto r_unlock;
 	}
 


