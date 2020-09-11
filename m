Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22E02666AA
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIKRbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgIKMze (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C8B922227;
        Fri, 11 Sep 2020 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828888;
        bh=8aGgTX7eJGwE5iNADZQgP2zo6D2f/WaG6nmMoTRNV/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7NxxEUSguU699UDRAmeH5a81NLR9tP2Biu+F4QY48vkPojaT/x/zMGcYY+rGWqC3
         lJPLpgt2+0ivnmvg4l8Z/m+ioRc18lhdWDR+KHLGm6b3sgsYhbXFDOhsRjotoYMez2
         zvVikeksGicjvZ6o2RQwyjhYpP2KpjyHkG/emsFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 45/62] net: refactor bind_bucket fastreuse into helper
Date:   Fri, 11 Sep 2020 14:46:28 +0200
Message-Id: <20200911122504.641002023@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Froidcoeur <tim.froidcoeur@tessares.net>

commit 62ffc589abb176821662efc4525ee4ac0b9c3894 upstream.

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_connection_sock.h |    4 +++
 net/ipv4/inet_connection_sock.c    |   46 ++++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 18 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -319,5 +319,9 @@ int inet_csk_compat_getsockopt(struct so
 int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
 			       char __user *optval, unsigned int optlen);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 #endif /* _INET_CONNECTION_SOCK_H */
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -87,6 +87,31 @@ int inet_csk_bind_conflict(const struct
 }
 EXPORT_SYMBOL_GPL(inet_csk_bind_conflict);
 
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk)
+{
+	kuid_t uid = sock_i_uid(sk);
+
+	if (hlist_empty(&tb->owners)) {
+		if (sk->sk_reuse && sk->sk_state != TCP_LISTEN)
+			tb->fastreuse = 1;
+		else
+			tb->fastreuse = 0;
+		if (sk->sk_reuseport) {
+			tb->fastreuseport = 1;
+			tb->fastuid = uid;
+		} else
+			tb->fastreuseport = 0;
+	} else {
+		if (tb->fastreuse &&
+		    (!sk->sk_reuse || sk->sk_state == TCP_LISTEN))
+			tb->fastreuse = 0;
+		if (tb->fastreuseport &&
+		    (!sk->sk_reuseport || !uid_eq(tb->fastuid, uid)))
+			tb->fastreuseport = 0;
+	}
+}
+
 /* Obtain a reference to a local port for the given sock,
  * if snum is zero it means select any available local port.
  */
@@ -216,24 +241,9 @@ tb_not_found:
 	if (!tb && (tb = inet_bind_bucket_create(hashinfo->bind_bucket_cachep,
 					net, head, snum)) == NULL)
 		goto fail_unlock;
-	if (hlist_empty(&tb->owners)) {
-		if (sk->sk_reuse && sk->sk_state != TCP_LISTEN)
-			tb->fastreuse = 1;
-		else
-			tb->fastreuse = 0;
-		if (sk->sk_reuseport) {
-			tb->fastreuseport = 1;
-			tb->fastuid = uid;
-		} else
-			tb->fastreuseport = 0;
-	} else {
-		if (tb->fastreuse &&
-		    (!sk->sk_reuse || sk->sk_state == TCP_LISTEN))
-			tb->fastreuse = 0;
-		if (tb->fastreuseport &&
-		    (!sk->sk_reuseport || !uid_eq(tb->fastuid, uid)))
-			tb->fastreuseport = 0;
-	}
+
+	inet_csk_update_fastreuse(tb, sk);
+
 success:
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, snum);


