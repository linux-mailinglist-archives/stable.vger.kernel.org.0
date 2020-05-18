Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9684A1D8479
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgERSDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbgERSDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD34207F5;
        Mon, 18 May 2020 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824990;
        bh=p+ja2vRe2GOEd4ER0sNd2TiM8cbguWj1RwJgbtZ5bCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThrXOwfqZF7e35t4JcBDEcZRloPebNQuAmzFxOtFjLbkrC7XJ06WFu3xN+dik3qSc
         doYyOUfXej0TnKPjXms9JqAVnZ47QyAsDYe/whNoeSChWoWP0yLNpy1E4cXpynrLtP
         QoCLNgHQd6z2Kgxhq7Yl4BTga6+HADKLN9ss/29E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 037/194] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
Date:   Mon, 18 May 2020 19:35:27 +0200
Message-Id: <20200518173534.803818704@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej Żenczykowski" <maze@google.com>

[ Upstream commit 09454fd0a4ce23cb3d8af65066c91a1bf27120dd ]

This reverts commit 19bda36c4299ce3d7e5bce10bebe01764a655a6d:

| ipv6: add mtu lock check in __ip6_rt_update_pmtu
|
| Prior to this patch, ipv6 didn't do mtu lock check in ip6_update_pmtu.
| It leaded to that mtu lock doesn't really work when receiving the pkt
| of ICMPV6_PKT_TOOBIG.
|
| This patch is to add mtu lock check in __ip6_rt_update_pmtu just as ipv4
| did in __ip_rt_update_pmtu.

The above reasoning is incorrect.  IPv6 *requires* icmp based pmtu to work.
There's already a comment to this effect elsewhere in the kernel:

  $ git grep -p -B1 -A3 'RTAX_MTU lock'
  net/ipv6/route.c=4813=

  static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
  ...
    /* In IPv6 pmtu discovery is not optional,
       so that RTAX_MTU lock cannot disable it.
       We still use this lock to block changes
       caused by addrconf/ndisc.
    */

This reverts to the pre-4.9 behaviour.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Fixes: 19bda36c4299 ("ipv6: add mtu lock check in __ip6_rt_update_pmtu")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2725,8 +2725,10 @@ static void __ip6_rt_update_pmtu(struct
 	const struct in6_addr *daddr, *saddr;
 	struct rt6_info *rt6 = (struct rt6_info *)dst;
 
-	if (dst_metric_locked(dst, RTAX_MTU))
-		return;
+	/* Note: do *NOT* check dst_metric_locked(dst, RTAX_MTU)
+	 * IPv6 pmtu discovery isn't optional, so 'mtu lock' cannot disable it.
+	 * [see also comment in rt6_mtu_change_route()]
+	 */
 
 	if (iph) {
 		daddr = &iph->daddr;


