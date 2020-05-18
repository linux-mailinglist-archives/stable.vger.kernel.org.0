Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58E31D85ED
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgERSWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgERRvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F8A20715;
        Mon, 18 May 2020 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824262;
        bh=5DKwiWJyRxq7YiGnGwAaSbObySpsOz8YE1NrzOWGdHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwQ8/uIwJqll5CRea7UXaQcxOaY7iIu0R2eb7jqiKtKzxSImFB1c9FQUFP9WNUr0q
         oqdvR6yeCli3m9TebIW5vBndgCMJG0voyw7hS1X+dwwKxIVrju9XiYL7tq+YUwxXKD
         Ci7GepW9d1MXrXLvOWHqETbeSBLdqTfHRJSjnReg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 21/80] tcp: fix SO_RCVLOWAT hangs with fat skbs
Date:   Mon, 18 May 2020 19:36:39 +0200
Message-Id: <20200518173454.663518050@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 24adbc1676af4e134e709ddc7f34cf2adc2131e4 ]

We autotune rcvbuf whenever SO_RCVLOWAT is set to account for 100%
overhead in tcp_set_rcvlowat()

This works well when skb->len/skb->truesize ratio is bigger than 0.5

But if we receive packets with small MSS, we can end up in a situation
where not enough bytes are available in the receive queue to satisfy
RCVLOWAT setting.
As our sk_rcvbuf limit is hit, we send zero windows in ACK packets,
preventing remote peer from sending more data.

Even autotuning does not help, because it only triggers at the time
user process drains the queue. If no EPOLLIN is generated, this
can not happen.

Note poll() has a similar issue, after commit
c7004482e8dc ("tcp: Respect SO_RCVLOWAT in tcp_poll().")

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h    |   13 +++++++++++++
 net/ipv4/tcp.c       |   14 +++++++++++---
 net/ipv4/tcp_input.c |    3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1373,6 +1373,19 @@ static inline int tcp_full_space(const s
 	return tcp_win_from_space(sk, sk->sk_rcvbuf);
 }
 
+/* We provision sk_rcvbuf around 200% of sk_rcvlowat.
+ * If 87.5 % (7/8) of the space has been consumed, we want to override
+ * SO_RCVLOWAT constraint, since we are receiving skbs with too small
+ * len/truesize ratio.
+ */
+static inline bool tcp_rmem_pressure(const struct sock *sk)
+{
+	int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+	int threshold = rcvbuf - (rcvbuf >> 3);
+
+	return atomic_read(&sk->sk_rmem_alloc) > threshold;
+}
+
 extern void tcp_openreq_init_rwin(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  const struct dst_entry *dst);
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -488,9 +488,17 @@ static void tcp_tx_timestamp(struct sock
 static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 					  int target, struct sock *sk)
 {
-	return (READ_ONCE(tp->rcv_nxt) - tp->copied_seq >= target) ||
-		(sk->sk_prot->stream_memory_read ?
-		sk->sk_prot->stream_memory_read(sk) : false);
+	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
+
+	if (avail > 0) {
+		if (avail >= target)
+			return true;
+		if (tcp_rmem_pressure(sk))
+			return true;
+	}
+	if (sk->sk_prot->stream_memory_read)
+		return sk->sk_prot->stream_memory_read(sk);
+	return false;
 }
 
 /*
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4683,7 +4683,8 @@ void tcp_data_ready(struct sock *sk)
 	const struct tcp_sock *tp = tcp_sk(sk);
 	int avail = tp->rcv_nxt - tp->copied_seq;
 
-	if (avail < sk->sk_rcvlowat && !sock_flag(sk, SOCK_DONE))
+	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
+	    !sock_flag(sk, SOCK_DONE))
 		return;
 
 	sk->sk_data_ready(sk);


