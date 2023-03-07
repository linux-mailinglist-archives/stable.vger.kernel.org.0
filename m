Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811696AEB13
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjCGRkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbjCGRjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:39:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753889DE15
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12121B81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60160C433D2;
        Tue,  7 Mar 2023 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210548;
        bh=sz5f/jOud0QOTKrqeQMz8PfDtCGLIE8Ln89W4S6AlBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3IRBIOsl+ZpQqK3T9FgJ+o2Xv/OKLLEdBkl+KYqesSq5m0sAkpQuC7tVBxuizWuU
         cnBqOe9NLFR2OSkZTk3CFHK5JZjYpBVqjHEvqqTeuAGyH4sRlrEQvCsmumvVCDVkv5
         inlnP7by18GcMsTQzWbtVlVVZgN+7B5K6Jgf5A9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bob Pearson <rpearsonhpe@gmail.com>,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0576/1001] Subject: RDMA/rxe: Handle zero length rdma
Date:   Tue,  7 Mar 2023 17:55:48 +0100
Message-Id: <20230307170046.455669136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 5ff31dfcd6d23f9c1bd5dd1a2c648ba499659357 ]

Currently the rxe driver does not handle all cases of zero length rdma
operations correctly. The client does not have to provide an rkey for zero
length RDMA read or write operations so the rkey provided may be invalid
and should not be used to lookup an mr.

This patch corrects the driver to ignore the provided rkey if the reth
length is zero for read or write operations and make sure to set the mr to
NULL. In read_reply() if length is zero rxe_recheck_mr() is not
called. Warnings are added in the routines in rxe_mr.c to catch NULL MRs
when the length is non-zero.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20230202044240.6304-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c   |  7 ++++
 drivers/infiniband/sw/rxe/rxe_resp.c | 59 +++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index c80458634962c..5e9a03831bf9f 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -314,6 +314,9 @@ int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 	if (length == 0)
 		return 0;
 
+	if (WARN_ON(!mr))
+		return -EINVAL;
+
 	if (mr->ibmr.type == IB_MR_TYPE_DMA) {
 		rxe_mr_copy_dma(mr, iova, addr, length, dir);
 		return 0;
@@ -432,6 +435,10 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length)
 	int err;
 	u8 *va;
 
+	/* mr must be valid even if length is zero */
+	if (WARN_ON(!mr))
+		return -EINVAL;
+
 	if (length == 0)
 		return 0;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index cd2d88de287ca..0cc1ba91d48cc 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -420,13 +420,23 @@ static enum resp_states rxe_resp_check_length(struct rxe_qp *qp,
 	return RESPST_CHK_RKEY;
 }
 
+/* if the reth length field is zero we can assume nothing
+ * about the rkey value and should not validate or use it.
+ * Instead set qp->resp.rkey to 0 which is an invalid rkey
+ * value since the minimum index part is 1.
+ */
 static void qp_resp_from_reth(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 {
+	unsigned int length = reth_len(pkt);
+
 	qp->resp.va = reth_va(pkt);
 	qp->resp.offset = 0;
-	qp->resp.rkey = reth_rkey(pkt);
-	qp->resp.resid = reth_len(pkt);
-	qp->resp.length = reth_len(pkt);
+	qp->resp.resid = length;
+	qp->resp.length = length;
+	if (pkt->mask & RXE_READ_OR_WRITE_MASK && length == 0)
+		qp->resp.rkey = 0;
+	else
+		qp->resp.rkey = reth_rkey(pkt);
 }
 
 static void qp_resp_from_atmeth(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
@@ -437,6 +447,10 @@ static void qp_resp_from_atmeth(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 	qp->resp.resid = sizeof(u64);
 }
 
+/* resolve the packet rkey to qp->resp.mr or set qp->resp.mr to NULL
+ * if an invalid rkey is received or the rdma length is zero. For middle
+ * or last packets use the stored value of mr.
+ */
 static enum resp_states check_rkey(struct rxe_qp *qp,
 				   struct rxe_pkt_info *pkt)
 {
@@ -473,10 +487,12 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		return RESPST_EXECUTE;
 	}
 
-	/* A zero-byte op is not required to set an addr or rkey. See C9-88 */
+	/* A zero-byte read or write op is not required to
+	 * set an addr or rkey. See C9-88
+	 */
 	if ((pkt->mask & RXE_READ_OR_WRITE_MASK) &&
-	    (pkt->mask & RXE_RETH_MASK) &&
-	    reth_len(pkt) == 0) {
+	    (pkt->mask & RXE_RETH_MASK) && reth_len(pkt) == 0) {
+		qp->resp.mr = NULL;
 		return RESPST_EXECUTE;
 	}
 
@@ -555,6 +571,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	return RESPST_EXECUTE;
 
 err:
+	qp->resp.mr = NULL;
 	if (mr)
 		rxe_put(mr);
 	if (mw)
@@ -885,7 +902,11 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	}
 
 	if (res->state == rdatm_res_state_new) {
-		if (!res->replay) {
+		if (!res->replay || qp->resp.length == 0) {
+			/* if length == 0 mr will be NULL (is ok)
+			 * otherwise qp->resp.mr holds a ref on mr
+			 * which we transfer to mr and drop below.
+			 */
 			mr = qp->resp.mr;
 			qp->resp.mr = NULL;
 		} else {
@@ -899,6 +920,10 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 		else
 			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST;
 	} else {
+		/* re-lookup mr from rkey on all later packets.
+		 * length will be non-zero. This can fail if someone
+		 * modifies or destroys the mr since the first packet.
+		 */
 		mr = rxe_recheck_mr(qp, res->read.rkey);
 		if (!mr)
 			return RESPST_ERR_RKEY_VIOLATION;
@@ -916,18 +941,16 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
 	if (!skb) {
-		if (mr)
-			rxe_put(mr);
-		return RESPST_ERR_RNR;
+		state = RESPST_ERR_RNR;
+		goto err_out;
 	}
 
 	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
 			  payload, RXE_FROM_MR_OBJ);
-	if (mr)
-		rxe_put(mr);
 	if (err) {
 		kfree_skb(skb);
-		return RESPST_ERR_RKEY_VIOLATION;
+		state = RESPST_ERR_RKEY_VIOLATION;
+		goto err_out;
 	}
 
 	if (bth_pad(&ack_pkt)) {
@@ -936,9 +959,12 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 		memset(pad, 0, bth_pad(&ack_pkt));
 	}
 
+	/* rxe_xmit_packet always consumes the skb */
 	err = rxe_xmit_packet(qp, &ack_pkt, skb);
-	if (err)
-		return RESPST_ERR_RNR;
+	if (err) {
+		state = RESPST_ERR_RNR;
+		goto err_out;
+	}
 
 	res->read.va += payload;
 	res->read.resid -= payload;
@@ -955,6 +981,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 		state = RESPST_CLEANUP;
 	}
 
+err_out:
+	if (mr)
+		rxe_put(mr);
 	return state;
 }
 
-- 
2.39.2



