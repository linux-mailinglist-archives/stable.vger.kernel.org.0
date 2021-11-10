Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901EC44C824
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhKJS7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:59:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbhKJS5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41F9361A0A;
        Wed, 10 Nov 2021 18:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570232;
        bh=EFeGSi+t4elHiHlXsTvSj+4LdGGPogYYXjiBQjCg7uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rp3hQQgyxbi84zsXhUBx5kXZyGIQvDznKi/03+UvkPy0HBO1pB6kGoRy0MZqQJhA/
         yGPeun+Tx7NQQerYrdZ2Sj4QUKznaf/jsHzeuXV8VaOlYiwxkQPn3TLIk3J/3UbKx5
         Uky/u8Xa2zZl92O2Q9dHIKu2aLBdz8jDC1aOU6LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 20/26] comedi: vmk80xx: fix bulk-buffer overflow
Date:   Wed, 10 Nov 2021 19:44:19 +0100
Message-Id: <20211110182004.334095450@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 78cdfd62bd54af615fba9e3ca1ba35de39d3871d upstream.

The driver is using endpoint-sized buffers but must not assume that the
tx and rx buffers are of equal size or a malicious device could overflow
the slab-allocated receive buffer when doing bulk transfers.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Cc: stable@vger.kernel.org      # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20211025114532.4599-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/vmk80xx.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -159,22 +159,20 @@ static void vmk80xx_do_bulk_msg(struct c
 	__u8 rx_addr;
 	unsigned int tx_pipe;
 	unsigned int rx_pipe;
-	size_t size;
+	size_t tx_size;
+	size_t rx_size;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
 	tx_pipe = usb_sndbulkpipe(usb, tx_addr);
 	rx_pipe = usb_rcvbulkpipe(usb, rx_addr);
-
-	/*
-	 * The max packet size attributes of the K8061
-	 * input/output endpoints are identical
-	 */
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
+	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
 	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
-		     size, NULL, devpriv->ep_tx->bInterval);
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, size, NULL, HZ * 10);
+		     tx_size, NULL, devpriv->ep_tx->bInterval);
+
+	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL, HZ * 10);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)


