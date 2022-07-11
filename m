Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1686556FB41
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiGKJ13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiGKJ05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE13CBCD;
        Mon, 11 Jul 2022 02:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CE361226;
        Mon, 11 Jul 2022 09:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0255C34115;
        Mon, 11 Jul 2022 09:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530933;
        bh=h767cPWK/Kt31VwAfBA7A8Ipg4z0NEJbLUloznUSy0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctNR4FrM202FkqyIQt0j869LKNWO8cH/9BjccU0kDT3sFnvZssTyMcdMFiEyf3+OQ
         3/VOsED3zZ0riV7GNwWNXaz4gOjuDs8RKdSHO2+FMxEslA948qUyz+ICOJuKZW0IoE
         ER1yAzTSAiDqVUx7wBeYYtorPUWguVRjwtD1ZiVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rhett Aultman <rhett.aultman@samsara.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 007/112] can: gs_usb: gs_usb_open/close(): fix memory leak
Date:   Mon, 11 Jul 2022 11:06:07 +0200
Message-Id: <20220711090549.760440897@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rhett Aultman <rhett.aultman@samsara.com>

commit 2bda24ef95c0311ab93bda00db40486acf30bd0a upstream.

The gs_usb driver appears to suffer from a malady common to many USB
CAN adapter drivers in that it performs usb_alloc_coherent() to
allocate a number of USB request blocks (URBs) for RX, and then later
relies on usb_kill_anchored_urbs() to free them, but this doesn't
actually free them. As a result, this may be leaking DMA memory that's
been used by the driver.

This commit is an adaptation of the techniques found in the esd_usb2
driver where a similar design pattern led to a memory leak. It
explicitly frees the RX URBs and their DMA memory via a call to
usb_free_coherent(). Since the RX URBs were allocated in the
gs_can_open(), we remove them in gs_can_close() rather than in the
disconnect function as was done in esd_usb2.

For more information, see the 928150fad41b ("can: esd_usb2: fix memory
leak").

Link: https://lore.kernel.org/all/alpine.DEB.2.22.394.2206031547001.1630869@thelappy
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Signed-off-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -268,6 +268,8 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
+	void *rxbuf[GS_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -742,6 +744,7 @@ static int gs_can_open(struct net_device
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
+			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -752,7 +755,7 @@ static int gs_can_open(struct net_device
 			buf = usb_alloc_coherent(dev->udev,
 						 dev->parent->hf_size_rx,
 						 GFP_KERNEL,
-						 &urb->transfer_dma);
+						 &buf_dma);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -760,6 +763,8 @@ static int gs_can_open(struct net_device
 				return -ENOMEM;
 			}
 
+			urb->transfer_dma = buf_dma;
+
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -781,10 +786,17 @@ static int gs_can_open(struct net_device
 					   "usb_submit failed (err=%d)\n", rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_coherent(dev->udev,
+						  sizeof(struct gs_host_frame),
+						  buf,
+						  buf_dma);
 				usb_free_urb(urb);
 				break;
 			}
 
+			dev->rxbuf[i] = buf;
+			dev->rxbuf_dma[i] = buf_dma;
+
 			/* Drop reference,
 			 * USB core will take care of freeing it
 			 */
@@ -842,13 +854,20 @@ static int gs_can_close(struct net_devic
 	int rc;
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
+	unsigned int i;
 
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
 	parent->active_channels--;
-	if (!parent->active_channels)
+	if (!parent->active_channels) {
 		usb_kill_anchored_urbs(&parent->rx_submitted);
+		for (i = 0; i < GS_MAX_RX_URBS; i++)
+			usb_free_coherent(dev->udev,
+					  sizeof(struct gs_host_frame),
+					  dev->rxbuf[i],
+					  dev->rxbuf_dma[i]);
+	}
 
 	/* Stop sending URBs */
 	usb_kill_anchored_urbs(&dev->tx_submitted);


