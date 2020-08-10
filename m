Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1EA240995
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgHJP2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbgHJP2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B6422B47;
        Mon, 10 Aug 2020 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073333;
        bh=H3HKqpd3odOpb8fgpYafotF4FlN0h5GwSYjdXkHyT6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfePzitmYniMe8N3U7uu+zeU/K4qRrlESaHXbMHudFh+9gLPDt1KfjiHvi0fiM0bj
         uu9bqEMP8JUNNQcjFM8M+69119dj5QY3ZFhttAIxYhdKdzJ4OjL7s49wVfRi1bHcYK
         Rag7uTnNqtj/goytOCczmQDAivgszvVLVYA5UtXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 56/67] net: lan78xx: replace bogus endpoint lookup
Date:   Mon, 10 Aug 2020 17:21:43 +0200
Message-Id: <20200810151812.264070554@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ea060b352654a8de1e070140d25fe1b7e4d50310 ]

Drop the bogus endpoint-lookup helper which could end up accepting
interfaces based on endpoints belonging to unrelated altsettings.

Note that the returned bulk pipes and interrupt endpoint descriptor
were never actually used. Instead the bulk-endpoint numbers are
hardcoded to 1 and 2 (matching the specification), while the interrupt-
endpoint descriptor was assumed to be the third descriptor created by
USB core.

Try to bring some order to this by dropping the bogus lookup helper and
adding the missing endpoint sanity checks while keeping the interrupt-
descriptor assumption for now.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |  117 +++++++++++-----------------------------------
 1 file changed, 30 insertions(+), 87 deletions(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -377,10 +377,6 @@ struct lan78xx_net {
 	struct tasklet_struct	bh;
 	struct delayed_work	wq;
 
-	struct usb_host_endpoint *ep_blkin;
-	struct usb_host_endpoint *ep_blkout;
-	struct usb_host_endpoint *ep_intr;
-
 	int			msg_enable;
 
 	struct urb		*urb_intr;
@@ -2868,78 +2864,12 @@ lan78xx_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static int
-lan78xx_get_endpoints(struct lan78xx_net *dev, struct usb_interface *intf)
-{
-	int tmp;
-	struct usb_host_interface *alt = NULL;
-	struct usb_host_endpoint *in = NULL, *out = NULL;
-	struct usb_host_endpoint *status = NULL;
-
-	for (tmp = 0; tmp < intf->num_altsetting; tmp++) {
-		unsigned ep;
-
-		in = NULL;
-		out = NULL;
-		status = NULL;
-		alt = intf->altsetting + tmp;
-
-		for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
-			struct usb_host_endpoint *e;
-			int intr = 0;
-
-			e = alt->endpoint + ep;
-			switch (e->desc.bmAttributes) {
-			case USB_ENDPOINT_XFER_INT:
-				if (!usb_endpoint_dir_in(&e->desc))
-					continue;
-				intr = 1;
-				/* FALLTHROUGH */
-			case USB_ENDPOINT_XFER_BULK:
-				break;
-			default:
-				continue;
-			}
-			if (usb_endpoint_dir_in(&e->desc)) {
-				if (!intr && !in)
-					in = e;
-				else if (intr && !status)
-					status = e;
-			} else {
-				if (!out)
-					out = e;
-			}
-		}
-		if (in && out)
-			break;
-	}
-	if (!alt || !in || !out)
-		return -EINVAL;
-
-	dev->pipe_in = usb_rcvbulkpipe(dev->udev,
-				       in->desc.bEndpointAddress &
-				       USB_ENDPOINT_NUMBER_MASK);
-	dev->pipe_out = usb_sndbulkpipe(dev->udev,
-					out->desc.bEndpointAddress &
-					USB_ENDPOINT_NUMBER_MASK);
-	dev->ep_intr = status;
-
-	return 0;
-}
-
 static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 {
 	struct lan78xx_priv *pdata = NULL;
 	int ret;
 	int i;
 
-	ret = lan78xx_get_endpoints(dev, intf);
-	if (ret) {
-		netdev_warn(dev->net, "lan78xx_get_endpoints failed: %d\n",
-			    ret);
-		return ret;
-	}
-
 	dev->data[0] = (unsigned long)kzalloc(sizeof(*pdata), GFP_KERNEL);
 
 	pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -3708,6 +3638,7 @@ static void lan78xx_stat_monitor(struct
 static int lan78xx_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
+	struct usb_host_endpoint *ep_blkin, *ep_blkout, *ep_intr;
 	struct lan78xx_net *dev;
 	struct net_device *netdev;
 	struct usb_device *udev;
@@ -3756,6 +3687,34 @@ static int lan78xx_probe(struct usb_inte
 
 	mutex_init(&dev->stats.access_lock);
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
+	ep_blkin = usb_pipe_endpoint(udev, dev->pipe_in);
+	if (!ep_blkin || !usb_endpoint_is_bulk_in(&ep_blkin->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
+	ep_blkout = usb_pipe_endpoint(udev, dev->pipe_out);
+	if (!ep_blkout || !usb_endpoint_is_bulk_out(&ep_blkout->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	ep_intr = &intf->cur_altsetting->endpoint[2];
+	if (!usb_endpoint_is_int_in(&ep_intr->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_intr = usb_rcvintpipe(dev->udev,
+					usb_endpoint_num(&ep_intr->desc));
+
 	ret = lan78xx_bind(dev, intf);
 	if (ret < 0)
 		goto out2;
@@ -3767,23 +3726,7 @@ static int lan78xx_probe(struct usb_inte
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
-	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
-		ret = -ENODEV;
-		goto out3;
-	}
-
-	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
-	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
-	dev->ep_intr = (intf->cur_altsetting)->endpoint + 2;
-
-	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
-	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
-
-	dev->pipe_intr = usb_rcvintpipe(dev->udev,
-					dev->ep_intr->desc.bEndpointAddress &
-					USB_ENDPOINT_NUMBER_MASK);
-	period = dev->ep_intr->desc.bInterval;
-
+	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr, 0);
 	buf = kmalloc(maxp, GFP_KERNEL);
 	if (buf) {


