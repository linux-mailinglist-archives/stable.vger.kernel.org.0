Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F49A79796
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390323AbfG2Tv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390741AbfG2Tv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E21E2184E;
        Mon, 29 Jul 2019 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429887;
        bh=7diFx/Ndu9awOFHzFQOuGvykDgKiAitf4b6izTp+8xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1zMVYr64iFYTmAkqdqMkfydCQjbjXavhJe3w65p4Fy8zyP4YuvSaLiI/WFlcclA2
         4w8mgfkEcOQPtlZDDQu1tA2aN7lSAlCurqh1EMB75skaOGwp/pEBm8T6aHMijmC3Oz
         CPLtPgCZxplk6pR625aTFTsrk1OnDLZCCkyVyMdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Taranov <konstantin.taranov@inf.ethz.ch>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 128/215] RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM
Date:   Mon, 29 Jul 2019 21:22:04 +0200
Message-Id: <20190729190801.582223676@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bdce1290493caa3f8119f24b5dacc3fb7ca27389 ]

Calculate the correct byte_len on the receiving side when a work
completion is generated with IB_WC_RECV_RDMA_WITH_IMM opcode.

According to the IBA byte_len must indicate the number of written bytes,
whereas it was always equal to zero for the IB_WC_RECV_RDMA_WITH_IMM
opcode, even though data was transferred.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Konstantin Taranov <konstantin.taranov@inf.ethz.ch>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c  | 5 ++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index aca9f60f9b21..1cbfbd98eb22 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -431,6 +431,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 			qp->resp.va = reth_va(pkt);
 			qp->resp.rkey = reth_rkey(pkt);
 			qp->resp.resid = reth_len(pkt);
+			qp->resp.length = reth_len(pkt);
 		}
 		access = (pkt->mask & RXE_READ_MASK) ? IB_ACCESS_REMOTE_READ
 						     : IB_ACCESS_REMOTE_WRITE;
@@ -856,7 +857,9 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 				pkt->mask & RXE_WRITE_MASK) ?
 					IB_WC_RECV_RDMA_WITH_IMM : IB_WC_RECV;
 		wc->vendor_err = 0;
-		wc->byte_len = wqe->dma.length - wqe->dma.resid;
+		wc->byte_len = (pkt->mask & RXE_IMMDT_MASK &&
+				pkt->mask & RXE_WRITE_MASK) ?
+					qp->resp.length : wqe->dma.length - wqe->dma.resid;
 
 		/* fields after byte_len are different between kernel and user
 		 * space
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index e8be7f44e3be..28bfb3ece104 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -213,6 +213,7 @@ struct rxe_resp_info {
 	struct rxe_mem		*mr;
 	u32			resid;
 	u32			rkey;
+	u32			length;
 	u64			atomic_orig;
 
 	/* SRQ only */
-- 
2.20.1



