Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFCE34445F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhCVM7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233189AbhCVM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB712619C4;
        Mon, 22 Mar 2021 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417382;
        bh=Q5RhL7XHwJL05v8amT0TiRX+i9gJwIhVfctROJ1vIWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6Nx8qdkg8T7kP5p7S1Q1pizDWNgMRbOsZi1znx7UjronmiaUg4qP3a8DUtkf7idN
         lkMWGlV5JE3/1qauL5S0kw05ImwALVCLsbCBfqhMyj/qYdFo+lnsBX4InVQDciAJLD
         CPqVpoVdMQ+bQrJfGqwOkqYbpSW+VbzI4487M/5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Kobras <kobras@puzzle-itc.de>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.14 20/43] sunrpc: fix refcount leak for rpc auth modules
Date:   Mon, 22 Mar 2021 13:29:01 +0100
Message-Id: <20210322121920.693130124@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Kobras <kobras@puzzle-itc.de>

commit f1442d6349a2e7bb7a6134791bdc26cb776c79af upstream.

If an auth module's accept op returns SVC_CLOSE, svc_process_common()
enters a call path that does not call svc_authorise() before leaving the
function, and thus leaks a reference on the auth module's refcount. Hence,
make sure calls to svc_authenticate() and svc_authorise() are paired for
all call paths, to make sure rpc auth modules can be unloaded.

Signed-off-by: Daniel Kobras <kobras@puzzle-itc.de>
Fixes: 4d712ef1db05 ("svcauth_gss: Close connection when dropping an incoming message")
Link: https://lore.kernel.org/linux-nfs/3F1B347F-B809-478F-A1E9-0BE98E22B0F0@oracle.com/T/#t
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1329,7 +1329,7 @@ svc_process_common(struct svc_rqst *rqst
 
  sendit:
 	if (svc_authorise(rqstp))
-		goto close;
+		goto close_xprt;
 	return 1;		/* Caller can now send it */
 
  dropit:
@@ -1338,6 +1338,8 @@ svc_process_common(struct svc_rqst *rqst
 	return 0;
 
  close:
+	svc_authorise(rqstp);
+close_xprt:
 	if (rqstp->rq_xprt && test_bit(XPT_TEMP, &rqstp->rq_xprt->xpt_flags))
 		svc_close_xprt(rqstp->rq_xprt);
 	dprintk("svc: svc_process close\n");
@@ -1346,7 +1348,7 @@ svc_process_common(struct svc_rqst *rqst
 err_short_len:
 	svc_printk(rqstp, "short len %zd, dropping request\n",
 			argv->iov_len);
-	goto close;
+	goto close_xprt;
 
 err_bad_rpc:
 	serv->sv_stats->rpcbadfmt++;


