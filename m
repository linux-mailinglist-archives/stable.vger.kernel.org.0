Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7B66C77D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjAPQbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjAPQaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8E3274BA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A75FAB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104B9C433EF;
        Mon, 16 Jan 2023 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885953;
        bh=EJC5HNZNHnFh0V6nQIv3a8AaOQNYju+rMX01tYc+DuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJ1JGZrrnIGJSkuSBWdhXgD/qsIaKtwljWU00qBsWRLsRFU5kjRjYMvO8o0ypMFRB
         b+mV+RRQDpB3MXu3Lzo4mVbakF/6NPN5Q26BDJodmzKksCZTBUkVAvXXcI64eSS3uT
         yCRJiRexnuHJUC9a7e94nGiM/4/2p4TCKX6EXuqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Olga Kornievskaia <kolga@netapp.com>,
        Tom Talpey <tom@talpey.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/658] RDMA/siw: Fix immediate work request flush to completion queue
Date:   Mon, 16 Jan 2023 16:45:34 +0100
Message-Id: <20230116154920.815645834@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit bdf1da5df9da680589a7f74448dd0a94dd3e1446 ]

Correctly set send queue element opcode during immediate work request
flushing in post sendqueue operation, if the QP is in ERROR state.
An undefined ocode value results in out-of-bounds access to an array
for mapping the opcode between siw internal and RDMA core representation
in work completion generation. It resulted in a KASAN BUG report
of type 'global-out-of-bounds' during NFSoRDMA testing.

This patch further fixes a potential case of a malicious user which may
write undefined values for completion queue elements status or opcode,
if the CQ is memory mapped to user land. It avoids the same out-of-bounds
access to arrays for status and opcode mapping as described above.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Fixes: b0fff7317bb4 ("rdma/siw: completion queue methods")
Reported-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Link: https://lore.kernel.org/r/20221107145057.895747-1-bmt@zurich.ibm.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cq.c    | 24 ++++++++++++++--
 drivers/infiniband/sw/siw/siw_verbs.c | 40 ++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cq.c b/drivers/infiniband/sw/siw/siw_cq.c
index d8db3bee9da7..26d4eb44a9d0 100644
--- a/drivers/infiniband/sw/siw/siw_cq.c
+++ b/drivers/infiniband/sw/siw/siw_cq.c
@@ -56,8 +56,6 @@ int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *wc)
 	if (READ_ONCE(cqe->flags) & SIW_WQE_VALID) {
 		memset(wc, 0, sizeof(*wc));
 		wc->wr_id = cqe->id;
-		wc->status = map_cqe_status[cqe->status].ib;
-		wc->opcode = map_wc_opcode[cqe->opcode];
 		wc->byte_len = cqe->bytes;
 
 		/*
@@ -71,10 +69,32 @@ int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *wc)
 				wc->wc_flags = IB_WC_WITH_INVALIDATE;
 			}
 			wc->qp = cqe->base_qp;
+			wc->opcode = map_wc_opcode[cqe->opcode];
+			wc->status = map_cqe_status[cqe->status].ib;
 			siw_dbg_cq(cq,
 				   "idx %u, type %d, flags %2x, id 0x%pK\n",
 				   cq->cq_get % cq->num_cqe, cqe->opcode,
 				   cqe->flags, (void *)(uintptr_t)cqe->id);
+		} else {
+			/*
+			 * A malicious user may set invalid opcode or
+			 * status in the user mmapped CQE array.
+			 * Sanity check and correct values in that case
+			 * to avoid out-of-bounds access to global arrays
+			 * for opcode and status mapping.
+			 */
+			u8 opcode = cqe->opcode;
+			u16 status = cqe->status;
+
+			if (opcode >= SIW_NUM_OPCODES) {
+				opcode = 0;
+				status = IB_WC_GENERAL_ERR;
+			} else if (status >= SIW_NUM_WC_STATUS) {
+				status = IB_WC_GENERAL_ERR;
+			}
+			wc->opcode = map_wc_opcode[opcode];
+			wc->status = map_cqe_status[status].ib;
+
 		}
 		WRITE_ONCE(cqe->flags, 0);
 		cq->cq_get++;
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index b9ca54e372b4..c8c2014b79d2 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -694,13 +694,45 @@ static int siw_copy_inline_sgl(const struct ib_send_wr *core_wr,
 static int siw_sq_flush_wr(struct siw_qp *qp, const struct ib_send_wr *wr,
 			   const struct ib_send_wr **bad_wr)
 {
-	struct siw_sqe sqe = {};
 	int rv = 0;
 
 	while (wr) {
-		sqe.id = wr->wr_id;
-		sqe.opcode = wr->opcode;
-		rv = siw_sqe_complete(qp, &sqe, 0, SIW_WC_WR_FLUSH_ERR);
+		struct siw_sqe sqe = {};
+
+		switch (wr->opcode) {
+		case IB_WR_RDMA_WRITE:
+			sqe.opcode = SIW_OP_WRITE;
+			break;
+		case IB_WR_RDMA_READ:
+			sqe.opcode = SIW_OP_READ;
+			break;
+		case IB_WR_RDMA_READ_WITH_INV:
+			sqe.opcode = SIW_OP_READ_LOCAL_INV;
+			break;
+		case IB_WR_SEND:
+			sqe.opcode = SIW_OP_SEND;
+			break;
+		case IB_WR_SEND_WITH_IMM:
+			sqe.opcode = SIW_OP_SEND_WITH_IMM;
+			break;
+		case IB_WR_SEND_WITH_INV:
+			sqe.opcode = SIW_OP_SEND_REMOTE_INV;
+			break;
+		case IB_WR_LOCAL_INV:
+			sqe.opcode = SIW_OP_INVAL_STAG;
+			break;
+		case IB_WR_REG_MR:
+			sqe.opcode = SIW_OP_REG_MR;
+			break;
+		default:
+			rv = -EINVAL;
+			break;
+		}
+		if (!rv) {
+			sqe.id = wr->wr_id;
+			rv = siw_sqe_complete(qp, &sqe, 0,
+					      SIW_WC_WR_FLUSH_ERR);
+		}
 		if (rv) {
 			if (bad_wr)
 				*bad_wr = wr;
-- 
2.35.1



