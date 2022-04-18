Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCB75052D8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbiDRMwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbiDRMuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B772CCB7;
        Mon, 18 Apr 2022 05:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EEEBB80EDC;
        Mon, 18 Apr 2022 12:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8CDC385A1;
        Mon, 18 Apr 2022 12:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285252;
        bh=6/aVB/eAzoB2Sz2DHvIrvyJiFvWJ+nwIA8Dtc/D44Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuA9qrZpE2E7CxgB0aHVPYd1EeGSXqN6lCCO1BApf1brKAuQdjMam+M4Sa06s9pmy
         9nbllwG5BDzHc/KPV8Z6t06TPotQqZmacoJmW5VHr3RUhVLGBRZZUKHM6TotJP2yBF
         3lpjrS8YS3y26GoXmlww+aNS26HukUBtXPRVi8Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 150/189] SUNRPC: Fix NFSDs request deferral on RDMA transports
Date:   Mon, 18 Apr 2022 14:12:50 +0200
Message-Id: <20220418121206.130360041@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 773f91b2cf3f52df0d7508fdbf60f37567cdaee4 upstream.

Trond Myklebust reports an NFSD crash in svc_rdma_sendto(). Further
investigation shows that the crash occurred while NFSD was handling
a deferred request.

This patch addresses two inter-related issues that prevent request
deferral from working correctly for RPC/RDMA requests:

1. Prevent the crash by ensuring that the original
   svc_rqst::rq_xprt_ctxt value is available when the request is
   revisited. Otherwise svc_rdma_sendto() does not have a Receive
   context available with which to construct its reply.

2. Possibly since before commit 71641d99ce03 ("svcrdma: Properly
   compute .len and .buflen for received RPC Calls"),
   svc_rdma_recvfrom() did not include the transport header in the
   returned xdr_buf. There should have been no need for svc_defer()
   and friends to save and restore that header, as of that commit.
   This issue is addressed in a backport-friendly way by simply
   having svc_rdma_recvfrom() set rq_xprt_hlen to zero
   unconditionally, just as svc_tcp_recvfrom() does. This enables
   svc_deferred_recv() to correctly reconstruct an RPC message
   received via RPC/RDMA.

Reported-by: Trond Myklebust <trondmy@hammerspace.com>
Link: https://lore.kernel.org/linux-nfs/82662b7190f26fb304eb0ab1bb04279072439d4e.camel@hammerspace.com/
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc.h              |    1 +
 net/sunrpc/svc_xprt.c                   |    3 +++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -384,6 +384,7 @@ struct svc_deferred_req {
 	size_t			addrlen;
 	struct sockaddr_storage	daddr;	/* where reply must come from */
 	size_t			daddrlen;
+	void			*xprt_ctxt;
 	struct cache_deferred_req handle;
 	size_t			xprt_hlen;
 	int			argslen;
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1213,6 +1213,8 @@ static struct cache_deferred_req *svc_de
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 		dr->xprt_hlen = rqstp->rq_xprt_hlen;
+		dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
+		rqstp->rq_xprt_ctxt = NULL;
 
 		/* back up head to the start of the buffer and copy */
 		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
@@ -1251,6 +1253,7 @@ static noinline int svc_deferred_recv(st
 	rqstp->rq_xprt_hlen   = dr->xprt_hlen;
 	rqstp->rq_daddr       = dr->daddr;
 	rqstp->rq_respages    = rqstp->rq_pages;
+	rqstp->rq_xprt_ctxt   = dr->xprt_ctxt;
 	svc_xprt_received(rqstp->rq_xprt);
 	return (dr->argslen<<2) - dr->xprt_hlen;
 }
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -826,7 +826,7 @@ int svc_rdma_recvfrom(struct svc_rqst *r
 		goto out_err;
 	if (ret == 0)
 		goto out_drop;
-	rqstp->rq_xprt_hlen = ret;
+	rqstp->rq_xprt_hlen = 0;
 
 	if (svc_rdma_is_reverse_direction_reply(xprt, ctxt))
 		goto out_backchannel;


