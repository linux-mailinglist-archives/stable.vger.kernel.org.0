Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480EAB5CEC
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfIRGa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729883AbfIRGYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C271021920;
        Wed, 18 Sep 2019 06:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787877;
        bh=BIqPyxDhQFWcJ1fCOfLaBJ1+/q0tWDGLpDzbeYHGRMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPswLC3UBUWUmRnxGF7ry8ihLmOLj6NgmGuaJ0bvNgxWdOppGsPie/Le1LyUg7cV8
         1YYdpwPA3u92m6ce14AViXVUWb9wcfIBwFaBNjtZHOM7e3vH6+tqbRNxtHtmtS0Bot
         9BFU4TsbZcsyEgsH6W7IVIvfuj62Yr+AbmFY/ULA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 17/85] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)
Date:   Wed, 18 Sep 2019 08:18:35 +0200
Message-Id: <20190918061234.695483315@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej Żenczykowski" <maze@google.com>

[ Upstream commit d55a2e374a94fa34a3048c6a2be535266e506d97 ]

There is a subtle change in behaviour introduced by:
  commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
  'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'

Before that patch /proc/net/ipv6_route includes:
00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo

Afterwards /proc/net/ipv6_route includes:
00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo

ie. the above commit causes the ::1/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).

AFAICT, this is incorrect since these routes are *not* coming from RA's.

As such, this patch restores the old behaviour.

Fixes: c7a1ce397ada ("ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create")
Cc: David Ahern <dsahern@gmail.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3841,13 +3841,14 @@ struct fib6_info *addrconf_f6i_alloc(str
 	struct fib6_config cfg = {
 		.fc_table = l3mdev_fib_table(idev->dev) ? : RT6_TABLE_LOCAL,
 		.fc_ifindex = idev->dev->ifindex,
-		.fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,
+		.fc_flags = RTF_UP | RTF_NONEXTHOP,
 		.fc_dst = *addr,
 		.fc_dst_len = 128,
 		.fc_protocol = RTPROT_KERNEL,
 		.fc_nlinfo.nl_net = net,
 		.fc_ignore_dev_down = true,
 	};
+	struct fib6_info *f6i;
 
 	if (anycast) {
 		cfg.fc_type = RTN_ANYCAST;
@@ -3857,7 +3858,10 @@ struct fib6_info *addrconf_f6i_alloc(str
 		cfg.fc_flags |= RTF_LOCAL;
 	}
 
-	return ip6_route_info_create(&cfg, gfp_flags, NULL);
+	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
+	if (f6i)
+		f6i->dst_nocount = true;
+	return f6i;
 }
 
 /* remove deleted ip from prefsrc entries */


