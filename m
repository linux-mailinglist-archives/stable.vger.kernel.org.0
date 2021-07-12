Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEB3C4B63
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbhGLG4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238118AbhGLGtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E770561167;
        Mon, 12 Jul 2021 06:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072290;
        bh=Ygo3Kp9OmH6W+A2OxYSc8ct0JaQwdeRUIkC0i60QSCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU6ka5JyHOcrlAG25p37sHZmQsQ/MfhQe4lHsXIi7b9fy9v07xwkKd1yC8tbMeoYJ
         os3afhdsp/WZn6gsE2RgqhJNCdTOiGry1GlpIo8mimn+8ZqUUdWqEhu+qMl6wpB60Z
         m5JapGQcfFgsPIwLYKI2RkNaR2usPHSVMX8LzYWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/593] ip6_tunnel: fix GRE6 segmentation
Date:   Mon, 12 Jul 2021 08:09:02 +0200
Message-Id: <20210712060929.018474698@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a6e3f2985a80ef6a45a17d2d9d9151f17ea3ce07 ]

Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
its callee ip6_tnl_xmit(). The latter is also used by GRE.

Since commit 38720352412a ("gre: Use inner_proto to obtain inner
header protocol") GRE had been depending on skb->inner_protocol
during segmentation. It sets it in gre_build_header() and reads
it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
the protocol, resulting in GSO skbs getting dropped.

Note that inner_protocol is a union with inner_ipproto,
GRE uses the former while the change switched it to the latter
(always setting it to just IPPROTO_GRE).

Restore the original location of skb_set_inner_ipproto(),
it is unclear why it was moved in the first place.

Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 42ca2d05c480..08441f06afd4 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1270,8 +1270,6 @@ route_lookup:
 	if (max_headroom > dev->needed_headroom)
 		dev->needed_headroom = max_headroom;
 
-	skb_set_inner_ipproto(skb, proto);
-
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
 		return err;
@@ -1408,6 +1406,8 @@ ipxip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
+	skb_set_inner_ipproto(skb, protocol);
+
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   protocol);
 	if (err != 0) {
-- 
2.30.2



