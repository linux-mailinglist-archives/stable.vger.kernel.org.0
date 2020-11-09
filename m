Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83DA2ABB22
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbgKINYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733301AbgKINSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6606206D8;
        Mon,  9 Nov 2020 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927923;
        bh=L2V8POW7BWB/ifqq4z9lxumBZZbLrKbTyY5mf+3pfwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0ZdnGgsRU3Zel4oowy0Yc8btkeZkH3dKv5IqEgYl/nIM2GvATKf441CoY8hKtcFM
         j3BQKHKviGSbJS1Jxkn3ikB/85aJovMT0HscrvE4OacCyOnhQNCHGK3ebjm1QR+r/W
         +wpmzz5jDuwFzj4sy5DbP3g6MUw/0nVKfpP9dhiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 037/133] ip6_tunnel: set inner ipproto before ip6_tnl_encap
Date:   Mon,  9 Nov 2020 13:54:59 +0100
Message-Id: <20201109125032.497762895@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Ovechkin <ovov@yandex-team.ru>

[ Upstream commit 9e7c5b396e98eed859d3dd1ab235912a296faab5 ]

ip6_tnl_encap assigns to proto transport protocol which
encapsulates inner packet, but we must pass to set_inner_ipproto
protocol of that inner packet.

Calling set_inner_ipproto after ip6_tnl_encap might break gso.
For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto
would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
incorrect calling sequence of gso functions:
ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
instead of:
ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment

Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Link: https://lore.kernel.org/r/20201029171012.20904-1-ovov@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1271,6 +1271,8 @@ route_lookup:
 	if (max_headroom > dev->needed_headroom)
 		dev->needed_headroom = max_headroom;
 
+	skb_set_inner_ipproto(skb, proto);
+
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
 		return err;
@@ -1280,8 +1282,6 @@ route_lookup:
 		ipv6_push_frag_opts(skb, &opt.ops, &proto);
 	}
 
-	skb_set_inner_ipproto(skb, proto);
-
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	ipv6h = ipv6_hdr(skb);


