Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BB2E40B3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408100AbgL1Ozu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408080AbgL1Ozu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:55:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0FB223E8;
        Mon, 28 Dec 2020 14:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609167309;
        bh=e+p16+ueJNC1uIzXC+7yN5BK/Yyq7zoVm3qEd4aRvPM=;
        h=Subject:To:From:Date:From;
        b=PhnIp/KIgRvcCSJPtQdkVRcTV8lIQsDvZ1VSyD3Kqg5qr9CekaCiDnzY7m0Eqa2E6
         J8Q6AOqv1IK5uFAy3NwzylsLBBlpFxfKtom1eryZT32soPpDe/VOucRdjraTTuNB0E
         v8P++hwOPEiQgtOaKGpJrANu3PtHtME7D94UJA/Q=
Subject: patch "usb: gadget: f_uac2: reset wMaxPacketSize" added to usb-linus
To:     jbrunet@baylibre.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:56:31 +0100
Message-ID: <160916739152189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac2: reset wMaxPacketSize

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9389044f27081d6ec77730c36d5bf9a1288bcda2 Mon Sep 17 00:00:00 2001
From: Jerome Brunet <jbrunet@baylibre.com>
Date: Mon, 21 Dec 2020 18:35:28 +0100
Subject: usb: gadget: f_uac2: reset wMaxPacketSize

With commit 913e4a90b6f9 ("usb: gadget: f_uac2: finalize wMaxPacketSize according to bandwidth")
wMaxPacketSize is computed dynamically but the value is never reset.

Because of this, the actual maximum packet size can only decrease each time
the audio gadget is instantiated.

Reset the endpoint maximum packet size and mark wMaxPacketSize as dynamic
to solve the problem.

Fixes: 913e4a90b6f9 ("usb: gadget: f_uac2: finalize wMaxPacketSize according to bandwidth")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201221173531.215169-2-jbrunet@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c | 69 ++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 3633df6d7610..5d960b6603b6 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -271,7 +271,7 @@ static struct usb_endpoint_descriptor fs_epout_desc = {
 
 	.bEndpointAddress = USB_DIR_OUT,
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1023),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 1,
 };
 
@@ -280,7 +280,7 @@ static struct usb_endpoint_descriptor hs_epout_desc = {
 	.bDescriptorType = USB_DT_ENDPOINT,
 
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1024),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 4,
 };
 
@@ -348,7 +348,7 @@ static struct usb_endpoint_descriptor fs_epin_desc = {
 
 	.bEndpointAddress = USB_DIR_IN,
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1023),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 1,
 };
 
@@ -357,7 +357,7 @@ static struct usb_endpoint_descriptor hs_epin_desc = {
 	.bDescriptorType = USB_DT_ENDPOINT,
 
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1024),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 4,
 };
 
@@ -444,12 +444,28 @@ struct cntrl_range_lay3 {
 	__le32	dRES;
 } __packed;
 
-static void set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
+static int set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
 	struct usb_endpoint_descriptor *ep_desc,
-	unsigned int factor, bool is_playback)
+	enum usb_device_speed speed, bool is_playback)
 {
 	int chmask, srate, ssize;
-	u16 max_packet_size;
+	u16 max_size_bw, max_size_ep;
+	unsigned int factor;
+
+	switch (speed) {
+	case USB_SPEED_FULL:
+		max_size_ep = 1023;
+		factor = 1000;
+		break;
+
+	case USB_SPEED_HIGH:
+		max_size_ep = 1024;
+		factor = 8000;
+		break;
+
+	default:
+		return -EINVAL;
+	}
 
 	if (is_playback) {
 		chmask = uac2_opts->p_chmask;
@@ -461,10 +477,12 @@ static void set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
 		ssize = uac2_opts->c_ssize;
 	}
 
-	max_packet_size = num_channels(chmask) * ssize *
+	max_size_bw = num_channels(chmask) * ssize *
 		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
-	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_packet_size,
-				le16_to_cpu(ep_desc->wMaxPacketSize)));
+	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
+						    max_size_ep));
+
+	return 0;
 }
 
 /* Use macro to overcome line length limitation */
@@ -670,10 +688,33 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 	}
 
 	/* Calculate wMaxPacketSize according to audio bandwidth */
-	set_ep_max_packet_size(uac2_opts, &fs_epin_desc, 1000, true);
-	set_ep_max_packet_size(uac2_opts, &fs_epout_desc, 1000, false);
-	set_ep_max_packet_size(uac2_opts, &hs_epin_desc, 8000, true);
-	set_ep_max_packet_size(uac2_opts, &hs_epout_desc, 8000, false);
+	ret = set_ep_max_packet_size(uac2_opts, &fs_epin_desc, USB_SPEED_FULL,
+				     true);
+	if (ret < 0) {
+		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
+		return ret;
+	}
+
+	ret = set_ep_max_packet_size(uac2_opts, &fs_epout_desc, USB_SPEED_FULL,
+				     false);
+	if (ret < 0) {
+		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
+		return ret;
+	}
+
+	ret = set_ep_max_packet_size(uac2_opts, &hs_epin_desc, USB_SPEED_HIGH,
+				     true);
+	if (ret < 0) {
+		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
+		return ret;
+	}
+
+	ret = set_ep_max_packet_size(uac2_opts, &hs_epout_desc, USB_SPEED_HIGH,
+				     false);
+	if (ret < 0) {
+		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
+		return ret;
+	}
 
 	if (EPOUT_EN(uac2_opts)) {
 		agdev->out_ep = usb_ep_autoconfig(gadget, &fs_epout_desc);
-- 
2.29.2


