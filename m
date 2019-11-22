Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E501070B0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKVKkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbfKVKkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 284CD20731;
        Fri, 22 Nov 2019 10:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419200;
        bh=TqqrcKleofOp6WEaP0GxHanALfR3V+fgwguyLNso3HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwd5tvHUVuPo4RtKyBZzbYFYilRTk/sj4G9xtP7UzlkEipZERxJ1kjrw+Dx/OqQyc
         y04rOEm9HRnn9Ry/4sNeNNqQacEaZ8ug2ySICVZi0zAr3GHpElNEoH7mBcpY8jvRsd
         jXkoujYSNoZgADVB/qGkVyGiflkJtg3KB5WpSCFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vijay Immanuel <vijayi@attalasystems.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/222] IB/rxe: fixes for rdma read retry
Date:   Fri, 22 Nov 2019 11:26:12 +0100
Message-Id: <20191122100843.117303445@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijay Immanuel <vijayi@attalasystems.com>

[ Upstream commit 030e46e495af855a13964a0aab9753ea82a96edc ]

When a read request is retried for the remaining partial
data, the response may restart from read response first
or read response only. So support those cases.

Do not advance the comp psn beyond the current wqe's last_psn
as that could skip over an entire read wqe and will cause the
req_retry() logic to set an incorrect req psn.
An example sequence is as follows:
Write        PSN 40 -- this is the current WQE.
Read request PSN 41
Write        PSN 42
Receive ACK  PSN 42 -- this will complete the current WQE
for PSN 40, and set the comp psn to 42 which is a problem
because the read request at PSN 41 has been skipped over.
So when req_retry() tries to retransmit the read request,
it sets the req psn to 42 which is incorrect.

When retrying a read request, calculate the number of psns
completed based on the dma resid instead of the wqe first_psn.
The wqe first_psn could have moved if the read request was
retried multiple times.

Set the reth length to the dma resid to handle read retries for
the remaining partial data.

Signed-off-by: Vijay Immanuel <vijayi@attalasystems.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 21 ++++++++++++++++-----
 drivers/infiniband/sw/rxe/rxe_req.c  | 15 +++++++++------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index df15b6d7b645e..b03a6206d9be7 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -250,6 +250,17 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
 		if (pkt->opcode != IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE &&
 		    pkt->opcode != IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST) {
+			/* read retries of partial data may restart from
+			 * read response first or response only.
+			 */
+			if ((pkt->psn == wqe->first_psn &&
+			     pkt->opcode ==
+			     IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST) ||
+			    (wqe->first_psn == wqe->last_psn &&
+			     pkt->opcode ==
+			     IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY))
+				break;
+
 			return COMPST_ERROR;
 		}
 		break;
@@ -486,11 +497,11 @@ static inline enum comp_state complete_wqe(struct rxe_qp *qp,
 					   struct rxe_pkt_info *pkt,
 					   struct rxe_send_wqe *wqe)
 {
-	qp->comp.opcode = -1;
-
-	if (pkt) {
-		if (psn_compare(pkt->psn, qp->comp.psn) >= 0)
-			qp->comp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+	if (pkt && wqe->state == wqe_state_pending) {
+		if (psn_compare(wqe->last_psn, qp->comp.psn) >= 0) {
+			qp->comp.psn = (wqe->last_psn + 1) & BTH_PSN_MASK;
+			qp->comp.opcode = -1;
+		}
 
 		if (qp->req.wait_psn) {
 			qp->req.wait_psn = 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 0f9fe2ca2a91a..6fb771290c566 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -72,9 +72,6 @@ static void req_retry(struct rxe_qp *qp)
 	int npsn;
 	int first = 1;
 
-	wqe = queue_head(qp->sq.queue);
-	npsn = (qp->comp.psn - wqe->first_psn) & BTH_PSN_MASK;
-
 	qp->req.wqe_index	= consumer_index(qp->sq.queue);
 	qp->req.psn		= qp->comp.psn;
 	qp->req.opcode		= -1;
@@ -106,11 +103,17 @@ static void req_retry(struct rxe_qp *qp)
 		if (first) {
 			first = 0;
 
-			if (mask & WR_WRITE_OR_SEND_MASK)
+			if (mask & WR_WRITE_OR_SEND_MASK) {
+				npsn = (qp->comp.psn - wqe->first_psn) &
+					BTH_PSN_MASK;
 				retry_first_write_send(qp, wqe, mask, npsn);
+			}
 
-			if (mask & WR_READ_MASK)
+			if (mask & WR_READ_MASK) {
+				npsn = (wqe->dma.length - wqe->dma.resid) /
+					qp->mtu;
 				wqe->iova += npsn * qp->mtu;
+			}
 		}
 
 		wqe->state = wqe_state_posted;
@@ -439,7 +442,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	if (pkt->mask & RXE_RETH_MASK) {
 		reth_set_rkey(pkt, ibwr->wr.rdma.rkey);
 		reth_set_va(pkt, wqe->iova);
-		reth_set_len(pkt, wqe->dma.length);
+		reth_set_len(pkt, wqe->dma.resid);
 	}
 
 	if (pkt->mask & RXE_IMMDT_MASK)
-- 
2.20.1



