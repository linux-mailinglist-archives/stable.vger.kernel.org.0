Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7481D76CB3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbfGZP0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387976AbfGZP0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EAE0205F4;
        Fri, 26 Jul 2019 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154799;
        bh=CGEPUx5/GNrDdg84izwMwOxDHOlO1764eXfvEVvnkSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtqPcEaxJ4gySOp/aIXGFnx3PMYUzyCjn4BImZe0+EjT9I/8O/CR5oKKcfI3+2TRd
         U+Yo82yqNTV9fypX6bVy0ZmlVGRaGRbHIniYe0cGu+xULjQhMTCAJCr0NPFpLyaODb
         4k4A3fC2wYySMFroKg2DADHJZf9PrePAhAvQsjK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 29/66] net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
Date:   Fri, 26 Jul 2019 17:24:28 +0200
Message-Id: <20190726152304.964693114@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 3b26a5d03d35d8f732d75951218983c0f7f68dff ]

We get a pointer to the ipv6 hdr in br_ip6_multicast_query but we may
call pskb_may_pull afterwards and end up using a stale pointer.
So use the header directly, it's just 1 place where it's needed.

Fixes: 08b202b67264 ("bridge br_multicast: IPv6 MLD support.")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Tested-by: Martin Weinelt <martin@linuxlounge.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1279,7 +1279,6 @@ static int br_ip6_multicast_query(struct
 				  u16 vid)
 {
 	unsigned int transport_len = ipv6_transport_len(skb);
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	struct mld_msg *mld;
 	struct net_bridge_mdb_entry *mp;
 	struct mld2_query *mld2q;
@@ -1323,7 +1322,7 @@ static int br_ip6_multicast_query(struct
 
 	if (is_general_query) {
 		saddr.proto = htons(ETH_P_IPV6);
-		saddr.u.ip6 = ip6h->saddr;
+		saddr.u.ip6 = ipv6_hdr(skb)->saddr;
 
 		br_multicast_query_received(br, port, &br->ip6_other_query,
 					    &saddr, max_delay);


