Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2011D84D3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgERR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732036AbgERR7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B8620715;
        Mon, 18 May 2020 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824762;
        bh=NmCEpgYmeMGduH1vgZ5506tzcc/1ilaFh4C+wpJCP3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hgvn3g6oyEHX4ZSr5r8XmNTeOX9HFqpBu+9Ivi5B02wFv6SaBaeau/eV4fN2ra5JW
         SDUABLHE2BI94DI5iY/bzq97lPT4Al6Emk8oTXRqsos2iTaQ37TXB7iv6cHEYFcD99
         nlgvd7Ox8l3S8olr1EJxH6tEtUM8ZXr0O0PlDRb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 141/147] SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")
Date:   Mon, 18 May 2020 19:37:44 +0200
Message-Id: <20200518173530.608825725@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 0a8e7b7d08466b5fc52f8e96070acc116d82a8bb upstream.

I've noticed that when krb5i or krb5p security is in use,
retransmitted requests are missing the server's duplicate reply
cache. The computed checksum on the retransmitted request does not
match the cached checksum, resulting in the server performing the
retransmitted request again instead of returning the cached reply.

The assumptions made when removing xdr_buf_trim() were not correct.
In the send paths, the upper layer has already set the segment
lengths correctly, and shorting the buffer's content is simply a
matter of reducing buf->len.

xdr_buf_trim() is the right answer in the receive/unwrap path on
both the client and the server. The buffer segment lengths have to
be shortened one-by-one.

On the server side in particular, head.iov_len needs to be updated
correctly to enable nfsd_cache_csum() to work correctly. The simple
buf->len computation doesn't do that, and that results in
checksumming stale data in the buffer.

The problem isn't noticed until there's significant instability of
the RPC transport. At that point, the reliability of retransmit
detection on the server becomes crucial.

Fixes: 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/xdr.h          |    1 
 net/sunrpc/auth_gss/gss_krb5_wrap.c |    7 ++----
 net/sunrpc/auth_gss/svcauth_gss.c   |    2 -
 net/sunrpc/xdr.c                    |   41 ++++++++++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 5 deletions(-)

--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -186,6 +186,7 @@ xdr_adjust_iovec(struct kvec *iov, __be3
 extern void xdr_shift_buf(struct xdr_buf *, size_t);
 extern void xdr_buf_from_iov(struct kvec *, struct xdr_buf *);
 extern int xdr_buf_subsegment(struct xdr_buf *, struct xdr_buf *, unsigned int, unsigned int);
+extern void xdr_buf_trim(struct xdr_buf *, unsigned int);
 extern int xdr_buf_read_mic(struct xdr_buf *, struct xdr_netobj *, unsigned int);
 extern int read_bytes_from_xdr_buf(struct xdr_buf *, unsigned int, void *, unsigned int);
 extern int write_bytes_to_xdr_buf(struct xdr_buf *, unsigned int, void *, unsigned int);
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -580,15 +580,14 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *
 	 */
 	movelen = min_t(unsigned int, buf->head[0].iov_len, len);
 	movelen -= offset + GSS_KRB5_TOK_HDR_LEN + headskip;
-	if (offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
-	    buf->head[0].iov_len)
-		return GSS_S_FAILURE;
+	BUG_ON(offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
+							buf->head[0].iov_len);
 	memmove(ptr, ptr + GSS_KRB5_TOK_HDR_LEN + headskip, movelen);
 	buf->head[0].iov_len -= GSS_KRB5_TOK_HDR_LEN + headskip;
 	buf->len = len - GSS_KRB5_TOK_HDR_LEN + headskip;
 
 	/* Trim off the trailing "extra count" and checksum blob */
-	buf->len -= ec + GSS_KRB5_TOK_HDR_LEN + tailskip;
+	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 
 	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);
 	*slack = *align + XDR_QUADLEN(ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -897,7 +897,7 @@ unwrap_integ_data(struct svc_rqst *rqstp
 	if (svc_getnl(&buf->head[0]) != seq)
 		goto out;
 	/* trim off the mic and padding at the end before returning */
-	buf->len -= 4 + round_up_to_quad(mic.len);
+	xdr_buf_trim(buf, round_up_to_quad(mic.len) + 4);
 	stat = 0;
 out:
 	kfree(mic.data);
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1150,6 +1150,47 @@ xdr_buf_subsegment(struct xdr_buf *buf,
 }
 EXPORT_SYMBOL_GPL(xdr_buf_subsegment);
 
+/**
+ * xdr_buf_trim - lop at most "len" bytes off the end of "buf"
+ * @buf: buf to be trimmed
+ * @len: number of bytes to reduce "buf" by
+ *
+ * Trim an xdr_buf by the given number of bytes by fixing up the lengths. Note
+ * that it's possible that we'll trim less than that amount if the xdr_buf is
+ * too small, or if (for instance) it's all in the head and the parser has
+ * already read too far into it.
+ */
+void xdr_buf_trim(struct xdr_buf *buf, unsigned int len)
+{
+	size_t cur;
+	unsigned int trim = len;
+
+	if (buf->tail[0].iov_len) {
+		cur = min_t(size_t, buf->tail[0].iov_len, trim);
+		buf->tail[0].iov_len -= cur;
+		trim -= cur;
+		if (!trim)
+			goto fix_len;
+	}
+
+	if (buf->page_len) {
+		cur = min_t(unsigned int, buf->page_len, trim);
+		buf->page_len -= cur;
+		trim -= cur;
+		if (!trim)
+			goto fix_len;
+	}
+
+	if (buf->head[0].iov_len) {
+		cur = min_t(size_t, buf->head[0].iov_len, trim);
+		buf->head[0].iov_len -= cur;
+		trim -= cur;
+	}
+fix_len:
+	buf->len -= (len - trim);
+}
+EXPORT_SYMBOL_GPL(xdr_buf_trim);
+
 static void __read_bytes_from_xdr_buf(struct xdr_buf *subbuf, void *obj, unsigned int len)
 {
 	unsigned int this_len;


