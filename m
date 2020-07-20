Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CB2226743
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbgGTQKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387628AbgGTQKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA1320672;
        Mon, 20 Jul 2020 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261409;
        bh=BP5p3xvMdM2LHrjqsnq4+2Ifc19baMI8Cqa1u5Fe9vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd20TkyZau7HN2ZogBj8gCRXC6PB5EeKm2h/oS/P+4OPXow4IbBjIOug/UHtcQgvI
         gJUPYqx9Jg1iP+CsVO7KKt/2HsJmTp0LrmWbeLwPvASut7SLA5tfughV61EpR8w6Y+
         bNKKOcmILxEETTomW50HW2xVP85vZK5uDBHEKdxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/244] xprtrdma: Fix recursion into rpcrdma_xprt_disconnect()
Date:   Mon, 20 Jul 2020 17:36:15 +0200
Message-Id: <20200720152830.777325100@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4cf44be6f1e86da302085bf3e1dc2c86f3cdaaaa ]

Both Dan and I have observed two processes invoking
rpcrdma_xprt_disconnect() concurrently. In my case:

1. The connect worker invokes rpcrdma_xprt_disconnect(), which
   drains the QP and waits for the final completion
2. This causes the newly posted Receive to flush and invoke
   xprt_force_disconnect()
3. xprt_force_disconnect() sets CLOSE_WAIT and wakes up the RPC task
   that is holding the transport lock
4. The RPC task invokes xprt_connect(), which calls ->ops->close
5. xprt_rdma_close() invokes rpcrdma_xprt_disconnect(), which tries
   to destroy the QP.

Deadlock.

To prevent xprt_force_disconnect() from waking anything, handle the
clean up after a failed connection attempt in the xprt's sndtask.

The retry loop is removed from rpcrdma_xprt_connect() to ensure
that the newly allocated ep and id are properly released before
a REJECTED connection attempt can be retried.

Reported-by: Dan Aloni <dan@kernelim.com>
Fixes: e28ce90083f0 ("xprtrdma: kmalloc rpcrdma_ep separate from rpcrdma_xprt")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/transport.c |  5 +++++
 net/sunrpc/xprtrdma/verbs.c     | 10 ++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 659da37020a46..3b5fb1f57aeb7 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -249,6 +249,11 @@ xprt_rdma_connect_worker(struct work_struct *work)
 					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
 		rc = -EAGAIN;
+	} else {
+		/* Force a call to xprt_rdma_close to clean up */
+		spin_lock(&xprt->transport_lock);
+		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+		spin_unlock(&xprt->transport_lock);
 	}
 	xprt_wake_pending_tasks(xprt, rc);
 }
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 4cb91dde849b9..00ee62579137b 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -288,7 +288,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 			sap, rdma_reject_msg(id, event->status));
 		ep->re_connect_status = -ECONNREFUSED;
 		if (event->status == IB_CM_REJ_STALE_CONN)
-			ep->re_connect_status = -EAGAIN;
+			ep->re_connect_status = -ENOTCONN;
 		goto disconnected;
 	case RDMA_CM_EVENT_DISCONNECTED:
 		ep->re_connect_status = -ECONNABORTED;
@@ -519,8 +519,6 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 	struct rpcrdma_ep *ep;
 	int rc;
 
-retry:
-	rpcrdma_xprt_disconnect(r_xprt);
 	rc = rpcrdma_ep_create(r_xprt);
 	if (rc)
 		return rc;
@@ -549,17 +547,13 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 	wait_event_interruptible(ep->re_connect_wait,
 				 ep->re_connect_status != 0);
 	if (ep->re_connect_status <= 0) {
-		if (ep->re_connect_status == -EAGAIN)
-			goto retry;
 		rc = ep->re_connect_status;
 		goto out;
 	}
 
 	rc = rpcrdma_reqs_setup(r_xprt);
-	if (rc) {
-		rpcrdma_xprt_disconnect(r_xprt);
+	if (rc)
 		goto out;
-	}
 	rpcrdma_mrs_create(r_xprt);
 
 out:
-- 
2.25.1



