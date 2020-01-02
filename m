Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C9F12EC48
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgABWRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgABWQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00069227BF;
        Thu,  2 Jan 2020 22:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003418;
        bh=/GNAuNFE5e987/ISVIjYsKkE1UFI+Kx0wFE1vVGjSA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uay4+HsLjWkVjZcBfMFFLdZxT7OK2ioOaUo58VS92fmPfkPVe7DxuKAk3d29znTTJ
         2siwinEvLnMB/Wt0jFDfB85znkxtgLGq7D8rckg+Lvuhw9yh3Fot7ykr0LHaAe1/jv
         UnQewgK7/0O2rMkjwvlUe5kVlLQTUbVxPyV7B/Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 153/191] net_sched: sch_fq: properly set sk->sk_pacing_status
Date:   Thu,  2 Jan 2020 23:07:15 +0100
Message-Id: <20200102215845.838130304@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bb3d0b8bf5be61ab1d6f472c43cbf34de17e796b ]

If fq_classify() recycles a struct fq_flow because
a socket structure has been reallocated, we do not
set sk->sk_pacing_status immediately, but later if the
flow becomes detached.

This means that any flow requiring pacing (BBR, or SO_MAX_PACING_RATE)
might fallback to TCP internal pacing, which requires a per-socket
high resolution timer, and therefore more cpu cycles.

Fixes: 218af599fa63 ("tcp: internal implementation for pacing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -301,6 +301,9 @@ static struct fq_flow *fq_classify(struc
 				     f->socket_hash != sk->sk_hash)) {
 				f->credit = q->initial_quantum;
 				f->socket_hash = sk->sk_hash;
+				if (q->rate_enable)
+					smp_store_release(&sk->sk_pacing_status,
+							  SK_PACING_FQ);
 				if (fq_flow_is_throttled(f))
 					fq_flow_unset_throttled(q, f);
 				f->time_next_packet = 0ULL;
@@ -322,8 +325,12 @@ static struct fq_flow *fq_classify(struc
 
 	fq_flow_set_detached(f);
 	f->sk = sk;
-	if (skb->sk == sk)
+	if (skb->sk == sk) {
 		f->socket_hash = sk->sk_hash;
+		if (q->rate_enable)
+			smp_store_release(&sk->sk_pacing_status,
+					  SK_PACING_FQ);
+	}
 	f->credit = q->initial_quantum;
 
 	rb_link_node(&f->fq_node, parent, p);
@@ -428,17 +435,9 @@ static int fq_enqueue(struct sk_buff *sk
 	f->qlen++;
 	qdisc_qstats_backlog_inc(sch, skb);
 	if (fq_flow_is_detached(f)) {
-		struct sock *sk = skb->sk;
-
 		fq_flow_add_tail(&q->new_flows, f);
 		if (time_after(jiffies, f->age + q->flow_refill_delay))
 			f->credit = max_t(u32, f->credit, q->quantum);
-		if (sk && q->rate_enable) {
-			if (unlikely(smp_load_acquire(&sk->sk_pacing_status) !=
-				     SK_PACING_FQ))
-				smp_store_release(&sk->sk_pacing_status,
-						  SK_PACING_FQ);
-		}
 		q->inactive_flows--;
 	}
 


