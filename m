Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157331EADF3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgFASGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbgFASGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1483E20C56;
        Mon,  1 Jun 2020 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034797;
        bh=1q76AKLut37keO81ctLOOpvemMv53SYFxyccq4xJPQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mQavoBLXK49gUYiVp6YfkpOM0XNSXoaqp+8vbJM7sxNOQYAwUpux22NIHG1DOHW8
         9dvwWB+RsiCMyEV17x5FDe7QpoWlOC1JDm6H3N2/pqFcYfpwX5Qmsku0h2L6Gv4ZfW
         8ipyAo51EGmns1RXxP7c6UDNd+cFDeW7bBgWAou0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 004/142] net: dsa: mt7530: fix roaming from DSA user ports
Date:   Mon,  1 Jun 2020 19:52:42 +0200
Message-Id: <20200601174038.507044694@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

[ Upstream commit 5e5502e012b8129e11be616acb0f9c34bc8f8adb ]

When a client moves from a DSA user port to a software port in a bridge,
it cannot reach any other clients that connected to the DSA user ports.
That is because SA learning on the CPU port is disabled, so the switch
ignores the client's frames from the CPU port and still thinks it is at
the user port.

Fix it by enabling SA learning on the CPU port.

To prevent the switch from learning from flooding frames from the CPU
port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
and let the switch flood them instead of trapping to the CPU port.
Multicast frames still need to be trapped to the CPU port for snooping,
so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
to disable SA learning.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    9 ++-------
 drivers/net/dsa/mt7530.h |    1 +
 net/dsa/tag_mtk.c        |   15 +++++++++++++++
 3 files changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -639,11 +639,8 @@ mt7530_cpu_port_enable(struct mt7530_pri
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Disable auto learning on the cpu port */
-	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
-
-	/* Unknown unicast frame fordwarding to the cpu port */
-	mt7530_set(priv, MT7530_MFC, UNU_FFP(BIT(port)));
+	/* Unknown multicast frame forwarding to the cpu port */
+	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
@@ -1246,8 +1243,6 @@ mt7530_setup(struct dsa_switch *ds)
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-	mt7530_clear(priv, MT7530_MFC, UNU_FFP_MASK);
-
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -31,6 +31,7 @@ enum {
 #define MT7530_MFC			0x10
 #define  BC_FFP(x)			(((x) & 0xff) << 24)
 #define  UNM_FFP(x)			(((x) & 0xff) << 16)
+#define  UNM_FFP_MASK			UNM_FFP(~0)
 #define  UNU_FFP(x)			(((x) & 0xff) << 8)
 #define  UNU_FFP_MASK			UNU_FFP(~0)
 #define  CPU_EN				BIT(7)
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -15,6 +15,7 @@
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
+#define MTK_HDR_XMIT_SA_DIS		BIT(6)
 
 static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
@@ -22,6 +23,9 @@ static struct sk_buff *mtk_tag_xmit(stru
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *mtk_tag;
 	bool is_vlan_skb = true;
+	unsigned char *dest = eth_hdr(skb)->h_dest;
+	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
+				!is_broadcast_ether_addr(dest);
 
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
@@ -47,6 +51,10 @@ static struct sk_buff *mtk_tag_xmit(stru
 		     MTK_HDR_XMIT_UNTAGGED;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
+	/* Disable SA learning for multicast frames */
+	if (unlikely(is_multicast_skb))
+		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
+
 	/* Tag control information is kept for 802.1Q */
 	if (!is_vlan_skb) {
 		mtk_tag[2] = 0;
@@ -61,6 +69,9 @@ static struct sk_buff *mtk_tag_rcv(struc
 {
 	int port;
 	__be16 *phdr, hdr;
+	unsigned char *dest = eth_hdr(skb)->h_dest;
+	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
+				!is_broadcast_ether_addr(dest);
 
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
@@ -86,6 +97,10 @@ static struct sk_buff *mtk_tag_rcv(struc
 	if (!skb->dev)
 		return NULL;
 
+	/* Only unicast or broadcast frames are offloaded */
+	if (likely(!is_multicast_skb))
+		skb->offload_fwd_mark = 1;
+
 	return skb;
 }
 


