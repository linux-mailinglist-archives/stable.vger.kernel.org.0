Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55677411EC7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbhITRfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343783AbhITRc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31D7C61505;
        Mon, 20 Sep 2021 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157498;
        bh=tJwFCxVvDMx9HXo9GAUYplsoc62Y9n47t2yBEcF6GLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3/FteJ+iy+n2IRW+G3WOQ2fuaZZGwuKiM9v35hDXal4PzcKKGS/Ch0s3ytTTTcRg
         XnQQoVvP33VMd3ZRSoWEZ+POp2vYPHydJzBP9KIGPnn7IhunPZrQc3QKlGFphC7dvQ
         xsfCSAzYwynVs1P6loMEbpW9LbeaTLTlC4qYoXPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.19 019/293] SUNRPC/nfs: Fix return value for nfs4_callback_compound()
Date:   Mon, 20 Sep 2021 18:39:41 +0200
Message-Id: <20210920163933.918801092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 83dd59a0b9afc3b1a2642fb5c9b0585b1c08768f upstream.

RPC server procedures are normally expected to return a __be32 encoded
status value of type 'enum rpc_accept_stat', however at least one function
wants to return an authentication status of type 'enum rpc_auth_stat'
in the case where authentication fails.
This patch adds functionality to allow this.

Fixes: a4e187d83d88 ("NFS: Don't drop CB requests with invalid principals")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback_xdr.c      |    2 +-
 include/linux/sunrpc/svc.h |    2 ++
 net/sunrpc/svc.c           |   27 ++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -991,7 +991,7 @@ static __be32 nfs4_callback_compound(str
 
 out_invalidcred:
 	pr_warn_ratelimited("NFS: NFSv4 callback contains invalid cred\n");
-	return rpc_autherr_badcred;
+	return svc_return_autherr(rqstp, rpc_autherr_badcred);
 }
 
 /*
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -271,6 +271,7 @@ struct svc_rqst {
 #define	RQ_VICTIM	(5)			/* about to be shut down */
 #define	RQ_BUSY		(6)			/* request is busy */
 #define	RQ_DATA		(7)			/* request has data */
+#define RQ_AUTHERR	(8)			/* Request status is auth error */
 	unsigned long		rq_flags;	/* flags field */
 	ktime_t			rq_qtime;	/* enqueue time */
 
@@ -504,6 +505,7 @@ unsigned int	   svc_fill_write_vector(st
 char		  *svc_fill_symlink_pathname(struct svc_rqst *rqstp,
 					     struct kvec *first, void *p,
 					     size_t total);
+__be32		   svc_return_autherr(struct svc_rqst *rqstp, __be32 auth_err);
 
 #define	RPC_MAX_ADDRBUFLEN	(63U)
 
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1146,6 +1146,22 @@ static __printf(2,3) void svc_printk(str
 
 extern void svc_tcp_prep_reply_hdr(struct svc_rqst *);
 
+__be32
+svc_return_autherr(struct svc_rqst *rqstp, __be32 auth_err)
+{
+	set_bit(RQ_AUTHERR, &rqstp->rq_flags);
+	return auth_err;
+}
+EXPORT_SYMBOL_GPL(svc_return_autherr);
+
+static __be32
+svc_get_autherr(struct svc_rqst *rqstp, __be32 *statp)
+{
+	if (test_and_clear_bit(RQ_AUTHERR, &rqstp->rq_flags))
+		return *statp;
+	return rpc_auth_ok;
+}
+
 /*
  * Common routine for processing the RPC request.
  */
@@ -1296,11 +1312,9 @@ svc_process_common(struct svc_rqst *rqst
 				procp->pc_release(rqstp);
 			goto dropit;
 		}
-		if (*statp == rpc_autherr_badcred) {
-			if (procp->pc_release)
-				procp->pc_release(rqstp);
-			goto err_bad_auth;
-		}
+		auth_stat = svc_get_autherr(rqstp, statp);
+		if (auth_stat != rpc_auth_ok)
+			goto err_release_bad_auth;
 		if (*statp == rpc_success && procp->pc_encode &&
 		    !procp->pc_encode(rqstp, resv->iov_base + resv->iov_len)) {
 			dprintk("svc: failed to encode reply\n");
@@ -1359,6 +1373,9 @@ err_bad_rpc:
 	svc_putnl(resv, 2);
 	goto sendit;
 
+err_release_bad_auth:
+	if (procp->pc_release)
+		procp->pc_release(rqstp);
 err_bad_auth:
 	dprintk("svc: authentication failed (%d)\n", ntohl(auth_stat));
 	serv->sv_stats->rpcbadauth++;


