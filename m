Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE5E34414C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhCVMcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231247AbhCVMbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EC526199E;
        Mon, 22 Mar 2021 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416298;
        bh=5se5gaFze5FojnenIsjIGSHCmUVrUyEE+kGFp3RHryE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hP454hA0UpXeMXqMjjHwgAJkK5IyNB+nDA2AJmqqNV9VkHlEgd0DSU7RNapQegTty
         SqRHEnouthU5T9H4EWh25bBjhSaeTYTVgseOh96xUQa5XZnWj0FsBOLASVOfBOFacz
         PPutpBtkZ+XXoKMwKUX8TM4Eeo+JutUEK10D5iH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Kobras <kobras@puzzle-itc.de>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 053/120] sunrpc: fix refcount leak for rpc auth modules
Date:   Mon, 22 Mar 2021 13:27:16 +0100
Message-Id: <20210322121931.453325690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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
@@ -1413,7 +1413,7 @@ svc_process_common(struct svc_rqst *rqst
 
  sendit:
 	if (svc_authorise(rqstp))
-		goto close;
+		goto close_xprt;
 	return 1;		/* Caller can now send it */
 
 release_dropit:
@@ -1425,6 +1425,8 @@ release_dropit:
 	return 0;
 
  close:
+	svc_authorise(rqstp);
+close_xprt:
 	if (rqstp->rq_xprt && test_bit(XPT_TEMP, &rqstp->rq_xprt->xpt_flags))
 		svc_close_xprt(rqstp->rq_xprt);
 	dprintk("svc: svc_process close\n");
@@ -1433,7 +1435,7 @@ release_dropit:
 err_short_len:
 	svc_printk(rqstp, "short len %zd, dropping request\n",
 			argv->iov_len);
-	goto close;
+	goto close_xprt;
 
 err_bad_rpc:
 	serv->sv_stats->rpcbadfmt++;


