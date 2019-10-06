Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E70CD757
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfJFR1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfJFR13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BCC2087E;
        Sun,  6 Oct 2019 17:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382848;
        bh=LUbM4ka2H8FG5xfdVBuMCQmSxKzeTM3Io58psCzNz80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Gb44CIX7sahPC2B17w/aDznIhyIfu/8UA/96XIJHEAvAMG+z9FXEzyJN1+UPl/z8
         NqwbcLBrKQAwfwb66iCeKlvZ4IF6QCMOMn/fU5WS83P/3WBtbS3ucMtch0ymh1jQcW
         z0vuy2BhEw9ts10DpP3TJsZOrUuFR3Iq9E0Ut2Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 62/68] tipc: fix unlimited bundling of small messages
Date:   Sun,  6 Oct 2019 19:21:38 +0200
Message-Id: <20191006171137.347001016@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit e95584a889e1902fdf1ded9712e2c3c3083baf96 ]

We have identified a problem with the "oversubscription" policy in the
link transmission code.

When small messages are transmitted, and the sending link has reached
the transmit window limit, those messages will be bundled and put into
the link backlog queue. However, bundles of data messages are counted
at the 'CRITICAL' level, so that the counter for that level, instead of
the counter for the real, bundled message's level is the one being
increased.
Subsequent, to-be-bundled data messages at non-CRITICAL levels continue
to be tested against the unchanged counter for their own level, while
contributing to an unrestrained increase at the CRITICAL backlog level.

This leaves a gap in congestion control algorithm for small messages
that can result in starvation for other users or a "real" CRITICAL
user. Even that eventually can lead to buffer exhaustion & link reset.

We fix this by keeping a 'target_bskb' buffer pointer at each levels,
then when bundling, we only bundle messages at the same importance
level only. This way, we know exactly how many slots a certain level
have occupied in the queue, so can manage level congestion accurately.

By bundling messages at the same level, we even have more benefits. Let
consider this:
- One socket sends 64-byte messages at the 'CRITICAL' level;
- Another sends 4096-byte messages at the 'LOW' level;

When a 64-byte message comes and is bundled the first time, we put the
overhead of message bundle to it (+ 40-byte header, data copy, etc.)
for later use, but the next message can be a 4096-byte one that cannot
be bundled to the previous one. This means the last bundle carries only
one payload message which is totally inefficient, as for the receiver
also! Later on, another 64-byte message comes, now we make a new bundle
and the same story repeats...

With the new bundling algorithm, this will not happen, the 64-byte
messages will be bundled together even when the 4096-byte message(s)
comes in between. However, if the 4096-byte messages are sent at the
same level i.e. 'CRITICAL', the bundling algorithm will again cause the
same overhead.

Also, the same will happen even with only one socket sending small
messages at a rate close to the link transmit's one, so that, when one
message is bundled, it's transmitted shortly. Then, another message
comes, a new bundle is created and so on...

We will solve this issue radically by another patch.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/link.c |   30 +++++++++++++++++++-----------
 net/tipc/msg.c  |    5 +----
 2 files changed, 20 insertions(+), 15 deletions(-)

--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -157,6 +157,7 @@ struct tipc_link {
 	struct {
 		u16 len;
 		u16 limit;
+		struct sk_buff *target_bskb;
 	} backlog[5];
 	u16 snd_nxt;
 	u16 last_retransm;
@@ -826,6 +827,8 @@ void link_prepare_wakeup(struct tipc_lin
 
 void tipc_link_reset(struct tipc_link *l)
 {
+	u32 imp;
+
 	l->peer_session = ANY_SESSION;
 	l->session++;
 	l->mtu = l->advertised_mtu;
@@ -833,11 +836,10 @@ void tipc_link_reset(struct tipc_link *l
 	__skb_queue_purge(&l->deferdq);
 	skb_queue_splice_init(&l->wakeupq, l->inputq);
 	__skb_queue_purge(&l->backlogq);
-	l->backlog[TIPC_LOW_IMPORTANCE].len = 0;
-	l->backlog[TIPC_MEDIUM_IMPORTANCE].len = 0;
-	l->backlog[TIPC_HIGH_IMPORTANCE].len = 0;
-	l->backlog[TIPC_CRITICAL_IMPORTANCE].len = 0;
-	l->backlog[TIPC_SYSTEM_IMPORTANCE].len = 0;
+	for (imp = 0; imp <= TIPC_SYSTEM_IMPORTANCE; imp++) {
+		l->backlog[imp].len = 0;
+		l->backlog[imp].target_bskb = NULL;
+	}
 	kfree_skb(l->reasm_buf);
 	kfree_skb(l->failover_reasm_skb);
 	l->reasm_buf = NULL;
@@ -876,7 +878,7 @@ int tipc_link_xmit(struct tipc_link *l,
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	struct sk_buff_head *transmq = &l->transmq;
 	struct sk_buff_head *backlogq = &l->backlogq;
-	struct sk_buff *skb, *_skb, *bskb;
+	struct sk_buff *skb, *_skb, **tskb;
 	int pkt_cnt = skb_queue_len(list);
 	int rc = 0;
 
@@ -922,19 +924,21 @@ int tipc_link_xmit(struct tipc_link *l,
 			seqno++;
 			continue;
 		}
-		if (tipc_msg_bundle(skb_peek_tail(backlogq), hdr, mtu)) {
+		tskb = &l->backlog[imp].target_bskb;
+		if (tipc_msg_bundle(*tskb, hdr, mtu)) {
 			kfree_skb(__skb_dequeue(list));
 			l->stats.sent_bundled++;
 			continue;
 		}
-		if (tipc_msg_make_bundle(&bskb, hdr, mtu, l->addr)) {
+		if (tipc_msg_make_bundle(tskb, hdr, mtu, l->addr)) {
 			kfree_skb(__skb_dequeue(list));
-			__skb_queue_tail(backlogq, bskb);
-			l->backlog[msg_importance(buf_msg(bskb))].len++;
+			__skb_queue_tail(backlogq, *tskb);
+			l->backlog[imp].len++;
 			l->stats.sent_bundled++;
 			l->stats.sent_bundles++;
 			continue;
 		}
+		l->backlog[imp].target_bskb = NULL;
 		l->backlog[imp].len += skb_queue_len(list);
 		skb_queue_splice_tail_init(list, backlogq);
 	}
@@ -949,6 +953,7 @@ void tipc_link_advance_backlog(struct ti
 	u16 seqno = l->snd_nxt;
 	u16 ack = l->rcv_nxt - 1;
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
+	u32 imp;
 
 	while (skb_queue_len(&l->transmq) < l->window) {
 		skb = skb_peek(&l->backlogq);
@@ -959,7 +964,10 @@ void tipc_link_advance_backlog(struct ti
 			break;
 		__skb_dequeue(&l->backlogq);
 		hdr = buf_msg(skb);
-		l->backlog[msg_importance(hdr)].len--;
+		imp = msg_importance(hdr);
+		l->backlog[imp].len--;
+		if (unlikely(skb == l->backlog[imp].target_bskb))
+			l->backlog[imp].target_bskb = NULL;
 		__skb_queue_tail(&l->transmq, skb);
 		__skb_queue_tail(xmitq, _skb);
 		TIPC_SKB_CB(skb)->ackers = l->ackers;
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -456,10 +456,7 @@ bool tipc_msg_make_bundle(struct sk_buff
 	bmsg = buf_msg(_skb);
 	tipc_msg_init(msg_prevnode(msg), bmsg, MSG_BUNDLER, 0,
 		      INT_H_SIZE, dnode);
-	if (msg_isdata(msg))
-		msg_set_importance(bmsg, TIPC_CRITICAL_IMPORTANCE);
-	else
-		msg_set_importance(bmsg, TIPC_SYSTEM_IMPORTANCE);
+	msg_set_importance(bmsg, msg_importance(msg));
 	msg_set_seqno(bmsg, msg_seqno(msg));
 	msg_set_ack(bmsg, msg_ack(msg));
 	msg_set_bcast_ack(bmsg, msg_bcast_ack(msg));


