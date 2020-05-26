Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F17199194
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbgCaJOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbgCaJOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5342072E;
        Tue, 31 Mar 2020 09:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646048;
        bh=5CvfJwbTSTp25ip8k7Gp6TZBaCo86dX6oC/nzpg0hSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvLNmILL1B36jybZBjJ4w+A2BWXb8G5pZyMO/ErwhPERrxvPt3ik3hMXq/DBmNL4/
         QoS6o/5lKirAicvdvx0L0YntvN3aJfQKLBlTpyyKHSrcGcACrpFCqdBVv9JjBLNHps
         8KBaQlu8G5EtFXlsN/WXJtNWnKY1r7GlzcixkS3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 019/155] net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_pop
Date:   Tue, 31 Mar 2020 10:57:39 +0200
Message-Id: <20200331085420.536558279@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e80f40cbe4dd51371818e967d40da8fe305db5e4 ]

Not only did this wheel did not need reinventing, but there is also
an issue with it: It doesn't remove the VLAN header in a way that
preserves the L2 payload checksum when that is being provided by the DSA
master hw.  It should recalculate checksum both for the push, before
removing the header, and for the pull afterwards. But the current
implementation is quite dizzying, with pulls followed immediately
afterwards by pushes, the memmove is done before the push, etc.  This
makes a DSA master with RX checksumming offload to print stack traces
with the infamous 'hw csum failure' message.

So remove the dsa_8021q_remove_header function and replace it with
something that actually works with inet checksumming.

Fixes: d461933638ae ("net: dsa: tag_8021q: Create helper function for removing VLAN header")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dsa/8021q.h |    7 -------
 net/dsa/tag_8021q.c       |   43 -------------------------------------------
 net/dsa/tag_sja1105.c     |   19 +++++++++----------
 3 files changed, 9 insertions(+), 60 deletions(-)

--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -28,8 +28,6 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb);
-
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -64,11 +62,6 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	return NULL;
-}
-
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -299,49 +299,6 @@ struct sk_buff *dsa_8021q_xmit(struct sk
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-/* In the DSA packet_type handler, skb->data points in the middle of the VLAN
- * tag, after tpid and before tci. This is because so far, ETH_HLEN
- * (DMAC, SMAC, EtherType) bytes were pulled.
- * There are 2 bytes of VLAN tag left in skb->data, and upper
- * layers expect the 'real' EtherType to be consumed as well.
- * Coincidentally, a VLAN header is also of the same size as
- * the number of bytes that need to be pulled.
- *
- * skb_mac_header                                      skb->data
- * |                                                       |
- * v                                                       v
- * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * +-----------------------+-----------------------+-------+-------+-------+
- * |    Destination MAC    |      Source MAC       |  TPID |  TCI  | EType |
- * +-----------------------+-----------------------+-------+-------+-------+
- * ^                                               |               |
- * |<--VLAN_HLEN-->to                              <---VLAN_HLEN--->
- * from            |
- *       >>>>>>>   v
- *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- *       >>>>>>>   +-----------------------+-----------------------+-------+
- *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
- *                 +-----------------------+-----------------------+-------+
- *                 ^                                                       ^
- * (now part of    |                                                       |
- *  skb->head)     skb_mac_header                                  skb->data
- */
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	u8 *from = skb_mac_header(skb);
-	u8 *dest = from + VLAN_HLEN;
-
-	memmove(dest, from, ETH_HLEN - VLAN_HLEN);
-	skb_pull(skb, VLAN_HLEN);
-	skb_push(skb, ETH_HLEN);
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
-	skb_pull_rcsum(skb, ETH_HLEN);
-
-	return skb;
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
-
 static const struct dsa_device_ops dsa_8021q_netdev_ops = {
 	.name		= "8021q",
 	.proto		= DSA_TAG_PROTO_8021Q,
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -238,14 +238,14 @@ static struct sk_buff *sja1105_rcv(struc
 {
 	struct sja1105_meta meta = {0};
 	int source_port, switch_id;
-	struct vlan_ethhdr *hdr;
+	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
 	bool is_tagged;
 	bool is_meta;
 
-	hdr = vlan_eth_hdr(skb);
-	tpid = ntohs(hdr->h_vlan_proto);
+	hdr = eth_hdr(skb);
+	tpid = ntohs(hdr->h_proto);
 	is_tagged = (tpid == ETH_P_SJA1105);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
@@ -254,7 +254,12 @@ static struct sk_buff *sja1105_rcv(struc
 
 	if (is_tagged) {
 		/* Normal traffic path. */
-		tci = ntohs(hdr->h_vlan_TCI);
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+
 		vid = tci & VLAN_VID_MASK;
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
@@ -283,12 +288,6 @@ static struct sk_buff *sja1105_rcv(struc
 		return NULL;
 	}
 
-	/* Delete/overwrite fake VLAN header, DSA expects to not find
-	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
-	 */
-	if (is_tagged)
-		skb = dsa_8021q_remove_header(skb);
-
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }


