Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA338303B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhEQOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239295AbhEQOWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6690B61462;
        Mon, 17 May 2021 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260734;
        bh=b83efOLHTmSSGmFU5D4z0nVxQnv622V+MVAwLRfQLy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTSNRPpzVxUXBhwGrBYCsMfDsDTjJFoap/S2yOK36kL29Z1Pg4SgbgLMqrukbR+yz
         KpgWKDSsTG4bExxIASuA87P1WMB6O6mAzTPBSPO4k34pCYuwvNLsLwYN+g+LxEbDMk
         LSDTyVr97Z/92MjswdUZTQr7T5SFgCIEvboSmxsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Tom Talpey <tom@talpey.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 181/363] xprtrdma: Avoid Receive Queue wrapping
Date:   Mon, 17 May 2021 16:00:47 +0200
Message-Id: <20210517140308.712181135@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 766a1048a48a..132df9b59ab4 100644
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



