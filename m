Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B82157959
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgBJNOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgBJMib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F0C24649;
        Mon, 10 Feb 2020 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338311;
        bh=aEjZw2J7aIBVzvMnJTth/pI9cvN2mbTja/B2sNNo73E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THUCYaI6i/JF7n9yqS9hsljmMgMLBbJ5nHZYdQ2weRh4pH7T23rdUAzfzT7rXUFiN
         IhOHpNbTrDkCMt7cxJHa9ojZeoKrUSx4YUcPReF+mVfXUhhwwifyWh9XWv1tc8m98D
         EjxZW3pR70G9RyIbCFc2kfjkmbcGrQTVIq9IHWhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.4 235/309] broken ping to ipv6 linklocal addresses on debian buster
Date:   Mon, 10 Feb 2020 04:33:11 -0800
Message-Id: <20200210122429.091989610@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

commit 87fbfffcc89b92a4281b0aa53bd06af714087889 upstream.

I am seeing ping failures to IPv6 linklocal addresses with Debian
buster. Easiest example to reproduce is:

$ ping -c1 -w1 ff02::1%eth1
connect: Invalid argument

$ ping -c1 -w1 ff02::1%eth1
PING ff02::01%eth1(ff02::1%eth1) 56 data bytes
64 bytes from fe80::e0:f9ff:fe0c:37%eth1: icmp_seq=1 ttl=64 time=0.059 ms

git bisect traced the failure to
commit b9ef5513c99b ("smack: Check address length before reading address family")

Arguably ping is being stupid since the buster version is not setting
the address family properly (ping on stretch for example does):

$ strace -e connect ping6 -c1 -w1 ff02::1%eth1
connect(5, {sa_family=AF_UNSPEC,
sa_data="\4\1\0\0\0\0\377\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\3\0\0\0"}, 28)
= -1 EINVAL (Invalid argument)

but the command works fine on kernels prior to this commit, so this is
breakage which goes against the Linux paradigm of "don't break userspace"

Cc: stable@vger.kernel.org
Reported-by: David Ahern <dsahern@gmail.com>
Suggested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 security/smack/smack_lsm.c | 41 +++++++++++++++++++----------------------
 security/smack/smack_lsm.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2832,42 +2832,39 @@ static int smack_socket_connect(struct s
 				int addrlen)
 {
 	int rc = 0;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
-#endif
-#ifdef SMACK_IPV6_SECMARK_LABELING
-	struct smack_known *rsp;
-	struct socket_smack *ssp;
-#endif
 
 	if (sock->sk == NULL)
 		return 0;
-
+	if (sock->sk->sk_family != PF_INET &&
+	    (!IS_ENABLED(CONFIG_IPV6) || sock->sk->sk_family != PF_INET6))
+		return 0;
+	if (addrlen < offsetofend(struct sockaddr, sa_family))
+		return 0;
+	if (IS_ENABLED(CONFIG_IPV6) && sap->sa_family == AF_INET6) {
+		struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
 #ifdef SMACK_IPV6_SECMARK_LABELING
-	ssp = sock->sk->sk_security;
+		struct smack_known *rsp;
 #endif
 
-	switch (sock->sk->sk_family) {
-	case PF_INET:
-		if (addrlen < sizeof(struct sockaddr_in) ||
-		    sap->sa_family != AF_INET)
-			return -EINVAL;
-		rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
-		break;
-	case PF_INET6:
-		if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family != AF_INET6)
-			return -EINVAL;
+		if (addrlen < SIN6_LEN_RFC2133)
+			return 0;
 #ifdef SMACK_IPV6_SECMARK_LABELING
 		rsp = smack_ipv6host_label(sip);
-		if (rsp != NULL)
+		if (rsp != NULL) {
+			struct socket_smack *ssp = sock->sk->sk_security;
+
 			rc = smk_ipv6_check(ssp->smk_out, rsp, sip,
-						SMK_CONNECTING);
+					    SMK_CONNECTING);
+		}
 #endif
 #ifdef SMACK_IPV6_PORT_LABELING
 		rc = smk_ipv6_port_check(sock->sk, sip, SMK_CONNECTING);
 #endif
-		break;
+		return rc;
 	}
+	if (sap->sa_family != AF_INET || addrlen < sizeof(struct sockaddr_in))
+		return 0;
+	rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
 	return rc;
 }
 


