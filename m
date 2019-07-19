Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F136DCA8
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbfGSEOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389563AbfGSEOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:14:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F151E2082F;
        Fri, 19 Jul 2019 04:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509647;
        bh=dIfooxZ+1jn6T9nEAerMYrcXZ0SVNMsyC8zRTx2EH10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txoar/3K1R3o0lZCEsX0niSmb9BU2b3i3MwkEXIQCo1T22WsV06HaRR86VLWFmtMk
         x96F1pUmtwJkM5P8UgU7Q3LqN2RyJ3hAuXuL3SA/WiXW+menx0/qlFaFxEu0wN84nR
         FPLd7fE7bAnXBgIpEu3YGaHQUxuPOLdvHjWl73dg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Taranov <konstantin.taranov@inf.ethz.ch>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 36/45] RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM
Date:   Fri, 19 Jul 2019 00:12:55 -0400
Message-Id: <20190719041304.18849-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Taranov <konstantin.taranov@inf.ethz.ch>

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
index 297653ab4004..5bfea23f3b60 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -432,6 +432,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 			qp->resp.va = reth_va(pkt);
 			qp->resp.rkey = reth_rkey(pkt);
 			qp->resp.resid = reth_len(pkt);
+			qp->resp.length = reth_len(pkt);
 		}
 		access = (pkt->mask & RXE_READ_MASK) ? IB_ACCESS_REMOTE_READ
 						     : IB_ACCESS_REMOTE_WRITE;
@@ -841,7 +842,9 @@ static enum resp_states do_complete(struct rxe_qp *qp,
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
index cac1d52a08f0..47003d2a4a46 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -209,6 +209,7 @@ struct rxe_resp_info {
 	struct rxe_mem		*mr;
 	u32			resid;
 	u32			rkey;
+	u32			length;
 	u64			atomic_orig;
 
 	/* SRQ only */
-- 
2.20.1

