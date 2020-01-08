Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EC2134C26
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgAHTuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:50:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43416 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730397AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oM-Fy; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dm3-Mr; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 08 Jan 2020 19:43:18 +0000
Message-ID: <lsq.1578512578.423430354@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 20/63] tcp/dccp: drop SYN packets if accept queue is full
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5ea8ea2cb7f1d0db15762c9b0bb9e7330425a071 upstream.

Per listen(fd, backlog) rules, there is really no point accepting a SYN,
sending a SYNACK, and dropping the following ACK packet if accept queue
is full, because application is not draining accept queue fast enough.

This behavior is fooling TCP clients that believe they established a
flow, while there is nothing at server side. They might then send about
10 MSS (if using IW10) that will be dropped anyway while server is under
stress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16: Apply TCP changes in both tcp_ipv4.c and tcp_ipv6.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -287,11 +287,6 @@ static inline int inet_csk_reqsk_queue_l
 	return reqsk_queue_len(&inet_csk(sk)->icsk_accept_queue);
 }
 
-static inline int inet_csk_reqsk_queue_young(const struct sock *sk)
-{
-	return reqsk_queue_len_young(&inet_csk(sk)->icsk_accept_queue);
-}
-
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
 	return reqsk_queue_is_full(&inet_csk(sk)->icsk_accept_queue);
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -621,13 +621,7 @@ int dccp_v4_conn_request(struct sock *sk
 	if (inet_csk_reqsk_queue_is_full(sk))
 		goto drop;
 
-	/*
-	 * Accept backlog is full. If we have already queued enough
-	 * of warm entries in syn queue, drop request. It is better than
-	 * clogging syn queue with openreqs with exponentially increasing
-	 * timeout.
-	 */
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1)
+	if (sk_acceptq_is_full(sk))
 		goto drop;
 
 	req = inet_reqsk_alloc(&dccp_request_sock_ops);
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -391,7 +391,7 @@ static int dccp_v6_conn_request(struct s
 	if (inet_csk_reqsk_queue_is_full(sk))
 		goto drop;
 
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1)
+	if (sk_acceptq_is_full(sk))
 		goto drop;
 
 	req = inet6_reqsk_alloc(&dccp6_request_sock_ops);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1292,12 +1292,7 @@ int tcp_v4_conn_request(struct sock *sk,
 			goto drop;
 	}
 
-	/* Accept backlog is full. If we have already queued enough
-	 * of warm entries in syn queue, drop request. It is better than
-	 * clogging syn queue with openreqs with exponentially increasing
-	 * timeout.
-	 */
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1) {
+	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
 		goto drop;
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1009,7 +1009,7 @@ static int tcp_v6_conn_request(struct so
 			goto drop;
 	}
 
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1) {
+	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
 		goto drop;
 	}

