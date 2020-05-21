Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BACF1DDB66
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgEUX56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:57:58 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0343DC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l1so6823313qvy.20
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JUnK4uHzxGkcMfn74KMNGXdUE6scgu7Pybx5TjW9L4I=;
        b=UIKVZD0oxUOFQLrnlHSjPTvX5fJ2WhWiTw9l5uM2fVHk/Oo0+XiaWI8RkkV3JeT1vF
         QSUIgSev/+H/IBIuINNWWsrYQ//kYqHbqXORbMOT2xjCJGeZIMkOLmImiDgbQGoTySHz
         7ewI3CYDDV3rI+HqopBrIGMFQxWiizOPyO9FOMbaHE97eIYy8JchsE2CyDicUtfExRB+
         q6u2rHB13j1/GFiAxeMk8Ph9h+Z+Rcr411yRTZJ/BQi0Adg/kUUiPyADNj9v4pRTqSkK
         d7w59G4ZzdtCm4sJQKbkHc8CHp26amc4w2HIHpKFAYsgoASF4aLUUEKu8aD8Vf4Nu+5O
         2S1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JUnK4uHzxGkcMfn74KMNGXdUE6scgu7Pybx5TjW9L4I=;
        b=BWOSbAHLEWsoS1ATrpmlF1dBZx3bQB/+fnwv+D1bJiE/jJeEt0wJx7szB/UPE5G7RR
         ePV9rD36Dk9NA1YaIm9p/DFCL9YTxHTi0/rIGrovQeKdJwOillLohjTA6cHOL1DXD1Oa
         1OaaRes6zOnE5Yj51ozy7612BhIgT1jyKbzgvrmtR4UPbiK6z7HVBQ+TflFsRbjjzx9q
         Rpjqx3gQK+mVKyIC9uAL2l9eg+ApWnFkiwFOZ2E68gyA1FG+gVAyc9Uxm/YG31qvKee/
         uigfUl8H/of1/A+8XSxDnNLMXNmTTYNQMz+6LarMoUMWbLyt4ZLLycTF+YLFEHeuab2X
         /U5w==
X-Gm-Message-State: AOAM531j+p47GxA9+8NssxPhdcNQFTHTkkX+0Tc29FrzcnqCFKwA6V59
        FylWIsE/hkkkIFamJmjUpje2DS15jmPY7Q==
X-Google-Smtp-Source: ABdhPJyaJklYWLq2sUVe6xuATLdfU4UPh6Ow83nR026PkGF65tfHsAmcXP7hOLiqPk2L8tTSBaMPIaapBaIqXw==
X-Received: by 2002:ad4:408b:: with SMTP id l11mr1294207qvp.156.1590105477130;
 Thu, 21 May 2020 16:57:57 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:15 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-3-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 02/27] l2tp: fix racy socket lookup in l2tp_ip and l2tp_ip6 bind()
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
 net/l2tp/l2tp_ip.c  | 27 ++++++++++++---------------
 net/l2tp/l2tp_ip6.c | 43 ++++++++++++++++++++-----------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index fab122cc6aac..2a77732c6496 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -269,15 +269,9 @@ static int l2tp_ip_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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
 
@@ -294,25 +288,28 @@ static int l2tp_ip_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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
 
 out:
 	release_sock(sk);
 
-	return ret;
-
-out_in_use:
-	read_unlock_bh(&l2tp_ip_lock);
-
 	return ret;
 }
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 59e609f2db64..4d4561dd4023 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -278,6 +278,7 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	struct sockaddr_l2tpip6 *addr = (struct sockaddr_l2tpip6 *) uaddr;
 	struct net *net = sock_net(sk);
 	__be32 v4addr = 0;
+	int bound_dev_if;
 	int addr_type;
 	int err;
 
@@ -296,13 +297,6 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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
@@ -312,28 +306,25 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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
@@ -348,13 +339,22 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

