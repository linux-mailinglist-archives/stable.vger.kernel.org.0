Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210F8341C25
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCSMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhCSMTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C60D64F6A;
        Fri, 19 Mar 2021 12:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156332;
        bh=KEpTMrMSJtlb0og6uLjfX+B730L9RzNRFcWa+QJBmHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1Lmy0Nh9ngmK7zLOHU2W1616Etn7PrIktvKku4+32q29ZuJWDl4ahp/hcx8nAJwR
         mJY6ZZv9zZ9OlHCxM66t/YxtbRQbulUeR0OBYZwNMCUu9mvmzMuLMSKwlmRRNCaB6L
         PhmVBlKzM1RfL3BMSO8Bj/+DnL3oy9LT5k+I7k+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilario Gelmetti <iochesonome@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 7/8] net: dsa: tag_mtk: fix 802.1ad VLAN egress
Date:   Fri, 19 Mar 2021 13:18:26 +0100
Message-Id: <20210319121744.340668743@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
References: <20210319121744.114946147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -20,6 +20,7 @@
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
+#define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 #define MTK_HDR_XMIT_SA_DIS		BIT(6)
@@ -28,8 +29,8 @@ static struct sk_buff *mtk_tag_xmit(stru
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 xmit_tpid;
 	u8 *mtk_tag;
-	bool is_vlan_skb = true;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
@@ -40,13 +41,20 @@ static struct sk_buff *mtk_tag_xmit(stru
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
 		if (skb_cow_head(skb, MTK_HDR_LEN) < 0)
 			return NULL;
 
+		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
-		is_vlan_skb = false;
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
@@ -54,8 +62,7 @@ static struct sk_buff *mtk_tag_xmit(stru
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
-	mtk_tag[0] = is_vlan_skb ? MTK_HDR_XMIT_TAGGED_TPID_8100 :
-		     MTK_HDR_XMIT_UNTAGGED;
+	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
 	/* Disable SA learning for multicast frames */
@@ -63,7 +70,7 @@ static struct sk_buff *mtk_tag_xmit(stru
 		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
 
 	/* Tag control information is kept for 802.1Q */
-	if (!is_vlan_skb) {
+	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
 		mtk_tag[3] = 0;
 	}


