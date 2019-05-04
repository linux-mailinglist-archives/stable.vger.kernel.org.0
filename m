Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBF01392C
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfEDKa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbfEDKZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:25:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8BD12084A;
        Sat,  4 May 2019 10:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965556;
        bh=ym/vF14EpxVfDOnzT5lnswelYOCBfZA/X3gAGxTbSQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFXzuu8A8dhWmb3+mJKfYlFHirC9ZlG7BU8+niCpGHg8nw8NYFl08eqMeN3Zlre7f
         B7FoguTLFmOdMuvvaTilyNmmjMatd+CUj75XmjAG92YSmbZAeZdJJ6c7dLOY32vm91
         1dQiJgJpD6Jm+K8mf9tAUEJI/9/Ay9iUoWrL2nUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@sysophe.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 17/32] tcp: add sanity tests in tcp_add_backlog()
Date:   Sat,  4 May 2019 12:25:02 +0200
Message-Id: <20190504102453.048443786@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ca2fe2956acef2f87f6c55549874fdd2e92d9824 ]

Richard and Bruno both reported that my commit added a bug,
and Bruno was able to determine the problem came when a segment
wih a FIN packet was coalesced to a prior one in tcp backlog queue.

It turns out the header prediction in tcp_rcv_established()
looks back to TCP headers in the packet, not in the metadata
(aka TCP_SKB_CB(skb)->tcp_flags)

The fast path in tcp_rcv_established() is not supposed to
handle a FIN flag (it does not call tcp_fin())

Therefore we need to make sure to propagate the FIN flag,
so that the coalesced packet does not go through the fast path,
the same than a GRO packet carrying a FIN flag.

While we are at it, make sure we do not coalesce packets with
RST or SYN, or if they do not have ACK set.

Many thanks to Richard and Bruno for pinpointing the bad commit,
and to Richard for providing a first version of the fix.

Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Reported-by: Bruno Prémont <bonbons@sysophe.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1673,7 +1673,9 @@ bool tcp_add_backlog(struct sock *sk, st
 	if (TCP_SKB_CB(tail)->end_seq != TCP_SKB_CB(skb)->seq ||
 	    TCP_SKB_CB(tail)->ip_dsfield != TCP_SKB_CB(skb)->ip_dsfield ||
 	    ((TCP_SKB_CB(tail)->tcp_flags |
-	      TCP_SKB_CB(skb)->tcp_flags) & TCPHDR_URG) ||
+	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_SYN | TCPHDR_RST | TCPHDR_URG)) ||
+	    !((TCP_SKB_CB(tail)->tcp_flags &
+	      TCP_SKB_CB(skb)->tcp_flags) & TCPHDR_ACK) ||
 	    ((TCP_SKB_CB(tail)->tcp_flags ^
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
@@ -1692,6 +1694,15 @@ bool tcp_add_backlog(struct sock *sk, st
 		if (after(TCP_SKB_CB(skb)->ack_seq, TCP_SKB_CB(tail)->ack_seq))
 			TCP_SKB_CB(tail)->ack_seq = TCP_SKB_CB(skb)->ack_seq;
 
+		/* We have to update both TCP_SKB_CB(tail)->tcp_flags and
+		 * thtail->fin, so that the fast path in tcp_rcv_established()
+		 * is not entered if we append a packet with a FIN.
+		 * SYN, RST, URG are not present.
+		 * ACK is set on both packets.
+		 * PSH : we do not really care in TCP stack,
+		 *       at least for 'GRO' packets.
+		 */
+		thtail->fin |= th->fin;
 		TCP_SKB_CB(tail)->tcp_flags |= TCP_SKB_CB(skb)->tcp_flags;
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {


