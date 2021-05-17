Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C0A383531
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbhEQPQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240706AbhEQPN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1380061C4E;
        Mon, 17 May 2021 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261914;
        bh=InIh6HKvECFj20U6L9vgh3JjpNCfwKZj7DEXA3TKNOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfOtOXI6dBeKDM++lJMeNkO95zj3Or2UVwYT1X3g176NWxTVIZpyQ2Or+kglaDC0t
         zkTCVXdzKU4A0NyhaWNZC1ICxrx0K+qU5bYvJ7is+l6SXeYKCT9T4RMx8hL/aWZeoc
         YHG2xTYcbS7py2xPbV27VQOZXOAtgUhgIFzTH88k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 186/329] sunrpc: Fix misplaced barrier in call_decode
Date:   Mon, 17 May 2021 16:01:37 +0200
Message-Id: <20210517140308.419829091@linuxfoundation.org>
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
index c2a01125be1a..f555d335e910 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2456,12 +2456,6 @@ call_decode(struct rpc_task *task)
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
@@ -2470,6 +2464,11 @@ call_decode(struct rpc_task *task)
 	if (!req->rq_reply_bytes_recvd)
 		goto out;
 
+	/* Ensure that we see all writes made by xprt_complete_rqst()
+	 * before it changed req->rq_reply_bytes_recvd.
+	 */
+	smp_rmb();
+
 	req->rq_rcv_buf.len = req->rq_private_buf.len;
 	trace_rpc_xdr_recvfrom(task, &req->rq_rcv_buf);
 
-- 
2.30.2



