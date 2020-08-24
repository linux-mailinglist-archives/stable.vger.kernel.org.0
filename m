Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48DF24F429
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHXIdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgHXIdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E87206F0;
        Mon, 24 Aug 2020 08:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258004;
        bh=BUqh9hxrrhfBSUuYGJs7qbkTVzJ4kaDSPrSOfKiy10g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS/6haiS2H/L3k9Y/KakDt+UJ8fTI/qdHJ592r8Q3sM48GSUcVK4jYRAzkTuvYIuo
         EtLaD4OyXm4OPHgk2nMs8QopWVEGsnTMb0vHkUyJCh/aEWrrSp4uDy5oPgiXE0ExlJ
         /wulgpafAMjwqpSlev98xNdI+vHzxylHQNMxGrC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.8 021/148] RDMA/hfi1: Correct an interlock issue for TID RDMA WRITE request
Date:   Mon, 24 Aug 2020 10:28:39 +0200
Message-Id: <20200824082414.985790869@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit b25e8e85e75a61af1ddc88c4798387dd3132dd43 upstream.

The following message occurs when running an AI application with TID RDMA
enabled:

hfi1 0000:7f:00.0: hfi1_0: [QP74] hfi1_tid_timeout 4084
hfi1 0000:7f:00.0: hfi1_0: [QP70] hfi1_tid_timeout 4084

The issue happens when TID RDMA WRITE request is followed by an
IB_WR_RDMA_WRITE_WITH_IMM request, the latter could be completed first on
the responder side. As a result, no ACK packet for the latter could be
sent because the TID RDMA WRITE request is still being processed on the
responder side.

When the TID RDMA WRITE request is eventually completed, the requester
will wait for the IB_WR_RDMA_WRITE_WITH_IMM request to be acknowledged.

If the next request is another TID RDMA WRITE request, no TID RDMA WRITE
DATA packet could be sent because the preceding IB_WR_RDMA_WRITE_WITH_IMM
request is not completed yet.

Consequently the IB_WR_RDMA_WRITE_WITH_IMM will be retried but it will be
ignored on the responder side because the responder thinks it has already
been completed. Eventually the retry will be exhausted and the qp will be
put into error state on the requester side. On the responder side, the TID
resource timer will eventually expire because no TID RDMA WRITE DATA
packets will be received for the second TID RDMA WRITE request.  There is
also risk of a write-after-write memory corruption due to the issue.

Fix by adding a requester side interlock to prevent any potential data
corruption and TID RDMA protocol error.

Fixes: a0b34f75ec20 ("IB/hfi1: Add interlock between a TID RDMA request and other requests")
Link: https://lore.kernel.org/r/20200811174931.191210.84093.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org> # 5.4.x+
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -3215,6 +3215,7 @@ bool hfi1_tid_rdma_wqe_interlock(struct
 	case IB_WR_ATOMIC_CMP_AND_SWP:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 	case IB_WR_RDMA_WRITE:
+	case IB_WR_RDMA_WRITE_WITH_IMM:
 		switch (prev->wr.opcode) {
 		case IB_WR_TID_RDMA_WRITE:
 			req = wqe_to_tid_req(prev);


