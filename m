Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD2F54FB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389048AbfKHS7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388926AbfKHS7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB9722501;
        Fri,  8 Nov 2019 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239571;
        bh=KB02WUCjZe9gVhl9Ru7yYHU+f40XexxgHI/C88O7Lw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMOJkb5uDS2y2ImMRnq8jx7kNa5VUYfucPHnMAz787Paphb03RwqAKZeheJyojXUS
         n6Fbm+VrUdFlhRY/HzkIA5D0P98mWHWo1GT/NS1gUc1iUkjgRZMLTA6L7MM2w4HOGE
         usoY8VQoRjCEgXF6fIRBWUy+djMNEBQyMb2kx990=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Thiemo Nagel <tnagel@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 48/62] inet: stop leaking jiffies on the wire
Date:   Fri,  8 Nov 2019 19:50:36 +0100
Message-Id: <20191108174752.638063700@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a904a0693c189691eeee64f6c6b188bd7dc244e9 ]

Historically linux tried to stick to RFC 791, 1122, 2003
for IPv4 ID field generation.

RFC 6864 made clear that no matter how hard we try,
we can not ensure unicity of IP ID within maximum
lifetime for all datagrams with a given source
address/destination address/protocol tuple.

Linux uses a per socket inet generator (inet_id), initialized
at connection startup with a XOR of 'jiffies' and other
fields that appear clear on the wire.

Thiemo Nagel pointed that this strategy is a privacy
concern as this provides 16 bits of entropy to fingerprint
devices.

Let's switch to a random starting point, this is just as
good as far as RFC 6864 is concerned and does not leak
anything critical.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thiemo Nagel <tnagel@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/ipv4.c     |    2 +-
 net/ipv4/datagram.c |    2 +-
 net/ipv4/tcp_ipv4.c |    4 ++--
 net/sctp/socket.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -121,7 +121,7 @@ int dccp_v4_connect(struct sock *sk, str
 						    inet->inet_daddr,
 						    inet->inet_sport,
 						    inet->inet_dport);
-	inet->inet_id = dp->dccps_iss ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	err = dccp_connect(sk);
 	rt = NULL;
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -75,7 +75,7 @@ int __ip4_datagram_connect(struct sock *
 	inet->inet_dport = usin->sin_port;
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
-	inet->inet_id = jiffies;
+	inet->inet_id = prandom_u32();
 
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -245,7 +245,7 @@ int tcp_v4_connect(struct sock *sk, stru
 						 inet->inet_daddr);
 	}
 
-	inet->inet_id = tp->write_seq ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	if (tcp_fastopen_defer_connect(sk, &err))
 		return err;
@@ -1368,7 +1368,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
-	newinet->inet_id = newtp->write_seq ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8136,7 +8136,7 @@ void sctp_copy_sock(struct sock *newsk,
 	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
 	newinet->inet_dport = htons(asoc->peer.port);
 	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = asoc->next_tsn ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	newinet->uc_ttl = inet->uc_ttl;
 	newinet->mc_loop = 1;


