Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C056ECD42
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjDXNVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjDXNVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D74C1F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B53162218
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7E6C4339B;
        Mon, 24 Apr 2023 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342491;
        bh=9d9GEENHWJfdbU11UJXFJMpSGN5RKmIq64s1rACX3yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tazeiP94zUYHiTCBaVV7ub/i+amqGW9cnKqik2t5eoOmJFR1jDYvaxnryeGhvMwe4
         /9KUxD/ctXlpqlA7Eq99mi7i83DDqw17Sejm7zJtq1k+GovgFqy5j2hWA7eS2Q18rt
         7+HCHvwO1blOk5D34TgJPG9RhIaMEZo3ca5zmSN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 5.15 60/73] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
Date:   Mon, 24 Apr 2023 15:17:14 +0200
Message-Id: <20230424131131.275236016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit b5fc29233d28be7a3322848ebe73ac327559cdb9 upstream.

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

Now we can remove unnecessary inet6_destroy_sock() calls in
sk->sk_prot->destroy().

DCCP and SCTP have their own sk->sk_destruct() function, so we
change them separately in the following patches.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ping.c      |    6 ------
 net/ipv6/raw.c       |    2 --
 net/ipv6/tcp_ipv6.c  |    8 +-------
 net/ipv6/udp.c       |    2 --
 net/l2tp/l2tp_ip6.c  |    2 --
 net/mptcp/protocol.c |    7 -------
 6 files changed, 1 insertion(+), 26 deletions(-)

--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -22,11 +22,6 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
-static void ping_v6_destroy(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
-
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -171,7 +166,6 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
-	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1211,8 +1211,6 @@ static void raw6_destroy(struct sock *sk
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
 	release_sock(sk);
-
-	inet6_destroy_sock(sk);
 }
 
 static int rawv6_init_sk(struct sock *sk)
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1972,12 +1972,6 @@ static int tcp_v6_init_sock(struct sock
 	return 0;
 }
 
-static void tcp_v6_destroy_sock(struct sock *sk)
-{
-	tcp_v4_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 #ifdef CONFIG_PROC_FS
 /* Proc filesystem TCPv6 sock list dumping. */
 static void get_openreq6(struct seq_file *seq,
@@ -2170,7 +2164,7 @@ struct proto tcpv6_prot = {
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
 	.init			= tcp_v6_init_sock,
-	.destroy		= tcp_v6_destroy_sock,
+	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1649,8 +1649,6 @@ void udpv6_destroy_sock(struct sock *sk)
 			udp_encap_disable();
 		}
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -255,8 +255,6 @@ static void l2tp_ip6_destroy_sock(struct
 
 	if (tunnel)
 		l2tp_tunnel_delete(tunnel);
-
-	inet6_destroy_sock(sk);
 }
 
 static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3621,12 +3621,6 @@ static const struct proto_ops mptcp_v6_s
 
 static struct proto mptcp_v6_prot;
 
-static void mptcp_v6_destroy(struct sock *sk)
-{
-	mptcp_destroy(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct inet_protosw mptcp_v6_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
@@ -3642,7 +3636,6 @@ int __init mptcp_proto_v6_init(void)
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
-	mptcp_v6_prot.destroy = mptcp_v6_destroy;
 	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
 
 	err = proto_register(&mptcp_v6_prot, 1);


