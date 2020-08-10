Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB22924095B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgHJPaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbgHJPaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012B820791;
        Mon, 10 Aug 2020 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073419;
        bh=6LDwZ9MemVioxkevWcJgVIU5tf4B02bHCyvyWRpJXq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLRoI7tvVUTtfGSgT+GuTRbOupKfkvbG/Zg/tyxmHtCKaIoNS5hsunenUs2frLDIA
         i9t0jD+WAWRtpVpt8lXKzga3ymDInyQePcboi1eou8I6F5L7wmEEr5DcNvlNwzKUvK
         AxtRRvFFEI4aRjGa7uW1ufH7JuEUvu7wEtN7p6ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ch3332xr@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 33/48] ipv6: fix memory leaks on IPV6_ADDRFORM path
Date:   Mon, 10 Aug 2020 17:21:55 +0200
Message-Id: <20200810151805.844634203@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 8c0de6e96c9794cb523a516c465991a70245da1c ]

IPV6_ADDRFORM causes resource leaks when converting an IPv6 socket
to IPv4, particularly struct ipv6_ac_socklist. Similar to
struct ipv6_mc_socklist, we should just close it on this path.

This bug can be easily reproduced with the following C program:

  #include <stdio.h>
  #include <string.h>
  #include <sys/types.h>
  #include <sys/socket.h>
  #include <arpa/inet.h>

  int main()
  {
    int s, value;
    struct sockaddr_in6 addr;
    struct ipv6_mreq m6;

    s = socket(AF_INET6, SOCK_DGRAM, 0);
    addr.sin6_family = AF_INET6;
    addr.sin6_port = htons(5000);
    inet_pton(AF_INET6, "::ffff:192.168.122.194", &addr.sin6_addr);
    connect(s, (struct sockaddr *)&addr, sizeof(addr));

    inet_pton(AF_INET6, "fe80::AAAA", &m6.ipv6mr_multiaddr);
    m6.ipv6mr_interface = 5;
    setsockopt(s, SOL_IPV6, IPV6_JOIN_ANYCAST, &m6, sizeof(m6));

    value = AF_INET;
    setsockopt(s, SOL_IPV6, IPV6_ADDRFORM, &value, sizeof(value));

    close(s);
    return 0;
  }

Reported-by: ch3332xr@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/addrconf.h   |    1 +
 net/ipv6/anycast.c       |   17 ++++++++++++-----
 net/ipv6/ipv6_sockglue.c |    1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -305,6 +305,7 @@ int ipv6_sock_ac_join(struct sock *sk, i
 		      const struct in6_addr *addr);
 int ipv6_sock_ac_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+void __ipv6_sock_ac_close(struct sock *sk);
 void ipv6_sock_ac_close(struct sock *sk);
 
 int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr);
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -173,7 +173,7 @@ int ipv6_sock_ac_drop(struct sock *sk, i
 	return 0;
 }
 
-void ipv6_sock_ac_close(struct sock *sk)
+void __ipv6_sock_ac_close(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net_device *dev = NULL;
@@ -181,10 +181,7 @@ void ipv6_sock_ac_close(struct sock *sk)
 	struct net *net = sock_net(sk);
 	int	prev_index;
 
-	if (!np->ipv6_ac_list)
-		return;
-
-	rtnl_lock();
+	ASSERT_RTNL();
 	pac = np->ipv6_ac_list;
 	np->ipv6_ac_list = NULL;
 
@@ -201,6 +198,16 @@ void ipv6_sock_ac_close(struct sock *sk)
 		sock_kfree_s(sk, pac, sizeof(*pac));
 		pac = next;
 	}
+}
+
+void ipv6_sock_ac_close(struct sock *sk)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	if (!np->ipv6_ac_list)
+		return;
+	rtnl_lock();
+	__ipv6_sock_ac_close(sk);
 	rtnl_unlock();
 }
 
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -207,6 +207,7 @@ static int do_ipv6_setsockopt(struct soc
 
 			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
+			__ipv6_sock_ac_close(sk);
 
 			/*
 			 * Sock is moving from IPv6 to IPv4 (sk_prot), so


