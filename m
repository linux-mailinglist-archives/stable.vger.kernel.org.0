Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D47B5011DD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345978AbiDNODo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346206AbiDNN4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F865A087;
        Thu, 14 Apr 2022 06:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869A761D9B;
        Thu, 14 Apr 2022 13:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915FEC385A5;
        Thu, 14 Apr 2022 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943951;
        bh=ZSUA3AExL0rM+Fasx1KoHMLHsfv+HTjdNBw1QA93xMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NACiMYmkNgv2zwUWuYJHxSzDgJ1b+DIphUj2RGJ1/Q9JxxOUL4UL7t7vmPvyjM/+l
         sX7JFQHJUcfPrb8eIXHAxVC+i/A4KQJaahcs8GZ4H7E0at8Ys4+rbGGZZqxtHEn33u
         QpdURxVxgILLxUvn2qiK2hHWfZBA8XB5c7+azrEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Subject: [PATCH 5.4 339/475] can: mcba_usb: properly check endpoint type
Date:   Thu, 14 Apr 2022 15:12:04 +0200
Message-Id: <20220414110904.570751493@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 136bed0bfd3bc9c95c88aafff2d22ecb3a919f23 upstream.

Syzbot reported warning in usb_submit_urb() which is caused by wrong
endpoint type. We should check that in endpoint is actually present to
prevent this warning.

Found pipes are now saved to struct mcba_priv and code uses them
directly instead of making pipes in place.

Fail log:

| usb 5-1: BOGUS urb xfer, pipe 3 != type 1
| WARNING: CPU: 1 PID: 49 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
| Modules linked in:
| CPU: 1 PID: 49 Comm: kworker/1:2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
| Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
| Workqueue: usb_hub_wq hub_event
| RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
| ...
| Call Trace:
|  <TASK>
|  mcba_usb_start drivers/net/can/usb/mcba_usb.c:662 [inline]
|  mcba_usb_probe+0x8a3/0xc50 drivers/net/can/usb/mcba_usb.c:858
|  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
|  call_driver_probe drivers/base/dd.c:517 [inline]

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Link: https://lore.kernel.org/all/20220313100903.10868-1-paskripkin@gmail.com
Reported-and-tested-by: syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/mcba_usb.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -33,10 +33,6 @@
 #define MCBA_USB_RX_BUFF_SIZE 64
 #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
 
-/* MCBA endpoint numbers */
-#define MCBA_USB_EP_IN 1
-#define MCBA_USB_EP_OUT 1
-
 /* Microchip command id */
 #define MBCA_CMD_RECEIVE_MESSAGE 0xE3
 #define MBCA_CMD_I_AM_ALIVE_FROM_CAN 0xF5
@@ -84,6 +80,8 @@ struct mcba_priv {
 	atomic_t free_ctx_cnt;
 	void *rxbuf[MCBA_MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
+	int rx_pipe;
+	int tx_pipe;
 };
 
 /* CAN frame */
@@ -272,10 +270,8 @@ static netdev_tx_t mcba_usb_xmit(struct
 
 	memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
 
-	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
-			  MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
-			  ctx);
+	usb_fill_bulk_urb(urb, priv->udev, priv->tx_pipe, buf, MCBA_USB_TX_BUFF_SIZE,
+			  mcba_usb_write_bulk_callback, ctx);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &priv->tx_submitted);
@@ -610,7 +606,7 @@ static void mcba_usb_read_bulk_callback(
 resubmit_urb:
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
+			  priv->rx_pipe,
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
@@ -655,7 +651,7 @@ static int mcba_usb_start(struct mcba_pr
 		urb->transfer_dma = buf_dma;
 
 		usb_fill_bulk_urb(urb, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
+				  priv->rx_pipe,
 				  buf, MCBA_USB_RX_BUFF_SIZE,
 				  mcba_usb_read_bulk_callback, priv);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -809,6 +805,13 @@ static int mcba_usb_probe(struct usb_int
 	struct mcba_priv *priv;
 	int err = -ENOMEM;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *in, *out;
+
+	err = usb_find_common_endpoints(intf->cur_altsetting, &in, &out, NULL, NULL);
+	if (err) {
+		dev_err(&intf->dev, "Can't find endpoints\n");
+		return err;
+	}
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
 	if (!netdev) {
@@ -854,6 +857,9 @@ static int mcba_usb_probe(struct usb_int
 		goto cleanup_free_candev;
 	}
 
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
+
 	devm_can_led_init(netdev);
 
 	/* Start USB dev only if we have successfully registered CAN device */


