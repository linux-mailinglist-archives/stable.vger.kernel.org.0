Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6170122053
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfLQAyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35450 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727144AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MA-Vo; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cT-C1; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Thiemo Nagel" <tnagel@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:47:26 +0000
Message-ID: <lsq.1576543535.412736491@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 112/136] inet: stop leaking jiffies on the wire
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a904a0693c189691eeee64f6c6b188bd7dc244e9 upstream.

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
[bwh: Backported to 3.16: drop changes in chelsio]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -122,7 +122,7 @@ int dccp_v4_connect(struct sock *sk, str
 						    inet->inet_daddr,
 						    inet->inet_sport,
 						    inet->inet_dport);
-	inet->inet_id = dp->dccps_iss ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	err = dccp_connect(sk);
 	rt = NULL;
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -74,7 +74,7 @@ int __ip4_datagram_connect(struct sock *
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
 	sk->sk_state = TCP_ESTABLISHED;
-	inet->inet_id = jiffies;
+	inet->inet_id = prandom_u32();
 
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -241,7 +241,7 @@ int tcp_v4_connect(struct sock *sk, stru
 							   inet->inet_sport,
 							   usin->sin_port);
 
-	inet->inet_id = tp->write_seq ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	err = tcp_connect(sk);
 
@@ -1449,7 +1449,7 @@ struct sock *tcp_v4_syn_recv_sock(struct
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
-	newinet->inet_id = newtp->write_seq ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7006,7 +7006,7 @@ void sctp_copy_sock(struct sock *newsk,
 	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
 	newinet->inet_dport = htons(asoc->peer.port);
 	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = asoc->next_tsn ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	newinet->uc_ttl = inet->uc_ttl;
 	newinet->mc_loop = 1;

