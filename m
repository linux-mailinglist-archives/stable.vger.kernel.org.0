Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21028B91D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390619AbgJLN5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389351AbgJLNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBEE422228;
        Mon, 12 Oct 2020 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510208;
        bh=s6QtDsKbyi8xS5gm6CK0a3MmCEMlRMvQCNqOc90Dt0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kngz/acrGhZPivwcgoDO3FGtmdt1rzuI4H73mMZ7MtPsdC20wTx5VLULVQ3bMnS0d
         p41CDHzhpi2Td7X6er7pDwR3YyllJR8tEIQmvJVNl/uc6kxiOyR1Uni9dKk3KhCoxP
         hyCGsiNd/YNpJIL3KOkuxojkBpmiQEV0UQ994Y/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexandre Ferrieux <alexandre.ferrieux@orange.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 78/85] tcp: fix receive window update in tcp_add_backlog()
Date:   Mon, 12 Oct 2020 15:27:41 +0200
Message-Id: <20201012132636.594100667@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 86bccd0367130f481ca99ba91de1c6a5aa1c78c1 upstream.

We got reports from GKE customers flows being reset by netfilter
conntrack unless nf_conntrack_tcp_be_liberal is set to 1.

Traces seemed to suggest ACK packet being dropped by the
packet capture, or more likely that ACK were received in the
wrong order.

 wscale=7, SYN and SYNACK not shown here.

 This ACK allows the sender to send 1871*128 bytes from seq 51359321 :
 New right edge of the window -> 51359321+1871*128=51598809

 09:17:23.389210 IP A > B: Flags [.], ack 51359321, win 1871, options [nop,nop,TS val 10 ecr 999], length 0

 09:17:23.389212 IP B > A: Flags [.], seq 51422681:51424089, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 1408
 09:17:23.389214 IP A > B: Flags [.], ack 51422681, win 1376, options [nop,nop,TS val 10 ecr 999], length 0
 09:17:23.389253 IP B > A: Flags [.], seq 51424089:51488857, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 64768
 09:17:23.389272 IP A > B: Flags [.], ack 51488857, win 859, options [nop,nop,TS val 10 ecr 999], length 0
 09:17:23.389275 IP B > A: Flags [.], seq 51488857:51521241, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384

 Receiver now allows to send 606*128=77568 from seq 51521241 :
 New right edge of the window -> 51521241+606*128=51598809

 09:17:23.389296 IP A > B: Flags [.], ack 51521241, win 606, options [nop,nop,TS val 10 ecr 999], length 0

 09:17:23.389308 IP B > A: Flags [.], seq 51521241:51553625, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384

 It seems the sender exceeds RWIN allowance, since 51611353 > 51598809

 09:17:23.389346 IP B > A: Flags [.], seq 51553625:51611353, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 57728
 09:17:23.389356 IP B > A: Flags [.], seq 51611353:51618393, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 7040

 09:17:23.389367 IP A > B: Flags [.], ack 51611353, win 0, options [nop,nop,TS val 10 ecr 999], length 0

 netfilter conntrack is not happy and sends RST

 09:17:23.389389 IP A > B: Flags [R], seq 92176528, win 0, length 0
 09:17:23.389488 IP B > A: Flags [R], seq 174478967, win 0, length 0

 Now imagine ACK were delivered out of order and tcp_add_backlog() sets window based on wrong packet.
 New right edge of the window -> 51521241+859*128=51631193

Normally TCP stack handles OOO packets just fine, but it
turns out tcp_add_backlog() does not. It can update the window
field of the aggregated packet even if the ACK sequence
of the last received packet is too old.

Many thanks to Alexandre Ferrieux for independently reporting the issue
and suggesting a fix.

Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_ipv4.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1719,12 +1719,12 @@ bool tcp_add_backlog(struct sock *sk, st
 
 	__skb_pull(skb, hdrlen);
 	if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
-		thtail->window = th->window;
-
 		TCP_SKB_CB(tail)->end_seq = TCP_SKB_CB(skb)->end_seq;
 
-		if (after(TCP_SKB_CB(skb)->ack_seq, TCP_SKB_CB(tail)->ack_seq))
+		if (likely(!before(TCP_SKB_CB(skb)->ack_seq, TCP_SKB_CB(tail)->ack_seq))) {
 			TCP_SKB_CB(tail)->ack_seq = TCP_SKB_CB(skb)->ack_seq;
+			thtail->window = th->window;
+		}
 
 		/* We have to update both TCP_SKB_CB(tail)->tcp_flags and
 		 * thtail->fin, so that the fast path in tcp_rcv_established()


