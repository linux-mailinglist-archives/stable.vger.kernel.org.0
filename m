Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A95240994
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgHJP2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbgHJP2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C711D22B47;
        Mon, 10 Aug 2020 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073330;
        bh=ogNWJlwwqlJ5+G6LbfyF42NoPKiqAVWTdQKENaciGhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+Ntf1yLquAElvm9KflkddTBUcgvt09tGSr4iifT3x1aAz6qfm7zjWWnVKV1bKpu3
         iZ3Ea9GORkcHtuwM3SXudnWHeUy6IMd3TuoHQZF3g5H9Vr5EYoh6HGt2vvvmaq6hFc
         XNBqgklNu81I/aF6rNs/g+NM4pCmGi2SzqlC5cyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Timo Rothenpieler <timo@rothenpieler.org>
Subject: [PATCH 5.4 67/67] nfsd: Fix NFSv4 READ on RDMA when using readv
Date:   Mon, 10 Aug 2020 17:21:54 +0200
Message-Id: <20200810151812.803166424@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 412055398b9e67e07347a936fc4a6adddabe9cf4 upstream.

svcrdma expects that the payload falls precisely into the xdr_buf
page vector. This does not seem to be the case for
nfsd4_encode_readv().

This code is called only when fops->splice_read is missing or when
RQ_SPLICE_OK is clear, so it's not a noticeable problem in many
common cases.

Add new transport method: ->xpo_read_payload so that when a READ
payload does not fit exactly in rq_res's page vector, the XDR
encoder can inform the RPC transport exactly where that payload is,
without the payload's XDR pad.

That way, when a Write chunk is present, the transport knows what
byte range in the Reply message is supposed to be matched with the
chunk.

Note that the Linux NFS server implementation of NFS/RDMA can
currently handle only one Write chunk per RPC-over-RDMA message.
This simplifies the implementation of this fix.

Fixes: b04209806384 ("nfsd4: allow exotic read compounds")
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=198053
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c                        |   20 ++++++++-------
 include/linux/sunrpc/svc.h               |    3 ++
 include/linux/sunrpc/svc_rdma.h          |    8 +++++-
 include/linux/sunrpc/svc_xprt.h          |    2 +
 net/sunrpc/svc.c                         |   16 ++++++++++++
 net/sunrpc/svcsock.c                     |    8 ++++++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |    1 
 net/sunrpc/xprtrdma/svc_rdma_rw.c        |   30 +++++++++++++----------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   40 ++++++++++++++++++++++++++++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 
 10 files changed, 106 insertions(+), 23 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3530,17 +3530,17 @@ static __be32 nfsd4_encode_readv(struct
 	u32 zzz = 0;
 	int pad;
 
+	/*
+	 * svcrdma requires every READ payload to start somewhere
+	 * in xdr->pages.
+	 */
+	if (xdr->iov == xdr->buf->head) {
+		xdr->iov = NULL;
+		xdr->end = xdr->p;
+	}
+
 	len = maxcount;
 	v = 0;
-
-	thislen = min_t(long, len, ((void *)xdr->end - (void *)xdr->p));
-	p = xdr_reserve_space(xdr, (thislen+3)&~3);
-	WARN_ON_ONCE(!p);
-	resp->rqstp->rq_vec[v].iov_base = p;
-	resp->rqstp->rq_vec[v].iov_len = thislen;
-	v++;
-	len -= thislen;
-
 	while (len) {
 		thislen = min_t(long, len, PAGE_SIZE);
 		p = xdr_reserve_space(xdr, (thislen+3)&~3);
@@ -3559,6 +3559,8 @@ static __be32 nfsd4_encode_readv(struct
 	read->rd_length = maxcount;
 	if (nfserr)
 		return nfserr;
+	if (svc_encode_read_payload(resp->rqstp, starting_len + 8, maxcount))
+		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + 8 + ((maxcount+3)&~3));
 
 	tmp = htonl(eof);
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -517,6 +517,9 @@ void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
 char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
+int		   svc_encode_read_payload(struct svc_rqst *rqstp,
+					   unsigned int offset,
+					   unsigned int length);
 unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
 					 struct page **pages,
 					 struct kvec *first, size_t total);
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -137,6 +137,8 @@ struct svc_rdma_recv_ctxt {
 	unsigned int		rc_page_count;
 	unsigned int		rc_hdr_count;
 	u32			rc_inv_rkey;
+	unsigned int		rc_read_payload_offset;
+	unsigned int		rc_read_payload_length;
 	struct page		*rc_pages[RPCSVC_MAXPAGES];
 };
 
@@ -171,7 +173,9 @@ extern int svc_rdma_recv_read_chunk(stru
 				    struct svc_rqst *rqstp,
 				    struct svc_rdma_recv_ctxt *head, __be32 *p);
 extern int svc_rdma_send_write_chunk(struct svcxprt_rdma *rdma,
-				     __be32 *wr_ch, struct xdr_buf *xdr);
+				     __be32 *wr_ch, struct xdr_buf *xdr,
+				     unsigned int offset,
+				     unsigned long length);
 extern int svc_rdma_send_reply_chunk(struct svcxprt_rdma *rdma,
 				     __be32 *rp_ch, bool writelist,
 				     struct xdr_buf *xdr);
@@ -190,6 +194,8 @@ extern int svc_rdma_map_reply_msg(struct
 				  struct svc_rdma_send_ctxt *ctxt,
 				  struct xdr_buf *xdr, __be32 *wr_lst);
 extern int svc_rdma_sendto(struct svc_rqst *);
+extern int svc_rdma_read_payload(struct svc_rqst *rqstp, unsigned int offset,
+				 unsigned int length);
 
 /* svc_rdma_transport.c */
 extern int svc_rdma_create_listen(struct svc_serv *, int, struct sockaddr *);
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -21,6 +21,8 @@ struct svc_xprt_ops {
 	int		(*xpo_has_wspace)(struct svc_xprt *);
 	int		(*xpo_recvfrom)(struct svc_rqst *);
 	int		(*xpo_sendto)(struct svc_rqst *);
+	int		(*xpo_read_payload)(struct svc_rqst *, unsigned int,
+					    unsigned int);
 	void		(*xpo_release_rqst)(struct svc_rqst *);
 	void		(*xpo_detach)(struct svc_xprt *);
 	void		(*xpo_free)(struct svc_xprt *);
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1635,6 +1635,22 @@ u32 svc_max_payload(const struct svc_rqs
 EXPORT_SYMBOL_GPL(svc_max_payload);
 
 /**
+ * svc_encode_read_payload - mark a range of bytes as a READ payload
+ * @rqstp: svc_rqst to operate on
+ * @offset: payload's byte offset in rqstp->rq_res
+ * @length: size of payload, in bytes
+ *
+ * Returns zero on success, or a negative errno if a permanent
+ * error occurred.
+ */
+int svc_encode_read_payload(struct svc_rqst *rqstp, unsigned int offset,
+			    unsigned int length)
+{
+	return rqstp->rq_xprt->xpt_ops->xpo_read_payload(rqstp, offset, length);
+}
+EXPORT_SYMBOL_GPL(svc_encode_read_payload);
+
+/**
  * svc_fill_write_vector - Construct data argument for VFS write call
  * @rqstp: svc_rqst to operate on
  * @pages: list of pages containing data payload
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -279,6 +279,12 @@ out:
 	return len;
 }
 
+static int svc_sock_read_payload(struct svc_rqst *rqstp, unsigned int offset,
+				 unsigned int length)
+{
+	return 0;
+}
+
 /*
  * Report socket names for nfsdfs
  */
@@ -655,6 +661,7 @@ static const struct svc_xprt_ops svc_udp
 	.xpo_create = svc_udp_create,
 	.xpo_recvfrom = svc_udp_recvfrom,
 	.xpo_sendto = svc_udp_sendto,
+	.xpo_read_payload = svc_sock_read_payload,
 	.xpo_release_rqst = svc_release_udp_skb,
 	.xpo_detach = svc_sock_detach,
 	.xpo_free = svc_sock_free,
@@ -1175,6 +1182,7 @@ static const struct svc_xprt_ops svc_tcp
 	.xpo_create = svc_tcp_create,
 	.xpo_recvfrom = svc_tcp_recvfrom,
 	.xpo_sendto = svc_tcp_sendto,
+	.xpo_read_payload = svc_sock_read_payload,
 	.xpo_release_rqst = svc_release_skb,
 	.xpo_detach = svc_tcp_sock_detach,
 	.xpo_free = svc_sock_free,
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -193,6 +193,7 @@ svc_rdma_recv_ctxt_get(struct svcxprt_rd
 
 out:
 	ctxt->rc_page_count = 0;
+	ctxt->rc_read_payload_length = 0;
 	return ctxt;
 
 out_empty:
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -481,18 +481,19 @@ static int svc_rdma_send_xdr_kvec(struct
 				     vec->iov_len);
 }
 
-/* Send an xdr_buf's page list by itself. A Write chunk is
- * just the page list. a Reply chunk is the head, page list,
- * and tail. This function is shared between the two types
- * of chunk.
+/* Send an xdr_buf's page list by itself. A Write chunk is just
+ * the page list. A Reply chunk is @xdr's head, page list, and
+ * tail. This function is shared between the two types of chunk.
  */
 static int svc_rdma_send_xdr_pagelist(struct svc_rdma_write_info *info,
-				      struct xdr_buf *xdr)
+				      struct xdr_buf *xdr,
+				      unsigned int offset,
+				      unsigned long length)
 {
 	info->wi_xdr = xdr;
-	info->wi_next_off = 0;
+	info->wi_next_off = offset - xdr->head[0].iov_len;
 	return svc_rdma_build_writes(info, svc_rdma_pagelist_to_sg,
-				     xdr->page_len);
+				     length);
 }
 
 /**
@@ -500,6 +501,8 @@ static int svc_rdma_send_xdr_pagelist(st
  * @rdma: controlling RDMA transport
  * @wr_ch: Write chunk provided by client
  * @xdr: xdr_buf containing the data payload
+ * @offset: payload's byte offset in @xdr
+ * @length: size of payload, in bytes
  *
  * Returns a non-negative number of bytes the chunk consumed, or
  *	%-E2BIG if the payload was larger than the Write chunk,
@@ -509,19 +512,20 @@ static int svc_rdma_send_xdr_pagelist(st
  *	%-EIO if rdma_rw initialization failed (DMA mapping, etc).
  */
 int svc_rdma_send_write_chunk(struct svcxprt_rdma *rdma, __be32 *wr_ch,
-			      struct xdr_buf *xdr)
+			      struct xdr_buf *xdr,
+			      unsigned int offset, unsigned long length)
 {
 	struct svc_rdma_write_info *info;
 	int ret;
 
-	if (!xdr->page_len)
+	if (!length)
 		return 0;
 
 	info = svc_rdma_write_info_alloc(rdma, wr_ch);
 	if (!info)
 		return -ENOMEM;
 
-	ret = svc_rdma_send_xdr_pagelist(info, xdr);
+	ret = svc_rdma_send_xdr_pagelist(info, xdr, offset, length);
 	if (ret < 0)
 		goto out_err;
 
@@ -530,7 +534,7 @@ int svc_rdma_send_write_chunk(struct svc
 		goto out_err;
 
 	trace_svcrdma_encode_write(xdr->page_len);
-	return xdr->page_len;
+	return length;
 
 out_err:
 	svc_rdma_write_info_free(info);
@@ -570,7 +574,9 @@ int svc_rdma_send_reply_chunk(struct svc
 	 * client did not provide Write chunks.
 	 */
 	if (!writelist && xdr->page_len) {
-		ret = svc_rdma_send_xdr_pagelist(info, xdr);
+		ret = svc_rdma_send_xdr_pagelist(info, xdr,
+						 xdr->head[0].iov_len,
+						 xdr->page_len);
 		if (ret < 0)
 			goto out_err;
 		consumed += xdr->page_len;
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -856,7 +856,18 @@ int svc_rdma_sendto(struct svc_rqst *rqs
 
 	if (wr_lst) {
 		/* XXX: Presume the client sent only one Write chunk */
-		ret = svc_rdma_send_write_chunk(rdma, wr_lst, xdr);
+		unsigned long offset;
+		unsigned int length;
+
+		if (rctxt->rc_read_payload_length) {
+			offset = rctxt->rc_read_payload_offset;
+			length = rctxt->rc_read_payload_length;
+		} else {
+			offset = xdr->head[0].iov_len;
+			length = xdr->page_len;
+		}
+		ret = svc_rdma_send_write_chunk(rdma, wr_lst, xdr, offset,
+						length);
 		if (ret < 0)
 			goto err2;
 		svc_rdma_xdr_encode_write_list(rdma_resp, wr_lst, ret);
@@ -891,3 +902,30 @@ int svc_rdma_sendto(struct svc_rqst *rqs
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
 	return -ENOTCONN;
 }
+
+/**
+ * svc_rdma_read_payload - special processing for a READ payload
+ * @rqstp: svc_rqst to operate on
+ * @offset: payload's byte offset in @xdr
+ * @length: size of payload, in bytes
+ *
+ * Returns zero on success.
+ *
+ * For the moment, just record the xdr_buf location of the READ
+ * payload. svc_rdma_sendto will use that location later when
+ * we actually send the payload.
+ */
+int svc_rdma_read_payload(struct svc_rqst *rqstp, unsigned int offset,
+			  unsigned int length)
+{
+	struct svc_rdma_recv_ctxt *rctxt = rqstp->rq_xprt_ctxt;
+
+	/* XXX: Just one READ payload slot for now, since our
+	 * transport implementation currently supports only one
+	 * Write chunk.
+	 */
+	rctxt->rc_read_payload_offset = offset;
+	rctxt->rc_read_payload_length = length;
+
+	return 0;
+}
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -81,6 +81,7 @@ static const struct svc_xprt_ops svc_rdm
 	.xpo_create = svc_rdma_create,
 	.xpo_recvfrom = svc_rdma_recvfrom,
 	.xpo_sendto = svc_rdma_sendto,
+	.xpo_read_payload = svc_rdma_read_payload,
 	.xpo_release_rqst = svc_rdma_release_rqst,
 	.xpo_detach = svc_rdma_detach,
 	.xpo_free = svc_rdma_free,


