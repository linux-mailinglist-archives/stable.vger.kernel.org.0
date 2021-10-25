Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A5B4395BF
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhJYMOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhJYMOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A844760FDA;
        Mon, 25 Oct 2021 12:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163935;
        bh=v30rtrxj73SBSsaMh1xs42dYppy3X1ftgTu3Cs0j0nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHwJpntodlhDh6K1X4S9eoXw/h86PKhrqpxVd1VYfttyeCkY2ACH1il2Ch9wcctIF
         oMnGqjtlXYkSXXDhgGebrPrKINXOWnj178ic5BdI+5l25PSbwN2UyHlA61xQLFRyP2
         F84M8P+u1tBhlMzttLt//sfGvWFitxSb13YuGY0CzHnu4PigKgT8zZN/iFVbYuG/GO
         0u+wX5YzmAYbTFcwQmbwNhEQMZHZQjWQ0dK2fBg+j1Lox5qcFdAX5/GKnJvnJVKR2V
         yz3sq/hH+DXWgHvfcK4b74b/9W1Gmhf7RwHMwiv2DcHlowXFXh1f6/cXx4iLN7b22D
         h+T7nZLvmzfyQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meypa-0001iJ-Fi; Mon, 25 Oct 2021 14:11:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.com>
Cc:     Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] sound: line6: fix control and interrupt message timeouts
Date:   Mon, 25 Oct 2021 14:11:42 +0200
Message-Id: <20211025121142.6531-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121142.6531-1-johan@kernel.org>
References: <20211025121142.6531-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control and interrupt message timeouts are specified in milliseconds
and should specifically not vary with CONFIG_HZ.

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 sound/usb/line6/driver.c   | 14 +++++++-------
 sound/usb/line6/driver.h   |  2 +-
 sound/usb/line6/podhd.c    |  6 +++---
 sound/usb/line6/toneport.c |  2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 9602929b7de9..59faa5a9a714 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -113,12 +113,12 @@ int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
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
@@ -347,7 +347,7 @@ int line6_read_data(struct usb_line6 *line6, unsigned address, void *data,
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 				   (datalen << 8) | 0x21, address, NULL, 0,
-				   LINE6_TIMEOUT * HZ, GFP_KERNEL);
+				   LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
 		goto exit;
@@ -360,7 +360,7 @@ int line6_read_data(struct usb_line6 *line6, unsigned address, void *data,
 		ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					   0x0012, 0x0000, &len, 1,
-					   LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					   LINE6_TIMEOUT, GFP_KERNEL);
 		if (ret) {
 			dev_err(line6->ifcdev,
 				"receive length failed (error %d)\n", ret);
@@ -387,7 +387,7 @@ int line6_read_data(struct usb_line6 *line6, unsigned address, void *data,
 	/* receive the result: */
 	ret = usb_control_msg_recv(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				   0x0013, 0x0000, data, datalen, LINE6_TIMEOUT * HZ,
+				   0x0013, 0x0000, data, datalen, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 	if (ret)
 		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
@@ -417,7 +417,7 @@ int line6_write_data(struct usb_line6 *line6, unsigned address, void *data,
 
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				   0x0022, address, data, datalen, LINE6_TIMEOUT * HZ,
+				   0x0022, address, data, datalen, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 	if (ret) {
 		dev_err(line6->ifcdev,
@@ -430,7 +430,7 @@ int line6_write_data(struct usb_line6 *line6, unsigned address, void *data,
 
 		ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-					   0x0012, 0x0000, status, 1, LINE6_TIMEOUT * HZ,
+					   0x0012, 0x0000, status, 1, LINE6_TIMEOUT,
 					   GFP_KERNEL);
 		if (ret) {
 			dev_err(line6->ifcdev,
diff --git a/sound/usb/line6/driver.h b/sound/usb/line6/driver.h
index 71d3da1db8c8..ecf3a2b39c7e 100644
--- a/sound/usb/line6/driver.h
+++ b/sound/usb/line6/driver.h
@@ -27,7 +27,7 @@
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
 
-#define LINE6_TIMEOUT 1
+#define LINE6_TIMEOUT 1000
 #define LINE6_BUFSIZE_LISTEN 64
 #define LINE6_MIDI_MESSAGE_MAXLEN 256
 
diff --git a/sound/usb/line6/podhd.c b/sound/usb/line6/podhd.c
index 28794a35949d..b24bc82f89e3 100644
--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -190,7 +190,7 @@ static int podhd_dev_start(struct usb_line6_podhd *pod)
 	ret = usb_control_msg_send(usbdev, 0,
 					0x67, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 					0x11, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					NULL, 0, LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(pod->line6.ifcdev, "read request failed (error %d)\n", ret);
 		goto exit;
@@ -200,7 +200,7 @@ static int podhd_dev_start(struct usb_line6_podhd *pod)
 	ret = usb_control_msg_recv(usbdev, 0, 0x67,
 					USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					0x11, 0x0,
-					init_bytes, 3, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					init_bytes, 3, LINE6_TIMEOUT, GFP_KERNEL);
 	if (ret) {
 		dev_err(pod->line6.ifcdev,
 			"receive length failed (error %d)\n", ret);
@@ -220,7 +220,7 @@ static int podhd_dev_start(struct usb_line6_podhd *pod)
 					USB_REQ_SET_FEATURE,
 					USB_TYPE_STANDARD | USB_RECIP_DEVICE | USB_DIR_OUT,
 					1, 0,
-					NULL, 0, LINE6_TIMEOUT * HZ, GFP_KERNEL);
+					NULL, 0, LINE6_TIMEOUT, GFP_KERNEL);
 exit:
 	return ret;
 }
diff --git a/sound/usb/line6/toneport.c b/sound/usb/line6/toneport.c
index 4e5693c97aa4..e33df58740a9 100644
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -128,7 +128,7 @@ static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2)
 
 	ret = usb_control_msg_send(usbdev, 0, 0x67,
 				   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				   cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ,
+				   cmd1, cmd2, NULL, 0, LINE6_TIMEOUT,
 				   GFP_KERNEL);
 
 	if (ret) {
-- 
2.32.0

