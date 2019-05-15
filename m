Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E871ED58
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfEOLIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfEOLI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:08:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 244F020644;
        Wed, 15 May 2019 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918507;
        bh=K6fm4fvYABgpTi7wF0dxNT5efY5YR8ML0YmMa9FRLqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co6lfgH0e9379BpEbDj77T8BtbR6gDm9Y47s0BjWouakV0eZjVEgv6/LyyXXQfDsF
         6rKTFuvbzdAzA3gN2Wix880depp7IZz4gEtfOOFKKFreRkk1H3rxyG51PbQZrEo/Rr
         eNkMHtf/SnYXiBMTRGN6LTqOo7DCBoM9k92vaiy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baozeng Ding <sploving1@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.4 156/266] ipv6: fix a potential deadlock in do_ipv6_setsockopt()
Date:   Wed, 15 May 2019 12:54:23 +0200
Message-Id: <20190515090728.190012520@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 8651be8f14a12d24f203f283601d9b0418c389ff upstream.

Baozeng reported this deadlock case:

       CPU0                    CPU1
       ----                    ----
  lock([  165.136033] sk_lock-AF_INET6);
                               lock([  165.136033] rtnl_mutex);
                               lock([  165.136033] sk_lock-AF_INET6);
  lock([  165.136033] rtnl_mutex);

Similar to commit 87e9f0315952
("ipv4: fix a potential deadlock in mcast getsockopt() path")
this is due to we still have a case, ipv6_sock_mc_close(),
where we acquire sk_lock before rtnl_lock. Close this deadlock
with the similar solution, that is always acquire rtnl lock first.

Fixes: baf606d9c9b1 ("ipv4,ipv6: grab rtnl before locking the socket")
Reported-by: Baozeng Ding <sploving1@gmail.com>
Tested-by: Baozeng Ding <sploving1@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/addrconf.h   |    1 +
 net/ipv6/ipv6_sockglue.c |    3 ++-
 net/ipv6/mcast.c         |   17 ++++++++++++-----
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -162,6 +162,7 @@ int ipv6_sock_mc_join(struct sock *sk, i
 		      const struct in6_addr *addr);
 int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+void __ipv6_sock_mc_close(struct sock *sk);
 void ipv6_sock_mc_close(struct sock *sk);
 bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr);
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -121,6 +121,7 @@ struct ipv6_txoptions *ipv6_update_optio
 static bool setsockopt_needs_rtnl(int optname)
 {
 	switch (optname) {
+	case IPV6_ADDRFORM:
 	case IPV6_ADD_MEMBERSHIP:
 	case IPV6_DROP_MEMBERSHIP:
 	case IPV6_JOIN_ANYCAST:
@@ -199,7 +200,7 @@ static int do_ipv6_setsockopt(struct soc
 			}
 
 			fl6_free_socklist(sk);
-			ipv6_sock_mc_close(sk);
+			__ipv6_sock_mc_close(sk);
 
 			/*
 			 * Sock is moving from IPv6 to IPv4 (sk_prot), so
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -276,16 +276,14 @@ static struct inet6_dev *ip6_mc_find_dev
 	return idev;
 }
 
-void ipv6_sock_mc_close(struct sock *sk)
+void __ipv6_sock_mc_close(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
 
-	if (!rcu_access_pointer(np->ipv6_mc_list))
-		return;
+	ASSERT_RTNL();
 
-	rtnl_lock();
 	while ((mc_lst = rtnl_dereference(np->ipv6_mc_list)) != NULL) {
 		struct net_device *dev;
 
@@ -303,8 +301,17 @@ void ipv6_sock_mc_close(struct sock *sk)
 
 		atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
 		kfree_rcu(mc_lst, rcu);
-
 	}
+}
+
+void ipv6_sock_mc_close(struct sock *sk)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	if (!rcu_access_pointer(np->ipv6_mc_list))
+		return;
+	rtnl_lock();
+	__ipv6_sock_mc_close(sk);
 	rtnl_unlock();
 }
 


