Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8216E1CAEB8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgEHMqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbgEHMqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864FB2145D;
        Fri,  8 May 2020 12:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941996;
        bh=/edro/A+J2bMGGxVR6fLVLDN4sc4mxIDHGqvWM8I/S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ez8iCmy4CytBzCoZG2+9NkRh4LlzcRYTApuPieH4LFuJ7NBbt3K2qFaMvns7njjGo
         8n76hHgvkrgxbtmQpDRh8JYEj+6I9wJnLkpnZu3tc16Iq8FIOtRWYbQJDtqK9vK5JH
         ZrLEIcLlQzVrEahX92S+rXQnyYCP3iXT/ptaTNTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 255/312] gre: build header correctly for collect metadata tunnels
Date:   Fri,  8 May 2020 14:34:06 +0200
Message-Id: <20200508123142.335957456@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

commit 2090714e1d6e80979dd6926be22b0de9ca432273 upstream.

In ipgre (i.e. not gretap) + collect metadata mode, the skb was assumed to
contain Ethernet header and was encapsulated as ETH_P_TEB. This is not the
case, the interface is ARPHRD_IPGRE and the protocol to be used for
encapsulation is skb->protocol.

Fixes: 2e15ea390e6f4 ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_gre.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -520,7 +520,8 @@ static struct rtable *gre_get_rt(struct
 	return ip_route_output_key(net, fl);
 }
 
-static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev)
+static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
+			__be16 proto)
 {
 	struct ip_tunnel_info *tun_info;
 	const struct ip_tunnel_key *key;
@@ -563,7 +564,7 @@ static void gre_fb_xmit(struct sk_buff *
 	}
 
 	flags = tun_info->key.tun_flags & (TUNNEL_CSUM | TUNNEL_KEY);
-	build_header(skb, tunnel_hlen, flags, htons(ETH_P_TEB),
+	build_header(skb, tunnel_hlen, flags, proto,
 		     tunnel_id_to_key(tun_info->key.tun_id), 0);
 
 	df = key->tun_flags & TUNNEL_DONT_FRAGMENT ?  htons(IP_DF) : 0;
@@ -605,7 +606,7 @@ static netdev_tx_t ipgre_xmit(struct sk_
 	const struct iphdr *tnl_params;
 
 	if (tunnel->collect_md) {
-		gre_fb_xmit(skb, dev);
+		gre_fb_xmit(skb, dev, skb->protocol);
 		return NETDEV_TX_OK;
 	}
 
@@ -649,7 +650,7 @@ static netdev_tx_t gre_tap_xmit(struct s
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
 	if (tunnel->collect_md) {
-		gre_fb_xmit(skb, dev);
+		gre_fb_xmit(skb, dev, htons(ETH_P_TEB));
 		return NETDEV_TX_OK;
 	}
 


