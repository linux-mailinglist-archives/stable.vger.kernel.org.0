Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A281D304A84
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbhAZFFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731344AbhAYSyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 640842067B;
        Mon, 25 Jan 2021 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600832;
        bh=Pza3cSwYcBt/gRzkSDx1KSnV3/1gjdFAMwDAhMgomys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2mELswBLM/8hGydNMHv7nmLyUu9MqDFHEMAtnoIswAayy3DrRfVcGJiQICphJ8CT
         5JVs6Ms2YE+SVKcRl10qFDL9iepvgN3guMPW/U6HEghuBOMCuKTa0kPlbXWHDgumt0
         BvhhCInWJ5ESdoU5vwhWVwmAB9/Od/2oF4pIVbtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 169/199] tcp: fix TCP socket rehash stats mis-accounting
Date:   Mon, 25 Jan 2021 19:39:51 +0100
Message-Id: <20210125183223.331102397@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

commit 9c30ae8398b0813e237bde387d67a7f74ab2db2d upstream.

The previous commit 32efcc06d2a1 ("tcp: export count for rehash attempts")
would mis-account rehashing SNMP and socket stats:

  a. During handshake of an active open, only counts the first
     SYN timeout

  b. After handshake of passive and active open, stop updating
     after (roughly) TCP_RETRIES1 recurring RTOs

  c. After the socket aborts, over count timeout_rehash by 1

This patch fixes this by checking the rehash result from sk_rethink_txhash.

Fixes: 32efcc06d2a1 ("tcp: export count for rehash attempts")
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20210119192619.1848270-1-ycheng@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sock.h   |   17 ++++++++++++-----
 net/ipv4/tcp_input.c |    5 ++---
 net/ipv4/tcp_timer.c |   22 ++++++++--------------
 3 files changed, 22 insertions(+), 22 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1903,10 +1903,13 @@ static inline void sk_set_txhash(struct
 	sk->sk_txhash = net_tx_rndhash();
 }
 
-static inline void sk_rethink_txhash(struct sock *sk)
+static inline bool sk_rethink_txhash(struct sock *sk)
 {
-	if (sk->sk_txhash)
+	if (sk->sk_txhash) {
 		sk_set_txhash(sk);
+		return true;
+	}
+	return false;
 }
 
 static inline struct dst_entry *
@@ -1929,12 +1932,10 @@ sk_dst_get(struct sock *sk)
 	return dst;
 }
 
-static inline void dst_negative_advice(struct sock *sk)
+static inline void __dst_negative_advice(struct sock *sk)
 {
 	struct dst_entry *ndst, *dst = __sk_dst_get(sk);
 
-	sk_rethink_txhash(sk);
-
 	if (dst && dst->ops->negative_advice) {
 		ndst = dst->ops->negative_advice(dst);
 
@@ -1946,6 +1947,12 @@ static inline void dst_negative_advice(s
 	}
 }
 
+static inline void dst_negative_advice(struct sock *sk)
+{
+	sk_rethink_txhash(sk);
+	__dst_negative_advice(sk);
+}
+
 static inline void
 __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4379,10 +4379,9 @@ static void tcp_rcv_spurious_retrans(str
 	 * The receiver remembers and reflects via DSACKs. Leverage the
 	 * DSACK state and change the txhash to re-route speculatively.
 	 */
-	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq) {
-		sk_rethink_txhash(sk);
+	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq &&
+	    sk_rethink_txhash(sk))
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDUPLICATEDATAREHASH);
-	}
 }
 
 static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -219,14 +219,8 @@ static int tcp_write_timeout(struct sock
 	int retry_until;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
-		if (icsk->icsk_retransmits) {
-			dst_negative_advice(sk);
-		} else {
-			sk_rethink_txhash(sk);
-			tp->timeout_rehash++;
-			__NET_INC_STATS(sock_net(sk),
-					LINUX_MIB_TCPTIMEOUTREHASH);
-		}
+		if (icsk->icsk_retransmits)
+			__dst_negative_advice(sk);
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
@@ -234,12 +228,7 @@ static int tcp_write_timeout(struct sock
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
-			dst_negative_advice(sk);
-		} else {
-			sk_rethink_txhash(sk);
-			tp->timeout_rehash++;
-			__NET_INC_STATS(sock_net(sk),
-					LINUX_MIB_TCPTIMEOUTREHASH);
+			__dst_negative_advice(sk);
 		}
 
 		retry_until = net->ipv4.sysctl_tcp_retries2;
@@ -270,6 +259,11 @@ static int tcp_write_timeout(struct sock
 		return 1;
 	}
 
+	if (sk_rethink_txhash(sk)) {
+		tp->timeout_rehash++;
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTREHASH);
+	}
+
 	return 0;
 }
 


