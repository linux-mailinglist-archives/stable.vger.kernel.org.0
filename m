Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C011DDB23
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgEUXjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FD3C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z7so7221777ybn.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yJUz8hfscvBYg94p07A5ULXPDZmlYxYElnQQFtU6vYs=;
        b=CLBb3NR6ulCPjarWu4FGOgG3djQ8bk0AdYgv8AiA8DQewbvGzWiKah0lh9BZckezYU
         RaSkFjkF86v/TiUDs5t8kLkk1SsxOPi03wSWlgpr2zuT/sjsei+tOnPokKGBXMNgC1pg
         PFvn99gbfv9XMdikt1jNC5NRESbjHjoe5D0dw6KIvOjhWP3SxlxW98ELINBmQuWawS41
         6cj4oRJkfKKpo6YaFb0aHGbzVQql4v9Pnz+Rpp9h0v4yYnV9u5AWDMSkOakIUlEWwnBr
         cCIj57JNVG7VQdH0RHQ7JMDDL5sVihNdxKblkkcO25KfSfx6dFUFsAWk6kK/bkIhylng
         Yelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yJUz8hfscvBYg94p07A5ULXPDZmlYxYElnQQFtU6vYs=;
        b=RYMbY8j1+Gs2DyH8y/31MEiCjm/axCsZMdcmabE0QBc07j0g1sZOQPeHLAHxrDjOju
         gzVReNmGje9ZToNRKQnN1mDqFWeLpwWQDhNFQdJB6DYja1PJ3Uh6Mts5zY8rIcGAHpXA
         Et8mRDXPOYboA4y/GSKtR2UolfwPhHiZogBUErNyBewDfeQt1kbnjZAEr4pwowV2BQdQ
         Uaw9buNoclgxWhLazIHitqIaSoxixIku0neo/5hZQi+8St4NTYIlJtKA7vmC6Xhi5VP2
         YEZe9X6f63voMZE9N5REcclRV3eV0tswJwm5HCfDx+ejKyQqx7SFqOR8HzIc8UCOcHSs
         ZPuw==
X-Gm-Message-State: AOAM530Zc5bu7F8AHGLYAXp2v56/2sVrm4ZoW7hVFM9ezCKFx7ItwCDh
        elHT2QvHw5DS1LvY2MKaRGR+JT3tQHIgHQ==
X-Google-Smtp-Source: ABdhPJy9YeVj053VF1ZFEgDKcsV4NlGN1K/caRQq6wie5Y3o44FtJSM5oGBrZGP1vmAp9bFnwG2t8lzHsbtLZQ==
X-Received: by 2002:a25:8b02:: with SMTP id i2mr19067283ybl.283.1590104393275;
 Thu, 21 May 2020 16:39:53 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:19 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-5-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 04/22] New kernel function to get IP overhead on a socket.
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org,
        "R. Parameswaran" <parameswaran.r7@gmail.com>,
        "R . Parameswaran" <rparames@brocade.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "R. Parameswaran" <parameswaran.r7@gmail.com>

commit 113c3075931a334f899008f6c753abe70a3a9323 upstream.

A new function, kernel_sock_ip_overhead(), is provided
to calculate the cumulative overhead imposed by the IP
Header and IP options, if any, on a socket's payload.
The new function returns an overhead of zero for sockets
that do not belong to the IPv4 or IPv6 address families.
This is used in the L2TP code path to compute the
total outer IP overhead on the L2TP tunnel socket when
calculating the default MTU for Ethernet pseudowires.

Signed-off-by: R. Parameswaran <rparames@brocade.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 include/linux/net.h |  3 +++
 net/socket.c        | 46 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index cd0c8bd0a1de..2c8b092f3f17 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -298,6 +298,9 @@ int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 int kernel_sock_ioctl(struct socket *sock, int cmd, unsigned long arg);
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how);
 
+/* Following routine returns the IP overhead imposed by a socket.  */
+u32 kernel_sock_ip_overhead(struct sock *sk);
+
 #define MODULE_ALIAS_NETPROTO(proto) \
 	MODULE_ALIAS("net-pf-" __stringify(proto))
 
diff --git a/net/socket.c b/net/socket.c
index 65afc8ec68d4..4892719a8a66 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3321,3 +3321,49 @@ int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how)
 	return sock->ops->shutdown(sock, how);
 }
 EXPORT_SYMBOL(kernel_sock_shutdown);
+
+/* This routine returns the IP overhead imposed by a socket i.e.
+ * the length of the underlying IP header, depending on whether
+ * this is an IPv4 or IPv6 socket and the length from IP options turned
+ * on at the socket.
+ */
+u32 kernel_sock_ip_overhead(struct sock *sk)
+{
+	struct inet_sock *inet;
+	struct ip_options_rcu *opt;
+	u32 overhead = 0;
+	bool owned_by_user;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6_pinfo *np;
+	struct ipv6_txoptions *optv6 = NULL;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+
+	if (!sk)
+		return overhead;
+
+	owned_by_user = sock_owned_by_user(sk);
+	switch (sk->sk_family) {
+	case AF_INET:
+		inet = inet_sk(sk);
+		overhead += sizeof(struct iphdr);
+		opt = rcu_dereference_protected(inet->inet_opt,
+						owned_by_user);
+		if (opt)
+			overhead += opt->opt.optlen;
+		return overhead;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		np = inet6_sk(sk);
+		overhead += sizeof(struct ipv6hdr);
+		if (np)
+			optv6 = rcu_dereference_protected(np->opt,
+							  owned_by_user);
+		if (optv6)
+			overhead += (optv6->opt_flen + optv6->opt_nflen);
+		return overhead;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+	default: /* Returns 0 overhead if the socket is not ipv4 or ipv6 */
+		return overhead;
+	}
+}
+EXPORT_SYMBOL(kernel_sock_ip_overhead);
-- 
2.27.0.rc0.183.gde8f92d652-goog

