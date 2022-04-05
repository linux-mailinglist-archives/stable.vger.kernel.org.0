Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0074F2E6B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347613AbiDEJ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244489AbiDEIwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB1DD64CE;
        Tue,  5 Apr 2022 01:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC388B81BBF;
        Tue,  5 Apr 2022 08:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36181C385A1;
        Tue,  5 Apr 2022 08:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148052;
        bh=G6f2/sQgiag0j9wye3uhzQKuFL3LXJowljAyAcD9C9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgQJT7thBc4uxdvC+jmTaFz1wcUWVHCDNE89kAJoL8kbWMmnyeIpJy4rii7HN1rW8
         zbeaLqZ3RdMibxVNddD1aB1zXbhj3Jp3RDN6F2FGf9p2AGYaMz+imsD6l1VI0KtYuM
         rJc0EPXFKQtb2U6k0tPmj4I7tlGuZ8wO/1QGgYv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashanth Prahlad <pprahlad@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0216/1017] security: add sctp_assoc_established hook
Date:   Tue,  5 Apr 2022 09:18:49 +0200
Message-Id: <20220405070400.663105580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 5e50f5d4ff31e95599d695df1f0a4e7d2d6fef99 ]

security_sctp_assoc_established() is added to replace
security_inet_conn_established() called in
sctp_sf_do_5_1E_ca(), so that asoc can be accessed in security
subsystem and save the peer secid to asoc->peer_secid.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Based-on-patch-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/security/SCTP.rst | 22 ++++++++++------------
 include/linux/lsm_hook_defs.h   |  2 ++
 include/linux/lsm_hooks.h       |  5 +++++
 include/linux/security.h        |  8 ++++++++
 net/sctp/sm_statefuns.c         |  8 +++++---
 security/security.c             |  7 +++++++
 6 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index d5fd6ccc3dcb..406cc68b8808 100644
--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -15,10 +15,7 @@ For security module support, three SCTP specific hooks have been implemented::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-
-Also the following security hook has been utilised::
-
-    security_inet_conn_established()
+    security_sctp_assoc_established()
 
 The usage of these hooks are described below with the SELinux implementation
 described in the `SCTP SELinux Support`_ chapter.
@@ -122,11 +119,12 @@ calls **sctp_peeloff**\(3).
     @newsk - pointer to new sock structure.
 
 
-security_inet_conn_established()
+security_sctp_assoc_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Called when a COOKIE ACK is received::
+Called when a COOKIE ACK is received, and the peer secid will be
+saved into ``@asoc->peer_secid`` for client::
 
-    @sk  - pointer to sock structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
@@ -134,7 +132,7 @@ Security Hooks used for Association Establishment
 -------------------------------------------------
 
 The following diagram shows the use of ``security_sctp_bind_connect()``,
-``security_sctp_assoc_request()``, ``security_inet_conn_established()`` when
+``security_sctp_assoc_request()``, ``security_sctp_assoc_established()`` when
 establishing an association.
 ::
 
@@ -172,7 +170,7 @@ establishing an association.
           <------------------------------------------- COOKIE ACK
           |                                               |
     sctp_sf_do_5_1E_ca                                    |
- Call security_inet_conn_established()                    |
+ Call security_sctp_assoc_established()                   |
  to set the peer label.                                   |
           |                                               |
           |                               If SCTP_SOCKET_TCP or peeled off
@@ -198,7 +196,7 @@ hooks with the SELinux specifics expanded below::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-    security_inet_conn_established()
+    security_sctp_assoc_established()
 
 
 security_sctp_assoc_request()
@@ -271,12 +269,12 @@ sockets sid and peer sid to that contained in the ``@asoc sid`` and
     @newsk - pointer to new sock structure.
 
 
-security_inet_conn_established()
+security_sctp_assoc_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Called when a COOKIE ACK is received where it sets the connection's peer sid
 to that in ``@skb``::
 
-    @sk  - pointer to sock structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index f0c7b352340a..2e078f40195d 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -335,6 +335,8 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
+LSM_HOOK(int, 0, sctp_assoc_established, struct sctp_association *asoc,
+	 struct sk_buff *skb)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index d45b6f6e27fd..d6823214d5c1 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1050,6 +1050,11 @@
  *	@asoc pointer to current sctp association structure.
  *	@sk pointer to current sock structure.
  *	@newsk pointer to new sock structure.
+ * @sctp_assoc_established:
+ *	Passes the @asoc and @chunk->skb of the association COOKIE_ACK packet
+ *	to the security module.
+ *	@asoc pointer to sctp association structure.
+ *	@skb pointer to skbuff of association packet.
  *
  * Security hooks for Infiniband
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index bbf44a466832..bd059e7b4766 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1430,6 +1430,8 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
+int security_sctp_assoc_established(struct sctp_association *asoc,
+				    struct sk_buff *skb);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1649,6 +1651,12 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *newsk)
 {
 }
+
+static inline int security_sctp_assoc_established(struct sctp_association *asoc,
+						  struct sk_buff *skb)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 354c1c4de19b..5633fbb1ba3c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -930,6 +930,11 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Set peer label for connection. */
+	if (security_sctp_assoc_established((struct sctp_association *)asoc,
+					    chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Verify that the chunk length for the COOKIE-ACK is OK.
 	 * If we don't do this, any bundled chunks may be junked.
 	 */
@@ -945,9 +950,6 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
 
-	/* Set peer label for connection. */
-	security_inet_conn_established(ep->base.sk, chunk->skb);
-
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
 	 * E) Upon reception of the COOKIE ACK, endpoint "A" will move
diff --git a/security/security.c b/security/security.c
index 64abdfb20bc2..cf6615b5e820 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2399,6 +2399,13 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
+int security_sctp_assoc_established(struct sctp_association *asoc,
+				    struct sk_buff *skb)
+{
+	return call_int_hook(sctp_assoc_established, 0, asoc, skb);
+}
+EXPORT_SYMBOL(security_sctp_assoc_established);
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-- 
2.34.1



