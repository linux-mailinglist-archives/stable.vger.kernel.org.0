Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6937C639
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbhELPto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhELPnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782C861C87;
        Wed, 12 May 2021 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832940;
        bh=B8iCQtKl6f99ZMNU0dijVVsCODS4TsCPh+5smRLGkZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daQ9HbQ/HDNiW/wo/PURogG5YcdOCMr/jzQcKUDgeG5EWb34a1vER5nUxTRBY69mZ
         S9UqhOHKWVRt2ju5+XuQ83rypxksuytySBLFNEf+bpW34iFDeejmp7ln5BNW6JmMDU
         iN8uXDlRFo3xdrTl6FMoXk2lJvFL4tSY2A4NSDjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/530] net/packet: remove data races in fanout operations
Date:   Wed, 12 May 2021 16:49:19 +0200
Message-Id: <20210512144834.523524937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 94f633ea8ade8418634d152ad0931133338226f6 ]

af_packet fanout uses RCU rules to ensure f->arr elements
are not dismantled before RCU grace period.

However, it lacks rcu accessors to make sure KCSAN and other tools
wont detect data races. Stupid compilers could also play games.

Fixes: dc99f600698d ("packet: Add fanout support.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 15 +++++++++------
 net/packet/internal.h  |  2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 92501e5f9d49..449625c2ccc7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1358,7 +1358,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 	struct packet_sock *po, *po_next, *po_skip = NULL;
 	unsigned int i, j, room = ROOM_NONE;
 
-	po = pkt_sk(f->arr[idx]);
+	po = pkt_sk(rcu_dereference(f->arr[idx]));
 
 	if (try_self) {
 		room = packet_rcv_has_room(po, skb);
@@ -1370,7 +1370,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 
 	i = j = min_t(int, po->rollover->sock, num - 1);
 	do {
-		po_next = pkt_sk(f->arr[i]);
+		po_next = pkt_sk(rcu_dereference(f->arr[i]));
 		if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
 		    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
 			if (i != j)
@@ -1465,7 +1465,7 @@ static int packet_rcv_fanout(struct sk_buff *skb, struct net_device *dev,
 	if (fanout_has_flag(f, PACKET_FANOUT_FLAG_ROLLOVER))
 		idx = fanout_demux_rollover(f, skb, idx, true, num);
 
-	po = pkt_sk(f->arr[idx]);
+	po = pkt_sk(rcu_dereference(f->arr[idx]));
 	return po->prot_hook.func(skb, dev, &po->prot_hook, orig_dev);
 }
 
@@ -1479,7 +1479,7 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po)
 	struct packet_fanout *f = po->fanout;
 
 	spin_lock(&f->lock);
-	f->arr[f->num_members] = sk;
+	rcu_assign_pointer(f->arr[f->num_members], sk);
 	smp_wmb();
 	f->num_members++;
 	if (f->num_members == 1)
@@ -1494,11 +1494,14 @@ static void __fanout_unlink(struct sock *sk, struct packet_sock *po)
 
 	spin_lock(&f->lock);
 	for (i = 0; i < f->num_members; i++) {
-		if (f->arr[i] == sk)
+		if (rcu_dereference_protected(f->arr[i],
+					      lockdep_is_held(&f->lock)) == sk)
 			break;
 	}
 	BUG_ON(i >= f->num_members);
-	f->arr[i] = f->arr[f->num_members - 1];
+	rcu_assign_pointer(f->arr[i],
+			   rcu_dereference_protected(f->arr[f->num_members - 1],
+						     lockdep_is_held(&f->lock)));
 	f->num_members--;
 	if (f->num_members == 0)
 		__dev_remove_pack(&f->prot_hook);
diff --git a/net/packet/internal.h b/net/packet/internal.h
index baafc3f3fa25..7af1e9179385 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -94,7 +94,7 @@ struct packet_fanout {
 	spinlock_t		lock;
 	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
-	struct sock		*arr[];
+	struct sock	__rcu	*arr[];
 };
 
 struct packet_rollover {
-- 
2.30.2



