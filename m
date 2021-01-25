Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B745D302AB1
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbhAYSuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbhAYSs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1732120679;
        Mon, 25 Jan 2021 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600492;
        bh=vFv/hyweCXYqQvMewzG0EA++KV4ngQIZ/kR+fMJVE9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSGpR6Tpm1nHocj2ABcLButv/WIM8gzW6tVTJ9ZQJS8UW6LoMvj0ry0milF6AWnbX
         1cHArn8vXbqCev1e271eOEMZllybxX10xxEE0VHP30/Ah/ooOcjDaK1UsjbosiFBbO
         w8aHaLQ7Rzlk2rSiCur78vD5u3rZhelyY7A87KnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daire Byrne <daire@dneg.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/199] SUNRPC: Handle TCP socket sends with kernel_sendpage() again
Date:   Mon, 25 Jan 2021 19:37:38 +0100
Message-Id: <20210125183217.768867744@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4a85a6a3320b4a622315d2e0ea91a1d2b013bce4 ]

Daire Byrne reports a ~50% aggregrate throughput regression on his
Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach server to
use xprt_sock_sendmsg for socket sends"), which replaced
kernel_send_page() calls in NFSD's socket send path with calls to
sock_sendmsg() using iov_iter.

Investigation showed that tcp_sendmsg() was not using zero-copy to
send the xdr_buf's bvec pages, but instead was relying on memcpy.
This means copying every byte of a large NFS READ payload.

It looks like TLS sockets do indeed support a ->sendpage method,
so it's really not necessary to use xprt_sock_sendmsg() to support
TLS fully on the server. A mechanical reversion of da1661b93bf4 is
not possible at this point, but we can re-implement the server's
TCP socket sendmsg path using kernel_sendpage().

Reported-by: Daire Byrne <daire@dneg.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209439
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 86 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index c2752e2b9ce34..4404c491eb388 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1062,6 +1062,90 @@ err_noclose:
 	return 0;	/* record not complete */
 }
 
+static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
+			      int flags)
+{
+	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
+			       offset_in_page(vec->iov_base),
+			       vec->iov_len, flags);
+}
+
+/*
+ * kernel_sendpage() is used exclusively to reduce the number of
+ * copy operations in this path. Therefore the caller must ensure
+ * that the pages backing @xdr are unchanging.
+ *
+ * In addition, the logic assumes that * .bv_len is never larger
+ * than PAGE_SIZE.
+ */
+static int svc_tcp_sendmsg(struct socket *sock, struct msghdr *msg,
+			   struct xdr_buf *xdr, rpc_fraghdr marker,
+			   unsigned int *sentp)
+{
+	const struct kvec *head = xdr->head;
+	const struct kvec *tail = xdr->tail;
+	struct kvec rm = {
+		.iov_base	= &marker,
+		.iov_len	= sizeof(marker),
+	};
+	int flags, ret;
+
+	*sentp = 0;
+	xdr_alloc_bvec(xdr, GFP_KERNEL);
+
+	msg->msg_flags = MSG_MORE;
+	ret = kernel_sendmsg(sock, msg, &rm, 1, rm.iov_len);
+	if (ret < 0)
+		return ret;
+	*sentp += ret;
+	if (ret != rm.iov_len)
+		return -EAGAIN;
+
+	flags = head->iov_len < xdr->len ? MSG_MORE | MSG_SENDPAGE_NOTLAST : 0;
+	ret = svc_tcp_send_kvec(sock, head, flags);
+	if (ret < 0)
+		return ret;
+	*sentp += ret;
+	if (ret != head->iov_len)
+		goto out;
+
+	if (xdr->page_len) {
+		unsigned int offset, len, remaining;
+		struct bio_vec *bvec;
+
+		bvec = xdr->bvec;
+		offset = xdr->page_base;
+		remaining = xdr->page_len;
+		flags = MSG_MORE | MSG_SENDPAGE_NOTLAST;
+		while (remaining > 0) {
+			if (remaining <= PAGE_SIZE && tail->iov_len == 0)
+				flags = 0;
+			len = min(remaining, bvec->bv_len);
+			ret = kernel_sendpage(sock, bvec->bv_page,
+					      bvec->bv_offset + offset,
+					      len, flags);
+			if (ret < 0)
+				return ret;
+			*sentp += ret;
+			if (ret != len)
+				goto out;
+			remaining -= len;
+			offset = 0;
+			bvec++;
+		}
+	}
+
+	if (tail->iov_len) {
+		ret = svc_tcp_send_kvec(sock, tail, 0);
+		if (ret < 0)
+			return ret;
+		*sentp += ret;
+	}
+
+out:
+	return 0;
+}
+
 /**
  * svc_tcp_sendto - Send out a reply on a TCP socket
  * @rqstp: completed svc_rqst
@@ -1089,7 +1173,7 @@ static int svc_tcp_sendto(struct svc_rqst *rqstp)
 	mutex_lock(&xprt->xpt_mutex);
 	if (svc_xprt_is_dead(xprt))
 		goto out_notconn;
-	err = xprt_sock_sendmsg(svsk->sk_sock, &msg, xdr, 0, marker, &sent);
+	err = svc_tcp_sendmsg(svsk->sk_sock, &msg, xdr, marker, &sent);
 	xdr_free_bvec(xdr);
 	trace_svcsock_tcp_send(xprt, err < 0 ? err : sent);
 	if (err < 0 || sent != (xdr->len + sizeof(marker)))
-- 
2.27.0



