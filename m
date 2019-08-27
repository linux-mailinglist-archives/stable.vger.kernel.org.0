Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C969DFFB
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbfH0H71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbfH0H7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0681217F5;
        Tue, 27 Aug 2019 07:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892763;
        bh=DshuPobI8Dnkog7Q9j2n0ly1ktr0cpKEiii2MKrU8Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl3gDrayj5J26xyuN2ECmSOkKJcs6xrc7UHDbo1hzvw//YTAzlh5Ybid8zEmznr4u
         UobFo5eedRcmVS+sbt5xaCpwRKphWK5vEbbfUP6WYVaZH+nOdhzsEobCy3VjVfqef2
         1slo11G3BhpEA9F5Uvd6wv6AaiEf1EJuMMQIiRHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 4.19 97/98] rxrpc: Fix local endpoint refcounting
Date:   Tue, 27 Aug 2019 09:51:16 +0200
Message-Id: <20190827072723.397975073@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 730c5fd42c1e3652a065448fd235cb9fafb2bd10 upstream.

The object lifetime management on the rxrpc_local struct is broken in that
the rxrpc_local_processor() function is expected to clean up and remove an
object - but it may get requeued by packets coming in on the backing UDP
socket once it starts running.

This may result in the assertion in rxrpc_local_rcu() firing because the
memory has been scheduled for RCU destruction whilst still queued:

	rxrpc: Assertion failed
	------------[ cut here ]------------
	kernel BUG at net/rxrpc/local_object.c:468!

Note that if the processor comes around before the RCU free function, it
will just do nothing because ->dead is true.

Fix this by adding a separate refcount to count active users of the
endpoint that causes the endpoint to be destroyed when it reaches 0.

The original refcount can then be used to refcount objects through the work
processor and cause the memory to be rcu freed when that reaches 0.

Fixes: 4f95dd78a77e ("rxrpc: Rework local endpoint management")
Reported-by: syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/af_rxrpc.c     |    4 +-
 net/rxrpc/ar-internal.h  |    5 ++
 net/rxrpc/input.c        |   16 ++++++--
 net/rxrpc/local_object.c |   86 +++++++++++++++++++++++++++++------------------
 4 files changed, 72 insertions(+), 39 deletions(-)

--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -195,7 +195,7 @@ static int rxrpc_bind(struct socket *soc
 
 service_in_use:
 	write_unlock(&local->services_lock);
-	rxrpc_put_local(local);
+	rxrpc_unuse_local(local);
 	ret = -EADDRINUSE;
 error_unlock:
 	release_sock(&rx->sk);
@@ -908,7 +908,7 @@ static int rxrpc_release_sock(struct soc
 	rxrpc_queue_work(&rxnet->service_conn_reaper);
 	rxrpc_queue_work(&rxnet->client_conn_reaper);
 
-	rxrpc_put_local(rx->local);
+	rxrpc_unuse_local(rx->local);
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -258,7 +258,8 @@ struct rxrpc_security {
  */
 struct rxrpc_local {
 	struct rcu_head		rcu;
-	atomic_t		usage;
+	atomic_t		active_users;	/* Number of users of the local endpoint */
+	atomic_t		usage;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
 	struct list_head	link;
 	struct socket		*socket;	/* my UDP socket */
@@ -998,6 +999,8 @@ struct rxrpc_local *rxrpc_lookup_local(s
 struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *);
 struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *);
 void rxrpc_put_local(struct rxrpc_local *);
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *);
+void rxrpc_unuse_local(struct rxrpc_local *);
 void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1106,8 +1106,12 @@ static void rxrpc_post_packet_to_local(s
 {
 	_enter("%p,%p", local, skb);
 
-	skb_queue_tail(&local->event_queue, skb);
-	rxrpc_queue_local(local);
+	if (rxrpc_get_local_maybe(local)) {
+		skb_queue_tail(&local->event_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	}
 }
 
 /*
@@ -1117,8 +1121,12 @@ static void rxrpc_reject_packet(struct r
 {
 	CHECK_SLAB_OKAY(&local->usage);
 
-	skb_queue_tail(&local->reject_queue, skb);
-	rxrpc_queue_local(local);
+	if (rxrpc_get_local_maybe(local)) {
+		skb_queue_tail(&local->reject_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	}
 }
 
 /*
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -83,6 +83,7 @@ static struct rxrpc_local *rxrpc_alloc_l
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
 		atomic_set(&local->usage, 1);
+		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_LIST_HEAD(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
@@ -270,11 +271,8 @@ struct rxrpc_local *rxrpc_lookup_local(s
 		 * bind the transport socket may still fail if we're attempting
 		 * to use a local address that the dying object is still using.
 		 */
-		if (!rxrpc_get_local_maybe(local)) {
-			cursor = cursor->next;
-			list_del_init(&local->link);
+		if (!rxrpc_use_local(local))
 			break;
-		}
 
 		age = "old";
 		goto found;
@@ -288,7 +286,10 @@ struct rxrpc_local *rxrpc_lookup_local(s
 	if (ret < 0)
 		goto sock_error;
 
-	list_add_tail(&local->link, cursor);
+	if (cursor != &rxnet->local_endpoints)
+		list_replace(cursor, &local->link);
+	else
+		list_add_tail(&local->link, cursor);
 	age = "new";
 
 found:
@@ -346,7 +347,8 @@ struct rxrpc_local *rxrpc_get_local_mayb
 }
 
 /*
- * Queue a local endpoint.
+ * Queue a local endpoint unless it has become unreferenced and pass the
+ * caller's reference to the work item.
  */
 void rxrpc_queue_local(struct rxrpc_local *local)
 {
@@ -355,15 +357,8 @@ void rxrpc_queue_local(struct rxrpc_loca
 	if (rxrpc_queue_work(&local->processor))
 		trace_rxrpc_local(local, rxrpc_local_queued,
 				  atomic_read(&local->usage), here);
-}
-
-/*
- * A local endpoint reached its end of life.
- */
-static void __rxrpc_put_local(struct rxrpc_local *local)
-{
-	_enter("%d", local->debug_id);
-	rxrpc_queue_work(&local->processor);
+	else
+		rxrpc_put_local(local);
 }
 
 /*
@@ -379,11 +374,46 @@ void rxrpc_put_local(struct rxrpc_local
 		trace_rxrpc_local(local, rxrpc_local_put, n, here);
 
 		if (n == 0)
-			__rxrpc_put_local(local);
+			call_rcu(&local->rcu, rxrpc_local_rcu);
 	}
 }
 
 /*
+ * Start using a local endpoint.
+ */
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
+{
+	unsigned int au;
+
+	local = rxrpc_get_local_maybe(local);
+	if (!local)
+		return NULL;
+
+	au = atomic_fetch_add_unless(&local->active_users, 1, 0);
+	if (au == 0) {
+		rxrpc_put_local(local);
+		return NULL;
+	}
+
+	return local;
+}
+
+/*
+ * Cease using a local endpoint.  Once the number of active users reaches 0, we
+ * start the closure of the transport in the work processor.
+ */
+void rxrpc_unuse_local(struct rxrpc_local *local)
+{
+	unsigned int au;
+
+	au = atomic_dec_return(&local->active_users);
+	if (au == 0)
+		rxrpc_queue_local(local);
+	else
+		rxrpc_put_local(local);
+}
+
+/*
  * Destroy a local endpoint's socket and then hand the record to RCU to dispose
  * of.
  *
@@ -397,16 +427,6 @@ static void rxrpc_local_destroyer(struct
 
 	_enter("%d", local->debug_id);
 
-	/* We can get a race between an incoming call packet queueing the
-	 * processor again and the work processor starting the destruction
-	 * process which will shut down the UDP socket.
-	 */
-	if (local->dead) {
-		_leave(" [already dead]");
-		return;
-	}
-	local->dead = true;
-
 	mutex_lock(&rxnet->local_mutex);
 	list_del_init(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
@@ -426,13 +446,11 @@ static void rxrpc_local_destroyer(struct
 	 */
 	rxrpc_purge_queue(&local->reject_queue);
 	rxrpc_purge_queue(&local->event_queue);
-
-	_debug("rcu local %d", local->debug_id);
-	call_rcu(&local->rcu, rxrpc_local_rcu);
 }
 
 /*
- * Process events on an endpoint
+ * Process events on an endpoint.  The work item carries a ref which
+ * we must release.
  */
 static void rxrpc_local_processor(struct work_struct *work)
 {
@@ -445,8 +463,10 @@ static void rxrpc_local_processor(struct
 
 	do {
 		again = false;
-		if (atomic_read(&local->usage) == 0)
-			return rxrpc_local_destroyer(local);
+		if (atomic_read(&local->active_users) == 0) {
+			rxrpc_local_destroyer(local);
+			break;
+		}
 
 		if (!skb_queue_empty(&local->reject_queue)) {
 			rxrpc_reject_packets(local);
@@ -458,6 +478,8 @@ static void rxrpc_local_processor(struct
 			again = true;
 		}
 	} while (again);
+
+	rxrpc_put_local(local);
 }
 
 /*


