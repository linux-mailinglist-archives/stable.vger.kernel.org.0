Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9337C57F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhELPlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235557AbhELPf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D9761959;
        Wed, 12 May 2021 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832680;
        bh=1iZ8BUAWHhydESmvXxPi9xC5QpAeVwofaZIVG3emBWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfQS/3g6GlXwqioOcGHk4PEP9QQb2/880N/xUDy/6mG1vctTSj9fauLFSdPSeUEbV
         7lP0Hmb+g+v8q++Ay98coQHAHcNr0ClOsL42rABlF9SGYkxng18zoNBMGpFBS2wtK4
         3G1ISP+I5rZC0XSv1LJ5HqLqsq91v68xVxE4RaYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/530] udp: never accept GSO_FRAGLIST packets
Date:   Wed, 12 May 2021 16:48:10 +0200
Message-Id: <20210512144832.263718249@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 4a2fd286787c..9d28b2778e8f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2657,9 +2657,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 
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



