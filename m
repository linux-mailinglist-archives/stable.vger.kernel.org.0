Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB1C1DDB65
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgEUX54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgEUX54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:57:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA2DC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y7so7270044ybj.15
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SqxOE+9wT9bCDyiiANOmvuVw5V5WdLRN81dGOQgBRMU=;
        b=Ez+zqwBQSBo8ttL7BI+SVaEvfobE1o4Vvj2bxjAuiwVhIQV84fPGmEvXPHEHpdu2vz
         ld6W5rpGxdg+Gc7ZeIAzTwkIsI/9zBGxGTxi89lURBkTJbIPWKXLPs+0iA/OV3mC5D8D
         FFQZrGEMdAwJr9TS9XgA7wFMO1irsKlEM9W09Ql8LpGbpu8qIXE/AmHjG3I31L4aqGwU
         d2+Z79UAL3yvx0KexLKrxgTO2Yczso6Cl6ph2HPs7XurqH71wd8kk1Yey+izsh4iV93e
         XY2jlvx/nDzW810q7WJhwpa0i4Z2z/Y/TuzKDd1h+OlnFa5FqCyCalY4sfBFS2cDTE8v
         4/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SqxOE+9wT9bCDyiiANOmvuVw5V5WdLRN81dGOQgBRMU=;
        b=DxMmzGkpEH/7I1Nd0Np+tOYz9N7N8s9DCBEP5RTEWwxsX0Os47JweVdL9Yr+QYCw14
         Pp6g7Jin5WIOps1HEmNwe1K6SW/teD4lDMlBcwGi+2+EMIjn2KZUi/uUJxXnpK0PFzB7
         rOwYSbMPWIx1VP9ziZW0Vt7/5XMb9eeFE2jfDQobzhVbem7jVEGS96l9fx9bDjOH/AnN
         ZX6tbVwaSxPE4m7/ko+c1Ou8/PDfjS4bJQ7seZY6HPWn0Rgj/hdsDQJYQpLBO7Bzb6AB
         Z5YCv2fxPM5DFXMLIHY8cN6yel0MDikg/vZ1/10isZX6eVMAhJLsUAFpsIJFNk6eVA7L
         SrWg==
X-Gm-Message-State: AOAM530kr6FqPyxgEtrCQOc9xvTkUtj+Iqqs6jmUSMQCj4Z/zxd/lxsD
        MVteCHcWK/pMMH2+GrUgJvfd4elRerjnRA==
X-Google-Smtp-Source: ABdhPJxqi8+SghDFWbalyH03Km6jyC671K9FfvKIsIKxAksSTJz13uAFCH8eUN/TJptE8OLaSz0uuBOoVVfYng==
X-Received: by 2002:a05:6902:6d1:: with SMTP id m17mr19964040ybt.372.1590105475123;
 Thu, 21 May 2020 16:57:55 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:14 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-2-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 01/27] l2tp: lock socket before checking flags in connect()
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

commit 0382a25af3c771a8e4d5e417d1834cbe28c2aaac upstream.

Socket flags aren't updated atomically, so the socket must be locked
while reading the SOCK_ZAPPED flag.

This issue exists for both l2tp_ip and l2tp_ip6. For IPv6, this patch
also brings error handling for __ip6_datagram_connect() failures.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 include/net/ipv6.h  |  2 ++
 net/ipv6/datagram.c |  4 +++-
 net/l2tp/l2tp_ip.c  | 19 ++++++++++++-------
 net/l2tp/l2tp_ip6.c | 16 +++++++++++-----
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 6258264a0bf7..94880f07bc06 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -915,6 +915,8 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen);
 
+int __ip6_datagram_connect(struct sock *sk, struct sockaddr *addr,
+			   int addr_len);
 int ip6_datagram_connect(struct sock *sk, struct sockaddr *addr, int addr_len);
 int ip6_datagram_connect_v6_only(struct sock *sk, struct sockaddr *addr,
 				 int addr_len);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index f33154365b64..389b6367a810 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -40,7 +40,8 @@ static bool ipv6_mapped_addr_any(const struct in6_addr *a)
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
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 58f87bdd12c7..fab122cc6aac 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -321,21 +321,24 @@ static int l2tp_ip_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
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
@@ -343,7 +346,9 @@ static int l2tp_ip_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	sk_add_bind_node(sk, &l2tp_ip_bind_table);
 	write_unlock_bh(&l2tp_ip_lock);
 
+out_sk:
 	release_sock(sk);
+
 	return rc;
 }
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2b5230ef8536..59e609f2db64 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -383,9 +383,6 @@ static int l2tp_ip6_connect(struct sock *sk, struct sockaddr *uaddr,
 	int	addr_type;
 	int rc;
 
-	if (sock_flag(sk, SOCK_ZAPPED)) /* Must bind first - autobinding does not work */
-		return -EINVAL;
-
 	if (addr_len < sizeof(*lsa))
 		return -EINVAL;
 
@@ -402,10 +399,18 @@ static int l2tp_ip6_connect(struct sock *sk, struct sockaddr *uaddr,
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
@@ -413,6 +418,7 @@ static int l2tp_ip6_connect(struct sock *sk, struct sockaddr *uaddr,
 	sk_add_bind_node(sk, &l2tp_ip6_bind_table);
 	write_unlock_bh(&l2tp_ip6_lock);
 
+out_sk:
 	release_sock(sk);
 
 	return rc;
-- 
2.27.0.rc0.183.gde8f92d652-goog

