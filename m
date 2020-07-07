Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04FD217255
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgGGPbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729905AbgGGPWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8520020773;
        Tue,  7 Jul 2020 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135365;
        bh=j2dSI6RXAkFUtf8d8kOUZofhmrUZPF86ouoaVN6w8T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=So+2h/zIKC0GeKMqvNugyAdS57bw679JcJ7syK/x+gBNQOU/Fb1/FvoyInph39kck
         vM/XDhWYgXkvYJT5m6TbGsrrjeTafGXNnd7Hgu77GW/LZPmm6CsGkYXiiG1D7VawgC
         OnzpUoHYv+vpw9q33uYrrs3naAoj14vmGqoiBWwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 012/112] tipc: add test for Nagle algorithm effectiveness
Date:   Tue,  7 Jul 2020 17:16:17 +0200
Message-Id: <20200707145801.580241478@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 0a3e060f340dbe232ffa290c40f879b7f7db595b ]

When streaming in Nagle mode, we try to bundle small messages from user
as many as possible if there is one outstanding buffer, i.e. not ACK-ed
by the receiving side, which helps boost up the overall throughput. So,
the algorithm's effectiveness really depends on when Nagle ACK comes or
what the specific network latency (RTT) is, compared to the user's
message sending rate.

In a bad case, the user's sending rate is low or the network latency is
small, there will not be many bundles, so making a Nagle ACK or waiting
for it is not meaningful.
For example: a user sends its messages every 100ms and the RTT is 50ms,
then for each messages, we require one Nagle ACK but then there is only
one user message sent without any bundles.

In a better case, even if we have a few bundles (e.g. the RTT = 300ms),
but now the user sends messages in medium size, then there will not be
any difference at all, that says 3 x 1000-byte data messages if bundled
will still result in 3 bundles with MTU = 1500.

When Nagle is ineffective, the delay in user message sending is clearly
wasted instead of sending directly.

Besides, adding Nagle ACKs will consume some processor load on both the
sending and receiving sides.

This commit adds a test on the effectiveness of the Nagle algorithm for
an individual connection in the network on which it actually runs.
Particularly, upon receipt of a Nagle ACK we will compare the number of
bundles in the backlog queue to the number of user messages which would
be sent directly without Nagle. If the ratio is good (e.g. >= 2), Nagle
mode will be kept for further message sending. Otherwise, we will leave
Nagle and put a 'penalty' on the connection, so it will have to spend
more 'one-way' messages before being able to re-enter Nagle.

In addition, the 'ack-required' bit is only set when really needed that
the number of Nagle ACKs will be reduced during Nagle mode.

Testing with benchmark showed that with the patch, there was not much
difference in throughput for small messages since the tool continuously
sends messages without a break, so Nagle would still take in effect.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c    |  3 ---
 net/tipc/msg.h    | 14 +++++++++--
 net/tipc/socket.c | 64 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 3ad411884e6c0..93966321f8929 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -235,9 +235,6 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 			msg_set_size(hdr, MIN_H_SIZE);
 			__skb_queue_tail(txq, skb);
 			total += 1;
-			if (prev)
-				msg_set_ack_required(buf_msg(prev), 0);
-			msg_set_ack_required(hdr, 1);
 		}
 		hdr = buf_msg(skb);
 		curr = msg_blocks(hdr);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 871feadbbc191..a4e2029170b1b 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -321,9 +321,19 @@ static inline int msg_ack_required(struct tipc_msg *m)
 	return msg_bits(m, 0, 18, 1);
 }
 
-static inline void msg_set_ack_required(struct tipc_msg *m, u32 d)
+static inline void msg_set_ack_required(struct tipc_msg *m)
 {
-	msg_set_bits(m, 0, 18, 1, d);
+	msg_set_bits(m, 0, 18, 1, 1);
+}
+
+static inline int msg_nagle_ack(struct tipc_msg *m)
+{
+	return msg_bits(m, 0, 18, 1);
+}
+
+static inline void msg_set_nagle_ack(struct tipc_msg *m)
+{
+	msg_set_bits(m, 0, 18, 1, 1);
 }
 
 static inline bool msg_is_rcast(struct tipc_msg *m)
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e370ad0edd768..d6b67d07d22ec 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -48,6 +48,8 @@
 #include "group.h"
 #include "trace.h"
 
+#define NAGLE_START_INIT	4
+#define NAGLE_START_MAX		1024
 #define CONN_TIMEOUT_DEFAULT    8000    /* default connect timeout = 8s */
 #define CONN_PROBING_INTV	msecs_to_jiffies(3600000)  /* [ms] => 1 h */
 #define TIPC_FWD_MSG		1
@@ -119,7 +121,10 @@ struct tipc_sock {
 	struct rcu_head rcu;
 	struct tipc_group *group;
 	u32 oneway;
+	u32 nagle_start;
 	u16 snd_backlog;
+	u16 msg_acc;
+	u16 pkt_cnt;
 	bool expect_ack;
 	bool nodelay;
 	bool group_is_open;
@@ -143,7 +148,7 @@ static int tipc_sk_insert(struct tipc_sock *tsk);
 static void tipc_sk_remove(struct tipc_sock *tsk);
 static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
 static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
-static void tipc_sk_push_backlog(struct tipc_sock *tsk);
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
 
 static const struct proto_ops packet_ops;
 static const struct proto_ops stream_ops;
@@ -474,6 +479,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	tsk = tipc_sk(sk);
 	tsk->max_pkt = MAX_PKT_DEFAULT;
 	tsk->maxnagle = 0;
+	tsk->nagle_start = NAGLE_START_INIT;
 	INIT_LIST_HEAD(&tsk->publications);
 	INIT_LIST_HEAD(&tsk->cong_links);
 	msg = &tsk->phdr;
@@ -541,7 +547,7 @@ static void __tipc_shutdown(struct socket *sock, int error)
 					    !tsk_conn_cong(tsk)));
 
 	/* Push out delayed messages if in Nagle mode */
-	tipc_sk_push_backlog(tsk);
+	tipc_sk_push_backlog(tsk, false);
 	/* Remove pending SYN */
 	__skb_queue_purge(&sk->sk_write_queue);
 
@@ -1252,14 +1258,37 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
  *                         when socket is in Nagle mode
  */
-static void tipc_sk_push_backlog(struct tipc_sock *tsk)
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
 {
 	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
+	struct sk_buff *skb = skb_peek_tail(txq);
 	struct net *net = sock_net(&tsk->sk);
 	u32 dnode = tsk_peer_node(tsk);
-	struct sk_buff *skb = skb_peek(txq);
 	int rc;
 
+	if (nagle_ack) {
+		tsk->pkt_cnt += skb_queue_len(txq);
+		if (!tsk->pkt_cnt || tsk->msg_acc / tsk->pkt_cnt < 2) {
+			tsk->oneway = 0;
+			if (tsk->nagle_start < NAGLE_START_MAX)
+				tsk->nagle_start *= 2;
+			tsk->expect_ack = false;
+			pr_debug("tsk %10u: bad nagle %u -> %u, next start %u!\n",
+				 tsk->portid, tsk->msg_acc, tsk->pkt_cnt,
+				 tsk->nagle_start);
+		} else {
+			tsk->nagle_start = NAGLE_START_INIT;
+			if (skb) {
+				msg_set_ack_required(buf_msg(skb));
+				tsk->expect_ack = true;
+			} else {
+				tsk->expect_ack = false;
+			}
+		}
+		tsk->msg_acc = 0;
+		tsk->pkt_cnt = 0;
+	}
+
 	if (!skb || tsk->cong_link_cnt)
 		return;
 
@@ -1267,9 +1296,10 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk)
 	if (msg_is_syn(buf_msg(skb)))
 		return;
 
+	if (tsk->msg_acc)
+		tsk->pkt_cnt += skb_queue_len(txq);
 	tsk->snt_unacked += tsk->snd_backlog;
 	tsk->snd_backlog = 0;
-	tsk->expect_ack = true;
 	rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
 	if (rc == -ELINKCONG)
 		tsk->cong_link_cnt = 1;
@@ -1322,8 +1352,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 		return;
 	} else if (mtyp == CONN_ACK) {
 		was_cong = tsk_conn_cong(tsk);
-		tsk->expect_ack = false;
-		tipc_sk_push_backlog(tsk);
+		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
 		tsk->snt_unacked -= msg_conn_ack(hdr);
 		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 			tsk->snd_win = msg_adv_win(hdr);
@@ -1516,6 +1545,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
+	struct sk_buff *skb;
 	u32 dnode = tsk_peer_node(tsk);
 	int maxnagle = tsk->maxnagle;
 	int maxpkt = tsk->max_pkt;
@@ -1544,17 +1574,25 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 			break;
 		send = min_t(size_t, dlen - sent, TIPC_MAX_USER_MSG_SIZE);
 		blocks = tsk->snd_backlog;
-		if (tsk->oneway++ >= 4 && send <= maxnagle) {
+		if (tsk->oneway++ >= tsk->nagle_start && send <= maxnagle) {
 			rc = tipc_msg_append(hdr, m, send, maxnagle, txq);
 			if (unlikely(rc < 0))
 				break;
 			blocks += rc;
+			tsk->msg_acc++;
 			if (blocks <= 64 && tsk->expect_ack) {
 				tsk->snd_backlog = blocks;
 				sent += send;
 				break;
+			} else if (blocks > 64) {
+				tsk->pkt_cnt += skb_queue_len(txq);
+			} else {
+				skb = skb_peek_tail(txq);
+				msg_set_ack_required(buf_msg(skb));
+				tsk->expect_ack = true;
+				tsk->msg_acc = 0;
+				tsk->pkt_cnt = 0;
 			}
-			tsk->expect_ack = true;
 		} else {
 			rc = tipc_msg_build(hdr, m, sent, send, maxpkt, txq);
 			if (unlikely(rc != send))
@@ -2091,7 +2129,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
 		smp_wmb();
 		tsk->cong_link_cnt--;
 		wakeup = true;
-		tipc_sk_push_backlog(tsk);
+		tipc_sk_push_backlog(tsk, false);
 		break;
 	case GROUP_PROTOCOL:
 		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
@@ -2180,7 +2218,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 		return false;
 	case TIPC_ESTABLISHED:
 		if (!skb_queue_empty(&sk->sk_write_queue))
-			tipc_sk_push_backlog(tsk);
+			tipc_sk_push_backlog(tsk, false);
 		/* Accept only connection-based messages sent by peer */
 		if (likely(con_msg && !err && pport == oport &&
 			   pnode == onode)) {
@@ -2188,8 +2226,10 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 				struct sk_buff *skb;
 
 				skb = tipc_sk_build_ack(tsk);
-				if (skb)
+				if (skb) {
+					msg_set_nagle_ack(buf_msg(skb));
 					__skb_queue_tail(xmitq, skb);
+				}
 			}
 			return true;
 		}
-- 
2.25.1



