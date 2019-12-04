Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EE0113238
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfLDSGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbfLDSGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:33 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B02D20674;
        Wed,  4 Dec 2019 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482792;
        bh=OUxMEqaedTerczHBI7WUPaEO4Ds7NoVMV/fIilPn1tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjRdYUI3pDktxWO/aXFyQcHeCIuOaxWsSnohMGjiZLuc7iFz1zbcVNo+r6gqdkOow
         Fz0PHarssx32tcpOwbRde0KBVfPzc6GWxud2z85SAxCgmv7TYfNZ6mixTIW1T72VJW
         Y3wjrcaXfaEowfNvobKTTHwD50jwGNFIP9H1kX1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 134/209] ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel
Date:   Wed,  4 Dec 2019 18:55:46 +0100
Message-Id: <20191204175332.445673372@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit d71b57532d70c03f4671dd04e84157ac6bf021b0 ]

ip l add dev tun type gretap key 1000
ip a a dev tun 10.0.0.1/24

Packets with tun-id 1000 can be recived by tun dev. But packet can't
be sent through dev tun for non-tunnel-dst

With this patch: tunnel-dst can be get through lwtunnel like beflow:
ip r a 10.0.0.7 encap ip dst 172.168.0.11 dev tun

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index fabc299cb875f..7a31287ff1232 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -661,13 +661,19 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	dst = tnl_params->daddr;
 	if (dst == 0) {
 		/* NBMA tunnel */
+		struct ip_tunnel_info *tun_info;
 
 		if (!skb_dst(skb)) {
 			dev->stats.tx_fifo_errors++;
 			goto tx_error;
 		}
 
-		if (skb->protocol == htons(ETH_P_IP)) {
+		tun_info = skb_tunnel_info(skb);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX) &&
+		    ip_tunnel_info_af(tun_info) == AF_INET &&
+		    tun_info->key.u.ipv4.dst)
+			dst = tun_info->key.u.ipv4.dst;
+		else if (skb->protocol == htons(ETH_P_IP)) {
 			rt = skb_rtable(skb);
 			dst = rt_nexthop(rt, inner_iph->daddr);
 		}
-- 
2.20.1



