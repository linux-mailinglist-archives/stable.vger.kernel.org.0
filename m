Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E96ECF1F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjDXNiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjDXNiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B99020
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6234F62412
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A7AC433D2;
        Mon, 24 Apr 2023 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343431;
        bh=HdMHGW7VW/Cww99jtcmdeK7hVAnqo7oV5rE3MltJiJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYsQnDiLehGpaGCtmecoGmP5dvoRKwKkYkQ1zP3ycDnGV7uIq4Qkq/rWRt75424wf
         x0vr/JNBiX+AZ503obBw5nBSOFKBJ2Dp1YhVYvLKF0iGis2B4ix3Ued+Z74E3VZA5P
         3luPEvrAgbcBA0iFlu0y+yUcGbsEBwT0w44BN11k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.14 22/28] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Mon, 24 Apr 2023 15:18:43 +0200
Message-Id: <20230424131122.077625566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
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

commit d38afeec26ed4739c640bf286c270559aab2ba5f upstream.

Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
Add lockless sendmsg() support") added a lockless memory allocation path,
which could cause a memory leak:

setsockopt(IPV6_ADDRFORM)                 sendmsg()
+-----------------------+                 +-------+
- do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
  - sockopt_lock_sock(sk)                   ^._ called via udpv6_prot
    - lock_sock(sk)                             before WRITE_ONCE()
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)
  - inet6_destroy_sock()                    - if (!corkreq)
  - sockopt_release_sock(sk)                  - ip6_make_skb(sk, ...)
    - release_sock(sk)                          ^._ lockless fast path for
                                                    the non-corking case

                                                - __ip6_append_data(sk, ...)
                                                  - ipv6_local_rxpmtu(sk, ...)
                                                    - xchg(&np->rxpmtu, skb)
                                                      ^._ rxpmtu is never freed.

                                                - goto out_no_dst;

                                            - lock_sock(sk)

For now, rxpmtu is only the case, but not to miss the future change
and a similar bug fixed in commit e27326009a3d ("net: ping6: Fix
memleak in ipv6_renew_options()."), let's set a new function to IPv6
sk->sk_destruct() and call inet6_cleanup_sock() there.  Since the
conversion does not change sk->sk_destruct(), we can guarantee that
we can clean up IPv6 resources finally.

We can now remove all inet6_destroy_sock() calls from IPv6 protocol
specific ->destroy() functions, but such changes are invasive to
backport.  So they can be posted as a follow-up later for net-next.

Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h    |    1 +
 include/net/udp.h     |    2 +-
 include/net/udplite.h |    8 --------
 net/ipv4/udp.c        |    9 ++++++---
 net/ipv4/udplite.c    |    8 ++++++++
 net/ipv6/af_inet6.c   |    8 +++++++-
 net/ipv6/udp.c        |   15 ++++++++++++++-
 net/ipv6/udp_impl.h   |    1 +
 net/ipv6/udplite.c    |    9 ++++++++-
 9 files changed, 46 insertions(+), 15 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -943,6 +943,7 @@ void ipv6_local_error(struct sock *sk, i
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
 void inet6_cleanup_sock(struct sock *sk);
+void inet6_sock_destruct(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr, int *uaddr_len,
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -251,7 +251,7 @@ static inline int udp_rqueue_get(struct
 }
 
 /* net/ipv4/udp.c */
-void udp_destruct_sock(struct sock *sk);
+void udp_destruct_common(struct sock *sk);
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
 void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -24,14 +24,6 @@ static __inline__ int udplite_getfrag(vo
 	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
 }
 
-/* Designate sk as UDP-Lite socket */
-static inline int udplite_sk_init(struct sock *sk)
-{
-	udp_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
-	return 0;
-}
-
 /*
  * 	Checksumming routines
  */
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1380,7 +1380,7 @@ drop:
 }
 EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
 
-void udp_destruct_sock(struct sock *sk)
+void udp_destruct_common(struct sock *sk)
 {
 	/* reclaim completely the forward allocated memory */
 	struct udp_sock *up = udp_sk(sk);
@@ -1393,10 +1393,14 @@ void udp_destruct_sock(struct sock *sk)
 		kfree_skb(skb);
 	}
 	udp_rmem_release(sk, total, 0, true);
+}
+EXPORT_SYMBOL_GPL(udp_destruct_common);
 
+static void udp_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
-EXPORT_SYMBOL_GPL(udp_destruct_sock);
 
 int udp_init_sock(struct sock *sk)
 {
@@ -1404,7 +1408,6 @@ int udp_init_sock(struct sock *sk)
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(udp_init_sock);
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -19,6 +19,14 @@
 struct udp_table 	udplite_table __read_mostly;
 EXPORT_SYMBOL(udplite_table);
 
+/* Designate sk as UDP-Lite socket */
+static int udplite_sk_init(struct sock *sk)
+{
+	udp_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplite_rcv(struct sk_buff *skb)
 {
 	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -107,6 +107,12 @@ static __inline__ struct ipv6_pinfo *ine
 	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
 }
 
+void inet6_sock_destruct(struct sock *sk)
+{
+	inet6_cleanup_sock(sk);
+	inet_sock_destruct(sk);
+}
+
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
 {
@@ -199,7 +205,7 @@ lookup_protocol:
 			inet->hdrincl = 1;
 	}
 
-	sk->sk_destruct		= inet_sock_destruct;
+	sk->sk_destruct		= inet6_sock_destruct;
 	sk->sk_family		= PF_INET6;
 	sk->sk_protocol		= protocol;
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -66,6 +66,19 @@ static bool udp6_lib_exact_dif_match(str
 	return false;
 }
 
+static void udpv6_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+int udpv6_init_sock(struct sock *sk)
+{
+	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	sk->sk_destruct = udpv6_destruct_sock;
+	return 0;
+}
+
 static u32 udp6_ehashfn(const struct net *net,
 			const struct in6_addr *laddr,
 			const u16 lport,
@@ -1552,7 +1565,7 @@ struct proto udpv6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udp_init_sock,
+	.init		   = udpv6_init_sock,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -12,6 +12,7 @@ int __udp6_lib_rcv(struct sk_buff *, str
 void __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
 		    __be32, struct udp_table *);
 
+int udpv6_init_sock(struct sock *sk);
 int udp_v6_get_port(struct sock *sk, unsigned short snum);
 
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -14,6 +14,13 @@
 #include <linux/export.h>
 #include "udp_impl.h"
 
+static int udplitev6_sk_init(struct sock *sk)
+{
+	udpv6_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplitev6_rcv(struct sk_buff *skb)
 {
 	return __udp6_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
@@ -39,7 +46,7 @@ struct proto udplitev6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udplite_sk_init,
+	.init		   = udplitev6_sk_init,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,


