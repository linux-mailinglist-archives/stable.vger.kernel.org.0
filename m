Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2B13FD88
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388528AbgAPX0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388305AbgAPX0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D1020684;
        Thu, 16 Jan 2020 23:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217209;
        bh=glpq+x/zJdkKmj8HYLHatQTZkXN+xIdD5FaHpHa3FU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj0oeDqKZlymwlEjZoBOJLxVkvNm0DWPStVsuHk4XxsFS2alrUIVAzGIAvLdbh8cA
         1wkp2QPij3c2N+sXZwnlurxoMTitaeKnOY3vxAfXe0sHajbirRfrwFUUcOGhEbZLzB
         F3gzAUf0oq6+dSFZikPzCR0W31M1OMh5ZHBvxSS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/203] rxrpc: Dont take call->user_mutex in rxrpc_new_incoming_call()
Date:   Fri, 17 Jan 2020 00:18:30 +0100
Message-Id: <20200116231801.081015323@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 13b7955a0252e15265386b229b814152f109b234 ]

Standard kernel mutexes cannot be used in any way from interrupt or softirq
context, so the user_mutex which manages access to a call cannot be a mutex
since on a new call the mutex must start off locked and be unlocked within
the softirq handler to prevent userspace interfering with a call we're
setting up.

Commit a0855d24fc22d49cdc25664fb224caee16998683 ("locking/mutex: Complain
upon mutex API misuse in IRQ contexts") causes big warnings to be splashed
in dmesg for each a new call that comes in from the server.  Whilst it
*seems* like it should be okay, since the accept path uses trylock, there
are issues with PI boosting and marking the wrong task as the owner.

Fix this by not taking the mutex in the softirq path at all.  It's not
obvious that there should be any need for it as the state is set before the
first notification is generated for the new call.

There's also no particular reason why the link-assessing ping should be
triggered inside the mutex.  It's not actually transmitted there anyway,
but rather it has to be deferred to a workqueue.

Further, I don't think that there's any particular reason that the socket
notification needs to be done from within rx->incoming_lock, so the amount
of time that lock is held can be shortened too and the ping prepared before
the new call notification is sent.

Fixes: 540b1c48c37a ("rxrpc: Fix deadlock between call creation and sendmsg/recvmsg")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Peter Zijlstra (Intel) <peterz@infradead.org>
cc: Ingo Molnar <mingo@redhat.com>
cc: Will Deacon <will@kernel.org>
cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_accept.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 3685b1732f65..44fa22b020ef 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -381,18 +381,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	trace_rxrpc_receive(call, rxrpc_receive_incoming,
 			    sp->hdr.serial, sp->hdr.seq);
 
-	/* Lock the call to prevent rxrpc_kernel_send/recv_data() and
-	 * sendmsg()/recvmsg() inconveniently stealing the mutex once the
-	 * notification is generated.
-	 *
-	 * The BUG should never happen because the kernel should be well
-	 * behaved enough not to access the call before the first notification
-	 * event and userspace is prevented from doing so until the state is
-	 * appropriate.
-	 */
-	if (!mutex_trylock(&call->user_mutex))
-		BUG();
-
 	/* Make the call live. */
 	rxrpc_incoming_call(rx, call, skb);
 	conn = call->conn;
@@ -433,6 +421,9 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 		BUG();
 	}
 	spin_unlock(&conn->state_lock);
+	spin_unlock(&rx->incoming_lock);
+
+	rxrpc_send_ping(call, skb);
 
 	if (call->state == RXRPC_CALL_SERVER_ACCEPTING)
 		rxrpc_notify_socket(call);
@@ -444,11 +435,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 */
 	rxrpc_put_call(call, rxrpc_call_put);
 
-	spin_unlock(&rx->incoming_lock);
-
-	rxrpc_send_ping(call, skb);
-	mutex_unlock(&call->user_mutex);
-
 	_leave(" = %p{%d}", call, call->debug_id);
 	return call;
 
-- 
2.20.1



