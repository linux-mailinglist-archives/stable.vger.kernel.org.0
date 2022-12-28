Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC25657DB5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiL1PqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiL1PqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:46:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C25140DE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA16B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8ACC433D2;
        Wed, 28 Dec 2022 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242362;
        bh=dMN3mDJHdHHc0Uv2YB6+Od/AoKfI03wz+7ALCv0+LfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGedbbF0ltYLsQYmaYJPLlQIPIEztvfuUl7usLA7l9AmCo+1lEGy5/XXKFbwDOZtx
         qgLYF3YpRyzFjSdnteWW2xeOi9DiTkMEAjbUlfi47a/HuqgXnmNXNCinevF+uYb2g8
         SLxR1aTpHe51iP4tA6c74ujmx62AsuMlZHeHREYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0361/1146] net: Return errno in sk->sk_prot->get_port().
Date:   Wed, 28 Dec 2022 15:31:40 +0100
Message-Id: <20221228144339.969733443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
 net/ipv4/inet_connection_sock.c | 7 ++++---
 net/ipv4/ping.c                 | 2 +-
 net/ipv4/udp.c                  | 2 +-
 net/ipv6/af_inet6.c             | 4 ++--
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0da679411330..92d423786251 100644
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
index 4e84ed21d16f..4a34bc7cb15e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -471,11 +471,11 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 	bool found_port = false, check_bind_conflict = true;
 	bool bhash_created = false, bhash2_created = false;
+	int ret = -EADDRINUSE, port = snum, l3mdev;
 	struct inet_bind_hashbucket *head, *head2;
 	struct inet_bind2_bucket *tb2 = NULL;
 	struct inet_bind_bucket *tb = NULL;
 	bool head2_lock_acquired = false;
-	int ret = 1, port = snum, l3mdev;
 	struct net *net = sock_net(sk);
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
@@ -1186,7 +1186,7 @@ int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	int err = -EADDRINUSE;
+	int err;
 
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
@@ -1202,7 +1202,8 @@ int inet_csk_listen_start(struct sock *sk)
 	 * after validation is complete.
 	 */
 	inet_sk_state_store(sk, TCP_LISTEN);
-	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
+	err = sk->sk_prot->get_port(sk, inet->inet_num);
+	if (!err) {
 		inet->inet_sport = htons(inet->inet_num);
 
 		sk_dst_reset(sk);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 04b4ec07bb06..409ec2a1f95b 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -143,7 +143,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 
 fail:
 	spin_unlock(&ping_table.lock);
-	return 1;
+	return -EADDRINUSE;
 }
 EXPORT_SYMBOL_GPL(ping_get_port);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 83fdd2b8afd6..2eaf47e23b22 100644
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
index 024191004982..7b0cd54da452 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -409,10 +409,10 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
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



