Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC14188133
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgCQLJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgCQLJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A443A205ED;
        Tue, 17 Mar 2020 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443381;
        bh=fpdVKyaAWG/7uJmchGNUYgPuUcV2lp3/K0fJgQue35U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDU3es6dJ/LgIOShi3fr00lyudCK0LxWiOXhhWE8ngnTdK9Hh/V8DYDDjKcWcsUyE
         dcLP/keCUQ0BHdikQPuqj6hV5zFNEyb/CG0WE5qGhWInJyFpaGXe3t2GDfbsMe9mKX
         cHpWPJ5jkc1vq+GXAt+SLOlUozhZ3UOowG9pKahs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 065/151] net/ipv6: remove the old peer route if change it to a new one
Date:   Tue, 17 Mar 2020 11:54:35 +0100
Message-Id: <20200317103331.135780177@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit d0098e4c6b83e502cc1cd96d67ca86bc79a6c559 ]

When we modify the peer route and changed it to a new one, we should
remove the old route first. Before the fix:

+ ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::2 proto kernel metric 256 pref medium
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::2 proto kernel metric 256 pref medium

After the fix:
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::3 proto kernel metric 256 pref medium

This patch depend on the previous patch "net/ipv6: need update peer route
when modify metric" to update new peer route after delete old one.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1226,11 +1226,13 @@ check_cleanup_prefix_route(struct inet6_
 }
 
 static void
-cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires, bool del_rt)
+cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
+		     bool del_rt, bool del_peer)
 {
 	struct fib6_info *f6i;
 
-	f6i = addrconf_get_prefix_route(&ifp->addr, ifp->prefix_len,
+	f6i = addrconf_get_prefix_route(del_peer ? &ifp->peer_addr : &ifp->addr,
+					ifp->prefix_len,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (f6i) {
 		if (del_rt)
@@ -1293,7 +1295,7 @@ static void ipv6_del_addr(struct inet6_i
 
 	if (action != CLEANUP_PREFIX_RT_NOP) {
 		cleanup_prefix_route(ifp, expires,
-			action == CLEANUP_PREFIX_RT_DEL);
+			action == CLEANUP_PREFIX_RT_DEL, false);
 	}
 
 	/* clean up prefsrc entries */
@@ -4631,6 +4633,7 @@ static int inet6_addr_modify(struct inet
 	unsigned long timeout;
 	bool was_managetempaddr;
 	bool had_prefixroute;
+	bool new_peer = false;
 
 	ASSERT_RTNL();
 
@@ -4662,6 +4665,13 @@ static int inet6_addr_modify(struct inet
 		cfg->preferred_lft = timeout;
 	}
 
+	if (cfg->peer_pfx &&
+	    memcmp(&ifp->peer_addr, cfg->peer_pfx, sizeof(struct in6_addr))) {
+		if (!ipv6_addr_any(&ifp->peer_addr))
+			cleanup_prefix_route(ifp, expires, true, true);
+		new_peer = true;
+	}
+
 	spin_lock_bh(&ifp->lock);
 	was_managetempaddr = ifp->flags & IFA_F_MANAGETEMPADDR;
 	had_prefixroute = ifp->flags & IFA_F_PERMANENT &&
@@ -4677,6 +4687,9 @@ static int inet6_addr_modify(struct inet
 	if (cfg->rt_priority && cfg->rt_priority != ifp->rt_priority)
 		ifp->rt_priority = cfg->rt_priority;
 
+	if (new_peer)
+		ifp->peer_addr = *cfg->peer_pfx;
+
 	spin_unlock_bh(&ifp->lock);
 	if (!(ifp->flags&IFA_F_TENTATIVE))
 		ipv6_ifa_notify(0, ifp);
@@ -4712,7 +4725,7 @@ static int inet6_addr_modify(struct inet
 
 		if (action != CLEANUP_PREFIX_RT_NOP) {
 			cleanup_prefix_route(ifp, rt_expires,
-				action == CLEANUP_PREFIX_RT_DEL);
+				action == CLEANUP_PREFIX_RT_DEL, false);
 		}
 	}
 


