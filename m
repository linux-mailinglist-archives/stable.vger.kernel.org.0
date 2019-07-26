Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D091C76D90
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389241AbfGZPek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387438AbfGZPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FAD72054F;
        Fri, 26 Jul 2019 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155251;
        bh=eQod0ywmdB6ZvWigLTZR/Z2eROwQcj35Rw5LyXpuEIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYY7jkhHP8uk+O7D2UGz/mL1WYMTtjtPeKpi8wOkQTeCccCkD4ZgiELPN6dv5ILc7
         AWTi5JqVeGJn2IhtfaK83jIBuaYjp+6KrPw/DogpX1qPdPlkxKq1i5Chi5xslY2TXJ
         SrA6oOe3aQkKG7EZrNAUqUvVD+7SypJL6Zu5U+6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 33/50] net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
Date:   Fri, 26 Jul 2019 17:25:08 +0200
Message-Id: <20190726152304.047028867@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
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
@@ -1510,7 +1510,6 @@ static int br_ip6_multicast_query(struct
 				  struct sk_buff *skb,
 				  u16 vid)
 {
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	struct mld_msg *mld;
 	struct net_bridge_mdb_entry *mp;
 	struct mld2_query *mld2q;
@@ -1554,7 +1553,7 @@ static int br_ip6_multicast_query(struct
 
 	if (is_general_query) {
 		saddr.proto = htons(ETH_P_IPV6);
-		saddr.u.ip6 = ip6h->saddr;
+		saddr.u.ip6 = ipv6_hdr(skb)->saddr;
 
 		br_multicast_query_received(br, port, &br->ip6_other_query,
 					    &saddr, max_delay);


