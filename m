Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE42408BE
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHJPYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgHJPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF41E208A9;
        Mon, 10 Aug 2020 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073077;
        bh=68W1lrHON+mnXteN5uH5KydswQjNoHEBArDwS/NNm4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or6eJ8yfGd6WbMkpCDTcimH1sTg825OVZxBCxLNaAS9iJdmGwFZHwFBFN5H4bmZhp
         fYYbbOmkqEeOhhgyMncH3eHsIDOIDhzFbHoxNh3uRKLGEBVOJ6ZJdx0ZzZzUX+Pe/w
         gvq9CKBGHhFNELOX9f5aKAzCA2hFZacU1axECnvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b54969381df354936d96@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 58/79] rxrpc: Fix race between recvmsg and sendmsg on immediate call failure
Date:   Mon, 10 Aug 2020 17:21:17 +0200
Message-Id: <20200810151815.116370289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 65550098c1c4db528400c73acf3e46bfa78d9264 ]

There's a race between rxrpc_sendmsg setting up a call, but then failing to
send anything on it due to an error, and recvmsg() seeing the call
completion occur and trying to return the state to the user.

An assertion fails in rxrpc_recvmsg() because the call has already been
released from the socket and is about to be released again as recvmsg deals
with it.  (The recvmsg_q queue on the socket holds a ref, so there's no
problem with use-after-free.)

We also have to be careful not to end up reporting an error twice, in such
a way that both returns indicate to userspace that the user ID supplied
with the call is no longer in use - which could cause the client to
malfunction if it recycles the user ID fast enough.

Fix this by the following means:

 (1) When sendmsg() creates a call after the point that the call has been
     successfully added to the socket, don't return any errors through
     sendmsg(), but rather complete the call and let recvmsg() retrieve
     them.  Make sendmsg() return 0 at this point.  Further calls to
     sendmsg() for that call will fail with ESHUTDOWN.

     Note that at this point, we haven't send any packets yet, so the
     server doesn't yet know about the call.

 (2) If sendmsg() returns an error when it was expected to create a new
     call, it means that the user ID wasn't used.

 (3) Mark the call disconnected before marking it completed to prevent an
     oops in rxrpc_release_call().

 (4) recvmsg() will then retrieve the error and set MSG_EOR to indicate
     that the user ID is no longer known by the kernel.

An oops like the following is produced:

	kernel BUG at net/rxrpc/recvmsg.c:605!
	...
	RIP: 0010:rxrpc_recvmsg+0x256/0x5ae
	...
	Call Trace:
	 ? __init_waitqueue_head+0x2f/0x2f
	 ____sys_recvmsg+0x8a/0x148
	 ? import_iovec+0x69/0x9c
	 ? copy_msghdr_from_user+0x5c/0x86
	 ___sys_recvmsg+0x72/0xaa
	 ? __fget_files+0x22/0x57
	 ? __fget_light+0x46/0x51
	 ? fdget+0x9/0x1b
	 do_recvmmsg+0x15e/0x232
	 ? _raw_spin_unlock+0xa/0xb
	 ? vtime_delta+0xf/0x25
	 __x64_sys_recvmmsg+0x2c/0x2f
	 do_syscall_64+0x4c/0x78
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 357f5ef64628 ("rxrpc: Call rxrpc_release_call() on error in rxrpc_new_client_call()")
Reported-by: syzbot+b54969381df354936d96@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_object.c |   27 +++++++++++++++++++--------
 net/rxrpc/conn_object.c |    8 +++++---
 net/rxrpc/recvmsg.c     |    2 +-
 net/rxrpc/sendmsg.c     |    3 +++
 4 files changed, 28 insertions(+), 12 deletions(-)

--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -288,7 +288,7 @@ struct rxrpc_call *rxrpc_new_client_call
 	 */
 	ret = rxrpc_connect_call(rx, call, cp, srx, gfp);
 	if (ret < 0)
-		goto error;
+		goto error_attached_to_socket;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
 			 atomic_read(&call->usage), here, NULL);
@@ -308,18 +308,29 @@ struct rxrpc_call *rxrpc_new_client_call
 error_dup_user_ID:
 	write_unlock(&rx->call_lock);
 	release_sock(&rx->sk);
-	ret = -EEXIST;
-
-error:
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
-				    RX_CALL_DEAD, ret);
+				    RX_CALL_DEAD, -EEXIST);
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(ret));
+			 atomic_read(&call->usage), here, ERR_PTR(-EEXIST));
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
-	_leave(" = %d", ret);
-	return ERR_PTR(ret);
+	_leave(" = -EEXIST");
+	return ERR_PTR(-EEXIST);
+
+	/* We got an error, but the call is attached to the socket and is in
+	 * need of release.  However, we might now race with recvmsg() when
+	 * completing the call queues it.  Return 0 from sys_sendmsg() and
+	 * leave the error to recvmsg() to deal with.
+	 */
+error_attached_to_socket:
+	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
+			 atomic_read(&call->usage), here, ERR_PTR(ret));
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
+				    RX_CALL_DEAD, ret);
+	_leave(" = c=%08x [err]", call->debug_id);
+	return call;
 }
 
 /*
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -212,9 +212,11 @@ void rxrpc_disconnect_call(struct rxrpc_
 
 	call->peer->cong_cwnd = call->cong_cwnd;
 
-	spin_lock_bh(&conn->params.peer->lock);
-	hlist_del_rcu(&call->error_link);
-	spin_unlock_bh(&conn->params.peer->lock);
+	if (!hlist_unhashed(&call->error_link)) {
+		spin_lock_bh(&call->peer->lock);
+		hlist_del_rcu(&call->error_link);
+		spin_unlock_bh(&call->peer->lock);
+	}
 
 	if (rxrpc_is_client_call(call))
 		return rxrpc_disconnect_client_call(call);
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -541,7 +541,7 @@ try_again:
 			goto error_unlock_call;
 	}
 
-	if (msg->msg_name) {
+	if (msg->msg_name && call->peer) {
 		struct sockaddr_rxrpc *srx = msg->msg_name;
 		size_t len = sizeof(call->peer->srx);
 
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -683,6 +683,9 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *
 		if (IS_ERR(call))
 			return PTR_ERR(call);
 		/* ... and we have the call lock. */
+		ret = 0;
+		if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE)
+			goto out_put_unlock;
 	} else {
 		switch (READ_ONCE(call->state)) {
 		case RXRPC_CALL_UNINITIALISED:


