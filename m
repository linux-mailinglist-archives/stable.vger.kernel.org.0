Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214AE18B758
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCSNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgCSNPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A9E7216FD;
        Thu, 19 Mar 2020 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623731;
        bh=/PVuNNLgYs1qw4JU9G+C5t9quBCZtWSKhTfKLZK6Fv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GTBruv9EPQVkwkSRy+sSrlGSiXgWL/BR8lL3CqsBve+4OBqj7Nr+TosO6IpWdiFx
         l3ditDKvoY4hb7z9lCrmR+o+roAYDtXB/wHoOjNxi+PZVvVnDv8loJId2jEJXkp3tF
         QBeARD96ddqTbk7OrOMsqvhKU/x17HN1SxjgKVQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 33/99] inet_diag: return classid for all socket types
Date:   Thu, 19 Mar 2020 14:03:11 +0100
Message-Id: <20200319123951.832232691@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>

[ Upstream commit 83f73c5bb7b9a9135173f0ba2b1aa00c06664ff9 ]

In commit 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and
fallback to priority") croup classid reporting was fixed. But this works
only for TCP sockets because for other socket types icsk parameter can
be NULL and classid code path is skipped. This change moves classid
handling to inet_diag_msg_attrs_fill() function.

Also inet_diag_msg_attrs_size() helper was added and addends in
nlmsg_new() were reordered to save order from inet_sk_diag_fill().

Fixes: 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and fallback to priority")
Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/inet_diag.h |   18 ++++++++++++------
 net/ipv4/inet_diag.c      |   44 ++++++++++++++++++++------------------------
 net/ipv4/raw_diag.c       |    5 +++--
 net/ipv4/udp_diag.c       |    5 +++--
 net/sctp/sctp_diag.c      |    8 ++------
 5 files changed, 40 insertions(+), 40 deletions(-)

--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -2,15 +2,10 @@
 #ifndef _INET_DIAG_H_
 #define _INET_DIAG_H_ 1
 
+#include <net/netlink.h>
 #include <uapi/linux/inet_diag.h>
 
-struct net;
-struct sock;
 struct inet_hashinfo;
-struct nlattr;
-struct nlmsghdr;
-struct sk_buff;
-struct netlink_callback;
 
 struct inet_diag_handler {
 	void		(*dump)(struct sk_buff *skb,
@@ -62,6 +57,17 @@ int inet_diag_bc_sk(const struct nlattr
 
 void inet_diag_msg_common_fill(struct inet_diag_msg *r, struct sock *sk);
 
+static inline size_t inet_diag_msg_attrs_size(void)
+{
+	return	  nla_total_size(1)  /* INET_DIAG_SHUTDOWN */
+		+ nla_total_size(1)  /* INET_DIAG_TOS */
+#if IS_ENABLED(CONFIG_IPV6)
+		+ nla_total_size(1)  /* INET_DIAG_TCLASS */
+		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
+#endif
+		+ nla_total_size(4)  /* INET_DIAG_MARK */
+		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
+}
 int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			     struct inet_diag_msg *r, int ext,
 			     struct user_namespace *user_ns, bool net_admin);
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -105,13 +105,9 @@ static size_t inet_sk_attr_size(struct s
 		aux = handler->idiag_get_aux_size(sk, net_admin);
 
 	return	  nla_total_size(sizeof(struct tcp_info))
-		+ nla_total_size(1) /* INET_DIAG_SHUTDOWN */
-		+ nla_total_size(1) /* INET_DIAG_TOS */
-		+ nla_total_size(1) /* INET_DIAG_TCLASS */
-		+ nla_total_size(4) /* INET_DIAG_MARK */
-		+ nla_total_size(4) /* INET_DIAG_CLASS_ID */
-		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(sizeof(struct inet_diag_msg))
+		+ inet_diag_msg_attrs_size()
+		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(SK_MEMINFO_VARS * sizeof(u32))
 		+ nla_total_size(TCP_CA_NAME_MAX)
 		+ nla_total_size(sizeof(struct tcpvegas_info))
@@ -152,6 +148,24 @@ int inet_diag_msg_attrs_fill(struct sock
 	if (net_admin && nla_put_u32(skb, INET_DIAG_MARK, sk->sk_mark))
 		goto errout;
 
+	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
+	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
+		u32 classid = 0;
+
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
+#endif
+		/* Fallback to socket priority if class id isn't set.
+		 * Classful qdiscs use it as direct reference to class.
+		 * For cgroup2 classid is always zero.
+		 */
+		if (!classid)
+			classid = sk->sk_priority;
+
+		if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
+			goto errout;
+	}
+
 	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = sock_i_ino(sk);
 
@@ -289,24 +303,6 @@ int inet_sk_diag_fill(struct sock *sk, s
 			goto errout;
 	}
 
-	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
-	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
-		u32 classid = 0;
-
-#ifdef CONFIG_SOCK_CGROUP_DATA
-		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
-#endif
-		/* Fallback to socket priority if class id isn't set.
-		 * Classful qdiscs use it as direct reference to class.
-		 * For cgroup2 classid is always zero.
-		 */
-		if (!classid)
-			classid = sk->sk_priority;
-
-		if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
-			goto errout;
-	}
-
 out:
 	nlmsg_end(skb, nlh);
 	return 0;
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -99,8 +99,9 @@ static int raw_diag_dump_one(struct sk_b
 	if (IS_ERR(sk))
 		return PTR_ERR(sk);
 
-	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
-			sizeof(struct inet_diag_meminfo) + 64,
+	rep = nlmsg_new(nla_total_size(sizeof(struct inet_diag_msg)) +
+			inet_diag_msg_attrs_size() +
+			nla_total_size(sizeof(struct inet_diag_meminfo)) + 64,
 			GFP_KERNEL);
 	if (!rep) {
 		sock_put(sk);
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -67,8 +67,9 @@ static int udp_dump_one(struct udp_table
 		goto out;
 
 	err = -ENOMEM;
-	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
-			sizeof(struct inet_diag_meminfo) + 64,
+	rep = nlmsg_new(nla_total_size(sizeof(struct inet_diag_msg)) +
+			inet_diag_msg_attrs_size() +
+			nla_total_size(sizeof(struct inet_diag_meminfo)) + 64,
 			GFP_KERNEL);
 	if (!rep)
 		goto out;
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -221,15 +221,11 @@ static size_t inet_assoc_attr_size(struc
 		addrcnt++;
 
 	return	  nla_total_size(sizeof(struct sctp_info))
-		+ nla_total_size(1) /* INET_DIAG_SHUTDOWN */
-		+ nla_total_size(1) /* INET_DIAG_TOS */
-		+ nla_total_size(1) /* INET_DIAG_TCLASS */
-		+ nla_total_size(4) /* INET_DIAG_MARK */
-		+ nla_total_size(4) /* INET_DIAG_CLASS_ID */
 		+ nla_total_size(addrlen * asoc->peer.transport_count)
 		+ nla_total_size(addrlen * addrcnt)
-		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(sizeof(struct inet_diag_msg))
+		+ inet_diag_msg_attrs_size()
+		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ 64;
 }
 


