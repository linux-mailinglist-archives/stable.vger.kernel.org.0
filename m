Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8B10BC99
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfK0VFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732324AbfK0VFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8302621770;
        Wed, 27 Nov 2019 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888746;
        bh=AiDrupa0ElEL9BkwztZdJMc2ifNPMRDNGjY+TvtGWtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQ1EJANJeNZKE8Z7M48pjWJ2JXm5k2DEqu8Z2BvHlr8ZLNO2PK5U7QKp7SgJRHTN3
         dpKIKvn2mDTWSUdYVAdlH7W5mLqjEtnjG8GBUf5rQlcLc+1g19Yhyw84yFnoTeW8pp
         TYsd9R7CKlcoiWcR8qHn9HAEbv9AOvPYy8hMzRa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Donald Sharp <sharpd@cumulusnetworks.com>,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 253/306] ipv6: Fix handling of LLA with VRF and sockets bound to VRF
Date:   Wed, 27 Nov 2019 21:31:43 +0100
Message-Id: <20191127203133.368836476@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit c2027d1e17582903e368abf5d4838b22a98f2b7b ]

A recent commit allows sockets bound to a VRF to receive ipv6 link local
packets. However, it only works for UDP and worse TCP connection attempts
to the LLA with the only listener bound to the VRF just hang where as
before the client gets a reset and connection refused. Fix by adjusting
ir_iif for LL addresses and packets received through a device enslaved
to a VRF.

Fixes: 6f12fa775530 ("vrf: mark skb for multicast or link-local as enslaved to VRF")
Reported-by: Donald Sharp <sharpd@cumulusnetworks.com>
Cc: Mike Manning <mmanning@vyatta.att-mail.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e7cdfa92c3820..9a117a79af659 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -734,6 +734,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
+	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct ipv6_pinfo *np = inet6_sk(sk_listener);
 
@@ -741,7 +742,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 
 	/* So that link locals have meaning */
-	if (!sk_listener->sk_bound_dev_if &&
+	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = tcp_v6_iif(skb);
 
-- 
2.20.1



