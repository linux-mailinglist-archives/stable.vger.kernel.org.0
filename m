Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED67197CD1
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgC3NZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:25:31 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34775 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727370AbgC3NZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 09:25:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F1405709;
        Mon, 30 Mar 2020 09:25:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 09:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pmO9UL
        ZzWtfsnQrrYqEltT7MvwlLHcQRYBQUI27zCKQ=; b=kD/cvdhZc63KjiN/F2sob7
        his9PSrmtfUDbCnA8pQN7wjazZgD36nxdgQW5FA7cJZH0ImmBsEfVJ/0lvL7wpUi
        RPe1AM2f+aXdEkRJ29rrT7xmmoBrQr5SeWOq1VTcgd2qn5shzeyF21W/zuEKxOlz
        gQnru4ONdr+iuQQjVgD5GO24/zL05Tze5oEoIm90Gi/4XD+euyilhI/GG7ifUwuB
        w4v+oCE5+qoZ4FJu8OYoxbmUYwQ6F4JxTKlRo1JX5/0v8wGkc12x9pbQit1/KX2A
        rvYEYWJit3x/W6Gg/pCkGMPTFK8ie2FiAjcHGmZbAhSCdqQ0JOCC/N7tcVWx4DTg
        ==
X-ME-Sender: <xms:SfOBXstYzOCMzdJBjUQfpRH-0DrOD6rUMZkWTCyllAiqV6oY8JozQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SfOBXmXCEt1gl6t3OaZydeiHNtaZLP7ytib3eCvLmbT6ooTgNIqfOQ>
    <xmx:SfOBXmisKGwonH4Ps2kTFOMydrf7WKqsfUhKBSJr6C-T7iCIikKMyw>
    <xmx:SfOBXjfXSfeT6aYBI2v8IYlqs8XdtNuONWgl1rA7_Adjd9luVxa29Q>
    <xmx:SfOBXsKSX_Q6tJ-k4Gg6hdCiZdMrG9roHul09-i0B5qZCTRbEMuXfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5E523280059;
        Mon, 30 Mar 2020 09:25:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] afs: Fix handling of an abort from a service handler" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 15:25:27 +0200
Message-ID: <158557472720577@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dde9f095583b3f375ba23979045ee10dfcebec2f Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Fri, 13 Mar 2020 13:46:08 +0000
Subject: [PATCH] afs: Fix handling of an abort from a service handler

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

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index ff3994a6be23..6765949b3aab 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -243,6 +243,17 @@ static void afs_cm_destructor(struct afs_call *call)
 	call->buffer = NULL;
 }
 
+/*
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
 /*
  * The server supplied a list of callbacks that it wanted to break.
  */
@@ -510,8 +521,7 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 	if (memcmp(r, &call->net->uuid, sizeof(call->net->uuid)) == 0)
 		afs_send_empty_reply(call);
 	else
-		rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-					1, 1, "K-1");
+		afs_abort_service_call(call, 1, 1, "K-1");
 
 	afs_put_call(call);
 	_leave("");
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 1d81fc4c3058..52de2112e1b1 100644
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
@@ -1209,8 +1209,16 @@ static inline void afs_set_call_complete(struct afs_call *call,
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
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 907d5948564a..972e3aafa361 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -18,7 +18,6 @@ struct workqueue_struct *afs_async_calls;
 
 static void afs_wake_up_call_waiter(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_wake_up_async_call(struct sock *, struct rxrpc_call *, unsigned long);
-static void afs_delete_async_call(struct work_struct *);
 static void afs_process_async_call(struct work_struct *);
 static void afs_rx_new_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_rx_discard_new_call(struct rxrpc_call *, unsigned long);
@@ -402,8 +401,10 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
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
@@ -585,8 +586,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 done:
 	if (call->type->done)
 		call->type->done(call);
-	if (state == AFS_CALL_COMPLETE && call->incoming)
-		afs_put_call(call);
 out:
 	_leave("");
 	return;
@@ -745,21 +744,6 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 	}
 }
 
-/*
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
 /*
  * Perform I/O processing on an asynchronous call.  The work item carries a ref
  * to the call struct that we either need to release or to pass on.
@@ -775,16 +759,6 @@ static void afs_process_async_call(struct work_struct *work)
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
@@ -811,6 +785,7 @@ void afs_charge_preallocation(struct work_struct *work)
 			if (!call)
 				break;
 
+			call->drop_ref = true;
 			call->async = true;
 			call->state = AFS_CALL_SV_AWAIT_OP_ID;
 			init_waitqueue_head(&call->waitq);

