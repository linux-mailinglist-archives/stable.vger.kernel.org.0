Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69572E3F92
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503971AbgL1O1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503964AbgL1O1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A305E20715;
        Mon, 28 Dec 2020 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165653;
        bh=Se0yAx/+GCP76IQO6UyKXtyTSG3emY9mc/wr5WGYCcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziw8LSwgymtONJiKhoXLzGirWx+SCxQAXFcLZSEKkB+fjt4BG2NXaFGN9/v1WfPk4
         v87MpDB5hyfLZyY6+Cj4ZTDEAzKBXhgyyPCRuUXgIByd7K814lCI+Q4RFsXQy051Uq
         XSfS4iMehhZC4oYwCLqwRiE2tIEbop+eiE+A/QsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 606/717] xprtrdma: Fix XDRBUF_SPARSE_PAGES support
Date:   Mon, 28 Dec 2020 13:50:04 +0100
Message-Id: <20201228125049.945106897@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 15261b9126cd5bb2ad8521da49d8f5c042d904c7 upstream.

Olga K. observed that rpcrdma_marsh_req() allocates sparse pages
only when it has determined that a Reply chunk is necessary. There
are plenty of cases where no Reply chunk is needed, but the
XDRBUF_SPARSE_PAGES flag is set. The result would be a crash in
rpcrdma_inline_fixup() when it tries to copy parts of the received
Reply into a missing page.

To avoid crashing, handle sparse page allocation up front.

Until XATTR support was added, this issue did not appear often
because the only SPARSE_PAGES consumer always expected a reply large
enough to always require a Reply chunk.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/rpc_rdma.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -179,6 +179,31 @@ rpcrdma_nonpayload_inline(const struct r
 		r_xprt->rx_ep->re_max_inline_recv;
 }
 
+/* ACL likes to be lazy in allocating pages. For TCP, these
+ * pages can be allocated during receive processing. Not true
+ * for RDMA, which must always provision receive buffers
+ * up front.
+ */
+static noinline int
+rpcrdma_alloc_sparse_pages(struct xdr_buf *buf)
+{
+	struct page **ppages;
+	int len;
+
+	len = buf->page_len;
+	ppages = buf->pages + (buf->page_base >> PAGE_SHIFT);
+	while (len > 0) {
+		if (!*ppages)
+			*ppages = alloc_page(GFP_NOWAIT | __GFP_NOWARN);
+		if (!*ppages)
+			return -ENOBUFS;
+		ppages++;
+		len -= PAGE_SIZE;
+	}
+
+	return 0;
+}
+
 /* Split @vec on page boundaries into SGEs. FMR registers pages, not
  * a byte range. Other modes coalesce these SGEs into a single MR
  * when they can.
@@ -233,15 +258,6 @@ rpcrdma_convert_iovs(struct rpcrdma_xprt
 	ppages = xdrbuf->pages + (xdrbuf->page_base >> PAGE_SHIFT);
 	page_base = offset_in_page(xdrbuf->page_base);
 	while (len) {
-		/* ACL likes to be lazy in allocating pages - ACLs
-		 * are small by default but can get huge.
-		 */
-		if (unlikely(xdrbuf->flags & XDRBUF_SPARSE_PAGES)) {
-			if (!*ppages)
-				*ppages = alloc_page(GFP_NOWAIT | __GFP_NOWARN);
-			if (!*ppages)
-				return -ENOBUFS;
-		}
 		seg->mr_page = *ppages;
 		seg->mr_offset = (char *)page_base;
 		seg->mr_len = min_t(u32, PAGE_SIZE - page_base, len);
@@ -867,6 +883,12 @@ rpcrdma_marshal_req(struct rpcrdma_xprt
 	__be32 *p;
 	int ret;
 
+	if (unlikely(rqst->rq_rcv_buf.flags & XDRBUF_SPARSE_PAGES)) {
+		ret = rpcrdma_alloc_sparse_pages(&rqst->rq_rcv_buf);
+		if (ret)
+			return ret;
+	}
+
 	rpcrdma_set_xdrlen(&req->rl_hdrbuf, 0);
 	xdr_init_encode(xdr, &req->rl_hdrbuf, rdmab_data(req->rl_rdmabuf),
 			rqst);


