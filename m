Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BBF32E8CE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhCEM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhCEM2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3003965064;
        Fri,  5 Mar 2021 12:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947311;
        bh=iaeSJnz/9PIlC3b50L0SHM98iQqBqXVPHBe3b5peswE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxK4AfkatYAx5OdaQMlSyfHlOVCcLmP0WEehNJR7wiS4HEZqZbyNH4t0Vw+fdw5ws
         d1I05KkAdEr0o8YeJjQoGaTaZhY+80PO4Op3NU/5Job545Swt3tjzrFkhFbgwcnDjH
         UeTdhb/xwwz+QRFU0XOjEejm1MUDYjVHW8eRPwgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 021/102] RDMA/rtrs-clt: Use bitmask to check sess->flags
Date:   Fri,  5 Mar 2021 13:20:40 +0100
Message-Id: <20210305120904.323329933@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

commit aaed465f761700dace9ab39521013cddaae4f5a3 upstream.

We may want to add new flags, so it's better to use bitmask to check flags.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-17-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -502,7 +502,7 @@ static void rtrs_clt_recv_done(struct rt
 	int err;
 	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
 
-	WARN_ON(sess->flags != RTRS_MSG_NEW_RKEY_F);
+	WARN_ON((sess->flags & RTRS_MSG_NEW_RKEY_F) == 0);
 	iu = container_of(wc->wr_cqe, struct rtrs_iu,
 			  cqe);
 	err = rtrs_iu_post_recv(&con->c, iu);
@@ -522,7 +522,7 @@ static void rtrs_clt_rkey_rsp_done(struc
 	u32 buf_id;
 	int err;
 
-	WARN_ON(sess->flags != RTRS_MSG_NEW_RKEY_F);
+	WARN_ON((sess->flags & RTRS_MSG_NEW_RKEY_F) == 0);
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
 
@@ -629,12 +629,12 @@ static void rtrs_clt_rdma_done(struct ib
 		} else if (imm_type == RTRS_HB_MSG_IMM) {
 			WARN_ON(con->c.cid);
 			rtrs_send_hb_ack(&sess->s);
-			if (sess->flags == RTRS_MSG_NEW_RKEY_F)
+			if (sess->flags & RTRS_MSG_NEW_RKEY_F)
 				return  rtrs_clt_recv_done(con, wc);
 		} else if (imm_type == RTRS_HB_ACK_IMM) {
 			WARN_ON(con->c.cid);
 			sess->s.hb_missed_cnt = 0;
-			if (sess->flags == RTRS_MSG_NEW_RKEY_F)
+			if (sess->flags & RTRS_MSG_NEW_RKEY_F)
 				return  rtrs_clt_recv_done(con, wc);
 		} else {
 			rtrs_wrn(con->c.sess, "Unknown IMM type %u\n",
@@ -662,7 +662,7 @@ static void rtrs_clt_rdma_done(struct ib
 		WARN_ON(!(wc->wc_flags & IB_WC_WITH_INVALIDATE ||
 			  wc->wc_flags & IB_WC_WITH_IMM));
 		WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done);
-		if (sess->flags == RTRS_MSG_NEW_RKEY_F) {
+		if (sess->flags & RTRS_MSG_NEW_RKEY_F) {
 			if (wc->wc_flags & IB_WC_WITH_INVALIDATE)
 				return  rtrs_clt_recv_done(con, wc);
 
@@ -687,7 +687,7 @@ static int post_recv_io(struct rtrs_clt_
 	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
 
 	for (i = 0; i < q_size; i++) {
-		if (sess->flags == RTRS_MSG_NEW_RKEY_F) {
+		if (sess->flags & RTRS_MSG_NEW_RKEY_F) {
 			struct rtrs_iu *iu = &con->rsp_ius[i];
 
 			err = rtrs_iu_post_recv(&con->c, iu);
@@ -1579,7 +1579,7 @@ static int create_con_cq_qp(struct rtrs_
 			      sess->queue_depth * 3 + 1);
 	}
 	/* alloc iu to recv new rkey reply when server reports flags set */
-	if (sess->flags == RTRS_MSG_NEW_RKEY_F || con->c.cid == 0) {
+	if (sess->flags & RTRS_MSG_NEW_RKEY_F || con->c.cid == 0) {
 		con->rsp_ius = rtrs_iu_alloc(max_recv_wr, sizeof(*rsp),
 					      GFP_KERNEL, sess->s.dev->ib_dev,
 					      DMA_FROM_DEVICE,


