Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976202B664C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgKQNNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgKQNNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:13:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86F024199;
        Tue, 17 Nov 2020 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618815;
        bh=WyukIjimA51JzY7f4wUJz3o2ph6/LMs3AdYr8QoZHgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh+rG7VCw143U7HcxgM1T9YhIITW8l7flMxq70bxO36/4JDXiMp/qTC0AW5q87/q9
         OinaP7KII15AA4rpmgM3Iqd3ReiWwzQPj4zoo/luIiUkWbPYCYL4hu6ktROBYjKNKO
         a0w1CsuLg53AHfrtIkV+Obgo9xYqqLyzpa9aL1pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/85] can: peak_usb: add range checking in decode operations
Date:   Tue, 17 Nov 2020 14:04:46 +0100
Message-Id: <20201117122111.882183800@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a6921dd524fe31d1f460c161d3526a407533b6db ]

These values come from skb->data so Smatch considers them untrusted.  I
believe Smatch is correct but I don't have a way to test this.

The usb_if->dev[] array has 2 elements but the index is in the 0-15
range without checks.  The cfd->len can be up to 255 but the maximum
valid size is CANFD_MAX_DLEN (64) so that could lead to memory
corruption.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200813140604.GA456946@mwanda
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 48 +++++++++++++++++-----
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 773fc15ac3ab6..0d762bdac4f88 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -476,12 +476,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_rx_msg *rm = (struct pucan_rx_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_msg_get_channel(rm)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct canfd_frame *cfd;
 	struct sk_buff *skb;
 	const u16 rx_msg_flags = le16_to_cpu(rm->flags);
 
+	if (pucan_msg_get_channel(rm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_msg_get_channel(rm)];
+	netdev = dev->netdev;
+
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN) {
 		/* CANFD frame case */
 		skb = alloc_canfd_skb(netdev, &cfd);
@@ -528,15 +534,21 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_status_msg *sm = (struct pucan_status_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
 	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
 	enum can_state rx_state, tx_state;
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pucan_stmsg_get_channel(sm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
+	netdev = dev->netdev;
+
 	/* nothing should be sent while in BUS_OFF state */
 	if (dev->can.state == CAN_STATE_BUS_OFF)
 		return 0;
@@ -589,9 +601,14 @@ static int pcan_usb_fd_decode_error(struct pcan_usb_fd_if *usb_if,
 				    struct pucan_msg *rx_msg)
 {
 	struct pucan_error_msg *er = (struct pucan_error_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_ermsg_get_channel(er)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
+	struct peak_usb_device *dev;
+
+	if (pucan_ermsg_get_channel(er) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pucan_ermsg_get_channel(er)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
 
 	/* keep a trace of tx and rx error counters for later use */
 	pdev->bec.txerr = er->tx_err_cnt;
@@ -605,11 +622,17 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
 				      struct pucan_msg *rx_msg)
 {
 	struct pcan_ufd_ovr_msg *ov = (struct pcan_ufd_ovr_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pufd_omsg_get_channel(ov)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pufd_omsg_get_channel(ov) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pufd_omsg_get_channel(ov)];
+	netdev = dev->netdev;
+
 	/* allocate an skb to store the error frame */
 	skb = alloc_can_err_skb(netdev, &cf);
 	if (!skb)
@@ -727,6 +750,9 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 	u16 tx_msg_size, tx_msg_flags;
 	u8 can_dlc;
 
+	if (cfd->len > CANFD_MAX_DLEN)
+		return -EINVAL;
+
 	tx_msg_size = ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
 	tx_msg->size = cpu_to_le16(tx_msg_size);
 	tx_msg->type = cpu_to_le16(PUCAN_MSG_CAN_TX);
-- 
2.27.0



