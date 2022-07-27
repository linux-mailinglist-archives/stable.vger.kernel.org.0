Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068F5582EA6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiG0RO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241629AbiG0ROH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EF076E9E;
        Wed, 27 Jul 2022 09:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8F6461494;
        Wed, 27 Jul 2022 16:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F3CC433D6;
        Wed, 27 Jul 2022 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940144;
        bh=rgp9Sjl5vf3cDHOahT05ecTSCc7mB1HYzcffHKemhxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzmYc0wr0u6QolNnAtfdfTZsgeLlg6x58m2C/4mIsFThErUo0STBiTzNXExptPLty
         Am8njM1SL6FtcTh8obJxxA8kNt1oiopz03bvAW8YlDz61o4rGm0rYwgYNRe4tBKPKR
         H5K4ljMZi9eBzU5dxiEIuEIINkbTuPppMZ+CkRuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/201] tcp: Fix data-races around sysctl knobs related to SYN option.
Date:   Wed, 27 Jul 2022 18:10:25 +0200
Message-Id: <20220727161032.775961702@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 7131cd1fb2ad..189eea1372d5 100644
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
index 8eee771d2aca..940839264025 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -249,12 +249,12 @@ bool cookie_timestamp_decode(const struct net *net,
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
@@ -263,7 +263,7 @@ bool cookie_timestamp_decode(const struct net *net,
 	tcp_opt->wscale_ok = 1;
 	tcp_opt->snd_wscale = options & TS_OPT_WSCALE_MASK;
 
-	return net->ipv4.sysctl_tcp_window_scaling != 0;
+	return READ_ONCE(net->ipv4.sysctl_tcp_window_scaling) != 0;
 }
 EXPORT_SYMBOL(cookie_timestamp_decode);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d9e534c6fd0c..dd10a317709f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4053,7 +4053,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_WINDOW:
 				if (opsize == TCPOLEN_WINDOW && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_window_scaling) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_window_scaling)) {
 					__u8 snd_wscale = *(__u8 *)ptr;
 					opt_rx->wscale_ok = 1;
 					if (snd_wscale > TCP_MAX_WSCALE) {
@@ -4069,7 +4069,7 @@ void tcp_parse_options(const struct net *net,
 			case TCPOPT_TIMESTAMP:
 				if ((opsize == TCPOLEN_TIMESTAMP) &&
 				    ((estab && opt_rx->tstamp_ok) ||
-				     (!estab && net->ipv4.sysctl_tcp_timestamps))) {
+				     (!estab && READ_ONCE(net->ipv4.sysctl_tcp_timestamps)))) {
 					opt_rx->saw_tstamp = 1;
 					opt_rx->rcv_tsval = get_unaligned_be32(ptr);
 					opt_rx->rcv_tsecr = get_unaligned_be32(ptr + 4);
@@ -4077,7 +4077,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_SACK_PERM:
 				if (opsize == TCPOLEN_SACK_PERM && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_sack) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_sack)) {
 					opt_rx->sack_ok = TCP_SACK_SEEN;
 					tcp_sack_reset(opt_rx);
 				}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fcccf56ae9f7..a08fcf15372a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -790,18 +790,18 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
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
@@ -3649,7 +3649,7 @@ static void tcp_connect_init(struct sock *sk)
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
 	 */
 	tp->tcp_header_len = sizeof(struct tcphdr);
-	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps))
 		tp->tcp_header_len += TCPOLEN_TSTAMP_ALIGNED;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -3685,7 +3685,7 @@ static void tcp_connect_init(struct sock *sk)
 				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
-				  sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
+				  READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling),
 				  &rcv_wscale,
 				  rcv_wnd);
 
-- 
2.35.1



