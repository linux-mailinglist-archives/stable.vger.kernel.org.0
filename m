Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D762150D33
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgBCQdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730173AbgBCQdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:51 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7846521775;
        Mon,  3 Feb 2020 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747629;
        bh=FGJN0gO2TBuNggdZwA7nnuBdLJL26KjsnjsQZvVTKJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcSlloEw0k+J+vV1HXwJDLV/A7rCNGZ6gLDRT7XYALFVcOOybFyhZDJRv1udOddgz
         FFcQluVpEs0uitNnMPcEcnPD3Srz4VCdl58LpOSuEgV38VpDzKPXm0BAyLJHmpC7QU
         F+brz9wm/b97Iu/5hXBrmLIIz3bP9Tq1M8H6yWls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/70] xfrm interface: fix packet tx through bpf_redirect()
Date:   Mon,  3 Feb 2020 16:20:07 +0000
Message-Id: <20200203161920.275797541@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit f042365dbffea98fb8148c98c700402e8d099f02 ]

With an ebpf program that redirects packets through a xfrm interface,
packets are dropped because no dst is attached to skb.

This could also be reproduced with an AF_PACKET socket, with the following
python script (xfrm1 is a xfrm interface):

 import socket
 send_s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, 0)
 # scapy
 # p = IP(src='10.100.0.2', dst='10.200.0.1')/ICMP(type='echo-request')
 # raw(p)
 req = b'E\x00\x00\x1c\x00\x01\x00\x00@\x01e\xb2\nd\x00\x02\n\xc8\x00\x01\x08\x00\xf7\xff\x00\x00\x00\x00'
 send_s.sendto(req, ('xfrm1', 0x800, 0, 0))

It was also not possible to send an ip packet through an AF_PACKET socket
because a LL header was expected. Let's remove those LL header constraints.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 4ee512622e93d..20565a4742112 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -268,9 +268,6 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	int err = -1;
 	int mtu;
 
-	if (!dst)
-		goto tx_err_link_failure;
-
 	dst_hold(dst);
 	dst = xfrm_lookup_with_ifid(xi->net, dst, fl, NULL, 0, xi->p.if_id);
 	if (IS_ERR(dst)) {
@@ -343,6 +340,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net_device_stats *stats = &xi->dev->stats;
+	struct dst_entry *dst = skb_dst(skb);
 	struct flowi fl;
 	int ret;
 
@@ -352,10 +350,33 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 	case htons(ETH_P_IPV6):
 		xfrm_decode_session(skb, &fl, AF_INET6);
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		if (!dst) {
+			fl.u.ip6.flowi6_oif = dev->ifindex;
+			fl.u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+			dst = ip6_route_output(dev_net(dev), NULL, &fl.u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				stats->tx_carrier_errors++;
+				goto tx_err;
+			}
+			skb_dst_set(skb, dst);
+		}
 		break;
 	case htons(ETH_P_IP):
 		xfrm_decode_session(skb, &fl, AF_INET);
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+		if (!dst) {
+			struct rtable *rt;
+
+			fl.u.ip4.flowi4_oif = dev->ifindex;
+			fl.u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+			rt = __ip_route_output_key(dev_net(dev), &fl.u.ip4);
+			if (IS_ERR(rt)) {
+				stats->tx_carrier_errors++;
+				goto tx_err;
+			}
+			skb_dst_set(skb, &rt->dst);
+		}
 		break;
 	default:
 		goto tx_err;
@@ -566,12 +587,9 @@ static void xfrmi_dev_setup(struct net_device *dev)
 {
 	dev->netdev_ops 	= &xfrmi_netdev_ops;
 	dev->type		= ARPHRD_NONE;
-	dev->hard_header_len 	= ETH_HLEN;
-	dev->min_header_len	= ETH_HLEN;
 	dev->mtu		= ETH_DATA_LEN;
 	dev->min_mtu		= ETH_MIN_MTU;
-	dev->max_mtu		= ETH_DATA_LEN;
-	dev->addr_len		= ETH_ALEN;
+	dev->max_mtu		= IP_MAX_MTU;
 	dev->flags 		= IFF_NOARP;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= xfrmi_dev_free;
-- 
2.20.1



