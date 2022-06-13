Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A42548AAC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385557AbiFMOrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385861AbiFMOqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520B4BE14D;
        Mon, 13 Jun 2022 04:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6033D61486;
        Mon, 13 Jun 2022 11:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73055C3411B;
        Mon, 13 Jun 2022 11:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121118;
        bh=pbz9DlEqA5TwTXAkZWWpEn6u8/MCy1hJFPIoVEmfs4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBTwz/YYO1b1XuX2wKbKBEbMa51dxiZS8kz0wUm7x0Q/X41LqpqLkYnwvT8l3+WMW
         usKzPcMVD2aQPq5kGk5zaGFad2jog+C/mMbSo8vEZoXSIaQyS4P0qVZ5XEk8HKHPQ6
         J8nW8RPct4Xs8BgC03GiF9b7FYlIjtEJ7H13JDeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.17 279/298] Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag
Date:   Mon, 13 Jun 2022 12:12:53 +0200
Message-Id: <20220613094933.542822063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit c42e65664390be7c1ef3838cd84956d3a2739d60 upstream.

The bcm5974 driver does the allocation and dma mapping of the usb urb
data buffer, but driver does not set the URB_NO_TRANSFER_DMA_MAP flag
to let usb core know the buffer is already mapped.

usb core tries to map the already mapped buffer, causing a warning:
"xhci_hcd 0000:00:14.0: rejecting DMA map of vmalloc memory"

Fix this by setting the URB_NO_TRANSFER_DMA_MAP, letting usb core
know buffer is already mapped by bcm5974 driver

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215890
Link: https://lore.kernel.org/r/20220606113636.588955-1-mathias.nyman@linux.intel.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/bcm5974.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -942,17 +942,22 @@ static int bcm5974_probe(struct usb_inte
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
-	if (dev->bt_urb)
+	if (dev->bt_urb) {
 		usb_fill_int_urb(dev->bt_urb, udev,
 				 usb_rcvintpipe(udev, cfg->bt_ep),
 				 dev->bt_data, dev->cfg.bt_datalen,
 				 bcm5974_irq_button, dev, 1);
 
+		dev->bt_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	}
+
 	usb_fill_int_urb(dev->tp_urb, udev,
 			 usb_rcvintpipe(udev, cfg->tp_ep),
 			 dev->tp_data, dev->cfg.tp_datalen,
 			 bcm5974_irq_trackpad, dev, 1);
 
+	dev->tp_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));


