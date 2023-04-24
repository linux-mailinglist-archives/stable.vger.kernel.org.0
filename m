Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE016ECF13
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjDXNiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjDXNhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310601993
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11EC1623D8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2502EC433EF;
        Mon, 24 Apr 2023 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343434;
        bh=IQzi1+CLKGx2LrvcpgzmyHuYhH0dnfabATDXje/dBaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuexaKf3+qui65ik4u+AMKzk8cBiB40M7yppxznCwkj6czB0m1eb0lATHkGAQrpuz
         KSzNDa0XSUB/nPFdYgtCW4xJpeqf0SoZJOyje9ceXgdlPo0cVbO6FJNbDdHtGDPnm+
         cddwfwnVeJrFiW2VpQJPfhdtDJKcGK4xUvecA+/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.14 23/28] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
Date:   Mon, 24 Apr 2023 15:18:44 +0200
Message-Id: <20230424131122.115143039@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 net/ipv6/ping.c     |    6 ------
 net/ipv6/raw.c      |    2 --
 net/ipv6/tcp_ipv6.c |    8 +-------
 net/ipv6/udp.c      |    2 --
 net/l2tp/l2tp_ip6.c |    2 --
 5 files changed, 1 insertion(+), 19 deletions(-)

--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -26,11 +26,6 @@
 #include <net/transp_v6.h>
 #include <net/ping.h>
 
-static void ping_v6_destroy(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
-
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -178,7 +173,6 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
-	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1258,8 +1258,6 @@ static void raw6_destroy(struct sock *sk
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
 	release_sock(sk);
-
-	inet6_destroy_sock(sk);
 }
 
 static int rawv6_init_sk(struct sock *sk)
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1754,12 +1754,6 @@ static int tcp_v6_init_sock(struct sock
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
@@ -1953,7 +1947,7 @@ struct proto tcpv6_prot = {
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
@@ -1459,8 +1459,6 @@ void udpv6_destroy_sock(struct sock *sk)
 		if (encap_destroy)
 			encap_destroy(sk);
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -277,8 +277,6 @@ static void l2tp_ip6_destroy_sock(struct
 		l2tp_tunnel_closeall(tunnel);
 		sock_put(sk);
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)


