Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E4740DF78
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhIPQKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbhIPQIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F436120F;
        Thu, 16 Sep 2021 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808403;
        bh=b0TWJ15KrBh9XOl6wwdaFm0lsYM5VY1rrABEVgV8nNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt6yS1vu4fQQSrW0rBwzovtn/LvTguy62D56lAnEzl55s+59CmjFa01DE1MXHgpku
         uQy2RfUynYaeELwyAHjYT+aSPbEE7yNCPUN2sEKuJ8dyhHOZ5YevR3EQLe5j8vuwi9
         ZO1hXV7qbyIGv+gjy2pMSoA0ALSFl8Yic6waVWEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/306] SUNRPC/xprtrdma: Fix reconnection locking
Date:   Thu, 16 Sep 2021 17:57:04 +0200
Message-Id: <20210916155756.748474748@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f99fa50880f5300fbbb3c0754ddc7f8738d24fe7 ]

The xprtrdma client code currently relies on the task that initiated the
connect to hold the XPRT_LOCK for the duration of the connection
attempt. If the task is woken early, due to some other event, then that
lock could get released early.
Avoid races by using the same mechanism that the socket code uses of
transferring lock ownership to the RDMA connect worker itself. That
frees us to call rpcrdma_xprt_disconnect() directly since we're now
guaranteed exclusion w.r.t. other callers.

Fixes: 4cf44be6f1e8 ("xprtrdma: Fix recursion into rpcrdma_xprt_disconnect()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c               |  2 ++
 net/sunrpc/xprtrdma/transport.c | 11 +++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index ccfa85e995fd..8201531ce5d9 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -844,6 +844,7 @@ bool xprt_lock_connect(struct rpc_xprt *xprt,
 	spin_unlock(&xprt->transport_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xprt_lock_connect);
 
 void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 {
@@ -860,6 +861,7 @@ void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 	spin_unlock(&xprt->transport_lock);
 	wake_up_bit(&xprt->state, XPRT_LOCKED);
 }
+EXPORT_SYMBOL_GPL(xprt_unlock_connect);
 
 /**
  * xprt_connect - schedule a transport connect operation
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index c26db0a37996..8e2368a0c2a2 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -249,12 +249,9 @@ xprt_rdma_connect_worker(struct work_struct *work)
 					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
 		rc = -EAGAIN;
-	} else {
-		/* Force a call to xprt_rdma_close to clean up */
-		spin_lock(&xprt->transport_lock);
-		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-		spin_unlock(&xprt->transport_lock);
-	}
+	} else
+		rpcrdma_xprt_disconnect(r_xprt);
+	xprt_unlock_connect(xprt, r_xprt);
 	xprt_wake_pending_tasks(xprt, rc);
 }
 
@@ -487,6 +484,8 @@ xprt_rdma_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 	struct rpcrdma_ep *ep = r_xprt->rx_ep;
 	unsigned long delay;
 
+	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, r_xprt));
+
 	delay = 0;
 	if (ep && ep->re_connect_status != 0) {
 		delay = xprt_reconnect_delay(xprt);
-- 
2.30.2



