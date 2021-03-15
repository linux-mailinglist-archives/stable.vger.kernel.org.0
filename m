Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5533B6E7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhCON7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232133AbhCON5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB2B64F36;
        Mon, 15 Mar 2021 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816670;
        bh=ULs0xDulZgZXrcyaRZxcqEYrIgBFhRxxjSfiS3yuAN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdD3jP7lEF/qbA/U4ie3NJkWeR5oj+UFmTaBVeRjefRRW0/ZPZJ4AyxwtlWeG83+G
         lRtTvbF1/sJ1tzPLtCLhiV4IvI5nl2i0yVZb6KBFLMBwmQbPQ+io15b+RaELcF9rJH
         TZh8ewC3qGCCCDWbS1GfFdFX3wwuPiUQvT94McYo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilario Gelmetti <iochesonome@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 054/306] net: dsa: tag_mtk: fix 802.1ad VLAN egress
Date:   Mon, 15 Mar 2021 14:51:57 +0100
Message-Id: <20210315135509.481199421@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: DENG Qingfang <dqfext@gmail.com>

commit 9200f515c41f4cbaeffd8fdd1d8b6373a18b1b67 upstream.

A different TPID bit is used for 802.1ad VLAN frames.

Reported-by: Ilario Gelmetti <iochesonome@gmail.com>
Fixes: f0af34317f4b ("net: dsa: mediatek: combine MediaTek tag with VLAN tag")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_mtk.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -13,6 +13,7 @@
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
+#define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 #define MTK_HDR_XMIT_SA_DIS		BIT(6)
@@ -21,8 +22,8 @@ static struct sk_buff *mtk_tag_xmit(stru
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 xmit_tpid;
 	u8 *mtk_tag;
-	bool is_vlan_skb = true;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
@@ -33,10 +34,17 @@ static struct sk_buff *mtk_tag_xmit(stru
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	if (!skb_vlan_tagged(skb)) {
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
+		break;
+	case htons(ETH_P_8021AD):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
+		break;
+	default:
+		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
-		is_vlan_skb = false;
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
@@ -44,8 +52,7 @@ static struct sk_buff *mtk_tag_xmit(stru
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
-	mtk_tag[0] = is_vlan_skb ? MTK_HDR_XMIT_TAGGED_TPID_8100 :
-		     MTK_HDR_XMIT_UNTAGGED;
+	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
 	/* Disable SA learning for multicast frames */
@@ -53,7 +60,7 @@ static struct sk_buff *mtk_tag_xmit(stru
 		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
 
 	/* Tag control information is kept for 802.1Q */
-	if (!is_vlan_skb) {
+	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
 		mtk_tag[3] = 0;
 	}


