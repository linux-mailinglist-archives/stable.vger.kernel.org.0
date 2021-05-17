Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651463834CA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbhEQPMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243526AbhEQPKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22BEC61209;
        Mon, 17 May 2021 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261833;
        bh=r6z/e/29C93BHxA0QOtuX1HIdRSKT16PRNmoi9HwCUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8J9WHyx8cAhEcr1o+QxoVaizPgmxijSH7pNjFuoprnBhGM/iCyNj44mAsLUEcygM
         LQnXOwGj5aeJ8kZqD/zWPjEWSeFbcmRgxEBXk6vm3NYJg8LU0xu6DyY+ZIQjrQv5Br
         DpBn2Be5w1pMvijnkZzJfpq7XOLgw7iriWhNB4VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Tom Talpey <tom@talpey.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 168/329] xprtrdma: Avoid Receive Queue wrapping
Date:   Mon, 17 May 2021 16:01:19 +0200
Message-Id: <20210517140307.817770892@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 32e6b68167f1d446111c973d57e6f52aee11897a ]

Commit e340c2d6ef2a ("xprtrdma: Reduce the doorbell rate (Receive)")
increased the number of Receive WRs that are posted by the client,
but did not increase the size of the Receive Queue allocated during
transport set-up.

This is usually not an issue because RPCRDMA_BACKWARD_WRS is defined
as (32) when SUNRPC_BACKCHANNEL is defined. In cases where it isn't,
there is a real risk of Receive Queue wrapping.

Fixes: e340c2d6ef2a ("xprtrdma: Reduce the doorbell rate (Receive)")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index baca49fe83af..e8b25f9290ab 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -257,6 +257,7 @@ int frwr_query_device(struct rpcrdma_ep *ep, const struct ib_device *device)
 	ep->re_attr.cap.max_send_wr += 1; /* for ib_drain_sq */
 	ep->re_attr.cap.max_recv_wr = ep->re_max_requests;
 	ep->re_attr.cap.max_recv_wr += RPCRDMA_BACKWARD_WRS;
+	ep->re_attr.cap.max_recv_wr += RPCRDMA_MAX_RECV_BATCH;
 	ep->re_attr.cap.max_recv_wr += 1; /* for ib_drain_rq */
 
 	ep->re_max_rdma_segs =
-- 
2.30.2



