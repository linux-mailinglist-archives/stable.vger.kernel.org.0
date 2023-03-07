Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1784B6AEB0F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjCGRjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjCGRjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:39:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3824A2243
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 713EDB8184C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC65AC433EF;
        Tue,  7 Mar 2023 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210535;
        bh=b2TGn6jR2ladCcBMd990rHHR8mXVLlsvpWje+oXLpA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WStvYaTs9lvqLJPBHiDd+dpI1NiAQIeYFMjRv5UbfbrElQ0IOyFvK7Wq/lrPev8xM
         CgSZLwMoLSNgXl6RjdzLHnnNGpR6rk7QQFc8rkn/CfM1lU+K+k4QbzQRoAoGVHy0Fv
         HqXy1OyNubLfzD001aPO349dGWIywbPhq1Qfs2OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0573/1001] RDMA-rxe: Isolate mr code from atomic_write_reply()
Date:   Tue,  7 Mar 2023 17:55:45 +0100
Message-Id: <20230307170046.340304540@linuxfoundation.org>
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

[ Upstream commit d8bdb0ebca086b5845d782e800ad2bf2a7eb4877 ]

Isolate mr specific code from atomic_write_reply() in rxe_resp.c into
a subroutine rxe_mr_do_atomic_write() in rxe_mr.c.
Check length for atomic write operation.
Make iova_to_vaddr() static.

Link: https://lore.kernel.org/r/20230119235936.19728-5-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 5ff31dfcd6d2 ("Subject: RDMA/rxe: Handle zero length rdma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c   | 38 ++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_resp.c | 61 ++++++++++------------------
 3 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index bcb1bbcf50dff..ad8bd6bd728a4 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -71,9 +71,9 @@ int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
 	      void *addr, int length, enum rxe_mr_copy_dir dir);
 int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
-void *iova_to_vaddr(struct rxe_mr *mr, u64 iova, int length);
 int rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
 			u64 compare, u64 swap_add, u64 *orig_val);
+int rxe_mr_do_atomic_write(struct rxe_mr *mr, u64 iova, u64 value);
 struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 			 enum rxe_mr_lookup_type type);
 int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index df9741474f1f0..5c4ce43914fa2 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -297,7 +297,7 @@ static void lookup_iova(struct rxe_mr *mr, u64 iova, int *m_out, int *n_out,
 	}
 }
 
-void *iova_to_vaddr(struct rxe_mr *mr, u64 iova, int length)
+static void *iova_to_vaddr(struct rxe_mr *mr, u64 iova, int length)
 {
 	size_t offset;
 	int m, n;
@@ -565,6 +565,42 @@ int rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
 	return 0;
 }
 
+/* only implemented for 64 bit architectures */
+#if defined CONFIG_64BIT
+int rxe_mr_do_atomic_write(struct rxe_mr *mr, u64 iova, u64 value)
+{
+	u64 *va;
+
+	/* See IBA oA19-28 */
+	if (unlikely(mr->state != RXE_MR_STATE_VALID)) {
+		rxe_dbg_mr(mr, "mr not in valid state");
+		return RESPST_ERR_RKEY_VIOLATION;
+	}
+
+	va = iova_to_vaddr(mr, iova, sizeof(value));
+	if (unlikely(!va)) {
+		rxe_dbg_mr(mr, "iova out of range");
+		return RESPST_ERR_RKEY_VIOLATION;
+	}
+
+	/* See IBA A19.4.2 */
+	if (unlikely((uintptr_t)va & 0x7 || iova & 0x7)) {
+		rxe_dbg_mr(mr, "misaligned address");
+		return RESPST_ERR_MISALIGNED_ATOMIC;
+	}
+
+	/* Do atomic write after all prior operations have completed */
+	smp_store_release(va, value);
+
+	return 0;
+}
+#else
+int rxe_mr_do_atomic_write(struct rxe_mr *mr, u64 iova, u64 value)
+{
+	return RESPST_ERR_UNSUPPORTED_OPCODE;
+}
+#endif
+
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length)
 {
 	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 9d4b4e9b42fc9..cd2d88de287ca 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -723,30 +723,32 @@ static enum resp_states atomic_reply(struct rxe_qp *qp,
 	return RESPST_ACKNOWLEDGE;
 }
 
-#ifdef CONFIG_64BIT
-static enum resp_states do_atomic_write(struct rxe_qp *qp,
-					struct rxe_pkt_info *pkt)
+static enum resp_states atomic_write_reply(struct rxe_qp *qp,
+					   struct rxe_pkt_info *pkt)
 {
-	struct rxe_mr *mr = qp->resp.mr;
-	int payload = payload_size(pkt);
-	u64 src, *dst;
-
-	if (mr->state != RXE_MR_STATE_VALID)
-		return RESPST_ERR_RKEY_VIOLATION;
+	struct resp_res *res = qp->resp.res;
+	struct rxe_mr *mr;
+	u64 value;
+	u64 iova;
+	int err;
 
-	memcpy(&src, payload_addr(pkt), payload);
+	if (!res) {
+		res = rxe_prepare_res(qp, pkt, RXE_ATOMIC_WRITE_MASK);
+		qp->resp.res = res;
+	}
 
-	dst = iova_to_vaddr(mr, qp->resp.va + qp->resp.offset, payload);
-	/* check vaddr is 8 bytes aligned. */
-	if (!dst || (uintptr_t)dst & 7)
-		return RESPST_ERR_MISALIGNED_ATOMIC;
+	if (res->replay)
+		return RESPST_ACKNOWLEDGE;
 
-	/* Do atomic write after all prior operations have completed */
-	smp_store_release(dst, src);
+	mr = qp->resp.mr;
+	value = *(u64 *)payload_addr(pkt);
+	iova = qp->resp.va + qp->resp.offset;
 
-	/* decrease resp.resid to zero */
-	qp->resp.resid -= sizeof(payload);
+	err = rxe_mr_do_atomic_write(mr, iova, value);
+	if (err)
+		return err;
 
+	qp->resp.resid = 0;
 	qp->resp.msn++;
 
 	/* next expected psn, read handles this separately */
@@ -755,29 +757,8 @@ static enum resp_states do_atomic_write(struct rxe_qp *qp,
 
 	qp->resp.opcode = pkt->opcode;
 	qp->resp.status = IB_WC_SUCCESS;
-	return RESPST_ACKNOWLEDGE;
-}
-#else
-static enum resp_states do_atomic_write(struct rxe_qp *qp,
-					struct rxe_pkt_info *pkt)
-{
-	return RESPST_ERR_UNSUPPORTED_OPCODE;
-}
-#endif /* CONFIG_64BIT */
-
-static enum resp_states atomic_write_reply(struct rxe_qp *qp,
-					   struct rxe_pkt_info *pkt)
-{
-	struct resp_res *res = qp->resp.res;
 
-	if (!res) {
-		res = rxe_prepare_res(qp, pkt, RXE_ATOMIC_WRITE_MASK);
-		qp->resp.res = res;
-	}
-
-	if (res->replay)
-		return RESPST_ACKNOWLEDGE;
-	return do_atomic_write(qp, pkt);
+	return RESPST_ACKNOWLEDGE;
 }
 
 static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
-- 
2.39.2



