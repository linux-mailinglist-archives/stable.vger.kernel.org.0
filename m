Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B6927305F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgIUREb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbgIUQfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494F8239EE;
        Mon, 21 Sep 2020 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706121;
        bh=DMb4kzrUCoEa9cTJ+IPBP2xmnZmQAPxi/Uv/5ddsf3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BipIKtxtpBDKVhI2ebQMfqkSuiZPnEZnnwavTj2bhrTeBoV6kkwvlr5TOm59TzMWr
         Kpxk4tW1IITWufU0MUzjeGFYmUVcubP230hwViQs3pUVH26FSic2Xj9e9/ovKsO3Ms
         6otcovnIMTxDf7sutdG25vDWalAAtmtAD4ZCQVYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+22794221ab96b0bab53a@syzkaller.appspotmail.com
Subject: [PATCH 4.9 29/70] staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()
Date:   Mon, 21 Sep 2020 18:27:29 +0200
Message-Id: <20200921162036.443962829@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit fea22e159d51c766ba70473f473a0ec914cc7e92 upstream.

let's use usb_find_common_endpoints() to discover endpoints, it does all
necessary checks for type and xfer direction

remove memset() in hfa384x_create(), because we now assign endpoints in
prism2sta_probe_usb() and because create_wlan() uses kzalloc() to
allocate hfa384x struct before calling hfa384x_create()

Fixes: faaff9765664 ("staging: wlan-ng: properly check endpoint types")
Reported-and-tested-by: syzbot+22794221ab96b0bab53a@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=22794221ab96b0bab53a
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200804145614.104320-1-rkovhaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/hfa384x_usb.c |    5 -----
 drivers/staging/wlan-ng/prism2usb.c   |   19 ++++++-------------
 2 files changed, 6 insertions(+), 18 deletions(-)

--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -523,13 +523,8 @@ static void hfa384x_usb_defer(struct wor
 ----------------------------------------------------------------*/
 void hfa384x_create(struct hfa384x *hw, struct usb_device *usb)
 {
-	memset(hw, 0, sizeof(struct hfa384x));
 	hw->usb = usb;
 
-	/* set up the endpoints */
-	hw->endp_in = usb_rcvbulkpipe(usb, 1);
-	hw->endp_out = usb_sndbulkpipe(usb, 2);
-
 	/* Set up the waitq */
 	init_waitqueue_head(&hw->cmdq);
 
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -60,23 +60,14 @@ static int prism2sta_probe_usb(struct us
 			       const struct usb_device_id *id)
 {
 	struct usb_device *dev;
-	const struct usb_endpoint_descriptor *epd;
-	const struct usb_host_interface *iface_desc = interface->cur_altsetting;
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
+	struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct wlandevice *wlandev = NULL;
 	struct hfa384x *hw = NULL;
 	int result = 0;
 
-	if (iface_desc->desc.bNumEndpoints != 2) {
-		result = -ENODEV;
-		goto failed;
-	}
-
-	result = -EINVAL;
-	epd = &iface_desc->endpoint[1].desc;
-	if (!usb_endpoint_is_bulk_in(epd))
-		goto failed;
-	epd = &iface_desc->endpoint[2].desc;
-	if (!usb_endpoint_is_bulk_out(epd))
+	result = usb_find_common_endpoints(iface_desc, &bulk_in, &bulk_out, NULL, NULL);
+	if (result)
 		goto failed;
 
 	dev = interface_to_usbdev(interface);
@@ -95,6 +86,8 @@ static int prism2sta_probe_usb(struct us
 	}
 
 	/* Initialize the hw data */
+	hw->endp_in = usb_rcvbulkpipe(dev, bulk_in->bEndpointAddress);
+	hw->endp_out = usb_sndbulkpipe(dev, bulk_out->bEndpointAddress);
 	hfa384x_create(hw, dev);
 	hw->wlandev = wlandev;
 


