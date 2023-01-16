Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48866C97A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbjAPQt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjAPQte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:49:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D5A2B616
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03B3561083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CAEC43396;
        Mon, 16 Jan 2023 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886979;
        bh=kCvNnYVPxdT4AgurtmL9YB8yHtcMrPvDBaTBjRIuXfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6Zx9C9G+DlJXGe8/5/misYODoVV+NannGkps6VLdbeN0ztoDrwNat+Ot4/M70W9S
         dB9x5n32Bj9evC8SorvyF1sQoieFRUT6xkIdclOdsUzFYQE6TN80fegyflihIsC9z/
         jfeAs+OxOg3UjqM/gU7qk5J5BxQlSmNhH0PhvpgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Maloy <jon.maloy@ericsson.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 634/658] tipc: improve throughput between nodes in netns
Date:   Mon, 16 Jan 2023 16:52:02 +0100
Message-Id: <20230116154938.494903817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit f73b12812a3d1d798b7517547ccdcf864844d2cd ]

Currently, TIPC transports intra-node user data messages directly
socket to socket, hence shortcutting all the lower layers of the
communication stack. This gives TIPC very good intra node performance,
both regarding throughput and latency.

We now introduce a similar mechanism for TIPC data traffic across
network namespaces located in the same kernel. On the send path, the
call chain is as always accompanied by the sending node's network name
space pointer. However, once we have reliably established that the
receiving node is represented by a namespace on the same host, we just
replace the namespace pointer with the receiving node/namespace's
ditto, and follow the regular socket receive patch though the receiving
node. This technique gives us a throughput similar to the node internal
throughput, several times larger than if we let the traffic go though
the full network stacks. As a comparison, max throughput for 64k
messages is four times larger than TCP throughput for the same type of
traffic.

To meet any security concerns, the following should be noted.

- All nodes joining a cluster are supposed to have been be certified
and authenticated by mechanisms outside TIPC. This is no different for
nodes/namespaces on the same host; they have to auto discover each
other using the attached interfaces, and establish links which are
supervised via the regular link monitoring mechanism. Hence, a kernel
local node has no other way to join a cluster than any other node, and
have to obey to policies set in the IP or device layers of the stack.

- Only when a sender has established with 100% certainty that the peer
node is located in a kernel local namespace does it choose to let user
data messages, and only those, take the crossover path to the receiving
node/namespace.

- If the receiving node/namespace is removed, its namespace pointer
is invalidated at all peer nodes, and their neighbor link monitoring
will eventually note that this node is gone.

- To ensure the "100% certainty" criteria, and prevent any possible
spoofing, received discovery messages must contain a proof that the
sender knows a common secret. We use the hash mix of the sending
node/namespace for this purpose, since it can be accessed directly by
all other namespaces in the kernel. Upon reception of a discovery
message, the receiver checks this proof against all the local
namespaces'hash_mix:es. If it finds a match, that, along with a
matching node id and cluster id, this is deemed sufficient proof that
the peer node in question is in a local namespace, and a wormhole can
be opened.

- We should also consider that TIPC is intended to be a cluster local
IPC mechanism (just like e.g. UNIX sockets) rather than a network
protocol, and hence we think it can justified to allow it to shortcut the
lower protocol layers.

Regarding traceability, we should notice that since commit 6c9081a3915d
("tipc: add loopback device tracking") it is possible to follow the node
internal packet flow by just activating tcpdump on the loopback
interface. This will be true even for this mechanism; by activating
tcpdump on the involved nodes' loopback interfaces their inter-name
space messaging can easily be tracked.

v2:
- update 'net' pointer when node left/rejoined
v3:
- grab read/write lock when using node ref obj
v4:
- clone traffics between netns to loopback

Suggested-by: Jon Maloy <jon.maloy@ericsson.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c244c092f1ed ("tipc: fix unexpected link reset due to discovery messages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/core.c       |  16 +++++
 net/tipc/core.h       |   6 ++
 net/tipc/discover.c   |   4 +-
 net/tipc/msg.h        |  14 ++++
 net/tipc/name_distr.c |   2 +-
 net/tipc/node.c       | 155 ++++++++++++++++++++++++++++++++++++++++--
 net/tipc/node.h       |   5 +-
 net/tipc/socket.c     |   6 +-
 8 files changed, 197 insertions(+), 11 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 90cf7e0bbaf0..58ee5ee70781 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -112,6 +112,15 @@ static void __net_exit tipc_exit_net(struct net *net)
 		cond_resched();
 }
 
+static void __net_exit tipc_pernet_pre_exit(struct net *net)
+{
+	tipc_node_pre_cleanup_net(net);
+}
+
+static struct pernet_operations tipc_pernet_pre_exit_ops = {
+	.pre_exit = tipc_pernet_pre_exit,
+};
+
 static struct pernet_operations tipc_net_ops = {
 	.init = tipc_init_net,
 	.exit = tipc_exit_net,
@@ -150,6 +159,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_pernet_topsrv;
 
+	err = register_pernet_subsys(&tipc_pernet_pre_exit_ops);
+	if (err)
+		goto out_register_pernet_subsys;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -170,6 +183,8 @@ static int __init tipc_init(void)
 out_netlink:
 	tipc_bearer_cleanup();
 out_bearer:
+	unregister_pernet_subsys(&tipc_pernet_pre_exit_ops);
+out_register_pernet_subsys:
 	unregister_pernet_device(&tipc_topsrv_net_ops);
 out_pernet_topsrv:
 	tipc_socket_stop();
@@ -187,6 +202,7 @@ static void __exit tipc_exit(void)
 	tipc_netlink_compat_stop();
 	tipc_netlink_stop();
 	tipc_bearer_cleanup();
+	unregister_pernet_subsys(&tipc_pernet_pre_exit_ops);
 	unregister_pernet_device(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
 	unregister_pernet_device(&tipc_net_ops);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index c6bda91f8581..59f97ef12e60 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -59,6 +59,7 @@
 #include <net/netns/generic.h>
 #include <linux/rhashtable.h>
 #include <net/genetlink.h>
+#include <net/netns/hash.h>
 
 #ifdef pr_fmt
 #undef pr_fmt
@@ -202,6 +203,11 @@ static inline int in_range(u16 val, u16 min, u16 max)
 	return !less(val, min) && !more(val, max);
 }
 
+static inline u32 tipc_net_hash_mixes(struct net *net, int tn_rand)
+{
+	return net_hash_mix(&init_net) ^ net_hash_mix(net) ^ tn_rand;
+}
+
 #ifdef CONFIG_SYSCTL
 int tipc_register_sysctl(void);
 void tipc_unregister_sysctl(void);
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 0436c8f2967d..61b80de93489 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -94,6 +94,7 @@ static void tipc_disc_init_msg(struct net *net, struct sk_buff *skb,
 	msg_set_dest_domain(hdr, dest_domain);
 	msg_set_bc_netid(hdr, tn->net_id);
 	b->media->addr2msg(msg_media_addr(hdr), &b->addr);
+	msg_set_peer_net_hash(hdr, tipc_net_hash_mixes(net, tn->random));
 	msg_set_node_id(hdr, tipc_own_id(net));
 }
 
@@ -245,7 +246,8 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 	if (!tipc_in_scope(legacy, b->domain, src))
 		return;
 	tipc_node_check_dest(net, src, peer_id, b, caps, signature,
-			     &maddr, &respond, &dupl_addr);
+			     msg_peer_net_hash(hdr), &maddr, &respond,
+			     &dupl_addr);
 	if (dupl_addr)
 		disc_dupl_alert(b, src, &maddr);
 	if (!respond)
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 0daa6f04ca81..2d7cb66a6912 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -1026,6 +1026,20 @@ static inline bool msg_is_reset(struct tipc_msg *hdr)
 	return (msg_user(hdr) == LINK_PROTOCOL) && (msg_type(hdr) == RESET_MSG);
 }
 
+/* Word 13
+ */
+static inline void msg_set_peer_net_hash(struct tipc_msg *m, u32 n)
+{
+	msg_set_word(m, 13, n);
+}
+
+static inline u32 msg_peer_net_hash(struct tipc_msg *m)
+{
+	return msg_word(m, 13);
+}
+
+/* Word 14
+ */
 static inline u32 msg_sugg_node_addr(struct tipc_msg *m)
 {
 	return msg_word(m, 14);
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 661bc2551a0a..6ac84e7c8b63 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -146,7 +146,7 @@ static void named_distribute(struct net *net, struct sk_buff_head *list,
 	struct publication *publ;
 	struct sk_buff *skb = NULL;
 	struct distr_item *item = NULL;
-	u32 msg_dsz = ((tipc_node_get_mtu(net, dnode, 0) - INT_H_SIZE) /
+	u32 msg_dsz = ((tipc_node_get_mtu(net, dnode, 0, false) - INT_H_SIZE) /
 			ITEM_SIZE) * ITEM_SIZE;
 	u32 msg_rem = msg_dsz;
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index c8f6177dd5a2..3136e2a777fd 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -126,6 +126,8 @@ struct tipc_node {
 	struct timer_list timer;
 	struct rcu_head rcu;
 	unsigned long delete_at;
+	struct net *peer_net;
+	u32 peer_hash_mix;
 };
 
 /* Node FSM states and events:
@@ -184,7 +186,7 @@ static struct tipc_link *node_active_link(struct tipc_node *n, int sel)
 	return n->links[bearer_id].link;
 }
 
-int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel)
+int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel, bool connected)
 {
 	struct tipc_node *n;
 	int bearer_id;
@@ -194,6 +196,14 @@ int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel)
 	if (unlikely(!n))
 		return mtu;
 
+	/* Allow MAX_MSG_SIZE when building connection oriented message
+	 * if they are in the same core network
+	 */
+	if (n->peer_net && connected) {
+		tipc_node_put(n);
+		return mtu;
+	}
+
 	bearer_id = n->active_links[sel & 1];
 	if (likely(bearer_id != INVALID_BEARER_ID))
 		mtu = n->links[bearer_id].mtu;
@@ -360,8 +370,37 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	}
 }
 
+static void tipc_node_assign_peer_net(struct tipc_node *n, u32 hash_mixes)
+{
+	int net_id = tipc_netid(n->net);
+	struct tipc_net *tn_peer;
+	struct net *tmp;
+	u32 hash_chk;
+
+	if (n->peer_net)
+		return;
+
+	for_each_net_rcu(tmp) {
+		tn_peer = tipc_net(tmp);
+		if (!tn_peer)
+			continue;
+		/* Integrity checking whether node exists in namespace or not */
+		if (tn_peer->net_id != net_id)
+			continue;
+		if (memcmp(n->peer_id, tn_peer->node_id, NODE_ID_LEN))
+			continue;
+		hash_chk = tipc_net_hash_mixes(tmp, tn_peer->random);
+		if (hash_mixes ^ hash_chk)
+			continue;
+		n->peer_net = tmp;
+		n->peer_hash_mix = hash_mixes;
+		break;
+	}
+}
+
 static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
-					  u8 *peer_id, u16 capabilities)
+					  u8 *peer_id, u16 capabilities,
+					  u32 signature, u32 hash_mixes)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_node *n, *temp_node;
@@ -372,6 +411,8 @@ static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 	spin_lock_bh(&tn->node_list_lock);
 	n = tipc_node_find(net, addr);
 	if (n) {
+		if (n->peer_hash_mix ^ hash_mixes)
+			tipc_node_assign_peer_net(n, hash_mixes);
 		if (n->capabilities == capabilities)
 			goto exit;
 		/* Same node may come back with new capabilities */
@@ -389,6 +430,7 @@ static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 		list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
 			tn->capabilities &= temp_node->capabilities;
 		}
+
 		goto exit;
 	}
 	n = kzalloc(sizeof(*n), GFP_ATOMIC);
@@ -399,6 +441,10 @@ static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 	n->addr = addr;
 	memcpy(&n->peer_id, peer_id, 16);
 	n->net = net;
+	n->peer_net = NULL;
+	n->peer_hash_mix = 0;
+	/* Assign kernel local namespace if exists */
+	tipc_node_assign_peer_net(n, hash_mixes);
 	n->capabilities = capabilities;
 	kref_init(&n->kref);
 	rwlock_init(&n->lock);
@@ -426,6 +472,10 @@ static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 				 tipc_bc_sndlink(net),
 				 &n->bc_entry.link)) {
 		pr_warn("Broadcast rcv link creation failed, no memory\n");
+		if (n->peer_net) {
+			n->peer_net = NULL;
+			n->peer_hash_mix = 0;
+		}
 		kfree(n);
 		n = NULL;
 		goto exit;
@@ -979,7 +1029,7 @@ u32 tipc_node_try_addr(struct net *net, u8 *id, u32 addr)
 
 void tipc_node_check_dest(struct net *net, u32 addr,
 			  u8 *peer_id, struct tipc_bearer *b,
-			  u16 capabilities, u32 signature,
+			  u16 capabilities, u32 signature, u32 hash_mixes,
 			  struct tipc_media_addr *maddr,
 			  bool *respond, bool *dupl_addr)
 {
@@ -998,7 +1048,8 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	*dupl_addr = false;
 	*respond = false;
 
-	n = tipc_node_create(net, addr, peer_id, capabilities);
+	n = tipc_node_create(net, addr, peer_id, capabilities, signature,
+			     hash_mixes);
 	if (!n)
 		return;
 
@@ -1343,6 +1394,10 @@ static void node_lost_contact(struct tipc_node *n,
 	/* Notify publications from this node */
 	n->action_flags |= TIPC_NOTIFY_NODE_DOWN;
 
+	if (n->peer_net) {
+		n->peer_net = NULL;
+		n->peer_hash_mix = 0;
+	}
 	/* Notify sockets connected to node */
 	list_for_each_entry_safe(conn, safe, conns, list) {
 		skb = tipc_msg_create(TIPC_CRITICAL_IMPORTANCE, TIPC_CONN_MSG,
@@ -1424,6 +1479,56 @@ static int __tipc_nl_add_node(struct tipc_nl_msg *msg, struct tipc_node *node)
 	return -EMSGSIZE;
 }
 
+static void tipc_lxc_xmit(struct net *peer_net, struct sk_buff_head *list)
+{
+	struct tipc_msg *hdr = buf_msg(skb_peek(list));
+	struct sk_buff_head inputq;
+
+	switch (msg_user(hdr)) {
+	case TIPC_LOW_IMPORTANCE:
+	case TIPC_MEDIUM_IMPORTANCE:
+	case TIPC_HIGH_IMPORTANCE:
+	case TIPC_CRITICAL_IMPORTANCE:
+		if (msg_connected(hdr) || msg_named(hdr)) {
+			tipc_loopback_trace(peer_net, list);
+			spin_lock_init(&list->lock);
+			tipc_sk_rcv(peer_net, list);
+			return;
+		}
+		if (msg_mcast(hdr)) {
+			tipc_loopback_trace(peer_net, list);
+			skb_queue_head_init(&inputq);
+			tipc_sk_mcast_rcv(peer_net, list, &inputq);
+			__skb_queue_purge(list);
+			skb_queue_purge(&inputq);
+			return;
+		}
+		return;
+	case MSG_FRAGMENTER:
+		if (tipc_msg_assemble(list)) {
+			tipc_loopback_trace(peer_net, list);
+			skb_queue_head_init(&inputq);
+			tipc_sk_mcast_rcv(peer_net, list, &inputq);
+			__skb_queue_purge(list);
+			skb_queue_purge(&inputq);
+		}
+		return;
+	case GROUP_PROTOCOL:
+	case CONN_MANAGER:
+		tipc_loopback_trace(peer_net, list);
+		spin_lock_init(&list->lock);
+		tipc_sk_rcv(peer_net, list);
+		return;
+	case LINK_PROTOCOL:
+	case NAME_DISTRIBUTOR:
+	case TUNNEL_PROTOCOL:
+	case BCAST_PROTOCOL:
+		return;
+	default:
+		return;
+	};
+}
+
 /**
  * tipc_node_xmit() is the general link level function for message sending
  * @net: the applicable net namespace
@@ -1439,6 +1544,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	struct tipc_link_entry *le = NULL;
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
+	bool node_up = false;
 	int bearer_id;
 	int rc;
 
@@ -1456,6 +1562,17 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	}
 
 	tipc_node_read_lock(n);
+	node_up = node_is_up(n);
+	if (node_up && n->peer_net && check_net(n->peer_net)) {
+		/* xmit inner linux container */
+		tipc_lxc_xmit(n->peer_net, list);
+		if (likely(skb_queue_empty(list))) {
+			tipc_node_read_unlock(n);
+			tipc_node_put(n);
+			return 0;
+		}
+	}
+
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
@@ -2591,3 +2708,33 @@ int tipc_node_dump(struct tipc_node *n, bool more, char *buf)
 
 	return i;
 }
+
+void tipc_node_pre_cleanup_net(struct net *exit_net)
+{
+	struct tipc_node *n;
+	struct tipc_net *tn;
+	struct net *tmp;
+
+	rcu_read_lock();
+	for_each_net_rcu(tmp) {
+		if (tmp == exit_net)
+			continue;
+		tn = tipc_net(tmp);
+		if (!tn)
+			continue;
+		spin_lock_bh(&tn->node_list_lock);
+		list_for_each_entry_rcu(n, &tn->node_list, list) {
+			if (!n->peer_net)
+				continue;
+			if (n->peer_net != exit_net)
+				continue;
+			tipc_node_write_lock(n);
+			n->peer_net = NULL;
+			n->peer_hash_mix = 0;
+			tipc_node_write_unlock_fast(n);
+			break;
+		}
+		spin_unlock_bh(&tn->node_list_lock);
+	}
+	rcu_read_unlock();
+}
diff --git a/net/tipc/node.h b/net/tipc/node.h
index 291d0ecd4101..30563c4f35d5 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -75,7 +75,7 @@ u32 tipc_node_get_addr(struct tipc_node *node);
 u32 tipc_node_try_addr(struct net *net, u8 *id, u32 addr);
 void tipc_node_check_dest(struct net *net, u32 onode, u8 *peer_id128,
 			  struct tipc_bearer *bearer,
-			  u16 capabilities, u32 signature,
+			  u16 capabilities, u32 signature, u32 hash_mixes,
 			  struct tipc_media_addr *maddr,
 			  bool *respond, bool *dupl_addr);
 void tipc_node_delete_links(struct net *net, int bearer_id);
@@ -92,7 +92,7 @@ void tipc_node_unsubscribe(struct net *net, struct list_head *subscr, u32 addr);
 void tipc_node_broadcast(struct net *net, struct sk_buff *skb);
 int tipc_node_add_conn(struct net *net, u32 dnode, u32 port, u32 peer_port);
 void tipc_node_remove_conn(struct net *net, u32 dnode, u32 port);
-int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel);
+int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel, bool connected);
 bool tipc_node_is_up(struct net *net, u32 addr);
 u16 tipc_node_get_capabilities(struct net *net, u32 addr);
 int tipc_nl_node_dump(struct sk_buff *skb, struct netlink_callback *cb);
@@ -107,4 +107,5 @@ int tipc_nl_node_get_monitor(struct sk_buff *skb, struct genl_info *info);
 int tipc_nl_node_dump_monitor(struct sk_buff *skb, struct netlink_callback *cb);
 int tipc_nl_node_dump_monitor_peer(struct sk_buff *skb,
 				   struct netlink_callback *cb);
+void tipc_node_pre_cleanup_net(struct net *exit_net);
 #endif
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 58c4d61d603f..e1e148da538d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -866,7 +866,7 @@ static int tipc_send_group_msg(struct net *net, struct tipc_sock *tsk,
 
 	/* Build message as chain of buffers */
 	__skb_queue_head_init(&pkts);
-	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
+	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
@@ -1407,7 +1407,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	}
 
 	__skb_queue_head_init(&pkts);
-	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
+	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
@@ -1547,7 +1547,7 @@ static void tipc_sk_finish_conn(struct tipc_sock *tsk, u32 peer_port,
 	sk_reset_timer(sk, &sk->sk_timer, jiffies + CONN_PROBING_INTV);
 	tipc_set_sk_state(sk, TIPC_ESTABLISHED);
 	tipc_node_add_conn(net, peer_node, tsk->portid, peer_port);
-	tsk->max_pkt = tipc_node_get_mtu(net, peer_node, tsk->portid);
+	tsk->max_pkt = tipc_node_get_mtu(net, peer_node, tsk->portid, true);
 	tsk->peer_caps = tipc_node_get_capabilities(net, peer_node);
 	__skb_queue_purge(&sk->sk_write_queue);
 	if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
-- 
2.35.1



