Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EEC582DEF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiG0RFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbiG0REc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BBD4E607;
        Wed, 27 Jul 2022 09:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95EB601CD;
        Wed, 27 Jul 2022 16:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C442DC433D7;
        Wed, 27 Jul 2022 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939954;
        bh=SfAAi25jBlgvjYljMD4I14ml56dBnB6TVuJGEZX53iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXVfH6Fe0appdcsZhet4Xqamb9ZEcVeEzpI9+RWURSCQkcmT/CZZJBLxG/rfMgnYs
         Iyp6K3PtsRLH9Jh5P+1P2QQ6YCAJACCHKlgqWZxY97R977EKyehv1dKIgjm64PtTty
         a31T9gJ5MlLobPcXujELuXyodGd1US4GwAm+gN4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/201] ipv4/tcp: do not use per netns ctl sockets
Date:   Wed, 27 Jul 2022 18:09:01 +0200
Message-Id: <20220727161028.405847629@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 37ba017dcc3b1123206808979834655ddcf93251 ]

TCP ipv4 uses per-cpu/per-netns ctl sockets in order to send
RST and some ACK packets (on behalf of TIMEWAIT sockets).

This adds memory and cpu costs, which do not seem needed.
Now typical servers have 256 or more cores, this adds considerable
tax to netns users.

tcp sockets are used from BH context, are not receiving packets,
and do not store any persistent state but the 'struct net' pointer
in order to be able to use IPv4 output functions.

Note that I attempted a related change in the past, that had
to be hot-fixed in commit bdbbb8527b6f ("ipv4: tcp: get rid of ugly unicast_sock")

This patch could very well surface old bugs, on layers not
taking care of sk->sk_kern_sock properly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h |  1 -
 net/ipv4/tcp_ipv4.c      | 61 ++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 6c5b2efc4f17..d60a10cfc382 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -74,7 +74,6 @@ struct netns_ipv4 {
 	struct sock		*mc_autojoin_sk;
 
 	struct inet_peer_base	*peers;
-	struct sock  * __percpu	*tcp_sk;
 	struct fqdir		*fqdir;
 
 	u8 sysctl_icmp_echo_ignore_all;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5d94822fd506..b9a9f288bfa6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -91,6 +91,8 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 struct inet_hashinfo tcp_hashinfo;
 EXPORT_SYMBOL(tcp_hashinfo);
 
+static DEFINE_PER_CPU(struct sock *, ipv4_tcp_sk);
+
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
 {
 	return secure_tcp_seq(ip_hdr(skb)->daddr,
@@ -807,7 +809,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.tos = ip_hdr(skb)->tos;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
@@ -822,6 +825,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
@@ -905,7 +909,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.tos = tos;
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
 	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
@@ -918,6 +923,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
 }
@@ -3103,41 +3109,14 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
-	int cpu;
-
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-
-	for_each_possible_cpu(cpu)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.tcp_sk, cpu));
-	free_percpu(net->ipv4.tcp_sk);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
 {
-	int res, cpu, cnt;
-
-	net->ipv4.tcp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv4.tcp_sk)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		struct sock *sk;
-
-		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
-					   IPPROTO_TCP, net);
-		if (res)
-			goto fail;
-		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
-
-		/* Please enforce IP_DF and IPID==0 for RST and
-		 * ACK sent in SYN-RECV and TIME-WAIT state.
-		 */
-		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
-
-		*per_cpu_ptr(net->ipv4.tcp_sk, cpu) = sk;
-	}
+	int cnt;
 
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
@@ -3221,10 +3200,6 @@ static int __net_init tcp_sk_init(struct net *net)
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
 	return 0;
-fail:
-	tcp_sk_exit(net);
-
-	return res;
 }
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
@@ -3318,6 +3293,24 @@ static void __init bpf_iter_register(void)
 
 void __init tcp_v4_init(void)
 {
+	int cpu, res;
+
+	for_each_possible_cpu(cpu) {
+		struct sock *sk;
+
+		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
+					   IPPROTO_TCP, &init_net);
+		if (res)
+			panic("Failed to create the TCP control socket.\n");
+		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+		/* Please enforce IP_DF and IPID==0 for RST and
+		 * ACK sent in SYN-RECV and TIME-WAIT state.
+		 */
+		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
+
+		per_cpu(ipv4_tcp_sk, cpu) = sk;
+	}
 	if (register_pernet_subsys(&tcp_sk_ops))
 		panic("Failed to create the TCP control socket.\n");
 
-- 
2.35.1



