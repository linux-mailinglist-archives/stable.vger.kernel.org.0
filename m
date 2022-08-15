Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92875594B59
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352141AbiHPAOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357445AbiHPANg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF4515D888;
        Mon, 15 Aug 2022 13:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2194B61057;
        Mon, 15 Aug 2022 20:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F8C433D6;
        Mon, 15 Aug 2022 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595406;
        bh=FsTM63fKqrQhD58pgBUPeFDJ8S+3PWu0hrxKXaYf4pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IY36NvoyrjGi8I3f6MXgxflsgU48QpmsYKpl4gBL6eK6lh5py23MqYLpBPnSQKqox
         EuYRQHFEPbJB1BupevJ27loCGVsdAvBhhGLoHY0iJD3vl+xWI32/c7BrWmWX7ziPqy
         QAa228nrH+07nu2WVtd2r1C+PjBJAhABzdxMLen8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0753/1157] RDMA/rxe: Add a responder state for atomic reply
Date:   Mon, 15 Aug 2022 20:01:49 +0200
Message-Id: <20220815180509.629844107@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 0ed5493e430a1d887eb62b45c75dd5d6bb2dcf48 ]

Add a responder state for atomic reply similar to read reply and rename
process_atomic() rxe_atomic_reply(). In preparation for merging the normal
and retry atomic responder flows.

Link: https://lore.kernel.org/r/20220606143836.3323-3-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index f4f6ee5d81fe..e38bf958ab48 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -21,6 +21,7 @@ enum resp_states {
 	RESPST_CHK_RKEY,
 	RESPST_EXECUTE,
 	RESPST_READ_REPLY,
+	RESPST_ATOMIC_REPLY,
 	RESPST_COMPLETE,
 	RESPST_ACKNOWLEDGE,
 	RESPST_CLEANUP,
@@ -55,6 +56,7 @@ static char *resp_state_name[] = {
 	[RESPST_CHK_RKEY]			= "CHK_RKEY",
 	[RESPST_EXECUTE]			= "EXECUTE",
 	[RESPST_READ_REPLY]			= "READ_REPLY",
+	[RESPST_ATOMIC_REPLY]			= "ATOMIC_REPLY",
 	[RESPST_COMPLETE]			= "COMPLETE",
 	[RESPST_ACKNOWLEDGE]			= "ACKNOWLEDGE",
 	[RESPST_CLEANUP]			= "CLEANUP",
@@ -552,8 +554,8 @@ static enum resp_states write_data_in(struct rxe_qp *qp,
 /* Guarantee atomicity of atomic operations at the machine level. */
 static DEFINE_SPINLOCK(atomic_ops_lock);
 
-static enum resp_states process_atomic(struct rxe_qp *qp,
-				       struct rxe_pkt_info *pkt)
+static enum resp_states rxe_atomic_reply(struct rxe_qp *qp,
+					 struct rxe_pkt_info *pkt)
 {
 	u64 *vaddr;
 	enum resp_states ret;
@@ -585,7 +587,16 @@ static enum resp_states process_atomic(struct rxe_qp *qp,
 
 	spin_unlock_bh(&atomic_ops_lock);
 
-	ret = RESPST_NONE;
+	qp->resp.msn++;
+
+	/* next expected psn, read handles this separately */
+	qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+	qp->resp.ack_psn = qp->resp.psn;
+
+	qp->resp.opcode = pkt->opcode;
+	qp->resp.status = IB_WC_SUCCESS;
+
+	ret = RESPST_ACKNOWLEDGE;
 out:
 	return ret;
 }
@@ -858,9 +869,7 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 		qp->resp.msn++;
 		return RESPST_READ_REPLY;
 	} else if (pkt->mask & RXE_ATOMIC_MASK) {
-		err = process_atomic(qp, pkt);
-		if (err)
-			return err;
+		return RESPST_ATOMIC_REPLY;
 	} else {
 		/* Unreachable */
 		WARN_ON_ONCE(1);
@@ -1316,6 +1325,9 @@ int rxe_responder(void *arg)
 		case RESPST_READ_REPLY:
 			state = read_reply(qp, pkt);
 			break;
+		case RESPST_ATOMIC_REPLY:
+			state = rxe_atomic_reply(qp, pkt);
+			break;
 		case RESPST_ACKNOWLEDGE:
 			state = acknowledge(qp, pkt);
 			break;
-- 
2.35.1



