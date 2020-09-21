Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB68272CE5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgIUQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgIUQfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAA723719;
        Mon, 21 Sep 2020 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706139;
        bh=YENuJSCxdVPSTQl4Opz/Nd5o5YFp8k7EbNJZ+Aa/z1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbDGWByavv3xETIRx3a3H0sWuXmrQ4lc55apRklE0FFS6+FSN5LGGDeNxAx7OyYJJ
         yyuLHhFgaqPrDw7mMYWjMvKlnCmNRWqeeykdZuBdh/9WfE6WtccANuUevsMs5GwBrO
         T2CUe7bcN2yckqqACFnp1OAfOp5vlY1Ul5cQyUjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Li <yieli@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 53/70] SUNRPC: stop printk reading past end of string
Date:   Mon, 21 Sep 2020 18:27:53 +0200
Message-Id: <20200921162037.551874544@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 8c6b6c793ed32b8f9770ebcdf1ba99af423c303b ]

Since p points at raw xdr data, there's no guarantee that it's NULL
terminated, so we should give a length.  And probably escape any special
characters too.

Reported-by: Zhi Li <yieli@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpcb_clnt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index eafc78e063f1d..185441d7a2814 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -975,8 +975,8 @@ static int rpcb_dec_getaddr(struct rpc_rqst *req, struct xdr_stream *xdr,
 	p = xdr_inline_decode(xdr, len);
 	if (unlikely(p == NULL))
 		goto out_fail;
-	dprintk("RPC: %5u RPCB_%s reply: %s\n", req->rq_task->tk_pid,
-			req->rq_task->tk_msg.rpc_proc->p_name, (char *)p);
+	dprintk("RPC: %5u RPCB_%s reply: %*pE\n", req->rq_task->tk_pid,
+			req->rq_task->tk_msg.rpc_proc->p_name, len, (char *)p);
 
 	if (rpc_uaddr2sockaddr(req->rq_xprt->xprt_net, (char *)p, len,
 				sap, sizeof(address)) == 0)
-- 
2.25.1



