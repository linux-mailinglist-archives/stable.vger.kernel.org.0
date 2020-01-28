Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D47B14B974
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgA1OcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733246AbgA1O1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA78520716;
        Tue, 28 Jan 2020 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221620;
        bh=sGzDFehRaZPVPmMg/ROjvVFMzFRiJsQGevwuvya4CHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9V8L/kmIXkTZM4TD6eTonDLFJ+d477PzVzi+YEtL92O8WdUGl5JzkPCt5Y95hQ6s
         lA8MIc1886QU1xbZbp4YEx2761CyOTWHnSE3sCN/c8MJuXS6+uP8jpohlIqPWejU4n
         jpg+CSBPTlZw6VraQD/vnGkwjxo2d5T7QaDYWrig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niko Kortstrom <niko.kortstrom@nokia.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 07/92] net: ip6_gre: fix moving ip6gre between namespaces
Date:   Tue, 28 Jan 2020 15:07:35 +0100
Message-Id: <20200128135810.196283555@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niko Kortstrom <niko.kortstrom@nokia.com>

[ Upstream commit 690afc165bb314354667f67157c1a1aea7dc797a ]

Support for moving IPv4 GRE tunnels between namespaces was added in
commit b57708add314 ("gre: add x-netns support"). The respective change
for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
namespaces.

Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1486,7 +1486,6 @@ static int ip6gre_tunnel_init_common(str
 		dev->mtu -= 8;
 
 	if (tunnel->parms.collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
 		netif_keep_dst(dev);
 	}
 	ip6gre_tnl_init_features(dev);
@@ -1914,7 +1913,6 @@ static void ip6gre_tap_setup(struct net_
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
@@ -2223,7 +2221,6 @@ static void ip6erspan_tap_setup(struct n
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);


