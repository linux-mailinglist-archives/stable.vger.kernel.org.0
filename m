Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B341D84EF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgERSOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgERSAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A336207C4;
        Mon, 18 May 2020 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824811;
        bh=PiIUnOhhtV6zwj7HabIkx+pTvU95yYRk5scr8HgFT8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsK6L7YBl2HGacmkK6NlFRvXsSBPL05A6i8vFYCtl6aFYuvsRbyPLGCV5SwyTcGsM
         ZisDz8lDL1Mvdkfk4cucoPADLkS74nxKVf0BA9NjBn0JZ1rlBx0kQlWT7tFXOm05gd
         cs6Xlv6O/AfMpYpx5+Da49QCBq2feWrEPsdWbkdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 014/194] SUNRPC: Fix GSS privacy computation of auth->au_ralign
Date:   Mon, 18 May 2020 19:35:04 +0200
Message-Id: <20200518173532.802740199@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a7e429a6fa6d612d1dacde96c885dc1bb4a9f400 ]

When the au_ralign field was added to gss_unwrap_resp_priv, the
wrong calculation was used. Setting au_rslack == au_ralign is
probably correct for kerberos_v1 privacy, but kerberos_v2 privacy
adds additional GSS data after the clear text RPC message.
au_ralign needs to be smaller than au_rslack in that fairly common
case.

When xdr_buf_trim() is restored to gss_unwrap_kerberos_v2(), it does
exactly what I feared it would: it trims off part of the clear text
RPC message. However, that's because rpc_prepare_reply_pages() does
not set up the rq_rcv_buf's tail correctly because au_ralign is too
large.

Fixing the au_ralign computation also corrects the alignment of
rq_rcv_buf->pages so that the client does not have to shift reply
data payloads after they are received.

Fixes: 35e77d21baa0 ("SUNRPC: Add rpc_auth::au_ralign field")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/gss_api.h      |  1 +
 net/sunrpc/auth_gss/auth_gss.c      |  8 +++-----
 net/sunrpc/auth_gss/gss_krb5_wrap.c | 19 +++++++++++++++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/sunrpc/gss_api.h b/include/linux/sunrpc/gss_api.h
index e9a79518d6527..bc07e51f20d1c 100644
--- a/include/linux/sunrpc/gss_api.h
+++ b/include/linux/sunrpc/gss_api.h
@@ -21,6 +21,7 @@
 struct gss_ctx {
 	struct gss_api_mech	*mech_type;
 	void			*internal_ctx_id;
+	unsigned int		slack, align;
 };
 
 #define GSS_C_NO_BUFFER		((struct xdr_netobj) 0)
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index a08a733f2d7c2..a7ad150fd4ee9 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -2030,7 +2030,6 @@ gss_unwrap_resp_priv(struct rpc_task *task, struct rpc_cred *cred,
 	struct xdr_buf *rcv_buf = &rqstp->rq_rcv_buf;
 	struct kvec *head = rqstp->rq_rcv_buf.head;
 	struct rpc_auth *auth = cred->cr_auth;
-	unsigned int savedlen = rcv_buf->len;
 	u32 offset, opaque_len, maj_stat;
 	__be32 *p;
 
@@ -2057,10 +2056,9 @@ gss_unwrap_resp_priv(struct rpc_task *task, struct rpc_cred *cred,
 	 */
 	xdr_init_decode(xdr, rcv_buf, p, rqstp);
 
-	auth->au_rslack = auth->au_verfsize + 2 +
-			  XDR_QUADLEN(savedlen - rcv_buf->len);
-	auth->au_ralign = auth->au_verfsize + 2 +
-			  XDR_QUADLEN(savedlen - rcv_buf->len);
+	auth->au_rslack = auth->au_verfsize + 2 + ctx->gc_gss_ctx->slack;
+	auth->au_ralign = auth->au_verfsize + 2 + ctx->gc_gss_ctx->align;
+
 	return 0;
 unwrap_failed:
 	trace_rpcgss_unwrap_failed(task);
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index c7589e35d5d92..4905652e75679 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -262,7 +262,8 @@ gss_wrap_kerberos_v1(struct krb5_ctx *kctx, int offset,
 
 static u32
 gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, int len,
-		       struct xdr_buf *buf)
+		       struct xdr_buf *buf, unsigned int *slack,
+		       unsigned int *align)
 {
 	int			signalg;
 	int			sealalg;
@@ -280,6 +281,7 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, int len,
 	u32			conflen = kctx->gk5e->conflen;
 	int			crypt_offset;
 	u8			*cksumkey;
+	unsigned int		saved_len = buf->len;
 
 	dprintk("RPC:       gss_unwrap_kerberos\n");
 
@@ -383,6 +385,10 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, int len,
 	if (gss_krb5_remove_padding(buf, blocksize))
 		return GSS_S_DEFECTIVE_TOKEN;
 
+	/* slack must include room for krb5 padding */
+	*slack = XDR_QUADLEN(saved_len - buf->len);
+	/* The GSS blob always precedes the RPC message payload */
+	*align = *slack;
 	return GSS_S_COMPLETE;
 }
 
@@ -489,7 +495,8 @@ gss_wrap_kerberos_v2(struct krb5_ctx *kctx, u32 offset,
 
 static u32
 gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, int len,
-		       struct xdr_buf *buf)
+		       struct xdr_buf *buf, unsigned int *slack,
+		       unsigned int *align)
 {
 	time64_t	now;
 	u8		*ptr;
@@ -583,6 +590,8 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, int len,
 	/* Trim off the trailing "extra count" and checksum blob */
 	buf->len -= ec + GSS_KRB5_TOK_HDR_LEN + tailskip;
 
+	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);
+	*slack = *align + XDR_QUADLEN(ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 	return GSS_S_COMPLETE;
 }
 
@@ -617,9 +626,11 @@ gss_unwrap_kerberos(struct gss_ctx *gctx, int offset,
 	case ENCTYPE_DES_CBC_RAW:
 	case ENCTYPE_DES3_CBC_RAW:
 	case ENCTYPE_ARCFOUR_HMAC:
-		return gss_unwrap_kerberos_v1(kctx, offset, len, buf);
+		return gss_unwrap_kerberos_v1(kctx, offset, len, buf,
+					      &gctx->slack, &gctx->align);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
-		return gss_unwrap_kerberos_v2(kctx, offset, len, buf);
+		return gss_unwrap_kerberos_v2(kctx, offset, len, buf,
+					      &gctx->slack, &gctx->align);
 	}
 }
-- 
2.20.1



