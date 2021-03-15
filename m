Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935A033B84E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhCOOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhCOOAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 696FE64F3E;
        Mon, 15 Mar 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816786;
        bh=hH5nnsUVrEKtD1IqMe8o0CVhKYO92yLCreFclILE9lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0de/qqLBvnc9YvMkM+wSBQTe2rJvh+QpAJ5h+0PAuHj9jMcOMYUdjOe167oM7WjAh
         0bZXrAXim/P/1hnai+x5D9/xZcE3m00/r000YiH3xA/gUOAtRz2uvI05yFW7gSeJpB
         IUaDVHL4pBDfCQYcWRysxLm1grIy6SRGQuaGhXoU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/290] net: dsa: tag_ksz: dont allocate additional memory for padding/tagging
Date:   Mon, 15 Mar 2021 14:53:27 +0100
Message-Id: <20210315135545.768141148@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 88fda8eefd9a7a7175bf4dad1d02cc0840581111 ]

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ksz.c | 73 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 64 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0a5aa982c60d..4820dbcedfa2 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -14,46 +14,6 @@
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
 
-static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
-				       struct net_device *dev, int len)
-{
-	struct sk_buff *nskb;
-	int padlen;
-
-	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
-
-	if (skb_tailroom(skb) >= padlen + len) {
-		/* Let dsa_slave_xmit() free skb */
-		if (__skb_put_padto(skb, skb->len + padlen, false))
-			return NULL;
-
-		nskb = skb;
-	} else {
-		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
-				 padlen + len, GFP_ATOMIC);
-		if (!nskb)
-			return NULL;
-		skb_reserve(nskb, NET_IP_ALIGN);
-
-		skb_reset_mac_header(nskb);
-		skb_set_network_header(nskb,
-				       skb_network_header(skb) - skb->head);
-		skb_set_transport_header(nskb,
-					 skb_transport_header(skb) - skb->head);
-		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-
-		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
-		 * skb
-		 */
-		if (skb_put_padto(nskb, nskb->len + padlen))
-			return NULL;
-
-		consume_skb(skb);
-	}
-
-	return nskb;
-}
-
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -90,23 +50,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *tag;
 	u8 *addr;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = 1 << dp->index;
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -156,18 +111,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ9477_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	val = BIT(dp->index);
 
@@ -176,7 +126,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -213,24 +163,19 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *addr;
 	u8 *tag;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = BIT(dp->index);
 
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
-- 
2.30.1



