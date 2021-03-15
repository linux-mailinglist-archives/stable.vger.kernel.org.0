Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFF933B844
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhCOOCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhCOOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5426364F6E;
        Mon, 15 Mar 2021 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816788;
        bh=Urk2Yb0PYFEln6/sAQFmJc+KSUuE1VgJnDV/ISFiNWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reUofijc1O0ka54A1ONk/sdaqXT6pboHwJxivSXKT8QUh4jhN7tvicYWClk8RoECV
         lNXvXL9YUJVjAOx+NL/YoqdbRBz07bQSbEybxDRPwKZhI2NMLJff3lvDWeFR58qaTF
         V3y+fZEGrm/jUwFS2qrhFPQfGnivtfFskIOrSH5A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/290] net: dsa: trailer: dont allocate additional memory for padding/tagging
Date:   Mon, 15 Mar 2021 14:53:28 +0100
Message-Id: <20210315135545.807996307@linuxfoundation.org>
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

[ Upstream commit ef3f72fee286bd270453ce2344feb7295a798508 ]

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_trailer.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 3a1cc24a4f0a..5b97ede56a0f 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -13,42 +13,15 @@
 static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
-	int padlen;
 	u8 *trailer;
 
-	/*
-	 * We have to make sure that the trailer ends up as the very
-	 * last 4 bytes of the packet.  This means that we have to pad
-	 * the packet to the minimum ethernet frame size, if necessary,
-	 * before adding the trailer.
-	 */
-	padlen = 0;
-	if (skb->len < 60)
-		padlen = 60 - skb->len;
-
-	nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 4, GFP_ATOMIC);
-	if (!nskb)
-		return NULL;
-	skb_reserve(nskb, NET_IP_ALIGN);
-
-	skb_reset_mac_header(nskb);
-	skb_set_network_header(nskb, skb_network_header(skb) - skb->head);
-	skb_set_transport_header(nskb, skb_transport_header(skb) - skb->head);
-	skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-	consume_skb(skb);
-
-	if (padlen) {
-		skb_put_zero(nskb, padlen);
-	}
-
-	trailer = skb_put(nskb, 4);
+	trailer = skb_put(skb, 4);
 	trailer[0] = 0x80;
 	trailer[1] = 1 << dp->index;
 	trailer[2] = 0x10;
 	trailer[3] = 0x00;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.30.1



