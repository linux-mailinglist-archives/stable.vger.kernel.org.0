Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5E45BF3E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbhKXM4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346809AbhKXMyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:54:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5900D61185;
        Wed, 24 Nov 2021 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757075;
        bh=Q/IxYcRohARTpULwWeWNJWhVfpUBk3oYJubfh6YI+lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGG0zg4yPjYmNYK9q7INNYObHiGfpnmbDKpEqylErcguspnSRhNnYthhQsXPXJ5jv
         kjKwoXyYZRDj6Pr0d70uP7MxxlL45M64MXfSIKsm8VOSYKL/hMh71MaGUx4cEnJKtK
         QCo22KsjCC/Ahm03uclVJy+wl7WncxLY4N/YAWU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 018/323] ALSA: line6: fix control and interrupt message timeouts
Date:   Wed, 24 Nov 2021 12:53:28 +0100
Message-Id: <20211124115719.460299911@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit f4000b58b64344871d7b27c05e73932f137cfef6 upstream.

USB control and interrupt message timeouts are specified in milliseconds
and should specifically not vary with CONFIG_HZ.

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025121142.6531-3-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/driver.c   |   14 +++++++-------
 sound/usb/line6/driver.h   |    2 +-
 sound/usb/line6/podhd.c    |    6 +++---
 sound/usb/line6/toneport.c |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -117,12 +117,12 @@ static int line6_send_raw_message(struct
 			retval = usb_interrupt_msg(line6->usbdev,
 						usb_sndintpipe(line6->usbdev, properties->ep_ctrl_w),
 						(char *)frag_buf, frag_size,
-						&partial, LINE6_TIMEOUT * HZ);
+						&partial, LINE6_TIMEOUT);
 		} else {
 			retval = usb_bulk_msg(line6->usbdev,
 						usb_sndbulkpipe(line6->usbdev, properties->ep_ctrl_w),
 						(char *)frag_buf, frag_size,
-						&partial, LINE6_TIMEOUT * HZ);
+						&partial, LINE6_TIMEOUT);
 		}
 
 		if (retval) {
@@ -365,7 +365,7 @@ int line6_read_data(struct usb_line6 *li
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			      (datalen << 8) | 0x21, address,
-			      NULL, 0, LINE6_TIMEOUT * HZ);
+			      NULL, 0, LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
@@ -380,7 +380,7 @@ int line6_read_data(struct usb_line6 *li
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
 				      0x0012, 0x0000, len, 1,
-				      LINE6_TIMEOUT * HZ);
+				      LINE6_TIMEOUT);
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
 				"receive length failed (error %d)\n", ret);
@@ -408,7 +408,7 @@ int line6_read_data(struct usb_line6 *li
 	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			      0x0013, 0x0000, data, datalen,
-			      LINE6_TIMEOUT * HZ);
+			      LINE6_TIMEOUT);
 
 	if (ret < 0)
 		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
@@ -440,7 +440,7 @@ int line6_write_data(struct usb_line6 *l
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			      0x0022, address, data, datalen,
-			      LINE6_TIMEOUT * HZ);
+			      LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(line6->ifcdev,
@@ -456,7 +456,7 @@ int line6_write_data(struct usb_line6 *l
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
 				      0x0012, 0x0000,
-				      status, 1, LINE6_TIMEOUT * HZ);
+				      status, 1, LINE6_TIMEOUT);
 
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
--- a/sound/usb/line6/driver.h
+++ b/sound/usb/line6/driver.h
@@ -31,7 +31,7 @@
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
 
-#define LINE6_TIMEOUT 1
+#define LINE6_TIMEOUT 1000
 #define LINE6_BUFSIZE_LISTEN 64
 #define LINE6_MIDI_MESSAGE_MAXLEN 256
 
--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -236,7 +236,7 @@ static int podhd_dev_start(struct usb_li
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
 					0x67, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 					0x11, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ);
+					NULL, 0, LINE6_TIMEOUT);
 	if (ret < 0) {
 		dev_err(pod->line6.ifcdev, "read request failed (error %d)\n", ret);
 		goto exit;
@@ -246,7 +246,7 @@ static int podhd_dev_start(struct usb_li
 	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 					USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					0x11, 0x0,
-					init_bytes, 3, LINE6_TIMEOUT * HZ);
+					init_bytes, 3, LINE6_TIMEOUT);
 	if (ret < 0) {
 		dev_err(pod->line6.ifcdev,
 			"receive length failed (error %d)\n", ret);
@@ -266,7 +266,7 @@ static int podhd_dev_start(struct usb_li
 					USB_REQ_SET_FEATURE,
 					USB_TYPE_STANDARD | USB_RECIP_DEVICE | USB_DIR_OUT,
 					1, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ);
+					NULL, 0, LINE6_TIMEOUT);
 exit:
 	kfree(init_bytes);
 	return ret;
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -130,7 +130,7 @@ static int toneport_send_cmd(struct usb_
 
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ);
+			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(&usbdev->dev, "send failed (error %d)\n", ret);


