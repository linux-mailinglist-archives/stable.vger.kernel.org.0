Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36E75830BE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242812AbiG0Rlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242830AbiG0RlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B73B88E1D;
        Wed, 27 Jul 2022 09:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E304616BD;
        Wed, 27 Jul 2022 16:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D27AC433D6;
        Wed, 27 Jul 2022 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940700;
        bh=yaO39FCIkog0GdspnVXs1MhPwE03uqdlb4jPCvcewdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYUV/6E6gtaIDdBkzybzV8htHNCHIS34I+/aUvOgrPkDtXaLfCqazFQ6H33T4mKi7
         b/Fg+bTMNxS2tAu+nhHypZ/w3jZYZHGtsR76fb5UmxySqqape0ViMaKz2OetPjlM8F
         +gLNsW32J2VthPkOvVysS1+uGVziypHmieyjnLjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 117/158] tcp: Fix data-races around sysctl knobs related to SYN option.
Date:   Wed, 27 Jul 2022 18:13:01 +0200
Message-Id: <20220727161026.153846951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

[ Upstream commit 3666f666e99600518ab20982af04a078bbdad277 ]

While reading these knobs, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - tcp_sack
  - tcp_window_scaling
  - tcp_timestamps

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    |  6 +++---
 net/core/secure_seq.c                                  |  4 ++--
 net/ipv4/syncookies.c                                  |  6 +++---
 net/ipv4/tcp_input.c                                   |  6 +++---
 net/ipv4/tcp_output.c                                  | 10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 7c760aa65540..ddfe9208529a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1236,8 +1236,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	csk->sndbuf = newsk->sk_sndbuf;
 	csk->smac_idx = ((struct port_info *)netdev_priv(ndev))->smt_idx;
 	RCV_WSCALE(tp) = select_rcv_wscale(tcp_full_space(newsk),
-					   sock_net(newsk)->
-						ipv4.sysctl_tcp_window_scaling,
+					   READ_ONCE(sock_net(newsk)->
+						     ipv4.sysctl_tcp_window_scaling),
 					   tp->window_clamp);
 	neigh_release(n);
 	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
@@ -1384,7 +1384,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 #endif
 	}
 	if (req->tcpopt.wsf <= 14 &&
-	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
 		inet_rsk(oreq)->wscale_ok = 1;
 		inet_rsk(oreq)->snd_wscale = req->tcpopt.wsf;
 	}
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 5f85e01d4093..b0ff6153be62 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -64,7 +64,7 @@ u32 secure_tcpv6_ts_off(const struct net *net,
 		.daddr = *(struct in6_addr *)daddr,
 	};
 
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(secure_ipv6_port_ephemeral);
 #ifdef CONFIG_INET
 u32 secure_tcp_ts_off(const struct net *net, __be32 saddr, __be32 daddr)
 {
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9b234b42021e..942d2dfa1115 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -247,12 +247,12 @@ bool cookie_timestamp_decode(const struct net *net,
 		return true;
 	}
 
-	if (!net->ipv4.sysctl_tcp_timestamps)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_timestamps))
 		return false;
 
 	tcp_opt->sack_ok = (options & TS_OPT_SACK) ? TCP_SACK_SEEN : 0;
 
-	if (tcp_opt->sack_ok && !net->ipv4.sysctl_tcp_sack)
+	if (tcp_opt->sack_ok && !READ_ONCE(net->ipv4.sysctl_tcp_sack))
 		return false;
 
 	if ((options & TS_OPT_WSCALE_MASK) == TS_OPT_WSCALE_MASK)
@@ -261,7 +261,7 @@ bool cookie_timestamp_decode(const struct net *net,
 	tcp_opt->wscale_ok = 1;
 	tcp_opt->snd_wscale = options & TS_OPT_WSCALE_MASK;
 
-	return net->ipv4.sysctl_tcp_window_scaling != 0;
+	return READ_ONCE(net->ipv4.sysctl_tcp_window_scaling) != 0;
 }
 EXPORT_SYMBOL(cookie_timestamp_decode);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d8d903ef61f7..c2431fe41b09 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4060,7 +4060,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_WINDOW:
 				if (opsize == TCPOLEN_WINDOW && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_window_scaling) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_window_scaling)) {
 					__u8 snd_wscale = *(__u8 *)ptr;
 					opt_rx->wscale_ok = 1;
 					if (snd_wscale > TCP_MAX_WSCALE) {
@@ -4076,7 +4076,7 @@ void tcp_parse_options(const struct net *net,
 			case TCPOPT_TIMESTAMP:
 				if ((opsize == TCPOLEN_TIMESTAMP) &&
 				    ((estab && opt_rx->tstamp_ok) ||
-				     (!estab && net->ipv4.sysctl_tcp_timestamps))) {
+				     (!estab && READ_ONCE(net->ipv4.sysctl_tcp_timestamps)))) {
 					opt_rx->saw_tstamp = 1;
 					opt_rx->rcv_tsval = get_unaligned_be32(ptr);
 					opt_rx->rcv_tsecr = get_unaligned_be32(ptr + 4);
@@ -4084,7 +4084,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_SACK_PERM:
 				if (opsize == TCPOLEN_SACK_PERM && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_sack) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_sack)) {
 					opt_rx->sack_ok = TCP_SACK_SEEN;
 					tcp_sack_reset(opt_rx);
 				}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3f20642c8171..be3e90b526d8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -789,18 +789,18 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	opts->mss = tcp_advertise_mss(sk);
 	remaining -= TCPOLEN_MSS_ALIGNED;
 
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_timestamps && !*md5)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps) && !*md5)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = tcp_skb_timestamp(skb) + tp->tsoffset;
 		opts->tsecr = tp->rx_opt.ts_recent;
 		remaining -= TCPOLEN_TSTAMP_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling))) {
 		opts->ws = tp->rx_opt.rcv_wscale;
 		opts->options |= OPTION_WSCALE;
 		remaining -= TCPOLEN_WSCALE_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_sack)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_sack))) {
 		opts->options |= OPTION_SACK_ADVERTISE;
 		if (unlikely(!(OPTION_TS & opts->options)))
 			remaining -= TCPOLEN_SACKPERM_ALIGNED;
@@ -3645,7 +3645,7 @@ static void tcp_connect_init(struct sock *sk)
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
 	 */
 	tp->tcp_header_len = sizeof(struct tcphdr);
-	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps))
 		tp->tcp_header_len += TCPOLEN_TSTAMP_ALIGNED;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -3681,7 +3681,7 @@ static void tcp_connect_init(struct sock *sk)
 				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
-				  sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
+				  READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling),
 				  &rcv_wscale,
 				  rcv_wnd);
 
-- 
2.35.1



