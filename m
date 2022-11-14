Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE05B6280CD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbiKNNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbiKNNJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01139FC4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD21B80EBB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9532C433C1;
        Mon, 14 Nov 2022 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431351;
        bh=1Ec09Ydr1bB22QY9SO3+xH2bNzLdxuVvnmMaATfwzN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SILDpaq55iB0+Cj+OAkYDplPAPSbFhAUdeHsYyulwqXBZ+VjF5YtLNdGKrPboJ5D7
         IxjOnTsFhYZbG8a3yMbkqgzbSZiVD8mUswaU6Th2H9bsGF0iXhRCgsLtI7T3/Ssl21
         epvFj5CTzUyxg11ru7D6BbcuG9wNvfzwjGILNZls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 173/190] can: dev: fix skb drop check
Date:   Mon, 14 Nov 2022 13:46:37 +0100
Message-Id: <20221114124506.423444759@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit ae64438be1923e3c1102d90fd41db7afcfaf54cc upstream.

In commit a6d190f8c767 ("can: skb: drop tx skb if in listen only
mode") the priv->ctrlmode element is read even on virtual CAN
interfaces that do not create the struct can_priv at startup. This
out-of-bounds read may lead to CAN frame drops for virtual CAN
interfaces like vcan and vxcan.

This patch mainly reverts the original commit and adds a new helper
for CAN interface drivers that provide the required information in
struct can_priv.

Fixes: a6d190f8c767 ("can: skb: drop tx skb if in listen only mode")
Reported-by: Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Max Staudt <max@enpas.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221102095431.36831-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org # 6.0.x
[mkl: patch pch_can, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/at91_can.c                       |    2 +-
 drivers/net/can/c_can/c_can_main.c               |    2 +-
 drivers/net/can/can327.c                         |    2 +-
 drivers/net/can/cc770/cc770.c                    |    2 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c         |    2 +-
 drivers/net/can/dev/skb.c                        |    9 +--------
 drivers/net/can/flexcan/flexcan-core.c           |    2 +-
 drivers/net/can/grcan.c                          |    2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c            |    2 +-
 drivers/net/can/janz-ican3.c                     |    2 +-
 drivers/net/can/kvaser_pciefd.c                  |    2 +-
 drivers/net/can/m_can/m_can.c                    |    2 +-
 drivers/net/can/mscan/mscan.c                    |    2 +-
 drivers/net/can/pch_can.c                        |    2 +-
 drivers/net/can/peak_canfd/peak_canfd.c          |    2 +-
 drivers/net/can/rcar/rcar_can.c                  |    2 +-
 drivers/net/can/rcar/rcar_canfd.c                |    2 +-
 drivers/net/can/sja1000/sja1000.c                |    2 +-
 drivers/net/can/slcan/slcan-core.c               |    2 +-
 drivers/net/can/softing/softing_main.c           |    2 +-
 drivers/net/can/spi/hi311x.c                     |    2 +-
 drivers/net/can/spi/mcp251x.c                    |    2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c     |    2 +-
 drivers/net/can/sun4i_can.c                      |    2 +-
 drivers/net/can/ti_hecc.c                        |    2 +-
 drivers/net/can/usb/ems_usb.c                    |    2 +-
 drivers/net/can/usb/esd_usb.c                    |    2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c      |    2 +-
 drivers/net/can/usb/gs_usb.c                     |    2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    2 +-
 drivers/net/can/usb/mcba_usb.c                   |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |    2 +-
 drivers/net/can/usb/ucan.c                       |    2 +-
 drivers/net/can/usb/usb_8dev.c                   |    2 +-
 drivers/net/can/xilinx_can.c                     |    2 +-
 include/linux/can/dev.h                          |   16 ++++++++++++++++
 36 files changed, 51 insertions(+), 42 deletions(-)

--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -452,7 +452,7 @@ static netdev_tx_t at91_start_xmit(struc
 	unsigned int mb, prio;
 	u32 reg_mid, reg_mcr;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	mb = get_tx_next_mb(priv);
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -457,7 +457,7 @@ static netdev_tx_t c_can_start_xmit(stru
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	u32 idx, obj, cmd = IF_COMM_TX;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	if (c_can_tx_busy(priv, tx_ring))
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -813,7 +813,7 @@ static netdev_tx_t can327_netdev_start_x
 	struct can327 *elm = netdev_priv(dev);
 	struct can_frame *frame = (struct can_frame *)skb->data;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	/* We shouldn't get here after a hardware fault:
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -429,7 +429,7 @@ static netdev_tx_t cc770_start_xmit(stru
 	struct cc770_priv *priv = netdev_priv(dev);
 	unsigned int mo = obj2msgobj(CC770_OBJ_TX);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -600,7 +600,7 @@ static netdev_tx_t ctucan_start_xmit(str
 	bool ok;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (unlikely(!CTU_CAN_FD_TXTNF(priv))) {
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/can/dev.h>
-#include <linux/can/netlink.h>
 #include <linux/module.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -300,7 +299,6 @@ static bool can_skb_headroom_valid(struc
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-	struct can_priv *priv = netdev_priv(dev);
 
 	if (skb->protocol == htons(ETH_P_CAN)) {
 		if (unlikely(skb->len != CAN_MTU ||
@@ -314,13 +312,8 @@ bool can_dropped_invalid_skb(struct net_
 		goto inval_skb;
 	}
 
-	if (!can_skb_headroom_valid(dev, skb)) {
-		goto inval_skb;
-	} else if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
-		netdev_info_once(dev,
-				 "interface in listen only mode, dropping skb\n");
+	if (!can_skb_headroom_valid(dev, skb))
 		goto inval_skb;
-	}
 
 	return false;
 
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -742,7 +742,7 @@ static netdev_tx_t flexcan_start_xmit(st
 	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_fd_len2dlc(cfd->len)) << 16);
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1345,7 +1345,7 @@ static netdev_tx_t grcan_start_xmit(stru
 	unsigned long flags;
 	u32 oneshotmode = priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	/* Trying to transmit in silent mode will generate error interrupts, but
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -860,7 +860,7 @@ static netdev_tx_t ifi_canfd_start_xmit(
 	u32 txst, txid, txdlc;
 	int i;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	/* Check if the TX buffer is full */
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1693,7 +1693,7 @@ static netdev_tx_t ican3_xmit(struct sk_
 	void __iomem *desc_addr;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock_irqsave(&mod->lock, flags);
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -775,7 +775,7 @@ static netdev_tx_t kvaser_pciefd_start_x
 	int nwords;
 	u8 count;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	nwords = kvaser_pciefd_prepare_tx_packet(&packet, can, skb);
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1722,7 +1722,7 @@ static netdev_tx_t m_can_start_xmit(stru
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	if (cdev->is_peripheral) {
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -191,7 +191,7 @@ static netdev_tx_t mscan_start_xmit(stru
 	int i, rtr, buf_id;
 	u32 can_id;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	out_8(&regs->cantier, 0);
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -882,7 +882,7 @@ static netdev_tx_t pch_xmit(struct sk_bu
 	int i;
 	u32 id2;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	tx_obj_no = priv->tx_obj;
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -651,7 +651,7 @@ static netdev_tx_t peak_canfd_start_xmit
 	int room_left;
 	u8 len;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	msg_size = ALIGN(sizeof(*msg) + cf->len, 4);
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -590,7 +590,7 @@ static netdev_tx_t rcar_can_start_xmit(s
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	u32 data, i;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (cf->can_id & CAN_EFF_FLAG)	/* Extended frame format */
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1476,7 +1476,7 @@ static netdev_tx_t rcar_canfd_start_xmit
 	unsigned long flags;
 	u32 ch = priv->channel;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (cf->can_id & CAN_EFF_FLAG) {
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -291,7 +291,7 @@ static netdev_tx_t sja1000_start_xmit(st
 	u8 cmd_reg_val = 0x00;
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -594,7 +594,7 @@ static netdev_tx_t slcan_netdev_xmit(str
 {
 	struct slcan *sl = netdev_priv(dev);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock(&sl->lock);
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -60,7 +60,7 @@ static netdev_tx_t softing_netdev_start_
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	uint8_t buf[DPRAM_TX_SIZE];
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock(&card->spin);
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -373,7 +373,7 @@ static netdev_tx_t hi3110_hard_start_xmi
 		return NETDEV_TX_BUSY;
 	}
 
-	if (can_dropped_invalid_skb(net, skb))
+	if (can_dev_dropped_skb(net, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(net);
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -789,7 +789,7 @@ static netdev_tx_t mcp251x_hard_start_xm
 		return NETDEV_TX_BUSY;
 	}
 
-	if (can_dropped_invalid_skb(net, skb))
+	if (can_dev_dropped_skb(net, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(net);
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
@@ -172,7 +172,7 @@ netdev_tx_t mcp251xfd_start_xmit(struct
 	u8 tx_head;
 	int err;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (mcp251xfd_tx_busy(priv, tx_ring))
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -429,7 +429,7 @@ static netdev_tx_t sun4ican_start_xmit(s
 	canid_t id;
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -470,7 +470,7 @@ static netdev_tx_t ti_hecc_xmit(struct s
 	u32 mbxno, mbx_mask, data;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	mbxno = get_tx_head_mb(priv);
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -747,7 +747,7 @@ static netdev_tx_t ems_usb_start_xmit(st
 	size_t size = CPC_HEADER_SIZE + CPC_MSG_HEADER_LEN
 			+ sizeof(struct cpc_can_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -725,7 +725,7 @@ static netdev_tx_t esd_usb_start_xmit(st
 	int ret = NETDEV_TX_OK;
 	size_t size = sizeof(struct esd_usb_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1913,7 +1913,7 @@ static netdev_tx_t es58x_start_xmit(stru
 	unsigned int frame_len;
 	int ret;
 
-	if (can_dropped_invalid_skb(netdev, skb)) {
+	if (can_dev_dropped_skb(netdev, skb)) {
 		if (priv->tx_urb)
 			goto xmit_commit;
 		return NETDEV_TX_OK;
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -605,7 +605,7 @@ static netdev_tx_t gs_can_start_xmit(str
 	unsigned int idx;
 	struct gs_tx_context *txc;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* find an empty context to keep track of transmission */
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -570,7 +570,7 @@ static netdev_tx_t kvaser_usb_start_xmit
 	unsigned int i;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -311,7 +311,7 @@ static netdev_tx_t mcba_usb_start_xmit(s
 		.cmd_id = MBCA_CMD_TRANSMIT_MESSAGE_EV
 	};
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	ctx = mcba_usb_get_free_ctx(priv, cf);
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -351,7 +351,7 @@ static netdev_tx_t peak_usb_ndo_start_xm
 	int i, err;
 	size_t size = dev->adapter->tx_buffer_size;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	for (i = 0; i < PCAN_USB_MAX_TX_URBS; i++)
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1120,7 +1120,7 @@ static netdev_tx_t ucan_start_xmit(struc
 	struct can_frame *cf = (struct can_frame *)skb->data;
 
 	/* check skb */
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* allocate a context and slow down tx path, if fifo state is low */
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -602,7 +602,7 @@ static netdev_tx_t usb_8dev_start_xmit(s
 	int i, err;
 	size_t size = sizeof(struct usb_8dev_tx_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -743,7 +743,7 @@ static netdev_tx_t xcan_start_xmit(struc
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES)
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -147,6 +147,22 @@ static inline u32 can_get_static_ctrlmod
 	return priv->ctrlmode & ~priv->ctrlmode_supported;
 }
 
+/* drop skb if it does not contain a valid CAN frame for sending */
+static inline bool can_dev_dropped_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	struct can_priv *priv = netdev_priv(dev);
+
+	if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
+		netdev_info_once(dev,
+				 "interface in listen only mode, dropping skb\n");
+		kfree_skb(skb);
+		dev->stats.tx_dropped++;
+		return true;
+	}
+
+	return can_dropped_invalid_skb(dev, skb);
+}
+
 void can_setup(struct net_device *dev);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,


