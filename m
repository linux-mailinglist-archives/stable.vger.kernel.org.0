Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D160D25AC84
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgIBOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726941AbgIBOFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 10:05:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8085C061247
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 07:05:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id d26so6874857ejr.1
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 07:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FLpCQ3qI5KfHEBWeNBVXvI2wwhNyV/ewM21YvGAgnzw=;
        b=szXIHXnW/DfiXlKuuhJYXkvcvY4v9pEwZcjQ0p4LaEvQfCpa/LVenqQ9o0iSlR8jey
         d90zBEehr5Fg3KBLHtFy1EZxSqkGLHZ7E6aSVHeyJ0msF+QklNjeb6FvxQGZAVHOTOhk
         XbmaEZy9cjFVeuoQmVfx2Y94inCyXC0oo2bIle7C9o9EkSzyq4K/M6y3nMG6ERtxuona
         RpZ0PsNTHnEG6QahRQucJVV/9rSGdZX2Tji0aoyoB2/liTu2R6YMBwnNodYK4NKox6gm
         vQ/xYDDwLkyuzN7kHS9qs1XgcIIFfKuZiQL0efDJaoIp3kt4dAxZfhZJSF1wU9vw/tpv
         jC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLpCQ3qI5KfHEBWeNBVXvI2wwhNyV/ewM21YvGAgnzw=;
        b=pNOFhPCi5+7dxXZpnxW6V4orpr+Ao5vLNSJqh+aPIE5lRKd1oeLhrjSas+S6c9MiL9
         Nb9tdxfvwUV8PFbhUMOIEjB4Ji96FKJBUyVkH0gFA1sRH+9cf0CkIr/i93IfbBJ+2Q50
         /fUJcZRF+Txj+cUSymxXSUnCPAsSh+haIH9/ccm6MdqjnSJAFq5N6NwBjy8c5RB7Hb8n
         WfzDq9kun9zRGorBm2JoC+1opJXLfk81inD2qPatUo695Ahymf0AHwxuuGOVx24+c/oA
         8uf3uDashg8gyhrVsZPICfExOZvIvAEoh4syBfYbm7iE9EuXj59DNo5SUnKf91STQMhh
         LJ2w==
X-Gm-Message-State: AOAM530B/WovIq1VYrF8d077nuxvHS+ZM5V+LoEu68JZpb/L8sOAOo9Q
        DOwOm+LHR4HRPPJWX01wBlZqyQ==
X-Google-Smtp-Source: ABdhPJwqSnB7z2vvto5AYOTdoYg5kh0MsgfWPFFpHnhvvrxZATt3nvpoXk9M7ZPJUTqsrdc4n9pUHw==
X-Received: by 2002:a17:906:480a:: with SMTP id w10mr179740ejq.372.1599055536596;
        Wed, 02 Sep 2020 07:05:36 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14oqa3w7cibjsc.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:8cba:3abe:17e1:aaec])
        by smtp.gmail.com with ESMTPSA id os15sm4354775ejb.61.2020.09.02.07.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:05:35 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: [PATCH 4.4 1/2] net: refactor bind_bucket fastreuse into helper
Date:   Wed,  2 Sep 2020 16:05:12 +0200
Message-Id: <20200902140513.866712-2-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200902140513.866712-1-tim.froidcoeur@tessares.net>
References: <20200902140513.866712-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62ffc589abb176821662efc4525ee4ac0b9c3894 ]

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 include/net/inet_connection_sock.h |  4 +++
 net/ipv4/inet_connection_sock.c    | 46 ++++++++++++++++++------------
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 72599bbc8255..a77a37c6349d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -319,5 +319,9 @@ int inet_csk_compat_getsockopt(struct sock *sk, int level, int optname,
 int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
 			       char __user *optval, unsigned int optlen);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 #endif /* _INET_CONNECTION_SOCK_H */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6c9158805b57..9678dd8d70c3 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -87,6 +87,31 @@ int inet_csk_bind_conflict(const struct sock *sk,
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
-- 
2.25.1

