Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B625CBD9
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfGBIDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfGBIDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4892183F;
        Tue,  2 Jul 2019 08:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054609;
        bh=N7yBcEA/YvP29KF0hR7aaT6DkCggrTkkAkNWfIWMvTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6ofxhyWwHFYtiFNQVqwJfyCh5GglU3JvOa7eWbyERl3peuZB2TSblASr6QJpJpEP
         eZNC3j6z6yAT+uVp75knsEC9KoOyGteGQyHIKnUUrze2JvfjQ5ee7yVBOkB+cubaQN
         T9uaUdnO5FZDWIGnVfAlmVKK3u6hcn36Edd5PR4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.1 28/55] SUNRPC: Fix up calculation of client message length
Date:   Tue,  2 Jul 2019 10:01:36 +0200
Message-Id: <20190702080125.558364382@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 7e3d3620974b743b91b1f9d0660061b1de20174c upstream.

In the case where a record marker was used, xs_sendpages() needs
to return the length of the payload + record marker so that we
operate correctly in the case of a partial transmission.
When the callers check return value, they therefore need to
take into account the record marker length.

Fixes: 06b5fc3ad94e ("Merge tag 'nfs-rdma-for-5.1-1'...")
Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtsock.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -950,6 +950,8 @@ static int xs_local_send_request(struct
 	struct sock_xprt *transport =
 				container_of(xprt, struct sock_xprt, xprt);
 	struct xdr_buf *xdr = &req->rq_snd_buf;
+	rpc_fraghdr rm = xs_stream_record_marker(xdr);
+	unsigned int msglen = rm ? req->rq_slen + sizeof(rm) : req->rq_slen;
 	int status;
 	int sent = 0;
 
@@ -964,9 +966,7 @@ static int xs_local_send_request(struct
 
 	req->rq_xtime = ktime_get();
 	status = xs_sendpages(transport->sock, NULL, 0, xdr,
-			      transport->xmit.offset,
-			      xs_stream_record_marker(xdr),
-			      &sent);
+			      transport->xmit.offset, rm, &sent);
 	dprintk("RPC:       %s(%u) = %d\n",
 			__func__, xdr->len - transport->xmit.offset, status);
 
@@ -976,7 +976,7 @@ static int xs_local_send_request(struct
 	if (likely(sent > 0) || status == 0) {
 		transport->xmit.offset += sent;
 		req->rq_bytes_sent = transport->xmit.offset;
-		if (likely(req->rq_bytes_sent >= req->rq_slen)) {
+		if (likely(req->rq_bytes_sent >= msglen)) {
 			req->rq_xmit_bytes_sent += transport->xmit.offset;
 			transport->xmit.offset = 0;
 			return 0;
@@ -1097,6 +1097,8 @@ static int xs_tcp_send_request(struct rp
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct xdr_buf *xdr = &req->rq_snd_buf;
+	rpc_fraghdr rm = xs_stream_record_marker(xdr);
+	unsigned int msglen = rm ? req->rq_slen + sizeof(rm) : req->rq_slen;
 	bool vm_wait = false;
 	int status;
 	int sent;
@@ -1122,9 +1124,7 @@ static int xs_tcp_send_request(struct rp
 	while (1) {
 		sent = 0;
 		status = xs_sendpages(transport->sock, NULL, 0, xdr,
-				      transport->xmit.offset,
-				      xs_stream_record_marker(xdr),
-				      &sent);
+				      transport->xmit.offset, rm, &sent);
 
 		dprintk("RPC:       xs_tcp_send_request(%u) = %d\n",
 				xdr->len - transport->xmit.offset, status);
@@ -1133,7 +1133,7 @@ static int xs_tcp_send_request(struct rp
 		 * reset the count of bytes sent. */
 		transport->xmit.offset += sent;
 		req->rq_bytes_sent = transport->xmit.offset;
-		if (likely(req->rq_bytes_sent >= req->rq_slen)) {
+		if (likely(req->rq_bytes_sent >= msglen)) {
 			req->rq_xmit_bytes_sent += transport->xmit.offset;
 			transport->xmit.offset = 0;
 			return 0;


