Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06FF2D03B6
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgLFLj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgLFLj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:57 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maria Pasechnik <mariap@mellanox.com>,
        Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 19/32] net: ip6_gre: set dev->hard_header_len when using header_ops
Date:   Sun,  6 Dec 2020 12:17:19 +0100
Message-Id: <20201206111556.680041926@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 832ba596494b2c9eac7760259eff2d8b7dcad0ee ]

syzkaller managed to crash the kernel using an NBMA ip6gre interface. I
could reproduce it creating an NBMA ip6gre interface and forwarding
traffic to it:

  skbuff: skb_under_panic: text:ffffffff8250e927 len:148 put:44 head:ffff8c03c7a33
  ------------[ cut here ]------------
  kernel BUG at net/core/skbuff.c:109!
  Call Trace:
  skb_push+0x10/0x10
  ip6gre_header+0x47/0x1b0
  neigh_connected_output+0xae/0xf0

ip6gre tunnel provides its own header_ops->create, and sets it
conditionally when initializing the tunnel in NBMA mode. When
header_ops->create is used, dev->hard_header_len should reflect the
length of the header created. Otherwise, when not used,
dev->needed_headroom should be used.

Fixes: eb95f52fc72d ("net: ipv6_gre: Fix GRO to work on IPv6 over GRE tap")
Cc: Maria Pasechnik <mariap@mellanox.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20201130161911.464106-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1140,8 +1140,13 @@ static void ip6gre_tnl_link_config_route
 			return;
 
 		if (rt->dst.dev) {
-			dev->needed_headroom = rt->dst.dev->hard_header_len +
-					       t_hlen;
+			unsigned short dst_len = rt->dst.dev->hard_header_len +
+						 t_hlen;
+
+			if (t->dev->header_ops)
+				dev->hard_header_len = dst_len;
+			else
+				dev->needed_headroom = dst_len;
 
 			if (set_mtu) {
 				dev->mtu = rt->dst.dev->mtu - t_hlen;
@@ -1166,7 +1171,12 @@ static int ip6gre_calc_hlen(struct ip6_t
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 
 	t_hlen = tunnel->hlen + sizeof(struct ipv6hdr);
-	tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
+
+	if (tunnel->dev->header_ops)
+		tunnel->dev->hard_header_len = LL_MAX_HEADER + t_hlen;
+	else
+		tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
+
 	return t_hlen;
 }
 


