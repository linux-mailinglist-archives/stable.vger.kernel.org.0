Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05310187F9B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgCQLC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbgCQLCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:02:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99EB20736;
        Tue, 17 Mar 2020 11:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442974;
        bh=15R0WSGcRE9tfD6nYg0dsV9L2EUcdNJhoqEcUtgZF/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+oeajHdneT7UNqLyYkIl/8y90+el+dX3yNvdlPkPtjpY5fqB4Bjik2nOj0nRuoV0
         6qvHPOH6yUySav1iQIxKwkXIeSYNBZcQVr3R7cRQr2Iugk51UNkiOVH82T1Iny/zSQ
         I1uxY06ZlBCYHEllCNCehTrhpfmrg9Vagw3GDOMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 053/123] net/ipv6: need update peer route when modify metric
Date:   Tue, 17 Mar 2020 11:54:40 +0100
Message-Id: <20200317103313.100860154@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 617940123e0140521f3080d2befc2bf55bcda094 ]

When we modify the route metric, the peer address's route need also
be updated. Before the fix:

+ ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2 metric 60
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 60 pref medium
2001:db8::2 proto kernel metric 60 pref medium
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 61 pref medium
2001:db8::2 proto kernel metric 60 pref medium

After the fix:
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 61 pref medium
2001:db8::2 proto kernel metric 61 pref medium

Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4590,12 +4590,14 @@ inet6_rtm_deladdr(struct sk_buff *skb, s
 }
 
 static int modify_prefix_route(struct inet6_ifaddr *ifp,
-			       unsigned long expires, u32 flags)
+			       unsigned long expires, u32 flags,
+			       bool modify_peer)
 {
 	struct fib6_info *f6i;
 	u32 prio;
 
-	f6i = addrconf_get_prefix_route(&ifp->addr, ifp->prefix_len,
+	f6i = addrconf_get_prefix_route(modify_peer ? &ifp->peer_addr : &ifp->addr,
+					ifp->prefix_len,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (!f6i)
 		return -ENOENT;
@@ -4606,7 +4608,8 @@ static int modify_prefix_route(struct in
 		ip6_del_rt(dev_net(ifp->idev->dev), f6i);
 
 		/* add new one */
-		addrconf_prefix_route(&ifp->addr, ifp->prefix_len,
+		addrconf_prefix_route(modify_peer ? &ifp->peer_addr : &ifp->addr,
+				      ifp->prefix_len,
 				      ifp->rt_priority, ifp->idev->dev,
 				      expires, flags, GFP_KERNEL);
 	} else {
@@ -4682,7 +4685,7 @@ static int inet6_addr_modify(struct inet
 		int rc = -ENOENT;
 
 		if (had_prefixroute)
-			rc = modify_prefix_route(ifp, expires, flags);
+			rc = modify_prefix_route(ifp, expires, flags, false);
 
 		/* prefix route could have been deleted; if so restore it */
 		if (rc == -ENOENT) {
@@ -4690,6 +4693,15 @@ static int inet6_addr_modify(struct inet
 					      ifp->rt_priority, ifp->idev->dev,
 					      expires, flags, GFP_KERNEL);
 		}
+
+		if (had_prefixroute && !ipv6_addr_any(&ifp->peer_addr))
+			rc = modify_prefix_route(ifp, expires, flags, true);
+
+		if (rc == -ENOENT && !ipv6_addr_any(&ifp->peer_addr)) {
+			addrconf_prefix_route(&ifp->peer_addr, ifp->prefix_len,
+					      ifp->rt_priority, ifp->idev->dev,
+					      expires, flags, GFP_KERNEL);
+		}
 	} else if (had_prefixroute) {
 		enum cleanup_prefix_rt_t action;
 		unsigned long rt_expires;


