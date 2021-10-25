Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DFB439530
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhJYLss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhJYLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 703AA61002;
        Mon, 25 Oct 2021 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162381;
        bh=EYRg6Kk1mOFdtTobWnLjNW8brE5BqDoSMG07X32ZNmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfzqmfEuaTAZi5ldwr++kvuDXSTMf8ZaIGfKw5/ZbRvIARpI7w8JodPhynhi3W8bh
         PT24iFl2RdjIVoWoLURbnVG/5wFlNqrFdFIbWG3zjm6kdLZpIjEQHlYNEkxTtwR4nf
         PfYN6rlR+ALjCHxIn4JmgQjGAiUtjaajgmP1eePG9dffPmOz84IyVnoguLXUHPy9vx
         alpI3GAijwWfj9m/Onlmq/u52toYRyavqiEqMQDlLjaXaW2BBLf9dChXJ1w2hPcbv/
         /SQaWMnwpkxv7hAzceyUF1OGPlsq3hPooxbDS/3JPZbx1KswUlqLoVxwTli/ZUkZNl
         DPIC26KZMnI3A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyQW-0001DP-Gi; Mon, 25 Oct 2021 13:46:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 5/5] comedi: vmk80xx: fix bulk and interrupt message timeouts
Date:   Mon, 25 Oct 2021 13:45:32 +0200
Message-Id: <20211025114532.4599-6-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025114532.4599-1-johan@kernel.org>
References: <20211025114532.4599-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/comedi/drivers/vmk80xx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index 9c56918e3b76..4b00a9ea611a 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -91,6 +91,7 @@ enum {
 #define IC6_VERSION		BIT(1)
 
 #define MIN_BUF_SIZE		64
+#define PACKET_TIMEOUT		10000	/* ms */
 
 enum vmk80xx_model {
 	VMK8055_MODEL,
@@ -169,10 +170,11 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
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
@@ -191,7 +193,7 @@ static int vmk80xx_read_packet(struct comedi_device *dev)
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
@@ -212,7 +214,7 @@ static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_reset_device(struct comedi_device *dev)
-- 
2.32.0

