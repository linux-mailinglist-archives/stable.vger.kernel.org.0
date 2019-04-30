Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96840F84B
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfD3Lkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbfD3Lkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB5E21734;
        Tue, 30 Apr 2019 11:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624441;
        bh=l29YY1Rymz3m8x+jhuKgXK4LbsFp8dBLSIzRwVLWfJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAgGokevZ0i1NGCOp7H7+rwJLRjPecTGL3J8WCOOWxs6cgVs7Dvi0IwyjAL5rAYUR
         2+/7QFOrvCpDE+RyIdv/Dmd2Zw1+96tyDJgaVY5iqeD4qDkUI8EHtPRkacMl+sxcaX
         xdJE/FsCbULIAEtCchO6/Lp0PtLApvljujMNAW38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 37/41] ipv6: frags: fix a lockdep false positive
Date:   Tue, 30 Apr 2019 13:38:48 +0200
Message-Id: <20190430113533.485703861@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 415787d7799f4fccbe8d49cb0b8e5811be6b0389 ]

lockdep does not know that the locks used by IPv4 defrag
and IPv6 reassembly units are of different classes.

It complains because of following chains :

1) sch_direct_xmit()        (lock txq->_xmit_lock)
    dev_hard_start_xmit()
     xmit_one()
      dev_queue_xmit_nit()
       packet_rcv_fanout()
        ip_check_defrag()
         ip_defrag()
          spin_lock()     (lock frag queue spinlock)

2) ip6_input_finish()
    ipv6_frag_rcv()       (lock frag queue spinlock)
     ip6_frag_queue()
      icmpv6_param_prob() (lock txq->_xmit_lock at some point)

We could add lockdep annotations, but we also can make sure IPv6
calls icmpv6_param_prob() only after the release of the frag queue spinlock,
since this naturally makes frag queue spinlock a leaf in lock hierarchy.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/reassembly.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -169,7 +169,8 @@ fq_find(struct net *net, __be32 id, cons
 }
 
 static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
-			   struct frag_hdr *fhdr, int nhoff)
+			  struct frag_hdr *fhdr, int nhoff,
+			  u32 *prob_offset)
 {
 	struct sk_buff *prev, *next;
 	struct net_device *dev;
@@ -185,11 +186,7 @@ static int ip6_frag_queue(struct frag_qu
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
 
 	if ((unsigned int)end > IPV6_MAXPLEN) {
-		__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-				IPSTATS_MIB_INHDRERRORS);
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
-				  ((u8 *)&fhdr->frag_off -
-				   skb_network_header(skb)));
+		*prob_offset = (u8 *)&fhdr->frag_off - skb_network_header(skb);
 		return -1;
 	}
 
@@ -220,10 +217,7 @@ static int ip6_frag_queue(struct frag_qu
 			/* RFC2460 says always send parameter problem in
 			 * this case. -DaveM
 			 */
-			__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-					IPSTATS_MIB_INHDRERRORS);
-			icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
-					  offsetof(struct ipv6hdr, payload_len));
+			*prob_offset = offsetof(struct ipv6hdr, payload_len);
 			return -1;
 		}
 		if (end > fq->q.len) {
@@ -524,15 +518,22 @@ static int ipv6_frag_rcv(struct sk_buff
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
+		u32 prob_offset = 0;
 		int ret;
 
 		spin_lock(&fq->q.lock);
 
 		fq->iif = iif;
-		ret = ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff);
+		ret = ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff,
+				     &prob_offset);
 
 		spin_unlock(&fq->q.lock);
 		inet_frag_put(&fq->q);
+		if (prob_offset) {
+			__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
+					IPSTATS_MIB_INHDRERRORS);
+			icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, prob_offset);
+		}
 		return ret;
 	}
 


