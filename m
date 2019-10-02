Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4083EC918C
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfJBTJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:09:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35952 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729335AbfJBTIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-000364-Qb; Wed, 02 Oct 2019 20:08:15 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003fP-K9; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dirk van der Merwe" <dirk.vandermerwe@netronome.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.899326605@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 69/87] net: netem: fix backlog accounting for
 corrupted GSO frames
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <jakub.kicinski@netronome.com>

commit 177b8007463c4f36c9a2c7ce7aa9875a4cad9bd5 upstream.

When GSO frame has to be corrupted netem uses skb_gso_segment()
to produce the list of frames, and re-enqueues the segments one
by one.  The backlog length has to be adjusted to account for
new frames.

The current calculation is incorrect, leading to wrong backlog
lengths in the parent qdisc (both bytes and packets), and
incorrect packet backlog count in netem itself.

Parent backlog goes negative, netem's packet backlog counts
all non-first segments twice (thus remaining non-zero even
after qdisc is emptied).

Move the variables used to count the adjustment into local
scope to make 100% sure they aren't used at any stage in
backports.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_netem.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -440,8 +440,7 @@ static int netem_enqueue(struct sk_buff
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
 	struct sk_buff *segs = NULL;
-	unsigned int len = 0, last_len, prev_len = qdisc_pkt_len(skb);
-	int nb = 0;
+	unsigned int prev_len = qdisc_pkt_len(skb);
 	int count = 1;
 	int rc = NET_XMIT_SUCCESS;
 	int rc_drop = NET_XMIT_DROP;
@@ -495,6 +494,7 @@ static int netem_enqueue(struct sk_buff
 			segs = netem_segment(skb, sch);
 			if (!segs)
 				return rc_drop;
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
 		} else {
 			segs = skb;
 		}
@@ -575,6 +575,11 @@ static int netem_enqueue(struct sk_buff
 
 finish_segs:
 	if (segs) {
+		unsigned int len, last_len;
+		int nb = 0;
+
+		len = skb->len;
+
 		while (segs) {
 			skb2 = segs->next;
 			segs->next = NULL;
@@ -590,9 +595,7 @@ finish_segs:
 			}
 			segs = skb2;
 		}
-		sch->q.qlen += nb;
-		if (nb > 1)
-			qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
+		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
 	}
 	return NET_XMIT_SUCCESS;
 }

