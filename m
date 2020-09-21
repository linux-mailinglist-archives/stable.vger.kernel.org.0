Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A54272E54
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgIUQsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729812AbgIUQsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D36C23888;
        Mon, 21 Sep 2020 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706884;
        bh=GjawHTpRZQneiMFwJreFa6zEEKuLLXl9QYrcHAXXn7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdCHDA6A3I2+9cSZUH81U+a/u2VzgAB6CBa0yhQAmAFWJ51jUGX0FfzEQtR78msI/
         Ezy7LD4YMv90D8JedtX/sL4AnFGARoqxnULC7VZWicH64jxXLdlen5NaaGfkLhi4n7
         QW9B5a0W9oR1ir/wtExBC0JGtKRt2JFFUFNRPgrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Li <yieli@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/72] SUNRPC: stop printk reading past end of string
Date:   Mon, 21 Sep 2020 18:30:54 +0200
Message-Id: <20200921163122.599379761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
index 4a020b6888608..1db9f62e466d9 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -988,8 +988,8 @@ static int rpcb_dec_getaddr(struct rpc_rqst *req, struct xdr_stream *xdr,
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



