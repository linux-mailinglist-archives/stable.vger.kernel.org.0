Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D737944C6E6
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhKJSqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhKJSqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345C261178;
        Wed, 10 Nov 2021 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569827;
        bh=oFKwCQFb63dsIhIomre8j/FdVdpATOETvtTkP3uHTB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/sMC4+oociwGvYnvKE9JNTQ+RT2m8Sb5cdAsvQqQ+i1UWOm3lJVhu6jCFr0C6H5g
         WlAIABendK3iNoZHP3LIO3JMZAYPIoKGYFoNpXNZgY1XcADLfydx0JHcR6paG7g0nu
         X7RxvJv23qs7zUDZtvJ8z3E0B7u6pclOjOl7ykCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheah Kok Cheong <thrust73@gmail.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.4 13/19] staging: comedi: drivers: replace le16_to_cpu() with usb_endpoint_maxp()
Date:   Wed, 10 Nov 2021 19:43:15 +0100
Message-Id: <20211110182001.689336223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheah Kok Cheong <thrust73@gmail.com>

commit 62190d498c1d1cee970176840f24822fc14d27d1 upstream.

Use macro introduced in commit 939f325f4a0f
("usb: add usb_endpoint_maxp() macro")

Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt9812.c     |    4 ++--
 drivers/staging/comedi/drivers/ni_usb6501.c |    4 ++--
 drivers/staging/comedi/drivers/vmk80xx.c    |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -717,12 +717,12 @@ static int dt9812_find_endpoints(struct
 		case 1:
 			dir = USB_DIR_OUT;
 			devpriv->cmd_wr.addr = ep->bEndpointAddress;
-			devpriv->cmd_wr.size = le16_to_cpu(ep->wMaxPacketSize);
+			devpriv->cmd_wr.size = usb_endpoint_maxp(ep);
 			break;
 		case 2:
 			dir = USB_DIR_IN;
 			devpriv->cmd_rd.addr = ep->bEndpointAddress;
-			devpriv->cmd_rd.size = le16_to_cpu(ep->wMaxPacketSize);
+			devpriv->cmd_rd.size = usb_endpoint_maxp(ep);
 			break;
 		case 3:
 			/* unused write stream */
--- a/drivers/staging/comedi/drivers/ni_usb6501.c
+++ b/drivers/staging/comedi/drivers/ni_usb6501.c
@@ -469,12 +469,12 @@ static int ni6501_alloc_usb_buffers(stru
 	struct ni6501_private *devpriv = dev->private;
 	size_t size;
 
-	size = le16_to_cpu(devpriv->ep_rx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_rx);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_tx);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -177,7 +177,7 @@ static void vmk80xx_do_bulk_msg(struct c
 	 * The max packet size attributes of the K8061
 	 * input/output endpoints are identical
 	 */
-	size = le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_tx);
 
 	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
 		     size, NULL, devpriv->ep_tx->bInterval);
@@ -199,7 +199,7 @@ static int vmk80xx_read_packet(struct co
 	ep = devpriv->ep_rx;
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
-				 le16_to_cpu(ep->wMaxPacketSize), NULL,
+				 usb_endpoint_maxp(ep), NULL,
 				 HZ * 10);
 }
 
@@ -220,7 +220,7 @@ static int vmk80xx_write_packet(struct c
 	ep = devpriv->ep_tx;
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
-				 le16_to_cpu(ep->wMaxPacketSize), NULL,
+				 usb_endpoint_maxp(ep), NULL,
 				 HZ * 10);
 }
 
@@ -230,7 +230,7 @@ static int vmk80xx_reset_device(struct c
 	size_t size;
 	int retval;
 
-	size = le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_tx);
 	memset(devpriv->usb_tx_buf, 0, size);
 	retval = vmk80xx_write_packet(dev, VMK8055_CMD_RST);
 	if (retval)
@@ -687,12 +687,12 @@ static int vmk80xx_alloc_usb_buffers(str
 	struct vmk80xx_private *devpriv = dev->private;
 	size_t size;
 
-	size = le16_to_cpu(devpriv->ep_rx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_rx);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
+	size = usb_endpoint_maxp(devpriv->ep_tx);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;


