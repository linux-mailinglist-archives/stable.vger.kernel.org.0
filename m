Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEC2428EE7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhJKNxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237497AbhJKNvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C17960F38;
        Mon, 11 Oct 2021 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960186;
        bh=jE5rqhFkjZtTLSM+ZTi9JFFOeSZNpMuav86n0F+SLjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHgiWmNBV4UeVmTizAMtUmeh4TttoZLKYtqdoWpF8j+Eo0TllJCLsyExbex6719VL
         LQdp991CmKWrjgXo0GAT/KBGx6lsK/UVYIr/6IV0odPrEl7OdFRmjVlQRFDjGTMy35
         quN69f3O/v9nCkZBr8vphZu8/22GSs1iRd9PvgzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/52] net: prefer socket bound to interface when not in VRF
Date:   Mon, 11 Oct 2021 15:46:14 +0200
Message-Id: <20211011134505.271255874@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
index 006a34b18537..72fdf1fcbcaa 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -239,8 +239,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
 
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
index de04d9941885..fdbd56ee1300 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -386,7 +386,8 @@ static int compute_score(struct sock *sk, struct net *net,
 					dif, sdif);
 	if (!dev_match)
 		return -1;
-	score += 4;
+	if (sk->sk_bound_dev_if)
+		score += 4;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index fbe9d4295eac..ab12e00f6bff 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -104,7 +104,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
 		if (!inet_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 			return -1;
 
-		score = 1;
+		score =  sk->sk_bound_dev_if ? 2 : 1;
 		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 5b8266f3e47f..0f57c682afdd 100644
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



