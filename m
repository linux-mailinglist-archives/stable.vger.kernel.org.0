Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADDE4290B9
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbhJKOLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240932AbhJKOJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 023F56113E;
        Mon, 11 Oct 2021 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960930;
        bh=3+anbr1w9S+ZkJqAyWxH8wZP/pLu7gTQNnv4+8Bd+TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4RITpgdWzI3FLRbfHaqMp421+zjQsEg/kJC3rNHfvUrK+K0j+rq4tCf1jv2LwRze
         uSMZG0JQytrADQ2Wy1AppaeBZ3XYyB265jAdJciKV+YxauBaoqWb32dyCB8pALAOao
         UzwBxF0vlPVNwZQytMSXAzZ0Ri3BXM62b+YfkT0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 117/151] net: prefer socket bound to interface when not in VRF
Date:   Mon, 11 Oct 2021 15:46:29 +0200
Message-Id: <20211011134521.599810189@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Manning <mvrmanning@gmail.com>

[ Upstream commit 8d6c414cd2fb74aa6812e9bfec6178f8246c4f3a ]

The commit 6da5b0f027a8 ("net: ensure unbound datagram socket to be
chosen when not in a VRF") modified compute_score() so that a device
match is always made, not just in the case of an l3mdev skb, then
increments the score also for unbound sockets. This ensures that
sockets bound to an l3mdev are never selected when not in a VRF.
But as unbound and bound sockets are now scored equally, this results
in the last opened socket being selected if there are matches in the
default VRF for an unbound socket and a socket bound to a dev that is
not an l3mdev. However, handling prior to this commit was to always
select the bound socket in this case. Reinstate this handling by
incrementing the score only for bound sockets. The required isolation
due to choosing between an unbound socket and a socket bound to an
l3mdev remains in place due to the device match always being made.
The same approach is taken for compute_score() for stream sockets.

Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c  | 4 +++-
 net/ipv4/udp.c              | 3 ++-
 net/ipv6/inet6_hashtables.c | 2 +-
 net/ipv6/udp.c              | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 80aeaf9e6e16..bfb522e51346 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -242,8 +242,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
 
 		if (!inet_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 			return -1;
+		score =  sk->sk_bound_dev_if ? 2 : 1;
 
-		score = sk->sk_family == PF_INET ? 2 : 1;
+		if (sk->sk_family == PF_INET)
+			score++;
 		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 915ea635b2d5..cbc7907f79b8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -390,7 +390,8 @@ static int compute_score(struct sock *sk, struct net *net,
 					dif, sdif);
 	if (!dev_match)
 		return -1;
-	score += 4;
+	if (sk->sk_bound_dev_if)
+		score += 4;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 55c290d55605..67c9114835c8 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -106,7 +106,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
 		if (!inet_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 			return -1;
 
-		score = 1;
+		score =  sk->sk_bound_dev_if ? 2 : 1;
 		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 80ae024d13c8..ba77955d75fb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -133,7 +133,8 @@ static int compute_score(struct sock *sk, struct net *net,
 	dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
 	if (!dev_match)
 		return -1;
-	score++;
+	if (sk->sk_bound_dev_if)
+		score++;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
-- 
2.33.0



