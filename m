Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C0F1A290F
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgDHTFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 15:05:08 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50901 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHTFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 15:05:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MdeSt-1inTPx0ouf-00ZfGF; Wed, 08 Apr 2020 21:04:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smack: avoid unused 'sip' variable warning
Date:   Wed,  8 Apr 2020 21:04:31 +0200
Message-Id: <20200408190448.778791-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YN15JdouRHUqp4Z3FJXkeTN/96nn0sT9zi+9TwGvUZQzcaMfrqR
 0IjEoymPsfmLhxaWA+J4RY53s34KX5U6kwNFzK0Y/8P7qH4Nld8AEfaJu2EIYJr7mE6Rztr
 AVjEvqSs56UWnQiOy1SqWD3ge/DUwsrrdNeVU2qQPJhNo7RiCL1G2qYC9+LN77EJCn9OnM6
 sJw7Z5FbNB8x98npc/9tA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:P+CL3ETxFTM=:geY3PpBWshG5C2oixOcL/C
 9ERZqDcfLxQiZ/WtFKn0ofSrKx3UnzMqCBowkzvoBYuOPMhZAikSh0AfMWWzmQM58NnqjQEMZ
 5QgJ/H+1aQIcrTu9rqtODx1iq8Ewyo8e7LO2TMVMw2IfevMsA+sMr/ktkVvIvSnvVbvyzvmx9
 h/v5z3c8evy4b7OvQIaMUz3qiptayfNOlB+7BcTNB9yjRhnudAhMg93yqpmJcEvGN40doHrEr
 I4UMi6GhxyEqIMKDqxlfwXGZXcmTo/GS7c84AmNEvgh1fxDGm/d4IR2VSCq4oRblxXZAdx5sG
 1mCmOUqtSxAFhFBokSeltjh+F1YXakp7baGM/k+X6nxQfkL1OnkGID/0qFx98Hrm4dWFhpmvt
 AuJ2wV0wO1n7b2pU88DqaPzKSWM95mHwxEk+Z0yKgYQSlpR0M9QZzOzHoAxNwfgmI+0SbmYzh
 hfT/i1qxxGLcVrOyRAePKx49NwnE32dXa6bwKoLCEd852p8G0J/akg86jpwqZc4/iMwP1xxkk
 8weP+rhNeIVh1llGkA/B9V/g1fuAbdvax5f+KFq9SCMqjp1IMb/paScQNe5K6q1tgyybv+JAo
 ARxoNKrROCuzCWDTex88I2lzsGJKV4ToN3Qo618JvWfbO0K0dAvZjcWiLZFQ9H3SSnRDdMEx+
 HJaM2TRH8rULReCytqJyeSlA2gDqMObJPJIO3DHn/iB2BbvLPqTv7hIBSCYhG3pOui+h7bvRb
 mDwQo6bKPI1G74Ck/ILzsflVM8HdnCIc2KVol13F0erpe7QjuckL3fx3Y5Keun6dtRusp7Aef
 kBCceNXIBdY+PyjQ7TSx56ITziq2CzaiHD0ByAhd/+pnNfBjxc=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mix of IS_ENABLED() and #ifdef checks has left a combination
that causes a warning about an unused variable:

security/smack/smack_lsm.c: In function 'smack_socket_connect':
security/smack/smack_lsm.c:2838:24: error: unused variable 'sip' [-Werror=unused-variable]
 2838 |   struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;

Change the code to use C-style checks consistently so the compiler
can handle it correctly.

Fixes: 87fbfffcc89b ("broken ping to ipv6 linklocal addresses on debian buster")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
There are lots of ways of addressing this, if you prefer a different
way, please just treat this patch as a bug report and apply the
replacement patch directly.
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
index 8c61d175e195..e193b0db0271 100644
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
+				rsp = smack_ipv6host_label(sip);
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
2.26.0

