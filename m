Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EB01EAA3F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgFASGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbgFASGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 478E420872;
        Mon,  1 Jun 2020 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034772;
        bh=mCYAZOYtqPhHSuF+HBntP+e3vx61FgHUMG0QbZOeItM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpkPL3kjh/LwZCItdti16+SguduLTDhE93Kh5c1r27KZWrRirRpok5hP0BFCxzxbe
         j1+DvNA9eVR7jr4A2TDa1aJNnzpie18Wvt8VxVdI0nbzqQ6kpfCYr/pbbL3b8DNTb+
         /p5QPG097ZByfXoKdxFtRxHQfrLR4k0t13FZkTGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 81/95] vti4: eliminated some duplicate code.
Date:   Mon,  1 Jun 2020 19:54:21 +0200
Message-Id: <20200601174032.964224486@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

commit f981c57ffd2d7cf2dd4b6d6f8fcb3965df42f54c upstream.

The ipip tunnel introduced in commit dd9ee3444014 ("vti4: Fix a ipip
packet processing bug in 'IPCOMP' virtual tunnel") largely duplicated
the existing vti_input and vti_recv functions.  Refactored to
deduplicate the common code.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_vti.c |   60 +++++++++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 38 deletions(-)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -50,7 +50,7 @@ static unsigned int vti_net_id __read_mo
 static int vti_tunnel_init(struct net_device *dev);
 
 static int vti_input(struct sk_buff *skb, int nexthdr, __be32 spi,
-		     int encap_type)
+		     int encap_type, bool update_skb_dev)
 {
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -65,6 +65,9 @@ static int vti_input(struct sk_buff *skb
 
 		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = tunnel;
 
+		if (update_skb_dev)
+			skb->dev = tunnel->dev;
+
 		return xfrm_input(skb, nexthdr, spi, encap_type);
 	}
 
@@ -74,47 +77,28 @@ drop:
 	return 0;
 }
 
-static int vti_input_ipip(struct sk_buff *skb, int nexthdr, __be32 spi,
-		     int encap_type)
+static int vti_input_proto(struct sk_buff *skb, int nexthdr, __be32 spi,
+			   int encap_type)
 {
-	struct ip_tunnel *tunnel;
-	const struct iphdr *iph = ip_hdr(skb);
-	struct net *net = dev_net(skb->dev);
-	struct ip_tunnel_net *itn = net_generic(net, vti_net_id);
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-				  iph->saddr, iph->daddr, 0);
-	if (tunnel) {
-		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto drop;
-
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = tunnel;
-
-		skb->dev = tunnel->dev;
-
-		return xfrm_input(skb, nexthdr, spi, encap_type);
-	}
-
-	return -EINVAL;
-drop:
-	kfree_skb(skb);
-	return 0;
+	return vti_input(skb, nexthdr, spi, encap_type, false);
 }
 
-static int vti_rcv(struct sk_buff *skb)
+static int vti_rcv(struct sk_buff *skb, __be32 spi, bool update_skb_dev)
 {
 	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
 	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
 
-	return vti_input(skb, ip_hdr(skb)->protocol, 0, 0);
+	return vti_input(skb, ip_hdr(skb)->protocol, spi, 0, update_skb_dev);
 }
 
-static int vti_rcv_ipip(struct sk_buff *skb)
+static int vti_rcv_proto(struct sk_buff *skb)
 {
-	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
-	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+	return vti_rcv(skb, 0, false);
+}
 
-	return vti_input_ipip(skb, ip_hdr(skb)->protocol, ip_hdr(skb)->saddr, 0);
+static int vti_rcv_tunnel(struct sk_buff *skb)
+{
+	return vti_rcv(skb, ip_hdr(skb)->saddr, true);
 }
 
 static int vti_rcv_cb(struct sk_buff *skb, int err)
@@ -478,31 +462,31 @@ static void __net_init vti_fb_tunnel_ini
 }
 
 static struct xfrm4_protocol vti_esp4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm4_protocol vti_ah4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm4_protocol vti_ipcomp4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm_tunnel ipip_handler __read_mostly = {
-	.handler	=	vti_rcv_ipip,
+	.handler	=	vti_rcv_tunnel,
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };


