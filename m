Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F84582E3C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiG0RKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiG0RJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C377743C9;
        Wed, 27 Jul 2022 09:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2672A601C3;
        Wed, 27 Jul 2022 16:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F233C433B5;
        Wed, 27 Jul 2022 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940062;
        bh=fVvNtlgbgAe6ClvXquGjijDpiSBJVzaHL91Kx5ew4Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSCoePc2Gi9gJwFYn4Ivn6fHIEXdZPDtMQ4/B9PrmWSIOptuzfOI5wWAFwNG4eMbL
         s7z6Ejw+ysdpZ46xMVJb2i54IlGYF4n+gijF+JXQWg9BeWKbLs/W3U51AO4c7qYHsw
         EmNcpNIl66pYI8ret3/ox+Owhzar0uGQfV4bxnJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/201] tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
Date:   Wed, 27 Jul 2022 18:09:55 +0200
Message-Id: <20220727161031.529543535@linuxfoundation.org>
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

[ Upstream commit 20a3b1c0f603e8c55c3396abd12dfcfb523e4d3c ]

While reading sysctl_tcp_syn(ack)?_retries, they can be changed
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c |  3 ++-
 net/ipv4/tcp.c                  |  3 ++-
 net/ipv4/tcp_timer.c            | 10 +++++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index d3bbb344bbe1..a53f9bf7886f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -829,7 +829,8 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 	icsk = inet_csk(sk_listener);
 	net = sock_net(sk_listener);
-	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
+	max_syn_ack_retries = icsk->icsk_syn_retries ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_synack_retries);
 	/* Normally all the openreqs are young and become mature
 	 * (i.e. converted to established socket) for first timeout.
 	 * If synack was not acknowledged for 1 second, it means
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4ac53c8f0583..e22a61b2ba82 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3974,7 +3974,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		val = keepalive_probes(tp);
 		break;
 	case TCP_SYNCNT:
-		val = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
+		val = icsk->icsk_syn_retries ? :
+			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		break;
 	case TCP_LINGER2:
 		val = tp->linger2;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 4f3b9ab222b6..a234704e8163 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -239,7 +239,8 @@ static int tcp_write_timeout(struct sock *sk)
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		if (icsk->icsk_retransmits)
 			__dst_negative_advice(sk);
-		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
+		retry_until = icsk->icsk_syn_retries ? :
+			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
 		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
@@ -406,12 +407,15 @@ abort:		tcp_write_err(sk);
 static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	int max_retries = icsk->icsk_syn_retries ? :
-	    sock_net(sk)->ipv4.sysctl_tcp_synack_retries + 1; /* add one more retry for fastopen */
 	struct tcp_sock *tp = tcp_sk(sk);
+	int max_retries;
 
 	req->rsk_ops->syn_ack_timeout(req);
 
+	/* add one more retry for fastopen */
+	max_retries = icsk->icsk_syn_retries ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_synack_retries) + 1;
+
 	if (req->num_timeout >= max_retries) {
 		tcp_write_err(sk);
 		return;
-- 
2.35.1



