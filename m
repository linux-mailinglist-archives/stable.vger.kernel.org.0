Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14A22C9BFE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390185AbgLAJN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390176AbgLAJN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5460D20671;
        Tue,  1 Dec 2020 09:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813995;
        bh=Ug+nf8psji60rPgTea66t45QU13XEV5GyVAri64n7ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXED+QNDhEhGK8HZbsdLzCQvaduHV9Ev51n0Lobk5o+HT64I8A6TBe1v116hhyGAC
         AO/Qh0NLJ6w0xNO4KFFn7cXRtA/QSKQgVS0Lb5PvrOw/vP1fgTY8PCvjbwrP5s+HgD
         qFQ+kXrVG7VSTcQdyoFBaSSCrpUIjfMfimK1VNeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maximilian Schneider <max@schneidersoft.net>,
        Hubert Denkmair <hubert@denkmair.de>,
        Michael Rausch <mr@netadair.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 130/152] can: gs_usb: fix endianess problem with candleLight firmware
Date:   Tue,  1 Dec 2020 09:54:05 +0100
Message-Id: <20201201084728.847459489@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4ba1cb39fce4464151517a37ce0ac0a1a3f580d6 ]

The firmware on the original USB2CAN by Geschwister Schneider Technologie
Entwicklungs- und Vertriebs UG exchanges all data between the host and the
device in host byte order. This is done with the struct
gs_host_config::byte_order member, which is sent first to indicate the desired
byte order.

The widely used open source firmware candleLight doesn't support this feature
and exchanges the data in little endian byte order. This breaks if a device
with candleLight firmware is used on big endianess systems.

To fix this problem, all u32 (but not the struct gs_host_frame::echo_id, which
is a transparent cookie) are converted to __le32.

Cc: Maximilian Schneider <max@schneidersoft.net>
Cc: Hubert Denkmair <hubert@denkmair.de>
Reported-by: Michael Rausch <mr@netadair.de>
Link: https://lore.kernel.org/r/b58aace7-61f3-6df7-c6df-69fee2c66906@netadair.de
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/r/20201120103818.3386964-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 131 +++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index a4b4b742c80c3..0ad13d78815c5 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -63,21 +63,27 @@ enum gs_can_identify_mode {
 };
 
 /* data types passed between host and device */
+
+/* The firmware on the original USB2CAN by Geschwister Schneider
+ * Technologie Entwicklungs- und Vertriebs UG exchanges all data
+ * between the host and the device in host byte order. This is done
+ * with the struct gs_host_config::byte_order member, which is sent
+ * first to indicate the desired byte order.
+ *
+ * The widely used open source firmware candleLight doesn't support
+ * this feature and exchanges the data in little endian byte order.
+ */
 struct gs_host_config {
-	u32 byte_order;
+	__le32 byte_order;
 } __packed;
-/* All data exchanged between host and device is exchanged in host byte order,
- * thanks to the struct gs_host_config byte_order member, which is sent first
- * to indicate the desired byte order.
- */
 
 struct gs_device_config {
 	u8 reserved1;
 	u8 reserved2;
 	u8 reserved3;
 	u8 icount;
-	u32 sw_version;
-	u32 hw_version;
+	__le32 sw_version;
+	__le32 hw_version;
 } __packed;
 
 #define GS_CAN_MODE_NORMAL               0
@@ -87,26 +93,26 @@ struct gs_device_config {
 #define GS_CAN_MODE_ONE_SHOT             BIT(3)
 
 struct gs_device_mode {
-	u32 mode;
-	u32 flags;
+	__le32 mode;
+	__le32 flags;
 } __packed;
 
 struct gs_device_state {
-	u32 state;
-	u32 rxerr;
-	u32 txerr;
+	__le32 state;
+	__le32 rxerr;
+	__le32 txerr;
 } __packed;
 
 struct gs_device_bittiming {
-	u32 prop_seg;
-	u32 phase_seg1;
-	u32 phase_seg2;
-	u32 sjw;
-	u32 brp;
+	__le32 prop_seg;
+	__le32 phase_seg1;
+	__le32 phase_seg2;
+	__le32 sjw;
+	__le32 brp;
 } __packed;
 
 struct gs_identify_mode {
-	u32 mode;
+	__le32 mode;
 } __packed;
 
 #define GS_CAN_FEATURE_LISTEN_ONLY      BIT(0)
@@ -117,23 +123,23 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_IDENTIFY         BIT(5)
 
 struct gs_device_bt_const {
-	u32 feature;
-	u32 fclk_can;
-	u32 tseg1_min;
-	u32 tseg1_max;
-	u32 tseg2_min;
-	u32 tseg2_max;
-	u32 sjw_max;
-	u32 brp_min;
-	u32 brp_max;
-	u32 brp_inc;
+	__le32 feature;
+	__le32 fclk_can;
+	__le32 tseg1_min;
+	__le32 tseg1_max;
+	__le32 tseg2_min;
+	__le32 tseg2_max;
+	__le32 sjw_max;
+	__le32 brp_min;
+	__le32 brp_max;
+	__le32 brp_inc;
 } __packed;
 
 #define GS_CAN_FLAG_OVERFLOW 1
 
 struct gs_host_frame {
 	u32 echo_id;
-	u32 can_id;
+	__le32 can_id;
 
 	u8 can_dlc;
 	u8 channel;
@@ -329,13 +335,13 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		if (!skb)
 			return;
 
-		cf->can_id = hf->can_id;
+		cf->can_id = le32_to_cpu(hf->can_id);
 
 		cf->can_dlc = get_can_dlc(hf->can_dlc);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
-		if (hf->can_id & CAN_ERR_FLAG)
+		if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
 
 		netdev->stats.rx_packets++;
@@ -418,11 +424,11 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 	if (!dbt)
 		return -ENOMEM;
 
-	dbt->prop_seg = bt->prop_seg;
-	dbt->phase_seg1 = bt->phase_seg1;
-	dbt->phase_seg2 = bt->phase_seg2;
-	dbt->sjw = bt->sjw;
-	dbt->brp = bt->brp;
+	dbt->prop_seg = cpu_to_le32(bt->prop_seg);
+	dbt->phase_seg1 = cpu_to_le32(bt->phase_seg1);
+	dbt->phase_seg2 = cpu_to_le32(bt->phase_seg2);
+	dbt->sjw = cpu_to_le32(bt->sjw);
+	dbt->brp = cpu_to_le32(bt->brp);
 
 	/* request bit timings */
 	rc = usb_control_msg(interface_to_usbdev(intf),
@@ -503,7 +509,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	cf = (struct can_frame *)skb->data;
 
-	hf->can_id = cf->can_id;
+	hf->can_id = cpu_to_le32(cf->can_id);
 	hf->can_dlc = cf->can_dlc;
 	memcpy(hf->data, cf->data, cf->can_dlc);
 
@@ -573,6 +579,7 @@ static int gs_can_open(struct net_device *netdev)
 	int rc, i;
 	struct gs_device_mode *dm;
 	u32 ctrlmode;
+	u32 flags = 0;
 
 	rc = open_candev(netdev);
 	if (rc)
@@ -640,24 +647,24 @@ static int gs_can_open(struct net_device *netdev)
 
 	/* flags */
 	ctrlmode = dev->can.ctrlmode;
-	dm->flags = 0;
 
 	if (ctrlmode & CAN_CTRLMODE_LOOPBACK)
-		dm->flags |= GS_CAN_MODE_LOOP_BACK;
+		flags |= GS_CAN_MODE_LOOP_BACK;
 	else if (ctrlmode & CAN_CTRLMODE_LISTENONLY)
-		dm->flags |= GS_CAN_MODE_LISTEN_ONLY;
+		flags |= GS_CAN_MODE_LISTEN_ONLY;
 
 	/* Controller is not allowed to retry TX
 	 * this mode is unavailable on atmels uc3c hardware
 	 */
 	if (ctrlmode & CAN_CTRLMODE_ONE_SHOT)
-		dm->flags |= GS_CAN_MODE_ONE_SHOT;
+		flags |= GS_CAN_MODE_ONE_SHOT;
 
 	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		dm->flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
+		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
 	/* finally start device */
-	dm->mode = GS_CAN_MODE_START;
+	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
+	dm->flags = cpu_to_le32(flags);
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
 			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
 			     GS_USB_BREQ_MODE,
@@ -737,9 +744,9 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 		return -ENOMEM;
 
 	if (do_identify)
-		imode->mode = GS_CAN_IDENTIFY_ON;
+		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_ON);
 	else
-		imode->mode = GS_CAN_IDENTIFY_OFF;
+		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
 			     usb_sndctrlpipe(interface_to_usbdev(dev->iface),
@@ -790,6 +797,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	struct net_device *netdev;
 	int rc;
 	struct gs_device_bt_const *bt_const;
+	u32 feature;
 
 	bt_const = kmalloc(sizeof(*bt_const), GFP_KERNEL);
 	if (!bt_const)
@@ -830,14 +838,14 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* dev settup */
 	strcpy(dev->bt_const.name, "gs_usb");
-	dev->bt_const.tseg1_min = bt_const->tseg1_min;
-	dev->bt_const.tseg1_max = bt_const->tseg1_max;
-	dev->bt_const.tseg2_min = bt_const->tseg2_min;
-	dev->bt_const.tseg2_max = bt_const->tseg2_max;
-	dev->bt_const.sjw_max = bt_const->sjw_max;
-	dev->bt_const.brp_min = bt_const->brp_min;
-	dev->bt_const.brp_max = bt_const->brp_max;
-	dev->bt_const.brp_inc = bt_const->brp_inc;
+	dev->bt_const.tseg1_min = le32_to_cpu(bt_const->tseg1_min);
+	dev->bt_const.tseg1_max = le32_to_cpu(bt_const->tseg1_max);
+	dev->bt_const.tseg2_min = le32_to_cpu(bt_const->tseg2_min);
+	dev->bt_const.tseg2_max = le32_to_cpu(bt_const->tseg2_max);
+	dev->bt_const.sjw_max = le32_to_cpu(bt_const->sjw_max);
+	dev->bt_const.brp_min = le32_to_cpu(bt_const->brp_min);
+	dev->bt_const.brp_max = le32_to_cpu(bt_const->brp_max);
+	dev->bt_const.brp_inc = le32_to_cpu(bt_const->brp_inc);
 
 	dev->udev = interface_to_usbdev(intf);
 	dev->iface = intf;
@@ -854,28 +862,29 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* can settup */
 	dev->can.state = CAN_STATE_STOPPED;
-	dev->can.clock.freq = bt_const->fclk_can;
+	dev->can.clock.freq = le32_to_cpu(bt_const->fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
 	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = 0;
 
-	if (bt_const->feature & GS_CAN_FEATURE_LISTEN_ONLY)
+	feature = le32_to_cpu(bt_const->feature);
+	if (feature & GS_CAN_FEATURE_LISTEN_ONLY)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
 
-	if (bt_const->feature & GS_CAN_FEATURE_LOOP_BACK)
+	if (feature & GS_CAN_FEATURE_LOOP_BACK)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LOOPBACK;
 
-	if (bt_const->feature & GS_CAN_FEATURE_TRIPLE_SAMPLE)
+	if (feature & GS_CAN_FEATURE_TRIPLE_SAMPLE)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 
-	if (bt_const->feature & GS_CAN_FEATURE_ONE_SHOT)
+	if (feature & GS_CAN_FEATURE_ONE_SHOT)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_ONE_SHOT;
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
 
-	if (dconf->sw_version > 1)
-		if (bt_const->feature & GS_CAN_FEATURE_IDENTIFY)
+	if (le32_to_cpu(dconf->sw_version) > 1)
+		if (feature & GS_CAN_FEATURE_IDENTIFY)
 			netdev->ethtool_ops = &gs_usb_ethtool_ops;
 
 	kfree(bt_const);
@@ -910,7 +919,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	if (!hconf)
 		return -ENOMEM;
 
-	hconf->byte_order = 0x0000beef;
+	hconf->byte_order = cpu_to_le32(0x0000beef);
 
 	/* send host config */
 	rc = usb_control_msg(interface_to_usbdev(intf),
-- 
2.27.0



