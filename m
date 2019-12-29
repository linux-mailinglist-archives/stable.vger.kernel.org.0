Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB012C82F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfL2Rvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732164AbfL2Rvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D5A21744;
        Sun, 29 Dec 2019 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641909;
        bh=0Fx2AptUmbnqJWwERQvM0/rovHRB++dwMACcgyDFEv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuzDou2oEQf5MytU/XEIdw8gLz/sba2eT5kD+V9/Ufl6DzVVa30Qwz6iO2cjCTv+X
         v0j1jnjMZvDNvEs7vGsqGbwkSNJemN5OGAljx/2loy4leoHEadUnbEutz/NVN0fRvQ
         Yp8y0dnIjz3qPobrqsHSX6E29QcQRORkh+1sM6E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/434] net: avoid potential false sharing in neighbor related code
Date:   Sun, 29 Dec 2019 18:25:15 +0100
Message-Id: <20191229172719.339035761@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 25c7a6d1f90e208ec27ca854b1381ed39842ec57 ]

There are common instances of the following construct :

	if (n->confirmed != now)
		n->confirmed = now;

A C compiler could legally remove the conditional.

Use READ_ONCE()/WRITE_ONCE() to avoid this problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/arp.h   |  4 ++--
 include/net/ndisc.h |  8 ++++----
 include/net/sock.h  | 12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index c8f580a0e6b1..4950191f6b2b 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -57,8 +57,8 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index b2f715ca0567..b5ebeb3b0de0 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -414,8 +414,8 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
@@ -431,8 +431,8 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 718e62fbe869..013396e50b91 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1940,8 +1940,8 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie);
 
 static inline void sk_dst_confirm(struct sock *sk)
 {
-	if (!sk->sk_dst_pending_confirm)
-		sk->sk_dst_pending_confirm = 1;
+	if (!READ_ONCE(sk->sk_dst_pending_confirm))
+		WRITE_ONCE(sk->sk_dst_pending_confirm, 1);
 }
 
 static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
@@ -1951,10 +1951,10 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
-		if (sk && sk->sk_dst_pending_confirm)
-			sk->sk_dst_pending_confirm = 0;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 	}
 }
 
-- 
2.20.1



