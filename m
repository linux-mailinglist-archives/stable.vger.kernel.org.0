Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38602F55B3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390936AbfKHTEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389057AbfKHTEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 344362067B;
        Fri,  8 Nov 2019 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239848;
        bh=1uRWxPfvmf2mM6P/WjTN+icFavAWs1wCndMKnSbc0dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2/QKKPnEiqGhDeq+PvueO2enNdM9aVjOF5Fq09LnXcMTpd80tLTs30+StXeHDDLH
         tmXvwWf4TSohwaIPL42T+sQnq0O6LUK3jfYIsb2M3jGSmmy7eIHDlHB1aZ0GUKfBx3
         wAvp4jq76WF3fRtPCGvvEGQvy+B1HNkNU/fycrd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Thiemo Nagel <tnagel@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 40/79] inet: stop leaking jiffies on the wire
Date:   Fri,  8 Nov 2019 19:50:20 +0100
Message-Id: <20191108174809.065126514@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
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
 drivers/crypto/chelsio/chtls/chtls_cm.c |    2 +-
 net/dccp/ipv4.c                         |    2 +-
 net/ipv4/datagram.c                     |    2 +-
 net/ipv4/tcp_ipv4.c                     |    4 ++--
 net/sctp/socket.c                       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1276,7 +1276,7 @@ static void make_established(struct sock
 	tp->write_seq = snd_isn;
 	tp->snd_nxt = snd_isn;
 	tp->snd_una = snd_isn;
-	inet_sk(sk)->inet_id = tp->write_seq ^ jiffies;
+	inet_sk(sk)->inet_id = prandom_u32();
 	assign_rxopt(sk, opt);
 
 	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
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
@@ -77,7 +77,7 @@ int __ip4_datagram_connect(struct sock *
 	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
-	inet->inet_id = jiffies;
+	inet->inet_id = prandom_u32();
 
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -305,7 +305,7 @@ int tcp_v4_connect(struct sock *sk, stru
 						 inet->inet_daddr);
 	}
 
-	inet->inet_id = tp->write_seq ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	if (tcp_fastopen_defer_connect(sk, &err))
 		return err;
@@ -1436,7 +1436,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
-	newinet->inet_id = newtp->write_seq ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8777,7 +8777,7 @@ void sctp_copy_sock(struct sock *newsk,
 	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
 	newinet->inet_dport = htons(asoc->peer.port);
 	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = asoc->next_tsn ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	newinet->uc_ttl = inet->uc_ttl;
 	newinet->mc_loop = 1;


