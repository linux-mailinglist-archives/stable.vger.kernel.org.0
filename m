Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344BE4F3AEE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiDELuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356081AbiDEKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83749B0A4E;
        Tue,  5 Apr 2022 03:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA886167E;
        Tue,  5 Apr 2022 10:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212E7C385A1;
        Tue,  5 Apr 2022 10:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153157;
        bh=o4/uCDFOiPoentGHBOsBJhXAVLVr9+YO14P1/ZT+Y2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDpu8xY0oxL6tNyYLyICQ1Y93UiBl2b6St+vxL+wMvBrzmOInP7zrePTYD9w0OswK
         N2FHLg0MOMwdDp7O6vhF58XpFji5fya+Zl9A7tSXEJa6SzWalXNidPSUVaVrtuM9VG
         Q71CYUaBjntUeIu7ARhfh6Li8DLSm6yiWDiI0olE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Antonio Quartulli <antonio@openvpn.net>
Subject: [PATCH 5.10 083/599] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Tue,  5 Apr 2022 09:26:17 +0200
Message-Id: <20220405070301.296870531@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

commit a4a600dd301ccde6ea239804ec1f19364a39d643 upstream.

When enabling encap for a ipv6 socket without udp_encap_needed_key
increased, UDP GRO won't work for v4 mapped v6 address packets as
sk will be NULL in udp4_gro_receive().

This patch is to enable it by increasing udp_encap_needed_key for
v6 sockets in udp_tunnel_encap_enable(), and correspondingly
decrease udp_encap_needed_key in udpv6_destroy_sock().

v1->v2:
  - add udp_encap_disable() and export it.
v2->v3:
  - add the change for rxrpc and bareudp into one patch, as Alex
    suggested.
v3->v4:
  - move rxrpc part to another patch.

Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bareudp.c    |    6 ------
 include/net/udp.h        |    1 +
 include/net/udp_tunnel.h |    3 +--
 net/ipv4/udp.c           |    6 ++++++
 net/ipv6/udp.c           |    4 +++-
 5 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -246,12 +246,6 @@ static int bareudp_socket_create(struct
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
-	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
-	 * socket type is v6 an explicit call to udp_encap_enable is needed.
-	 */
-	if (sock->sk->sk_family == AF_INET6)
-		udp_encap_enable();
-
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -467,6 +467,7 @@ void udp_init(void);
 
 DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
 void udp_encap_enable(void);
+void udp_encap_disable(void);
 #if IS_ENABLED(CONFIG_IPV6)
 DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
 void udpv6_encap_enable(void);
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -177,9 +177,8 @@ static inline void udp_tunnel_encap_enab
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sock->sk->sk_family == PF_INET6)
 		ipv6_stub->udpv6_encap_enable();
-	else
 #endif
-		udp_encap_enable();
+	udp_encap_enable();
 }
 
 #define UDP_TUNNEL_NIC_MAX_TABLES	4
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -598,6 +598,12 @@ void udp_encap_enable(void)
 }
 EXPORT_SYMBOL(udp_encap_enable);
 
+void udp_encap_disable(void)
+{
+	static_branch_dec(&udp_encap_needed_key);
+}
+EXPORT_SYMBOL(udp_encap_disable);
+
 /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
  * through error handlers in encapsulations looking for a match.
  */
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1610,8 +1610,10 @@ void udpv6_destroy_sock(struct sock *sk)
 			if (encap_destroy)
 				encap_destroy(sk);
 		}
-		if (up->encap_enabled)
+		if (up->encap_enabled) {
 			static_branch_dec(&udpv6_encap_needed_key);
+			udp_encap_disable();
+		}
 	}
 
 	inet6_destroy_sock(sk);


