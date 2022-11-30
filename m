Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EFC63DD83
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiK3S2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiK3S2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:28:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A88B40921
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C26F1B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2223FC433D6;
        Wed, 30 Nov 2022 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832881;
        bh=lZT8B0TA+bXH2nET3/0KmbVGe4jQEGPDWJYl6zp+uBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvaKfwxTzrayHehmJ14o8Vwe37Q9z8D2UFS1IyR5u7Ega6EO4lGt1NPQLECHNPS0U
         gNbXZbZDH4zIA9VTKk8zv/ZkPg1ZWtAUfUpOhuR4nkSrC+cGit6tBNha8V6WoAdsVN
         mR5Zxw8tchfcJ3DxOOGwwc58OXN0GSuHk7+GiaDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/162] rxrpc: Allow list of in-use local UDP endpoints to be viewed in /proc
Date:   Wed, 30 Nov 2022 19:22:08 +0100
Message-Id: <20221130180529.781403025@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

[ Upstream commit 33912c2639ad76660988c8ca97e4d18fca89b668 ]

Allow the list of in-use local UDP endpoints in the current network
namespace to be viewed in /proc.

To aid with this, the endpoint list is converted to an hlist and RCU-safe
manipulation is used so that the list can be read with only the RCU
read lock held.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3bcd6c7eaa53 ("rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h  |  5 +--
 net/rxrpc/local_object.c | 37 +++++++++++----------
 net/rxrpc/net_ns.c       |  5 ++-
 net/rxrpc/proc.c         | 69 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 22 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ccb65412b670..2d0c797a176a 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -86,7 +86,7 @@ struct rxrpc_net {
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
 
-	struct list_head	local_endpoints;
+	struct hlist_head	local_endpoints;
 	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
 
 	DECLARE_HASHTABLE	(peer_hash, 10);
@@ -266,7 +266,7 @@ struct rxrpc_local {
 	atomic_t		active_users;	/* Number of users of the local endpoint */
 	atomic_t		usage;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
-	struct list_head	link;
+	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
@@ -1001,6 +1001,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *);
 extern const struct seq_operations rxrpc_call_seq_ops;
 extern const struct seq_operations rxrpc_connection_seq_ops;
 extern const struct seq_operations rxrpc_peer_seq_ops;
+extern const struct seq_operations rxrpc_local_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ebbf1b03b62c..11db28a902f4 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -81,7 +81,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		atomic_set(&local->usage, 1);
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
-		INIT_LIST_HEAD(&local->link);
+		INIT_HLIST_NODE(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
@@ -199,7 +199,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 {
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
-	struct list_head *cursor;
+	struct hlist_node *cursor;
 	const char *age;
 	long diff;
 	int ret;
@@ -209,16 +209,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 
 	mutex_lock(&rxnet->local_mutex);
 
-	for (cursor = rxnet->local_endpoints.next;
-	     cursor != &rxnet->local_endpoints;
-	     cursor = cursor->next) {
-		local = list_entry(cursor, struct rxrpc_local, link);
+	hlist_for_each(cursor, &rxnet->local_endpoints) {
+		local = hlist_entry(cursor, struct rxrpc_local, link);
 
 		diff = rxrpc_local_cmp_key(local, srx);
-		if (diff < 0)
+		if (diff != 0)
 			continue;
-		if (diff > 0)
-			break;
 
 		/* Services aren't allowed to share transport sockets, so
 		 * reject that here.  It is possible that the object is dying -
@@ -230,9 +226,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 			goto addr_in_use;
 		}
 
-		/* Found a match.  We replace a dying object.  Attempting to
-		 * bind the transport socket may still fail if we're attempting
-		 * to use a local address that the dying object is still using.
+		/* Found a match.  We want to replace a dying object.
+		 * Attempting to bind the transport socket may still fail if
+		 * we're attempting to use a local address that the dying
+		 * object is still using.
 		 */
 		if (!rxrpc_use_local(local))
 			break;
@@ -249,10 +246,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	if (ret < 0)
 		goto sock_error;
 
-	if (cursor != &rxnet->local_endpoints)
-		list_replace_init(cursor, &local->link);
-	else
-		list_add_tail(&local->link, cursor);
+	if (cursor) {
+		hlist_replace_rcu(cursor, &local->link);
+		cursor->pprev = NULL;
+	} else {
+		hlist_add_head_rcu(&local->link, &rxnet->local_endpoints);
+	}
 	age = "new";
 
 found:
@@ -393,7 +392,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	local->dead = true;
 
 	mutex_lock(&rxnet->local_mutex);
-	list_del_init(&local->link);
+	hlist_del_init_rcu(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 
 	rxrpc_clean_up_local_conns(local);
@@ -480,9 +479,9 @@ void rxrpc_destroy_all_locals(struct rxrpc_net *rxnet)
 
 	flush_workqueue(rxrpc_workqueue);
 
-	if (!list_empty(&rxnet->local_endpoints)) {
+	if (!hlist_empty(&rxnet->local_endpoints)) {
 		mutex_lock(&rxnet->local_mutex);
-		list_for_each_entry(local, &rxnet->local_endpoints, link) {
+		hlist_for_each_entry(local, &rxnet->local_endpoints, link) {
 			pr_err("AF_RXRPC: Leaked local %p {%d}\n",
 			       local, atomic_read(&local->usage));
 		}
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index cc7e30733feb..34f389975a7d 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -72,7 +72,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	timer_setup(&rxnet->client_conn_reap_timer,
 		    rxrpc_client_conn_reap_timeout, 0);
 
-	INIT_LIST_HEAD(&rxnet->local_endpoints);
+	INIT_HLIST_HEAD(&rxnet->local_endpoints);
 	mutex_init(&rxnet->local_mutex);
 
 	hash_init(rxnet->peer_hash);
@@ -98,6 +98,9 @@ static __net_init int rxrpc_init_net(struct net *net)
 	proc_create_net("peers", 0444, rxnet->proc_net,
 			&rxrpc_peer_seq_ops,
 			sizeof(struct seq_net_private));
+	proc_create_net("locals", 0444, rxnet->proc_net,
+			&rxrpc_local_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index e2f990754f88..8a8f776f91ae 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -334,3 +334,72 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 	.stop   = rxrpc_peer_seq_stop,
 	.show   = rxrpc_peer_seq_show,
 };
+
+/*
+ * Generate a list of extant virtual local endpoints in /proc/net/rxrpc/locals
+ */
+static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
+{
+	struct rxrpc_local *local;
+	char lbuff[50];
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq,
+			 "Proto Local                                          "
+			 " Use Act\n");
+		return 0;
+	}
+
+	local = hlist_entry(v, struct rxrpc_local, link);
+
+	sprintf(lbuff, "%pISpc", &local->srx.transport);
+
+	seq_printf(seq,
+		   "UDP   %-47.47s %3u %3u\n",
+		   lbuff,
+		   atomic_read(&local->usage),
+		   atomic_read(&local->active_users));
+
+	return 0;
+}
+
+static void *rxrpc_local_seq_start(struct seq_file *seq, loff_t *_pos)
+	__acquires(rcu)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+	unsigned int n;
+
+	rcu_read_lock();
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	n = *_pos;
+	if (n == 0)
+		return SEQ_START_TOKEN;
+
+	return seq_hlist_start_rcu(&rxnet->local_endpoints, n - 1);
+}
+
+static void *rxrpc_local_seq_next(struct seq_file *seq, void *v, loff_t *_pos)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	return seq_hlist_next_rcu(v, &rxnet->local_endpoints, _pos);
+}
+
+static void rxrpc_local_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+const struct seq_operations rxrpc_local_seq_ops = {
+	.start  = rxrpc_local_seq_start,
+	.next   = rxrpc_local_seq_next,
+	.stop   = rxrpc_local_seq_stop,
+	.show   = rxrpc_local_seq_show,
+};
-- 
2.35.1



