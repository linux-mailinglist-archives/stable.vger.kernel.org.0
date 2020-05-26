Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5DD1E2F19
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389705AbgEZTdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389678AbgEZSz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0155D208B8;
        Tue, 26 May 2020 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519355;
        bh=kBSF++gb6m4kTRiXsle1v76F4W+mwBGYsEFJVJcd0dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0H8tOPrnmvs964ksSHKXaiVwIeNELiOv/M+zj4F6imOu82b/pOJrMHJE3TPZSBnkz
         jI6NcN7PSiIsV/vTeo0DyPI/BHJTbmaiNPXJ1nZBkObjpiLQ0un5PhYLe75qpizoEE
         zo1KG10csjxunPIBPEPNfgvXsSKnYUPL6b4/kfq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 35/65] l2tp: fix racy socket lookup in l2tp_ip and l2tp_ip6 bind()
Date:   Tue, 26 May 2020 20:52:54 +0200
Message-Id: <20200526183918.432782150@linuxfoundation.org>
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

commit d5e3a190937a1e386671266202c62565741f0f1a upstream.

It's not enough to check for sockets bound to same address at the
beginning of l2tp_ip{,6}_bind(): even if no socket is found at that
time, a socket with the same address could be bound before we take
the l2tp lock again.

This patch moves the lookup right before inserting the new socket, so
that no change can ever happen to the list between address lookup and
socket insertion.

Care is taken to avoid side effects on the socket in case of failure.
That is, modifications of the socket are done after the lookup, when
binding is guaranteed to succeed, and before releasing the l2tp lock,
so that concurrent lookups will always see fully initialised sockets.

For l2tp_ip, 'ret' is set to -EINVAL before checking the SOCK_ZAPPED
bit. Error code was mistakenly set to -EADDRINUSE on error by commit
32c231164b76 ("l2tp: fix racy SOCK_ZAPPED flag check in l2tp_ip{,6}_bind()").
Using -EINVAL restores original behaviour.

For l2tp_ip6, the lookup is now always done with the correct bound
device. Before this patch, when binding to a link-local address, the
lookup was done with the original sk->sk_bound_dev_if, which was later
overwritten with addr->l2tp_scope_id. Lookup is now performed with the
final sk->sk_bound_dev_if value.

Finally, the (addr_len >= sizeof(struct sockaddr_in6)) check has been
dropped: addr is a sockaddr_l2tpip6 not sockaddr_in6 and addr_len has
already been checked at this point (this part of the code seems to have
been copy-pasted from net/ipv6/raw.c).

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip.c  |   27 ++++++++++++---------------
 net/l2tp/l2tp_ip6.c |   43 ++++++++++++++++++++-----------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -269,15 +269,9 @@ static int l2tp_ip_bind(struct sock *sk,
 	if (addr->l2tp_family != AF_INET)
 		return -EINVAL;
 
-	ret = -EADDRINUSE;
-	read_lock_bh(&l2tp_ip_lock);
-	if (__l2tp_ip_bind_lookup(net, addr->l2tp_addr.s_addr,
-				  sk->sk_bound_dev_if, addr->l2tp_conn_id))
-		goto out_in_use;
-
-	read_unlock_bh(&l2tp_ip_lock);
-
 	lock_sock(sk);
+
+	ret = -EINVAL;
 	if (!sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 
@@ -294,14 +288,22 @@ static int l2tp_ip_bind(struct sock *sk,
 		inet->inet_rcv_saddr = inet->inet_saddr = addr->l2tp_addr.s_addr;
 	if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
 		inet->inet_saddr = 0;  /* Use device */
-	sk_dst_reset(sk);
 
+	write_lock_bh(&l2tp_ip_lock);
+	if (__l2tp_ip_bind_lookup(net, addr->l2tp_addr.s_addr,
+				  sk->sk_bound_dev_if, addr->l2tp_conn_id)) {
+		write_unlock_bh(&l2tp_ip_lock);
+		ret = -EADDRINUSE;
+		goto out;
+	}
+
+	sk_dst_reset(sk);
 	l2tp_ip_sk(sk)->conn_id = addr->l2tp_conn_id;
 
-	write_lock_bh(&l2tp_ip_lock);
 	sk_add_bind_node(sk, &l2tp_ip_bind_table);
 	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip_lock);
+
 	ret = 0;
 	sock_reset_flag(sk, SOCK_ZAPPED);
 
@@ -309,11 +311,6 @@ out:
 	release_sock(sk);
 
 	return ret;
-
-out_in_use:
-	read_unlock_bh(&l2tp_ip_lock);
-
-	return ret;
 }
 
 static int l2tp_ip_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -278,6 +278,7 @@ static int l2tp_ip6_bind(struct sock *sk
 	struct sockaddr_l2tpip6 *addr = (struct sockaddr_l2tpip6 *) uaddr;
 	struct net *net = sock_net(sk);
 	__be32 v4addr = 0;
+	int bound_dev_if;
 	int addr_type;
 	int err;
 
@@ -296,13 +297,6 @@ static int l2tp_ip6_bind(struct sock *sk
 	if (addr_type & IPV6_ADDR_MULTICAST)
 		return -EADDRNOTAVAIL;
 
-	err = -EADDRINUSE;
-	read_lock_bh(&l2tp_ip6_lock);
-	if (__l2tp_ip6_bind_lookup(net, &addr->l2tp_addr,
-				   sk->sk_bound_dev_if, addr->l2tp_conn_id))
-		goto out_in_use;
-	read_unlock_bh(&l2tp_ip6_lock);
-
 	lock_sock(sk);
 
 	err = -EINVAL;
@@ -312,28 +306,25 @@ static int l2tp_ip6_bind(struct sock *sk
 	if (sk->sk_state != TCP_CLOSE)
 		goto out_unlock;
 
+	bound_dev_if = sk->sk_bound_dev_if;
+
 	/* Check if the address belongs to the host. */
 	rcu_read_lock();
 	if (addr_type != IPV6_ADDR_ANY) {
 		struct net_device *dev = NULL;
 
 		if (addr_type & IPV6_ADDR_LINKLOCAL) {
-			if (addr_len >= sizeof(struct sockaddr_in6) &&
-			    addr->l2tp_scope_id) {
-				/* Override any existing binding, if another
-				 * one is supplied by user.
-				 */
-				sk->sk_bound_dev_if = addr->l2tp_scope_id;
-			}
+			if (addr->l2tp_scope_id)
+				bound_dev_if = addr->l2tp_scope_id;
 
 			/* Binding to link-local address requires an
-			   interface */
-			if (!sk->sk_bound_dev_if)
+			 * interface.
+			 */
+			if (!bound_dev_if)
 				goto out_unlock_rcu;
 
 			err = -ENODEV;
-			dev = dev_get_by_index_rcu(sock_net(sk),
-						   sk->sk_bound_dev_if);
+			dev = dev_get_by_index_rcu(sock_net(sk), bound_dev_if);
 			if (!dev)
 				goto out_unlock_rcu;
 		}
@@ -348,13 +339,22 @@ static int l2tp_ip6_bind(struct sock *sk
 	}
 	rcu_read_unlock();
 
-	inet->inet_rcv_saddr = inet->inet_saddr = v4addr;
+	write_lock_bh(&l2tp_ip6_lock);
+	if (__l2tp_ip6_bind_lookup(net, &addr->l2tp_addr, bound_dev_if,
+				   addr->l2tp_conn_id)) {
+		write_unlock_bh(&l2tp_ip6_lock);
+		err = -EADDRINUSE;
+		goto out_unlock;
+	}
+
+	inet->inet_saddr = v4addr;
+	inet->inet_rcv_saddr = v4addr;
+	sk->sk_bound_dev_if = bound_dev_if;
 	sk->sk_v6_rcv_saddr = addr->l2tp_addr;
 	np->saddr = addr->l2tp_addr;
 
 	l2tp_ip6_sk(sk)->conn_id = addr->l2tp_conn_id;
 
-	write_lock_bh(&l2tp_ip6_lock);
 	sk_add_bind_node(sk, &l2tp_ip6_bind_table);
 	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip6_lock);
@@ -367,10 +367,7 @@ out_unlock_rcu:
 	rcu_read_unlock();
 out_unlock:
 	release_sock(sk);
-	return err;
 
-out_in_use:
-	read_unlock_bh(&l2tp_ip6_lock);
 	return err;
 }
 


