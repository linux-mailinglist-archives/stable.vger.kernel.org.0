Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F18144C7C3
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhKJSzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233459AbhKJSxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:53:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD305613D3;
        Wed, 10 Nov 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570102;
        bh=q9aydd/CFdTUD+m0FPc5a7Q3PINsajNfFPjpq+9ald8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XSzBT6ja+OSzcdOSh0xY1PamTKeUfpwPeETIziwWbraD3qoeRJEGu0pmvXt3PzSv
         xdv7YUDcKoQ70HU7KcALpvHrtjvL5DiwCv8Qsdd6nqs1cAyOruZC4xJchCNSEbwkps
         w+KjwgKqhEF5isd/YxWJpDZ+/ZeHCSAF8kxhHJL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 17/21] comedi: vmk80xx: fix bulk and interrupt message timeouts
Date:   Wed, 10 Nov 2021 19:44:03 +0100
Message-Id: <20211110182003.509132581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a56d3e40bda460edf3f8d6aac00ec0b322b4ab83 upstream.

USB bulk and interrupt message timeouts are specified in milliseconds
and should specifically not vary with CONFIG_HZ.

Note that the bulk-out transfer timeout was set to the endpoint
bInterval value, which should be ignored for bulk endpoints and is
typically set to zero. This meant that a failing bulk-out transfer
would never time out.

Assume that the 10 second timeout used for all other transfers is more
than enough also for the bulk-out endpoint.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Fixes: 951348b37738 ("staging: comedi: vmk80xx: wait for URBs to complete")
Cc: stable@vger.kernel.org      # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20211025114532.4599-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -91,6 +91,7 @@ enum {
 #define IC6_VERSION		BIT(1)
 
 #define MIN_BUF_SIZE		64
+#define PACKET_TIMEOUT		10000	/* ms */
 
 enum vmk80xx_model {
 	VMK8055_MODEL,
@@ -169,10 +170,11 @@ static void vmk80xx_do_bulk_msg(struct c
 	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
 	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
-	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
-		     tx_size, NULL, devpriv->ep_tx->bInterval);
+	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
+		     PACKET_TIMEOUT);
 
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL, HZ * 10);
+	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
+		     PACKET_TIMEOUT);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)
@@ -191,7 +193,7 @@ static int vmk80xx_read_packet(struct co
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
@@ -212,7 +214,7 @@ static int vmk80xx_write_packet(struct c
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_reset_device(struct comedi_device *dev)


