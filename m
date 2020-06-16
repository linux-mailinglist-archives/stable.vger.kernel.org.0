Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9E1FB736
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbgFPPoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731902AbgFPPoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71901208E4;
        Tue, 16 Jun 2020 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322244;
        bh=AU8kPO1hPe5EGPaST5+To5lYsboUwNEV7+7aWvUfdVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2ASHxiMGEE92BdGsHqaCMtbAr9q2ttgTAFrSlpqcsid4nSvJq0gvKqhIa3eCP0OK
         PN6bYNzU1uioFVB+funV3yI/iOO75G7eS1iprwhxAGyjSrMgefLxu8cfGRuMDGmg8q
         Ha3D8WdtNQjMBnwg7wAjUh0C6t4+8Py5GJOcXFW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 026/163] smack: avoid unused sip variable warning
Date:   Tue, 16 Jun 2020 17:33:20 +0200
Message-Id: <20200616153108.134501400@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 00720f0e7f288d29681d265c23b22bb0f0f4e5b4 ]

The mix of IS_ENABLED() and #ifdef checks has left a combination
that causes a warning about an unused variable:

security/smack/smack_lsm.c: In function 'smack_socket_connect':
security/smack/smack_lsm.c:2838:24: error: unused variable 'sip' [-Werror=unused-variable]
 2838 |   struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;

Change the code to use C-style checks consistently so the compiler
can handle it correctly.

Fixes: 87fbfffcc89b ("broken ping to ipv6 linklocal addresses on debian buster")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h     |  6 ------
 security/smack/smack_lsm.c | 25 ++++++++-----------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 62529f382942..335d2411abe4 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -148,7 +148,6 @@ struct smk_net4addr {
 	struct smack_known	*smk_label;	/* label */
 };
 
-#if IS_ENABLED(CONFIG_IPV6)
 /*
  * An entry in the table identifying IPv6 hosts.
  */
@@ -159,9 +158,7 @@ struct smk_net6addr {
 	int			smk_masks;	/* mask size */
 	struct smack_known	*smk_label;	/* label */
 };
-#endif /* CONFIG_IPV6 */
 
-#ifdef SMACK_IPV6_PORT_LABELING
 /*
  * An entry in the table identifying ports.
  */
@@ -174,7 +171,6 @@ struct smk_port_label {
 	short			smk_sock_type;	/* Socket type */
 	short			smk_can_reuse;
 };
-#endif /* SMACK_IPV6_PORT_LABELING */
 
 struct smack_known_list_elem {
 	struct list_head	list;
@@ -335,9 +331,7 @@ extern struct smack_known smack_known_web;
 extern struct mutex	smack_known_lock;
 extern struct list_head smack_known_list;
 extern struct list_head smk_net4addr_list;
-#if IS_ENABLED(CONFIG_IPV6)
 extern struct list_head smk_net6addr_list;
-#endif /* CONFIG_IPV6 */
 
 extern struct mutex     smack_onlycap_lock;
 extern struct list_head smack_onlycap_list;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8c61d175e195..14bf2f4aea3b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -50,10 +50,8 @@
 #define SMK_RECEIVING	1
 #define SMK_SENDING	2
 
-#ifdef SMACK_IPV6_PORT_LABELING
-DEFINE_MUTEX(smack_ipv6_lock);
+static DEFINE_MUTEX(smack_ipv6_lock);
 static LIST_HEAD(smk_ipv6_port_list);
-#endif
 static struct kmem_cache *smack_inode_cache;
 struct kmem_cache *smack_rule_cache;
 int smack_enabled;
@@ -2320,7 +2318,6 @@ static struct smack_known *smack_ipv4host_label(struct sockaddr_in *sip)
 	return NULL;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
 /*
  * smk_ipv6_localhost - Check for local ipv6 host address
  * @sip: the address
@@ -2388,7 +2385,6 @@ static struct smack_known *smack_ipv6host_label(struct sockaddr_in6 *sip)
 
 	return NULL;
 }
-#endif /* CONFIG_IPV6 */
 
 /**
  * smack_netlabel - Set the secattr on a socket
@@ -2477,7 +2473,6 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	return smack_netlabel(sk, sk_lbl);
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
 /**
  * smk_ipv6_check - check Smack access
  * @subject: subject Smack label
@@ -2510,7 +2505,6 @@ static int smk_ipv6_check(struct smack_known *subject,
 	rc = smk_bu_note("IPv6 check", subject, object, MAY_WRITE, rc);
 	return rc;
 }
-#endif /* CONFIG_IPV6 */
 
 #ifdef SMACK_IPV6_PORT_LABELING
 /**
@@ -2599,6 +2593,7 @@ static void smk_ipv6_port_label(struct socket *sock, struct sockaddr *address)
 	mutex_unlock(&smack_ipv6_lock);
 	return;
 }
+#endif
 
 /**
  * smk_ipv6_port_check - check Smack port access
@@ -2661,7 +2656,6 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 
 	return smk_ipv6_check(skp, object, address, act);
 }
-#endif /* SMACK_IPV6_PORT_LABELING */
 
 /**
  * smack_inode_setsecurity - set smack xattrs
@@ -2836,24 +2830,21 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 		return 0;
 	if (IS_ENABLED(CONFIG_IPV6) && sap->sa_family == AF_INET6) {
 		struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
-#ifdef SMACK_IPV6_SECMARK_LABELING
-		struct smack_known *rsp;
-#endif
+		struct smack_known *rsp = NULL;
 
 		if (addrlen < SIN6_LEN_RFC2133)
 			return 0;
-#ifdef SMACK_IPV6_SECMARK_LABELING
-		rsp = smack_ipv6host_label(sip);
+		if (__is_defined(SMACK_IPV6_SECMARK_LABELING))
+			rsp = smack_ipv6host_label(sip);
 		if (rsp != NULL) {
 			struct socket_smack *ssp = sock->sk->sk_security;
 
 			rc = smk_ipv6_check(ssp->smk_out, rsp, sip,
 					    SMK_CONNECTING);
 		}
-#endif
-#ifdef SMACK_IPV6_PORT_LABELING
-		rc = smk_ipv6_port_check(sock->sk, sip, SMK_CONNECTING);
-#endif
+		if (__is_defined(SMACK_IPV6_PORT_LABELING))
+			rc = smk_ipv6_port_check(sock->sk, sip, SMK_CONNECTING);
+
 		return rc;
 	}
 	if (sap->sa_family != AF_INET || addrlen < sizeof(struct sockaddr_in))
-- 
2.25.1



