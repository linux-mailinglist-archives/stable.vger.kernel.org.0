Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA85E583097
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiG0Rjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbiG0Riv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9761D59;
        Wed, 27 Jul 2022 09:50:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4761B61617;
        Wed, 27 Jul 2022 16:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55120C433C1;
        Wed, 27 Jul 2022 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940648;
        bh=adF74x9d7xXtzr19a8APZ0CrVp/SgZ0sMYxDKxqdacA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0fzoSrSBdza+TFo1J0dD0q8NBRmu0rZehV4NVCo1NeyWOzrCy+om6TjgSOnx2E94
         +rEsItTqo8xjxR5lT2odAW58Iw+SjxEbPTfUaxw22HRI3s8uR8ATb6Q9RhDAcTILS3
         AgquC9QK4Lhlwvtj2lmQQsd/ILjybVhnFJdF3QE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 067/158] tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
Date:   Wed, 27 Jul 2022 18:12:11 +0200
Message-Id: <20220727161024.191282043@linuxfoundation.org>
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
index dfb5a2d7ad85..cdc750ced525 100644
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
index f2fd1779d925..df3bf1a24c39 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3988,7 +3988,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
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



