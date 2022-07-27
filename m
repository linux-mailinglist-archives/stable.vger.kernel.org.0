Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1AE582E3D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbiG0RKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiG0RJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C01743DB;
        Wed, 27 Jul 2022 09:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9672614AD;
        Wed, 27 Jul 2022 16:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C23C433C1;
        Wed, 27 Jul 2022 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940065;
        bh=ilUh0IvKwTJ3bPPNwTZW/MfnPkQl5fCqOhNvsYei6tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQP95Cqqx3Gm/fjtgO0KLlrqyZkrM4IwreesxsslPnYvdw9ntdw06aID8PbumhCeu
         6+ql3BLUZtZ7PG7Za9d55Cr1WYTwglTD9JBPOVfFAGzHviCfK691E4un5QTTvFaGSG
         8tk58SXgtEqlCDJ4p3hDJqO6bw4v1453aeB4Taqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/201] tcp: Fix data-races around sysctl_tcp_syncookies.
Date:   Wed, 27 Jul 2022 18:09:56 +0200
Message-Id: <20220727161031.573205678@linuxfoundation.org>
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

[ Upstream commit f2e383b5bb6bbc60a0b94b87b3e49a2b1aefd11e ]

While reading sysctl_tcp_syncookies, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c     |  4 ++--
 net/ipv4/syncookies.c |  3 ++-
 net/ipv4/tcp_input.c  | 20 ++++++++++++--------
 net/ipv6/syncookies.c |  3 ++-
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8b2bc855714b..ac64395611ae 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6734,7 +6734,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -EINVAL;
 
 	if (!th->ack || th->rst || th->syn)
@@ -6809,7 +6809,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -ENOENT;
 
 	if (!th->syn || th->ack || th->fin || th->rst)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index fd1dc86ba512..8eee771d2aca 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -342,7 +342,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct flowi4 fl4;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ae06923fe8d0..134e36f46e91 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6735,11 +6735,14 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 {
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	const char *msg = "Dropping request";
-	bool want_cookie = false;
 	struct net *net = sock_net(sk);
+	bool want_cookie = false;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 #ifdef CONFIG_SYN_COOKIES
-	if (net->ipv4.sysctl_tcp_syncookies) {
+	if (syncookies) {
 		msg = "Sending cookies";
 		want_cookie = true;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDOCOOKIES);
@@ -6747,8 +6750,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 #endif
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
-	if (!queue->synflood_warned &&
-	    net->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (!queue->synflood_warned && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0)
 		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
 				     proto, sk->sk_num, msg);
@@ -6797,7 +6799,7 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 	struct tcp_sock *tp = tcp_sk(sk);
 	u16 mss;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) != 2 &&
 	    !inet_csk_reqsk_queue_is_full(sk))
 		return 0;
 
@@ -6831,13 +6833,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
 	 * evidently real one.
 	 */
-	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
-	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
+	if ((syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
@@ -6887,7 +6891,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	if (!want_cookie && !isn) {
 		/* Kill the following clause, if you dislike this way. */
-		if (!net->ipv4.sysctl_tcp_syncookies &&
+		if (!syncookies &&
 		    (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
 		     (net->ipv4.sysctl_max_syn_backlog >> 2)) &&
 		    !tcp_peer_is_proven(req, dst)) {
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index ca92dd6981de..12ae817aaf2e 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -141,7 +141,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
-- 
2.35.1



