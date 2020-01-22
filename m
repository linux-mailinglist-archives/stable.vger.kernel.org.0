Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1741450D5
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbgAVJjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733142AbgAVJjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:39:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF32724680;
        Wed, 22 Jan 2020 09:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685953;
        bh=2XKmY0c9D7XUVpX17QA59ql3z4kAvoi44sZGTwYqWqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn/5f3vtqAFyLGNalD7YsteaneAI9mEQZYmYXXnz1OWytuehSE1ofIQpAtjnz/II/
         gX71Ht12eLVQlN6C9FaOYQTDJgY0LUQl6evO9ROILnOUGGvsV8E85MmxgXoK7vDi9r
         cSQ6CZ9CT8xfdNh1XGY3g/dxy3hDjIaYqVsJ5wEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 49/65] tcp: fix marked lost packets not being retransmitted
Date:   Wed, 22 Jan 2020 10:29:34 +0100
Message-Id: <20200122092758.260941988@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit e176b1ba476cf36f723cfcc7a9e57f3cb47dec70 ]

When the packet pointed to by retransmit_skb_hint is unlinked by ACK,
retransmit_skb_hint will be set to NULL in tcp_clean_rtx_queue().
If packet loss is detected at this time, retransmit_skb_hint will be set
to point to the current packet loss in tcp_verify_retransmit_hint(),
then the packets that were previously marked lost but not retransmitted
due to the restriction of cwnd will be skipped and cannot be
retransmitted.

To fix this, when retransmit_skb_hint is NULL, retransmit_skb_hint can
be reset only after all marked lost packets are retransmitted
(retrans_out >= lost_out), otherwise we need to traverse from
tcp_rtx_queue_head in tcp_xmit_retransmit_queue().

Packetdrill to demonstrate:

// Disable RACK and set max_reordering to keep things simple
    0 `sysctl -q net.ipv4.tcp_recovery=0`
   +0 `sysctl -q net.ipv4.tcp_max_reordering=3`

// Establish a connection
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 8 data segments
   +0 write(4, ..., 8000) = 8000
   +0 > P. 1:8001(8000) ack 1

// Enter recovery and 1:3001 is marked lost
 +.01 < . 1:1(0) ack 1 win 257 <sack 3001:4001,nop,nop>
   +0 < . 1:1(0) ack 1 win 257 <sack 5001:6001 3001:4001,nop,nop>
   +0 < . 1:1(0) ack 1 win 257 <sack 5001:7001 3001:4001,nop,nop>

// Retransmit 1:1001, now retransmit_skb_hint points to 1001:2001
   +0 > . 1:1001(1000) ack 1

// 1001:2001 was ACKed causing retransmit_skb_hint to be set to NULL
 +.01 < . 1:1(0) ack 2001 win 257 <sack 5001:8001 3001:4001,nop,nop>
// Now retransmit_skb_hint points to 4001:5001 which is now marked lost

// BUG: 2001:3001 was not retransmitted
   +0 > . 2001:3001(1000) ack 1

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -932,9 +932,10 @@ static void tcp_update_reordering(struct
 /* This must be called before lost_out is incremented */
 static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 {
-	if (!tp->retransmit_skb_hint ||
-	    before(TCP_SKB_CB(skb)->seq,
-		   TCP_SKB_CB(tp->retransmit_skb_hint)->seq))
+	if ((!tp->retransmit_skb_hint && tp->retrans_out >= tp->lost_out) ||
+	    (tp->retransmit_skb_hint &&
+	     before(TCP_SKB_CB(skb)->seq,
+		    TCP_SKB_CB(tp->retransmit_skb_hint)->seq)))
 		tp->retransmit_skb_hint = skb;
 }
 


