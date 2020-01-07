Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B901331B9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAGVD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgAGVD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DDC7214D8;
        Tue,  7 Jan 2020 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431008;
        bh=jRRNJpXoS9bXhoOpUAEeX0aM+B3fJRWVrK0HbiutWO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+7vb4nuTjUy48/RVP8Ylp02wfoNH3unYPf/js77LLsezXrZdTGc2er+q1dmMnZyE
         wa8QAxJu9nV5YBfPOYqY87DFy3DS09hu3KaeygZ+kMlLMYyd23WHYAVdXasq4Q2obE
         CVIL2xWqms1x318PIyGgQTDQk0q2rwOXC2ssjRBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/191] net: annotate lockless accesses to sk->sk_pacing_shift
Date:   Tue,  7 Jan 2020 21:55:07 +0100
Message-Id: <20200107205342.996828677@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7c68fa2bddda6d942bd387c9ba5b4300737fd991 ]

sk->sk_pacing_shift can be read and written without lock
synchronization. This patch adds annotations to
document this fact and avoid future syzbot complains.

This might also avoid unexpected false sharing
in sk_pacing_shift_update(), as the compiler
could remove the conditional check and always
write over sk->sk_pacing_shift :

if (sk->sk_pacing_shift != val)
	sk->sk_pacing_shift = val;

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h    | 4 ++--
 net/core/sock.c       | 2 +-
 net/ipv4/tcp_bbr.c    | 3 ++-
 net/ipv4/tcp_output.c | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e09e2886a836..6c5a3809483e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2589,9 +2589,9 @@ static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
  */
 static inline void sk_pacing_shift_update(struct sock *sk, int val)
 {
-	if (!sk || !sk_fullsock(sk) || sk->sk_pacing_shift == val)
+	if (!sk || !sk_fullsock(sk) || READ_ONCE(sk->sk_pacing_shift) == val)
 		return;
-	sk->sk_pacing_shift = val;
+	WRITE_ONCE(sk->sk_pacing_shift, val);
 }
 
 /* if a socket is bound to a device, check that the given device
diff --git a/net/core/sock.c b/net/core/sock.c
index ac78a570e43a..b4d1112174c1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2918,7 +2918,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_max_pacing_rate = ~0UL;
 	sk->sk_pacing_rate = ~0UL;
-	sk->sk_pacing_shift = 10;
+	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
 
 	sk_rx_queue_clear(sk);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 32772d6ded4e..a6545ef0d27b 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -306,7 +306,8 @@ static u32 bbr_tso_segs_goal(struct sock *sk)
 	/* Sort of tcp_tso_autosize() but ignoring
 	 * driver provided sk_gso_max_size.
 	 */
-	bytes = min_t(unsigned long, sk->sk_pacing_rate >> sk->sk_pacing_shift,
+	bytes = min_t(unsigned long,
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
 		      GSO_MAX_SIZE - 1 - MAX_TCP_HEADER);
 	segs = max_t(u32, bytes / tp->mss_cache, bbr_min_tso_segs(sk));
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0269584e9cf7..e4ba915c4bb5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1728,7 +1728,7 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 	u32 bytes, segs;
 
 	bytes = min_t(unsigned long,
-		      sk->sk_pacing_rate >> sk->sk_pacing_shift,
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
 		      sk->sk_gso_max_size - 1 - MAX_TCP_HEADER);
 
 	/* Goal is to send at least one packet per ms,
@@ -2263,7 +2263,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 
 	limit = max_t(unsigned long,
 		      2 * skb->truesize,
-		      sk->sk_pacing_rate >> sk->sk_pacing_shift);
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
 			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
-- 
2.20.1



