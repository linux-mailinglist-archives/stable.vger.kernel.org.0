Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0F619916C
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgCaJSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbgCaJSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:18:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEC732072E;
        Tue, 31 Mar 2020 09:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646312;
        bh=S+l0kdqv9zAU8su7E9NEvsIw1agQzL5zm07q0m8C7sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVjICcnEAkgQavRPd6yD5agtXJLyCRgSINX0nc3WNrgGDFBzLTkuHxBeW5s398ade
         IKx5TmOgxCHmIlnR4oMSqyyWNWWygUk3lm6Yh1QV7c6JRdXFIblUMj7qgJ6GdAH5gG
         a+GqCUPjX9tW4sEnwdoLtWtD8VBAOLqVrw/WX1EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 109/155] afs: Fix handling of an abort from a service handler
Date:   Tue, 31 Mar 2020 10:59:09 +0200
Message-Id: <20200331085430.846470116@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit dde9f095583b3f375ba23979045ee10dfcebec2f upstream.

When an AFS service handler function aborts a call, AF_RXRPC marks the call
as complete - which means that it's not going to get any more packets from
the receiver.  This is a problem because reception of the final ACK is what
triggers afs_deliver_to_call() to drop the final ref on the afs_call
object.

Instead, aborted AFS service calls may then just sit around waiting for
ever or until they're displaced by a new call on the same connection
channel or a connection-level abort.

Fix this by calling afs_set_call_complete() to finalise the afs_call struct
representing the call.

However, we then need to drop the ref that stops the call from being
deallocated.  We can do this in afs_set_call_complete(), as the work queue
is holding a separate ref of its own, but then we shouldn't do it in
afs_process_async_call() and afs_delete_async_call().

call->drop_ref is set to indicate that a ref needs dropping for a call and
this is dealt with when we transition a call to AFS_CALL_COMPLETE.

But then we also need to get rid of the ref that pins an asynchronous
client call.  We can do this by the same mechanism, setting call->drop_ref
for an async client call too.

We can also get rid of call->incoming since nothing ever sets it and only
one thing ever checks it (futilely).


A trace of the rxrpc_call and afs_call struct ref counting looks like:

          <idle>-0     [001] ..s5   164.764892: rxrpc_call: c=00000002 SEE u=3 sp=rxrpc_new_incoming_call+0x473/0xb34 a=00000000442095b5
          <idle>-0     [001] .Ns5   164.766001: rxrpc_call: c=00000002 QUE u=4 sp=rxrpc_propose_ACK+0xbe/0x551 a=00000000442095b5
          <idle>-0     [001] .Ns4   164.766005: rxrpc_call: c=00000002 PUT u=3 sp=rxrpc_new_incoming_call+0xa3f/0xb34 a=00000000442095b5
          <idle>-0     [001] .Ns7   164.766433: afs_call: c=00000002 WAKE  u=2 o=11 sp=rxrpc_notify_socket+0x196/0x33c
     kworker/1:2-1810  [001] ...1   164.768409: rxrpc_call: c=00000002 SEE u=3 sp=rxrpc_process_call+0x25/0x7ae a=00000000442095b5
     kworker/1:2-1810  [001] ...1   164.769439: rxrpc_tx_packet: c=00000002 e9f1a7a8:95786a88:00000008:09c5 00000001 00000000 02 22 ACK CallAck
     kworker/1:2-1810  [001] ...1   164.769459: rxrpc_call: c=00000002 PUT u=2 sp=rxrpc_process_call+0x74f/0x7ae a=00000000442095b5
     kworker/1:2-1810  [001] ...1   164.770794: afs_call: c=00000002 QUEUE u=3 o=12 sp=afs_deliver_to_call+0x449/0x72c
     kworker/1:2-1810  [001] ...1   164.770829: afs_call: c=00000002 PUT   u=2 o=12 sp=afs_process_async_call+0xdb/0x11e
     kworker/1:2-1810  [001] ...2   164.771084: rxrpc_abort: c=00000002 95786a88:00000008 s=0 a=1 e=1 K-1
     kworker/1:2-1810  [001] ...1   164.771461: rxrpc_tx_packet: c=00000002 e9f1a7a8:95786a88:00000008:09c5 00000002 00000000 04 00 ABORT CallAbort
     kworker/1:2-1810  [001] ...1   164.771466: afs_call: c=00000002 PUT   u=1 o=12 sp=SRXAFSCB_ProbeUuid+0xc1/0x106

The abort generated in SRXAFSCB_ProbeUuid(), labelled "K-1", indicates that
the local filesystem/cache manager didn't recognise the UUID as its own.

Fixes: 2067b2b3f484 ("afs: Fix the CB.ProbeUuid service handler to reply correctly")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/cmservice.c |   14 ++++++++++++--
 fs/afs/internal.h  |   12 ++++++++++--
 fs/afs/rxrpc.c     |   33 ++++-----------------------------
 3 files changed, 26 insertions(+), 33 deletions(-)

--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -244,6 +244,17 @@ static void afs_cm_destructor(struct afs
 }
 
 /*
+ * Abort a service call from within an action function.
+ */
+static void afs_abort_service_call(struct afs_call *call, u32 abort_code, int error,
+				   const char *why)
+{
+	rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
+				abort_code, error, why);
+	afs_set_call_complete(call, error, 0);
+}
+
+/*
  * The server supplied a list of callbacks that it wanted to break.
  */
 static void SRXAFSCB_CallBack(struct work_struct *work)
@@ -510,8 +521,7 @@ static void SRXAFSCB_ProbeUuid(struct wo
 	if (memcmp(r, &call->net->uuid, sizeof(call->net->uuid)) == 0)
 		afs_send_empty_reply(call);
 	else
-		rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-					1, 1, "K-1");
+		afs_abort_service_call(call, 1, 1, "K-1");
 
 	afs_put_call(call);
 	_leave("");
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -154,7 +154,7 @@ struct afs_call {
 	};
 	unsigned char		unmarshall;	/* unmarshalling phase */
 	unsigned char		addr_ix;	/* Address in ->alist */
-	bool			incoming;	/* T if incoming call */
+	bool			drop_ref;	/* T if need to drop ref for incoming call */
 	bool			send_pages;	/* T if data from mapping should be sent */
 	bool			need_attention;	/* T if RxRPC poked us */
 	bool			async;		/* T if asynchronous */
@@ -1203,8 +1203,16 @@ static inline void afs_set_call_complete
 		ok = true;
 	}
 	spin_unlock_bh(&call->state_lock);
-	if (ok)
+	if (ok) {
 		trace_afs_call_done(call);
+
+		/* Asynchronous calls have two refs to release - one from the alloc and
+		 * one queued with the work item - and we can't just deallocate the
+		 * call because the work item may be queued again.
+		 */
+		if (call->drop_ref)
+			afs_put_call(call);
+	}
 }
 
 /*
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -18,7 +18,6 @@ struct workqueue_struct *afs_async_calls
 
 static void afs_wake_up_call_waiter(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_wake_up_async_call(struct sock *, struct rxrpc_call *, unsigned long);
-static void afs_delete_async_call(struct work_struct *);
 static void afs_process_async_call(struct work_struct *);
 static void afs_rx_new_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_rx_discard_new_call(struct rxrpc_call *, unsigned long);
@@ -402,8 +401,10 @@ void afs_make_call(struct afs_addr_curso
 	/* If the call is going to be asynchronous, we need an extra ref for
 	 * the call to hold itself so the caller need not hang on to its ref.
 	 */
-	if (call->async)
+	if (call->async) {
 		afs_get_call(call, afs_call_trace_get);
+		call->drop_ref = true;
+	}
 
 	/* create a call */
 	rxcall = rxrpc_kernel_begin_call(call->net->socket, srx, call->key,
@@ -584,8 +585,6 @@ static void afs_deliver_to_call(struct a
 done:
 	if (call->type->done)
 		call->type->done(call);
-	if (state == AFS_CALL_COMPLETE && call->incoming)
-		afs_put_call(call);
 out:
 	_leave("");
 	return;
@@ -745,21 +744,6 @@ static void afs_wake_up_async_call(struc
 }
 
 /*
- * Delete an asynchronous call.  The work item carries a ref to the call struct
- * that we need to release.
- */
-static void afs_delete_async_call(struct work_struct *work)
-{
-	struct afs_call *call = container_of(work, struct afs_call, async_work);
-
-	_enter("");
-
-	afs_put_call(call);
-
-	_leave("");
-}
-
-/*
  * Perform I/O processing on an asynchronous call.  The work item carries a ref
  * to the call struct that we either need to release or to pass on.
  */
@@ -774,16 +758,6 @@ static void afs_process_async_call(struc
 		afs_deliver_to_call(call);
 	}
 
-	if (call->state == AFS_CALL_COMPLETE) {
-		/* We have two refs to release - one from the alloc and one
-		 * queued with the work item - and we can't just deallocate the
-		 * call because the work item may be queued again.
-		 */
-		call->async_work.func = afs_delete_async_call;
-		if (!queue_work(afs_async_calls, &call->async_work))
-			afs_put_call(call);
-	}
-
 	afs_put_call(call);
 	_leave("");
 }
@@ -810,6 +784,7 @@ void afs_charge_preallocation(struct wor
 			if (!call)
 				break;
 
+			call->drop_ref = true;
 			call->async = true;
 			call->state = AFS_CALL_SV_AWAIT_OP_ID;
 			init_waitqueue_head(&call->waitq);


