Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE03B383417
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241178AbhEQPFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240902AbhEQPDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E2161A14;
        Mon, 17 May 2021 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261669;
        bh=RbyxU3iZx6saDnMK0TpZmbo+VXFMvfPU9ymCtkk9fe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEOoZSzaIjAiXb4fLf45If/4Gmf2u2CqDIBSR9AwkPlwgZssi9WC3v6e2vqq9ypBG
         OKFG8EEiwr5NSGpzS9mSjckmnrbBASgHRes26l4A57N11K9/8k78ZzgRejIB+GKDqN
         H3BOkXGalPLNJrpn1kdBqPk4BCgxSnpiXiG2aAdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/141] sunrpc: Fix misplaced barrier in call_decode
Date:   Mon, 17 May 2021 16:02:06 +0200
Message-Id: <20210517140245.282029095@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

[ Upstream commit f8f7e0fb22b2e75be55f2f0c13e229e75b0eac07 ]

Fix a misplaced barrier in call_decode. The struct rpc_rqst is modified
as follows by xprt_complete_rqst:

req->rq_private_buf.len = copied;
/* Ensure all writes are done before we update */
/* req->rq_reply_bytes_recvd */
smp_wmb();
req->rq_reply_bytes_recvd = copied;

And currently read as follows by call_decode:

smp_rmb(); // misplaced
if (!req->rq_reply_bytes_recvd)
   goto out;
req->rq_rcv_buf.len = req->rq_private_buf.len;

This patch places the smp_rmb after the if to ensure that
rq_reply_bytes_recvd and rq_private_buf.len are read in order.

Fixes: 9ba828861c56a ("SUNRPC: Don't try to parse incomplete RPC messages")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f1088ca39d44..b6039642df67 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2505,12 +2505,6 @@ call_decode(struct rpc_task *task)
 		task->tk_flags &= ~RPC_CALL_MAJORSEEN;
 	}
 
-	/*
-	 * Ensure that we see all writes made by xprt_complete_rqst()
-	 * before it changed req->rq_reply_bytes_recvd.
-	 */
-	smp_rmb();
-
 	/*
 	 * Did we ever call xprt_complete_rqst()? If not, we should assume
 	 * the message is incomplete.
@@ -2519,6 +2513,11 @@ call_decode(struct rpc_task *task)
 	if (!req->rq_reply_bytes_recvd)
 		goto out;
 
+	/* Ensure that we see all writes made by xprt_complete_rqst()
+	 * before it changed req->rq_reply_bytes_recvd.
+	 */
+	smp_rmb();
+
 	req->rq_rcv_buf.len = req->rq_private_buf.len;
 
 	/* Check that the softirq receive buffer is valid */
-- 
2.30.2



