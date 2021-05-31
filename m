Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1153962C0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhEaPAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234463AbhEaO7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29F561946;
        Mon, 31 May 2021 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469704;
        bh=D63P77HwMmhGS9UdU6aGgjUqACebIidGZofYsJ/azHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZyz0uR7ARUBqY4m/r5jG0oVkw93wL3UvOfJKX9FmYTC/hiZ+yqpPospu4dfGq6Kw
         apnkz0bU5VFroGKFgnfUUJcv432C+EQ068FWgx1FT0iEGOP2AvnHNu3gsStzAnfegG
         U4QepfTetqKY0dApMJQw+cieHc8o91VnMMH14zjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 288/296] xprtrdma: Revert 586a0787ce35
Date:   Mon, 31 May 2021 15:15:43 +0200
Message-Id: <20210531130713.396050902@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ae605ee9830840f14566a3b1cde27fa8096dbdd4 ]

Commit 9ed5af268e88 ("SUNRPC: Clean up the handling of page padding
in rpc_prepare_reply_pages()") [Dec 2020] affects RPC Replies that
have a data payload (i.e., Write chunks).

rpcrdma_prepare_readch(), as its name suggests, sets up Read chunks
which are data payloads within RPC Calls. Those payloads are
constructed by xdr_write_pages(), which continues to stuff the call
buffer's tail kvec with the payload's XDR roundup. Thus removing
the tail buffer logic in rpcrdma_prepare_readch() was the wrong
thing to do.

Fixes: 586a0787ce35 ("xprtrdma: Clean up rpcrdma_prepare_readch()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 21ddd78a8c35..15e0c4e7b24a 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -628,8 +628,9 @@ out_mapping_err:
 	return false;
 }
 
-/* The tail iovec might not reside in the same page as the
- * head iovec.
+/* The tail iovec may include an XDR pad for the page list,
+ * as well as additional content, and may not reside in the
+ * same page as the head iovec.
  */
 static bool rpcrdma_prepare_tail_iov(struct rpcrdma_req *req,
 				     struct xdr_buf *xdr,
@@ -747,19 +748,27 @@ static bool rpcrdma_prepare_readch(struct rpcrdma_xprt *r_xprt,
 				   struct rpcrdma_req *req,
 				   struct xdr_buf *xdr)
 {
-	struct kvec *tail = &xdr->tail[0];
-
 	if (!rpcrdma_prepare_head_iov(r_xprt, req, xdr->head[0].iov_len))
 		return false;
 
-	/* If there is a Read chunk, the page list is handled
+	/* If there is a Read chunk, the page list is being handled
 	 * via explicit RDMA, and thus is skipped here.
 	 */
 
-	if (tail->iov_len) {
-		if (!rpcrdma_prepare_tail_iov(req, xdr,
-					      offset_in_page(tail->iov_base),
-					      tail->iov_len))
+	/* Do not include the tail if it is only an XDR pad */
+	if (xdr->tail[0].iov_len > 3) {
+		unsigned int page_base, len;
+
+		/* If the content in the page list is an odd length,
+		 * xdr_write_pages() adds a pad at the beginning of
+		 * the tail iovec. Force the tail's non-pad content to
+		 * land at the next XDR position in the Send message.
+		 */
+		page_base = offset_in_page(xdr->tail[0].iov_base);
+		len = xdr->tail[0].iov_len;
+		page_base += len & 3;
+		len -= len & 3;
+		if (!rpcrdma_prepare_tail_iov(req, xdr, page_base, len))
 			return false;
 		kref_get(&req->rl_kref);
 	}
-- 
2.30.2



