Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED004F31B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354107AbiDEKLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344190AbiDEJSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0D5673FC;
        Tue,  5 Apr 2022 02:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF38D614E4;
        Tue,  5 Apr 2022 09:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA18C385A0;
        Tue,  5 Apr 2022 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149511;
        bh=eUsgjC8EUy7Jhy7bQB65UsbKAQIwSW3Ze00Fs+nIr/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8LHuhjBHxmwpxdOyq/Fcc+UJ/0TZs6EUptSSN67bNGnE/kk5ztPJQ5xJfxa6ch1O
         K6zYxGNltm5LxuOyz+b1fV+uDCwt/Sfqs1X830S8uqL56TO7UwX+uH3AGrqIVWa084
         SiIKQhCcSnr+MOrmFxIDnVbOKF5L8N+OHLwH80Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 0714/1017] SUNRPC: improve swap handling: scheduling and PF_MEMALLOC
Date:   Tue,  5 Apr 2022 09:27:07 +0200
Message-Id: <20220405070415.463278689@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 8db55a032ac7ac1ed7b98d6b1dc980e6378c652f ]

rpc tasks can be marked as RPC_TASK_SWAPPER.  This causes GFP_MEMALLOC
to be used for some allocations.  This is needed in some cases, but not
in all where it is currently provided, and in some where it isn't
provided.

Currently *all* tasks associated with a rpc_client on which swap is
enabled get the flag and hence some GFP_MEMALLOC support.

GFP_MEMALLOC is provided for ->buf_alloc() but only swap-writes need it.
However xdr_alloc_bvec does not get GFP_MEMALLOC - though it often does
need it.

xdr_alloc_bvec is called while the XPRT_LOCK is held.  If this blocks,
then it blocks all other queued tasks.  So this allocation needs
GFP_MEMALLOC for *all* requests, not just writes, when the xprt is used
for any swap writes.

Similarly, if the transport is not connected, that will block all
requests including swap writes, so memory allocations should get
GFP_MEMALLOC if swap writes are possible.

So with this patch:
 1/ we ONLY set RPC_TASK_SWAPPER for swap writes.
 2/ __rpc_execute() sets PF_MEMALLOC while handling any task
    with RPC_TASK_SWAPPER set, or when handling any task that
    holds the XPRT_LOCKED lock on an xprt used for swap.
    This removes the need for the RPC_IS_SWAPPER() test
    in ->buf_alloc handlers.
 3/ xprt_prepare_transmit() sets PF_MEMALLOC after locking
    any task to a swapper xprt.  __rpc_execute() will clear it.
 3/ PF_MEMALLOC is set for all the connect workers.

Reviewed-by: Chuck Lever <chuck.lever@oracle.com> (for xprtrdma parts)
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c                  |  2 ++
 net/sunrpc/clnt.c               |  2 --
 net/sunrpc/sched.c              | 20 +++++++++++++++++---
 net/sunrpc/xprt.c               |  3 +++
 net/sunrpc/xprtrdma/transport.c |  6 ++++--
 net/sunrpc/xprtsock.c           |  8 ++++++++
 6 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 7a23b4644507..e86aff429993 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1411,6 +1411,8 @@ static void nfs_initiate_write(struct nfs_pgio_header *hdr,
 {
 	int priority = flush_task_priority(how);
 
+	if (IS_SWAPFILE(hdr->inode))
+		task_setup_data->flags |= RPC_TASK_SWAPPER;
 	task_setup_data->priority = priority;
 	rpc_ops->write_setup(hdr, msg, &task_setup_data->rpc_client);
 	trace_nfs_initiate_write(hdr);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index c83fe618767c..5985b78eddf1 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1085,8 +1085,6 @@ void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 		task->tk_flags |= RPC_TASK_TIMEOUT;
 	if (clnt->cl_noretranstimeo)
 		task->tk_flags |= RPC_TASK_NO_RETRANS_TIMEOUT;
-	if (atomic_read(&clnt->cl_swapper))
-		task->tk_flags |= RPC_TASK_SWAPPER;
 	/* Add to the client's list of all tasks */
 	spin_lock(&clnt->cl_lock);
 	list_add_tail(&task->tk_task, &clnt->cl_tasks);
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index d5b6e897f5a5..ae295844ac55 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -876,6 +876,15 @@ void rpc_release_calldata(const struct rpc_call_ops *ops, void *calldata)
 		ops->rpc_release(calldata);
 }
 
+static bool xprt_needs_memalloc(struct rpc_xprt *xprt, struct rpc_task *tk)
+{
+	if (!xprt)
+		return false;
+	if (!atomic_read(&xprt->swapper))
+		return false;
+	return test_bit(XPRT_LOCKED, &xprt->state) && xprt->snd_task == tk;
+}
+
 /*
  * This is the RPC `scheduler' (or rather, the finite state machine).
  */
@@ -884,6 +893,7 @@ static void __rpc_execute(struct rpc_task *task)
 	struct rpc_wait_queue *queue;
 	int task_is_async = RPC_IS_ASYNC(task);
 	int status = 0;
+	unsigned long pflags = current->flags;
 
 	WARN_ON_ONCE(RPC_IS_QUEUED(task));
 	if (RPC_IS_QUEUED(task))
@@ -906,6 +916,10 @@ static void __rpc_execute(struct rpc_task *task)
 		}
 		if (!do_action)
 			break;
+		if (RPC_IS_SWAPPER(task) ||
+		    xprt_needs_memalloc(task->tk_xprt, task))
+			current->flags |= PF_MEMALLOC;
+
 		trace_rpc_task_run_action(task, do_action);
 		do_action(task);
 
@@ -943,7 +957,7 @@ static void __rpc_execute(struct rpc_task *task)
 		rpc_clear_running(task);
 		spin_unlock(&queue->lock);
 		if (task_is_async)
-			return;
+			goto out;
 
 		/* sync task: sleep here */
 		trace_rpc_task_sync_sleep(task, task->tk_action);
@@ -967,6 +981,8 @@ static void __rpc_execute(struct rpc_task *task)
 
 	/* Release all resources associated with the task */
 	rpc_release_task(task);
+out:
+	current_restore_flags(pflags, PF_MEMALLOC);
 }
 
 /*
@@ -1025,8 +1041,6 @@ int rpc_malloc(struct rpc_task *task)
 
 	if (RPC_IS_ASYNC(task))
 		gfp = GFP_NOWAIT | __GFP_NOWARN;
-	if (RPC_IS_SWAPPER(task))
-		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 5388263f8fc8..396a74974f60 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1503,6 +1503,9 @@ bool xprt_prepare_transmit(struct rpc_task *task)
 		return false;
 
 	}
+	if (atomic_read(&xprt->swapper))
+		/* This will be clear in __rpc_execute */
+		current->flags |= PF_MEMALLOC;
 	return true;
 }
 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index a52277115500..6268af7e0310 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -239,8 +239,11 @@ xprt_rdma_connect_worker(struct work_struct *work)
 	struct rpcrdma_xprt *r_xprt = container_of(work, struct rpcrdma_xprt,
 						   rx_connect_worker.work);
 	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
+	unsigned int pflags = current->flags;
 	int rc;
 
+	if (atomic_read(&xprt->swapper))
+		current->flags |= PF_MEMALLOC;
 	rc = rpcrdma_xprt_connect(r_xprt);
 	xprt_clear_connecting(xprt);
 	if (!rc) {
@@ -254,6 +257,7 @@ xprt_rdma_connect_worker(struct work_struct *work)
 		rpcrdma_xprt_disconnect(r_xprt);
 	xprt_unlock_connect(xprt, r_xprt);
 	xprt_wake_pending_tasks(xprt, rc);
+	current_restore_flags(pflags, PF_MEMALLOC);
 }
 
 /**
@@ -576,8 +580,6 @@ xprt_rdma_allocate(struct rpc_task *task)
 	flags = RPCRDMA_DEF_GFP;
 	if (RPC_IS_ASYNC(task))
 		flags = GFP_NOWAIT | __GFP_NOWARN;
-	if (RPC_IS_SWAPPER(task))
-		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_check_regbuf(r_xprt, req->rl_sendbuf, rqst->rq_callsize,
 				  flags))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 056fa0230359..821eeea1c83b 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2070,7 +2070,10 @@ static void xs_udp_setup_socket(struct work_struct *work)
 	struct rpc_xprt *xprt = &transport->xprt;
 	struct socket *sock;
 	int status = -EIO;
+	unsigned int pflags = current->flags;
 
+	if (atomic_read(&xprt->swapper))
+		current->flags |= PF_MEMALLOC;
 	sock = xs_create_sock(xprt, transport,
 			xs_addr(xprt)->sa_family, SOCK_DGRAM,
 			IPPROTO_UDP, false);
@@ -2090,6 +2093,7 @@ static void xs_udp_setup_socket(struct work_struct *work)
 	xprt_clear_connecting(xprt);
 	xprt_unlock_connect(xprt, transport);
 	xprt_wake_pending_tasks(xprt, status);
+	current_restore_flags(pflags, PF_MEMALLOC);
 }
 
 /**
@@ -2249,7 +2253,10 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	struct socket *sock = transport->sock;
 	struct rpc_xprt *xprt = &transport->xprt;
 	int status;
+	unsigned int pflags = current->flags;
 
+	if (atomic_read(&xprt->swapper))
+		current->flags |= PF_MEMALLOC;
 	if (!sock) {
 		sock = xs_create_sock(xprt, transport,
 				xs_addr(xprt)->sa_family, SOCK_STREAM,
@@ -2314,6 +2321,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	xprt_clear_connecting(xprt);
 out_unlock:
 	xprt_unlock_connect(xprt, transport);
+	current_restore_flags(pflags, PF_MEMALLOC);
 }
 
 /**
-- 
2.34.1



