Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF93ED50C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhHPNHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236742AbhHPNG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934AD600D4;
        Mon, 16 Aug 2021 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119157;
        bh=wJhnLijUpO5g66t/LWMUzQYTDhuZXsDNJEG1cdAeMGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8j/tMzl61qcc61CNJu656QrNgxP074HggNXQhRimhn7lQc0Mcq61rPwGLmyx1Kx0
         psPLle7QEUha+qV9jDWxqbYKu7Vx7B/6EASCtsupCLOqrpC4+yXbtPxc8Z8b/0EhHa
         CdcismczLkANZWriV8e3wWq5mpFjNi/NFEKSAyss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@essensium.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 14/96] net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases
Date:   Mon, 16 Aug 2021 15:01:24 +0200
Message-Id: <20210816125435.400148998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit acc68b8d2a1196c4db806947606f162dbeed2274 upstream.

The CPSW switchdev driver inherited fix from commit 9421c9015047 ("net:
ethernet: ti: cpsw: fix min eth packet size") which changes min TX packet
size to 64bytes (VLAN_ETH_ZLEN, excluding ETH_FCS). It was done to fix HW
packed drop issue when packets are sent from Host to the port with PVID and
un-tagging enabled. Unfortunately this breaks some other non-switch
specific use-cases, like:
- [1] CPSW port as DSA CPU port with DSA-tag applied at the end of the
packet
- [2] Some industrial protocols, which expects min TX packet size 60Bytes
(excluding FCS).

Fix it by configuring min TX packet size depending on driver mode
 - 60Bytes (ETH_ZLEN) for multi mac (dual-mac) mode
 - 64Bytes (VLAN_ETH_ZLEN) for switch mode
and update it during driver mode change and annotate with
READ_ONCE()/WRITE_ONCE() as it can be read by napi while writing.

[1] https://lore.kernel.org/netdev/20210531124051.GA15218@cephalopod/
[2] https://e2e.ti.com/support/arm/sitara_arm/f/791/t/701669

Cc: stable@vger.kernel.org
Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Reported-by: Ben Hutchings <ben.hutchings@essensium.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_new.c  |    7 +++++--
 drivers/net/ethernet/ti/cpsw_priv.h |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -928,7 +928,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(s
 	struct cpdma_chan *txch;
 	int ret, q_idx;
 
-	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
+	if (skb_put_padto(skb, READ_ONCE(priv->tx_packet_min))) {
 		cpsw_err(priv, tx_err, "packet pad failed\n");
 		ndev->stats.tx_dropped++;
 		return NET_XMIT_DROP;
@@ -1108,7 +1108,7 @@ static int cpsw_ndo_xdp_xmit(struct net_
 
 	for (i = 0; i < n; i++) {
 		xdpf = frames[i];
-		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
+		if (xdpf->len < READ_ONCE(priv->tx_packet_min)) {
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
 			continue;
@@ -1402,6 +1402,7 @@ static int cpsw_create_ports(struct cpsw
 		priv->dev  = dev;
 		priv->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
 		priv->emac_port = i + 1;
+		priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
 
 		if (is_valid_ether_addr(slave_data->mac_addr)) {
 			ether_addr_copy(priv->mac_addr, slave_data->mac_addr);
@@ -1699,6 +1700,7 @@ static int cpsw_dl_switch_mode_set(struc
 
 			priv = netdev_priv(sl_ndev);
 			slave->port_vlan = vlan;
+			WRITE_ONCE(priv->tx_packet_min, CPSW_MIN_PACKET_SIZE_VLAN);
 			if (netif_running(sl_ndev))
 				cpsw_port_add_switch_def_ale_entries(priv,
 								     slave);
@@ -1727,6 +1729,7 @@ static int cpsw_dl_switch_mode_set(struc
 
 			priv = netdev_priv(slave->ndev);
 			slave->port_vlan = slave->data->dual_emac_res_vlan;
+			WRITE_ONCE(priv->tx_packet_min, CPSW_MIN_PACKET_SIZE);
 			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
 		}
 
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -89,7 +89,8 @@ do {								\
 
 #define CPSW_POLL_WEIGHT	64
 #define CPSW_RX_VLAN_ENCAP_HDR_SIZE		4
-#define CPSW_MIN_PACKET_SIZE	(VLAN_ETH_ZLEN)
+#define CPSW_MIN_PACKET_SIZE_VLAN	(VLAN_ETH_ZLEN)
+#define CPSW_MIN_PACKET_SIZE	(ETH_ZLEN)
 #define CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN +\
 				 ETH_FCS_LEN +\
 				 CPSW_RX_VLAN_ENCAP_HDR_SIZE)
@@ -380,6 +381,7 @@ struct cpsw_priv {
 	u32 emac_port;
 	struct cpsw_common *cpsw;
 	int offload_fwd_mark;
+	u32 tx_packet_min;
 };
 
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)


