Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D80452505
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhKPBq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241576AbhKOSXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469C2632B7;
        Mon, 15 Nov 2021 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998813;
        bh=Kdlp775W5TwyS0oje3X5rwpxwRw9mFXv5f0/mum7Uyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUZX+Ed5mASOdD2aeJdDI441BRMuRz9pIJWK1wQrdGWE4YtpEFv1Vr6k/LY1jsrTS
         zUUqc9NfMpFv1Qh6BN8X/F55SkqsgFFysa59A814pgWrfiWEsv10kIC59YCGdSSnzI
         j/TbI+dUbQc92wtjPHvz75jy8Ke6nNj5zrMwiQwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 038/849] ALSA: line6: fix control and interrupt message timeouts
Date:   Mon, 15 Nov 2021 17:52:01 +0100
Message-Id: <20211115165421.294895657@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -113,12 +113,12 @@ int line6_send_raw_message(struct usb_li
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
@@ -347,7 +347,7 @@ int line6_read_data(struct usb_line6 *li
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 				   (datalen << 8) | 0x21, address, NULL, 0,
-				   LINE6_TIMEOUT * HZ, GFP_KERNEL);
+				   LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
 		goto exit;
@@ -360,7 +360,7 @@ int line6_read_data(struct usb_line6 *li
 		ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					   0x0012, 0x0000, &len, 1,
-					   LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					   LINE6_TIMEOUT, GFP_KERNEL);
 		if (ret) {
 			dev_err(line6->ifcdev,
 				"receive length failed (error %d)\n", ret);
@@ -387,7 +387,7 @@ int line6_read_data(struct usb_line6 *li
 	/* receive the result: */
 	ret = usb_control_msg_recv(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				   0x0013, 0x0000, data, datalen, LINE6_TIMEOUT * HZ,
+				   0x0013, 0x0000, data, datalen, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 	if (ret)
 		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
@@ -417,7 +417,7 @@ int line6_write_data(struct usb_line6 *l
 
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				   0x0022, address, data, datalen, LINE6_TIMEOUT * HZ,
+				   0x0022, address, data, datalen, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 	if (ret) {
 		dev_err(line6->ifcdev,
@@ -430,7 +430,7 @@ int line6_write_data(struct usb_line6 *l
 
 		ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-					   0x0012, 0x0000, status, 1, LINE6_TIMEOUT * HZ,
+					   0x0012, 0x0000, status, 1, LINE6_TIMEOUT,
 					   GFP_KERNEL);
 		if (ret) {
 			dev_err(line6->ifcdev,
--- a/sound/usb/line6/driver.h
+++ b/sound/usb/line6/driver.h
@@ -27,7 +27,7 @@
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
 
-#define LINE6_TIMEOUT 1
+#define LINE6_TIMEOUT 1000
 #define LINE6_BUFSIZE_LISTEN 64
 #define LINE6_MIDI_MESSAGE_MAXLEN 256
 
--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -190,7 +190,7 @@ static int podhd_dev_start(struct usb_li
 	ret = usb_control_msg_send(usbdev, 0,
 					0x67, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 					0x11, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					NULL, 0, LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(pod->line6.ifcdev, "read request failed (error %d)\n", ret);
 		goto exit;
@@ -200,7 +200,7 @@ static int podhd_dev_start(struct usb_li
 	ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					0x11, 0x0,
-					init_bytes, 3, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					init_bytes, 3, LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(pod->line6.ifcdev,
 			"receive length failed (error %d)\n", ret);
@@ -220,7 +220,7 @@ static int podhd_dev_start(struct usb_li
 					USB_REQ_SET_FEATURE,
 					USB_TYPE_STANDARD | USB_RECIP_DEVICE | USB_DIR_OUT,
 					1, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					NULL, 0, LINE6_TIMEOUT, GFP_KERNEL);
 exit:
 	return ret;
 }
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -128,7 +128,7 @@ static int toneport_send_cmd(struct usb_
 
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				   cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ,
+				   cmd1, cmd2, NULL, 0, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 
 	if (ret) {


