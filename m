Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6214B9A5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgA1OYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgA1OYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24B7D24686;
        Tue, 28 Jan 2020 14:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221477;
        bh=/3l2Trj3+KfJHArCZMTjN+/sNNieSLhlNJk3rYqQWU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY3zBPag6bI8j0upe0GePe/RsIM9wTPcJWEL7vJfMxFN4IRt8LupaQMopuJ6aa00n
         icj/SwbuBgGdxCuTsMoWccuG7fTv0fmjkpBpBeJ7hwyx3PXJVbMladJ5gny4jnLZ3n
         l+XBUaqdAHvRE1Q4qxQy0OxlSyfYWn3dsS2bCES8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Hughes <james.hughes@raspberrypi.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 241/271] net: usb: lan78xx: Add .ndo_features_check
Date:   Tue, 28 Jan 2020 15:06:30 +0100
Message-Id: <20200128135910.477579436@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hughes <james.hughes@raspberrypi.org>

[ Upstream commit ce896476c65d72b4b99fa09c2f33436b4198f034 ]

As reported by Eric Dumazet, there are still some outstanding
cases where the driver does not handle TSO correctly when skb's
are over a certain size. Most cases have been fixed, this patch
should ensure that forwarded SKB's that are greater than
MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
and handled correctly.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -30,6 +30,7 @@
 #include <linux/ipv6.h>
 #include <linux/mdio.h>
 #include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/microchipphy.h>
 #include <linux/of_net.h>
 #include "lan78xx.h"
@@ -3291,6 +3292,19 @@ static void lan78xx_tx_timeout(struct ne
 	tasklet_schedule(&dev->bh);
 }
 
+static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
+						struct net_device *netdev,
+						netdev_features_t features)
+{
+	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
+		features &= ~NETIF_F_GSO_MASK;
+
+	features = vlan_features_check(skb, features);
+	features = vxlan_features_check(skb, features);
+
+	return features;
+}
+
 static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_open		= lan78xx_open,
 	.ndo_stop		= lan78xx_stop,
@@ -3304,6 +3318,7 @@ static const struct net_device_ops lan78
 	.ndo_set_features	= lan78xx_set_features,
 	.ndo_vlan_rx_add_vid	= lan78xx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= lan78xx_vlan_rx_kill_vid,
+	.ndo_features_check	= lan78xx_features_check,
 };
 
 static void lan78xx_stat_monitor(unsigned long param)


