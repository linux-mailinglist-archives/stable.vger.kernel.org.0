Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6D2F1768
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbhAKOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbhAKNEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA552225AB;
        Mon, 11 Jan 2021 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370226;
        bh=69FRb86U0lkthIViw6BofrHtE23XAqp4RBNfmMOLtTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN2VKFUfgw8sITMQ2KpCFH18BR2e7Zt3O4U1DWwD1MSuL6v4ut/Kghly2m8JqrowV
         /FkLnhSyyjAhk0LZktez/xZGsylf3BvVsM4daPgOZyqmp3aa8GzKziTJ4dJA0GCpE7
         XArmq1JufP7ZF0PRKUIXCuNUMSqB7+0myDlqbie8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 4.9 33/45] usb: gadget: f_uac2: reset wMaxPacketSize
Date:   Mon, 11 Jan 2021 14:01:11 +0100
Message-Id: <20210111130035.253479761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 9389044f27081d6ec77730c36d5bf9a1288bcda2 upstream.

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
 drivers/usb/gadget/function/f_uac2.c |   69 +++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 14 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -766,7 +766,7 @@ static struct usb_endpoint_descriptor fs
 
 	.bEndpointAddress = USB_DIR_OUT,
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1023),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 1,
 };
 
@@ -775,7 +775,7 @@ static struct usb_endpoint_descriptor hs
 	.bDescriptorType = USB_DT_ENDPOINT,
 
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1024),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 4,
 };
 
@@ -843,7 +843,7 @@ static struct usb_endpoint_descriptor fs
 
 	.bEndpointAddress = USB_DIR_IN,
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1023),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 1,
 };
 
@@ -852,7 +852,7 @@ static struct usb_endpoint_descriptor hs
 	.bDescriptorType = USB_DT_ENDPOINT,
 
 	.bmAttributes = USB_ENDPOINT_XFER_ISOC | USB_ENDPOINT_SYNC_ASYNC,
-	.wMaxPacketSize = cpu_to_le16(1024),
+	/* .wMaxPacketSize = DYNAMIC */
 	.bInterval = 4,
 };
 
@@ -963,12 +963,28 @@ free_ep(struct uac2_rtd_params *prm, str
 			"%s:%d Error!\n", __func__, __LINE__);
 }
 
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
@@ -980,10 +996,12 @@ static void set_ep_max_packet_size(const
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
 
 static int
@@ -1082,10 +1100,33 @@ afunc_bind(struct usb_configuration *cfg
 	uac2->c_prm.uac2 = uac2;
 
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
 
 	hs_epout_desc.bEndpointAddress = fs_epout_desc.bEndpointAddress;
 	hs_epin_desc.bEndpointAddress = fs_epin_desc.bEndpointAddress;


