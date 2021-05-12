Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC537C9AD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhELQUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238217AbhELQPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:15:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BEB61D70;
        Wed, 12 May 2021 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834148;
        bh=5UwZZ3qCASXLL5WWG5EKPMjBg3/p1LCHUcu6tR8P1bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kw5AiVdGoBM7UisZ7sAybj+LDFk/LkM7lDOboUOlZFy+7mi52K2sp5M+73lYCOSwE
         BbJkjpXU91giEI0e3DiMBpZ2VgZyXlkgUiYl1uGR+nunKT6ltuzZviwE5LPpmyMA6n
         1qDnFeCyZH3vPBrZplHW8RGsyqwLU/eBaaGJONww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 427/601] udp: never accept GSO_FRAGLIST packets
Date:   Wed, 12 May 2021 16:48:24 +0200
Message-Id: <20210512144841.898017157@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 78352f73dc5047f3f744764cc45912498c52f3c9 ]

Currently the UDP protocol delivers GSO_FRAGLIST packets to
the sockets without the expected segmentation.

This change addresses the issue introducing and maintaining
a couple of new fields to explicitly accept SKB_GSO_UDP_L4
or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
accordingly.

UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
zeroed.

v1 -> v2:
 - use 2 bits instead of a whole GSO bitmask (Willem)

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 16 +++++++++++++---
 net/ipv4/udp.c      |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33..ae58ff3b6b5b 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -51,7 +51,9 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1;	/* Can accept GRO packets */
+			 gro_enabled:1,	/* Request GRO aggregation */
+			 accept_udp_l4:1,
+			 accept_udp_fraglist:1;
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
@@ -131,8 +133,16 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
-	return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
+	if (!skb_is_gso(skb))
+		return false;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->accept_udp_l4)
+		return true;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST && !udp_sk(sk)->accept_udp_fraglist)
+		return true;
+
+	return false;
 }
 
 #define udp_portaddr_for_each_entry(__sk, list) \
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9d2a1a247cec..a5d716f185f6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2659,9 +2659,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 
 	case UDP_GRO:
 		lock_sock(sk);
+
+		/* when enabling GRO, accept the related GSO packet type */
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
 		up->gro_enabled = valbool;
+		up->accept_udp_l4 = valbool;
 		release_sock(sk);
 		break;
 
-- 
2.30.2



