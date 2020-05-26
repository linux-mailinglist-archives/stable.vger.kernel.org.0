Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCE1E2F12
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389675AbgEZSzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389671AbgEZSzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830232086A;
        Tue, 26 May 2020 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519353;
        bh=NOUY2cFAxW4NOpv/x7vgV6FUGdxcy+oqZ/7YtptmUIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL+EsfELdovadTz759QINdor245D5BTQ0UsNIvvO4L6bRMyzrhzEE3oBGbciiu2KQ
         23GN93SvgsOjxv1s9Mrbwx9yCrnj7MWVxHthYwFlIZ9jrOXX17egzV+H6OohT1Vo+Z
         A22r3kR2pWejRYWx3kQODCwW0lmoSFg/+HkBvN78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 34/65] l2tp: lock socket before checking flags in connect()
Date:   Tue, 26 May 2020 20:52:53 +0200
Message-Id: <20200526183918.173764337@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 0382a25af3c771a8e4d5e417d1834cbe28c2aaac upstream.

Socket flags aren't updated atomically, so the socket must be locked
while reading the SOCK_ZAPPED flag.

This issue exists for both l2tp_ip and l2tp_ip6. For IPv6, this patch
also brings error handling for __ip6_datagram_connect() failures.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h  |    2 ++
 net/ipv6/datagram.c |    4 +++-
 net/l2tp/l2tp_ip.c  |   19 ++++++++++++-------
 net/l2tp/l2tp_ip6.c |   16 +++++++++++-----
 4 files changed, 28 insertions(+), 13 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -915,6 +915,8 @@ int compat_ipv6_setsockopt(struct sock *
 int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen);
 
+int __ip6_datagram_connect(struct sock *sk, struct sockaddr *addr,
+			   int addr_len);
 int ip6_datagram_connect(struct sock *sk, struct sockaddr *addr, int addr_len);
 int ip6_datagram_connect_v6_only(struct sock *sk, struct sockaddr *addr,
 				 int addr_len);
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -40,7 +40,8 @@ static bool ipv6_mapped_addr_any(const s
 	return ipv6_addr_v4mapped(a) && (a->s6_addr32[3] == 0);
 }
 
-static int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
+int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
+			   int addr_len)
 {
 	struct sockaddr_in6	*usin = (struct sockaddr_in6 *) uaddr;
 	struct inet_sock	*inet = inet_sk(sk);
@@ -213,6 +214,7 @@ out:
 	fl6_sock_release(flowlabel);
 	return err;
 }
+EXPORT_SYMBOL_GPL(__ip6_datagram_connect);
 
 int ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -321,21 +321,24 @@ static int l2tp_ip_connect(struct sock *
 	struct sockaddr_l2tpip *lsa = (struct sockaddr_l2tpip *) uaddr;
 	int rc;
 
-	if (sock_flag(sk, SOCK_ZAPPED)) /* Must bind first - autobinding does not work */
-		return -EINVAL;
-
 	if (addr_len < sizeof(*lsa))
 		return -EINVAL;
 
 	if (ipv4_is_multicast(lsa->l2tp_addr.s_addr))
 		return -EINVAL;
 
-	rc = ip4_datagram_connect(sk, uaddr, addr_len);
-	if (rc < 0)
-		return rc;
-
 	lock_sock(sk);
 
+	/* Must bind first - autobinding does not work */
+	if (sock_flag(sk, SOCK_ZAPPED)) {
+		rc = -EINVAL;
+		goto out_sk;
+	}
+
+	rc = __ip4_datagram_connect(sk, uaddr, addr_len);
+	if (rc < 0)
+		goto out_sk;
+
 	l2tp_ip_sk(sk)->peer_conn_id = lsa->l2tp_conn_id;
 
 	write_lock_bh(&l2tp_ip_lock);
@@ -343,7 +346,9 @@ static int l2tp_ip_connect(struct sock *
 	sk_add_bind_node(sk, &l2tp_ip_bind_table);
 	write_unlock_bh(&l2tp_ip_lock);
 
+out_sk:
 	release_sock(sk);
+
 	return rc;
 }
 
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -383,9 +383,6 @@ static int l2tp_ip6_connect(struct sock
 	int	addr_type;
 	int rc;
 
-	if (sock_flag(sk, SOCK_ZAPPED)) /* Must bind first - autobinding does not work */
-		return -EINVAL;
-
 	if (addr_len < sizeof(*lsa))
 		return -EINVAL;
 
@@ -402,10 +399,18 @@ static int l2tp_ip6_connect(struct sock
 			return -EINVAL;
 	}
 
-	rc = ip6_datagram_connect(sk, uaddr, addr_len);
-
 	lock_sock(sk);
 
+	 /* Must bind first - autobinding does not work */
+	if (sock_flag(sk, SOCK_ZAPPED)) {
+		rc = -EINVAL;
+		goto out_sk;
+	}
+
+	rc = __ip6_datagram_connect(sk, uaddr, addr_len);
+	if (rc < 0)
+		goto out_sk;
+
 	l2tp_ip6_sk(sk)->peer_conn_id = lsa->l2tp_conn_id;
 
 	write_lock_bh(&l2tp_ip6_lock);
@@ -413,6 +418,7 @@ static int l2tp_ip6_connect(struct sock
 	sk_add_bind_node(sk, &l2tp_ip6_bind_table);
 	write_unlock_bh(&l2tp_ip6_lock);
 
+out_sk:
 	release_sock(sk);
 
 	return rc;


