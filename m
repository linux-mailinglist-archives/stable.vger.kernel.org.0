Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECE657D1F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiL1Pjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiL1Pjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:39:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49715167D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D90F96154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12D4C433D2;
        Wed, 28 Dec 2022 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241977;
        bh=3HDWe89flz0DMmrZtFI4A9NZWaSAp+gsSQhoGexSq5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fe6rjvH4ryWJekbGAMG9rHk0+XCGEK8vvS3gZfAZv8PNnjY6EtKMe1vkXwVXCbf/Q
         6AGp1wyvbLbsLzJOqUMT9j8pf82WGA0pU76gQ4xUlEL8vzWYcEVKD57rhlgrEd0ZcZ
         DIkYfnMtfwDE8J7kxAbzQZIG7mfSuo6SDZINxs6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0350/1073] net: Return errno in sk->sk_prot->get_port().
Date:   Wed, 28 Dec 2022 15:32:18 +0100
Message-Id: <20221228144337.512799851@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 7a7160edf1bfde25422262fb26851cef65f695d3 ]

We assume the correct errno is -EADDRINUSE when sk->sk_prot->get_port()
fails, so some ->get_port() functions return just 1 on failure and the
callers return -EADDRINUSE instead.

However, mptcp_get_port() can return -EINVAL.  Let's not ignore the error.

Note the only exception is inet_autobind(), all of whose callers return
-EAGAIN instead.

Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c              | 4 ++--
 net/ipv4/inet_connection_sock.c | 5 +++--
 net/ipv4/ping.c                 | 2 +-
 net/ipv4/udp.c                  | 2 +-
 net/ipv6/af_inet6.c             | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7f6d7c355e38..4c8782df8eef 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -522,9 +522,9 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	/* Make sure we are allowed to bind here. */
 	if (snum || !(inet->bind_address_no_port ||
 		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
-		if (sk->sk_prot->get_port(sk, snum)) {
+		err = sk->sk_prot->get_port(sk, snum);
+		if (err) {
 			inet->inet_saddr = inet->inet_rcv_saddr = 0;
-			err = -EADDRINUSE;
 			goto out_release_sock;
 		}
 		if (!(flags & BIND_FROM_BPF)) {
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb31c7158b39..971969cc7e17 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1041,7 +1041,7 @@ int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	int err = -EADDRINUSE;
+	int err;
 
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
@@ -1057,7 +1057,8 @@ int inet_csk_listen_start(struct sock *sk)
 	 * after validation is complete.
 	 */
 	inet_sk_state_store(sk, TCP_LISTEN);
-	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
+	err = sk->sk_prot->get_port(sk, inet->inet_num);
+	if (!err) {
 		inet->inet_sport = htons(inet->inet_num);
 
 		sk_dst_reset(sk);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3b2420829c23..948f4801f993 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -142,7 +142,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 
 fail:
 	spin_unlock(&ping_table.lock);
-	return 1;
+	return -EADDRINUSE;
 }
 EXPORT_SYMBOL_GPL(ping_get_port);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c04a26339bd1..7fe0ba3f0933 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -235,7 +235,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 	struct udp_table *udptable = sk->sk_prot->h.udp_table;
 	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
-	int error = 1;
+	int error = -EADDRINUSE;
 
 	if (!snum) {
 		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index dbb1430d6cc2..cceda5c83302 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -403,10 +403,10 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	/* Make sure we are allowed to bind here. */
 	if (snum || !(inet->bind_address_no_port ||
 		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
-		if (sk->sk_prot->get_port(sk, snum)) {
+		err = sk->sk_prot->get_port(sk, snum);
+		if (err) {
 			sk->sk_ipv6only = saved_ipv6only;
 			inet_reset_saddr(sk);
-			err = -EADDRINUSE;
 			goto out;
 		}
 		if (!(flags & BIND_FROM_BPF)) {
-- 
2.35.1



