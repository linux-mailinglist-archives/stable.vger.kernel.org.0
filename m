Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02933147D70
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbgAXKAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:00:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgAXKAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:00:39 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF3920709;
        Fri, 24 Jan 2020 10:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860039;
        bh=hBIj/ENEPbPLis2iE9Mk5zEC30Jacme0nvEoZde/gHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOV1LgCHdZjPXARUcH/4uC8B9vgLfGM2xHB2p4etAycWAP/kxNQiv8Gp3JNoNt+Wp
         XNOl1HnC1KkfpJpuMmRGoJqhLK3OYumgnD7jlJijTGBFfDbNuPUJBlKPI7DoVf8qTD
         kzB64p0sMpxdHtG4jZhOoCwM3R7iXwarpjCsJlCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 237/343] net: netem: fix backlog accounting for corrupted GSO frames
Date:   Fri, 24 Jan 2020 10:30:55 +0100
Message-Id: <20200124092951.323856739@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 177b8007463c4f36c9a2c7ce7aa9875a4cad9bd5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 6266121a03f9a..ede0a24e67eb8 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -431,8 +431,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
 	struct sk_buff *segs = NULL;
-	unsigned int len = 0, last_len, prev_len = qdisc_pkt_len(skb);
-	int nb = 0;
+	unsigned int prev_len = qdisc_pkt_len(skb);
 	int count = 1;
 	int rc = NET_XMIT_SUCCESS;
 	int rc_drop = NET_XMIT_DROP;
@@ -489,6 +488,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			segs = netem_segment(skb, sch, to_free);
 			if (!segs)
 				return rc_drop;
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
 		} else {
 			segs = skb;
 		}
@@ -579,6 +579,11 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
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
@@ -594,9 +599,7 @@ finish_segs:
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
-- 
2.20.1



