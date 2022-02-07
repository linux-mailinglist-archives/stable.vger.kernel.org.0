Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7644ABC60
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377095AbiBGLfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238765AbiBGL2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA4C0364B6;
        Mon,  7 Feb 2022 03:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79E76091A;
        Mon,  7 Feb 2022 11:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87002C004E1;
        Mon,  7 Feb 2022 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233184;
        bh=lV1mkuh7zyPWVcvLXzJOB2GkO6mowb3cwC8cFqZQMqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qphQZw38ZA6I73laFsNqdqEqAWo6HKF9w3UZeG7BifWgOS1HVwUnOLi65NukDxQei
         ph9nTa+xpfu7j0ErtyEPhaSJSqr+5OORAQZZKkEvo07Ex6StR7bjOHRUApfeFntXDc
         SSbdEBpRDBOw0kOT9yBntM6sNLj/GPCrB7eErapc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jared Holzman <jared.holzman@excelero.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 043/110] RDMA/siw: Fix broken RDMA Read Fence/Resume logic.
Date:   Mon,  7 Feb 2022 12:06:16 +0100
Message-Id: <20220207103803.734262243@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Bernard Metzler <bmt@zurich.ibm.com>

commit b43a76f423aa304037603fd6165c4a534d2c09a7 upstream.

Code unconditionally resumed fenced SQ processing after next RDMA Read
completion, even if other RDMA Read responses are still outstanding, or
ORQ is full. Also adds comments for better readability of fence
processing, and removes orq_get_tail() helper, which is not needed
anymore.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Fixes: a531975279f3 ("rdma/siw: main include file")
Link: https://lore.kernel.org/r/20220130170815.1940-1-bmt@zurich.ibm.com
Reported-by: Jared Holzman <jared.holzman@excelero.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw.h       |    7 +------
 drivers/infiniband/sw/siw/siw_qp_rx.c |   20 +++++++++++---------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -644,14 +644,9 @@ static inline struct siw_sqe *orq_get_cu
 	return &qp->orq[qp->orq_get % qp->attrs.orq_size];
 }
 
-static inline struct siw_sqe *orq_get_tail(struct siw_qp *qp)
-{
-	return &qp->orq[qp->orq_put % qp->attrs.orq_size];
-}
-
 static inline struct siw_sqe *orq_get_free(struct siw_qp *qp)
 {
-	struct siw_sqe *orq_e = orq_get_tail(qp);
+	struct siw_sqe *orq_e = &qp->orq[qp->orq_put % qp->attrs.orq_size];
 
 	if (READ_ONCE(orq_e->flags) == 0)
 		return orq_e;
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1153,11 +1153,12 @@ static int siw_check_tx_fence(struct siw
 
 	spin_lock_irqsave(&qp->orq_lock, flags);
 
-	rreq = orq_get_current(qp);
-
 	/* free current orq entry */
+	rreq = orq_get_current(qp);
 	WRITE_ONCE(rreq->flags, 0);
 
+	qp->orq_get++;
+
 	if (qp->tx_ctx.orq_fence) {
 		if (unlikely(tx_waiting->wr_status != SIW_WR_QUEUED)) {
 			pr_warn("siw: [QP %u]: fence resume: bad status %d\n",
@@ -1165,10 +1166,12 @@ static int siw_check_tx_fence(struct siw
 			rv = -EPROTO;
 			goto out;
 		}
-		/* resume SQ processing */
+		/* resume SQ processing, if possible */
 		if (tx_waiting->sqe.opcode == SIW_OP_READ ||
 		    tx_waiting->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
-			rreq = orq_get_tail(qp);
+
+			/* SQ processing was stopped because of a full ORQ */
+			rreq = orq_get_free(qp);
 			if (unlikely(!rreq)) {
 				pr_warn("siw: [QP %u]: no ORQE\n", qp_id(qp));
 				rv = -EPROTO;
@@ -1181,15 +1184,14 @@ static int siw_check_tx_fence(struct siw
 			resume_tx = 1;
 
 		} else if (siw_orq_empty(qp)) {
+			/*
+			 * SQ processing was stopped by fenced work request.
+			 * Resume since all previous Read's are now completed.
+			 */
 			qp->tx_ctx.orq_fence = 0;
 			resume_tx = 1;
-		} else {
-			pr_warn("siw: [QP %u]: fence resume: orq idx: %d:%d\n",
-				qp_id(qp), qp->orq_get, qp->orq_put);
-			rv = -EPROTO;
 		}
 	}
-	qp->orq_get++;
 out:
 	spin_unlock_irqrestore(&qp->orq_lock, flags);
 


