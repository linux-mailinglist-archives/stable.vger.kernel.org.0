Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A256673BB
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjALN5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjALN5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:57:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CB448CEE
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 301A161F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311DC433EF;
        Thu, 12 Jan 2023 13:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531820;
        bh=H8t5L49o0g/XMciPO70pXGcB6byECZ2Psx0oSm9ps6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuO4rPeTPlFOSKW81D+8wXVX+I9HOv5OlyGjP9a56jQHgcYqXrGJkkx7Atcy3c8up
         00BYfoTBc6LoncaivrWDrmIkiXUxpSN/CZ/ioJ8UbU/ra+dQ0TK2xXUeHzEM7RQlTF
         e4tGd0vF//ZYDrPn67QbsLgbn3vwllu2vHwXda6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 08/10] Revert "SUNRPC: Use RMW bitops in single-threaded hot paths"
Date:   Thu, 12 Jan 2023 14:56:29 +0100
Message-Id: <20230112135327.324829549@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 7827c81f0248e3c2f40d438b020f3d222f002171 upstream.

The premise that "Once an svc thread is scheduled and executing an
RPC, no other processes will touch svc_rqst::rq_flags" is false.
svc_xprt_enqueue() examines the RQ_BUSY flag in scheduled nfsd
threads when determining which thread to wake up next.

Found via KCSAN.

Fixes: 28df0988815f ("SUNRPC: Use RMW bitops in single-threaded hot paths")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c                       |    7 +++----
 fs/nfsd/nfs4xdr.c                        |    2 +-
 net/sunrpc/auth_gss/svcauth_gss.c        |    4 ++--
 net/sunrpc/svc.c                         |    6 +++---
 net/sunrpc/svc_xprt.c                    |    2 +-
 net/sunrpc/svcsock.c                     |    8 ++++----
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 7 files changed, 15 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -928,7 +928,7 @@ nfsd4_read(struct svc_rqst *rqstp, struc
 	 * the client wants us to do more in this compound:
 	 */
 	if (!nfsd4_last_compound_op(rqstp))
-		__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* check stateid */
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
@@ -2615,12 +2615,11 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 	cstate->minorversion = args->minorversion;
 	fh_init(current_fh, NFS4_FHSIZE);
 	fh_init(save_fh, NFS4_FHSIZE);
-
 	/*
 	 * Don't use the deferral mechanism for NFSv4; compounds make it
 	 * too hard to avoid non-idempotency problems.
 	 */
-	__clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 
 	/*
 	 * According to RFC3010, this takes precedence over all other errors.
@@ -2742,7 +2741,7 @@ encode_op:
 out:
 	cstate->status = status;
 	/* Reset deferral mechanism for RPC deferrals */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2464,7 +2464,7 @@ nfsd4_decode_compound(struct nfsd4_compo
 	argp->rqstp->rq_cachetype = cachethis ? RC_REPLBUFF : RC_NOCACHE;
 
 	if (readcount > 1 || max_reply > PAGE_SIZE - auth_slack)
-		__clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
 
 	return true;
 }
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -900,7 +900,7 @@ unwrap_integ_data(struct svc_rqst *rqstp
 	 * rejecting the server-computed MIC in this somewhat rare case,
 	 * do not use splice with the GSS integrity service.
 	 */
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* Did we already verify the signature on the original pass through? */
 	if (rqstp->rq_deferred)
@@ -972,7 +972,7 @@ unwrap_priv_data(struct svc_rqst *rqstp,
 	int pad, remaining_len, offset;
 	u32 rseqno;
 
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	priv_len = svc_getnl(&buf->head[0]);
 	if (rqstp->rq_deferred) {
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1244,10 +1244,10 @@ svc_process_common(struct svc_rqst *rqst
 		goto err_short_len;
 
 	/* Will be turned off by GSS integrity and privacy services */
-	__set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 	/* Will be turned off only when NFSv4 Sessions are used */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
-	__clear_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	svc_putu32(resv, rqstp->rq_xid);
 
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1238,7 +1238,7 @@ static struct cache_deferred_req *svc_de
 	trace_svc_defer(rqstp);
 	svc_xprt_get(rqstp->rq_xprt);
 	dr->xprt = rqstp->rq_xprt;
-	__set_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	dr->handle.revisit = svc_revisit;
 	return &dr->handle;
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -298,9 +298,9 @@ static void svc_sock_setbufsize(struct s
 static void svc_sock_secure_port(struct svc_rqst *rqstp)
 {
 	if (svc_port_is_privileged(svc_addr(rqstp)))
-		__set_bit(RQ_SECURE, &rqstp->rq_flags);
+		set_bit(RQ_SECURE, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_SECURE, &rqstp->rq_flags);
+		clear_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 /*
@@ -1008,9 +1008,9 @@ static int svc_tcp_recvfrom(struct svc_r
 	rqstp->rq_xprt_ctxt   = NULL;
 	rqstp->rq_prot	      = IPPROTO_TCP;
 	if (test_bit(XPT_LOCAL, &svsk->sk_xprt.xpt_flags))
-		__set_bit(RQ_LOCAL, &rqstp->rq_flags);
+		set_bit(RQ_LOCAL, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_LOCAL, &rqstp->rq_flags);
+		clear_bit(RQ_LOCAL, &rqstp->rq_flags);
 
 	p = (__be32 *)rqstp->rq_arg.head[0].iov_base;
 	calldir = p[1];
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -602,7 +602,7 @@ static int svc_rdma_has_wspace(struct sv
 
 static void svc_rdma_secure_port(struct svc_rqst *rqstp)
 {
-	__set_bit(RQ_SECURE, &rqstp->rq_flags);
+	set_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 static void svc_rdma_kill_temp_xprt(struct svc_xprt *xprt)


