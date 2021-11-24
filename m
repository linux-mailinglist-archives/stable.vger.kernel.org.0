Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5884645B995
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbhKXMDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241890AbhKXMDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2006160F90;
        Wed, 24 Nov 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755210;
        bh=ZIMZiOMBU1P4jKF6FqYjr6WoiHgNKZ2L8/ckYM5ti/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XH3LJHvKL/SZgjZ/BQeGxTU/LpbiD5y4pRz+Bn31uULvpvnrIzOWQ9SsW9jSLIIYy
         6lBGASTp5fKIK373o6roC3eYtGsD6mAUbqlQ0gM+9VeId1MaXB6/crbeEzYqO74e3O
         AtLwpzJnKnFuCzXkp7BjN/GvPoO592QnkV+j64+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 013/162] ALSA: line6: fix control and interrupt message timeouts
Date:   Wed, 24 Nov 2021 12:55:16 +0100
Message-Id: <20211124115658.757367371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
 sound/usb/line6/driver.c   |   12 ++++++------
 sound/usb/line6/driver.h   |    2 +-
 sound/usb/line6/toneport.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -101,7 +101,7 @@ static int line6_send_raw_message(struct
 					usb_sndintpipe(line6->usbdev,
 						line6->properties->ep_ctrl_w),
 					(char *)frag_buf, frag_size,
-					&partial, LINE6_TIMEOUT * HZ);
+					&partial, LINE6_TIMEOUT);
 
 		if (retval) {
 			dev_err(line6->ifcdev,
@@ -321,7 +321,7 @@ int line6_read_data(struct usb_line6 *li
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			      (datalen << 8) | 0x21, address,
-			      NULL, 0, LINE6_TIMEOUT * HZ);
+			      NULL, 0, LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
@@ -336,7 +336,7 @@ int line6_read_data(struct usb_line6 *li
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
 				      0x0012, 0x0000, len, 1,
-				      LINE6_TIMEOUT * HZ);
+				      LINE6_TIMEOUT);
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
 				"receive length failed (error %d)\n", ret);
@@ -364,7 +364,7 @@ int line6_read_data(struct usb_line6 *li
 	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			      0x0013, 0x0000, data, datalen,
-			      LINE6_TIMEOUT * HZ);
+			      LINE6_TIMEOUT);
 
 	if (ret < 0)
 		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
@@ -396,7 +396,7 @@ int line6_write_data(struct usb_line6 *l
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			      0x0022, address, data, datalen,
-			      LINE6_TIMEOUT * HZ);
+			      LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(line6->ifcdev,
@@ -412,7 +412,7 @@ int line6_write_data(struct usb_line6 *l
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
 				      0x0012, 0x0000,
-				      status, 1, LINE6_TIMEOUT * HZ);
+				      status, 1, LINE6_TIMEOUT);
 
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
--- a/sound/usb/line6/driver.h
+++ b/sound/usb/line6/driver.h
@@ -24,7 +24,7 @@
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
 
-#define LINE6_TIMEOUT 1
+#define LINE6_TIMEOUT 1000
 #define LINE6_BUFSIZE_LISTEN 32
 #define LINE6_MESSAGE_MAXLEN 256
 
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -133,7 +133,7 @@ static int toneport_send_cmd(struct usb_
 
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ);
+			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT);
 
 	if (ret < 0) {
 		dev_err(&usbdev->dev, "send failed (error %d)\n", ret);


