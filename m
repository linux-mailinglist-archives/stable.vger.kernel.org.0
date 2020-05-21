Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845781DDB6D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgEUX6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D6C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 186so7284090ybq.1
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xo+wusjQ3apmlZ8lyrHuft8+VHE/2u5OsjWNlhYSErs=;
        b=H4m7ktKGSbfRcqIcMOxf7oGPXMUr7Gvv05fLa6hQ4dG+1hKp1og1qcQosPrT1ObGDz
         snLqfVp+BDm0GVbFaladkcUGmlOgHtzm3ie0tzRtb0/p/OYE4f+0AqSDRvHqGpo2NFF0
         JEh7Q7xS/OdCD0KBQ5VutjCqb798A0cI4Rs18h48w7O/c47uFA3NTGxzcezv6iwGsi9I
         TbiPugEHOxC048LAzpEFoqUc+ToOBSFniSc3OAw3jJ7RouaShTJVXvjhAlUaDrB1Eu2w
         TiHb03skdj6P8gzTHjI/GwW4sP7OwzsOb82G6qLAJAnNsxCVT1u/cG/T8MiN0GLicJWE
         HTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xo+wusjQ3apmlZ8lyrHuft8+VHE/2u5OsjWNlhYSErs=;
        b=thFiE+ZRdzZz88bqbEvvWQ3ZvnlInlm+bshzvV0+DKTvr8ZfVt+05ERGqF8i2ug3/F
         lPua73ahpe/DdVz3pIn5WzFphN8EU0WZO7aTZ1UIztZeASpcWjJdnFU/ix+SotfrvxPW
         u7/dgO5CbiOfHU5Ka48m/cDZemOcgnrTn618je8L59N92Zpbuec/4E8zcbR5XAgjFBd5
         eyq76+2WQ9XHX0uf742WHh2mK6XtOH5UXu37k0MfWENmHxtYLHb3DOEoicaOd74kaG/V
         ld5qv7iV9go7iVDEB/SLtXebHNLF1sPFAZv1dDD5bWPiT4BPLsFw8tX/4n6YYM3vMWQQ
         CvzQ==
X-Gm-Message-State: AOAM532iYvxLiepkiD21jHXGoNf8lhd0cnFveYy/rgFZpdGegKPWGe04
        //4NaHgq1sDWeeAf3qp5w2MVnJXEUMy3lA==
X-Google-Smtp-Source: ABdhPJx1L0d5WZDHShB7k9bHtVrGrpQcUj50rAnRIl+g6rMsbRdnVBsWF+TQS7fC+ztupiRZYOJYsUVrVvG13g==
X-Received: by 2002:a25:f507:: with SMTP id a7mr19878670ybe.176.1590105491790;
 Thu, 21 May 2020 16:58:11 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:22 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-10-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 09/27] New kernel function to get IP overhead on a socket.
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
index c00b8d182226..a0c6c00ac166 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -291,6 +291,9 @@ int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 int kernel_sock_ioctl(struct socket *sock, int cmd, unsigned long arg);
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how);
 
+/* Following routine returns the IP overhead imposed by a socket.  */
+u32 kernel_sock_ip_overhead(struct sock *sk);
+
 #define MODULE_ALIAS_NETPROTO(proto) \
 	MODULE_ALIAS("net-pf-" __stringify(proto))
 
diff --git a/net/socket.c b/net/socket.c
index 15bdba4211ad..1a2a7320554b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3304,3 +3304,49 @@ int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how)
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

