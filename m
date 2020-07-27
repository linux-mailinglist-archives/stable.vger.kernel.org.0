Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E594622EEA3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgG0OJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729657AbgG0OJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E41A320838;
        Mon, 27 Jul 2020 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858971;
        bh=7GxXv2zT/X+wZk8mZDrsLKBo7LEPW+1pTpkbylMQ38I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAfCRcrTNbnxDr2ogi5AysLtfr/nkRSaHvNys4yKPzGAiOslDXn7ZIcdlPh+n37rH
         5Qq+gJBAR67ooNQpJqeJFbj0mBhyRo36SRSbq1KSz1a+Vg3xJpr1vDaUovRRZTjWKx
         tbLPVNaawilDEiJQlsgsyOyxV6JGdYfDw815FZTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 4.19 17/86] tipc: clean up skb list lock handling on send path
Date:   Mon, 27 Jul 2020 16:03:51 +0200
Message-Id: <20200727134915.215521925@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>

commit e654f9f53b45fde3fcc8051830b212c7a8f36148 upstream.

The policy for handling the skb list locks on the send and receive paths
is simple.

- On the send path we never need to grab the lock on the 'xmitq' list
  when the destination is an exernal node.

- On the receive path we always need to grab the lock on the 'inputq'
  list, irrespective of source node.

However, when transmitting node local messages those will eventually
end up on the receive path of a local socket, meaning that the argument
'xmitq' in tipc_node_xmit() will become the 'ínputq' argument in  the
function tipc_sk_rcv(). This has been handled by always initializing
the spinlock of the 'xmitq' list at message creation, just in case it
may end up on the receive path later, and despite knowing that the lock
in most cases never will be used.

This approach is inaccurate and confusing, and has also concealed the
fact that the stated 'no lock grabbing' policy for the send path is
violated in some cases.

We now clean up this by never initializing the lock at message creation,
instead doing this at the moment we find that the message actually will
enter the receive path. At the same time we fix the four locations
where we incorrectly access the spinlock on the send/error path.

This patch also reverts commit d12cffe9329f ("tipc: ensure head->lock
is initialised") which has now become redundant.

CC: Eric Dumazet <edumazet@google.com>
Reported-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[acj: backport v4.19 -stable
- adjust context
- skipped the hunk modifying non-existent function tipc_mcast_send_sync
- additional comment ]
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/bcast.c  |    8 ++++----
 net/tipc/group.c  |    4 ++--
 net/tipc/link.c   |   12 ++++++------
 net/tipc/node.c   |    7 ++++---
 net/tipc/socket.c |   12 ++++++------
 5 files changed, 22 insertions(+), 21 deletions(-)

--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -181,7 +181,7 @@ static void tipc_bcbase_xmit(struct net
 	}
 
 	/* We have to transmit across all bearers */
-	skb_queue_head_init(&_xmitq);
+	__skb_queue_head_init(&_xmitq);
 	for (bearer_id = 0; bearer_id < MAX_BEARERS; bearer_id++) {
 		if (!bb->dests[bearer_id])
 			continue;
@@ -237,7 +237,7 @@ static int tipc_bcast_xmit(struct net *n
 	struct sk_buff_head xmitq;
 	int rc = 0;
 
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	tipc_bcast_lock(net);
 	if (tipc_link_bc_peers(l))
 		rc = tipc_link_xmit(l, pkts, &xmitq);
@@ -267,7 +267,7 @@ static int tipc_rcast_xmit(struct net *n
 	u32 dnode, selector;
 
 	selector = msg_link_selector(buf_msg(skb_peek(pkts)));
-	skb_queue_head_init(&_pkts);
+	__skb_queue_head_init(&_pkts);
 
 	list_for_each_entry_safe(dst, tmp, &dests->list, list) {
 		dnode = dst->node;
@@ -299,7 +299,7 @@ int tipc_mcast_xmit(struct net *net, str
 	int rc = 0;
 
 	skb_queue_head_init(&inputq);
-	skb_queue_head_init(&localq);
+	__skb_queue_head_init(&localq);
 
 	/* Clone packets before they are consumed by next call */
 	if (dests->local && !tipc_msg_reassemble(pkts, &localq)) {
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -199,7 +199,7 @@ void tipc_group_join(struct net *net, st
 	struct tipc_member *m, *tmp;
 	struct sk_buff_head xmitq;
 
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
 		tipc_group_proto_xmit(grp, m, GRP_JOIN_MSG, &xmitq);
 		tipc_group_update_member(m, 0);
@@ -435,7 +435,7 @@ bool tipc_group_cong(struct tipc_group *
 		return true;
 	if (state == MBR_PENDING && adv == ADV_IDLE)
 		return true;
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	tipc_group_proto_xmit(grp, m, GRP_ADV_MSG, &xmitq);
 	tipc_node_distr_xmit(grp->net, &xmitq);
 	return true;
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -928,7 +928,7 @@ int tipc_link_xmit(struct tipc_link *l,
 	int rc = 0;
 
 	if (unlikely(msg_size(hdr) > mtu)) {
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EMSGSIZE;
 	}
 
@@ -957,7 +957,7 @@ int tipc_link_xmit(struct tipc_link *l,
 		if (likely(skb_queue_len(transmq) < maxwin)) {
 			_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!_skb) {
-				skb_queue_purge(list);
+				__skb_queue_purge(list);
 				return -ENOBUFS;
 			}
 			__skb_dequeue(list);
@@ -1429,7 +1429,7 @@ void tipc_link_create_dummy_tnl_msg(stru
 	struct sk_buff *skb;
 	u32 dnode = l->addr;
 
-	skb_queue_head_init(&tnlq);
+	__skb_queue_head_init(&tnlq);
 	skb = tipc_msg_create(TUNNEL_PROTOCOL, FAILOVER_MSG,
 			      INT_H_SIZE, BASIC_H_SIZE,
 			      dnode, onode, 0, 0, 0);
@@ -1465,8 +1465,8 @@ void tipc_link_tnl_prepare(struct tipc_l
 	if (!tnl)
 		return;
 
-	skb_queue_head_init(&tnlq);
-	skb_queue_head_init(&tmpxq);
+	__skb_queue_head_init(&tnlq);
+	__skb_queue_head_init(&tmpxq);
 
 	/* At least one packet required for safe algorithm => add dummy */
 	skb = tipc_msg_create(TIPC_LOW_IMPORTANCE, TIPC_DIRECT_MSG,
@@ -1476,7 +1476,7 @@ void tipc_link_tnl_prepare(struct tipc_l
 		pr_warn("%sunable to create tunnel packet\n", link_co_err);
 		return;
 	}
-	skb_queue_tail(&tnlq, skb);
+	__skb_queue_tail(&tnlq, skb);
 	tipc_link_xmit(l, &tnlq, &tmpxq);
 	__skb_queue_purge(&tmpxq);
 
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1368,13 +1368,14 @@ int tipc_node_xmit(struct net *net, stru
 	int rc;
 
 	if (in_own_node(net, dnode)) {
+		spin_lock_init(&list->lock);
 		tipc_sk_rcv(net, list);
 		return 0;
 	}
 
 	n = tipc_node_find(net, dnode);
 	if (unlikely(!n)) {
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EHOSTUNREACH;
 	}
 
@@ -1383,7 +1384,7 @@ int tipc_node_xmit(struct net *net, stru
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
 		tipc_node_put(n);
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EHOSTUNREACH;
 	}
 
@@ -1415,7 +1416,7 @@ int tipc_node_xmit_skb(struct net *net,
 {
 	struct sk_buff_head head;
 
-	skb_queue_head_init(&head);
+	__skb_queue_head_init(&head);
 	__skb_queue_tail(&head, skb);
 	tipc_node_xmit(net, &head, dnode, selector);
 	return 0;
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -800,7 +800,7 @@ static int tipc_sendmcast(struct  socket
 	msg_set_nameupper(hdr, seq->upper);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	rc = tipc_msg_build(hdr, msg, 0, dlen, mtu, &pkts);
 
 	/* Send message if build was successful */
@@ -841,7 +841,7 @@ static int tipc_send_group_msg(struct ne
 	msg_set_grp_bc_seqno(hdr, bc_snd_nxt);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
@@ -1046,7 +1046,7 @@ static int tipc_send_group_bcast(struct
 	msg_set_grp_bc_ack_req(hdr, ack);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
@@ -1372,7 +1372,7 @@ static int __tipc_sendmsg(struct socket
 	if (unlikely(rc))
 		return rc;
 
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
@@ -1427,7 +1427,7 @@ static int __tipc_sendstream(struct sock
 	int send, sent = 0;
 	int rc = 0;
 
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 
 	if (unlikely(dlen > INT_MAX))
 		return -EMSGSIZE;
@@ -1782,7 +1782,7 @@ static int tipc_recvmsg(struct socket *s
 
 	/* Send group flow control advertisement when applicable */
 	if (tsk->group && msg_in_group(hdr) && !grp_evt) {
-		skb_queue_head_init(&xmitq);
+		__skb_queue_head_init(&xmitq);
 		tipc_group_update_rcv_win(tsk->group, tsk_blocks(hlen + dlen),
 					  msg_orignode(hdr), msg_origport(hdr),
 					  &xmitq);


