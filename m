Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C54232E8F
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgG3IVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbgG3IFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D594C20672;
        Thu, 30 Jul 2020 08:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096300;
        bh=hmR68HHAxwJGc9KMOu2OPGMn7a+StS9X8sZSVsjPbws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pf1BJAfSSTT6RYGGDEsy2+4rVa21S2JWyN9qd0CtFmET6a39RM0t+doFRY5EGJo/d
         NP1eRvYSOqUZ4StYRFcMjJseAX+z1D6yRLg4CPg5xsPMIkyok39CtEJKXSFVCQ5u2o
         RBbXO1s/PoM4+LZPHOMffwYapeHq/6ZTGevXp4jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 17/20] udp: Improve load balancing for SO_REUSEPORT.
Date:   Thu, 30 Jul 2020 10:04:07 +0200
Message-Id: <20200730074421.342711211@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit efc6b6f6c3113e8b203b9debfb72d81e0f3dcace ]

Currently, SO_REUSEPORT does not work well if connected sockets are in a
UDP reuseport group.

Then reuseport_has_conns() returns true and the result of
reuseport_select_sock() is discarded. Also, unconnected sockets have the
same score, hence only does the first unconnected socket in udp_hslot
always receive all packets sent to unconnected sockets.

So, the result of reuseport_select_sock() should be used for load
balancing.

The noteworthy point is that the unconnected sockets placed after
connected sockets in sock_reuseport.socks will receive more packets than
others because of the algorithm in reuseport_select_sock().

    index | connected | reciprocal_scale | result
    ---------------------------------------------
    0     | no        | 20%              | 40%
    1     | no        | 20%              | 20%
    2     | yes       | 20%              | 0%
    3     | no        | 20%              | 40%
    4     | yes       | 20%              | 0%

If most of the sockets are connected, this can be a problem, but it still
works better than now.

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
CC: Willem de Bruijn <willemb@google.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |   15 +++++++++------
 net/ipv6/udp.c |   15 +++++++++------
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -413,7 +413,7 @@ static struct sock *udp4_lib_lookup2(str
 				     struct udp_hslot *hslot2,
 				     struct sk_buff *skb)
 {
-	struct sock *sk, *result;
+	struct sock *sk, *result, *reuseport_result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -423,17 +423,20 @@ static struct sock *udp4_lib_lookup2(str
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
+			reuseport_result = NULL;
+
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
-				result = reuseport_select_sock(sk, hash, skb,
-							sizeof(struct udphdr));
-				if (result && !reuseport_has_conns(sk, false))
-					return result;
+				reuseport_result = reuseport_select_sock(sk, hash, skb,
+									 sizeof(struct udphdr));
+				if (reuseport_result && !reuseport_has_conns(sk, false))
+					return reuseport_result;
 			}
+
+			result = reuseport_result ? : sk;
 			badness = score;
-			result = sk;
 		}
 	}
 	return result;
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -148,7 +148,7 @@ static struct sock *udp6_lib_lookup2(str
 		int dif, int sdif, struct udp_hslot *hslot2,
 		struct sk_buff *skb)
 {
-	struct sock *sk, *result;
+	struct sock *sk, *result, *reuseport_result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -158,17 +158,20 @@ static struct sock *udp6_lib_lookup2(str
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
+			reuseport_result = NULL;
+
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
-				result = reuseport_select_sock(sk, hash, skb,
-							sizeof(struct udphdr));
-				if (result && !reuseport_has_conns(sk, false))
-					return result;
+				reuseport_result = reuseport_select_sock(sk, hash, skb,
+									 sizeof(struct udphdr));
+				if (reuseport_result && !reuseport_has_conns(sk, false))
+					return reuseport_result;
 			}
-			result = sk;
+
+			result = reuseport_result ? : sk;
 			badness = score;
 		}
 	}


