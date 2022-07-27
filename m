Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF55582BA1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiG0Qfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbiG0QfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:35:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2BD4F652;
        Wed, 27 Jul 2022 09:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FFBE619D6;
        Wed, 27 Jul 2022 16:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EF8C433D7;
        Wed, 27 Jul 2022 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939209;
        bh=8CQ8rsKERdiu9+Ig5+Kfcc5GKHqTaAhILdolMlu++n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/uWD2+z2fMKpTXuJzYjwYNHjKsykf+dSSdBCDTXxpx873jGnlaRDzKXeqMEFPFg6
         NrPI1HtGAAR3hbSHY+q0D7IwdBzOfyEMgrECwW5lHxd0pDkR6DHKD+pfx1XMEqyaNo
         ztl3fU3hGkLhMPJUoac+VGjNmMfQO4rsKB2medAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/62] tcp: Fix data-races around some timeout sysctl knobs.
Date:   Wed, 27 Jul 2022 18:10:29 +0200
Message-Id: <20220727161004.987834230@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 39e24435a776e9de5c6dd188836cf2523547804b ]

While reading these sysctl knobs, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - tcp_retries1
  - tcp_retries2
  - tcp_orphan_retries
  - tcp_fin_timeout

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     |  3 ++-
 net/ipv4/tcp.c        |  2 +-
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/tcp_timer.c  | 10 +++++-----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5c5807ed66ee..f92b93cf074c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1430,7 +1430,8 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 
 static inline int tcp_fin_time(const struct sock *sk)
 {
-	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
+	int fin_timeout = tcp_sk(sk)->linger2 ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fin_timeout);
 	const int rto = inet_csk(sk)->icsk_rto;
 
 	if (fin_timeout < (rto << 2) - (rto >> 1))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b1b121d5076c..0f89d0f2c21f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3386,7 +3386,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_LINGER2:
 		val = tp->linger2;
 		if (val >= 0)
-			val = (val ? : net->ipv4.sysctl_tcp_fin_timeout) / HZ;
+			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
 	case TCP_DEFER_ACCEPT:
 		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 33f9a486661c..3d5ea169e905 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3776,7 +3776,7 @@ void tcp_send_probe0(struct sock *sk)
 	}
 
 	if (err <= 0) {
-		if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
+		if (icsk->icsk_backoff < READ_ONCE(net->ipv4.sysctl_tcp_retries2))
 			icsk->icsk_backoff++;
 		icsk->icsk_probes_out++;
 		probe_max = TCP_RTO_MAX;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 5d761333ffc4..e905fff09fea 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -124,7 +124,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
  */
 static int tcp_orphan_retries(struct sock *sk, bool alive)
 {
-	int retries = sock_net(sk)->ipv4.sysctl_tcp_orphan_retries; /* May be zero. */
+	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
 	if (sk->sk_err_soft && !alive)
@@ -226,7 +226,7 @@ static int tcp_write_timeout(struct sock *sk)
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
-		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
+		if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1), 0)) {
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
@@ -235,7 +235,7 @@ static int tcp_write_timeout(struct sock *sk)
 			sk_rethink_txhash(sk);
 		}
 
-		retry_until = net->ipv4.sysctl_tcp_retries2;
+		retry_until = READ_ONCE(net->ipv4.sysctl_tcp_retries2);
 		if (sock_flag(sk, SOCK_DEAD)) {
 			const bool alive = icsk->icsk_rto < TCP_RTO_MAX;
 
@@ -362,7 +362,7 @@ static void tcp_probe_timer(struct sock *sk)
 		 (s32)(tcp_time_stamp(tp) - start_ts) > icsk->icsk_user_timeout)
 		goto abort;
 
-	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
+	max_probes = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retries2);
 	if (sock_flag(sk, SOCK_DEAD)) {
 		const bool alive = inet_csk_rto_backoff(icsk, TCP_RTO_MAX) < TCP_RTO_MAX;
 
@@ -556,7 +556,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 				  tcp_clamp_rto_to_user_timeout(sk), TCP_RTO_MAX);
-	if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1 + 1, 0))
+	if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1) + 1, 0))
 		__sk_dst_reset(sk);
 
 out:;
-- 
2.35.1



