Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E345187ECF
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgCQK4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgCQK4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 659B720658;
        Tue, 17 Mar 2020 10:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442578;
        bh=e3Klngrac4+w1f9XTSHkEg9+NXdhnqHoFjkzrrltu9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNDkHfBrkKTxDpNdwcicWXmML/iES3XysqZcbVGjBYtArOzpkJj+w5AkyWmu7xpxF
         XnITjcxZixA/Zj/kui/WB+6JGzLfAx/11miXhlAexntqIW6/JIETrdIdX7AzeTFHz2
         ig2Vo35zpzFt+3HdOdUUjWkKCY2tMmGbwmyVSlBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 11/89] net/ipv6: use configured metric when add peer route
Date:   Tue, 17 Mar 2020 11:54:20 +0100
Message-Id: <20200317103301.168886715@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 07758eb9ff52794fba15d03aa88d92dbd1b7d125 ]

When we add peer address with metric configured, IPv4 could set the dest
metric correctly, but IPv6 do not. e.g.

]# ip addr add 192.0.2.1 peer 192.0.2.2/32 dev eth1 metric 20
]# ip route show dev eth1
192.0.2.2 proto kernel scope link src 192.0.2.1 metric 20
]# ip addr add 2001:db8::1 peer 2001:db8::2/128 dev eth1 metric 20
]# ip -6 route show dev eth1
2001:db8::1 proto kernel metric 20 pref medium
2001:db8::2 proto kernel metric 256 pref medium

Fix this by using configured metric instead of default one.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5706,9 +5706,9 @@ static void __ipv6_ifa_notify(int event,
 		if (ifp->idev->cnf.forwarding)
 			addrconf_join_anycast(ifp);
 		if (!ipv6_addr_any(&ifp->peer_addr))
-			addrconf_prefix_route(&ifp->peer_addr, 128, 0,
-					      ifp->idev->dev, 0, 0,
-					      GFP_ATOMIC);
+			addrconf_prefix_route(&ifp->peer_addr, 128,
+					      ifp->rt_priority, ifp->idev->dev,
+					      0, 0, GFP_ATOMIC);
 		break;
 	case RTM_DELADDR:
 		if (ifp->idev->cnf.forwarding)


