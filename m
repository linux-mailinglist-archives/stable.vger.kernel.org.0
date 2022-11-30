Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97A863DF59
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiK3SqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiK3SqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384CF99F29
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC72261D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D28C433D6;
        Wed, 30 Nov 2022 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833960;
        bh=2pz691OfsyP6cRZWoKAZ0660RZzdKn/bXNnKhcBx0/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzQBLIIx9b9Vll/bh6zkvIQl+nd7LBjB1dsN0xFeg4A2H6/i6Ej3lOZ7cLdOs6NJA
         5AclXtohku/YTCoa4nouCsp9FnbMBFr+zAZQ8w1YYbXEy/KSLExRDzBDulr/39PqHH
         Yr3Kg/24HB2zMt3hmVWJNLulhZrGMS/1NS19KElE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        zdi-disclosures@trendmicro.com,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 077/289] rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]
Date:   Wed, 30 Nov 2022 19:21:02 +0100
Message-Id: <20221130180545.886629980@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3bcd6c7eaa53b56c3f584da46a1f7652e759d0e5 ]

After rxrpc_unbundle_conn() has removed a connection from a bundle, it
checks to see if there are any conns with available channels and, if not,
removes and attempts to destroy the bundle.

Whilst it does check after grabbing client_bundles_lock that there are no
connections attached, this races with rxrpc_look_up_bundle() retrieving the
bundle, but not attaching a connection for the connection to be attached
later.

There is therefore a window in which the bundle can get destroyed before we
manage to attach a new connection to it.

Fix this by adding an "active" counter to struct rxrpc_bundle:

 (1) rxrpc_connect_call() obtains an active count by prepping/looking up a
     bundle and ditches it before returning.

 (2) If, during rxrpc_connect_call(), a connection is added to the bundle,
     this obtains an active count, which is held until the connection is
     discarded.

 (3) rxrpc_deactivate_bundle() is created to drop an active count on a
     bundle and destroy it when the active count reaches 0.  The active
     count is checked inside client_bundles_lock() to prevent a race with
     rxrpc_look_up_bundle().

 (4) rxrpc_unbundle_conn() then calls rxrpc_deactivate_bundle().

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-15975
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: zdi-disclosures@trendmicro.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/conn_client.c | 38 +++++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 62c70709d798..e0123efa2a62 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -399,6 +399,7 @@ enum rxrpc_conn_proto_state {
 struct rxrpc_bundle {
 	struct rxrpc_conn_parameters params;
 	refcount_t		ref;
+	atomic_t		active;		/* Number of active users */
 	unsigned int		debug_id;
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 3c9eeb5b750c..bdb335cb2d05 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -40,6 +40,8 @@ __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 DEFINE_IDR(rxrpc_client_conn_ids);
 static DEFINE_SPINLOCK(rxrpc_conn_id_lock);
 
+static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
+
 /*
  * Get a connection ID and epoch for a client connection from the global pool.
  * The connection struct pointer is then recorded in the idr radix tree.  The
@@ -123,6 +125,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 		bundle->params = *cp;
 		rxrpc_get_peer(bundle->params.peer);
 		refcount_set(&bundle->ref, 1);
+		atomic_set(&bundle->active, 1);
 		spin_lock_init(&bundle->channel_lock);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
 	}
@@ -149,7 +152,7 @@ void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
 
 	dead = __refcount_dec_and_test(&bundle->ref, &r);
 
-	_debug("PUT B=%x %d", d, r);
+	_debug("PUT B=%x %d", d, r - 1);
 	if (dead)
 		rxrpc_free_bundle(bundle);
 }
@@ -338,6 +341,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
+	atomic_inc(&bundle->active);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = %u [found]", bundle->debug_id);
 	return bundle;
@@ -435,6 +439,7 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 			if (old)
 				trace_rxrpc_client(old, -1, rxrpc_client_replace);
 			candidate->bundle_shift = shift;
+			atomic_inc(&bundle->active);
 			bundle->conns[i] = candidate;
 			for (j = 0; j < RXRPC_MAXCALLS; j++)
 				set_bit(shift + j, &bundle->avail_chans);
@@ -725,6 +730,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	smp_rmb();
 
 out_put_bundle:
+	rxrpc_deactivate_bundle(bundle);
 	rxrpc_put_bundle(bundle);
 out:
 	_leave(" = %d", ret);
@@ -900,9 +906,8 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_bundle *bundle = conn->bundle;
-	struct rxrpc_local *local = bundle->params.local;
 	unsigned int bindex;
-	bool need_drop = false, need_put = false;
+	bool need_drop = false;
 	int i;
 
 	_enter("C=%x", conn->debug_id);
@@ -921,15 +926,22 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 	}
 	spin_unlock(&bundle->channel_lock);
 
-	/* If there are no more connections, remove the bundle */
-	if (!bundle->avail_chans) {
-		_debug("maybe unbundle");
-		spin_lock(&local->client_bundles_lock);
+	if (need_drop) {
+		rxrpc_deactivate_bundle(bundle);
+		rxrpc_put_connection(conn);
+	}
+}
 
-		for (i = 0; i < ARRAY_SIZE(bundle->conns); i++)
-			if (bundle->conns[i])
-				break;
-		if (i == ARRAY_SIZE(bundle->conns) && !bundle->params.exclusive) {
+/*
+ * Drop the active count on a bundle.
+ */
+static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
+{
+	struct rxrpc_local *local = bundle->params.local;
+	bool need_put = false;
+
+	if (atomic_dec_and_lock(&bundle->active, &local->client_bundles_lock)) {
+		if (!bundle->params.exclusive) {
 			_debug("erase bundle");
 			rb_erase(&bundle->local_node, &local->client_bundles);
 			need_put = true;
@@ -939,10 +951,6 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 		if (need_put)
 			rxrpc_put_bundle(bundle);
 	}
-
-	if (need_drop)
-		rxrpc_put_connection(conn);
-	_leave("");
 }
 
 /*
-- 
2.35.1



