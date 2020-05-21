Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F811DD040
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgEUOlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgEUOlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:19 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A3C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:19 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id s65so7838948qtd.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xz8AG2PLIPRjNcGi677EpvqnMTH4UzXVgfhRBhLkdGk=;
        b=NHc4hgY57YPrGXbxd6QL1J7g12s90zU0HqPdl9OgmuZrnDB5M6NvcfuN6WhSnqKQPg
         y4NYHNB6TzbB7vqTNUzVpJD12UnG2x3P5/4O4qszNiVer+tZ3b/RlpEbVOCAe+xuePbj
         3Td7CYidqmXunhKg/cJwLay63bKLbdyjxqFyZdNPwZpToDEHugm+Darvn/Ns7Px/X+R7
         iKVGy9+RhCW1I9DlzpAw3Q3NM0R3AUHJNzxhXvWHEQcxjP9Vk7kdcsmEmt0XF8TDjPyw
         NjuMeRXTfAmL/CY3uT22W5as22WcRSf6s82xvmya6jSe+Lgn63GfnOiKQDD1qZTpb9rT
         j2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xz8AG2PLIPRjNcGi677EpvqnMTH4UzXVgfhRBhLkdGk=;
        b=YEbNO2T8LmIXJIk6HaB8l40fiynl1x95KL2h7YPKYJeHnCBKRgAh9J1rILiwFl+M48
         Sn8jiyhmbvu6/wtVvUhTqKeI6DD/aFro5ePCKrkvz8MkvEp+uPfHuPm/D0fBeOwj3Nb9
         Baay23d1a0sVWX7Rx/HP+xpdZ6lFFm7Tb0kyVSZVTvAwLWOn5IvGyi3Wq1ajAE5Fp5fC
         g0Dc8Rh/6FxONg8OXZwdxI5F+H/M1apS0i9iE2nrCA0y202fkH/La4R3T41fb++v9tH/
         JX7cRj8tfzKBL1qrUA4UdN4OGjvYuVef0XVY6aCdB+FUlycNGEnoSiuqZLWPYkBD19LS
         +J6w==
X-Gm-Message-State: AOAM530Jfs7Z1bG4fuKaIwZV1awWct0k1e010lM5WXmuFRMOKQ8vA4r1
        6640Ixl5zGLDkF1smXR3IrXd2eiW9sNtXA==
X-Google-Smtp-Source: ABdhPJze/1vqrdeVLOJLFG06NIaBZKJtsCpXZqKWbE2R/jSIat3ijFNua4rbbHXFfPjY0EVzOxHid/B0qAuwSw==
X-Received: by 2002:a05:6214:1422:: with SMTP id o2mr10391987qvx.13.1590072078409;
 Thu, 21 May 2020 07:41:18 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:42 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-5-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 04/22] New kernel function to get IP overhead on a socket.
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
2.26.2.761.g0e0b3e54be-goog

