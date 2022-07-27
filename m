Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF2582D45
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiG0QzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbiG0QyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD5F54CBF;
        Wed, 27 Jul 2022 09:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F198DB821BE;
        Wed, 27 Jul 2022 16:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431EBC433D6;
        Wed, 27 Jul 2022 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939726;
        bh=tcNKqGtDtsyWutxE+xvFDDK7Vyq6N/uegsJekL4Td60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfsDHCcW6ejxNOJgEz1H4U/FGaB5F+Olw//Jm2jQR+z9x3k5Ncj8tzGqZVnm4CT6o
         rIiuBq/XQ2gis/yAiE4XlgiCGwOtW+pdP1bdHfXZvy/AtXBpIF3p4U35t5KkD2NlNY
         yZBlgWAdK6tD7LqEyPCG5AQFPs3CXEX1xX2yVSNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/105] tcp: Fix data-races around sysctl_tcp_fastopen.
Date:   Wed, 27 Jul 2022 18:10:41 +0200
Message-Id: <20220727161014.289382540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit 5a54213318c43f4009ae158347aa6016e3b9b55a ]

While reading sysctl_tcp_fastopen, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 2100c8d2d9db ("net-tcp: Fast Open base")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c      | 2 +-
 net/ipv4/tcp.c          | 6 ++++--
 net/ipv4/tcp_fastopen.c | 4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9d1ff3baa213..a733ce1a3f8f 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -220,7 +220,7 @@ int inet_listen(struct socket *sock, int backlog)
 		 * because the socket was in TCP_LISTEN state previously but
 		 * was shutdown() rather than close().
 		 */
-		tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+		tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 		if ((tcp_fastopen & TFO_SERVER_WO_SOCKOPT1) &&
 		    (tcp_fastopen & TFO_SERVER_ENABLE) &&
 		    !inet_csk(sk)->icsk_accept_queue.fastopenq.max_qlen) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6cd5ce3eac0c..f1fd26bb199c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1148,7 +1148,8 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 	struct sockaddr *uaddr = msg->msg_name;
 	int err, flags;
 
-	if (!(sock_net(sk)->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) ||
+	if (!(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) &
+	      TFO_CLIENT_ENABLE) ||
 	    (uaddr && msg->msg_namelen >= sizeof(uaddr->sa_family) &&
 	     uaddr->sa_family == AF_UNSPEC))
 		return -EOPNOTSUPP;
@@ -3390,7 +3391,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_FASTOPEN_CONNECT:
 		if (val > 1 || val < 0) {
 			err = -EINVAL;
-		} else if (net->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) {
+		} else if (READ_ONCE(net->ipv4.sysctl_tcp_fastopen) &
+			   TFO_CLIENT_ENABLE) {
 			if (sk->sk_state == TCP_CLOSE)
 				tp->fastopen_connect = val;
 			else
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 107111984384..ed7aa6ae7b51 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -349,7 +349,7 @@ static bool tcp_fastopen_no_cookie(const struct sock *sk,
 				   const struct dst_entry *dst,
 				   int flag)
 {
-	return (sock_net(sk)->ipv4.sysctl_tcp_fastopen & flag) ||
+	return (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) & flag) ||
 	       tcp_sk(sk)->fastopen_no_cookie ||
 	       (dst && dst_metric(dst, RTAX_FASTOPEN_NO_COOKIE));
 }
@@ -364,7 +364,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      const struct dst_entry *dst)
 {
 	bool syn_data = TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq + 1;
-	int tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+	int tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 	struct tcp_fastopen_cookie valid_foc = { .len = -1 };
 	struct sock *child;
 	int ret = 0;
-- 
2.35.1



