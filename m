Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390214F34A2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245238AbiDEIyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbiDEIcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D3DB91B0;
        Tue,  5 Apr 2022 01:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B4E6117A;
        Tue,  5 Apr 2022 08:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83083C385A2;
        Tue,  5 Apr 2022 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147195;
        bh=YMuvDVCXN0t5GEpEso/ItGrfwaHKye26v8Bn/LLLC+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD8ismDVo92r1QOkX+tb0IAcjFRhNxZmqDvazmqEDqMVPmgkweyXtZdXN1aH5vz61
         OAoiE3qTiFthE7aS5mrpyZVTPzCUkB2fIUCXQYpGcV+hi/qkZIfRJi94iZl+r3zbHL
         1T8bD+QR2fFdKOF+0R8xkoJQd/cQeQLOZ3QPJAdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 1035/1126] rxrpc: Fix call timer start racing with call destruction
Date:   Tue,  5 Apr 2022 09:29:42 +0200
Message-Id: <20220405070437.856096500@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 4a7f62f91933c8ae5308f9127fd8ea48188b6bc3 upstream.

The rxrpc_call struct has a timer used to handle various timed events
relating to a call.  This timer can get started from the packet input
routines that are run in softirq mode with just the RCU read lock held.
Unfortunately, because only the RCU read lock is held - and neither ref or
other lock is taken - the call can start getting destroyed at the same time
a packet comes in addressed to that call.  This causes the timer - which
was already stopped - to get restarted.  Later, the timer dispatch code may
then oops if the timer got deallocated first.

Fix this by trying to take a ref on the rxrpc_call struct and, if
successful, passing that ref along to the timer.  If the timer was already
running, the ref is discarded.

The timer completion routine can then pass the ref along to the call's work
item when it queues it.  If the timer or work item where already
queued/running, the extra ref is discarded.

Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-March/005073.html
Link: https://lore.kernel.org/r/164865115696.2943015.11097991776647323586.stgit@warthog.procyon.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    8 +++++++-
 net/rxrpc/ar-internal.h      |   15 +++++++--------
 net/rxrpc/call_event.c       |    2 +-
 net/rxrpc/call_object.c      |   40 +++++++++++++++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 15 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -83,12 +83,15 @@ enum rxrpc_call_trace {
 	rxrpc_call_error,
 	rxrpc_call_got,
 	rxrpc_call_got_kernel,
+	rxrpc_call_got_timer,
 	rxrpc_call_got_userid,
 	rxrpc_call_new_client,
 	rxrpc_call_new_service,
 	rxrpc_call_put,
 	rxrpc_call_put_kernel,
 	rxrpc_call_put_noqueue,
+	rxrpc_call_put_notimer,
+	rxrpc_call_put_timer,
 	rxrpc_call_put_userid,
 	rxrpc_call_queued,
 	rxrpc_call_queued_ref,
@@ -278,12 +281,15 @@ enum rxrpc_tx_point {
 	EM(rxrpc_call_error,			"*E*") \
 	EM(rxrpc_call_got,			"GOT") \
 	EM(rxrpc_call_got_kernel,		"Gke") \
+	EM(rxrpc_call_got_timer,		"GTM") \
 	EM(rxrpc_call_got_userid,		"Gus") \
 	EM(rxrpc_call_new_client,		"NWc") \
 	EM(rxrpc_call_new_service,		"NWs") \
 	EM(rxrpc_call_put,			"PUT") \
 	EM(rxrpc_call_put_kernel,		"Pke") \
-	EM(rxrpc_call_put_noqueue,		"PNQ") \
+	EM(rxrpc_call_put_noqueue,		"PnQ") \
+	EM(rxrpc_call_put_notimer,		"PnT") \
+	EM(rxrpc_call_put_timer,		"PTM") \
 	EM(rxrpc_call_put_userid,		"Pus") \
 	EM(rxrpc_call_queued,			"QUE") \
 	EM(rxrpc_call_queued_ref,		"QUR") \
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -777,14 +777,12 @@ void rxrpc_propose_ACK(struct rxrpc_call
 		       enum rxrpc_propose_ack_trace);
 void rxrpc_process_call(struct work_struct *);
 
-static inline void rxrpc_reduce_call_timer(struct rxrpc_call *call,
-					   unsigned long expire_at,
-					   unsigned long now,
-					   enum rxrpc_timer_trace why)
-{
-	trace_rxrpc_timer(call, why, now);
-	timer_reduce(&call->timer, expire_at);
-}
+void rxrpc_reduce_call_timer(struct rxrpc_call *call,
+			     unsigned long expire_at,
+			     unsigned long now,
+			     enum rxrpc_timer_trace why);
+
+void rxrpc_delete_call_timer(struct rxrpc_call *call);
 
 /*
  * call_object.c
@@ -808,6 +806,7 @@ void rxrpc_release_calls_on_socket(struc
 bool __rxrpc_queue_call(struct rxrpc_call *);
 bool rxrpc_queue_call(struct rxrpc_call *);
 void rxrpc_see_call(struct rxrpc_call *);
+bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op);
 void rxrpc_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_put_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_cleanup_call(struct rxrpc_call *);
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -310,7 +310,7 @@ recheck_state:
 	}
 
 	if (call->state == RXRPC_CALL_COMPLETE) {
-		del_timer_sync(&call->timer);
+		rxrpc_delete_call_timer(call);
 		goto out_put;
 	}
 
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -53,10 +53,30 @@ static void rxrpc_call_timer_expired(str
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		trace_rxrpc_timer(call, rxrpc_timer_expired, jiffies);
-		rxrpc_queue_call(call);
+		__rxrpc_queue_call(call);
+	} else {
+		rxrpc_put_call(call, rxrpc_call_put);
+	}
+}
+
+void rxrpc_reduce_call_timer(struct rxrpc_call *call,
+			     unsigned long expire_at,
+			     unsigned long now,
+			     enum rxrpc_timer_trace why)
+{
+	if (rxrpc_try_get_call(call, rxrpc_call_got_timer)) {
+		trace_rxrpc_timer(call, why, now);
+		if (timer_reduce(&call->timer, expire_at))
+			rxrpc_put_call(call, rxrpc_call_put_notimer);
 	}
 }
 
+void rxrpc_delete_call_timer(struct rxrpc_call *call)
+{
+	if (del_timer_sync(&call->timer))
+		rxrpc_put_call(call, rxrpc_call_put_timer);
+}
+
 static struct lock_class_key rxrpc_call_user_mutex_lock_class_key;
 
 /*
@@ -463,6 +483,17 @@ void rxrpc_see_call(struct rxrpc_call *c
 	}
 }
 
+bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
+{
+	const void *here = __builtin_return_address(0);
+	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
+
+	if (n == 0)
+		return false;
+	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	return true;
+}
+
 /*
  * Note the addition of a ref on a call.
  */
@@ -510,8 +541,7 @@ void rxrpc_release_call(struct rxrpc_soc
 	spin_unlock_bh(&call->lock);
 
 	rxrpc_put_call_slot(call);
-
-	del_timer_sync(&call->timer);
+	rxrpc_delete_call_timer(call);
 
 	/* Make sure we don't get any more notifications */
 	write_lock_bh(&rx->recvmsg_lock);
@@ -618,6 +648,8 @@ static void rxrpc_destroy_call(struct wo
 	struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
 	struct rxrpc_net *rxnet = call->rxnet;
 
+	rxrpc_delete_call_timer(call);
+
 	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
@@ -652,8 +684,6 @@ void rxrpc_cleanup_call(struct rxrpc_cal
 
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
-	del_timer_sync(&call->timer);
-
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 


